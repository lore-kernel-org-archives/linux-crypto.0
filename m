Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C15822083;
	Thu, 24 Jul 2025 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753376585; cv=none; b=VMgbXKs8ksGq7y508E6E2haPsTcNXC1u0VLqYxh7oEL1iZ5/yLfu5pX7KAsy4gYspsnXPhGNE98gg0MbESjJwUBPcBCGW0vy0b5Ks/FNKuzQfO1syPcOsF3hcTlowl7kztCfJPeMqWnXZATJCNXVGxKxFITR9To1NJ7ceQ2zHcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753376585; c=relaxed/simple;
	bh=iIFcGTqsWi64FA+4X8Vt5ss+eRrTzEKBSs8ulGfYqio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzGbj5aBonvVQL84QHIJiQ7FDmXhxeVtbJEZJukhu0nrvVniahUrQLm0u7AxOAqaS96U23kMQcnD9fNlqSNHGyeaZdgF3EXA7RLIRNvmkKPSy0TbT6UYr1ZncU1pVaeNLEs7M13g0myudPfvtvsdOCqM0+On4fFSMt8cAqqAnoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDFK7nla; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDFK7nla"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235f9ea8d08so10759575ad.1;
        Thu, 24 Jul 2025 10:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753376583; x=1753981383; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qwJL8vrfuTsFeO1izedEBY4esNoRy60YOKTbu+lV4JY=;
        b=LDFK7nlaURkNhNsTe3OXeSOEUkuzsxQ54Z0OQzDmMYYtVtfV+CrTlXF5wahFEqjA5c
         POV1QaSgLWX6fxZH30hVUDdsfXROerYaj1mVv5KRHSgi2rvw1zojHYbRkY4vRe1iGbls
         YTU6Lca3Tvi2rOJhPk64Vye6SPa7Ur2JqDgvbdxKWxiIMILGVb+uJPwFrL04klckCfVN
         rdpAq+H/FKgoTTA2nLiErVBWv57NiG6LO8/IuAYTb1KH4Vcr6uIwOSwBf5l0lSPchM1p
         TgJb8bH5cZQGBZ21GrHuoo+ok7em1jE4R7eXia8VusdUEN4g/9i2i9T1TQ9xSerCXXyE
         HgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753376583; x=1753981383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwJL8vrfuTsFeO1izedEBY4esNoRy60YOKTbu+lV4JY=;
        b=QwqGi28n1hVB43Bf9dMVhzX1ZbQyp/jXrEPtBX9EUrOH2jtwrug/9MahrKQV/673HU
         ftrAsOgpWE8JEesN7Hwjc7dMcwo+VHRym7jNIucZ8sbLH7yInRBwEQe+aMv8jJuQXPVA
         A1deN1fIj5dbaGlIsT71R3sEqnqqX2RpstA+CHC8gl4X8uHxFroOdZ5cQWF+HQpvnWg/
         yLOqHj5bkW84bmzpypK1T4Xl5v2ZCaQAcy+hGkL1xgxMGqRtkcTL2DG57MFY1u7+hOcu
         x08+tRm/u7J+wbuK17ZNCxXGHQPWl7W1WZ1LoqZ7P/psiIzhKfT+lVjcJtqgiPYC84tq
         qSZg==
X-Forwarded-Encrypted: i=1; AJvYcCUYIJDyQcPo7Y4xNkgFK1XYF6tBDPtlwgDTSeM98s0flhiLdd6Gjvo84kHdnsfLTu3Nc58nbNMHjV94rrJ7@vger.kernel.org, AJvYcCUo/I34BbHDAyqbtjV7sfJDwx/mVi9C964fhTg4X8JRN71RBsuqaeynakXwdZuKoQsAgbITNwEeQljigcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf28O6OOkgIgkNXfkFYRdzoUuWm2aBIgvIEwdARAB7WENinKjT
	qVl050jRjq3hu3dRtbzQRCXzUURtVlXglAN2R3U3IVvEEN+umbbJ4uQr6E3BEg==
X-Gm-Gg: ASbGncstmu+5c5Mb9X3tGwtPMnSp4i1iPY5WEgI4DKVHNkxJcMjMAJw2lzZSM65MLuY
	ut4hDAz6oZpRzxGD2kSf0aAUHG+dwwtfVy0lXk/sqM3uLsibPkjk4AYAn85Qjez+sI2k2VRQYC2
	Mof/slbJ7kcHFErcAJCAGLCy+yrgWZOLVekfEha0TPoaWEk7A1D3S+0Z1XhvE12Ja7j7QFvL70p
	160XbnoBrEhswr1ufRvUsMFv+hu6GJx6xHlQWhBV0fiAKgpfTQ3MBWhf3KDsB9FcG00zv0d/Zow
	MpgiGj41lG/+cGnyudkHh9YOVu0jvG/+nxSqfORlFRp6ekVvEfL/03S81Wos/ggsP5m5s0Yq5sR
	bVf9RKdV5WFH8Gff+SEsA5u1DsiAPWqeBn7A=
X-Google-Smtp-Source: AGHT+IE038e+1kcoMofDlT1AiHNizN2sCo+hdTNdriW2qg7IRJkKbLtAQVV1ymUwx5UtRSNmZnOrcg==
X-Received: by 2002:a17:902:cecb:b0:234:9656:7db9 with SMTP id d9443c01a7336-23f981ba33bmr127953255ad.32.1753376582402;
        Thu, 24 Jul 2025 10:03:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bde61sm19478105ad.109.2025.07.24.10.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 10:03:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 24 Jul 2025 10:03:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Annotate worker to be on stack
Message-ID: <57d41f7c-44ea-4097-a7ae-458e785fd694@roeck-us.net>
References: <20250721231917.3182029-1-linux@roeck-us.net>
 <20250722031603.GA1298@sol>
 <a534e0ad-35db-45f5-a1c9-9bd34cd3dafd@roeck-us.net>
 <20250724162615.GA26800@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724162615.GA26800@sol>

On Thu, Jul 24, 2025 at 09:26:15AM -0700, Eric Biggers wrote:
> On Thu, Jul 24, 2025 at 07:19:00AM -0700, Guenter Roeck wrote:
> > On Mon, Jul 21, 2025 at 08:16:03PM -0700, Eric Biggers wrote:
> > > On Mon, Jul 21, 2025 at 04:19:17PM -0700, Guenter Roeck wrote:
> > > > The following warning traceback is seen if object debugging is enabled
> > > > with the new crypto test code.
> > > > 
> > > > ODEBUG: object 9000000106237c50 is on stack 9000000106234000, but NOT annotated.
> > > > ------------[ cut here ]------------
> > > > WARNING: lib/debugobjects.c:655 at lookup_object_or_alloc.part.0+0x19c/0x1f4, CPU#0: kunit_try_catch/468
> > > > ...
> > > > 
> > > > This also results in a boot stall when running the code in qemu:loongarch.
> > > > 
> > > > Initializing the worker with INIT_WORK_ONSTACK() fixes the problem.
> > > > 
> > > > Cc: Eric Biggers <ebiggers@kernel.org>
> > > > Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > ---
> > > >  lib/crypto/tests/hash-test-template.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> > > 
> > 
> > Unfortunately it turns out that this is insufficient and/or that there
> > are more problems. With this patch applied and the ext4 unit test crash
> > fixed in next-20250724, I now see the following crash. I'll try to bisect.
> > 
> > Guenter
> > 
> > ---
> > [    9.683061]     KTAP version 1
> > [    9.683116]     # Subtest: poly1305
> > [    9.683160]     # module: poly1305_kunit
> > [    9.683391]     1..12
> > [    9.686210] BUG: unable to handle page fault for address: ffff923a00a09000
> > [    9.686349] #PF: supervisor read access in kernel mode
> > [    9.686399] #PF: error_code(0x0000) - not-present page
> > [    9.686517] PGD 1000067 P4D 1000067 PUD 1291067 PMD 3248067 PTE 0
> > [    9.686694] Oops: Oops: 0000 [#1] SMP PTI
> > [    9.686957] CPU: 0 UID: 0 PID: 565 Comm: kunit_try_catch Tainted: G                 N  6.16.0-rc7-next-20250724-00001-ga9d31cee9308 #1 PREEMPT(voluntary) 
> > [    9.687093] Tainted: [N]=TEST
> > [    9.687126] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> > [    9.687264] RIP: 0010:poly1305_blocks_avx2+0x47c/0x780
> > [    9.687352] Code: bd f4 f3 c5 bd f4 d4 c5 7a 6f 46 10 c5 25 d4 de c5 1d d4 e2 c5 fd 6f 50 10 c5 b5 f4 f1 c5 35 f4 c8 c5 0d d4 f6 c4 41 15 d4 e9 <c4> 63 3d 38 46 30 01 48 8d 76 40 c5 ed f4 f1 c5 ed f4 d0 c5 b5 73
> > [    9.687509] RSP: 0000:ffff923a009fba00 EFLAGS: 00010202
> > [    9.687565] RAX: ffff923a009fba90 RBX: 0000000000001000 RCX: ffffffffb36df180
> > [    9.687624] RDX: 0000000000000040 RSI: ffff923a00a08fc0 RDI: ffff923a009fbd18
> > [    9.687686] RBP: 0000000000001000 R08: 0000000000000001 R09: 0000000000000000
> > [    9.687744] R10: ffff923a009fbc08 R11: 0ed99de400a62f9c R12: ffff923a00a08000
> > [    9.687801] R13: ffff923a009fbca8 R14: 0000000000000001 R15: 0000000000001000
> > [    9.687881] FS:  0000000000000000(0000) GS:ffff8ad208a1a000(0000) knlGS:0000000000000000
> > [    9.687948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    9.687998] CR2: ffff923a00a09000 CR3: 000000001e09c000 CR4: 00000000001506f0
> > [    9.688097] Call Trace:
> > [    9.688183]  <TASK>
> > [    9.688331]  ? __poly1305_init_avx+0x172/0x1f0
> > [    9.688394]  ? kernel_fpu_begin_mask+0xa1/0xf0
> > [    9.688442]  poly1305_blocks_arch+0x95/0x190
> > [    9.688493]  poly1305_update+0x6e/0x150
> > [    9.688534]  poly1305+0x5b/0x90
> > [    9.688592]  test_hash_test_vectors+0xd1/0x1c0
> 
> That's weird.  This crash suggests that the Poly1305 assembly code read
> past the end of the input data buffer, which is a type of bug the test
> is designed to detect.  However, I've never gotten this crash when
> running the test, even on next-20250724 and even on a CPU that uses the
> poly1305_blocks_avx2() code path.
> 

Are you running the test while booting or as module ? Sometimes that makes
a difference.

> Could you provide your kconfig, in case this is kconfig dependent
> somehow?
> 

Configuration file and decoded stacktrace are at

http://server.roeck-us.net/qemu/crypto/

Please let me know if you need anything else.

Thanks,
Guenter
