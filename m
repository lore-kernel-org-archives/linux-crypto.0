Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E534E3B14DF
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 08:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786522064; cv=none; b=q1llpIXuv/An5qNyPICp4mgQMnyRdvp5WYJhR7CJwip/K6jH722UljBJGQJGI5h9cir0lUx6+T+sqRslk1ISyvPslpTlyWrAcDiYTGzu+K+SoKIGr/lMZU+Hfs7EwAcBz/2b2FmPLcZCAGFzEUiTyYjrHvm5jM/XceLf0L3iwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786522064; c=relaxed/simple;
	bh=phtMQBSWxti2FtrLAu7NAAGr5W/iDboRvSWFz940F10=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQAJGGNhWRho5qzrweTf99EvruzqvN5YamlGn6ITb5pDdcGfXYrIosEU/E5tDVG/j9ZXgFe/AhRZicOweGU+4EIGDcvl4JfBUzmvgQqBA4xwlXbyXXJhEmBjvI2AhHBqL2OwW1Jg+YTdK0oo4eMPq9pOFpRjayqjsSVdYYkav0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Onedg4SQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Onedg4SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CA61F00A3D
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 08:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786522062;
	bh=h8e/6oz7HT3XGeTxfmCmaaxs2u9xqMmsHSHBOLgeCac=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=Onedg4SQJKw0lKgmzutiivqk0laLcNuhJ0JyknizYv2W7tRuCbYj5AL9WCkkWj9uF
	 G7LSU5Hnoifmg95Ej+miCVwKr2tULhHxbNCySmmjz+zFqOLWGHVodWVbcyC+mVgrJv
	 yUiPHasDPYRFew8QcAOFj4ciYZH++aRUtJRh9EoiNXp2uqMrJc3DPO8SOitg8sOt+j
	 +ozOd3EtnZ8PF8eNvGCsHmc/T5U+AAhQNhRVrbFTrbsbIXGChXknN3HXV8q9CQ8CZ7
	 Z1bl9NIjpmvDuJZiw/hV1IPopbVlJc4mcYjYfAQMgyMp/alVeiNKunj82VdvnO8iQy
	 68QNNlwmzLlKQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39f20d19895so5376831fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 01:07:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RryWX5x+dadVcfe3eFU+Vh9JjhkgonOjFZyCddBU2eAd3NPAeH3IVGjbQ41vHh6iuLb3FV7pvaR6wTQEvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR7yeh30OhcBOuOk345eSM29jdOfCscM9TU6zSQunYarZJ+XCC
	0vcmcTOrtS6Rgxt+vnzAU/6G+13a5T60p0Xy7l9qHI6Zr6MK8uSxwNULq7pApzOweTJWjjSWzUs
	YYOpXRuCwc4pBNflFwnNMgN0L75GAAYIfch4BFPUA0A==
X-Received: by 2002:a2e:be94:0:b0:39c:7922:b446 with SMTP id
 38308e7fff4ca-3a10d57ffa2mr2776991fa.14.1786522061234; Wed, 12 Aug 2026
 01:07:41 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 12 Aug 2026 01:07:40 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 12 Aug 2026 01:07:40 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260811224110.GC1905@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731050838.158825-1-ebiggers@kernel.org> <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com> <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark> <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark> <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
Date: Wed, 12 Aug 2026 01:07:40 -0700
X-Gmail-Original-Message-ID: <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
X-Gm-Features: AUfX_mza5iszjfEYHc7a-SULX42xVaS3ZTvYWTguGELO7PtuyXidmfp9nmIXTrA
Message-ID: <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Aug 2026 00:41:10 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Tue, Aug 11, 2026 at 08:42:55AM -0500, Bartosz Golaszewski wrote:
>
>> No, the rationale has never been this. FWIW it can be that it's used for
>> testing of the crypto module on a supported platform and that is already
>> enough of a reason to keep it upstream.
>>
>> As I've said before: we don't just drop maintained drivers from linux.
>
> We definitely do if the drivers are not useful or appropriate for
> inclusion in the kernel, though the policy varies by subsystem.  Even
> just last month an entire filesystem got dropped despite someone wanting
> to maintain it.
>

I suppose you're talking about EFS? A thing that can't even be tested on real
hardware? This is a much more extreme case. Here you have several people
representing the vendor saying they want to keep and maintain it. I'm fine
having my own tree and sending PRs to Herbert if he agrees and you are of
course entirely free to disregard any patches targetting it.

Thanks,
Bartosz
