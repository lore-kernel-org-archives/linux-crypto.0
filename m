From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Mon, 8 Jun 2015 15:21:09 +0300
Message-ID: <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Waiman Long <Waiman.Long@hp.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
To: Jim Davis <jim.epost@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:35794 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbFHMVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 08:21:11 -0400
In-Reply-To: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2015 at 10:14 PM, Jim Davis <jim.epost@gmail.com> wrote=
:
> Building with the attached random configuration file,

Hit the very same error against next-20150605.

The issue with that file we have no compiler optimization enabled. So,
guys, how you would recommend to fix it?

By the way, I'm building the x86_64_defconfig with following changes

diff --git a/arch/x86/configs/x86_64_defconfig
b/arch/x86/configs/x86_64_defconfig
index 315b861..363824f 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -172,9 +172,11 @@ CONFIG_TIGON3=3Dy
 CONFIG_NET_TULIP=3Dy
 CONFIG_E100=3Dy
 CONFIG_E1000=3Dy
+CONFIG_E1000E=3Dy
 CONFIG_SKY2=3Dy
 CONFIG_FORCEDETH=3Dy
 CONFIG_8139TOO=3Dy
+CONFIG_R8169=3Dy
 CONFIG_FDDI=3Dy
 CONFIG_INPUT_POLLDEV=3Dy
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
@@ -198,7 +200,7 @@ CONFIG_HW_RANDOM=3Dy
 # CONFIG_HW_RANDOM_INTEL is not set
 # CONFIG_HW_RANDOM_AMD is not set
 CONFIG_NVRAM=3Dy
-CONFIG_HPET=3Dy
+# CONFIG_HPET is not set
 # CONFIG_HPET_MMAP is not set
 CONFIG_I2C_I801=3Dy
 CONFIG_WATCHDOG=3Dy
@@ -206,8 +208,8 @@ CONFIG_AGP=3Dy
 CONFIG_AGP_AMD64=3Dy
 CONFIG_AGP_INTEL=3Dy
 CONFIG_DRM=3Dy
-CONFIG_DRM_I915=3Dy
-CONFIG_DRM_I915_KMS=3Dy
+# CONFIG_DRM_I915 is not set
+CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
 CONFIG_FB_MODE_HELPERS=3Dy
 CONFIG_FB_TILEBLITTING=3Dy
 CONFIG_FB_EFI=3Dy
@@ -224,8 +226,8 @@ CONFIG_SND_MIXER_OSS=3Dy
 CONFIG_SND_PCM_OSS=3Dy
 CONFIG_SND_SEQUENCER_OSS=3Dy
 CONFIG_SND_HRTIMER=3Dy
-CONFIG_SND_HDA_INTEL=3Dy
-CONFIG_SND_HDA_HWDEP=3Dy
+# CONFIG_SND_HDA_INTEL is not set
+# CONFIG_SND_HDA_HWDEP is not set
 CONFIG_HIDRAW=3Dy
 CONFIG_HID_GYRATION=3Dy
 CONFIG_LOGITECH_FF=3Dy
@@ -307,3 +309,56 @@ CONFIG_SECURITY_SELINUX=3Dy
 CONFIG_SECURITY_SELINUX_BOOTPARAM=3Dy
 CONFIG_SECURITY_SELINUX_DISABLE=3Dy
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
+CONFIG_FUNCTION_TRACER=3Dy
+CONFIG_I2C_DESIGNWARE_PCI=3Dy
+CONFIG_I2C_DESIGNWARE_PLATFORM=3Dm
+CONFIG_GPIOLIB=3Dy
+CONFIG_GPIO_INTEL_MID=3Dy
+CONFIG_INTEL_MID_WATCHDOG=3Dy
+CONFIG_NOP_USB_XCEIV=3Dy
+CONFIG_USB_CHIPIDEA=3Dy
+CONFIG_USB_CHIPIDEA_UDC=3Dy
+CONFIG_USB_CHIPIDEA_HOST=3Dy
+CONFIG_X86_EXTENDED_PLATFORM=3Dy
+CONFIG_X86_INTEL_MID=3Dy
+CONFIG_EFI_STUB=3Dy
+CONFIG_EFI_MIXED=3Dy
+CONFIG_EARLY_PRINTK_EFI=3Dy
+CONFIG_FB=3Dy
+CONFIG_FRAMEBUFFER_CONSOLE=3Dy
+CONFIG_DYNAMIC_DEBUG=3Dy
+CONFIG_USB_XHCI_HCD=3Dy
+CONFIG_USB_DWC3=3Dy
+CONFIG_USB_DWC3_GADGET=3Dy
+CONFIG_USB_SERIAL=3Dy
+CONFIG_USB_SERIAL_PL2303=3Dy
+CONFIG_USB_USBNET=3Dy
+CONFIG_USB_NET_AX88179_178A=3Dy
+CONFIG_USB_NET_MCS7830=3Dy
+CONFIG_USB_NET_AX8817X=3Dy
+CONFIG_X86_INTEL_LPSS=3Dy
+CONFIG_PM_RUNTIME=3Dy
+CONFIG_DW_DMAC_CORE=3Dm
+CONFIG_DW_DMAC=3Dm
+CONFIG_DW_DMAC_PCI=3Dm
+CONFIG_DMATEST=3Dm
+CONFIG_SERIAL_8250_DMA=3Dy
+CONFIG_SERIAL_8250_PCI=3Dy
+CONFIG_SERIAL_8250_DW=3Dm
+CONFIG_MMC=3Dm
+CONFIG_MMC_SDHCI=3Dm
+CONFIG_MMC_SDHCI_ACPI=3Dm
+CONFIG_ACPI_DEBUG=3Dy
+CONFIG_ACPI_PROCFS_POWER=3Dy
+CONFIG_DMA_API_DEBUG=3Dy
+CONFIG_DEBUG_LOCKDEP=3Dy
+CONFIG_DEBUG_SHIRQ=3Dy
+CONFIG_PINCTRL=3Dy
+CONFIG_PINCTRL_BAYTRAIL=3Dy
+CONFIG_PWM=3Dy
+CONFIG_PWM_LPSS=3Dm
+CONFIG_PWM_LPSS_PCI=3Dm
+CONFIG_PWM_LPSS_PLATFORM=3Dm
+CONFIG_SPI=3Dy
+CONFIG_SPI_PXA2XX_PCI=3Dm
+CONFIG_SPI_PXA2XX=3Dm


>
> In file included from ./arch/x86/include/asm/spinlock.h:46:0,
>                  from include/linux/spinlock.h:87,
>                  from include/linux/seqlock.h:35,
>                  from include/linux/time.h:5,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from crypto/jitterentropy.c:52:
> In function =E2=80=98native_queued_spin_unlock=E2=80=99,
>     inlined from =E2=80=98queued_spin_unlock=E2=80=99 at ./arch/x86/i=
nclude/asm/qspinlock.h:38:2
> ,
>     inlined from =E2=80=98do_raw_spin_unlock=E2=80=99 at include/linu=
x/spinlock.h:175:2,
>     inlined from =E2=80=98__raw_spin_unlock=E2=80=99 at include/linux=
/spinlock_api_smp.h:153:2,
>     inlined from =E2=80=98spin_unlock=E2=80=99 at include/linux/spinl=
ock.h:357:2,
>     inlined from =E2=80=98jent_kcapi_cleanup=E2=80=99 at crypto/jitte=
rentropy.c:844:2:
> ./arch/x86/include/asm/qspinlock.h:17:317: error: call to
> =E2=80=98__compiletime_assert_17=E2=80=99 declared with attribute err=
or: Need native
> word sized stores/loads for atomicity.
> In function =E2=80=98native_queued_spin_unlock=E2=80=99,
>     inlined from =E2=80=98queued_spin_unlock=E2=80=99 at ./arch/x86/i=
nclude/asm/qspinlock.h:38:2
> ,
>     inlined from =E2=80=98do_raw_spin_unlock=E2=80=99 at include/linu=
x/spinlock.h:175:2,
>     inlined from =E2=80=98__raw_spin_unlock=E2=80=99 at include/linux=
/spinlock_api_smp.h:153:2,
>     inlined from =E2=80=98spin_unlock=E2=80=99 at include/linux/spinl=
ock.h:357:2,
>     inlined from =E2=80=98jent_kcapi_random=E2=80=99 at crypto/jitter=
entropy.c:856:2:
> ./arch/x86/include/asm/qspinlock.h:17:317: error: call to
> =E2=80=98__compiletime_assert_17=E2=80=99 declared with attribute err=
or: Need native
> word sized stores/loads for atomicity.
> scripts/Makefile.build:264: recipe for target 'crypto/jitterentropy.o=
' failed



--=20
With Best Regards,
Andy Shevchenko
