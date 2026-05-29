Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849FD37B40E
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780074612; cv=none; b=Is/mS9ua90gbHLKub3G4PTLGmSTIF24cjqUvBME/b+ROSf1E0d28WIIrJUISmDbzYCc40K9xM66ag4xjZizJWOXSOWuPabOQxTlP1BolcWTqw8+BveoXa05CmE5AABecc+1Lkb8grRJTRjUQWP1LOBRrLgwtBFOhRRhXY5F0Ock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780074612; c=relaxed/simple;
	bh=dgeJvvjQc5QMwRX5JtGFSTlN6V6uNPGM8Ed0SvjA7so=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKWJt9pgOPhbNyyV5VHILgg6KMLnw/Ywdlz/fmVQVT77mtINMro2XH3onxkFjmM/q3f7ePLfXXekgYhWdGF4yqW1hAhyfHjSbFRbbnyxeKOtfprhEB6yyb3rF2d8GXwuOFRTG5PMpudtPd205vKo/YrCLdxrC89UT8rrCfbLvEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bZAejIFg; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZAejIFg"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7cfd0d8eb09so110191287b3.1
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780074610; x=1780679410; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XEa79tV2eMzpcPWIo8LBBqUX2PeWclrMmzllPIEalhs=;
        b=bZAejIFgCs57YsKX7b5JsJP1Suks/r80z11NV5gdeFrUCsYgKLHyEtpJBmPngOM1vp
         c+dzvAS+boE640978Bp3FYPXHcs/O1WjHcgEUF0trRG4IiWP8bb8Nr7VsM4Bm7X0iiaI
         PRtUdxr2OnlkknchGjq5NUjGBEG163RcIe53VC9oS3OQI/fsM1xVKARZBn00yuSiQBpV
         NICErp9XU07swaxcotQRpmCi6XUrJ+u+BhH7ye5SSoGrP55QCucVQV0fQdM/zdegQ4SV
         JLrV584vT6mLJs+ifinPDWhBrKq0xNMI27vdI9m+e0B7ymijgi/pF77iiJy3FdC8FF1L
         nEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780074610; x=1780679410;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEa79tV2eMzpcPWIo8LBBqUX2PeWclrMmzllPIEalhs=;
        b=LlZrPIGTcwYWBtwuAPnS4TRxkyzAuXz0FNzwWu3fcjbhquVuhRhM+vobXGyIO348BN
         JehkB4GlK9024qfh9Kbu8ImK0GFdo1YJsOKjzcB/h4q5dLTJBxMzVxaTpQ85Rqetj2Nr
         uJLavr3Zq2GNKfer7zXi/t32UFkboluLEvLSq22Gec5WxPxXh5YO7LFvgSeOGiB6Rn9d
         QmeDkEIoAhaVocshKuJAnXAmhhXZXh676pOneXgf/bADc/skJWAhcTyHg7a4d8Q8uK0V
         OHmS+njBgfnh1yy078Ruqpyv85kdxHQg3Vk5qDxHvtZBlA15WhFhLarvRiMAhLUjMx/V
         EXCw==
X-Forwarded-Encrypted: i=1; AFNElJ8O7KW4jkJWM4kmW8AwBkzEXSbdTV5hLJ6Xipo2ADCFj8VrWv6AqH/+vEjxJgq102j6bMWqrN118jx4AgY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhg7JM4AFB3CGnWWZ4Gax+xR1qf7cR63pDXf9P/DV8DtYTn1Np
	/muBVyEuPMAbFdNqfZlHHgpOji1gW5TzhsQTv6m7Bw7wfm8aQvWYRWl9c/UmjQ==
X-Gm-Gg: Acq92OGuIMIPe0muXhtwOMoFXv+Bes3oVRIhmG+zhfuGbmqjy7CT3Hc5ZD2uyDRUGiW
	YjY7m+jpXOxEHW+n4I7wQ4nGAys6WUCfuin+33NNWjhU1nBKCcFUteUbnhC4HBXrnXC5GF5fz0/
	o//gydzFeHHKeDPDARWWKPQObmPioX1Go+MrXk7bfux+J4dczbGMrtnEj2MRARbYmqlsHUTky2P
	62kwTFwqysb6q3OPtHNJUrtDVGq+g3BqcplV6y/tvFhFMFd4HP3mCc0A0nlftpVHZ0C36iUD3pU
	Uel7eG/mhSDebECHspyezDxymKFs3+W+AGqv+rwTxzaEuSd8uGAxZtHcFCkTGf320K8kgFh5hor
	U+l9T3wZDqAa+wOssb0GHGS/i9Qp2GhVDVZHIgXpz6JogDIENRqVWoYTM9rAVIF8t7EvkPZWl/F
	copZ8bY8800NpG3B/7nx2eX2Q9ACmTSsqELw==
X-Received: by 2002:a05:690c:e34b:b0:7d0:261a:6bd with SMTP id 00721157ae682-7e05f11c4ffmr1672527b3.44.1780074610517;
        Fri, 29 May 2026 10:10:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 00721157ae682-7de689e58d9sm8427927b3.21.2026.05.29.10.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 10:10:09 -0700 (PDT)
Date: Fri, 29 May 2026 19:10:06 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Tianchu Chen <tianchu.chen@linux.dev>, herbert@gondor.apana.org.au,
	davem@davemloft.net, wens@kernel.org, jernej.skrabec@gmail.com,
	samuel@sholland.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun4i-ss - clamp PRNG seed length to prevent
 heap overflow
Message-ID: <ahnIbpBLyn5z_siT@Red>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
 <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>
 <20260529161057.GA2706@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260529161057.GA2706@sol>

Le Fri, May 29, 2026 at 09:10:57AM -0700, Eric Biggers a écrit :
> On Fri, May 29, 2026 at 08:08:01AM +0000, Tianchu Chen wrote:
> > From: Tianchu Chen <flynnnchen@tencent.com>
> > 
> > sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
> > using the user-provided length with no bounds check. The crypto core
> > does not enforce slen <= seedsize before calling into the driver, so a
> > userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
> > sysctl_optmem_max bytes, overflowing the fixed-size buffer and
> > corrupting adjacent heap memory.
> > 
> > Clamp the copy length to the buffer size, matching the approach used by
> > loongson-rng for oversized seeds.
> > 
> > Discovered by Atuin - Automated Vulnerability Discovery Engine.
> > 
> > Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> > ---
> > v2: Silently clamp oversized seeds with min_t instead of returning
> >     -EINVAL (Herbert Xu).
> 
> sun4i-ss-prng.c is useless, is still broken, and should just be deleted.

Hello

useless ? clearly no, it helped a lot on devices where it is.

Regards
