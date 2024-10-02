Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5191F93E
	for <linux-crypto@vger.kernel.org>; Wed,  2 Oct 2024 12:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727870470; cv=none; b=uPqwTqqIbUMflkNKIad1Rvbn4H7LAgaO3S8XK/p773r6cqzQUIWsiLohyPv6JfqtYdMqjjdHdIk4UD4JSMsmfd0rpWG57dyPNe8O/IHmrrzubUgvOloDeBEUnIZGEEQx4/MXa47Ma17V4cIA2p8Q9Dwg0wi0Z3dGw0WxwOdRf4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727870470; c=relaxed/simple;
	bh=Jhe3tLEweCiMYZ2LehMOCt5zrK8MNW/fCdRUGp8zQ2A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Cyvt7jQL2mFv+yAWmx4XUB4OdRg/Wi4QiHahnZeouDR715Zh1d1K3ydvVwcdTq8EAZDVTB1iR7+z5Rrg6oVjOe6tN3U0qtPR4lLq2nleR/L9yPAQlmogT8ii3UTuRsxMYTGQlsldG4o0Dq34zFI+F+kj+D8+I8PklWFnntyVyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=izcwDV1F; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="izcwDV1F"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cacabd2e0so52051445e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2024 05:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1727870467; x=1728475267; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iztEn2bXOGHKqLMz9umpFeOSGqxGMqp9GCEQezWIfnc=;
        b=izcwDV1FtnYym2xu6xjPzMBZ6TNuvNtgrVv3X9V+Pkk+D5SvQQhLDddVF/7goScocE
         wmpAevOjjyDIZcdSc3Im3/yW/sskkkzso/jy8YrGrXfGOr4qMGchDrPIRjp/EE1Ho2mm
         ffK9JtbH0Xp8HM83fdJvXIFbfFfKR6Xz2akctq7my6sspuwJSZ/yY3cUmtYNPayIgnrj
         gv3y/H17T5Fg997CnlrFZz0c4yra8vbCx2knFeCw70iRzP8e6FaXDWBU4M2vZbez6rKy
         P7Di10ICCNb4XeA5pkyL1ubvGGVHxOV7LCgYwEcXvZCgg9wuyE4U9Ooq2l/Nv6G/ujTO
         h3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727870467; x=1728475267;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iztEn2bXOGHKqLMz9umpFeOSGqxGMqp9GCEQezWIfnc=;
        b=deU/sjxjF19/v+ljWV08FAJSJkzWwcejIGJZg49iUTpUXbueJtEcDgg48gJCkfZtcN
         O0wNWxr+6aev5ReOybIrN6zq7xYbzbTpeygILyztfyC/ieI3jgKmP0zqbJe3cNApuLKq
         zN3bgApz72A1fqxUJZpgLy6NhJtZq2z5HzYvtGPatFCp+en4bM+xNznT0Z/vGyZpt3vX
         fbEOnJ71Iu7+nETCtGW6koMZZRvFR58iJEWOMUcO8Wm0jhqhln9/qjbHOWq+8Slgq0CI
         dg5muFGPMUf36wjlDmoOeEcVNJAv63tgZsHca7RaREqxpAD8O0mNhh+8X/15//ps4lwa
         Oplg==
X-Forwarded-Encrypted: i=1; AJvYcCXg6f3uh2oV2rfYfD5BBZtu9V2SkmwDaUtHPaEmB4NAr1bITueTzMtYp0jGqdnIzQ5LCXq1LEuOrLHH84U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdQUt2Ov2Fx50qQpLAOPvZr9r7oQWEDRVS+oc9LdVfddsmyM0Y
	9reV5IsuWgffeMLKRBRswjB7T7HhPz2WsrQkGOV6FGYcU+S9NpTyA9vhD/p6K5AcRkGl8IKztyg
	mNkA=
X-Google-Smtp-Source: AGHT+IFqIAIZk1Bx3gWa7LK81D9E5Pbk20XkTAU0YsnnIt8UZsFh/wrxV6rBQkzeroeOKYmBZtcNYg==
X-Received: by 2002:a5d:598c:0:b0:374:c9f0:752d with SMTP id ffacd0b85a97d-37cfba0468cmr1777372f8f.47.1727870466592;
        Wed, 02 Oct 2024 05:01:06 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d3:3500:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37cd57427b9sm13776516f8f.95.2024.10.02.05.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 05:01:06 -0700 (PDT)
Date: Wed, 2 Oct 2024 14:01:04 +0200
From: Corentin LABBE <clabbe@baylibre.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
	naveen@kernel.org, maddy@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, olivia@selenic.com,
	herbert@gondor.apana.org.au
Subject: BUG: Kernel NULL pointer dereference on read at 0x00000000 in
 pnv_get_random_long()
Message-ID: <Zv02AMOBJ5a2lrF0@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

I have a 8335-GCA POWER8 which got a kernel crash during boot:
[   11.754238] Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
[   11.754437] BUG: Kernel NULL pointer dereference on read at 0x00000000
[   11.754499] Faulting instruction address: 0xc0000000000c3758
[   11.754518] Oops: Kernel access of bad area, sig: 11 [#1]
[   11.754534] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
[   11.754699] Modules linked in: powernv_rng(+) ecb ctr sr_mod hid ofpart fb_sys_fops cdrom i2c_algo_bit powernv_flash sg mtd vmx_crypto(+) ipmi_powernv ipmi_devintf at24(+) ipmi_msghandler opal_prd regmap_i2c nfsd gf128mul auth_rpcgss nfs_acl lockd grace sunrpc drm fuse configfs loop drm_panel_orientation_quirks ip_tables x_tables autofs4 uas usb_storage ext4 crc16 mbcache jbd2 crc32c_generic dm_mod xhci_pci xhci_hcd sd_mod t10_pi crc64_rocksoft crc64 crc_t10dif crct10dif_generic crct10dif_common usbcore tg3 libphy crc32c_vpmsum ahci usb_common libahci
[   11.754869] CPU: 25 PID: 1332 Comm: (udev-worker) Not tainted 6.1.106 #4 
[   11.754890] Hardware name: 8335-GCA POWER8 (raw) 0x4d0200 opal:skiboot-5.4.8-5787ad3 PowerNV
[   11.754926] NIP:  c0000000000c3758 LR: c0000000000c3754 CTR: 0000000000000000
[   11.754947] REGS: c00000000ec3af70 TRAP: 0300   Not tainted  (6.1.106)
[   11.754966] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 44222282  XER: 20000000
[   11.755168] CFAR: c0000000001dfbb4 DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0 
               GPR00: c0000000000c3754 c00000000ec3b210 c00000000113cd00 000000000000002c 
               GPR04: 00000000ffff7fff c00000000ec3b010 c00000000ec3b008 0000000ff57e0000 
               GPR08: 0000000000000027 c000000ff7907f98 0000000000000001 0000000000002200 
               GPR12: 0000000000000000 c000000ffffeaf00 0000000000000020 0000000022000000 
               GPR16: 0000000000000000 0000000000000000 0000000000000009 000000013c86f5d8 
               GPR20: 0000000000000000 000001002cd75d90 0000000000000000 0000000000000005 
               GPR24: 000001002cd794a0 000001002cd75d90 c00000000285e6fc c000000000f9e4a0 
               GPR28: 0000000000000003 0000000000000004 0000000000000000 c0000010103ca180 
[   11.755363] NIP [c0000000000c3758] pnv_get_random_long+0x88/0x170
[   11.755386] LR [c0000000000c3754] pnv_get_random_long+0x84/0x170
[   11.755407] Call Trace:
[   11.755416] [c00000000ec3b210] [c0000000000c3754] pnv_get_random_long+0x84/0x170 (unreliable)
[   11.755444] [c00000000ec3b280] [c008000021c50130] powernv_rng_read+0x98/0x120 [powernv_rng]
[   11.755473] [c00000000ec3b300] [c00000000091ac88] add_early_randomness+0x88/0x150
[   11.755577] [c00000000ec3b340] [c00000000091b2c4] hwrng_register+0x344/0x420
[   11.755678] [c00000000ec3b3a0] [c00000000091b408] devm_hwrng_register+0x68/0xf0
[   11.755703] [c00000000ec3b3e0] [c008000021c5003c] powernv_rng_probe+0x34/0x90 [powernv_rng]
[   11.755728] [c00000000ec3b450] [c000000000949218] platform_probe+0x78/0x110
[   11.755750] [c00000000ec3b4d0] [c0000000009442d8] really_probe+0x108/0x590
[   11.755773] [c00000000ec3b560] [c000000000944814] __driver_probe_device+0xb4/0x230
[   11.755799] [c00000000ec3b5e0] [c0000000009449e4] driver_probe_device+0x54/0x130
[   11.755824] [c00000000ec3b620] [c0000000009456d8] __driver_attach+0x158/0x2b0
[   11.755850] [c00000000ec3b6a0] [c000000000940764] bus_for_each_dev+0xb4/0x140
[   11.755874] [c00000000ec3b700] [c000000000943734] driver_attach+0x34/0x50
[   11.755896] [c00000000ec3b720] [c000000000942d88] bus_add_driver+0x218/0x300
[   11.755921] [c00000000ec3b7b0] [c000000000946b84] driver_register+0xb4/0x1c0
[   11.755947] [c00000000ec3b820] [c000000000948b98] __platform_driver_register+0x38/0x50
[   11.755969] [c00000000ec3b840] [c008000021c501e8] powernv_rng_driver_init+0x30/0x4c [powernv_rng]
[   11.755997] [c00000000ec3b860] [c0000000000121b0] do_one_initcall+0x80/0x320
[   11.756020] [c00000000ec3b940] [c0000000002198bc] do_init_module+0x6c/0x290
[   11.756042] [c00000000ec3b9c0] [c00000000021d118] __do_sys_finit_module+0xd8/0x190
[   11.756066] [c00000000ec3baf0] [c00000000002b038] system_call_exception+0x138/0x260
[   11.756091] [c00000000ec3be10] [c00000000000c654] system_call_common+0xf4/0x258
[   11.756117] --- interrupt: c00 at 0x7fffaae9a9e4
[   11.756134] NIP:  00007fffaae9a9e4 LR: 00007fffab110500 CTR: 0000000000000000
[   11.756153] REGS: c00000000ec3be80 TRAP: 0c00   Not tainted  (6.1.106)
[   11.762944] MSR:  900000000280f033 <SF,HV,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 24222248  XER: 00000000
[   11.765251] IRQMASK: 0 
               GPR00: 0000000000000161 00007ffff4b57210 00007fffaafa6f00 0000000000000006 
               GPR04: 00007fffab11be88 0000000000000000 0000000000000006 0000000000000000 
               GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
               GPR12: 0000000000000000 00007fffab1fe240 0000000000000020 0000000022000000 
               GPR16: 0000000000000000 0000000000000000 0000000000000009 000000013c86f5d8 
               GPR20: 0000000000000000 000001002cd75d90 0000000000000000 0000000000000005 
               GPR24: 000001002cd794a0 000001002cd75d90 0000000022000000 000001002cd32120 
               GPR28: 00007fffab11be88 0000000000020000 0000000000000000 000001002cd75d90 
[   11.773845] NIP [00007fffaae9a9e4] 0x7fffaae9a9e4
[   11.774334] LR [00007fffab110500] 0x7fffab110500
[   11.774347] --- interrupt: c00
[   11.779698] Instruction dump:
[   11.779711] e88952f8 38634198 3bde52f8 4811c439 60000000 e94d0030 3c62ffe4 386341c0 
[   11.779739] 7fcaf02a 7fc4f378 4811c41d 60000000 <e93e0000> 7c0004ac e9490000 0c0a0000 
[   11.779782] ---[ end trace 0000000000000000 ]---

This happen on stock debian 6.1.0-23-powerpc64le.

I debugged a bit and the crash happen in arch/powerpc/platforms/powernv/rng.c in pnv_get_random_long()
The call rng = get_cpu_var(pnv_rng) return null and so rng is dereferenced via ->regs just after.

I have no real idea on how to fix properly (appart adding a "!rng return 0" test)

Regards
