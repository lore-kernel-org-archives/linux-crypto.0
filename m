Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BF8C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 13:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7984161053
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 13:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhKDNOZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 09:14:25 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:39428 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhKDNOZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 09:14:25 -0400
Received: by mail-ua1-f52.google.com with SMTP id i6so10673425uae.6;
        Thu, 04 Nov 2021 06:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+7NH5Idjgn9ApVYVFSqCN4puKLgEB+Ku+KsXDT2oU8=;
        b=YV797P99uXfASCQlNya5VSo7PuM9Q9rrJOOJFRR6yB8CzP/gUUScUJnMGg7L4RLjnF
         8R1VsEUEy+Kt+BMSBtSeILOj0nSBfyXywNSuzYmeUiioOiscmOzCGf7XbCdvtcOWZUgD
         8VckdX9lW/zPRCK8PcvCvQT/XA76M2uiRfMTXZ77a2IUvWufXPuxhTKb9yltjhZsLmxk
         KwjMtJC3maXVUisl/kIuuYmrusxCbfTUy5bANwqJMUYTUi5xKryKPj0pFkFcJXt2MtBv
         8p8lP52q0V4UCqoD+rZhur6uQgZ7NvNl69CPEqeAhh9WNHAG4GkEuWp4325YdBL1Kh0M
         Gp3g==
X-Gm-Message-State: AOAM531baYkmJUIJRgoCf1BBtvq+4IBoViuWbIFidzle3+Raql+m2dev
        OQyMP04zHKZrReadMPlU4IyuaBdjkXOOeA==
X-Google-Smtp-Source: ABdhPJxCJpbuc9oROzhu0VYH8aGbbsBvkyVbZfVwd2XSjqQkVASVgpmOfG+r5k0akoV6yb0aPIh0dA==
X-Received: by 2002:a05:6102:e83:: with SMTP id l3mr43279947vst.7.1636031506637;
        Thu, 04 Nov 2021 06:11:46 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id u17sm821617vsk.25.2021.11.04.06.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 06:11:46 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id q13so10717811uaq.2;
        Thu, 04 Nov 2021 06:11:46 -0700 (PDT)
X-Received: by 2002:a9f:2584:: with SMTP id 4mr56157206uaf.114.1636031505720;
 Thu, 04 Nov 2021 06:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210917002619.GA6407@gondor.apana.org.au> <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au> <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au> <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au> <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
 <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com> <20211104121612.GA8044@gondor.apana.org.au>
In-Reply-To: <20211104121612.GA8044@gondor.apana.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Nov 2021 14:11:34 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWAAWWS+TgeN1AajHBS5w9-datMEeXqAN8RjxRd9bX63Q@mail.gmail.com>
Message-ID: <CAMuHMdWAAWWS+TgeN1AajHBS5w9-datMEeXqAN8RjxRd9bX63Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: api - Do not create test larvals if manager is disabled
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Thu, Nov 4, 2021 at 1:16 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Nov 04, 2021 at 08:58:16AM +0100, Geert Uytterhoeven wrote:
> > On Thu, Nov 4, 2021 at 8:29 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> > > On 2021/11/03 0:41, Geert Uytterhoeven wrote:
> >
> > > > Thanks for your patch, which is now commit cad439fc040efe5f
> > > > ("crypto: api - Do not create test larvals if manager is disabled").
> > > >
> > > > I have bisected a failure to mount the root file system on k210 to this
> > > > commit.
> > > >
> > > > Dmesg before/after:
> > > >
> > > >       mmcblk0: mmc0:0000 SA04G 3.68 GiB
> > > >       random: fast init done
> > > >        mmcblk0: p1
> > > >      -EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null). Quota mode: disabled.
> > > >      -VFS: Mounted root (ext4 filesystem) readonly on device 179:1.
> > > >      +EXT4-fs (mmcblk0p1): Cannot load crc32c driver.
> > > >      +VFS: Cannot open root device "mmcblk0p1" or unknown-block(179,1): error -80
> > >
> > > p1 exist as the message 2 lines above shows. And since the mount error is -80
> > > (ELIBBAD), it is really all about crypto. Since the default k210 config compile
> > > everything in-kernel (no modules), it should work. Was crc32c compiled as a
> > > module ? If yes, then the k210 will need to be booted with U-Boot and use a real
> > > initrd, which likely will all end-up in a no memory situation. ext4 in itself
> > > will consume way too much memory...
> >
> > Everything is built-in, including crc32c. It worked fine, until the commit
> > referenced.
>
> Can someone please send me the Kconfig used in this case?

My config is nommu_k210_sdcard_defconfig with the changes below:

diff --git a/arch/riscv/configs/nommu_k210_sdcard_defconfig.orig
b/arch/riscv/configs/nommu_k210_sdcard_defconfig
index 61f887f65419950c..f14ea3803cea5f3d 100644
--- a/arch/riscv/configs/nommu_k210_sdcard_defconfig.orig
+++ b/arch/riscv/configs/nommu_k210_sdcard_defconfig
@@ -1,3 +1,5 @@
+CONFIG_WERROR=y
+CONFIG_LOCALVERSION="-k210"
 # CONFIG_CPU_ISOLATION is not set
 CONFIG_LOG_BUF_SHIFT=13
 CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=12
@@ -21,16 +23,15 @@ CONFIG_EMBEDDED=y
 CONFIG_SLOB=y
 # CONFIG_MMU is not set
 CONFIG_SOC_CANAAN=y
-CONFIG_SOC_CANAAN_K210_DTB_SOURCE="k210_generic"
-CONFIG_MAXPHYSMEM_2GB=y
+CONFIG_SOC_CANAAN_K210_DTB_SOURCE="sipeed_maix_bit"
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_CMDLINE="earlycon console=ttySIF0 rootdelay=2 root=/dev/mmcblk0p1 ro"
 CONFIG_CMDLINE_FORCE=y
 # CONFIG_SECCOMP is not set
 # CONFIG_STACKPROTECTOR is not set
-# CONFIG_GCC_PLUGINS is not set
-# CONFIG_BLK_DEV_BSG is not set
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_EFI_PARTITION is not set
 # CONFIG_MQ_IOSCHED_DEADLINE is not set
 # CONFIG_MQ_IOSCHED_KYBER is not set
 CONFIG_BINFMT_FLAT=y
@@ -39,10 +40,16 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_ALLOW_DEV_COREDUMP is not set
+CONFIG_MTD=y
+# CONFIG_MTD_OF_PARTS is not set
+CONFIG_MTD_SPI_NOR=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_INPUT is not set
+# CONFIG_INPUT_LEDS is not set
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
+# CONFIG_UNIX98_PTYS is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_LDISC_AUTOLOAD is not set
 # CONFIG_HW_RANDOM is not set
@@ -52,7 +59,6 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_HELPER_AUTO is not set
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
-# CONFIG_SPI_MEM is not set
 CONFIG_SPI_DESIGNWARE=y
 CONFIG_SPI_DW_MMIO=y
 # CONFIG_GPIO_CDEV_V1 is not set
@@ -61,6 +67,7 @@ CONFIG_GPIO_SIFIVE=y
 CONFIG_POWER_RESET=y
 CONFIG_POWER_RESET_SYSCON=y
 # CONFIG_HWMON is not set
+# CONFIG_HID is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 # CONFIG_PWRSEQ_EMMC is not set
@@ -72,8 +79,9 @@ CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_USER=y
 # CONFIG_VIRTIO_MENU is not set
 # CONFIG_VHOST_MENU is not set
-# CONFIG_SURFACE_PLATFORMS is not set
-CONFIG_EXT2_FS=y
+# CONFIG_NVMEM is not set
+CONFIG_EXT4_FS=y
+# CONFIG_EXT4_USE_FOR_EXT2 is not set
 # CONFIG_FILE_LOCKING is not set
 # CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY_USER is not set
@@ -82,8 +90,8 @@ CONFIG_LSM="[]"
 CONFIG_PRINTK_TIME=y
 # CONFIG_SYMBOLIC_ERRNAME is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
 # CONFIG_FRAME_POINTER is not set
+CONFIG_VMLINUX_MAP=y
 # CONFIG_DEBUG_MISC is not set
 CONFIG_PANIC_ON_OOPS=y
 # CONFIG_SCHED_DEBUG is not set

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
