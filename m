Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F803154426
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742584027; cv=none; b=DwbjTappD5Uk+xXx8eBdNH7d5Yokipz4RaJ/ii83As0MZzxaX18RV0aXufhCDmGdGBa9QlrelINIfbzBtCOmOwIGFeRje5uyXsUue9ujL4tDz/sXMxI/JkpgMJFRuF/TTuRzdGA0zt17lIFoBF4kY51/UNyv79tXpQ+lYWdhBZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742584027; c=relaxed/simple;
	bh=SeXomrHKQfgt7VnrVhTC/3YFrbfLLCzg+wJ6zRDDgLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b63XtNpSaluxfGZK6anORo2ATGAjskoWzsl7GxTcI/TeRuKpAdpGhq+0x5RaNnSius8/+xOfQrOCgcqle7YicYfnLuvgJPeg33gxrnkAat3cKNXjwJ4vX23obeY4i6C7WPOnVi4e7epybvDTSaQ4umh8KWqDSTExZVDt6isfeDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDl9Np6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDl9Np6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC85C4CEE3
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 19:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742584027;
	bh=SeXomrHKQfgt7VnrVhTC/3YFrbfLLCzg+wJ6zRDDgLA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EDl9Np6gCzlQc6n3bB192joYvlc5HQi63vD/SImhyDUhbCpxwHzKaNRrh9iKwraiM
	 CTA00wGoyYqlrKWOhLJWdMcIQWQmJw4/I7y0mFy+1ebSoh0crVIk3Kj4J0LbGfvEd5
	 /ItfuCt8RmJ49/O6Fy76E77sI1KOZpZiU88CxYiRC7qN5Gx9ycFh6PF+j/pt8HRLm+
	 54ZSOs/tTbL1/Uvg2QN0Kk+wDRxVJ3tq/NyqF9l4yvroZliXlRMqgCWo0vtPOR2vGP
	 1YIK79ATVQXAWZ6o06mQZP/QHlqLdCScfzcUTNosAU6ZAXDUIBkDXU7SrNZ8+cEIoc
	 YLT7eP06nko3g==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-549b159c84cso2627450e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 12:07:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YwGdn8EMKjSLOoCfxYPQBvGKLbW303/hPdiIngw38jpJwoR5uCn
	N33bZnMoxCsNoeYacO5NsddcF0cpJNx8o5w5C3MAmnUlprSgy7uD1NP5H9to+c8+qhQId+gjLT3
	7Jef2a+r2xU/ahJE5MBVquEPn96I=
X-Google-Smtp-Source: AGHT+IEzcjFHMX6bdcxyx9wH4jZuZqNlynhAabBb78CVPs4FKRwwH/do8/+UBO5yAwoHVxPYXlyTZt1Ef0cTVQY0cxU=
X-Received: by 2002:a05:6512:1108:b0:549:8c2a:3b4 with SMTP id
 2adb3069b0e04-54ad6486111mr1778178e87.13.1742584025351; Fri, 21 Mar 2025
 12:07:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z9zupEU1itUXzaMn@gondor.apana.org.au> <CAMj1kXGz=nFchp683XqTvKFxLWXebvxMW496awB95L8JUwxytg@mail.gmail.com>
 <Z91Ztqm-qtZNgpJc@gondor.apana.org.au>
In-Reply-To: <Z91Ztqm-qtZNgpJc@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Mar 2025 20:06:54 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHZrHbtEnP9Ubwds8pGOCKkqZ-KeX3GsC-3rKSshKU+Vg@mail.gmail.com>
X-Gm-Features: AQ5f1Jr9kwb3-aCossqyi9gEtO0Ya-QDq6P7iO2oEDH8fGEyNBrDRRnDbsE8A7w
Message-ID: <CAMj1kXHZrHbtEnP9Ubwds8pGOCKkqZ-KeX3GsC-3rKSshKU+Vg@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/ghash-ce - Remove SIMD fallback code path
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Mar 2025 at 13:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Mar 21, 2025 at 12:51:42PM +0100, Ard Biesheuvel wrote:
> >
> > Are shashes only callable in task or softirq context?
>
> The entire Crypto API is designed on the premise that it can only
> be called from process and softirq context.  Hard IRQ context has
> never been supported.
>
> Of course, that doesn't mean that we actively deter people from
> doing so.  If you're aware of anyone doing this, please let me
> konw and I will look into it.
>

I think it's probably fine, I was just curious.

So this patch seems reasonable, yes - good riddance.
