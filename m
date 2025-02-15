Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF8D1C84C3
	for <linux-crypto@vger.kernel.org>; Sat, 15 Feb 2025 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739625304; cv=none; b=D2asXR3b1yv1R2rJXurA1kuhMcKhUGNyWa6OSsgZ8YfiEr7zd+fLQQJWMxCURBC9tB4Aji/LF3pSlU+Mdu8YM9w5IGNjnjnjuBWdlmJzF/G/Irwsv/SshpiZuDLJvxa/pWlf0gVPmuSnvBJBT8b8i4MZIelEDO1CpuN9X9VCnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739625304; c=relaxed/simple;
	bh=osL9ANixDxg2wKESmidrgMn97s4G8GbN85dcsS82vGQ=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qc3B0eBiMc/4uNc3L+cmw4biFQY2nvKWwY//9m6ZrmCWy+lj5k278PKGck62GLcZDRtbHSHXGASJl8djVlTNvOJxzEet5e6Kkic2aglw9libWyPJmprQ04B4iS+Q7jg4+0vA6Zv1xpt6DPJPhORrVA03lG7Kb+cyvg0qFMTOwXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jI/NxDt0; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jI/NxDt0"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so1901391f8f.0
        for <linux-crypto@vger.kernel.org>; Sat, 15 Feb 2025 05:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739625301; x=1740230101; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JktJoiLjN9G+FXngOuwQrKpiqMxxFGFsweUWP3aKSZM=;
        b=jI/NxDt0AnmGpMVTd4MtslbW7x2zg+wiEICwAVlR5uQs7h2XarqGlJtnFJjC5fpwbA
         7+nMijCrU01TkmjQ0k2M+I3saZrbH6d0vAusUf8E/hIB7qOkUlJpPEchiO4PlKSWh1l9
         Y1kAbD2y9Tuw1XaWSQJn465MXNoyxcC+Ljcd///VmPEHZriAI+W/qzF5jgE8k7iWvVDi
         PfYAYcIFuCVcIfS4jTuOiJyk6SkR6t0VbBEE31q2/MoyDJcsk8JhIYaF24mC2jUA4njs
         qYRZ1dF7HAi68Q/E6gvYSkEVBYfPOqWHx9MQtsN9KauLAlGfBGpB7A7aazSHPjcOP9ZL
         ynrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739625301; x=1740230101;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JktJoiLjN9G+FXngOuwQrKpiqMxxFGFsweUWP3aKSZM=;
        b=wwo0E3g2p+msFtygQcuH8+1zaZHduGvzws3L66wqdArrB9mLZhJavcbEx03ZwbEibA
         4VFVBc5oKUZ2Ici50FYBelLgWGOxur8FJFNpYcU8baLzKto+Bydg5+m77Bxi9drEm8Wz
         GJ6gAtgm2AL+146wz912HL52imp8MNNubCRWfKc6JtEevhflzGjUCrgh+AxDaoXYxW5b
         AuFeC8x6grhl002uVhLrs5lvfnBWPJWyB4rEXab9nzTEJ8fjZtNmZ093iSHqWV91ULdu
         J/Nf+iVkDP9yEI3lZlDQlLo0SnRWKXYsATeS2tHKRmJ5gOML9lB8oz0Km4QxQd5KZvwc
         vXvA==
X-Gm-Message-State: AOJu0Yw9Z+IoPNJa3ohkshhLSGMSZbyBDvEp/ZYRYiojoOQBbH2zLCc/
	qnqmyp8JAWdOXyS3uqMLLZ4Hr0J40s+HdBEeR3d++B/Q2zPcw1ua
X-Gm-Gg: ASbGncvTCzmPYLc1IhQ5E1Cb5RqJb2fYtDDEsHpUpdLUJGr9LmFYr4kU5mfocrHgchW
	NUGi5FXTWQCvh5xAFQgzDSg8R9tKX3JjKyMPl5egT3D0sh11SV2cik2enpoMsN1CMIiABXHd8Q5
	DtViVH2PVlG2OZFPAnzANvyszgSYOk5nA/qTNR1C7ka3+ux6VbqOMi00CnsLdWzwBFqizIax8ZL
	cL4XYdQLpFmwZhuepD4gVCFBMwfdMoVuEpKJ9JY4QsyrGED/dEErvcsJhyIM7wMCrM3P0Ro3avv
	uA3QLOaGJZ9dUQ==
X-Google-Smtp-Source: AGHT+IHkbYJ4+h4s01OLrB6MUmN/H9WDTDB0+IezimJTq8anopSta0j2NLvE3J308MqSir+OWxj/Kg==
X-Received: by 2002:a05:6000:1f87:b0:38d:e6b6:5096 with SMTP id ffacd0b85a97d-38f33f3d4bamr3549207f8f.15.1739625299651;
        Sat, 15 Feb 2025 05:14:59 -0800 (PST)
Received: from Ansuel-XPS. ([87.6.198.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258f5fabsm7137141f8f.45.2025.02.15.05.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2025 05:14:59 -0800 (PST)
Message-ID: <67b09353.5d0a0220.245b91.dc34@mx.google.com>
X-Google-Original-Message-ID: <Z7CTTJ2Nc3DaoPPI@Ansuel-XPS.>
Date: Sat, 15 Feb 2025 14:14:52 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: eip93 - Add Inside Secure SafeXcel EIP-93
 crypto engine support
References: <cea9bafd-3dde-4028-9b20-4832dd2977e6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cea9bafd-3dde-4028-9b20-4832dd2977e6@stanley.mountain>

On Wed, Feb 12, 2025 at 06:23:01PM +0300, Dan Carpenter wrote:
> Hello Christian Marangi,
> 
> Commit 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel
> EIP-93 crypto engine support") from Jan 14, 2025 (linux-next), leads
> to the following Smatch static checker warning:
> 
> drivers/crypto/inside-secure/eip93/eip93-common.c:233 check_valid_request() warn: 'src_nents' unsigned <= 0
> drivers/crypto/inside-secure/eip93/eip93-common.c:237 check_valid_request() warn: error code type promoted to positive: 'src_nents'
> drivers/crypto/inside-secure/eip93/eip93-common.c:240 check_valid_request() warn: error code type promoted to positive: 'dst_nents'
> 
> drivers/crypto/inside-secure/eip93/eip93-common.c
>     201 int check_valid_request(struct eip93_cipher_reqctx *rctx)
>     202 {
>     203         struct scatterlist *src = rctx->sg_src;
>     204         struct scatterlist *dst = rctx->sg_dst;
>     205         u32 src_nents, dst_nents;
>     206         u32 textsize = rctx->textsize;
>     207         u32 authsize = rctx->authsize;
>     208         u32 blksize = rctx->blksize;
>     209         u32 totlen_src = rctx->assoclen + rctx->textsize;
>     210         u32 totlen_dst = rctx->assoclen + rctx->textsize;
>     211         u32 copy_len;
>     212         bool src_align, dst_align;
>     213         int err = -EINVAL;
>     214 
>     215         if (!IS_CTR(rctx->flags)) {
>     216                 if (!IS_ALIGNED(textsize, blksize))
>     217                         return err;
>     218         }
>     219 
>     220         if (authsize) {
>     221                 if (IS_ENCRYPT(rctx->flags))
>     222                         totlen_dst += authsize;
>     223                 else
>     224                         totlen_src += authsize;
>     225         }
>     226 
>     227         src_nents = sg_nents_for_len(src, totlen_src);
>     228         dst_nents = sg_nents_for_len(dst, totlen_dst);
> 
> These return -EINVAL on error.
> 
>     229 
>     230         if (src == dst) {
>     231                 src_nents = max(src_nents, dst_nents);
>     232                 dst_nents = src_nents;
> --> 233                 if (unlikely((totlen_src || totlen_dst) && src_nents <= 0))
>                                                                    ^^^^^^^^^^^^^^
> It's unsigned so it can't be less than zero.
> 
>     234                         return err;
>     235 
>     236         } else {
>     237                 if (unlikely(totlen_src && src_nents <= 0))
>                                                    ^^^^^^^^^^^^^^
>     238                         return err;
>     239 
>     240                 if (unlikely(totlen_dst && dst_nents <= 0))
>                                                    ^^^^^^^^^^^^^^
> Same.
> 
>     241                         return err;
>     242         }
>     243 
>     244         if (authsize) {
>     245                 if (dst_nents == 1 && src_nents == 1) {
>     246                         src_align = eip93_is_sg_aligned(src, totlen_src, blksize);
>

Thanks, this wasn't reported in the first run so sorry for not noticing
this. I will take care of sending a follow-up patch to address this.

Again thanks for the report!

-- 
	Ansuel
