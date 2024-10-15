Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A428691
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729015740; cv=none; b=t/WU1y/MazWWPvy1zRi0H4aAAlNeRYyeuKJaGxNGXQB8z0TP66VWrYviBhcH7EFJuuqKuaUFAgtDVviry/+AgBu98QMPW9X+nwxqF18aeuJ81ZmrzFCMhbeGakosW24ZbjnvxgoQrKQ7rkD4mpF4U7Xf5bHFFylb/3XHaudrezI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729015740; c=relaxed/simple;
	bh=rTeXxu4zOBdMiBEx4bPscqjStv4MuYpxDy8ZIwCvlMw=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/pxZYqHg69f1E/2eqOwrJA3hga/ZAWD3WA8miAyoDuMcVcJao1hXkGvZd/d/dymA+NILrDmxodi184ZD6uPmJzr63VsWl8vBOuVG6Ev28a78/dwRzWh8nwfa3Vk6zDSHNGCCvtLbkoQeqW39/zfNEyJqfNzeY72eGs2pwcYPZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=C1A/nYmL; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="C1A/nYmL"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4XShtY29BDz9spX;
	Tue, 15 Oct 2024 20:08:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1729015733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n2O0CGtlmSLtyi1V1Gdir82UkI1dOC9PgLmdQl5tRWE=;
	b=C1A/nYmLmfNQWIZhgEJr6l24TYpcYdv0/AZ6Xn31UmhFKg2lsJXAxX8qNk6LYa1osom1XG
	KgiqWegGKdfc8thAkdQ+Q6w02UOKw753W8cvaHhc59d5L551bw/Q8c+xsD0o+gtTbfaM1l
	V3k2+igM5UEyI/KZHdvQfWi3fHqtuXnc8RVNN4vot3Umkj+kKWXrR9zr5NcrTCHwoFxQz6
	FeSruU/ZwNREGC+985YIxPGWgMforXzDn2lEmzIgxLNqIHoXqxMFkqor9jSbifLpr4QDVc
	k1AfuDKtNXk0x9AEoZAkDuSNOQHwYZnYnCpuEnpbysdXLthfovgTedexazjxtA==
Date: Tue, 15 Oct 2024 20:08:50 +0200
From: Erhard Furtner <erhard_f@mailbox.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: WARNING: CPU: 1 PID: 81 at crypto/testmgr.c:5931
 alg_test+0x2a4/0x300 (Thinkpad T60, v6.12-rc2)
Message-ID: <20241015200850.6a1d0e2e@yea>
In-Reply-To: <20241010013829.68da351d@yea>
References: <20241010013829.68da351d@yea>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: 3pncc7pqyjz85ubq65pmd3xh9zfx7mmz
X-MBO-RS-ID: 48ffddb00815e70245e

On Thu, 10 Oct 2024 01:38:29 +0200
Erhard Furtner <erhard_f@mailbox.org> wrote:

> On kernel v6.12-rc2 this warning shows up at boot on my Thinkpad T60:
> 
> [...]
> alg: akcipher: decrypt test failed. err -1
> alg: akcipher: test 1 failed for rsa-generic, err=-1
> alg: self-tests for rsa using rsa-generic failed (rc=-1)
> ------------[ cut here ]------------
> alg: self-tests for rsa using rsa-generic failed (rc=-1)
> WARNING: CPU: 1 PID: 81 at crypto/testmgr.c:5931 alg_test+0x2a4/0x300
> Modules linked in:
> CPU: 1 UID: 0 PID: 81 Comm: cryptomgr_test Not tainted 6.12.0-rc2-P3 #3
> Hardware name: LENOVO 2007F2G/2007F2G, BIOS 79ETE7WW (2.27 ) 03/21/2011
> EIP: alg_test+0x2a4/0x300
> Code: 53 68 0b 27 9a c9 e8 e3 7f 3e 00 83 c4 10 89 f0 be fe ff ff ff 83 ff fe 74 9b 57 50 53 68 cd 80 9a c9 e8 37 a2 cb ff 83 c4 10 <0f> 0b 89 fe eb 85 68 ef 66 95 c9 53 56 68 ce 89 9b c9 e8 7d 7d 3e
> EAX: 00000000 EBX: c1d2fa80 ECX: 00000000 EDX: 00000000
> ESI: fffffffe EDI: ffffffff EBP: c1a4bf60 ESP: c1a4bec8
> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010282
> CR0: 80050033 CR2: 00000000 CR3: 09b7c000 CR4: 000006f0
> Call Trace:
>  ? show_regs+0x4e/0x5c
>  ? __warn+0x87/0xdc
>  ? alg_test+0x2a4/0x300
>  ? report_bug+0x94/0x108
>  ? exc_overflow+0x3c/0x3c
>  ? handle_bug+0x41/0x60
>  ? exc_invalid_op+0x17/0x40
>  ? handle_exception+0x101/0x101
>  ? exc_overflow+0x3c/0x3c
>  ? alg_test+0x2a4/0x300
>  ? exc_overflow+0x3c/0x3c
>  ? alg_test+0x2a4/0x300
>  ? __switch_to_asm+0x88/0xe4
>  ? __switch_to_asm+0x82/0xe4
>  ? __switch_to_asm+0x7c/0xe4
>  ? __switch_to_asm+0x76/0xe4
>  ? __switch_to_asm+0x70/0xe4
>  ? __switch_to_asm+0x6a/0xe4
>  ? __switch_to_asm+0x64/0xe4
>  ? __switch_to_asm+0x5e/0xe4
>  ? __switch_to_asm+0x58/0xe4
>  ? __switch_to_asm+0x52/0xe4
>  ? __switch_to_asm+0x4c/0xe4
>  ? __switch_to_asm+0x46/0xe4
>  ? _raw_spin_unlock+0x8/0xc
>  ? finish_task_switch+0x98/0x244
>  ? __switch_to_asm+0x1c/0xe4
>  ? __switch_to_asm+0x16/0xe4
>  ? __schedule+0x587/0x7a4
>  cryptomgr_test+0x1c/0x38
>  kthread+0xc4/0xd0
>  ? crypto_alg_put+0x40/0x40
>  ? kthread_blkcg+0x24/0x24
>  ? kthread_blkcg+0x24/0x24
>  ret_from_fork+0x31/0x3c
>  ret_from_fork_asm+0x12/0x18
>  entry_INT80_32+0xf0/0xf0
> ---[ end trace 0000000000000000 ]---

v6.12-rc3 still affected. So I bisected the issue to the following commit:

 # git bisect good
5a72a244bac3e8663834d88bb0b4f9069203e5e0 is the first bad commit
commit 5a72a244bac3e8663834d88bb0b4f9069203e5e0
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat Aug 10 14:21:02 2024 +0800

    crypto: rsa - Check MPI allocation errors
    
    Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
    Fixes: f145d411a67e ("crypto: rsa - implement Chinese Remainder Theorem for faster private key operation")
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

 crypto/rsa.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


Reverting 5a72a244bac3e8663834d88bb0b4f9069203e5e0 on top of v6.12-rc3 fixes the failure.

Regards,
Erhard
