Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8D818B47E
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 02:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741229318; cv=none; b=t3A7zgGs+zSqxtYESdoC9UL1BaPbfGO1eHUc9e5Ql8S0CwvZ5qfVKZ//4UWG8eGCCCzk0TcanwxkMPx2QakdR77QOP8HjAoA4d9Pj7HUP8zbjOGylWAUQxs9u4mFm9+6U/71Qf+0dcnHRMVQzqgQG0gG8QD/Zbi7ULWuVjHwvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741229318; c=relaxed/simple;
	bh=uPNYVc3UppXm9hsnEP1h3cpyCORrZGpxm3/d5Mg2jl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNuMBODPAoPLSUKdWsLnIv8YDQ8ZeMOZa1jNvyMIF3tm3R8xYpHhruft/vRQAqM7gDfpmSfb3HdRQv4lWmRu4Y8Dj9ci/H09jznB3m7AHFFCsfT7PUlQztbQQZmEtNOwuY2J+/FN+xy6z5YUUi6yd99QUsXG49n6357zejVdx1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=eiEzm5cr; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eiEzm5cr"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fe848040b1so414794a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Mar 2025 18:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741229316; x=1741834116; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EwVWBOdzAZFDUrVCZ0TYEQNSfFcaIacpoDQH/C8G1OU=;
        b=eiEzm5crH0/sMDeCPupRd28rpjEKsy7toVqRLF9FWsCdtuTVPHFx65l/H3VllIdbFj
         qUc/Kyo9wGroqkXruMXeFnzphOTenGg6vmS3RzH3cMUisIR5xlGVsHxyiLWzo6TXhrVt
         vbcANVpY61N7cHtfWx9dWlXBb6euJvExjwpqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741229316; x=1741834116;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwVWBOdzAZFDUrVCZ0TYEQNSfFcaIacpoDQH/C8G1OU=;
        b=r8sHAlwPDFYDsZWExz/afl+E3TFuTKQf4D8dMPQy4h/EpGKxFSvZCBYtnOurO5NJUP
         maNV/SXr35CVvAzM9I0dgwM8iEDmA3K67iv0Wi7yUj8l0Fru/VkM17+0ghUs/FbLlQr5
         /6a1Goi+HSDutfkSdsKvgYoF3XMo8Amk5fgGozvXJZou0OTF9CePUt7qqHZqSHuuNgcL
         0UXzV3IniCbC7gGzwwIrQzhGLIBqUwfs+dBH0i5cpkNnxouYgPEpZ7i7MZZ4T60OPpHi
         B0hNIgJazg0jwsHjNGb2dpnL6R4j4HwWRr14z5xupg3vBdW22Fywj9HFuQI6QrMmj8jR
         uMGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUKsEpGpZO7hYVwyXBA/zc2vHyBDqNiSy9TEzV3mVaeMQGs623opvzaWLHwUjWk3SnZKv8FJMRpD/y4BM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPkVHCQDtTjGpegc3InLoblL3ZFAmfBWbCk55M+VpcR9RAczzv
	f1HyIMN97X6r0JBchRYuh5RUSR3Eetm3KXFKHrzwI++lMOCsVr+K+EE/Y94Tiw==
X-Gm-Gg: ASbGnctjvWY6YO3rjfb8llHLIG+ABvIzC6K6ovJUszw4kpUA9l94S2DQ3FIsPfpdji+
	I6BET0FN4lJtapYxiiSzd4LM0G0qoNQ4lzWC0UZvhriOgPhisgSmKMSbzcdOYONdL4+oKRxf6rd
	kDGWEuDqQ7OBjHKZtbW7QasDdUtH6LcPLQQmOrOG3oVyqWSowtYzs6iAEBWTiuuoqHZfhm/UPvR
	pDF5yCMJEndOUhVGdYCnd+ZgX3p1MfKUIRnK7lYXHsUictn0PDeEjJtIMnxDCqWtQxs3Gg5Y2mD
	G+XmnGMlf9wyfxWws6KeopFPuLhEI4Wg4YEKKZgRYEa7M6hr
X-Google-Smtp-Source: AGHT+IFIArgRzLNGNrgRJZdaaHvP2M0KzTaCSzTD4thI/cKyXM2KJp9u20CrvciiusRzKtXjic+oIQ==
X-Received: by 2002:a17:90b:2402:b0:2ff:53ad:a0ec with SMTP id 98e67ed59e1d1-2ff53ada24fmr4619812a91.21.1741229316507;
        Wed, 05 Mar 2025 18:48:36 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2558:9089:fa0d:5caf])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693f8804sm183276a91.47.2025.03.05.18.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 18:48:35 -0800 (PST)
Date: Thu, 6 Mar 2025 11:48:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Eric Biggers <ebiggers@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <tpwzz56hn57md5hby734jygl5tnvnrggfeoxxemmuqbwa5zroh@46hjqovwki4l>
References: <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com>
 <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
 <Z8fssWOSw0kfggsM@google.com>
 <Z8gAHrXYc52EPsqH@gondor.apana.org.au>
 <CAKEwX=MoiqOCDt=4Y-82PKUg92RtFxR1bOXOottSC2i1G7Bekw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MoiqOCDt=4Y-82PKUg92RtFxR1bOXOottSC2i1G7Bekw@mail.gmail.com>

On (25/03/05 09:07), Nhat Pham wrote:
> On Tue, Mar 4, 2025 at 11:41 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Mar 05, 2025 at 06:18:25AM +0000, Yosry Ahmed wrote:
> > >
> > > I think there are other motivations for zcomp. Nhat was actually talking
> > > about switch zswap to use zcomp for other reasons. Please see this
> > > thread:
> > > https://lore.kernel.org/lkml/CAKEwX=O8zQj3Vj=2G6aCjK7e2DDs+VBUhRd25AefTdcvFOT-=A@mail.gmail.com/.
> >
> > The only reason I saw was the support for algorithm parameters.
> > Yes that will of course be added to crypto_acomp before I attempt
> > to replace zcomp.
> 
> For the record, that's also the only reason why I was thinking about
> it. :) I have no passion for zcomp or anything - as long as we support
> all the cases (hardware acceleration/offloading, algorithms
> parameters, etc.), I'm happy :)
> 
> Thanks for the hard work, Herbert, and I look forward to seeing all of
> this work.

zcomp arrived at the right time and served its purpose.

Back in the days, when I started adding params to comp algos, zram was
still using *legacy* crypto (scomp?) API and Herbert made it clear that
parameters would be added only to a new acomp API, which was a blocker for
zram (zram by design did not support anything async or even sleepable).
So the decision was to drop scomp from zram (this should have happened
sooner or later anyway), enable parameters support (so that we could start
playing around with acceleration levels, user C/D dicts, etc.) and begin
preparing zram for async API.  The last part turned up to be a little more
complicated than was anticipated (as usual), but now we are reaching the
point [1] when zram and zsmalloc become async ready.

With this we can start moving parameters support to acomp, switch zram
to acomp and sunset zcomp.

[1] https://lore.kernel.org/linux-mm/20250303022425.285971-1-senozhatsky@chromium.org
