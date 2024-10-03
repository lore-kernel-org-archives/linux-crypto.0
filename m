Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BBB13B280
	for <linux-crypto@vger.kernel.org>; Thu,  3 Oct 2024 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727970824; cv=none; b=Mz79Edg57l+8NyZD9dtltQbEBl0bj11S/SCEZayjMr4IpT++U6x+reIo6/2lUgJxkwMxOkR6cr4Dx43LDMntOKgIwGvMSL3w7xz3wJnjgXF7CUYwtHG9FJM+p36Gc4jWu3s23Xpslc0Fsbkg7veldW9UySnhfr5ikSKu4CdGLO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727970824; c=relaxed/simple;
	bh=cAFFZt41t7ISRzpEfShwwnBK1JyjTPHoRKZ7EFGxYDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0R+z5tWChUzSkrhUvsEax+SHrGGAfIKntESS0NXSypZn06Ek5iSn21Mi61qEl9PNZ2Uh8re+rdO0Dy2omwfkvifbKUVtac1AQp18Fk/l7ZL+l3GSLxOGiFcqin71sdcLFoQtzhnB/9H221RwglVDRgpk5rQzGdPHS2Ak6l6ars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=hn++T0cP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="hn++T0cP"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37cc4e718ecso876232f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2024 08:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1727970820; x=1728575620; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ASn58+r/8fDXURx9NppfUmubazdMza+XY931VIjG0b8=;
        b=hn++T0cPAI1KAvqypgGrRq60f/bGIQObGOuluuodHaTWw9mUG8+WrJRU00bEtPeYGz
         2CYEVxRFhXCVXWnR5ZZS/HEwmkRQ/+SvE4CLNctBb3Pko0DE5Vz6QYUqC4vF2sx2rl1/
         u1XnsIuoPBcaqchyaB6Bgh0x08Mmd1JH66iJFHDjGbZV93kvF0oYfI/IhU16CizpHuF2
         qrz3+kLLikoXKfv/7iP9MwY/a4D2PfGiHGUGwvvMrSoQCZa5MO+cmrxT49vV3Bf2ETSI
         7fBi/hD1gm1VvO5TnajYWnj3NSuOP97MPvM5jVxBQqvOGC+fDUGPPYMF869+SHFZtidB
         dpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727970820; x=1728575620;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ASn58+r/8fDXURx9NppfUmubazdMza+XY931VIjG0b8=;
        b=B+qYs0XkD4M2xXJQE3NieHrtY+0YEr+23BMLxpLrVyJgr8hWfCa7cZ7J2wuf9psnWZ
         r9Qow0j2+L8n21jHpPy/ZUoEg3StynwSiuEARA79XCpdUrwiCz2PY1nTVFUepkJEkxpa
         CQW59kt3OLCegdEjhkzgvoKKIoegelT85qcrd5G9T9QzswuHAO8CodkJ4w579rqcWfjv
         kIO0hn1xb7P4FnoPsDPeQOIRH7MFthjWShPHTgK952OwhVZuUINw8ynnxSuiofKl86VM
         MjC3BZj3inFvhV8l+evilMgdlEwmGfq93Zr6ToEfK7IwZDzDzh2Nfmo+3jAzsACtCF0G
         kTwA==
X-Forwarded-Encrypted: i=1; AJvYcCVXxgjzD+d27PkKFBgMugNFRCbNdrDKgj6ZVxAXqwWiY7LUpfTOiRDmQN4B9MJGzkDkvEzRP7AVzJmdITA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzeq6NnPbteLmneoRV4lJMK7g85ymOS5+t7GamEVGDpTfXHeiO/
	MeF8sKd6xID6vy/P5blauThax/19XyxND4QYpwBb5vbfsuv0eZG3bz7Q5n8cdGs=
X-Google-Smtp-Source: AGHT+IEjglsEKst00kNEaQrnMTlDmam7zrHREWEMLYXkuCR/dpU0lwFkoVio16P0Wnlv5tWhRZ2i7g==
X-Received: by 2002:a5d:6189:0:b0:374:cbc4:53b1 with SMTP id ffacd0b85a97d-37cfba0a641mr4589247f8f.40.1727970819978;
        Thu, 03 Oct 2024 08:53:39 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d3:3500:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37d08226fecsm1542030f8f.37.2024.10.03.08.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 08:53:39 -0700 (PDT)
Date: Thu, 3 Oct 2024 17:53:33 +0200
From: Corentin LABBE <clabbe@baylibre.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
	naveen@kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	olivia@selenic.com, herbert@gondor.apana.org.au
Subject: Re: BUG: Kernel NULL pointer dereference on read at 0x00000000 in
 pnv_get_random_long()
Message-ID: <Zv69_TmchQCudlcP@Red>
References: <Zv02AMOBJ5a2lrF0@Red>
 <eabd6384-0b3f-4112-92d4-7cae4bc3f61f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eabd6384-0b3f-4112-92d4-7cae4bc3f61f@linux.ibm.com>

Le Thu, Oct 03, 2024 at 11:49:27AM +0530, Madhavan Srinivasan a écrit :
> 
> 
> On 10/2/24 5:31 PM, Corentin LABBE wrote:
> > Hello
> > 
> > I have a 8335-GCA POWER8 which got a kernel crash during boot:
> > [   11.754238] Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
> > [   11.754437] BUG: Kernel NULL pointer dereference on read at 0x00000000
> > [   11.754499] Faulting instruction address: 0xc0000000000c3758
> > [   11.754518] Oops: Kernel access of bad area, sig: 11 [#1]
> > [   11.754534] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
> > [   11.754699] Modules linked in: powernv_rng(+) ecb ctr sr_mod hid ofpart fb_sys_fops cdrom i2c_algo_bit powernv_flash sg mtd vmx_crypto(+) ipmi_powernv ipmi_devintf at24(+) ipmi_msghandler opal_prd regmap_i2c nfsd gf128mul auth_rpcgss nfs_acl lockd grace sunrpc drm fuse configfs loop drm_panel_orientation_quirks ip_tables x_tables autofs4 uas usb_storage ext4 crc16 mbcache jbd2 crc32c_generic dm_mod xhci_pci xhci_hcd sd_mod t10_pi crc64_rocksoft crc64 crc_t10dif crct10dif_generic crct10dif_common usbcore tg3 libphy crc32c_vpmsum ahci usb_common libahci
> > [   11.754869] CPU: 25 PID: 1332 Comm: (udev-worker) Not tainted 6.1.106 #4 
> > [   11.754890] Hardware name: 8335-GCA POWER8 (raw) 0x4d0200 opal:skiboot-5.4.8-5787ad3 PowerNV
> > [   11.754926] NIP:  c0000000000c3758 LR: c0000000000c3754 CTR: 0000000000000000
> > [   11.754947] REGS: c00000000ec3af70 TRAP: 0300   Not tainted  (6.1.106)
> > [   11.754966] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 44222282  XER: 20000000
> > [   11.755168] CFAR: c0000000001dfbb4 DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0 
> >                GPR00: c0000000000c3754 c00000000ec3b210 c00000000113cd00 000000000000002c 
> >                GPR04: 00000000ffff7fff c00000000ec3b010 c00000000ec3b008 0000000ff57e0000 
> >                GPR08: 0000000000000027 c000000ff7907f98 0000000000000001 0000000000002200 
> >                GPR12: 0000000000000000 c000000ffffeaf00 0000000000000020 0000000022000000 
> >                GPR16: 0000000000000000 0000000000000000 0000000000000009 000000013c86f5d8 
> >                GPR20: 0000000000000000 000001002cd75d90 0000000000000000 0000000000000005 
> >                GPR24: 000001002cd794a0 000001002cd75d90 c00000000285e6fc c000000000f9e4a0 
> >                GPR28: 0000000000000003 0000000000000004 0000000000000000 c0000010103ca180 
> > [   11.755363] NIP [c0000000000c3758] pnv_get_random_long+0x88/0x170
> > [   11.755386] LR [c0000000000c3754] pnv_get_random_long+0x84/0x170
> > [   11.755407] Call Trace:
> > [   11.755416] [c00000000ec3b210] [c0000000000c3754] pnv_get_random_long+0x84/0x170 (unreliable)
> > [   11.755444] [c00000000ec3b280] [c008000021c50130] powernv_rng_read+0x98/0x120 [powernv_rng]
> > [   11.755473] [c00000000ec3b300] [c00000000091ac88] add_early_randomness+0x88/0x150
> > [   11.755577] [c00000000ec3b340] [c00000000091b2c4] hwrng_register+0x344/0x420
> > [   11.755678] [c00000000ec3b3a0] [c00000000091b408] devm_hwrng_register+0x68/0xf0
> > [   11.755703] [c00000000ec3b3e0] [c008000021c5003c] powernv_rng_probe+0x34/0x90 [powernv_rng]
> > [   11.755728] [c00000000ec3b450] [c000000000949218] platform_probe+0x78/0x110
> > [   11.755750] [c00000000ec3b4d0] [c0000000009442d8] really_probe+0x108/0x590
> > [   11.755773] [c00000000ec3b560] [c000000000944814] __driver_probe_device+0xb4/0x230
> > [   11.755799] [c00000000ec3b5e0] [c0000000009449e4] driver_probe_device+0x54/0x130
> > [   11.755824] [c00000000ec3b620] [c0000000009456d8] __driver_attach+0x158/0x2b0
> > [   11.755850] [c00000000ec3b6a0] [c000000000940764] bus_for_each_dev+0xb4/0x140
> > [   11.755874] [c00000000ec3b700] [c000000000943734] driver_attach+0x34/0x50
> > [   11.755896] [c00000000ec3b720] [c000000000942d88] bus_add_driver+0x218/0x300
> > [   11.755921] [c00000000ec3b7b0] [c000000000946b84] driver_register+0xb4/0x1c0
> > [   11.755947] [c00000000ec3b820] [c000000000948b98] __platform_driver_register+0x38/0x50
> > [   11.755969] [c00000000ec3b840] [c008000021c501e8] powernv_rng_driver_init+0x30/0x4c [powernv_rng]
> > [   11.755997] [c00000000ec3b860] [c0000000000121b0] do_one_initcall+0x80/0x320
> > [   11.756020] [c00000000ec3b940] [c0000000002198bc] do_init_module+0x6c/0x290
> > [   11.756042] [c00000000ec3b9c0] [c00000000021d118] __do_sys_finit_module+0xd8/0x190
> > [   11.756066] [c00000000ec3baf0] [c00000000002b038] system_call_exception+0x138/0x260
> > [   11.756091] [c00000000ec3be10] [c00000000000c654] system_call_common+0xf4/0x258
> > [   11.756117] --- interrupt: c00 at 0x7fffaae9a9e4
> > [   11.756134] NIP:  00007fffaae9a9e4 LR: 00007fffab110500 CTR: 0000000000000000
> > [   11.756153] REGS: c00000000ec3be80 TRAP: 0c00   Not tainted  (6.1.106)
> > [   11.762944] MSR:  900000000280f033 <SF,HV,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 24222248  XER: 00000000
> > [   11.765251] IRQMASK: 0 
> >                GPR00: 0000000000000161 00007ffff4b57210 00007fffaafa6f00 0000000000000006 
> >                GPR04: 00007fffab11be88 0000000000000000 0000000000000006 0000000000000000 
> >                GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> >                GPR12: 0000000000000000 00007fffab1fe240 0000000000000020 0000000022000000 
> >                GPR16: 0000000000000000 0000000000000000 0000000000000009 000000013c86f5d8 
> >                GPR20: 0000000000000000 000001002cd75d90 0000000000000000 0000000000000005 
> >                GPR24: 000001002cd794a0 000001002cd75d90 0000000022000000 000001002cd32120 
> >                GPR28: 00007fffab11be88 0000000000020000 0000000000000000 000001002cd75d90 
> > [   11.773845] NIP [00007fffaae9a9e4] 0x7fffaae9a9e4
> > [   11.774334] LR [00007fffab110500] 0x7fffab110500
> > [   11.774347] --- interrupt: c00
> > [   11.779698] Instruction dump:
> > [   11.779711] e88952f8 38634198 3bde52f8 4811c439 60000000 e94d0030 3c62ffe4 386341c0 
> > [   11.779739] 7fcaf02a 7fc4f378 4811c41d 60000000 <e93e0000> 7c0004ac e9490000 0c0a0000 
> > [   11.779782] ---[ end trace 0000000000000000 ]---
> > 
> > This happen on stock debian 6.1.0-23-powerpc64le.
> 
> I am not able to recreate this in my setup. 
> Have tried stable 6.1.106, 6.1.100 and also latest upstream with powernv_defconfig.
> Can you share the config file. 
> 

Hello

I used the debian config as base, this is the diff:
diff -u /boot/config-6.1.0-25-powerpc64le .config
--- /boot/config-6.1.0-25-powerpc64le	2024-08-26 21:47:39.000000000 +0200
+++ .config	2024-10-01 20:18:23.579867536 +0200
@@ -2,7 +2,7 @@
 # Automatically generated file; DO NOT EDIT.
 # Linux/powerpc 6.1.106 Kernel Configuration
 #
-CONFIG_CC_VERSION_TEXT="gcc-12 (Debian 12.2.0-14) 12.2.0"
+CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14) 12.2.0"
 CONFIG_CC_IS_GCC=y
 CONFIG_GCC_VERSION=120200
 CONFIG_CLANG_VERSION=0
@@ -18,7 +18,7 @@
 CONFIG_GCC_ASM_GOTO_OUTPUT_WORKAROUND=y
 CONFIG_CC_HAS_ASM_INLINE=y
 CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
-CONFIG_PAHOLE_VERSION=124
+CONFIG_PAHOLE_VERSION=0
 CONFIG_IRQ_WORK=y
 CONFIG_BUILDTIME_TABLE_SORT=y
 CONFIG_THREAD_INFO_IN_TASK=y
@@ -31,6 +31,7 @@
 # CONFIG_WERROR is not set
 CONFIG_LOCALVERSION=""
 # CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_BUILD_SALT=""
 CONFIG_HAVE_KERNEL_GZIP=y
 CONFIG_HAVE_KERNEL_XZ=y
 # CONFIG_KERNEL_GZIP is not set
@@ -8295,6 +8296,7 @@
 # Certificates for signature checking
 #
 CONFIG_SYSTEM_TRUSTED_KEYRING=y
+CONFIG_SYSTEM_TRUSTED_KEYS=""
 # CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
 CONFIG_SECONDARY_TRUSTED_KEYRING=y
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
@@ -8498,8 +8500,6 @@
 # CONFIG_DEBUG_INFO_COMPRESSED is not set
 # CONFIG_DEBUG_INFO_SPLIT is not set
 # CONFIG_DEBUG_INFO_BTF is not set
-CONFIG_PAHOLE_HAS_SPLIT_BTF=y
-CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
 # CONFIG_GDB_SCRIPTS is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_STRIP_ASM_SYMS=y

The resulting config is https://kernel.montjoie.ovh/ppc.config

Regards
