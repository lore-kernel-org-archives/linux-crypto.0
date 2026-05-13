Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE85384CD2
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 21:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778706512; cv=none; b=QEk/8+6vB+WRq6vXVV5MKmGpK0fGWxzbPAvC0IQU6h4cC9pClgjbare9Sww9e/jCpn+LNOwyeu9dLsyNM5ePVD5fGVsYCWjZimKwSTsDpPBHHphB7L4CfhJ7mcAdtZoDm+578hLyDjHaprTiVma8xy1vnieqmtcj2m/wxE1amfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778706512; c=relaxed/simple;
	bh=QTnfFdk6Ou6qx4/NP97q2rkM2PR+aFaKRRwo++mRCeA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCBiGLLagCSVRKb2sQY3JgJSbq0MBd/1gL0i2hOkGiOCsKewzLcHo7/Vg1NdkQ0jIwqO9OEBoAWfDeAf3GXM2DKhSXY2ZM+y2PnWhjsJ2xqdTAA+5xtxjbo0Qwoq396FL/yDqqx1qOiPphToPnu4ibwuHUU32Pqfe6b0spXfGB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bw9Rsze0; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bw9Rsze0"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45d96d21e82so191869f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 14:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778706507; x=1779311307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoCZ/nzaYrByUCIKabpsWTVqU7hdllfpMNoIhC860eM=;
        b=bw9Rsze0QKCdizARKcG4bkhj7dsmWVj9e6dEdw5nFsyZ2QCgy0epj2c14MN03DriUW
         TZC5dQpOS32vvtCd3gYJvJAhC9G2NK0/aF+FTaM6uq6S2BMZ4lK5470fDgDKnkDrz+r1
         xJzOpLx9gUHV/DOoos5BSqHY1yxWH1FJuvBVYFunXxRRlD60t05gbZUJU/1thEtknbQQ
         G14Ooyegv8gg13PkK6tvHMJaFkUpjJlBArOcX8/dsnGul9uEF4glTenqG/0rYHfrF6kt
         1eKzGXs791wtXl3sD2Cd3s5xN0d0cx4RWtab5svcwsVPuPCVSgd5/I/HJMlBTcdqKshE
         yL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778706507; x=1779311307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XoCZ/nzaYrByUCIKabpsWTVqU7hdllfpMNoIhC860eM=;
        b=OXpq6oQd9Gpd293r0AL2nb36qObhSMZQaU7zyt3wbOyvem5HhEkKBOoFmoixIsuL4x
         UEqHjZJHrd1kS8fVAQaL7TYot6uIK10p8xdg4Xt54caCnAcLFQ4RdDnZIjkEpi2ZbjSA
         o8Ntmz5qiMG18D/kN1KmPkjHLFMXf/+v3GevK17w/5PI+Wp7N3cyxPIBfpm8ah1YQuxq
         yfCzOI4vdVqUSjhvRMMRhmdge4QFFFZj3/ayfZ/noCbkMu+NBRhopi+Atn9G9/kiARyF
         sJZUOHKbjohCnsG64dDiMhKTEs1U1bYjg7hvWrAZw3sWCjmMzpYqe9Q2G8iT8jDgqlHk
         3bUw==
X-Forwarded-Encrypted: i=1; AFNElJ+C2sjo0q6WSJ3zo71wo4YfCwHj1kDO46ZlmyO3NXniAmOpZRdGAz/yjZukh1t5jRRpuuvUduW54Pnm1t4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLdyxSj/4el0uRBfq8GJJfhSRUQg2vfV2vnlHw4oRalYmsseOZ
	SwrQKZK4ctv1aDVKWs/xH7Ep/ohtmpyQvq5/pQvjJXfpnCNky7X8xDhfZwsUt2mA
X-Gm-Gg: Acq92OFKCiWC1wwPslP80Uz2OT5LsyXLJCaRncXE6ZU3sv2diuaL7v0j+6boOEsPKEt
	GVHqQMJNt3Q0zgfbs7AfsXv5jeO6KNJMdJyleygj6jPit5mi2DJIvj0ktLsudm/iERDRzFAY9pC
	M2uDilYH2cwLffSsVE8ZUiAvmgNmpiOXvOTMVLLvbn2qgT8WRdkxWZbUR0Y45dNu44JbEjmBb00
	42tjqWl7cCDeKfKncclX5FFWRi2dyzkQi7TuLZdy3hvLPV/VUUD5tvVR8Z064hAujCaM5Jbn0vp
	KI7aalwu0+m1yGglX3LFjOiuMYZ2Y1PoqJ+B8Luvo1EiJe7ZbtK0NPXV5iGncr/scP1v/nU+yl3
	fh8Lw2bFtRKg4Hb6dDPmCicXeNtH8R17AD+Fuz+Lc7hPpxFckfqKh+s1it4Iz2adMvlJV+BHfZG
	+7DHwVKBBL1UhkAa1KwOSgfCfDvmXC66rSFJ79HrUWmWrWabVsqSuxNJ3MMF5S
X-Received: by 2002:a05:6000:40da:b0:44f:d9f8:c0e7 with SMTP id ffacd0b85a97d-45c77e635bfmr7157222f8f.5.1778706507141;
        Wed, 13 May 2026 14:08:27 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a17ec2sm1312367f8f.24.2026.05.13.14.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 14:08:26 -0700 (PDT)
Date: Wed, 13 May 2026 22:08:25 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Qingfang Deng <qingfang.deng@linux.dev>
Cc: Anastasia Tishchenko <sv3iry@gmail.com>, Lukas Wunner <lukas@wunner.de>,
 Stefan Berger <stefanb@linux.ibm.com>, Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ecc - Fix carry overflow in vli
 multiplication
Message-ID: <20260513220825.0d10d80f@pumpkin>
In-Reply-To: <20260513123948.842-1-qingfang.deng@linux.dev>
References: <20260513105741.55534-1-sv3iry@gmail.com>
	<20260513123948.842-1-qingfang.deng@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 May 2026 20:39:48 +0800
Qingfang Deng <qingfang.deng@linux.dev> wrote:

> On Wed, 13 May 2026 at 13:57:40 +0300, Anastasia Tishchenko wrote:
> > diff --git a/crypto/ecc.c b/crypto/ecc.c
> > index 43b0def3a225..6eb4d97a5f0d 100644
> > --- a/crypto/ecc.c
> > +++ b/crypto/ecc.c
> > @@ -393,14 +393,26 @@ static uint128_t mul_64_64(u64 left, u64 right)
> >  	return result;
> >  }
> >  
> > -static uint128_t add_128_128(uint128_t a, uint128_t b)
> > +/* Calculate addition with overflow checking. Returns true on wrap-around,
> > + * false otherwise.
> > + */
> > +static bool check_add_128_128_overflow(uint128_t *result, uint128_t a,
> > +				       uint128_t b)
> >  {
> > -	uint128_t result;
> > +	bool carry;
> >  
> > -	result.m_low = a.m_low + b.m_low;
> > -	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
> > +	result->m_low = a.m_low + b.m_low;
> > +	carry = (result->m_low < a.m_low);
> >  
> > -	return result;
> > +	result->m_high = a.m_high + b.m_high + carry;  
> 
> If CONFIG_ARCH_SUPPORTS_INT128 is defined, you can convert them to
> "unsigned __int128" as done in mul_64_64(), and use check_add_overflow()
> to get the carry.

Can you guarantee the compiler generates 'constant time' code for
any of this?
If you care then relying on compiler support for anything that might
generate a conditional jump isn't a good idea.

Just writing 'bitwise' arithmetic doesn't mean the compiler won't
use branches.
Even if you don't get one today, someone else might get one tomorrow.
IIRC even on x86 'x += (a < b)' can generate a branch rather than the
obvious 'cmp a, b; adc $0, x', or the longer cmov or setc sequences.

You pretty much have to use asm for anything that isn't trivial arithmetic.

-- David

> 
> > +
> > +	/* Using constant-time bitwise arithmetic to prevent timing
> > +	 * side-channels.
> > +	 */
> > +	carry = (result->m_high < a.m_high) |
> > +		((result->m_high == a.m_high) & carry);
> > +
> > +	return carry;
> >  }
> >    
> 
> Regards,
> Qingfang
> 

