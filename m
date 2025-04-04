Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA4033FD;
	Fri,  4 Apr 2025 05:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743746155; cv=none; b=SD8L5L2g/p4ADS27x3TUkeGthzjXROXyyni+KCSv1lp9VLqPTw2SHsC6X9HKsXwyQNRgG6rF7X2OVtOrDXuGyP7FTaS6ZpPf6woPUmIza/uQmtMcCz9pSWbgbd0UWPcyj2zmFOfjH2JxEUrVGbAry+MxG7oHtanNE9Ktyiw/Qdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743746155; c=relaxed/simple;
	bh=m3Wf1exXRQJ0ctdB9DJLeYyEFT0zavPZvNni4xpRWm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQvbB4Qa/pjVfifZ8T6VCMbDHJa4z8gKb3c8GmNXZXqjPVPh/EdzaN+W7Eo/rv2fmKYXHb7bjYePwGcLJVUxPlouvXM///e5tpudFBgpgb3CxJ/t3OOB6p36P+W/NoTf8liyyqLicOI4uEYn16AtktHfpxUdrXlssgJltQaoa5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMnkIA6A; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMnkIA6A"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-307325f2436so16886161fa.0;
        Thu, 03 Apr 2025 22:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743746152; x=1744350952; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4m4Lgv/G0HSWsRrxvRHFcyOI0AOUZXlAU03wGqymqg=;
        b=HMnkIA6AEZaCdSoe+bo2VKoCAI14RgK7eore8JvxQVz26DcKwNF85hxrKAkTrbcvDO
         KH1fYI9JG9iL1eDOuZEltAzuyVDhB23Gua64LnWJjAUdQDng62pqq/131t42OD2q2SqV
         fvY9FhsLs9RsCjFUghEWX5O+CUrNSOMyPn5fPL14ygg86mLOy/CCDbl3FlaprmfsVoGd
         6q+Ld54No6v1YZNK3L+H+NI9PAsfX2z3dRIUBzI4gFewXwm4Osj7rOkwgn6Vblb1bCk1
         crQIRXu2weBU2I5+xqeyMgCYhdgLplmGcfsnJ3ASBgBG32H0+q5Ckb3dP6/h2uFejG2Y
         K6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743746152; x=1744350952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4m4Lgv/G0HSWsRrxvRHFcyOI0AOUZXlAU03wGqymqg=;
        b=jmUZRgwbOG/E3cwmxi+vpJ1reorwQFelHmlT8fekEAgpBnXNA2D6U6yu2zMfBigNt2
         q3vUtDduY3Ar0zsaWoYxf8NBla3Y9Fk5HN8sz37sxVHYnPuaomUMyOAeJg/4e9joyhOL
         0oVSLdXdmIFbh1Y5lUj7mTo9VtMijQM5MFTnR6jlKuNzWfOK9MaSB7u9kaDofN0sk+98
         qbMrWxSWw3fllUBsY6miguKJsr3q7FMqRsFMZojKIFx9AQUAVi5LEdZGqJc74zM5OywK
         tYZgR2e4F0XuoF8SeoEBr/bSPHNDAyfIUf33fGO3taXEjtxbq9oXJ2iOmunbnb4UCvuF
         N30g==
X-Forwarded-Encrypted: i=1; AJvYcCUI7aCfLrHo/qzrX1KtPqalWrSYu6OQfXO3ynJB2EMZiGaDdzFtikFcDn9qBeOy+j0M63Yzr73JcMg5UMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEXr97snYU6Yyq9l4wKc1GCNkbUyW9SKJhbGcljCFjV+uMOUqy
	rBimD3m8Uc0wY+c0psAU3a4r6EQNc0lTJ5KuuXNEpt6WfipK9L9FY/5RnlltjrBEMQnRUsqMUDS
	CIbl+4AY3dM2yC9NpdDaflbXWkCw=
X-Gm-Gg: ASbGncvBtoStisP5dkheU+tUPactRBeR/ln1uRznyTME4fQ7zNJv/kX1u94wIPN9hAm
	v6ZQfauvygrFwJBlS358VNmL77MPkq0SYmcMKf5nFARy5q1LPp+prC/2bAkDOAijfQYt5OMMJyI
	lPKWeSE5EpARJcVljRVy5fNl6ykg==
X-Google-Smtp-Source: AGHT+IGTy1lG5z/lKToJqLPpKeMMyAygaCW/W5NO8s5KV8h/yzeNHSQV1ViJFpeSbZCYHzC1pamHt+ktBZwIl25G9jM=
X-Received: by 2002:a2e:ad92:0:b0:30d:e104:cd58 with SMTP id
 38308e7fff4ca-30f0c08d73cmr3440681fa.41.1743746151616; Thu, 03 Apr 2025
 22:55:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403094527.349526-3-ubizjak@gmail.com> <202504040855.mr885Pz1-lkp@intel.com>
 <20250404015112.GA96368@sol.localdomain>
In-Reply-To: <20250404015112.GA96368@sol.localdomain>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Fri, 4 Apr 2025 07:55:40 +0200
X-Gm-Features: ATxdqUHvxKjaAuNJAyKxretVYKicCee6aHgEDOIqcSNJgt7UxehAOrZAXyC0sC4
Message-ID: <CAFULd4YrG-7DCXabke+uuLwLw2azciogG1nPGeAkMxLACw+0og@mail.gmail.com>
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	Herbert Xu <herbert@gondor.apana.org.au>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 4, 2025 at 3:51=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Fri, Apr 04, 2025 at 09:13:40AM +0800, kernel test robot wrote:
> > Hi Uros,
> >
> > kernel test robot noticed the following build warnings:
> >
> > [auto build test WARNING on herbert-cryptodev-2.6/master]
> > [also build test WARNING on herbert-crypto-2.6/master tip/x86/core linu=
s/master v6.14]
> > [cannot apply to next-20250403]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/cryp=
to-x86-Remove-CONFIG_AS_SHA256_NI/20250403-174814
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptod=
ev-2.6.git master
> > patch link:    https://lore.kernel.org/r/20250403094527.349526-3-ubizja=
k%40gmail.com
> > patch subject: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
> > config: i386-buildonly-randconfig-001-20250404 (https://download.01.org=
/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/config)
> > compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20250404/202504040855.mr885Pz1-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202504040855.mr885Pz1-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> lib/raid6/recov_avx512.c:382:2: warning: #warning "your version of b=
inutils lacks AVX512 support" [-Wcpp]
> >      382 | #warning "your version of binutils lacks AVX512 support"
> >          |  ^~~~~~~
> >
> >
> > vim +382 lib/raid6/recov_avx512.c
> >
> > 13c520b2993c9fa Gayatri Kammela 2016-08-12  380
> > 13c520b2993c9fa Gayatri Kammela 2016-08-12  381  #else
> > 13c520b2993c9fa Gayatri Kammela 2016-08-12 @382  #warning "your version=
 of binutils lacks AVX512 support"
>
> Yeah, CONFIG_AS_AVX512 needs to be removed from lib/raid6/ too.  It looke=
d like
> that directory was rolling its own CONFIG_AS_AVX512 in lib/raid6/test/Mak=
efile,
> but that's a makefile for a test program and not the actual kernel makefi=
le.

I think the best approach to avoid patch dependencies is not to remove
the test for AS_AVX512 from Kconfig.assembler in this patch, but in a
separate patch that will be eventually committed late in the merge
cycle (or for the next version), after all other users are removed
from the tree. I have patches for other parts ready.

I'll post v2 of this series with the above adjustment.

Thanks,
Uros.
