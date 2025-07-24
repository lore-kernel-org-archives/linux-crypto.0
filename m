Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232C02DCBFC;
	Thu, 24 Jul 2025 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753366745; cv=none; b=UzWlMg5TSSLt3zWovqXZmJT5eABrakFwiOa7Y8VbxDdAkyRa2MRHsI+9OwByT1lYxlPlGWnpVDcBXxqzFnjYPDqcxd5XdHdZg6wGWbfAyY9BWOCfNqyAnj7dH01Fi3lnpSLwaJ1BS8t2qTPYg8itUAQSDdAzCNyfq1nT/vKngLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753366745; c=relaxed/simple;
	bh=Mc3JLXnH+n+dnZu0tXN2P6wEBvnCfFS+qrI904akuJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwIvjpunL55DOy8TCGFWVIaaSE+FY8eY8AeVHEiB+ky4bDipHGDhOJx1HcKU/1LoDYzu37f4kJfG2YAYcTxFnvz+Q7A8K/B8/uuZ3aAAFsnPykO+PnAFIBcrCgJcoQBZuaiKSb0OjkRzjRndDAbW1lO2493WqgXVrL0zBDcKj3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SBaM5qdZ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBaM5qdZ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-74b50c71b0aso693890b3a.0;
        Thu, 24 Jul 2025 07:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753366742; x=1753971542; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZAOIx3PJfW39vOKSvH4KifNViAdZaaWdo0J3eZrJpCU=;
        b=SBaM5qdZOThpx0BRtOGq7xyc3axLVR0iXSGMCLK+HlKZw74St2GiQOGvz+4JRHtwFB
         N798nVfVff8QEnlnMqAYTEUIchqPB+5g5HPoeK7hm5PWFTmFgiRNT07kx2UKqllDXn2n
         Q9dUn9t3jzMlp0mocb+m4IfuKlee/blbLLgWRh86DfmqqH6mhv/yJlGznsakBKo2MA2y
         p8MaVuIPzqSC+SOsc74TW47gsCTbAE9/J5Bn4AuOHPcn6m1JYFYXRlDRtCWPD/uclA9g
         wj7Kl48G1ZkeB+TmzpDWWxOqgnV3nloHxyKGLFPZgpL8Gs3EljZLYrU+UXOX6faWuNd8
         V3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753366742; x=1753971542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAOIx3PJfW39vOKSvH4KifNViAdZaaWdo0J3eZrJpCU=;
        b=FyudHSLf84KEeO3Yfo53W9M2yg3ZsXhDc/mq2JUD3lXAAH7mifvvarhd3VFA5+fGDC
         Dm2YrR2zaJSmXPAFvkC69//3F2ckRN5FqF7y65tSEQ80hEswTgoNT9zQX7NMJk9ugoxC
         lDTWZRnRzcVgbiqC5meoGMcoCbt8Lyko4WFdRLJitZUvo43pyRKuh+gXUWM5tg3yZKgy
         UoXc4LrLlykmYyJcn5KjO/M3cFNGgYqFwdg1+lq5ad9RIGcUqBP6XZbRHF4Uj+XC7wHG
         8SQv1u5dEnAZD0+hqYN3NGPPVHK76Uyawirn2RmpZzJ52R1eObhiT/C7VgGM0J2RK8sW
         4ccw==
X-Forwarded-Encrypted: i=1; AJvYcCU3ipMs/2X9yxJ/sZtg9ok0ecG3tR6zVK7fDnqUbXdsDX1nDIekMxfOajbNzjyfe2wr8xe3Ehi6nMyIjem/@vger.kernel.org, AJvYcCUJXgDdHEDgyeletK2+WLz9vd71mM30e2tiULr1cNJbH6XRhMTTb4vSUilXa/AmDWphRJrQzujPd8I8KFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaU6IEOAkK09nJnusPkCcVJcb9/gy5skLbu1E+HXAZfMRb0KGx
	TbVt4SQs5TqYTQgri9BZdt5vW58unB2w3dNIoo/o0kRunMbO4vGwKGNTfzgsXg==
X-Gm-Gg: ASbGncv6ShWcmKMIQn4QWiiBrdfWEj0wjhnR0IfvjPeQOVzvq1YadAPD3nHzfcAUXTK
	YVXztsL8+SQAITGw5Qzo4BzAhVLuwrORC3/Amv+YUvfmdA4wvXKcye23zAdMI7fCzeVEiZaVtIJ
	uCQABGBhSL/S7F9mCwhuR+NkYgVoIQq17g7bgt/born5fOAZfje4hVxpKwo6DBVYMcYIvUPjS4M
	9h7ezEsszOEhXBKp5gBbTB5uaOneYfM2lqJhp1p4rkqn2UkkJX4InKZBwAxZcqN/jJSZ+a2qs6E
	ni1e9BasG1pmZfcEEAstE9dIL9qxaP9yrK7GTnxOmd3tLSD1q4OEZzO7gPDB6GfMen3MKC9z+kv
	2BYDJHBwjhFp6ja10jTa71yVnu8psTG+XYVqk/XnkNAw8Hg==
X-Google-Smtp-Source: AGHT+IFYbRyQdWdSwYy50FjqC2rPebWbjhDSfcG2X/vEbGcT3qZnZawWe/w+3ZvKgLX0C1c5FNqaNA==
X-Received: by 2002:a05:6a20:3945:b0:216:5f67:98f7 with SMTP id adf61e73a8af0-23d49137911mr10234734637.33.1753366742184;
        Thu, 24 Jul 2025 07:19:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f6c07ffe5sm1551277a12.3.2025.07.24.07.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 07:19:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 24 Jul 2025 07:19:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Annotate worker to be on stack
Message-ID: <a534e0ad-35db-45f5-a1c9-9bd34cd3dafd@roeck-us.net>
References: <20250721231917.3182029-1-linux@roeck-us.net>
 <20250722031603.GA1298@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722031603.GA1298@sol>

On Mon, Jul 21, 2025 at 08:16:03PM -0700, Eric Biggers wrote:
> On Mon, Jul 21, 2025 at 04:19:17PM -0700, Guenter Roeck wrote:
> > The following warning traceback is seen if object debugging is enabled
> > with the new crypto test code.
> > 
> > ODEBUG: object 9000000106237c50 is on stack 9000000106234000, but NOT annotated.
> > ------------[ cut here ]------------
> > WARNING: lib/debugobjects.c:655 at lookup_object_or_alloc.part.0+0x19c/0x1f4, CPU#0: kunit_try_catch/468
> > ...
> > 
> > This also results in a boot stall when running the code in qemu:loongarch.
> > 
> > Initializing the worker with INIT_WORK_ONSTACK() fixes the problem.
> > 
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  lib/crypto/tests/hash-test-template.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> 

Unfortunately it turns out that this is insufficient and/or that there
are more problems. With this patch applied and the ext4 unit test crash
fixed in next-20250724, I now see the following crash. I'll try to bisect.

Guenter

---
[    9.683061]     KTAP version 1
[    9.683116]     # Subtest: poly1305
[    9.683160]     # module: poly1305_kunit
[    9.683391]     1..12
[    9.686210] BUG: unable to handle page fault for address: ffff923a00a09000
[    9.686349] #PF: supervisor read access in kernel mode
[    9.686399] #PF: error_code(0x0000) - not-present page
[    9.686517] PGD 1000067 P4D 1000067 PUD 1291067 PMD 3248067 PTE 0
[    9.686694] Oops: Oops: 0000 [#1] SMP PTI
[    9.686957] CPU: 0 UID: 0 PID: 565 Comm: kunit_try_catch Tainted: G                 N  6.16.0-rc7-next-20250724-00001-ga9d31cee9308 #1 PREEMPT(voluntary) 
[    9.687093] Tainted: [N]=TEST
[    9.687126] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    9.687264] RIP: 0010:poly1305_blocks_avx2+0x47c/0x780
[    9.687352] Code: bd f4 f3 c5 bd f4 d4 c5 7a 6f 46 10 c5 25 d4 de c5 1d d4 e2 c5 fd 6f 50 10 c5 b5 f4 f1 c5 35 f4 c8 c5 0d d4 f6 c4 41 15 d4 e9 <c4> 63 3d 38 46 30 01 48 8d 76 40 c5 ed f4 f1 c5 ed f4 d0 c5 b5 73
[    9.687509] RSP: 0000:ffff923a009fba00 EFLAGS: 00010202
[    9.687565] RAX: ffff923a009fba90 RBX: 0000000000001000 RCX: ffffffffb36df180
[    9.687624] RDX: 0000000000000040 RSI: ffff923a00a08fc0 RDI: ffff923a009fbd18
[    9.687686] RBP: 0000000000001000 R08: 0000000000000001 R09: 0000000000000000
[    9.687744] R10: ffff923a009fbc08 R11: 0ed99de400a62f9c R12: ffff923a00a08000
[    9.687801] R13: ffff923a009fbca8 R14: 0000000000000001 R15: 0000000000001000
[    9.687881] FS:  0000000000000000(0000) GS:ffff8ad208a1a000(0000) knlGS:0000000000000000
[    9.687948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.687998] CR2: ffff923a00a09000 CR3: 000000001e09c000 CR4: 00000000001506f0
[    9.688097] Call Trace:
[    9.688183]  <TASK>
[    9.688331]  ? __poly1305_init_avx+0x172/0x1f0
[    9.688394]  ? kernel_fpu_begin_mask+0xa1/0xf0
[    9.688442]  poly1305_blocks_arch+0x95/0x190
[    9.688493]  poly1305_update+0x6e/0x150
[    9.688534]  poly1305+0x5b/0x90
[    9.688592]  test_hash_test_vectors+0xd1/0x1c0
[    9.688632]  ? kunit_try_run_case+0x86/0x190
[    9.688678]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
[    9.688730]  kunit_try_run_case+0x92/0x190
[    9.688772]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
[    9.688823]  kunit_generic_run_threadfn_adapter+0x1c/0x40
[    9.688870]  kthread+0x10b/0x230
[    9.688904]  ? __pfx_kthread+0x10/0x10
[    9.688940]  ret_from_fork+0x165/0x1b0
[    9.688975]  ? __pfx_kthread+0x10/0x10
[    9.689010]  ret_from_fork_asm+0x1a/0x30
[    9.689069]  </TASK>
[    9.689109] Modules linked in:
[    9.689228] CR2: ffff923a00a09000
[    9.689405] ---[ end trace 0000000000000000 ]---
[    9.689498] RIP: 0010:poly1305_blocks_avx2+0x47c/0x780
[    9.689543] Code: bd f4 f3 c5 bd f4 d4 c5 7a 6f 46 10 c5 25 d4 de c5 1d d4 e2 c5 fd 6f 50 10 c5 b5 f4 f1 c5 35 f4 c8 c5 0d d4 f6 c4 41 15 d4 e9 <c4> 63 3d 38 46 30 01 48 8d 76 40 c5 ed f4 f1 c5 ed f4 d0 c5 b5 73
[    9.689678] RSP: 0000:ffff923a009fba00 EFLAGS: 00010202
[    9.689723] RAX: ffff923a009fba90 RBX: 0000000000001000 RCX: ffffffffb36df180
[    9.689777] RDX: 0000000000000040 RSI: ffff923a00a08fc0 RDI: ffff923a009fbd18
[    9.689831] RBP: 0000000000001000 R08: 0000000000000001 R09: 0000000000000000
[    9.689885] R10: ffff923a009fbc08 R11: 0ed99de400a62f9c R12: ffff923a00a08000
[    9.689940] R13: ffff923a009fbca8 R14: 0000000000000001 R15: 0000000000001000
[    9.689994] FS:  0000000000000000(0000) GS:ffff8ad208a1a000(0000) knlGS:0000000000000000
[    9.690055] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.690100] CR2: ffff923a00a09000 CR3: 000000001e09c000 CR4: 00000000001506f0
[    9.690229] Kernel panic - not syncing: Fatal exception in interrupt
[    9.690580] Kernel Offset: 0x30a00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
