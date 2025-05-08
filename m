Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7B58472
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682990; cv=none; b=jFhtjssfWKPltuMKISUd5ZjpON9hDeJQuKYNK2ohD1rYBuOsVmyXxdaQpRsSKeVwSZ/WWIKnIMJcTVPXa7ebCEnMbGqT9LbVk3HRuh75vARvjAlZMFbPQ2VFqG8WlAmsLn6bfbBERXQ3ODXRUbjM4bfcuzF7xUlPpQ99KD+VIxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682990; c=relaxed/simple;
	bh=Fv8otgfb835vzC4YcxvRcQ71XivAi0oVk1wgiO9JmdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0d1IANnACsAkNvAtIfUEnfZ/iNtWLiXg+/NMHP01VIytAKwVVxQQy8StqqBan/zAguEHsiFa2Q3BYSGGsKtCg2+IJzFMUqdMO/457euvyvNjIO3ite+KRq/YIepbkl8zfuPHwzu2kXMNtu3D+CZjMDWZ8Ht47xRwmiiIp0f9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=aHTiaVBR; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aHTiaVBR"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22c3407a87aso8635665ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 May 2025 22:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1746682988; x=1747287788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lvQH4NxuLOJyCK1IWxiQFZho+f+Pe1KaVnYyh/jEzUM=;
        b=aHTiaVBRG3NDgewddiU09Hgaeb/5Q5f57p34g3DUf4SQWh8y5lFkyVSxE8Q4KPPNNq
         Tlu6Sz8pbgFSwYNqPjdeDrKu0Ii50HdUjPQuAlDqGU8qbQ/bMMt51UNJgI1XcrVRT5ri
         11wGCzfmG7eFx1BkGB8xHfKHDZU5GMdxXhy5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746682988; x=1747287788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvQH4NxuLOJyCK1IWxiQFZho+f+Pe1KaVnYyh/jEzUM=;
        b=m0+ruAPDEt9kqclaDgwC/PD44hrH20OSRbUoUWbkDwBGFSE4xDhTSBHf5521JqvTrD
         JFJx0CPTnp0bsaKhrHyfZ2bPV5QGPU/VSRUZsQoaMIkhPNLQCfoEWRiPqyB16D9NefD/
         yrjefxcrGTwkBeIYxb6bD9OZsGVYJXcejRLYN7NYPKfN0KiRjN6XaVUqpaHv0pZhSrfA
         t96GeP6hamX17EwMONNMMiDqlY2t6ZZNUkqzJ9xAxLhlaJeWB69BrIQHfz2Gbyi90Pum
         e/DlF448wqpmzf5snKyfEQFyNCtKWdsnCDo4706Dlf0jiAvBhbMHYCtaqhl3pRSuvT6Z
         6S8g==
X-Forwarded-Encrypted: i=1; AJvYcCU/ZMN5swS0w9JD3Kv3d1lBE+abnq5JiWvaqPb6JVCwKZRhXe+fY7oCcTM4OM5FSQeVDYVt9EAne2SXNls=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4rCMVT6khqIgwEYrxcx13AhROTtNOeUopSa7kX2QUoQzMBcWc
	YR7wI2XwlZkWD4J82W2ks7PvzXyJoX9LZyTWcxzAlXKKwW697WVlBe98OcPouw==
X-Gm-Gg: ASbGncveGL/1s3n9fMaPWHy8iUxM7LPGWRTdt86W3cubMFD75e/bRe4fYk8x9VaAfBf
	4eHJ/2w6GwcxijsNt5Ecygh5aZ95lQFuj4zJsz0JR22CCoGszzgCW8VXQCrAT0nO0+mQ59d3WlW
	eUIF3aYilg+hU9PXe2P5QCLOClwBMWs+gCreHP9/7+EMBvg7lNBwrx0inbBbLHn7UlaY6wy+Ltp
	4rKP4XBXmENFM19sDwUkPK1EkEfY4aPCU6a3k/vJ5WDSRZC4QYBSMyLmyQNtZtIR3Oy9fIOrZNn
	MvHwL7gF1avAwKw3L91QZyqpbGbTmPxA4bXmnkAYuB2vjhQIEfcT3C0=
X-Google-Smtp-Source: AGHT+IFd8H6WezFjFWEMye3ZxfnhD0jJjbnmU7gtOapiiYZ6ZCqkdMrbyurP3RvcR5r5qSZ94Fi63Q==
X-Received: by 2002:a17:902:e484:b0:224:179a:3b8f with SMTP id d9443c01a7336-22ed712c792mr20493145ad.23.1746682987970;
        Wed, 07 May 2025 22:43:07 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:c794:38be:3be8:4c26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151eb171sm104038075ad.102.2025.05.07.22.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 22:43:07 -0700 (PDT)
Date: Thu, 8 May 2025 14:42:42 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Message-ID: <2auyg2ozb5zppeadmufewg7pt4lam27iyimceqwtnqzt2avf4s@5sri6qk3bmhe>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
 <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>
 <aBrDihaynGkKIFj8@gondor.apana.org.au>
 <20250507171644.GB181648@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507171644.GB181648@sol>

Cc-ing zswap and zram folks.

On (25/05/07 10:16), Eric Biggers wrote:
> On Wed, May 07, 2025 at 10:20:58AM +0800, Herbert Xu wrote:
> > On Tue, May 06, 2025 at 05:01:27PM +0100, Cabiddu, Giovanni wrote:
> > >
> > > > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > > > index 6fdf0ff9f3c0..cf37243a2a3c 100644
> > > > --- a/crypto/acompress.c
> > > > +++ b/crypto/acompress.c
> > > ...
> > > > +int crypto_acomp_setparam(struct crypto_acomp *tfm, const u8 *param,
> > > > +			  unsigned int len)
> > > Is the intent here to use strings to identify parameters? In such case,
> > > `len` should be called `value`.
> > > Or, is `param` a pointer to a structure?
> > 
> > param is just an arbitrary buffer with a length.  It's up to each
> > algorithm to put an interpretation on param.
> > 
> > But I would recommend going with the existing Crypto API norm of
> > using rtnl serialisation.
> > 
> > For example the existing struct zcomp_params (for zstd) would then
> > look like this under rtnl (copied from authenc):
> > 
> > 	struct rtattr *rta = (struct rtattr *)param;
> > 	struct crypto_zstd_param {
> > 		__le32 dictlen;
> > 		__le32 level;
> > 	};
> > 
> > 	struct crypto_zstd_param *zstd_param;
> > 
> > 	if (!RTA_OK(rta, keylen))
> > 		return -EINVAL;
> > 	if (rta->rta_type != CRYPTO_AUTHENC_ZSTD_PARAM)
> > 		return -EINVAL;
> > 
> > 	if (RTA_PAYLOAD(rta) != sizeof(*param))
> > 		return -EINVAL;
> > 
> > 	zstd_param = RTA_DATA(rta);
> > 	dictlen = le32_to_cpu(zstd_param->dictlen);
> > 	level = le32_to_cpu(zstd_param->level);
> > 
> > 	param += rta->rta_len;
> > 	len -= rta->rta_len;
> > 
> > 	if (len < dictlen)
> > 		return -EINVAL;
> > 
> > 	dict = param;
> 
> That sounds crazy.  There's no need to serialize and deserialize byte streams
> just for different parts of the kernel to talk to each other.
> 
> I'm still skeptical about the whole idea of trying to force people to go through
> the Crypto API for compression.  It just results in the adoption of all the bad
> ideas from the Crypto API.

So in zram (for the time being) we use a very tiny (trivial) compression
API, which is more like wrappers around compression libs, we don't intend
to support anything other than that, sort of simplifies things a lot.  But
we are in a (slow) process of moving to async Crypto API.

I suspect there are compression modules in the kernel that have only Crypto
API hooks, e.g. drivers/crypto/intel/iaa/?  So in some cases (zswap + iaa)
I guess Crypto API is the only answer.
