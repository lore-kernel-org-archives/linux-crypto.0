Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056B8392C2E
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 10:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774002989; cv=none; b=XFx7uZ2mkXG7NQeNhXWtTh8WbaTsiIP34xDZlL6cvjbXaKhYoOPmDHA44xwvO5ry+hByGGJsgJrB1HYyR0+7wC9Y80KH+al7d+AN/OxNfSxACwb63FQ/UqI8HxmGADPDAeFSwp2jMsjmO7H/aEglmlfeas+mtzTW9zoqAY7iNLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774002989; c=relaxed/simple;
	bh=dPRx2MQu6B0xiU4qpnOR7rAWWIXlHsP2JW3UYqre8S4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pm47U7wiu7cyuTgYHcTsbXRoh4Sk1oWHjE/hut+Xyrn1wAWVyiCwrpcQ68CgY8LPrXyGdt+T7UJKPLHeurO3IbtAV69R9HB5OIDFAzAoGlto5KuLa+QafV72uSC6yjioiYVLEKB1WxyAFIXVaeG8NYRKjE7Kwb+H9rhUGTcXpFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awcwj682; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awcwj682"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48628ce9ab5so5312745e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 03:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774002986; x=1774607786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgNW8ZyRv/2L8K0OWsGTx7038b4mfqW4545kvGPn8uw=;
        b=awcwj682VrrdkM39U4ibxVkwswu8nu7zO3ctfLy4jkeXYj6I4Zk40pNMe2yMtlfMcX
         eCq+kZuczvpfEq3JP4iZ901ngxoaZD1fPszq1URrt1a81kFY70fs2LXwrIY252soS3PI
         li1Fuzib57PTXCpAG960iQAdjUTqFrzo+VQMvh1DTZRS36d59QLTzLSgtaky7e80tHqg
         cbyWK5cnYqeNh6rbD+12hXT9uiXzppTy+e2uf6eZ0/h1RgJLwVG7EUhWtac0Qu0/Ieg+
         ubuQONZfzMJJryMy2OY8ebCr+68NA36aLCag30BK/fi0g/6YMzS1EDoWubfMXParLbHD
         P/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774002986; x=1774607786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QgNW8ZyRv/2L8K0OWsGTx7038b4mfqW4545kvGPn8uw=;
        b=QV5v2auRy8PGWnIE3+8UZnwZUkExXSn39gdV8HZOhBCqi+gBTJYDGkHuBWplQ1omMi
         4ki5M84HweOvJqhGUOaPywgdSUsFAka+MkIfifRm7s/SA9ivjt8IlV9YZTbopX6EXRK3
         UhM6xiYEbvQxkGgE/o1TrTHlp4H+uDtriStqsbhcfflqqo26CLaue8CpYpSoRB4Qn+TK
         6bm0BqXwcPPyjUtSDqUvucN8llDbnl8LToSiWEdOvqbyGLRCb4sC6CXPxOf0vJXFWV1O
         gSNoYPkeA6bQRZ5IrhFtqGy1Y3hSe/yYqbM3klpWbLPa4YkUuZoYeXKz75J0eYp8G+aV
         EEkA==
X-Forwarded-Encrypted: i=1; AJvYcCWZbC64XrMJwKECEOoiuC2nRK4B0PVqKMjUM/VS11JVq1e1XinlpFAfipWTpr3AXwqmy2BMLkygXvZdvZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMVgIEiN347pu+ZC7A7Tq7cXYJg1Ojfj/mrK61lomdoPg3aeI2
	S0bhIOGyQnU4hYTzC7d4Iv8PmkywnpMFdpkLT5S0refDT8/ViNd8Mgprh9GA6M2i
X-Gm-Gg: ATEYQzxZ4Vm/DdP9k17kU6Uf6OdinayxQIIMeZPZWYZ81zL9XNrr7zhR1tRPchVk6lo
	MFpDQT3zZuMLE2wC94BE4K5URG6H0pJOKwCraNl1nnnOy6lFpTb/qVC5ZBs6mdw29PbaWc0HMeM
	95E6oYSBaGHOsBuND08Yf9TWM9Kkjjbo9v7YSsYuLF5z1XLkSLWIaVafLGB23O7iNiihYEUdurE
	WHQIW7mXAci1p+Dx0qp7sRrnfUYC3l20B90SA6nK3IGYJYkwdCuDItfC2qoYxQlnkYPM4Z2Fbmt
	gIDcE0UUKxbqbL6ZL0XA7MMVF7GfB3R+jbiaD9/PCY/meTK/RMwJ6EWwwcqdGeozCuc/cMNcGOa
	oALRoHQoez0waCQbecAAbAB5TuZmKa01arG2Iv+2K7LYhkd1CJJI8s1DwP8Ix7ui599p9I3WGAh
	I1vZE5Xoa58zNlFpGE4CfdS/xjQuSBLNAJa9shPFPOKfGUc90PiLw+rnFeu6spACnS
X-Received: by 2002:a05:600c:3b23:b0:486:fdc6:1c0d with SMTP id 5b1f17b1804b1-486ff02da9emr37797415e9.22.1774002985855;
        Fri, 20 Mar 2026 03:36:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470c239sm4926279f8f.27.2026.03.20.03.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 03:36:25 -0700 (PDT)
Date: Fri, 20 Mar 2026 10:36:24 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demian Shulhan <demyansh@gmail.com>, ardb@kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260320103624.0e13d26f@pumpkin>
In-Reply-To: <20260319190908.GB10208@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
	<20260319190908.GB10208@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Mar 2026 12:09:08 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Tue, Mar 17, 2026 at 06:54:25AM +0000, Demian Shulhan wrote:
> > Implement an optimized CRC64 (NVMe) algorithm for ARM64 using NEON
> > Polynomial Multiply Long (PMULL) instructions. The generic shift-and-XOR
> > software implementation is slow, which creates a bottleneck in NVMe and
> > other storage subsystems.
> > 
> > The acceleration is implemented using C intrinsics (<arm_neon.h>) rather
> > than raw assembly for better readability and maintainability.
> > 
> > Key highlights of this implementation:
> > - Uses 4KB chunking inside scoped_ksimd() to avoid preemption latency
> >   spikes on large buffers.
> > - Pre-calculates and loads fold constants via vld1q_u64() to minimize
> >   register spilling.
> > - Benchmarks show the break-even point against the generic implementation
> >   is around 128 bytes. The PMULL path is enabled only for len >= 128.
> > - Safely falls back to the generic implementation on Big-Endian systems.
> > 
> > Performance results (kunit crc_benchmark on Cortex-A72):
> > - Generic (len=4096): ~268 MB/s
> > - PMULL (len=4096): ~1556 MB/s (nearly 6x improvement)
> > 
> > Signed-off-by: Demian Shulhan <demyansh@gmail.com>  
> 
> Thanks!  I'm planning to accept this once the relatively minor comments
> later on in this email are addressed.
> 
> But just FYI, having separate code for each CRC variant isn't very
> sustainable.  CRC-T10DIF, CRC64-NVME, and CRC64-BE should all have
> similar PMULL based implementations.  x86 and riscv solve this using a
> "template" that supports all CRC variants.  I'd like to eventually bring
> a similar solution to arm64 (and arm) as well.
> 
> So while this code is fine for now, later I'd like to replace it with
> something more general, like x86 and riscv have now.  Then we can
> optimize CRC-T10DIF, CRC64-NVME, and CRC64-BE together.

I'm also pretty sure that the same loop will process 32bit and 16bit CRC
(just needs the high bits of the constant multiplier set to zero).
There are fewer bits to correct for at the end (I think it is always
the size of the CRC) but that may not be worth worrying about.

> E.g., consider that the CRC64-NVME code added by patch folds across at
> most 1 vector.  That's much less optimized than the existing CRC-T10DIF
> code in lib/crc/arm64/crc-t10dif-core.S, which folds across 8.  If we
> used a unified approach, we could optimize these CRC variants together.
> 
> As for intristics vs. assembly: the kernel usually uses assembly.
> However, I'm supportive of starting to use intrinsics more, and this a
> good start.  But we'll need to keep an eye out for any compiler issues.

But they do make the code unreadable - probably even more than the
assembler would be.
It might be better to write some C that required the architecture provide
the functions required for doing a CRC with 128bit registers that hold
two 64bit values (etc) and give them sane names.
Then common C code can be used provided the required instructions exist.
I'm pretty sure the loop is effectively:
	for (; p < limit; p++)
		p[N] ^= low(*p) * const_a ^ high(*p) * const_b;
where N is at least one and you don't actually want to write into the buffer.
Making N > 1 should improve performance - just needs care.

That might be what you've done for x86 - I keep meaning to look at that code.

	David

