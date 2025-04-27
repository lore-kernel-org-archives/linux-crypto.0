Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7D21ACEDC;
	Sun, 27 Apr 2025 18:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745778225; cv=none; b=d8yPRmbzpZg7cbtQE8Nl6HiRO5e5SxQ+cSKOLDnuvokGq9aMekcUcHPb5wWWpMlCX10rTVTUN0j7XRNteLbrh8FCjVNWfuhM2LYhhFnEvsD6mcPYZQOQ3Y0sXStJVG+bt6zk+Vh1IbSB2X3qobtCrIoBZmzBengIU306mSZ5SrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745778225; c=relaxed/simple;
	bh=1duZXEd6o6yqgIxjU3gS1pYSWkmrgiC7CikfmSykev0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YTbOaN3dAGF3kWfMxtRXXHQobyiFEgfPf0L138GJZODTqvUwV4MbEUA4tW05wG0lodpxU67x0YLtQTQ2zgc2NHmHyHKZrZ7RDgn6CNlirXbkp3HDd2QOODw6MkpgvnYYGk7BHmF0BeG2rzRVMV8ScBXvWMteHvI98dgMNHFbN+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IEAmAb9C; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IEAmAb9C"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f4d6d6aaabso6377410a12.2;
        Sun, 27 Apr 2025 11:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745778222; x=1746383022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yUSiCMc3+HiLY3TDrmFMgC3VJtgyOzx1EV4C1MFAjrY=;
        b=IEAmAb9CitK9tNGaots09fvDJkUzTdeLFnwuwbEGDAl4cVBhmmEofrr71n9sRElX9Z
         +i729UpVSTh4vCGUml7PmHUm1gZ9P+0lAKCA3dfBvVGUJpXUUh+cmVQkws+braduDqa/
         gmhtUs1aQOWInC8EMFM3MmVsUGYv/7StKQn1Bic+ZbJcpXwIeZrYM9I5GkEqVqp5SPrV
         iz26z+RaNj8+TPR5NLmUmIN6sWzAwQL7Nwdg7lvNkqOUX8/Qp5F3i7VHp4VUMWfGzdzY
         +XYbsugfWgYUoyPn1LkcckCYvM1JVu4WeWRuHyBnCHfESJXCaP+FKpjG5ygnCkivCD/4
         N5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745778222; x=1746383022;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUSiCMc3+HiLY3TDrmFMgC3VJtgyOzx1EV4C1MFAjrY=;
        b=C+G0jwi4vR4u3CZEHNMToFfu4ddNmT/DMVk5i2dO3YlH9yO5pf6HRRcwC8SgUfTQ9U
         IFt+872nqRrzvuVn4S1l134jd1n6KsyKi7MqEpYlFwPrrIs/qVLdhA1LdSbNER7+UbGS
         6PcIzJLvGc7pIicoOwiPQg95Fj5/TIfcgTNsS4Bxw1C9J48TTuW6mZ4rKzJmy1o/ArZ+
         FgurqqiMTUsn83Hg/ocmFc7UBSU29gDsMGoKyYqrjBPHt3hOWVAYGbuaa8KhZU5mBIWM
         nFLVgxfJYEubmGuXNSGqOed5FUhrjALjVq613M06WvxTmY9LsbvvtBzXhaBC6wT3rL1u
         uS8w==
X-Forwarded-Encrypted: i=1; AJvYcCU3PkvEE7GDLNvU/5vEBB3TxPeCCXMjv86xFfjv3MMQsbmKz2yOJJ68idr3DLDo6D7S7oe7DPMZ2POAHWI=@vger.kernel.org, AJvYcCW1SILoy9u/ODEhfQHSqM23cKxn01XF2kRUg4Lb6JYsVvZVoY4GB7iwVi8Eg8c5yW1DPg1SQ/aNXDrqhmpZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyOGTmN4l/q26PfpbHJLjGCqTLNr63Qxmcgevj4a4UlRol4kyoL
	cv9UhPE701GtKAnYTlP2Sosu5Td6GBxudhrchv4I2a9KVTLEMM32
X-Gm-Gg: ASbGncvxTZ8scxljpJ07VqmSUaDY7YRfhqrIAoQ9Sj2aLp/1Ub3j7fz6A/+6jSJJ5mE
	FZ22/nFBWhMYnyqzg4SN9QyJKMUIBzwiyZZfeSRjyqV0mNOQV+xEOuwSVwcFAG7TdytXXoZUDwa
	ADGRDzuKuVLkOAVVIT//OrI33PLUbchnCCPse8DdvOwXE03dnYpeC4tNyYH66HjRcgdft9H9R/y
	cLS6lMp7pcgEIPgkCtb7VBqoWs9ghfHp+lqviw0D1MVcomThpYezotikvwveyAEGaYROqnnSj1D
	C8d9hYx7cAT0FMGjYnUowtrnzxUvMiXSuHylqs1UShOsdI9ceft7UwL1GZTEQbraWfs1PQpLXP7
	3fvehXqmBAYUhgpg/V/8dtbWas6P+9i1b43IP
X-Google-Smtp-Source: AGHT+IFvq46nAYQLC0nkEAA7EJrWLuZNcuxxB8BvzF8vxeFLFcLhIZ0aOQG+z7k46qu9zHJydkv9Kg==
X-Received: by 2002:a05:6402:5109:b0:5f3:26bb:8858 with SMTP id 4fb4d7f45d1cf-5f723a15496mr7817963a12.34.1745778221650;
        Sun, 27 Apr 2025 11:23:41 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6? ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7038328f1sm4417391a12.70.2025.04.27.11.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Apr 2025 11:23:41 -0700 (PDT)
Message-ID: <e147c220-92e1-40cb-920b-916cf6703b40@gmail.com>
Date: Sun, 27 Apr 2025 21:23:40 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] crypto: sun8i-ss: do not use sg_dma_len before
 calling DMA functions
To: Corentin Labbe <clabbe.montjoie@gmail.com>, herbert@gondor.apana.org.au,
 jernej.skrabec@gmail.com, samuel@sholland.org, wens@csie.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
References: <20250427111236.25668-1-clabbe.montjoie@gmail.com>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250427111236.25668-1-clabbe.montjoie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 4/27/25 2:12 PM, Corentin Labbe wrote:
> When testing sun8i-ss with multi_v7_defconfig, all CBC algorithm fail crypto
> selftests.
> This is strange since on sunxi_defconfig, everything was ok.
> The problem was in the IV setup loop which never run because sg_dma_len
> was 0.
> 
> Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
> 
> If someone know why sunxi_defconfig have sg_dma_len() which always works
> even with any DMA call not done.
> 

It seems that sunxi_defconfig has CONFIG_NEED_SG_DMA_LENGTH disabled, so
sg_dma_len() defaults to sg->length.

From include/linux/scatterlist.h:

/*
 * These macros should be used after a dma_map_sg call has been done
 * to get bus addresses of each of the SG entries and their lengths.
 * You should only work with the number of sg entries dma_map_sg
 * returns, or alternatively stop on the first sg_dma_len(sg) which
 * is 0.
 */
...
#ifdef CONFIG_NEED_SG_DMA_LENGTH
#define sg_dma_len(sg)		((sg)->dma_length)
#else
#define sg_dma_len(sg)		((sg)->length)
#endif


On the other hand, multi_v7_defconfig has CONFIG_NEED_SG_DMA_LENGTH
enabled, so sg_dma_len(sg) defaults to sg->dma_length and it would need
to be used after calling dma_map_sg() (as indicated in the comment from
include/linux/scatterlist.h).


Ovidiu

>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> index 4caf17310e90..ddec1b08d4f6 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> @@ -141,7 +141,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
>  
>  	/* we need to copy all IVs from source in case DMA is bi-directionnal */
>  	while (sg && len) {
> -		if (sg_dma_len(sg) == 0) {
> +		if (sg->length == 0) {
>  			sg = sg_next(sg);
>  			continue;
>  		}

