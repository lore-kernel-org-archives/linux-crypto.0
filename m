Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AD1405CC;
	Wed, 22 May 2024 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716374075; cv=none; b=Q8wFvg4Pntvn/01sIIJPnEZt0Kb4dhGfw3iqvBz5clNJdkXPa9QRKKiEfMFqy8yG+fKN4yTsi9Ghmn2khyTe0q+bXo2GTHD92ZGAD133V5H9Meaxy0xV7arLksjEpiAL61aeHXdB5QZTSLBdDdPx+aUCD6H+Cg4Ko0kFq7I2gyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716374075; c=relaxed/simple;
	bh=Vp1+puQ8lIm8PK3Dju+ML1u9LvmdCOMYuUylrLAQ0Tk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FY1T1ikLbE1u1zxUawKW6hzWr1ob5xtoKpLk0j5AqZzhMdEenSqrEzPDXR2x2iqwEz7QymyIbwDHvoH0cCpHlTEmRNP5Sq6ZPGKU3Bu3uXJCTSS6uG0B+MLEcalIhikdu6ERTr8CCskweRIIkyvUxqd/CbsOm/75hQbUpNxQUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9kUS2Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9kUS2Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07338C4AF0A;
	Wed, 22 May 2024 10:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716374075;
	bh=Vp1+puQ8lIm8PK3Dju+ML1u9LvmdCOMYuUylrLAQ0Tk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J9kUS2VhmL9oq3jqJJBQWu6gPMcjQkQ3r1jbNd2BsoHeFTMfmUT811kYpbeblAmHm
	 MFpSpQiAWrMvEOjjF0Z5kiBFIZtL9JOn8UURDXyV6g6p9a7DHxpp0yTCOKvy3Nmk07
	 2nSZGGdnRhwtQPEFw6M95k9WaI7w7hpEZl3wpDmgMkg11vYNygVOziELtYD6AFBRh+
	 68+v9W4k5fHHtErYADnlhTRAQM69huuIbp9dIlXnUhcj2dhkuJMtEz+NF4QaHWdjQc
	 f8ApOwYysteHiSGuzgCXVSi/zAeQfoVROH5ggr6ZYd/Pvq2B9P4NZQ+6hpjZe5GOL7
	 YSvcg5fY40Qpw==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2e1fa824504so59516371fa.0;
        Wed, 22 May 2024 03:34:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW7vqXp32AJES10m8s1eY3wx4R+Tpifm6Pr42iEX88NofgtlTZa8aaJkUu9mLVbJxhubOjgk9DYVED83KJOctIJEq/U9xXv36p1O84+uat3CgERDP39eAbw8NBmE5nB4FM50fAj8yZT8gI2
X-Gm-Message-State: AOJu0Yw5ELUdnqK3PEc6J9cVNITsqKDYsco0TNvkRrfHEeXtH8J2EnP2
	4FgOGaAfTAnt1+l/BQ3kt40+Cmg1JrNFChgMr5de4yQJ2W7PEgWQ3WvwHDjdKSyySehf4gFpYTK
	IccRMDj4YHPec4wb5/BK1CLfLnag=
X-Google-Smtp-Source: AGHT+IH+jNZxvIPnlSs8TkStRsQm3U7USVGW+hq4eFIvUiVOZaJXMQxX0rxM/CU1kANKXl8vmW25kOlLriTekpqYRLs=
X-Received: by 2002:a2e:8711:0:b0:2de:3ec7:8887 with SMTP id
 38308e7fff4ca-2e94946eaafmr9149841fa.18.1716374073269; Wed, 22 May 2024
 03:34:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
In-Reply-To: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 22 May 2024 12:34:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH6ijtvyGbh9ftEJ+PSWa9oaqZ1BbobGDEWZcV_4L8MwQ@mail.gmail.com>
Message-ID: <CAMj1kXH6ijtvyGbh9ftEJ+PSWa9oaqZ1BbobGDEWZcV_4L8MwQ@mail.gmail.com>
Subject: Re: [PATCH] arm64/crypto: Raise priority of NEON crct10dif implementation
To: Mark Brown <broonie@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 May 2024 at 22:23, Mark Brown <broonie@kernel.org> wrote:
>
> The NEON implementation of crctd10dif is registered with a priority of 100
> which is identical to that used by the generic C implementation. Raise the
> priority to 150, half way between the PMULL based implementation and the
> NEON one, so that it will be preferred over the generic implementation.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm64/crypto/crct10dif-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
> index 09eb1456aed4..59016518f44d 100644
> --- a/arch/arm64/crypto/crct10dif-ce-glue.c
> +++ b/arch/arm64/crypto/crct10dif-ce-glue.c
> @@ -98,7 +98,7 @@ static struct shash_alg crc_t10dif_alg[] = {{
>
>         .base.cra_name          = "crct10dif",
>         .base.cra_driver_name   = "crct10dif-arm64-neon",
> -       .base.cra_priority      = 100,
> +       .base.cra_priority      = 150,
>         .base.cra_blocksize     = CRC_T10DIF_BLOCK_SIZE,
>         .base.cra_module        = THIS_MODULE,
>  }, {
>
> ---
> base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
> change-id: 20240521-arm64-crct10dif-neon-prio-894a9350ec1e
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
>
