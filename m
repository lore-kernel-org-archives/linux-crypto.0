Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B3D2405F5;
	Fri, 25 Apr 2025 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745577744; cv=none; b=e/uV1mf8FJMEI6Uz8t+qwsKBEAwzg2Y5sN3MErcehaQuzs2IPc2yAjcjfXe8TAzbkB9/y2V6VLQvRLDVfEvAZ5hQGvu3zjMrrQXlE+gthtJ6MhUshNd72CHHJOFsv//gEQFqKTE5ZJgiMXfymeOmzkns9oRDzhKS+ZVolUVOUvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745577744; c=relaxed/simple;
	bh=0bDDdW2Fgz+EcgDZSK00gAwh+/fzSBx05bYgQOQs8FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MALODPR3ChEPpEusyV0811KUUsqosQhIXsNuV6Xoqewi6y7V2bnmSBZpj7exVbkC+qDUZKYGtdPB2ck22fSIn0ehH4dPdsmM+ssNPmT5iYNg1a3wCYLzihVh+MnIGkYVcrq7MMnVyOT2GTeWvLrO5kArJ74nlJ1kZchOTpZammw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EVLx6/a1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EVLx6/a1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43edb40f357so14322485e9.0;
        Fri, 25 Apr 2025 03:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745577740; x=1746182540; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NOGmH1pVAAUAxb8wMFKpWEUiZgek26ZK36mDQNMI/7Y=;
        b=EVLx6/a1w6C7smuUIeCvKgA0Fmj9c5CjJ0kDYLYTnOeEeN1FqAp0CIxKsRBSryqBv4
         0LouI6GoPf7z75fQLJB8z0n/+Gro6PNBxKZVh0pBlYuxIb70wn5xPVRNeptvM8p8tmZv
         cdFLypdq+OH7uNSqww1ro+38AzskXYXJaeS0b454J7QmwJp1pknPo/KPDzhUNw56h2fF
         ycUgi8s2SbTM4Lp8wis5XvQxIqO6DAYbH8H8beXGeiESx/KAOrYhTejLxw8lWLi7Apxx
         jDzKyLVkGcaxf/payrK8dTEumGVMDRckU3XRpCYPSIAg3pQABqYN6P7+b3hS0jvdJiGf
         h4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745577740; x=1746182540;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOGmH1pVAAUAxb8wMFKpWEUiZgek26ZK36mDQNMI/7Y=;
        b=xHCZ3HzHyBzbmyUxTrudaModQVgnnuEB90pVroqcPUBe8GSHgyhNIWgEBfvb3C57fh
         DcS6Xp/foo+mn0PpQMG6rktfzplwR7rXPxXIvnPzNtBpqu15w9eUWX5WBFwcIfLMGyx5
         0p5aQOXpWcD34jULjrjnh4KSfE5ECR0CB2ExbS8zPgJL/e9R8r3TUM+ZkaOjFODECELy
         0AetlNpSMJOhGiql7OtUuioeDWs5pkCVTJf1D7nvQP+SS+g9OVoyR4zKNSvklG4KipQV
         3jLOtjmgZkYugMHNV8aXXYC45TIuk+AAHm42zIq+G9B28pi38NeO0PeioeIQyFJ3LhJq
         dn4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrE/QDk8v8gPFzNpRBaGjj8QbZV1t4KGJGi7E7V8ZXsseodc8BUm20EWYPsLQnQFmaZhTq5PNQSczzRKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG117iGXzkJvBzjKBFv1BxqEfDKHyXEzSIjHIkhIPtoR0Tpfhb
	oy70jSbAZtiEQsMhKi2LqE4+/VhDAFA6rcOXOQ4ZDJKC0T+LTuuabUqppQ==
X-Gm-Gg: ASbGncs1RP4+wXwCFJYeaT3PDGHgJJjc8kivbWd3egEH1rt6EnBPYmAV/LJ1OUljPtF
	EEkYYZO5/lHt7ZuDD9+NXcIz+GBe2hFopQ3C9Dp+VogaWdSDnrlX1SCh6JTr+ufd5b9FdYeRWRv
	jdogPajHiFMjIC7dp4gzGvBWyeYPCBe/M2xxzGm5gOm6jvkO0yyC130A5xJDJc77nC/2wYhJxyY
	ZV6HCPzUfRpPXq5A+WvBTXT/AbmzQMu+gX5wkmt1UahNruJ9MD15wtXZC01zDmL7wGJtgVGvuag
	pLv34b5IVlIZOrHfZkNHFAs0FjU4UZ/oCW2smuWhzw==
X-Google-Smtp-Source: AGHT+IG3Q3+8w1qsTuv8aHJ3PrGbLwd6YJC/As67Q6d59Psh8rZS3yxrTBfs7uLURaaAghrVYR+W8Q==
X-Received: by 2002:a05:600c:1d97:b0:440:67f8:7589 with SMTP id 5b1f17b1804b1-440a66143f0mr17670635e9.16.1745577740370;
        Fri, 25 Apr 2025 03:42:20 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-440a5394bfasm20624755e9.40.2025.04.25.03.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 03:42:19 -0700 (PDT)
Date: Fri, 25 Apr 2025 12:42:17 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm/blake2b - Set FINAL_NONZERO
Message-ID: <aAtnCR5jVAnjfR1i@Red>
References: <aAop_uMhxVh2l5Fy@Red>
 <aApN64n7i15ArnX4@gondor.apana.org.au>
 <aAqhbdiLmkHV350S@Red>
 <aAsCk3jtbAE7dPpJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aAsCk3jtbAE7dPpJ@gondor.apana.org.au>

Le Fri, Apr 25, 2025 at 11:33:39AM +0800, Herbert Xu a écrit :
> On Thu, Apr 24, 2025 at 10:39:09PM +0200, Corentin Labbe wrote:
> >
> > Thanks it fixes my crypto hw devices.
> > So Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
> 
> What about the sha1-ce failure on arm64? Did that go away too?

No they are still there:
[    2.022921] alg: shash: sha1-ce test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
[    2.022950] alg: self-tests for sha1 using sha1-ce failed (rc=-22)
[    2.022957] ------------[ cut here ]------------
[    2.022960] alg: self-tests for sha1 using sha1-ce failed (rc=-22)
[    2.023009] WARNING: CPU: 3 PID: 110 at crypto/testmgr.c:5871 alg_test+0x5e8/0x60c
[    2.023033] Modules linked in:
[    2.023046] CPU: 3 UID: 0 PID: 110 Comm: cryptomgr_test Not tainted 6.15.0-rc1-g583d02477052 #2 PREEMPT 
Setting prompt string to ['-+\\[ end trace \\w* \\]-+[^\\n]*\\r', '/ #', '~ #', 'sh-5.1#', 'Login timed out', 'Login incorrect']
[    2.023057] Hardware name: Pine64 PINE H64 Model A (DT)
[    2.023062] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.023071] pc : alg_test+0x5e8/0x60c
[    2.023081] lr : alg_test+0x5e8/0x60c
[    2.023090] sp : ffff80008180bd40
[    2.023093] x29: ffff80008180bde0 x28: 00000000000000bc x27: 0000000000000000
[    2.023106] x26: 00000000ffffffff x25: 00000000ffffffea x24: 0000000000000177
[    2.023118] x23: ffff800081014208 x22: ffff00000152ae80 x21: 000000000500000e
[    2.023130] x20: ffff00000152ae00 x19: ffff800080a26238 x18: 00000000fffffffe
[    2.023142] x17: 2c3020726f746365 x16: 762074736574206e x15: ffff800080fdc47b
[    2.023154] x14: 0000000000000000 x13: ffff800080fdc47f x12: 65742d666c657320
[    2.023165] x11: 0000000000000058 x10: 0000000000000029 x9 : 0000000000000001
[    2.023177] x8 : ffff800080ec3308 x7 : ffff80008180bae0 x6 : 000000000000000c
[    2.023188] x5 : 0000000000000000 x4 : 00000000fffff0b5 x3 : 0000000000000000
[    2.023199] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000099a7000
[    2.023211] Call trace:
[    2.023216]  alg_test+0x5e8/0x60c (P)
[    2.023229]  cryptomgr_test+0x24/0x44
[    2.023240]  kthread+0x12c/0x204
[    2.023253]  ret_from_fork+0x10/0x20
[    2.023267] ---[ end trace 0000000000000000 ]---


> 
> That didn't seem related to crypto_engine.
> 
> > But I still got some crash with blake2b:
> > +[   54.348477] alg: shash: blake2b-256-neon test failed (wrong result) on test vector 1, cfg="init+update+final aligned buffer"
> > +[   54.348525] alg: self-tests for blake2b-256 using blake2b-256-neon failed (rc=-22)
> > +[   54.348536] ------------[ cut here ]------------
> 
> OK this is easy, I left out the FINAL_NONZERO bit in the arm patch:
> 

blake2b crash disappear, so
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
