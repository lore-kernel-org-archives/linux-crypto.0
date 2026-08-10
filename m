Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF23B95F0
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357435; cv=none; b=F8KGdVH5qi3uVVGocdZzsgeGUDppZBe61/P8KdoYZSequuqbMq1zRCwoELUAQtkyl8l/bVJT6PubuYyXbNaA1ZmisD7U9anS/Gj2fEvRTusFXyTECn2YJgVZvtAUB/l/EQp+ry6SfiPpfj5/lKBkM0yJSGqoy+10ZPknw0fV6o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357435; c=relaxed/simple;
	bh=wpv7yCZtqzGpymgIBpq2xprUOu/HO+Ii+2myekc94UQ=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KVk4MFQy42B0XAaIfEejpkobst661FPf2OZDw1OQ1YiIgMcizI8o90wnMGt2maPsJiUChrk4eXiZgDkG0YP1sbWdwpvAPwE8QCY+BBYtwM4L5JrjzQHcIkg9MLO4vlK5PS/zIr/FKT/knQBIPTHc4V7vhSNusigShpR/8auEbAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVBWMh7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVBWMh7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82801F00ADB
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 10:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786357431;
	bh=VXlJ4MRsvdw0tt/TAbvwG9Xn7DOulcryLzjZ1Z/C30U=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=aVBWMh7URy4oytN7JSCODkv8dmyfCEXc/eyg5gaJLSib1XtThwSy6T5JB6WoeAf08
	 qRGuFB4Ty3wuF5TcN+F35eDqp+zyqIezELUk3gF0S8cjbKQ5n1W6Jq4g2NLgCDF2jb
	 LvWDmUqz8LGbNfQyFTVhkgBOFBA5Y9MLyVz7v8CEcKa6afg1u6WSDdJojWIzqNEdO4
	 /1Mc+7qidTJb4fau096gBww36pHcV4s2ZXUv5J8Goxx7pFeYihwuMVvNuSpeBNkJ3p
	 Q92YodrErGSIAKCBVew6gahb0f3Mmf2zhNI2cBaa0WDZ1ZT1VMNAPKnhz+kUb9zO54
	 qMRDG6naw2ezQ==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39ca0a30148so13415861fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 03:23:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqr+nZziVVUv6flkcria3Ad3USYDDqSp65DOUCjGKCEkgFNnUTTv0F9V3cu4RvnRbJdKXfAVEs+m9PHtwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJb4IoT++cxkmKoMURs+MxYv7t2wWN0glBvyHVWy/2lHtss639
	F2P4JJw+bHb1VjNfoHb62T/E8sVaVtzBuf4bTWxl5CmyL4j3a1++PGaoHSzGYDV+SP8NNVtNFlY
	Fg00zlXwWVZhADB7XRwPCgmGixJTtwIofAeUqThhK1w==
X-Received: by 2002:a05:651c:a111:10b0:39c:f58e:5c74 with SMTP id
 38308e7fff4ca-3a00e9bf925mr750931fa.22.1786357430361; Mon, 10 Aug 2026
 03:23:50 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 10:23:47 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 10:23:47 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260807065454.1640815-1-md.alam@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807065454.1640815-1-md.alam@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:23:47 +0000
X-Gmail-Original-Message-ID: <CAMRc=McDAt5G9-mJSY15oL6vQT+rcOFK0cj+bnx7kk93WooGPQ@mail.gmail.com>
X-Gm-Features: AUfX_mwYz2T3Du22q1EW54KFvAX6iEvMhf5BShH-BcDYhDcpydM1MVdnkBjtNho
Message-ID: <CAMRc=McDAt5G9-mJSY15oL6vQT+rcOFK0cj+bnx7kk93WooGPQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce: fix CCM AAD buffer underallocation
To: Md Sadre Alam <md.alam@oss.qualcomm.com>
Cc: varadarajan.narayanan@oss.qualcomm.com, brgl@kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, thara.gopinath@linaro.org, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 7 Aug 2026 08:54:54 +0200, Md Sadre Alam
<md.alam@oss.qualcomm.com> said:
> The AAD buffer allocated in qce_aead_ccm_prepare_buf_assoclen()
> can be smaller than the length later programmed into the DMA
> scatterlist.
>
> The allocation size is currently calculated as:
>
>   ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN
>
> while the DMA length is set to:
>
>   ALIGN(assoclen + adata_header_len, 16)
>
> Since ALIGN() does not distribute over addition, the allocation
> can be smaller than the DMA length. For example, when
> assoclen = 32 and adata_header_len = 2:
>
>   allocation = ALIGN(32, 16) + 6 = 38
>   DMA length = ALIGN(32 + 2, 16) = 48
>
> As a result, the QCE hardware can read beyond the allocated
> buffer while computing the CBC-MAC over the associated data.
> The extra bytes are folded into the authentication tag,
> resulting in an incorrect tag and causing CCM self-test
> failures such as:
>
>   alg: aead: ccm-aes-qce encryption test failed (wrong result)
>   on test vector 8
>
> Fix the allocation by adding the maximum possible AAD header
> length before alignment:
>
>   ALIGN(assoclen + MAX_CCM_ADATA_HEADER_LEN, 16)
>
> This guarantees that the allocated buffer is large enough
> for the fully padded AAD data for all supported header sizes.
>
> Cc: stable@vger.kernel.org
> Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
> Signed-off-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
