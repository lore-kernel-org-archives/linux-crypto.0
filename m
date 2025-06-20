Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705C030E83E
	for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750406658; cv=none; b=RJHbSBqqO0727yvVNsitf1w8cfxr4/RXK+VvhHstzDVVcYUSrMEIJR47aUJo14vi4S06wR0GVY2mAF+qXP60qYYQmzZg6rgi+Z6bDlM5VDry/lnDeMrUB4yfM5D8xgE/mxEG1xZdaxDlOKt3Rh21UVY5aWlu7mtoLpzvQw3X39g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750406658; c=relaxed/simple;
	bh=n/3fIWHZfJzhOTujA53DP7keuhAqVyp7k3fLFkQyb3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hML5SqhPetUDJ4DC4ee0yiZTanJVX/9VHWSyPoxVDXu6BsSkB3IUZOkHtc73BaNY64a5Gv/2h/hS3+kDOpYnfwZH62Vq1C6joqaVaZiIje0RPNuufa+ZATnQWc3kGhlQXeTBLkdvUGDI6ZkyGSnkw2ZAmwLYW32ulY8zvzJCup0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dAd49aSk; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dAd49aSk"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-607ea238c37so3011984a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 01:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750406655; x=1751011455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XxgHvAza9lzucEyGfJBYSkwi+l6FJLLetBFw6IaVvqg=;
        b=dAd49aSk1WkQ1ip7rFKt+ClM4cFTXqM6x549Ibf0NJmBRz3Q6amYIpCrHbQCZFpi1/
         pnCGp4gn8+naTJDoeLTxLIaV9Y/WeOzEIauzDe5rvm2guFpya+gffMWlJQZFcCnvjoc8
         0PIr+U0+ibopGi7JJ44hQQ+Ntigaa9GXdqh+jkxsepPG94UjAgnULT1aiCR/vITddAPq
         dt7oABTPJ7jjKDwKA2aovTWHWswLk1mdAqOijguQgLKy0UAQgZevoJ8hdZJDgmIPTP9e
         DnDLPkYIaB/CUUHgxTFrV0a2XYisifbTIYt9RQuHNJ9Hbgmts68+nXIjCHtsLOHHDFzX
         fohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750406655; x=1751011455;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxgHvAza9lzucEyGfJBYSkwi+l6FJLLetBFw6IaVvqg=;
        b=Ib+hy7jmCEoS11Nl8QYQ3qR8eGS9g2SPckZrpueuRozP4XMUBtfJDLhmhwSHRxtMm/
         SUnhnvSLICufp5YHgk5sQqPxDsjGOAU1ftwlUKNL+m0HS9WEfF0IZg8/JiGtKoukXSBz
         RS4ui8UoOQgLbNkwNgvDL+urmJ43gLgqirTI2atel5GVYGdZNaT3w4yH9YjZf9lh4M9A
         XO6o6lAVhfdR61IVAEkdtlf2vfaFqqaZgc+C6hC4BRbYf1tEJiArMBQm3ajt5f4bN3J8
         1xE5BAZnZZ1JYPU+90E0poX4jHbLBHVe2/ffGijVm7xoBdYsL8URlJezhAuhGZbFcXhb
         awEg==
X-Gm-Message-State: AOJu0Ywwi6l7BGtFUlLdMzDdrsCARzDpWnkHMNbLtnPG5OBH2fk0aL62
	aCPwijovChdGmnzqYmnTTqETNd68z4K1NHBucAhq/o6hGdaS+pxmbCHC
X-Gm-Gg: ASbGncvfFRAxlhX5yQoIk4gHdPU+uJugikmfqO6d9RC+OoOWS0gudAuatFituD92GDF
	6RDpNMQF4sWwSLmfBjbRUHGK0o8vNMeXLyMAqlCq11QJwXFZxUv7yOzA/nWcSb4z9a+9hjJMWd6
	f/GGEQwE8nqBTVuP8h80VGDswpyri1MSUGb+fvedyvLB+/F+IUwA5kjKrcGaJWix4OpFe4jKKlH
	4TyyRghwjtCqnn1NtW7swQcjVb2o8gAA0JQX11JppDbFSZnAx8sq1ViPfcTlWWkpFcQzjpQG7yU
	QGSHe4e4Phd1OJMzoQ0FRvxHB+S+sVn/aBvUt0U2NWeuJcaXxgc/kRoDLZvnfQYXrQGhc60GpFg
	+pC7EdqOAbv6TxfttCiX6
X-Google-Smtp-Source: AGHT+IE5fWGab2EWf6qV2gM2GyKNO3qx+p6jv8lprhcHKBfTDR0H8lDSkJ2uHgsoe6k0mhzzfgsDhw==
X-Received: by 2002:a05:6402:4316:b0:5f3:f04b:5663 with SMTP id 4fb4d7f45d1cf-60a1cd31008mr1709094a12.24.1750406654469;
        Fri, 20 Jun 2025 01:04:14 -0700 (PDT)
Received: from [192.168.8.101] (78-80-16-228.customers.tmcz.cz. [78.80.16.228])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60a18cbadb6sm1027090a12.62.2025.06.20.01.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 01:04:14 -0700 (PDT)
Message-ID: <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
Date: Fri, 20 Jun 2025 10:04:12 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-crypt: Extend state buffer size in crypt_iv_lmk_one
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
 <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 xsFNBE94p38BEADZRET8y1gVxlfDk44/XwBbFjC7eM6EanyCuivUPMmPwYDo9qRey0JdOGhW
 hAZeutGGxsKliozmeTL25Z6wWICu2oeY+ZfbgJQYHFeQ01NVwoYy57hhytZw/6IMLFRcIaWS
 Hd7oNdneQg6mVJcGdA/BOX68uo3RKSHj6Q8GoQ54F/NpCotzVcP1ORpVJ5ptyG0x6OZm5Esn
 61pKE979wcHsz7EzcDYl+3MS63gZm+O3D1u80bUMmBUlxyEiC5jo5ksTFheA8m/5CAPQtxzY
 vgezYlLLS3nkxaq2ERK5DhvMv0NktXSutfWQsOI5WLjG7UWStwAnO2W+CVZLcnZV0K6OKDaF
 bCj4ovg5HV0FyQZknN2O5QbxesNlNWkMOJAnnX6c/zowO7jq8GCpa3oJl3xxmwFbCZtH4z3f
 EVw0wAFc2JlnufR4dhaax9fhNoUJ4OSVTi9zqstxhEyywkazakEvAYwOlC5+1FKoc9UIvApA
 GvgcTJGTOp7MuHptHGwWvGZEaJqcsqoy7rsYPxtDQ7bJuJJblzGIUxWAl8qsUsF8M4ISxBkf
 fcUYiR0wh1luUhXFo2rRTKT+Ic/nJDE66Ee4Ecn9+BPlNODhlEG1vk62rhiYSnyzy5MAUhUl
 stDxuEjYK+NGd2aYH0VANZalqlUZFTEdOdA6NYROxkYZVsVtXQARAQABzSBNaWxhbiBCcm96
 IDxnbWF6eWxhbmRAZ21haWwuY29tPsLBlQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwEC
 HgECF4AWIQQqKRgkP95GZI0GhvnZsFd72T6Y/AUCYaUUZgUJJPhv5wAKCRDZsFd72T6Y/D5N
 D/438pkYd5NyycQ2Gu8YAjF57Od2GfeiftCDBOMXzh1XxIx7gLosLHvzCZ0SaRYPVF/Nr/X9
 sreJVrMkwd1ILNdCQB1rLBhhKzwYFztmOYvdCG9LRrBVJPgtaYqO/0493CzXwQ7FfkEc4OVB
 uhBs4YwFu+kmhh0NngcP4jaaaIziHw/rQ9vLiAi28p1WeVTzOjtBt8QisTidS2VkZ+/iAgqB
 9zz2UPkE1UXBAPU4iEsGCVXGWRz99IULsTNjP4K3p8ZpdZ6ovy7X6EN3lYhbpmXYLzZ3RXst
 PEojSvqpkSQsjUksR5VBE0GnaY4B8ZlM3Ng2o7vcxbToQOsOkbVGn+59rpBKgiRadRFuT+2D
 x80VrwWBccaph+VOfll9/4FVv+SBQ1wSPOUHl11TWVpdMFKtQgA5/HHldVqrcEssWJb9/tew
 9pqxTDn6RHV/pfzKCspiiLVkI66BF802cpyboLBBSvcDuLHbOBHrpC+IXCZ7mgkCrgMlZMql
 wFWBjAu8Zlc5tQJPgE9eeQAQrfZRcLgux88PtxhVihA1OsMNoqYapgMzMTubLUMYCCsjrHZe
 nzw5uTcjig0RHz9ilMJlvVbhwVVLmmmf4p/R37QYaqm1RycLpvkUZUzSz2NCyTcZp9nM6ooR
 GhpDQWmUdH1Jz9T6E9//KIhI6xt4//P15ZfiIs7BTQRPeKd/ARAA3oR1fJ/D3GvnoInVqydD
 U9LGnMQaVSwQe+fjBy5/ILwo3pUZSVHdaKeVoa84gLO9g6JLToTo+ooMSBtsCkGHb//oiGTU
 7KdLTLiFh6kmL6my11eiK53o1BI1CVwWMJ8jxbMBPet6exUubBzceBFbmqq3lVz4RZ2D1zKV
 njxB0/KjdbI53anIv7Ko1k+MwaKMTzO/O6vBmI71oGQkKO6WpcyzVjLIip9PEpDUYJRCrhKg
 hBeMPwe+AntP9Om4N/3AWF6icarGImnFvTYswR2Q+C6AoiAbqI4WmXOuzJLKiImwZrSYnSfQ
 7qtdDGXWYr/N1+C+bgI8O6NuAg2cjFHE96xwJVhyaMzyROUZgm4qngaBvBvCQIhKzit61oBe
 I/drZ/d5JolzlKdZZrcmofmiCQRa+57OM3Fbl8ykFazN1ASyCex2UrftX5oHmhaeeRlGVaTV
 iEbAvU4PP4RnNKwaWQivsFhqQrfFFhvFV9CRSvsR6qu5eiFI6c8CjB49gBcKKAJ9a8gkyWs8
 sg4PYY7L15XdRn8kOf/tg98UCM1vSBV2moEJA0f98/Z48LQXNb7dgvVRtH6owARspsV6nJyD
 vktsLTyMW5BW9q4NC1rgQC8GQXjrQ+iyQLNwy5ESe2MzGKkHogxKg4Pvi1wZh9Snr+RyB0Rq
 rIrzbXhyi47+7wcAEQEAAcLBfAQYAQgAJgIbDBYhBCopGCQ/3kZkjQaG+dmwV3vZPpj8BQJh
 pRSXBQkk+HAYAAoJENmwV3vZPpj8BPMP/iZV+XROOhs/MsKd7ngQeFgETkmt8YVhb2Rg3Vgp
 AQe9cn6aw9jk3CnB0ecNBdoyyt33t3vGNau6iCwlRfaTdXg9qtIyctuCQSewY2YMk5AS8Mmb
 XoGvjH1Z/irrVsoSz+N7HFPKIlAy8D/aRwS1CHm9saPQiGoeR/zThciVYncRG/U9J6sV8XH9
 OEPnQQR4w/V1bYI9Sk+suGcSFN7pMRMsSslOma429A3bEbZ7Ikt9WTJnUY9XfL5ZqQnjLeRl
 8243OTfuHSth26upjZIQ2esccZMYpQg0/MOlHvuFuFu6MFL/gZDNzH8jAcBrNd/6ABKsecYT
 nBInKH2TONc0kC65oAhrSSBNLudTuPHce/YBCsUCAEMwgJTybdpMQh9NkS68WxQtXxU6neoQ
 U7kEJGGFsc7/yXiQXuVvJUkK/Xs04X6j0l1f/6KLoNQ9ep/2In596B0BcvvaKv7gdDt1Trgg
 vlB+GpT+iFRLvhCBe5kAERREfRfmWJq1bHod/ulrp/VLGAaZlOBTgsCzufWF5SOLbZkmV2b5
 xy2F/AU3oQUZncCvFMTWpBC+gO/o3kZCyyGCaQdQe4jS/FUJqR1suVwNMzcOJOP/LMQwujE/
 Ch7XLM35VICo9qqhih4OvLHUAWzC5dNSipL+rSGHvWBdfXDhbezJIl6sp7/1rJfS8qPs
In-Reply-To: <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/20/25 6:09 AM, Herbert Xu wrote:
> The output buffer size of of crypto_shash_export is returned by
> crypto_shash_statesize.  Alternatively HASH_MAX_STATESIZE may be
> used for stack buffers.
> 
> Fixes: 8cf4c341f193 ("crypto: md5-generic - Use API partial block handling")
> Reported-by: Milan Broz <gmazyland@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Yes, that fixes the issue, thanks!

Tested-by: Milan Broz <gmazyland@gmail.com>

Mikulas, I think this should go through DM tree, could you send it for 6.16?
The full patch is here
https://lore.kernel.org/linux-crypto/aFTe3kDZXCAzcwNq@gondor.apana.org.au/T/#u

> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 9dfdb63220d7..cb4617df7356 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -517,7 +517,10 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
>   {
>   	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
>   	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
> -	struct md5_state md5state;
> +	union {
> +		struct md5_state md5state;
> +		u8 state[HASH_MAX_STATESIZE];
> +	} u;

I am ok with it, as this is an obscure IV case for old devices compatibility,
but I would kind of expected the algorithm state struct is self-contained...

...

Thanks,
Milan

