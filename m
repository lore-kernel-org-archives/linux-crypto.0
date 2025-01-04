Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED7A211C;
	Sat,  4 Jan 2025 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736007999; cv=none; b=Xn6RtFD+9MNmNE5oJqmdTOYwPoN0rAl3ZXLJTyy8PT2QNWNiFoGjxWnsTwPY4lOMq0UF7W02+cF4z9W/FEHY6cSgpAwcBohPhUVhKq6mCdfTP7tU5TiIWkx/rOey6bNmLZiYiMLO+j5USoQz1tgSq0wQhlAQaWlJFcIIzB/A2HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736007999; c=relaxed/simple;
	bh=+2hu2HBFZ3z098bnGj2w0wakHLQJ1X+CDDzNKkFvSo4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Am0ZgM3GTCoXuMw6e4NULvFpKlDlIYuUGe4skoVrwZTgcxwywzmnBdOKKdzhC2tVAtj/CYjqlVzDM/3jru0227WqwVoJJogzXy8dkA+I7TUMPKZcEKr4ug15BnSgdTZf+6bYcxMxogcnraIe3pj1pSd3Q8uWOXXoNglIuIdMimg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MrZP4R5P; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrZP4R5P"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-436345cc17bso94927185e9.0;
        Sat, 04 Jan 2025 08:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736007996; x=1736612796; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nTlW5tpHNJbidyn2Hd1CGByd7XKtmPkVfZjZnPxhfiU=;
        b=MrZP4R5PiDR2VD4LVtyzTyOapw0kz8tvjuY7HeG8Lkgu4wU7/huV8G6gTQmk7Y1gV8
         /NX5+Nq/9W/TREPQDyKCqjDCfoVsepjgHxYWYaCihkKaw7R6WP+G35XeiQY1m+3hlbPg
         ECGms9p8jhG1R6pIO5GELtbsV6yyxbCVfidBIUFoH/wIReqXmf7LSuTqxbV04zLudwuA
         b+/hBz7vQY52+6qOKcDsPbnbNqnqsL6RRZZ+pT4Fuw3BA0YanG6yPW3wybswvKvUdNuk
         xZvO6NUOIzbSKnAbvFQ/Ove6fJhnY/NKmQ4uRuIyaQ3HtRZyi189EqoHh6etAvr16aAb
         3pHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736007996; x=1736612796;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTlW5tpHNJbidyn2Hd1CGByd7XKtmPkVfZjZnPxhfiU=;
        b=XWpL6hsp8iSq8Miwjw/tEcxtzRhQlCVG6zMIHd88RV9+e+v24/4HywTFOPgoF2Znt+
         /E3fxIvHxZ3mT0uiPe3zSFsmgGYp7PoeUO0053xXd4eTJkLDvugyJml+AHMq2rZt1fi5
         lmPLdnOSIwLlI+9PzCiOFpeOe9P5bnWZVHTx90yWwTDaDABr+UW7c6aA+TOGet8aTaDu
         96FEaexzK51pXzBAcPLU/HlOLLE/OXMr9iCxThPcF4/ndxoJro5uu7WgLjsv9NrJgE3C
         3G5Le7JoIuvq9lYzIuClWDd0KhC8mWYCNKmyK8TxnNBYDqcYIIFKg6A5aFtpbuNFKMeV
         3uIg==
X-Forwarded-Encrypted: i=1; AJvYcCUmsRy30dg0mQjFdalaI2uwOGO3RjHRx+raS4vbnwJF7b814GOcy1SA1ZmpvBv3ZjIFRK437PDUq8t7@vger.kernel.org, AJvYcCVBbY2ij3HV+sB6soYmEuSbyp5d0GttBxfZcFbgFHPGxErCspXbZ3e7YphgUC+mPaEtmbkQ/XtgyraWQrt0@vger.kernel.org, AJvYcCXLxQHaNZFl4QeJwYalzQ6lCFIodta1EP0YK3xWqTf2f9cgf7RANoSU86S5r8xJ78UH0GI9emWja4rp+kzQ@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdmo9eiTfEhQPOLUYMaz4mtCpimcbRAgOS7Ce6SCMiunoZ89iE
	U9MPMQ/hK6g6r5QOtW2PfwnxfpH9fYFyK9iKG/b9UboZnUyMORmp
X-Gm-Gg: ASbGncuR55nNCsAftkif/l7ugm0pWJJBIFNX2tzKXpLSfeZ5CkrGDj+Ph5rPJ0d4og9
	Zg6UAVqHDXMRPh88Si6wcyc02tIo0hIF1zzze/YlgsUE7gv6wCYeUIunvVeC1cKVl+1hsbo6RLc
	noSKIZH7ub6GLgKsFikE1nSwW6bth65TmN93Q1pB7Jis1nfaIToSlWEd/kLqChdvyvvHLKPvzrW
	k5gJwxdWMGVrXey/uleFwMaJU/Q/hKneYqnYyweifl0I7Q4DRlnR7E2YaObRzJKXGeRG1yQGpZS
	LF6n3XY9z1SwjuFuXdM0Klto5kkx
X-Google-Smtp-Source: AGHT+IEYyWCHbe8Xmh/2fe8JTYwqsP1+JeqaC3d0GDdR+GXkSctHI+hIK/4TMHem5BXiKUDqAK4wFA==
X-Received: by 2002:a05:600c:470a:b0:434:f767:68ea with SMTP id 5b1f17b1804b1-43668548337mr441848705e9.5.1736007995848;
        Sat, 04 Jan 2025 08:26:35 -0800 (PST)
Received: from Ansuel-XPS. (host-95-246-253-26.retail.telecomitalia.it. [95.246.253.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4366127c488sm515449015e9.27.2025.01.04.08.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 08:26:34 -0800 (PST)
Message-ID: <6779613a.050a0220.184c1c.c90e@mx.google.com>
X-Google-Original-Message-ID: <Z3lhNNTbHX6We7M8@Ansuel-XPS.>
Date: Sat, 4 Jan 2025 17:26:28 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v9 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241214132808.19449-1-ansuelsmth@gmail.com>
 <20241214132808.19449-4-ansuelsmth@gmail.com>
 <Z2aqHmrVAm3adVG6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2aqHmrVAm3adVG6@gondor.apana.org.au>

On Sat, Dec 21, 2024 at 07:44:30PM +0800, Herbert Xu wrote:
> On Sat, Dec 14, 2024 at 02:27:54PM +0100, Christian Marangi wrote:
> >
> > +	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
> > +	if (IS_ERR(ahash_tfm))
> > +		return PTR_ERR(ahash_tfm);
> > +
> > +	req = ahash_request_alloc(ahash_tfm, GFP_ATOMIC);
> > +	if (!req) {
> > +		ret = -ENOMEM;
> > +		goto err_ahash;
> > +	}
> > +
> > +	rctx = ahash_request_ctx_dma(req);
> > +	crypto_init_wait(&wait);
> > +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +				   crypto_req_done, &wait);
> > +
> > +	/* Hash the key if > SHA256_BLOCK_SIZE */
> > +	if (keylen > SHA256_BLOCK_SIZE) {
> > +		sg_init_one(&sg[0], key, keylen);
> > +
> > +		ahash_request_set_crypt(req, sg, ipad, keylen);
> > +		ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
> 
> Sleeping in setkey is no longer allowed.  I don't think it's
> fatal yet because the main user driving this currently uses
> sync ahashes only.  But we should avoid this in all new driver
> code.
> 
> Easiest fix would be to allocate a sync ahash:
> 
> 	ahash_tfm = crypto_alloc_ahash(alg_name, 0, CRYPTO_ALG_SYNC);
>

Hi Herbert,

I'm a bit confused by this... I can't find any reference of
CRYPTO_ALG_SYNC, is this something new? Any hint on where to look for
it? Can't find it in include/linux/crypto.h

Following the codeflow of crypto_alloc_ahash is a bit problematic.

-- 
	Ansuel
