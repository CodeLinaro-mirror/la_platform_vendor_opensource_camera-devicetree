ifeq ($(CONFIG_ARCH_SHIKRA), y)
DTBS_TARGETS += shikra-camera.dtbo
CAMERA_KERNEL_ROOT := ${ANDROID_BUILD_TOP}/vendor/qcom/opensource/camera-kernel/camera
CAMERA_KERNEL_INCLUDE := ${CAMERA_KERNEL_ROOT}
KERNEL_INCLUDE := ${ANDROID_BUILD_TOP}/kernel_platform/common/include
SOC_INCLUDE := ${ANDROID_BUILD_TOP}/kernel_platform/soc-repo/include
endif

# Build include flags conditionally
DTC_INCLUDE_FLAGS :=
ifneq (${KERNEL_INCLUDE},)
    DTC_INCLUDE_FLAGS += -I ${KERNEL_INCLUDE}
endif
ifneq (${CAMERA_KERNEL_INCLUDE},)
    DTC_INCLUDE_FLAGS += -I ${CAMERA_KERNEL_INCLUDE}
endif
ifneq (${SOC_INCLUDE},)
    DTC_INCLUDE_FLAGS += -I ${SOC_INCLUDE}
endif

dtbs: $(DTBS_TARGETS)

%.dtbo: %.dtso
	echo "Processing target $@"
	${CC} -undef -x assembler-with-cpp $< ${DTC_INCLUDE_FLAGS} -E -o $*.dts.preprocessed
	${DTC} -O dtb -o $@ $*.dts.preprocessed

clean:
	rm -rf *.dtbo
	rm -rf *.preprocessed
