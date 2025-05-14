Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE566191F98
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230390; cv=none; b=AYpuP7VEqq7/sSSE+qxVX6453VPNNwNnErABnJbi5SfxVLRT44zZjz/soHVCodrj6F++3CJ3+VVp3LTNOS9/A1/t48dRKPfLwNUMOTCm51ZHuOpH7697kdjqyQECmbjxkbNMlcRiRg22+Xl1ATJRh1+Z2h66aLSN/13wO6SxHUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230390; c=relaxed/simple;
	bh=EZzS2s/9Rus1YLqEHk1xmcB30EGgAweFxDnh/MIikK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7GMM2FZFqrrdyUSJvEE/3+CNnaJRkcvmhlh+AW2H1TWpVLsccER9kZqQx7z6UFSbd96qtX3ZaZ6rXBJiEt/Kmc/YNpfI5TDgoOdEd+rXladgbFrrSVXvJPTGpXMH3JAxobnhhR8GynCW1yWbQUZIcpSqZ16AnVL+RrooJ+LOpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bZkSegR3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZkSegR3"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso12740132a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 06:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747230386; x=1747835186; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9N/LFYnFcJ+thh0vcMCkQFM9etSTHG791gyhElF6mrY=;
        b=bZkSegR36IFybGZONdOjfn9chF0dDa07OTJirR4oftk2eeiDl9HrR3aXPaCG3swdmA
         SmBSHFgEe/SNi99NLEoBW5yLR47tKRMl6KUcvC5ig6eu6YI9AHOImqtvcFqxnFbkUkhK
         H85gC99+JAl/H7RNE8NbR34dWuODdO2dSiNUABrYEkFvMHXJ0APx4P+3RW2fOljQSba4
         K48SgoIw4RdhTFRcN/NT86nLS2q4KNb/w+PPOZxG3x66AjCEv0wZRTHQHxJ/1zBvJyPH
         ZzMx5RvMvQdtGbJaUcL/SWR8AOFnNkgZZ7JvDRctSZapODKgk76/b4Fwn04l3/64OUhK
         LhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747230386; x=1747835186;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9N/LFYnFcJ+thh0vcMCkQFM9etSTHG791gyhElF6mrY=;
        b=r7yc+wP0EODmhXsm5HY0JJSGg9RfPQHyo8celzTDZQKTiQbxmnPkOy4+YHNi0zAKuG
         SfMBSwgesMOSuNiR7Fltbecl2b1b/gtL2itAeV7xkG1CnIjPD0FRrqcy+Gc9ZMzXOxNW
         ik4Vwbr/u2P4ArP4FIthhJlP9TJ85qM7vALQZUtAauQxJ9ypDd20BErIbJ8VmjUFShsw
         EAuPFOoCc2nuFXXB59ASMcVVjgT9rK1eR+ZbArgIIoHsus3/uM5wuJyhndaqKog1eiiO
         fKqAOztN5eYc+hMUMK+FQa9+e39NNkCV10gudZMUn6NEPI3hsPpKOQYRTC/WRjAoxlFI
         QKDQ==
X-Gm-Message-State: AOJu0YxMXJB0ufwoT9a53en54BLr9qWIkVKTgJgE4aFKTfgpmeAakHgL
	0pV8TGHt01TV7IgRBVWgG08O7MdKd5DZgWLpg+ZbaOnuRBq1nXvpiddr6g==
X-Gm-Gg: ASbGnctBhw4NqPmcZD6F1vPOOSj+i1rjhOdhDcKVEed7aLKixAsDcU+W38evsTat5Sx
	x6r1GC3gkTPizDYeo6Z+OdURIk3cqclQTQi4LnflZkVhXUjx/pNZS99AHNvpYuKhyp1wP0a3sL8
	p0kWftzNJHTBdYU52agqvvNdqiXgFmTbaknwgTl1phaNaCVHWeNXIcJxAH71pKPU9CyUhHnHx1n
	+5K08RP1bY+mfPb1qW9TJoALuWOGvpdVEZanaxkwj8sEPFX80gbBTJ6ylLEcyiOGYXxqsERM7x/
	MelHZjPjuNbLfBezKRb47KK8Azj000jI1mDtwBlOSakYMzbS1EkO
X-Google-Smtp-Source: AGHT+IGLPA0gkkGG5xWzAcB9kG3iqgJe+TZg2agl36IqB1oaX6IDMe1/TuuT1mRUgfEYvBYnW6ygww==
X-Received: by 2002:a05:6402:1d50:b0:5fc:4045:7d79 with SMTP id 4fb4d7f45d1cf-5ff988d14cdmr3185662a12.22.1747230385416;
        Wed, 14 May 2025 06:46:25 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5fd0142152bsm6728155a12.19.2025.05.14.06.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 06:46:24 -0700 (PDT)
Date: Wed, 14 May 2025 15:46:23 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <aCSer34x-WvSRn4m@Red>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>

Le Wed, May 14, 2025 at 05:22:27PM +0800, Herbert Xu a écrit :
> v3 adds hash export format testing and import_core/export_core
> hooks for hmac.
> 
> This series adds partial block handling to ahash so that drivers
> do not have to handle them.  It also adds hmac ahash support so
> that drivers that do hmac purely in software can be simplified.
> 
> A new test has been added to testmgr to ensure that all implementations
> of a given algorithm use the same export format.  As a transitional
> measure only algorithms that declare themselves as block-only, or
> provides export_core/import_core hooks will be tested.
> 
> Herbert Xu (11):
>   crypto: hash - Move core export and import into internel/hash.h
>   crypto: hash - Add export_core and import_core hooks
>   crypto: ahash - Handle partial blocks in API
>   crypto: hmac - Zero shash desc in setkey
>   crypto: hmac - Add export_core and import_core
>   crypto: shash - Set reqsize in shash_alg
>   crypto: algapi - Add driver template support to crypto_inst_setname
>   crypto: hmac - Add ahash support
>   crypto: hmac - Add ahash support
>   crypto: testmgr - Use ahash for generic tfm
>   crypto: testmgr - Add hash export format testing
> 
>  crypto/ahash.c                 | 572 ++++++++++++++++-----------------
>  crypto/algapi.c                |   8 +-
>  crypto/hmac.c                  | 390 +++++++++++++++++++---
>  crypto/shash.c                 |  46 ++-
>  crypto/testmgr.c               | 132 ++++++--
>  crypto/testmgr.h               |   2 +
>  include/crypto/algapi.h        |  12 +-
>  include/crypto/hash.h          |  73 ++---
>  include/crypto/internal/hash.h |  66 ++++
>  9 files changed, 881 insertions(+), 420 deletions(-)
> 

Hello

I get multiple crash on lot of qemu with this patch:
[   75.992879] alg: hash: error allocating hmac(sha1-generic) (generic impl of hmac(sha1)): -17
[   75.993252] alg: self-tests for hmac(sha1) using hmac-ahash(sha1-generic) failed (rc=-17)
[   75.993467] ------------[ cut here ]------------
[   75.993535] alg: self-tests for hmac(sha1) using hmac-ahash(sha1-generic) failed (rc=-17)
[   75.994387] WARNING: CPU: 0 PID: 1419 at crypto/testmgr.c:5884 alg_test.part.0+0x348/0x35e
[   75.995474] Modules linked in: sha1_generic des_generic libdes cmac
[   75.996341] CPU: 0 UID: 0 PID: 1419 Comm: cryptomgr_test Not tainted 6.15.0-rc5-gd5c3878fc8b2 #33 NONE 
[   75.996465] Hardware name: riscv-virtio,qemu (DT)
[   75.996711] epc : alg_test.part.0+0x348/0x35e
[   75.996871]  ra : alg_test.part.0+0x348/0x35e
[   75.996932] epc : ffffffff803bdc94 ra : ffffffff803bdc94 sp : ff20000000223d40
[   75.996981]  gp : ffffffff8151a678 tp : ff600000069ee400 t0 : ffffffff8141db98
[   75.997027]  t1 : 0000000000000004 t2 : 2d2d2d2d2d2d2d2d s0 : ff20000000223e40
[   75.997079]  s1 : ffffffffffffffef a0 : 000000000000004d a1 : 0000000000000001
[   75.997126]  a2 : 0000000000000010 a3 : 0000000000000000 a4 : ac65d7ac2de49800
[   75.997172]  a5 : ac65d7ac2de49800 a6 : c0000000ffffefff a7 : 0000000000000000
[   75.997217]  s2 : 000000000004080f s3 : ff600000066ca000 s4 : ff600000066ca080
[   75.997268]  s5 : ffffffff8151d0e0 s6 : 0000000000000400 s7 : ffffffffffffffff
[   75.997315]  s8 : 0000000000000087 s9 : ffffffff80e5c4c0 s10: 0000000000000000
[   75.997391]  s11: 0000000000000000 t3 : ffffffff81534f04 t4 : ffffffff81534f04
[   75.997437]  t5 : ffffffff81534ee0 t6 : ff20000000223aa8
[   75.997481] status: 0000000200000120 badaddr: ffffffff803bdc94 cause: 0000000000000003
[   75.997743] [<ffffffff803bdc94>] alg_test.part.0+0x348/0x35e
[   75.997933] [<ffffffff803bdcc2>] alg_test+0x18/0x4e
[   75.997980] [<ffffffff803b8b4c>] cryptomgr_test+0x1c/0x3a
[   75.998019] [<ffffffff80041a20>] kthread+0xe8/0x1b0
[   75.998080] [<ffffffff809dedda>] ret_from_fork+0xe/0x18
[   75.998288] ---[ end trace 0000000000000000 ]---
[   78.533559] alg: hash: error allocating hmac(sha512-generic) (generic impl of hmac(sha512)): -17
[   78.533772] alg: self-tests for hmac(sha512) using hmac-ahash(sha512-generic) failed (rc=-17)
[   78.533836] ------------[ cut here ]------------
[   78.533880] alg: self-tests for hmac(sha512) using hmac-ahash(sha512-generic) failed (rc=-17)
[   78.533991] WARNING: CPU: 0 PID: 1497 at crypto/testmgr.c:5884 alg_test.part.0+0x348/0x35e
[   78.534079] Modules linked in: sha1_generic des_generic libdes cmac
[   78.534566] CPU: 0 UID: 0 PID: 1497 Comm: cryptomgr_test Tainted: G        W           6.15.0-rc5-gd5c3878fc8b2 #33 NONE 
[   78.534720] Tainted: [W]=WARN
[   78.534759] Hardware name: riscv-virtio,qemu (DT)
[   78.534793] epc : alg_test.part.0+0x348/0x35e
[   78.534838]  ra : alg_test.part.0+0x348/0x35e
[   78.534873] epc : ffffffff803bdc94 ra : ffffffff803bdc94 sp : ff200000002d3d40
[   78.534898]  gp : ffffffff8151a678 tp : ff600000069ea580 t0 : ffffffff8141e538
[   78.534920]  t1 : 0000000000000004 t2 : 2d2d2d2d2d2d2d2d s0 : ff200000002d3e40
[   78.534942]  s1 : ffffffffffffffef a0 : 0000000000000051 a1 : 0000000000000001
[   78.534963]  a2 : 0000000000000010 a3 : 0000000000000000 a4 : ac65d7ac2de49800
[   78.534984]  a5 : ac65d7ac2de49800 a6 : c0000000ffffefff a7 : 0000000000000000
[   78.535006]  s2 : 000000000004080f s3 : ff60000006b9fc00 s4 : ff60000006b9fc80
[   78.535027]  s5 : ffffffff8151d0e0 s6 : 0000000000000400 s7 : ffffffffffffffff
[   78.535049]  s8 : 000000000000008f s9 : ffffffff80e5c4c0 s10: 0000000000000000
[   78.535100]  s11: 0000000000000000 t3 : ffffffff815356ec t4 : ffffffff815356ec
[   78.535123]  t5 : ffffffff815356c8 t6 : ff200000002d3aa8
[   78.535144] status: 0000000200000120 badaddr: ffffffff803bdc94 cause: 0000000000000003
[   78.535174] [<ffffffff803bdc94>] alg_test.part.0+0x348/0x35e
[   78.535221] [<ffffffff803bdcc2>] alg_test+0x18/0x4e
[   78.535261] [<ffffffff803b8b4c>] cryptomgr_test+0x1c/0x3a
[   78.535299] [<ffffffff80041a20>] kthread+0xe8/0x1b0
[   78.535345] [<ffffffff809dedda>] ret_from_fork+0xe/0x18
[   78.535393] ---[ end trace 0000000000000000 ]---
[  119.113318] alg: hash: error allocating hmac(sha256-generic) (generic impl of hmac(sha256)): -17
[  119.113535] alg: self-tests for hmac(sha256) using hmac(sha256-riscv) failed (rc=-17)
[  119.113585] ------------[ cut here ]------------
[  119.113629] alg: self-tests for hmac(sha256) using hmac(sha256-riscv) failed (rc=-17)
[  119.113740] WARNING: CPU: 0 PID: 2499 at crypto/testmgr.c:5884 alg_test.part.0+0x348/0x35e
[  119.113870] Modules linked in: drbg ctr ccm algif_aead sha1_generic des_generic libdes cmac
[  119.114045] CPU: 0 UID: 0 PID: 2499 Comm: cryptomgr_test Tainted: G        W           6.15.0-rc5-gd5c3878fc8b2 #33 NONE 
[  119.114103] Tainted: [W]=WARN
[  119.114121] Hardware name: riscv-virtio,qemu (DT)
[  119.114143] epc : alg_test.part.0+0x348/0x35e
[  119.114183]  ra : alg_test.part.0+0x348/0x35e
[  119.114217] epc : ffffffff803bdc94 ra : ffffffff803bdc94 sp : ff2000000020bd40
[  119.114241]  gp : ffffffff8151a678 tp : ff600000069e8000 t0 : ffffffff8141ef30
[  119.114262]  t1 : 0000000000000004 t2 : 2d2d2d2d2d2d2d2d s0 : ff2000000020be40
[  119.114284]  s1 : ffffffffffffffef a0 : 0000000000000049 a1 : 0000000000000001
[  119.114306]  a2 : 0000000000000010 a3 : 0000000000000000 a4 : ac65d7ac2de49800
[  119.114327]  a5 : ac65d7ac2de49800 a6 : c0000000ffffefff a7 : 0000000000000000
[  119.114348]  s2 : 000000000004080e s3 : ff60000006b9f000 s4 : ff60000006b9f080
[  119.114370]  s5 : ffffffff8151d0e0 s6 : 0000000000000400 s7 : ffffffffffffffff
[  119.114391]  s8 : 0000000000000089 s9 : ffffffff80e5c4c0 s10: 0000000000000000
[  119.114412]  s11: 0000000000000000 t3 : ffffffff81535f04 t4 : ffffffff81535f04
[  119.114433]  t5 : ffffffff81535ee0 t6 : ff2000000020baa8
[  119.114452] status: 0000000200000120 badaddr: ffffffff803bdc94 cause: 0000000000000003
[  119.114479] [<ffffffff803bdc94>] alg_test.part.0+0x348/0x35e
[  119.114523] [<ffffffff803bdcc2>] alg_test+0x18/0x4e
[  119.114561] [<ffffffff803b8b4c>] cryptomgr_test+0x1c/0x3a
[  119.114598] [<ffffffff80041a20>] kthread+0xe8/0x1b0
[  119.114643] [<ffffffff809dedda>] ret_from_fork+0xe/0x18
[  119.114688] ---[ end trace 0000000000000000 ]---
[  119.115809] DRBG: could not allocate digest TFM handle: hmac(sha256)
[  119.116042] alg: drbg: Failed to reset rng
[  119.116144] alg: drbg: Test 0 failed for drbg_nopr_hmac_sha256
[  119.116226] alg: self-tests for stdrng using drbg_nopr_hmac_sha256 failed (rc=-22)
[  119.116269] ------------[ cut here ]------------
[  119.116312] alg: self-tests for stdrng using drbg_nopr_hmac_sha256 failed (rc=-22)
[  119.116402] WARNING: CPU: 0 PID: 2489 at crypto/testmgr.c:5884 alg_test.part.0+0x348/0x35e
[  119.116479] Modules linked in: drbg ctr ccm algif_aead sha1_generic des_generic libdes cmac
[  119.116630] CPU: 0 UID: 0 PID: 2489 Comm: cryptomgr_test Tainted: G        W           6.15.0-rc5-gd5c3878fc8b2 #33 NONE 
[  119.116680] Tainted: [W]=WARN
[  119.116696] Hardware name: riscv-virtio,qemu (DT)
[  119.116713] epc : alg_test.part.0+0x348/0x35e
[  119.116751]  ra : alg_test.part.0+0x348/0x35e
[  119.116795] epc : ffffffff803bdc94 ra : ffffffff803bdc94 sp : ff20000000213d40
[  119.116818]  gp : ffffffff8151a678 tp : ff60000006b6d780 t0 : ffffffff8141f9d8
[  119.116840]  t1 : 0000000000000004 t2 : 2d2d2d2d2d2d2d2d s0 : ff20000000213e40
[  119.116861]  s1 : ffffffffffffffea a0 : 0000000000000046 a1 : ffffffff81487c60
[  119.116882]  a2 : 0000000000000010 a3 : ffffffff81487c60 a4 : ac65d7ac2de49800
[  119.116903]  a5 : ac65d7ac2de49800 a6 : c0000000ffffefff a7 : 0000000000000000
[  119.116924]  s2 : 000000000000000c s3 : ff600000066cae00 s4 : ff600000066cae80
[  119.116945]  s5 : ffffffff8151d0e0 s6 : 0000000000000400 s7 : 0000000000001480
[  119.116968]  s8 : ffffffffffffffff s9 : ffffffff80e5c4c0 s10: 0000000000000000
[  119.116990]  s11: 0000000000000000 t3 : ffffffff81536784 t4 : ffffffff81536784
[  119.117011]  t5 : ffffffff81536760 t6 : ff20000000213aa8
[  119.117032] status: 0000000200000120 badaddr: ffffffff803bdc94 cause: 0000000000000003
[  119.117056] [<ffffffff803bdc94>] alg_test.part.0+0x348/0x35e
[  119.117099] [<ffffffff803bdcc2>] alg_test+0x18/0x4e
[  119.117136] [<ffffffff803b8b4c>] cryptomgr_test+0x1c/0x3a
[  119.117173] [<ffffffff80041a20>] kthread+0xe8/0x1b0
[  119.117214] [<ffffffff809dedda>] ret_from_fork+0xe/0x18
[  119.117257] ---[ end trace 0000000000000000 ]---
[  119.120333] DRBG: could not allocate digest TFM handle: hmac(sha256)
[  119.120449] alg: drbg: Failed to reset rng
[  119.120508] alg: drbg: Test 0 failed for drbg_pr_hmac_sha256
[  119.120561] alg: self-tests for stdrng using drbg_pr_hmac_sha256 failed (rc=-22)
[  119.120607] ------------[ cut here ]------------
[  119.120649] alg: self-tests for stdrng using drbg_pr_hmac_sha256 failed (rc=-22)
[  119.120762] WARNING: CPU: 0 PID: 2485 at crypto/testmgr.c:5884 alg_test.part.0+0x348/0x35e
[  119.120881] Modules linked in: drbg ctr ccm algif_aead sha1_generic des_generic libdes cmac
[  119.121058] CPU: 0 UID: 0 PID: 2485 Comm: cryptomgr_test Tainted: G        W           6.15.0-rc5-gd5c3878fc8b2 #33 NONE 
[  119.121114] Tainted: [W]=WARN
[  119.121133] Hardware name: riscv-virtio,qemu (DT)
[  119.121155] epc : alg_test.part.0+0x348/0x35e
[  119.121198]  ra : alg_test.part.0+0x348/0x35e
[  119.121232] epc : ffffffff803bdc94 ra : ffffffff803bdc94 sp : ff20000000203d40
[  119.121256]  gp : ffffffff8151a678 tp : ff600000069ea580 t0 : ffffffff81420480
[  119.121277]  t1 : 0000000000000004 t2 : 2d2d2d2d2d2d2d2d s0 : ff20000000203e40
[  119.121299]  s1 : ffffffffffffffea a0 : 0000000000000044 a1 : ffffffff81487c60
[  119.121320]  a2 : 0000000000000010 a3 : ffffffff81487c60 a4 : ac65d7ac2de49800
[  119.121341]  a5 : ac65d7ac2de49800 a6 : c0000000ffffefff a7 : 0000000000000000
[  119.121362]  s2 : 000000000000000c s3 : ff60000006b9f600 s4 : ff60000006b9f680
[  119.121383]  s5 : ffffffff8151d0e0 s6 : 0000000000000400 s7 : 00000000000016c0
[  119.121404]  s8 : ffffffffffffffff s9 : ffffffff80e5c4c0 s10: 0000000000000000
[  119.121425]  s11: 0000000000000000 t3 : ffffffff81536ff4 t4 : ffffffff81536ff4
[  119.121446]  t5 : ffffffff81536fd0 t6 : ff20000000203aa8
[  119.121465] status: 0000000200000120 badaddr: ffffffff803bdc94 cause: 0000000000000003
[  119.121493] [<ffffffff803bdc94>] alg_test.part.0+0x348/0x35e
[  119.121537] [<ffffffff803bdcc2>] alg_test+0x18/0x4e
[  119.121574] [<ffffffff803b8b4c>] cryptomgr_test+0x1c/0x3a
[  119.121611] [<ffffffff80041a20>] kthread+0xe8/0x1b0
[  119.121656] [<ffffffff809dedda>] ret_from_fork+0xe/0x18
[  119.121702] ---[ end trace 0000000000000000 ]---
[  119.608997] alg: hash: error allocating hmac(sha256-generic) (generic impl of hmac(sha256)): -17
[  119.609903] alg: self-tests for hmac(sha256) using hmac-ahash(sha256-generic) failed (rc=-17)
[  119.609958] ------------[ cut here ]------------
[  119.610003] alg: self-tests for hmac(sha256) using hmac-ahash(sha256-generic) failed (rc=-17)
[  119.610116] WARNING: CPU: 0 PID: 2505 at crypto/testmgr.c:5884 alg_test.part.0+0x348/0x35e
[  119.610205] Modules linked in: drbg ctr ccm algif_aead sha1_generic des_generic libdes cmac
[  119.610374] CPU: 0 UID: 0 PID: 2505 Comm: cryptomgr_test Tainted: G        W           6.15.0-rc5-gd5c3878fc8b2 #33 NONE 
[  119.610430] Tainted: [W]=WARN
[  119.610449] Hardware name: riscv-virtio,qemu (DT)
[  119.610472] epc : alg_test.part.0+0x348/0x35e
[  119.610512]  ra : alg_test.part.0+0x348/0x35e
[  119.610547] epc : ffffffff803bdc94 ra : ffffffff803bdc94 sp : ff2000000022bd40
[  119.610571]  gp : ffffffff8151a678 tp : ff60000006b6be80 t0 : ffffffff81420e78
[  119.610593]  t1 : 0000000000000004 t2 : 2d2d2d2d2d2d2d2d s0 : ff2000000022be40
[  119.610614]  s1 : ffffffffffffffef a0 : 0000000000000051 a1 : 0000000000000001
[  119.610635]  a2 : 0000000000000010 a3 : 0000000000000000 a4 : ac65d7ac2de49800
[  119.610657]  a5 : ac65d7ac2de49800 a6 : c0000000ffffefff a7 : 0000000000000000
[  119.610678]  s2 : 000000000004080f s3 : ff60000020032400 s4 : ff60000020032480
[  119.610699]  s5 : ffffffff8151d0e0 s6 : 0000000000000400 s7 : ffffffffffffffff
[  119.610721]  s8 : 0000000000000089 s9 : ffffffff80e5c4c0 s10: 0000000000000000
[  119.610741]  s11: 0000000000000000 t3 : ffffffff8153781c t4 : ffffffff8153781c
[  119.610763]  t5 : ffffffff815377f8 t6 : ff2000000022baa8
[  119.610790] status: 0000000200000120 badaddr: ffffffff803bdc94 cause: 0000000000000003
[  119.610821] [<ffffffff803bdc94>] alg_test.part.0+0x348/0x35e
[  119.610867] [<ffffffff803bdcc2>] alg_test+0x18/0x4e
[  119.610905] [<ffffffff803b8b4c>] cryptomgr_test+0x1c/0x3a
[  119.610942] [<ffffffff80041a20>] kthread+0xe8/0x1b0
[  119.610987] [<ffffffff809dedda>] ret_from_fork+0xe/0x18
[  119.611034] ---[ end trace 0000000000000000 ]---

Regards
