Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBDF211A2A;
	Wed, 11 Dec 2024 11:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733917162; cv=none; b=b/3+HPZgKmes6ljjjQbul+tvDPM47VqUTfZw9HBMn98CQHwvIUoP9nmVJxgu7EylYUgg9K+4wi5FFbAOO/Ej7eTcwik+1cQ0uoHkqhdHEgAvj+bpL/i+eLiQXcwMGF1BbUBJYhPG16wQV5Rugi539FPiBsDuT0+VU2xDotZv+4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733917162; c=relaxed/simple;
	bh=tbspPjYs+73r2j4ySGBJyGBNWGcl3sWds2HJdphhR4Y=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnV/GaS3QE5B70ZpmOSJgGV8uLQREoaYtbBsBd7E+sx/DdNgabhC1K4OLrYfs6oohWfHSFegTQOVlaaUV8iYPHeS1c9P9lKHbSCr2QPpTgc4I3C4+JHE9RjhEOy9QmEbxEavX0DUSUhTPZQ2Byq3XSFmL6Lw9y79lCocg/zmxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vg1UHviB; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vg1UHviB"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3863494591bso2046961f8f.1;
        Wed, 11 Dec 2024 03:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733917158; x=1734521958; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B8lOnb2hGc/HeFSo81ffjoj+9khn7BFghib0/DAmAJY=;
        b=Vg1UHviBaokdWs4hC3pBqZ7xUfurGBU4KK8B1PeSWzwl44plQEvHvNWpF4O0Q5cFyc
         cPopeFv1fJwj77rebZtZPZdCS9Sjrt08HPyFODBYH5jcVcoZRRu0LWvtDznrVjoc40l9
         JPVbktxtTTV5KBdWn+hMpzaKOZT/G1+3L7n9Jo9PAUhYMGtjNNrf2Z/G6eBSfp5bJKGA
         0KoccaSEwWPQ8mkb0L4ahKQtHzk1Ni9RHpIHvOnSfpt48xjZx+HXvMTGekHbGIVxxSSw
         /IVDAhewFWKbCrPSkWJOsX4y9H1mkbe+hyKS2LwntcfjZHagN8SZd3o9KuaCXHId6eN2
         4hTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733917158; x=1734521958;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8lOnb2hGc/HeFSo81ffjoj+9khn7BFghib0/DAmAJY=;
        b=KJOZebLWAYnRn9HbK8hjLy5WFAdctOY0Qrw1sLMKqD1TRfq7KU4xWGZKBzi/IaqroS
         QiZBeZxaUcti/7oOGrlC5KKgs1C9ULlQHlM1eRQIf9Q+qJJOxackJyHPCpbeE8inYohW
         OuMmLwasilsfvq+zonapWiwg0SHG84BJmTrhuIBeBoTqrYO3PZZ+aYNGzNHA5uFVSALs
         ukuSV57H+LQ/nZlDq2DL+q1K688UjrFyAgog7WD+biIYCR3rDzGbZ1GgLKxqWOGRdVoi
         xIJsqkxbpERG6mNWqtzG3rO6KwnsoM/R6bxu5jXoVLyaZt6XB0Rhwxo+a0+s4xrXXqCa
         jkBA==
X-Forwarded-Encrypted: i=1; AJvYcCUX0JElv9GABIAv1y1p8qYSurfSi/7A6yzTWSaQePOrjio04C7N9j6SiYg0qM9E6mNgqQFo/HW8LO4QmPLv@vger.kernel.org, AJvYcCUzyxkJ2tQ7y2PR6AkJCfXYIfU0tE3E+JK1ABV6XrvHzXpTk3MTbrw7DkcQMA10vUqsb9gNhSED7UJvGVk0@vger.kernel.org, AJvYcCW6hxyXhmDp6raqYBtDCHudd0J3KWzIcMSHE6ZZgYIB/U29n70a8nt8Z8ROEV+b2vj8pJ5U2VFLDYPa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8kvRjwlFTnd3fsxISh/msOsAXIZZdkykomaHFbJzonio3GFhF
	PDFlAu4YbHIcS9PfIf69YWQkCoZCTlAeQJBr4gpldqpmBsW6Le82yqhZZw==
X-Gm-Gg: ASbGncvBUYzPaS/r6NJ4zL9nmd5sXMxhotkAnf3lpVnznHTuOAAxh0J6FUV8pBfKbuf
	xVTFkOegq+DOoJOeBL5YqoZbPMJLJLedEM07Jiho3C1ju/5RjeBMuAWE0p9UDTYpZSHa7mEyTVQ
	l69sAPfng0YGQoFHvE/5nIMATBbW+WKUwX067xuZ1G9bqXmprbiZ1qlYfxQHNFuIvemQuEWParn
	PZSNjtJx+s6qxknXn4oMOUg6ud3GqJ+F4UGi4NZaVRM936nQtao60S8Iya8LiRHHjP6mUk9dpor
	Pnxx2ndgpA==
X-Google-Smtp-Source: AGHT+IEu2L6xxMGKBzrUx057O/u6Pru32/aq1pu98cgTxsX305NBsVSVBbNw/7ELG0jiQjX0S3MyBQ==
X-Received: by 2002:a05:6000:4020:b0:385:dc45:ea06 with SMTP id ffacd0b85a97d-3864ce51e82mr2289707f8f.13.1733917158107;
        Wed, 11 Dec 2024 03:39:18 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-387824bd889sm1102564f8f.44.2024.12.11.03.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 03:39:17 -0800 (PST)
Message-ID: <675979e5.5d0a0220.207826.2bf1@mx.google.com>
X-Google-Original-Message-ID: <Z1l54cDWpFTUmsCB@Ansuel-XPS.>
Date: Wed, 11 Dec 2024 12:39:13 +0100
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
Subject: Re: [PATCH v8 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
 <20241210204853.18765-4-ansuelsmth@gmail.com>
 <Z1lb0ImxhhFs4Kuz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1lb0ImxhhFs4Kuz@gondor.apana.org.au>

On Wed, Dec 11, 2024 at 05:30:56PM +0800, Herbert Xu wrote:
> On Tue, Dec 10, 2024 at 09:48:33PM +0100, Christian Marangi wrote:
> >
> > +	/*
> > +	 * Consume remaining data.
> > +	 * 1. Loop until we consume all the data in block of 64bytes
> > +	 * 2. Send full block of 64bytes
> > +	 * 3. Skip sending last block for future update() or for final() to
> > +	 *    enable HASH_FINALIZE bit.
> > +	 */
> > +	while (to_consume > 0) {
> > +		int to_read = min(to_consume, SHA256_BLOCK_SIZE);
> > +
> > +		block = kzalloc(sizeof(*block), GFP_KERNEL);
> 
> You should avoid allocating memory.  If you really must do it,
> then it needs to be GFP_ATOMIC, and your algorithm needs to set
> CRYPTO_ALG_ALLOCATES_MEMORY which means that it won't be used
> by the storage layer as memory allocations may lead to dead-lock.
>

It's problematic for the ring consumption logic to free the block as
they get consumed hence memory allocation is needed.

> The preferred way to access extra memory is through the request
> context structure.
>

Do you have quick example for this?

-- 
	Ansuel
