Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8382E1B87C0
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732556764; cv=none; b=n1r8Y6t/B22XXCfjPu3yU1LhfIvaO8CslJo6tJrXjkziz7feIixxMmW329H50T/3XuUfuhK0YpDE/A9c9Bbfp4wmfpWHWWFo6W3k/FtjPS4VuxxCRmw3oTKTO8RQyC1Qci4Jy5S19GRA+KnNXSNiIokEdNI5fkvcu/Ocq2fwL2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732556764; c=relaxed/simple;
	bh=uhabn9BVG8w1TuYz7WZso6Lr0Z7LCRUTkDJQeuXYs1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1gFHgwGqO0gTaIixgZ2x4lNEvnDK/jwLeZ1OhbhucNukT3lbLYJ+cFPoAx1fuBtWvWxEH2xsAtWSnjjpx2yKVkgPRlReCOrLHCo6PiJTDrlI4weqmMhd1A0e+6TVIvMrGeXGeLKVKo6FwqC1jup4c4c8eONoKMq2ND1Y12aJdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NZSMSS3a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZSMSS3a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732556760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WSVD4y0suTM7CLDu030+A7nb83ADAbUwES7LbzFUnI=;
	b=NZSMSS3au8rIdGuWfVb+4wr3A7frXsTjgPFdGoCcqPGM/xiOEh/78DiOE+Sq8tm1tueeIa
	NBvK1EtMickWN7uMzeMYKyc+m9VyGqv2Glrp3rKGXZXkq2rbN5ia1zjDNIJQcKjmJc0G/m
	RiSwGTtyIaCzaVIJt6sDKam6PCPKua4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-nPvgkAfGPM2PGJftQID1Lg-1; Mon, 25 Nov 2024 12:45:58 -0500
X-MC-Unique: nPvgkAfGPM2PGJftQID1Lg-1
X-Mimecast-MFC-AGG-ID: nPvgkAfGPM2PGJftQID1Lg
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5eb78268680so3518206eaf.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 09:45:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732556758; x=1733161558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WSVD4y0suTM7CLDu030+A7nb83ADAbUwES7LbzFUnI=;
        b=a2NgNhVPolKqKeHkO9Uw07fFGuK7V7dFpO4lRGZxTZwdAn078Qd3m8H0cMvt1sKmag
         nqbEatHWB1bEKx9iUqbJ6njC8yeHiq9vy9k2+FdwfFyxjtAECaPsvdXR54WvZdFATkmU
         NcQjz0aL8x7PBhbJNisSQN+2GE7iZAW0ZqGaQSg+/sl8AjJD1U6V62/+0R5OeHMtSetG
         hiiqNamSyAK2NdI49k+SFfmJEK3qZRHSr9JIzWjUVDIiPkn+vzY45GTqH8Odr7aHJOaF
         rrmFnIK6alj4peOYMEujKGWFDPlzkXn8BYbM55Fkd0WvOO748IuXFTnd/z6O0eyw1d/+
         Py3w==
X-Gm-Message-State: AOJu0YwHMjt3Fd665cPn43p7lDqh0kOQjIrdDrtfJWIKFKMxNWgt5rFf
	H43ySLLkX5Te82VsmcxaSpewIWalXK3PZOMVbZQsAN91SDBASIKgLzTWhexg5fF0TFq5nNwmMS1
	JLxGVGMDaBZ1XduS5v58fIGY6Taf9x61amUl+3sy6FJJiSXTtIEF3Ycd5Zz3io4vR9f907Zdjsz
	QrcRI+k/uLIpIeAeGmCIfijKFxAH9uC5Jqe9u4
X-Gm-Gg: ASbGncsiH2Hxs9vBJTFK6H0OG4BdKFN56sNLN5XSjutD7DQEzEbnCMpbfI2zxwengvz
	laviqY0/XyoWz/HG2Gx+uT2+9iBy3Y5A=
X-Received: by 2002:a05:6820:2081:b0:5e1:e65d:5148 with SMTP id 006d021491bc7-5f06a9f66famr11652724eaf.6.1732556757964;
        Mon, 25 Nov 2024 09:45:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzXuqy0fVspoLL8NU5lRk2wqffHqrtaLwT5+DkHgjBKy7VZnoowFt58EnxYjzgmXtO3DQapsU1SeqXgPswod0=
X-Received: by 2002:a05:6820:2081:b0:5e1:e65d:5148 with SMTP id
 006d021491bc7-5f06a9f66famr11652702eaf.6.1732556757639; Mon, 25 Nov 2024
 09:45:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAASaF6yrdR6qyS38hwh+XQ8rjxP21z-o86E9g06mVz4=ck_tOQ@mail.gmail.com>
In-Reply-To: <CAASaF6yrdR6qyS38hwh+XQ8rjxP21z-o86E9g06mVz4=ck_tOQ@mail.gmail.com>
From: Jan Stancek <jstancek@redhat.com>
Date: Mon, 25 Nov 2024 18:45:25 +0100
Message-ID: <CAASaF6wYCo9TbY7nWzu6cS9ou4VXv2P=dROK-Jt8ik5jX-N2EQ@mail.gmail.com>
Subject: Re: [bug] pkcs1(rsa-generic,sha256) sign test and RSA selftest
 failures, possibly related to sig_alg backend changes
To: lukas@wunner.de, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Justin Forbes <jforbes@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 3:52=E2=80=AFPM Jan Stancek <jstancek@redhat.com> w=
rote:
>
> Hi,
>
> We are seeing 2 errors with recent Fedora & ELN kernels that may be
> related to same issue:
> [1] alg: sig: test 1 failed for pkcs1(rsa-generic,sha256): err -38
> [2] Kernel panic - not syncing: Certs RSA selftest:
> pkcs7_validate_trust() =3D -126
>
> Last known good kernel was commit 158f238aa69d, commit fcc79e1714e8 is
> exhibiting the problem. Builds (and configs) can be found on Fedora
> koji: https://koji.fedoraproject.org/koji/packageinfo?packageID=3D8
>
> I did try to run this alg test manually from a dummy module, and while
> it worked on older kernels as:
>   int ret =3D alg_test("pkcs1pad(rsa-generic,sha256)",
> "pkcs1pad(rsa,sha256)", CRYPTO_ALG_INSTANCE|CRYPTO_ALG_TYPE_SIG,
> CRYPTO_ALG_TESTED);
>
> this now doesn't work (HEAD at commit 0393dda270e3):
>   int ret =3D alg_test("pkcs1(rsa-generic,sha256)", "pkcs1(rsa,sha256)",
> CRYPTO_ALG_INSTANCE|CRYPTO_ALG_TYPE_SIG, CRYPTO_ALG_TESTED);
>
> I'll continue with bisect, unless someone can spot the problem sooner.

Please disregard as this appears to be specific issue to Fedora.
Apologies for noise.

>
> Thanks,
> Jan
>
> [1][2]
> [    2.039909] registered taskstats version 1
> [    2.041881] Loading compiled-in X.509 certificates
> [    2.044931] Loaded X.509 cert 'Red Hat Enterprise Linux kernel
> signing key: d02591e7d874078d39c0a63aa29d0f3481a45682'
> [    2.048828] alg: sig: sign test failed: err -38
> [    2.050391] alg: sig: test 1 failed for pkcs1(rsa-generic,sha256): err=
 -38
> [    2.052618] alg: self-tests for pkcs1(rsa,sha256) using
> pkcs1(rsa-generic,sha256) failed (rc=3D-38)
> [    2.052624] ------------[ cut here ]------------
> [    2.057056] alg: self-tests for pkcs1(rsa,sha256) using
> pkcs1(rsa-generic,sha256) failed (rc=3D-38)
> [    2.057083] WARNING: CPU: 0 PID: 113 at crypto/testmgr.c:6048
> alg_test.cold+0xb7/0xe0
> [    2.062500] Modules linked in:
> [    2.063598] CPU: 0 UID: 0 PID: 113 Comm: cryptomgr_test Not tainted
> 6.12.0-8.test.eln.x86_64 #1
> [    2.066405] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2=
014
> [    2.068579] RIP: 0010:alg_test.cold+0xb7/0xe0
> [    2.070047] Code: c7 c7 c0 54 89 95 e8 52 b4 fe ff 41 83 fe fe 0f
> 84 3d 53 81 ff 44 89 f1 48 89 ea 4c 89 e6 48 c7 c7 f8 54 89 95 e8 93
> 42 2e ff <0f> 0b e9 21 53 81 ff 48 c7 c1 a6 6c 93 95 4c 89 e2 48 89 ee
> 48 c7
> [    2.075865] RSP: 0000:ffffab19004cfdf8 EFLAGS: 00010286
> [    2.077577] RAX: 0000000000000000 RBX: 00000000000000b5 RCX: 00000000f=
fff7fff
> [    2.079864] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 000000000=
0000001
> [    2.082156] RBP: ffff902b417e9800 R08: 0000000000000000 R09: ffffffff9=
63e2aa8
> [    2.084431] R10: ffffffff96322a68 R11: 0000000000000003 R12: ffff902b4=
17e9880
> [    2.086694] R13: 00000000000000af R14: 00000000ffffffda R15: 00000000f=
fffffff
> [    2.088983] FS:  0000000000000000(0000) GS:ffff902e6a800000(0000)
> knlGS:0000000000000000
> [    2.091601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.093460] CR2: ffff902d0f401000 CR3: 00000002cde22001 CR4: 000000000=
0370ef0
> [    2.095734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [    2.098017] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [    2.100280] Call Trace:
> [    2.101197]  <TASK>
> [    2.102026]  ? show_trace_log_lvl+0x1b0/0x2f0
> [    2.103487]  ? show_trace_log_lvl+0x1b0/0x2f0
> [    2.104966]  ? cryptomgr_test+0x24/0x40
> [    2.106282]  ? alg_test.cold+0xb7/0xe0
> [    2.107564]  ? __warn.cold+0x93/0xf4
> [    2.108809]  ? alg_test.cold+0xb7/0xe0
> [    2.110091]  ? report_bug+0xff/0x140
> [    2.111330]  ? handle_bug+0x53/0x90
> [    2.112539]  ? exc_invalid_op+0x17/0x70
> [    2.113844]  ? asm_exc_invalid_op+0x1a/0x20
> [    2.115253]  ? alg_test.cold+0xb7/0xe0
> [    2.116534]  ? alg_test.cold+0xb7/0xe0
> [    2.117824]  ? __call_rcu_common.constprop.0+0xa9/0x2f0
> [    2.119528]  ? __schedule+0x265/0x570
> [    2.120811]  ? __pfx_cryptomgr_test+0x10/0x10
> [    2.122270]  cryptomgr_test+0x24/0x40
> [    2.123532]  kthread+0xd2/0x100
> [    2.124643]  ? __pfx_kthread+0x10/0x10
> [    2.125947]  ret_from_fork+0x34/0x50
> [    2.127174]  ? __pfx_kthread+0x10/0x10
> [    2.128464]  ret_from_fork_asm+0x1a/0x30
> [    2.129813]  </TASK>
> [    2.130633] ---[ end trace 0000000000000000 ]---
> [    2.132283] Problem loading in-kernel X.509 certificate (-80)
> [    2.134310] Problem loading in-kernel X.509 certificate (-80)
> [    2.136231] Loaded X.509 cert 'Nvidia GPU OOT signing 001:
> 55e1cef88193e60419f0b0ec379c49f77545acf0'
> [    2.177928] Loaded X.509 cert 'Fedora IMA CA:
> a8a00c31663f853f9c6ff2564872e378af026b28'
> [    2.183693] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    2.185954] Demotion targets for Node 0: null
> [    2.187689] page_owner is disabled
> [    2.189469] Key type .fscrypt registered
> [    2.190849] Key type fscrypt-provisioning registered
> [    2.192642] Key type big_key registered
> [    2.194112] Key type trusted registered
> [    2.217055] Key type encrypted registered
> [    2.218516] Loading compiled-in module X.509 certificates
> [    2.220817] Loaded X.509 cert 'Red Hat Enterprise Linux kernel
> signing key: d02591e7d874078d39c0a63aa29d0f3481a45682'
> [    2.224230] ima: Allocated hash algorithm: sha256
> [    2.284425] ima: No architecture policies found
> [    2.286106] evm: Initialising EVM extended attributes:
> [    2.287807] evm: security.selinux
> [    2.288981] evm: security.SMACK64 (disabled)
> [    2.290418] evm: security.SMACK64EXEC (disabled)
> [    2.291980] evm: security.SMACK64TRANSMUTE (disabled)
> [    2.293646] evm: security.SMACK64MMAP (disabled)
> [    2.295185] evm: security.apparmor (disabled)
> [    2.296657] evm: security.ima
> [    2.297732] evm: security.capability
> [    2.298971] evm: HMAC attrs: 0x1
> [    2.303465] Running certificate verification RSA selftest
> [    2.312640] Problem loading in-kernel X.509 certificate (-80)
> [    2.318523] usb 2-1: New USB device found, idVendor=3D0627,
> idProduct=3D0001, bcdDevice=3D 0.00
> [    2.321349] usb 2-1: New USB device strings: Mfr=3D1, Product=3D3,
> SerialNumber=3D10
> [    2.323821] usb 2-1: Product: QEMU USB Tablet
> [    2.325327] usb 2-1: Manufacturer: QEMU
> [    2.326665] usb 2-1: SerialNumber: 28754-0000:00:05.7-1
> [    2.330363] Kernel panic - not syncing: Certs RSA selftest:
> pkcs7_validate_trust() =3D -126
> [    2.333231] CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Tainted: G
> W         -------  ---  6.12.0-8.test.eln.x86_64 #1
> [    2.336670] Tainted: [W]=3DWARN
> [    2.337729] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2=
014
> [    2.339918] Call Trace:
> [    2.340826]  <TASK>
> [    2.341632]  dump_stack_lvl+0x4e/0x70
> [    2.343196]  panic+0x113/0x2dd
> [    2.344290]  fips_signature_selftest+0x12a/0x148
> [    2.345917]  ? __pfx_fips_signature_selftest_init+0x10/0x10
> [    2.347744]  fips_signature_selftest_rsa+0x3a/0x40
> [    2.349321]  fips_signature_selftest_init+0xe/0x20
> [    2.351058]  do_one_initcall+0x5b/0x300
> [    2.352439]  do_initcalls+0xdf/0x100
> [    2.353691]  ? __pfx_kernel_init+0x10/0x10
> [    2.355075]  kernel_init_freeable+0x147/0x1a0
> [    2.356540]  kernel_init+0x1a/0x140
> [    2.357753]  ret_from_fork+0x34/0x50
> [    2.359058]  ? __pfx_kernel_init+0x10/0x10
> [    2.360435]  ret_from_fork_asm+0x1a/0x30
> [    2.361762]  </TASK>
> [    2.362730] Kernel Offset: 0x13000000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [    2.366169] ---[ end Kernel panic - not syncing: Certs RSA
> selftest: pkcs7_validate_trust() =3D -126 ]---

