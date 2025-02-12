Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758AF211479
	for <linux-crypto@vger.kernel.org>; Wed, 12 Feb 2025 15:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739373788; cv=none; b=lPpGI69kjFkfQ9FIPhgms8IMOYepPmpJF4Cq5397GYeW66fOcjcyFG+V5KorVrrRvds7jVeRw9HU1b3VZqy2DReQ0AvK9mDfXiSKl5dfmENKYrbtsjTmaDK7/rdx9FVxExLWADe6sbfkuyPEzhcW+58mBJgMkHwq6vBseqJiKi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739373788; c=relaxed/simple;
	bh=3bCzMZ8uPx9wHcLyBkOJVFJa96hKBwTfSgNNOm9Azyg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CeaReGR1ztvQGKISLlI9zUqNy5ovchJ6LT7GkITCdNcIisqgSLH/n87xQJqlPw+zmDFa/aT0WML7zNhDFN10ot1TqA0isW9OWltedDYQ97hsb/4j6tkLmdf47GEF9Z/lWYE+jXJNCEaU19UrbACKJdUgeyCgZNTKI6aNOcXZ5dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pVpe2sQC; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pVpe2sQC"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5deb956aa5eso611814a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Feb 2025 07:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739373785; x=1739978585; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=64YvJQuCzRGu1P61pUIAXqWgUq9X+jvhdIKiLQpBSyU=;
        b=pVpe2sQCfa4F8wfHBD+xFHbvn6nWLyngRZkO2fJ6DjtTyjhALLbhrQ7crGbqajyvDM
         +yVAegXR2bHPWJ9mlczujiWPVnuJNZBynC3PAkfMeBqg3/5oEuQTobGh4+4xVtzdLUuY
         6xFZU1uPL8QVbyoEn75jAB+TbsfRNu6aWoANHmNeTxLsB16scUwunkr7MHWI+wtOfXN8
         Q983PdEQZvIdHpPPo9MtbUwloagEer6sP6kjVriFM+djDBxzjqhmJ7ONf3VKNdW1SxQJ
         Tq5gwAFDgEIQkEfwz4SeZn6D6hhYmYVMw19CBnlHONrLBH2y9I5/lBahN76LJkMD97yF
         eUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739373785; x=1739978585;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64YvJQuCzRGu1P61pUIAXqWgUq9X+jvhdIKiLQpBSyU=;
        b=MLUFSa4B5/Yw2j/7c6M0iDyQQum4mAGzWtAr865gB+d0maqL2GPyxs9fXRELCUjIsi
         HclahNHg+8vsMQDLnqaKvtokFldbnARuOnmvGwsH5tgfaSxeneeNsHYEeKksUoCNsNww
         jOvgM0+MlXWXV+lLJkKWsrZ7E32Bt/BoUrsQmn61RnUYYvJZPhN+OzMGA7rfCB1dq3KD
         3JX4O9+Irk8IKnrr0y/hH1ERzerTNXA7g5j7asmlHRdLVm1fcf5AW1kM+IE3sQhBth6B
         viiawz2w63elGOt9y9gZZm2V4YNyv/0o8qKAjuV1u2DLoCf7jT3gmsxAwM9c4KSEjiMw
         fStQ==
X-Gm-Message-State: AOJu0YwgClor6xCk4azrRtgb0NFeiFjrKNNgUOA6VT18Jczu4lVVLTih
	i9K2fW6t0kdSGkTw8cQ13yfmjc9hKMORiffk8FCYF0W+WsdYhhnIvCo0at+9CQg=
X-Gm-Gg: ASbGncvzcUG4ityntXX/VGdqGtguWwjnMF/B2h2atOjZfd5k1lnKHUvEhPX9Owxpm3v
	xgPHwhifjZaWvIPeSPi4+8YO+U/5PRdEfSevmMsEnsfkY3g1YEqoiYEtfk+SQCltr3VqddqgqF4
	8dyciT6RlfyAvt2PRObYFVUj8tMN18SYY0NV4AVVi6ASzh3rrSzZGe/23OMBAmD36eOyYiiQ74a
	apsv3aF4Jpy33kfFSr8r2Qgk4Dnc13GJ2cjEY2X3VrEpJvtWeZV2NWsF4iHPk4aZIHkaucygfRa
	NwTgM6OtvWMtvzJknPJz
X-Google-Smtp-Source: AGHT+IF5KX1fW5IY0ZYPNxkMuagyVfdIq4Krzhqtj5uIsKy6X9aHz4JDV52RREfahA7utOyaZduAww==
X-Received: by 2002:a05:6402:2399:b0:5de:b947:b22a with SMTP id 4fb4d7f45d1cf-5deb947b247mr3091298a12.11.1739373784596;
        Wed, 12 Feb 2025 07:23:04 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab7cc3c8cccsm539270466b.173.2025.02.12.07.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 07:23:04 -0800 (PST)
Date: Wed, 12 Feb 2025 18:23:01 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: eip93 - Add Inside Secure SafeXcel EIP-93
 crypto engine support
Message-ID: <cea9bafd-3dde-4028-9b20-4832dd2977e6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Christian Marangi,

Commit 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel
EIP-93 crypto engine support") from Jan 14, 2025 (linux-next), leads
to the following Smatch static checker warning:

drivers/crypto/inside-secure/eip93/eip93-common.c:233 check_valid_request() warn: 'src_nents' unsigned <= 0
drivers/crypto/inside-secure/eip93/eip93-common.c:237 check_valid_request() warn: error code type promoted to positive: 'src_nents'
drivers/crypto/inside-secure/eip93/eip93-common.c:240 check_valid_request() warn: error code type promoted to positive: 'dst_nents'

drivers/crypto/inside-secure/eip93/eip93-common.c
    201 int check_valid_request(struct eip93_cipher_reqctx *rctx)
    202 {
    203         struct scatterlist *src = rctx->sg_src;
    204         struct scatterlist *dst = rctx->sg_dst;
    205         u32 src_nents, dst_nents;
    206         u32 textsize = rctx->textsize;
    207         u32 authsize = rctx->authsize;
    208         u32 blksize = rctx->blksize;
    209         u32 totlen_src = rctx->assoclen + rctx->textsize;
    210         u32 totlen_dst = rctx->assoclen + rctx->textsize;
    211         u32 copy_len;
    212         bool src_align, dst_align;
    213         int err = -EINVAL;
    214 
    215         if (!IS_CTR(rctx->flags)) {
    216                 if (!IS_ALIGNED(textsize, blksize))
    217                         return err;
    218         }
    219 
    220         if (authsize) {
    221                 if (IS_ENCRYPT(rctx->flags))
    222                         totlen_dst += authsize;
    223                 else
    224                         totlen_src += authsize;
    225         }
    226 
    227         src_nents = sg_nents_for_len(src, totlen_src);
    228         dst_nents = sg_nents_for_len(dst, totlen_dst);

These return -EINVAL on error.

    229 
    230         if (src == dst) {
    231                 src_nents = max(src_nents, dst_nents);
    232                 dst_nents = src_nents;
--> 233                 if (unlikely((totlen_src || totlen_dst) && src_nents <= 0))
                                                                   ^^^^^^^^^^^^^^
It's unsigned so it can't be less than zero.

    234                         return err;
    235 
    236         } else {
    237                 if (unlikely(totlen_src && src_nents <= 0))
                                                   ^^^^^^^^^^^^^^
    238                         return err;
    239 
    240                 if (unlikely(totlen_dst && dst_nents <= 0))
                                                   ^^^^^^^^^^^^^^
Same.

    241                         return err;
    242         }
    243 
    244         if (authsize) {
    245                 if (dst_nents == 1 && src_nents == 1) {
    246                         src_align = eip93_is_sg_aligned(src, totlen_src, blksize);

regards,
dan carpenter
