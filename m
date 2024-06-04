Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781CD2A8D0
	for <linux-crypto@vger.kernel.org>; Tue,  4 Jun 2024 05:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477761; cv=none; b=nkIvuH3A1ggt81pXCwREqDm0gJc2ShauXAixQ4d4J8k44xdmZlw2P4RyYZfI1RqEYVRUWOFKWLr3c5QLzt4SmyslrEKA4iYcx6MvGW5Qoi/T7MvU3RPZcAgQ6s5zgSakn5759uDAbRjVzQQqfiGnZe4P4tK14yqoPA2v0SVS4UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477761; c=relaxed/simple;
	bh=FkpT8Rf0FsrYxaF0MLfRIOY1IL8I8CRatSRkqzossa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YY/gCJWAyRcyrIDUuk1u1pzyB6eJrjfg7SlbmAiEuzQ3CR3Exp+++BvWkNW5JDFP5O/VU4oijoCmOYQ7yQv1EWohAFcjVw9lxArGRnMuSQW6xcQ6iQkcVCidTihi8o9Tf4AOhLd4+Tsy/ddzbnpgHdz6LBVie8dLlM+2WqtXPt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=azTzmkHT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="azTzmkHT"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f44b45d6abso5981085ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jun 2024 22:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717477760; x=1718082560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=15TkgN+3bQd9zOq6PhxHS61GPHiDyE3EXpjgMNn0uuI=;
        b=azTzmkHToG5QsDRqOSeqM2osNWRl0D0+LJtRN6KeCx/tToBGd3Aa9q000fEK37Hoyp
         3qbw39XCvtX6zn6AKAn5i/rWtD26a7mYngmikHxiyaN7VQTKC7nHi2/mVxI+BS333fBk
         jhr3nRPJVxEsEKB0dK3m7w88tg3olylDDhXsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717477760; x=1718082560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15TkgN+3bQd9zOq6PhxHS61GPHiDyE3EXpjgMNn0uuI=;
        b=PepIf7x/Waz+rtIeWgWJ389yPhhLbEDizbh7zjx3c4DSe+nKACto4Tj0oP47TYgMUn
         7EPkIBiY8xxCyucw8w6/GXZj1YaIoOxRUMhB9FK4jjiPMGPtHckB3xFVBgv/Vk7RDdqk
         5d3Ck3SLIP89LBKJMN1/Fp76HIFv+9oHmNACAnvEFrPQPGvbEGtrLcfJ1DinVQNRAorl
         vSCKTdDAsKdzomfgw2q2R1Sk4XgSaZ0JWkc03xgIkFrPD0VErBnHvHbPWEMUIl6IT+GL
         s/VY/TrTjDVy8MfJF2qtifkkQD6c4tSxxvYnH7E41U7BZy0u7nrJvMoXgwVwGU9h1Gs0
         GNtw==
X-Forwarded-Encrypted: i=1; AJvYcCX30j1UDklQT9z84y9FHG+FLQr2QRfTtCEDea0+gvI/JPoqyRlKzOy1QCuRItJeP4BBxoRh8dsp64E5Srrfhh0/xD9y75+41s4MNWq6
X-Gm-Message-State: AOJu0YwSkwIkuFSZn4C+fb4Ctw9GXkkQh9no3w3OrQoJLbx/tIq0EVDN
	mahPCm58zEFpvOIRIyuNSFuaIzB3j4ssIQGSbMzHDvNLbjVK2Yh6dFv33zWJrWhWXbl/k5XyR5I
	=
X-Google-Smtp-Source: AGHT+IFp+jp82deJwSsz9KE2urIaeSx1MDBe5KDMDOYj8FTE3ln1dfyHnoliVKnBA2xRqfOl31dtHg==
X-Received: by 2002:a17:902:ce82:b0:1f4:b702:f12d with SMTP id d9443c01a7336-1f637006b05mr109304445ad.26.1717477759672;
        Mon, 03 Jun 2024 22:09:19 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:72fe:f923:2f3c:6cd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f632338be8sm73475935ad.44.2024.06.03.22.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 22:09:18 -0700 (PDT)
Date: Tue, 4 Jun 2024 14:09:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <20240604050915.GA11718@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
 <20240601002415.GH8400@google.com>
 <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>
 <20240603023447.GI8400@google.com>
 <20240603082856.GJ8400@google.com>
 <Zl2ABxcUmNYD1DoF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl2ABxcUmNYD1DoF@gondor.apana.org.au>

On (24/06/03 16:34), Herbert Xu wrote:
> On Mon, Jun 03, 2024 at 05:28:56PM +0900, Sergey Senozhatsky wrote:
> >
> > Herbert, I'm not sure I see how tfm sharing is working.
> > 
> > crypto_tfm carries a pointer to __crt_ctx, which e.g. for zstd
> > is struct zstd_ctx, where it keeps all the state (zstd_cctx, zstd_dctx,
> > and compression/decompression workmem buffers).
> 
> That's the legacy compression interface.  You should be looking
> at the crypto_acomp interface which handles this properly.

Oh, I see, thanks, I didn't know about that, okay now I see what
you meant when you said that you'd not add setparams to legacy
scomp interface.

Alright, so this means

1) zram needs to be converted to acomp interface
2) scomp drivers that zram is using needs to become acomp compatible
   (for example, I don't think I see acomp support in crypto/zstd.c)
3) zram needs to support setparam
4) zram needs to support tfm sharing, so that setparam can be called
   once
5) crypto comp drivers need to start support setparam

That's quite a bit of work, I should admit.
