Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5741B0F30
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732546400; cv=none; b=QS7SJaitWEu9kfkTSJiiIKBJu55T348+NfgdvOLsbf4j98iiHvWeaRBj/oJEu+sY5jT4hLOmSQxs6DsWhSaKh2ijq5UW7/ZZJE72v5R60QxJPlUX7BUgnjHnvzYqY1JOArOHeyncvZMnWyZx3fbc22oZ/lW4wCZG8KLhWqj3F9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732546400; c=relaxed/simple;
	bh=nBTtz7r3YY8b3rj5Wo/fZoChjzlEVRHzCpwYWDdUS0o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KenIcJwb6fbDGuag+r+ojspXPyzohRMShA/+uNFV7e0mIvIRR9J/WZdbx3Y6WxR1WzuSZc/rUviUDGbfvIray5ydGMjyU4Geeoe0KUJkihF0/w/Lm98xX2xHKFeHgi/zcxU81hNFosMkyFSlnLi3YuWsmnFiP47wQbhmdbRfQ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPDVj8Pg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPDVj8Pg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732546397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ndIuHuv99BQ8GPsKU75647HNsdoqspce8VOoIQukdJw=;
	b=aPDVj8Pg2AIfnHvxe8DZsUDCwV8W9b+sORzfO+RwhZ38SJDTkMxERaSaRtzhhN9Yajn9Jm
	hIcrTVwzg5vDGXgGKnLbKbsdm/RjBQej3NLs4ck130XecVW5GzCCZ6A8R2u80kA3YQSnc7
	tbL/6dooHmYeBrpyCaiqvPT9MsqePg4=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-auSkVrAfNRy0Odmq5pFwwA-1; Mon, 25 Nov 2024 09:53:16 -0500
X-MC-Unique: auSkVrAfNRy0Odmq5pFwwA-1
X-Mimecast-MFC-AGG-ID: auSkVrAfNRy0Odmq5pFwwA
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5ebb90bcb4eso3354137eaf.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 06:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732546395; x=1733151195;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndIuHuv99BQ8GPsKU75647HNsdoqspce8VOoIQukdJw=;
        b=BqcLI+5PHeBz9DAfamQ2bxO5alUeN5krdUjoGJwGDa0ghwTON5wHEI5wiJOWGFCgIj
         h3PosIKLbAiWHbRFeco8kbiVt9m2vPOUakHo/beH1TDuXbn5ymYJCP3kPVJ8NQb5f3H3
         JewGucIF/Cf79ufLZe8+jNgfobLPmdUgmhbme6+LxsylJZh8ZSQwDi9TXirKrXQvAjJQ
         WZhKDqphYACKc+oZpWlyVpqqhSreZSFw1RlJgfr/8xrBqhU7exhfndaHejKKB6sPhx/P
         9xL8QISH47rXJf8+4yiByvoWyjRtRBAosgS/kzm2RWC1bQRMh6I2L5UW/bWi0Y92OY06
         KZWA==
X-Gm-Message-State: AOJu0YyIyZhFtTcDL6S3h5xTEeXHzsiou7KTXbxHM5uDUOylVCo06ISI
	WmgFBweORlJuzdR2pXXDWb8dMRThgnY9XNyTzV3GwAeY0/MIj+oFAdjzUB4Ob5pg+rMfzgaux4A
	cc4bu/rgbAc6FljEdpcJUhS8Q6hnsq3bth93DGRreUs6wE5QxvBA0o5ankyzqOSUabziJFBcX2/
	xlCAmPYmjhg+GKsdEhFQJh3VX5lGusOedE6cAt
X-Gm-Gg: ASbGncujvzseY6C8dmgxufMujWOczGpeoNx9ztI3/J/wMJfs8vUFqoOUAL0OT4rG1FO
	7KThafID39yEu2WojUWL8EduEbnsdqDw=
X-Received: by 2002:a05:6820:2006:b0:5e1:ebf1:816d with SMTP id 006d021491bc7-5f06a9c6d8fmr9925202eaf.4.1732546395672;
        Mon, 25 Nov 2024 06:53:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0vw+s+pDKOUXqyfiUWLKNBtJ1zXsk7g7szhRIrFKHXIEXNKMXtDoxO+QsQNDJNgdtuzlMBgnO27VLRI3uFgs=
X-Received: by 2002:a05:6820:2006:b0:5e1:ebf1:816d with SMTP id
 006d021491bc7-5f06a9c6d8fmr9925184eaf.4.1732546395382; Mon, 25 Nov 2024
 06:53:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jan Stancek <jstancek@redhat.com>
Date: Mon, 25 Nov 2024 15:52:59 +0100
Message-ID: <CAASaF6yrdR6qyS38hwh+XQ8rjxP21z-o86E9g06mVz4=ck_tOQ@mail.gmail.com>
Subject: [bug] pkcs1(rsa-generic,sha256) sign test and RSA selftest failures,
 possibly related to sig_alg backend changes
To: lukas@wunner.de, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Justin Forbes <jforbes@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

We are seeing 2 errors with recent Fedora & ELN kernels that may be
related to same issue:
[1] alg: sig: test 1 failed for pkcs1(rsa-generic,sha256): err -38
[2] Kernel panic - not syncing: Certs RSA selftest:
pkcs7_validate_trust() = -126

Last known good kernel was commit 158f238aa69d, commit fcc79e1714e8 is
exhibiting the problem. Builds (and configs) can be found on Fedora
koji: https://koji.fedoraproject.org/koji/packageinfo?packageID=8

I did try to run this alg test manually from a dummy module, and while
it worked on older kernels as:
  int ret = alg_test("pkcs1pad(rsa-generic,sha256)",
"pkcs1pad(rsa,sha256)", CRYPTO_ALG_INSTANCE|CRYPTO_ALG_TYPE_SIG,
CRYPTO_ALG_TESTED);

this now doesn't work (HEAD at commit 0393dda270e3):
  int ret = alg_test("pkcs1(rsa-generic,sha256)", "pkcs1(rsa,sha256)",
CRYPTO_ALG_INSTANCE|CRYPTO_ALG_TYPE_SIG, CRYPTO_ALG_TESTED);

I'll continue with bisect, unless someone can spot the problem sooner.

Thanks,
Jan

[1][2]
[    2.039909] registered taskstats version 1
[    2.041881] Loading compiled-in X.509 certificates
[    2.044931] Loaded X.509 cert 'Red Hat Enterprise Linux kernel
signing key: d02591e7d874078d39c0a63aa29d0f3481a45682'
[    2.048828] alg: sig: sign test failed: err -38
[    2.050391] alg: sig: test 1 failed for pkcs1(rsa-generic,sha256): err -38
[    2.052618] alg: self-tests for pkcs1(rsa,sha256) using
pkcs1(rsa-generic,sha256) failed (rc=-38)
[    2.052624] ------------[ cut here ]------------
[    2.057056] alg: self-tests for pkcs1(rsa,sha256) using
pkcs1(rsa-generic,sha256) failed (rc=-38)
[    2.057083] WARNING: CPU: 0 PID: 113 at crypto/testmgr.c:6048
alg_test.cold+0xb7/0xe0
[    2.062500] Modules linked in:
[    2.063598] CPU: 0 UID: 0 PID: 113 Comm: cryptomgr_test Not tainted
6.12.0-8.test.eln.x86_64 #1
[    2.066405] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2014
[    2.068579] RIP: 0010:alg_test.cold+0xb7/0xe0
[    2.070047] Code: c7 c7 c0 54 89 95 e8 52 b4 fe ff 41 83 fe fe 0f
84 3d 53 81 ff 44 89 f1 48 89 ea 4c 89 e6 48 c7 c7 f8 54 89 95 e8 93
42 2e ff <0f> 0b e9 21 53 81 ff 48 c7 c1 a6 6c 93 95 4c 89 e2 48 89 ee
48 c7
[    2.075865] RSP: 0000:ffffab19004cfdf8 EFLAGS: 00010286
[    2.077577] RAX: 0000000000000000 RBX: 00000000000000b5 RCX: 00000000ffff7fff
[    2.079864] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000001
[    2.082156] RBP: ffff902b417e9800 R08: 0000000000000000 R09: ffffffff963e2aa8
[    2.084431] R10: ffffffff96322a68 R11: 0000000000000003 R12: ffff902b417e9880
[    2.086694] R13: 00000000000000af R14: 00000000ffffffda R15: 00000000ffffffff
[    2.088983] FS:  0000000000000000(0000) GS:ffff902e6a800000(0000)
knlGS:0000000000000000
[    2.091601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.093460] CR2: ffff902d0f401000 CR3: 00000002cde22001 CR4: 0000000000370ef0
[    2.095734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.098017] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    2.100280] Call Trace:
[    2.101197]  <TASK>
[    2.102026]  ? show_trace_log_lvl+0x1b0/0x2f0
[    2.103487]  ? show_trace_log_lvl+0x1b0/0x2f0
[    2.104966]  ? cryptomgr_test+0x24/0x40
[    2.106282]  ? alg_test.cold+0xb7/0xe0
[    2.107564]  ? __warn.cold+0x93/0xf4
[    2.108809]  ? alg_test.cold+0xb7/0xe0
[    2.110091]  ? report_bug+0xff/0x140
[    2.111330]  ? handle_bug+0x53/0x90
[    2.112539]  ? exc_invalid_op+0x17/0x70
[    2.113844]  ? asm_exc_invalid_op+0x1a/0x20
[    2.115253]  ? alg_test.cold+0xb7/0xe0
[    2.116534]  ? alg_test.cold+0xb7/0xe0
[    2.117824]  ? __call_rcu_common.constprop.0+0xa9/0x2f0
[    2.119528]  ? __schedule+0x265/0x570
[    2.120811]  ? __pfx_cryptomgr_test+0x10/0x10
[    2.122270]  cryptomgr_test+0x24/0x40
[    2.123532]  kthread+0xd2/0x100
[    2.124643]  ? __pfx_kthread+0x10/0x10
[    2.125947]  ret_from_fork+0x34/0x50
[    2.127174]  ? __pfx_kthread+0x10/0x10
[    2.128464]  ret_from_fork_asm+0x1a/0x30
[    2.129813]  </TASK>
[    2.130633] ---[ end trace 0000000000000000 ]---
[    2.132283] Problem loading in-kernel X.509 certificate (-80)
[    2.134310] Problem loading in-kernel X.509 certificate (-80)
[    2.136231] Loaded X.509 cert 'Nvidia GPU OOT signing 001:
55e1cef88193e60419f0b0ec379c49f77545acf0'
[    2.177928] Loaded X.509 cert 'Fedora IMA CA:
a8a00c31663f853f9c6ff2564872e378af026b28'
[    2.183693] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.185954] Demotion targets for Node 0: null
[    2.187689] page_owner is disabled
[    2.189469] Key type .fscrypt registered
[    2.190849] Key type fscrypt-provisioning registered
[    2.192642] Key type big_key registered
[    2.194112] Key type trusted registered
[    2.217055] Key type encrypted registered
[    2.218516] Loading compiled-in module X.509 certificates
[    2.220817] Loaded X.509 cert 'Red Hat Enterprise Linux kernel
signing key: d02591e7d874078d39c0a63aa29d0f3481a45682'
[    2.224230] ima: Allocated hash algorithm: sha256
[    2.284425] ima: No architecture policies found
[    2.286106] evm: Initialising EVM extended attributes:
[    2.287807] evm: security.selinux
[    2.288981] evm: security.SMACK64 (disabled)
[    2.290418] evm: security.SMACK64EXEC (disabled)
[    2.291980] evm: security.SMACK64TRANSMUTE (disabled)
[    2.293646] evm: security.SMACK64MMAP (disabled)
[    2.295185] evm: security.apparmor (disabled)
[    2.296657] evm: security.ima
[    2.297732] evm: security.capability
[    2.298971] evm: HMAC attrs: 0x1
[    2.303465] Running certificate verification RSA selftest
[    2.312640] Problem loading in-kernel X.509 certificate (-80)
[    2.318523] usb 2-1: New USB device found, idVendor=0627,
idProduct=0001, bcdDevice= 0.00
[    2.321349] usb 2-1: New USB device strings: Mfr=1, Product=3,
SerialNumber=10
[    2.323821] usb 2-1: Product: QEMU USB Tablet
[    2.325327] usb 2-1: Manufacturer: QEMU
[    2.326665] usb 2-1: SerialNumber: 28754-0000:00:05.7-1
[    2.330363] Kernel panic - not syncing: Certs RSA selftest:
pkcs7_validate_trust() = -126
[    2.333231] CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Tainted: G
W         -------  ---  6.12.0-8.test.eln.x86_64 #1
[    2.336670] Tainted: [W]=WARN
[    2.337729] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2014
[    2.339918] Call Trace:
[    2.340826]  <TASK>
[    2.341632]  dump_stack_lvl+0x4e/0x70
[    2.343196]  panic+0x113/0x2dd
[    2.344290]  fips_signature_selftest+0x12a/0x148
[    2.345917]  ? __pfx_fips_signature_selftest_init+0x10/0x10
[    2.347744]  fips_signature_selftest_rsa+0x3a/0x40
[    2.349321]  fips_signature_selftest_init+0xe/0x20
[    2.351058]  do_one_initcall+0x5b/0x300
[    2.352439]  do_initcalls+0xdf/0x100
[    2.353691]  ? __pfx_kernel_init+0x10/0x10
[    2.355075]  kernel_init_freeable+0x147/0x1a0
[    2.356540]  kernel_init+0x1a/0x140
[    2.357753]  ret_from_fork+0x34/0x50
[    2.359058]  ? __pfx_kernel_init+0x10/0x10
[    2.360435]  ret_from_fork_asm+0x1a/0x30
[    2.361762]  </TASK>
[    2.362730] Kernel Offset: 0x13000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    2.366169] ---[ end Kernel panic - not syncing: Certs RSA
selftest: pkcs7_validate_trust() = -126 ]---

