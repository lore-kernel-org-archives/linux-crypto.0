Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE47253B64
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294306; cv=none; b=p3zbLB3NYI96mhtN+n52BGSVzpV5wn1nGjTdL1NSOW+Vegbg4AsYpDOSDMWZTF349T+uk/iI8DZeLOPNzpvHc8171MMiW/RzJBY76cXGjA2xWKWxlkrM1D57pjVN2qCWM4AstCUb+80++AYpvyMFZIMz3U4E5GUwmNIH5A/ix+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294306; c=relaxed/simple;
	bh=RGxC493IbjEEger8hKnkve1PTNTnnMKtNGhHQrFJ6n4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YFNLsZcRM9kmR9RJ1yCKhT6goNz6RzRyko4Bv+6LNUELp93fV7rhPVKz7V0QssDxSf9WIGx173MWP4cqMtTj3fM22EFqrBnO6vNdMqIUx8MFFon5KuzQ7hr+9AqU4qwAQFQk/wlHOlKX1TPIdvPOjSWD1ulLYqDkuv55RYFP8fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CaDGoptu; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CaDGoptu"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-795773ac2a2so16728396d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294304; x=1758899104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGxC493IbjEEger8hKnkve1PTNTnnMKtNGhHQrFJ6n4=;
        b=CaDGoptuO7+gYm/LN+pnZ4lY4/s97m+PbxxS6g+OQ7MfP0XtuFTsk3JNJdV1DQOZ9W
         uA7HXNU2CcLDbSC2RKBVbOIwpy2kdIBMLyMGjSAEc1ODdzSuO60172qeaNpvwJVpTX4V
         6y/vik/koLoiQZnx6e060dpRSS+L0PfcBFtra8AVDmifsvO25de2KGjThl0lgTh/0T7V
         huV94L2Sy+3kqRgFuMKgQRN41uwEMDfYwNw6NGYILd1Ea73JnmKFkiEPQI8ifTj0HqXe
         sKh23vzJmqEl+f+2zTvlKM/Cb+qv+tseikUkVNBUtxHnMoHP4lPGguJbkQw0k+5QZ5UN
         /A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294304; x=1758899104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGxC493IbjEEger8hKnkve1PTNTnnMKtNGhHQrFJ6n4=;
        b=ZvFLE3Cg1Yxk2j03J8tp4UVpkeyfkF6x0dRkPPpPDIABWlutH+SoFeRHxT+AET2Gph
         yZJjejh4T5he5tSEO4jnUHhqPaEiyL9QbOCR3Gyi1efUQ6qwWjMRNlQsaJI2OQd8hmEM
         aZS034EoGq5cNpcCMrUoIwMGLo6WjZlq8oDQ4XmaaA4TWLREmitZzRCv9kxLax6384Sq
         nQGl9Y7uc0QhDKBcor3aJxzZ+GWAJagS50jgbnL1wrMK9sUrEj0Nz88a8wAKrulPP1px
         U2L1mcVk32e2bUQI7PlS1K6j7ovxYkv/7hUv2Mu7ls3//wVx2IFyl2oDoJoaPKyb+7U5
         OCHA==
X-Forwarded-Encrypted: i=1; AJvYcCVVPY6hQZc+P1Nh9mJIWWjLDAmPogoisN4pK9unNG/K0qVGRo3aoHn6FZT7+x88m5/rZLSi4uPG7J4ANp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyHWfYJwNTbWYmNtY6mTbq40rvM0MvmDt+l83jmb/H8aZF2bn6
	gNpCT9xU5EuiwXtrB+XbFrx0YBVWrEvOM7Enw3bg8rWUzxJcZuk/Pvcan12XsXNJobIMnRjFnIj
	Y0nXaVhW95p7BcROGmqxu6BR9WTx4bRV6tQnaUPem
X-Gm-Gg: ASbGncuObpWlbVeefyCkrbhDU++Y+LNsw9DgHDMJ8EJRQNKKCtdzSJb+4oUg2NKXSB7
	A06QhbMrXTdxE627A/pdE7Vd2Rh4p1fRwgWyPTBqG1R5clE0mRJMX/eCExD11REocKUNCpg7lOs
	mRGLO/6eAZwPcz7xTEU5KZTjMfuGZY3ntwcUesq2ieYp8c8CXvsVddHcrE5ecEB6BxwZKB1pJdr
	TnvWD8VD1/E1RcTbJEoZhSrGpO8C1grEdsafA==
X-Google-Smtp-Source: AGHT+IF48Qn9P8ThM/E5RZW+mTL5SaGErQDzvl4ZKUA9/53oJ7O4E+LJZwUwDw3pueAy5SweS7Sy91A5mlwWtXOr9SM=
X-Received: by 2002:a05:6214:e6a:b0:747:b0b8:307 with SMTP id
 6a1803df08f44-79912a7799bmr34142706d6.26.1758294303181; Fri, 19 Sep 2025
 08:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:04:26 +0200
X-Gm-Features: AS18NWDNOJ80ZgwJUanMmHMdQpo3tLnLB0-s453y8IuyYBCYAQcCDLNYEOTyu6E
Message-ID: <CAG_fn=XXvk-okceUAnpwkk5W5kFLecyoNJcVU9Rb3g=M9qA8ig@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>, shuah@kernel.org
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.

Hi Shuah,
Since these are all fundamentally test code, I was wondering if the
selftests tree would be the appropriate path for merging them?

If you agree, would you be open to picking them up once the review is done?

Thank you!
