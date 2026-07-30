Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9A23E4C72
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 08:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785401586; cv=none; b=jrgfcw2BrQaxAaKVnqxBpCOkw0pDO8WSr4FRtzu8Whhg7XqX37QKRTW6gJjsxFeaGi0I6Jsi+uISyutJm5Fssmy4nLYwRriH80jrLyQ37U/uMKaF1vwWw7g43T0DvTRQsil34AMDyzEOTlvZ9ZFMTc4Fe/mvvuVo2u5Pq6P3+Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785401586; c=relaxed/simple;
	bh=2BdmxP3UvGmpLWqgVPM5x4605csuNvFPacun9QrkpVA=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SOreJ+DMWdOIECXxxW8PMD0angYa0QywVW2Ov4qeMbSq/i8VWdXv30qpT2+sONhFOWfSlIp3rnozq0UdbzsRo3bAV95j2HxVw7K0xB2Ol982fGugB+Ud6IJqdr+JhvbW+2fkg8U7mzA/XD9NNQAKtt8YHDAR7N8mpGIsQAvgfr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAjIacqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAjIacqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058FB1F00AC4
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 08:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785401584;
	bh=pfO9lbRcZyOaISByAFQj44DKb868UDJ/vCL76qkWXGk=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=IAjIacqkvbdxj5XvnTUfyjTL9zdBjRZUxcUKZPbnpx6GWJHYJW42R4fBb680clQJh
	 oejgyHOU6iKP9piQqaQZryQl9fHgMd5HwHseFW63ExbLjjMnByJB9QhUqPlE/AK9s6
	 4llM4mpIyaA+8zgpoifApdnK9d02VIeasNiMzXMWsNs6oEGNxgzgAlfD/E01OmtlId
	 Est+E0ChZsE3HaKswJbjOew458MltmcKSjNH68GdcST2sA73pi8Y7qWjc99nF3N8jw
	 a6pgmCNGIVYq0/nu5Q+ZvkxIMNMqo5aQcjDnEjRpvMGAizfuGQ/PsM1VK2xQsk5MaS
	 LZh/0tD/cteGg==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39c95395230so15549271fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 01:53:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqclbWyWJEAtGz4HK7Kx/P9w1Bb8Ozp0xRTLKx+wRHwkB7eysQenbSypFRVxUBiriIxEvlhTI9V5t0hCSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi1XrTayMHjkIaJMhyRTvgnr2E4vntW2cMCb6UV1arpNgKQiXv
	EmTrFEq6YnXC76tGSpbUKhJeXrvED98rwH4HAYbQsFSSeQEn4BFcWHGHVwOrz6LcRPtqCNTP0kX
	xW7krALncfcui6oyRZ5MKEGIHMoEmLHrfxUYsDNdMCw==
X-Received: by 2002:a05:6512:3d16:b0:5b2:a8dd:7d90 with SMTP id
 2adb3069b0e04-5b2db34c86emr398203e87.25.1785401582782; Thu, 30 Jul 2026
 01:53:02 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 01:53:01 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 01:53:01 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <amaTb58-PcC1ePoY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
 <20260717-qce-fix-self-tests-v6-1-455775fe5f6c@oss.qualcomm.com>
 <20260723192514.GA110634@quark> <amaTb58-PcC1ePoY@gondor.apana.org.au>
Date: Thu, 30 Jul 2026 01:53:01 -0700
X-Gmail-Original-Message-ID: <CAMRc=MfeuA7YX8Z=fL4TMQ4kmm-ti6p+M9YOKoS+5ODUCyHZdQ@mail.gmail.com>
X-Gm-Features: AUfX_mxy6VT4QjhqPuTIM395mHjIY26EbWMyTtFE4gfPKJlpiehTCM-sKrNMYEU
Message-ID: <CAMRc=MfeuA7YX8Z=fL4TMQ4kmm-ti6p+M9YOKoS+5ODUCyHZdQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] crypto: qce - Fix HMAC self-test failures for
 empty messages
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, 
	stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Jul 2026 01:08:31 +0200, Herbert Xu
<herbert@gondor.apana.org.au> said:
> On Thu, Jul 23, 2026 at 12:25:14PM -0700, Eric Biggers wrote:
>>
>> I'm trying to understand how this is intended to work.  This uses
>> crypto_tfm::fb.  But this driver doesn't set CRYPTO_ALG_NEED_FALLBACK,
>> so crypto_tfm::fb is actually just a pointer to the same crypto_tfm.
>> (See crypto_create_tfm_node() and crypto_ahash_init_tfm().)  Doesn't
>> this just result in an infinite recursive loop and a crash?
>
> Every async driver gets a fallback by default, unless you set
> the bit CRYPTO_ALG_NO_FALLBACK or you declare that you support
> CRYPTO_ALG_REQ_VIRT (which no driver does).
>

Herbert,

Is there anything else I need to do for this series to get picked up?

Thanks,
Bartosz
