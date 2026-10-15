Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC222882AB
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 05:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792041525; cv=none; b=Hb/n2jx1kTN63DJHCNJFTLUYcS54VEHpjfzH0wyXFDmov3WWG2XjZLIJFvrWvhl6/gY3c82dN6iaYncYhEvwe4ZjftpXqUW6g7PdBCsEJzByaP8sbfLqwJRAA57+HWLwHfl4MiTY5h2irTpXvsziYdmMsdo7rNv7WW9JVnWdhbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792041525; c=relaxed/simple;
	bh=9t/6UgUaM3zu5+pSU9RyHJtRpDhvkOn4SysHGOLElHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YSYSJb51TqGTmp9rX4MpwhjvnELqz7nT4bpgCJ1da0ZBJkadaj68s7G0zDEuDa1aqCJhMY0CXQM8uLr6cExPjgmjv0GzAaJuHLqGImReBUUa8GxgIHJOjaMRMxA2nBvqpYsYedH583MCVLy1uciKOKZI4iUKT4uo8wdC8btVbm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oABBbyg3; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oABBbyg3"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35ef6b49813so982297eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 22:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792041523; x=1792646323; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z6Pw1hNQK2+gggiLI8jmYSYl4DMnm2i3W0kXD2qU3oc=;
        b=oABBbyg382nTBY3G9XYPQvOftXbe66048x3GkypJAHfRVM50eI1kduAgC6RYMbu2eI
         mEGEyt/SFsmUTCrBvg3uoiXhUuKeMjBlDU/c17xHB+jfp4/SygZVjzeN1AXKzPdffvob
         WjOmPefi7TkCxP9gQs9/NDBVeVXB1tYxrnF7dmd2Ri1VJaNAmEa6VkNpNRyuUrYdfAYY
         5M4LhhTMEBIM09VPHB8yNY8KZmv0ZyplByMqiyVEpbq2cYfu9rVtX/Z1b1IT7/uE6nwQ
         14S5GniOr5b8a4pj7hwvl4mPXbUcPH40fecYuQL82NT0RWlrtQir39krfs1ly+qKUH/T
         A1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792041523; x=1792646323;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z6Pw1hNQK2+gggiLI8jmYSYl4DMnm2i3W0kXD2qU3oc=;
        b=PGSt5V6ESLlvzJc9maL3+ITT3djN2vc8exJmCo56C5saFDEak5PgMgz6+I9qzG+vgz
         Uf1FAyqKWw5CVplIfnYAC1hkTxe/vjvZdAEJjF0oZqbCybvfGlwyzd8mVtLJCywQDpy0
         kX7zAWcCHY+eJYvisOzF/xzoZFRY0KtggkZtlMojukSpznHRZ5IJJGTrpnm7dXuhuzke
         LXYO/MaNe7u7EfAcadn0XkMuWzGhI0VT8yHvCAimIUhwtW1fkU0iFivFIMfJpHSCxKB+
         zSMqzHKsY1d9H1c1PeejcGCA/Va0aHOMCF5ME/Ygvd6W4nEItHZ8hxNliS7X0YdGtheL
         75dw==
X-Forwarded-Encrypted: i=1; AKwUvBzmiUCs28WzNEvl8oXDKcQixnwpxl1XV2bmfxKhR3uABdVJiWW8DIODIcuPliowGpFWGvsbyQ+PpNs5NBs=@vger.kernel.org
X-Gm-Message-State: AFq9FYIJKNL4X+OgZVZZKC/M1xOgkEJIoVCBOGEPipFdolpKmPAL084h
	uafBLYr+mp2IMf89mIX1/MBi4/wBr1o1/9hwNfFus0sWBRyqIrh/Yt80B9Q3Rg==
X-Gm-Gg: AYBFou2LFlQujG1ouZ5AKaV33tdOWT8aphjO+MUri9vfFVZHVZpnk+XQMklB/ZLQVPg
	+hcoP/Yi3mY9LEqvW+Pmx8B0JKqu8JXsl7KJXnxWeCfsXp1oa3WyUPurUb4tvs2HEeN3CTuVCvM
	cp9grHbhWipXIe76ONStDuqY9yVVcIRxk1OSZxKSSWxPxPSv1wf7qVwqq/pEIPtKA0s13YgKKOt
	3O6aHWNi07ab/nnDl3usQVqppuc3QV8T7BXeedApHB63RnXKhmlQCa8FYMLecf4ofKbn5LvMR+r
	cOk5ECQqUu1qfO+Qc/Gzq5uk+VFvpEgs05elWCX7ekcEyIHupK3RxWsgno5/+X2sJRTaSJ38Yqc
	jIEl2JhXMirGG5JB5odsu4qd+BRqSlojv+lSfRdFV3y2KPqjVP99T1sLKYDHMpNpEbvj9S/Rf6H
	YlZRNGGBqvW+60R8QxTfZmHf5fUjf9I37ZfqXNJNLMh+CW2PlVm94ZLBgNZ/BvKEzcRqyLnJdZL
	l/7OnXD+Lx8kuE=
X-Received: by 2002:a05:693c:2a12:b0:35d:2c2b:215a with SMTP id 5a478bee46e88-35d2c2b2220mr7701428eec.35.1792041522634;
        Wed, 14 Oct 2026 22:18:42 -0700 (PDT)
Received: from kernel ([45.251.35.75])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm42929176eec.11.2026.10.14.22.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:18:42 -0700 (PDT)
Date: Thu, 15 Oct 2026 10:48:35 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: ebiggers@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: md5: correct header inclusions
Message-ID: <atBiK2z2MKCeg-YA@kernel>
References: <20261015033843.6056-1-raizudeen.kerneldev@gmail.com>
 <atBa776tU-O1Qg-T@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atBa776tU-O1Qg-T@gondor.apana.org.au>

On Thu, Oct 15, 2026 at 03:47:43PM +1100, Herbert Xu wrote:
> Mohamad Raizudeen <raizudeen.kerneldev@gmail.com> wrote:
> > The file uses 'rol32()' inline function (inside the MD5STEP macro) but
> > does not explicitly include `<linux/bitops.h>`, currently relying on
> > indirect includes.
> > 
> > Also, `<linux/unaligned.h>` is included but never used, as the code
> > relies on direct pointer casts.
> > 
> > Add the missing `<linux/bitops.h>` and remove the unused
> > `<linux/unaligned.h>`.
> > 
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > ---
> > lib/crypto/md5.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
> > index 3d2b017a0525..a838bb90103f 100644
> > --- a/lib/crypto/md5.c
> > +++ b/lib/crypto/md5.c
> > @@ -13,10 +13,10 @@
> > #include <crypto/hmac.h>
> > #include <crypto/md5.h>
> > #include <linux/export.h>
> > +#include <linux/bitops.h>
> > #include <linux/kernel.h>
> 
> bitops.h is redundant because kernel.h already includes it.
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Understood. I will drop the bitops.h addition. I will send a v2
that only removes the unused `<linux/unaligned.h>` include.

Thanks,
Mohamad Raizudeen
