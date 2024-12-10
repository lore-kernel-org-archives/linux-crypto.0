Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB931A08BC;
	Tue, 10 Dec 2024 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733833011; cv=none; b=cdKrtgaa8361DSwjDYPhMuQExVczfROxQJVNnAq1YI+mV54h7TptutILae8+KdvCrxg24k8LCBIvX7b5AMsYROTbLHSRby5RfetQVxQoqZ00lSjtp2yEzdmMGWwdX7P65TV4PxyZYzABaO9fyGaehBBZgBabh9kz74nd3YSOjiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733833011; c=relaxed/simple;
	bh=WDfgjmse2TMOfKgkubZlX/dUuqS21zwt9rwCmWHbd2U=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxfW+mF0VPbsmlOU/bIEKvsMqxYTMMmQLdoGPDvrCFsdR0iIOtNGpkgxEeUvR//ZW/ArzwYnHt78zoxdeN8gkEVypvsJ+IS1fBjyDECNxCvx2xtjX08XhGBnt1ThV14OQbhkkOtAkkBrlhqTwcdEz2QCBBkWCdplC0Wdj+j/MYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVOzDago; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVOzDago"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3862d161947so2660820f8f.3;
        Tue, 10 Dec 2024 04:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733833008; x=1734437808; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yf1CFLxebCAG5P70tlgOYPGg7XUceZtr9bdXkbq3ysE=;
        b=dVOzDagoJXxCJcWjQwJP6wvmRXEe5alhIxZ0oBjip/qgAN/aqFaAJBz91dcT8MMi27
         MHxMNBIzum8OyYcM2tbRtvOAACx4fknp2Ob+0u7c7gRLdbKD8nfUeKRKdpU6OfDmBuf1
         qXJ2OECR57ig1ER5+C9ZRi6DZWkr29QkSCb+YfxyLtCvynqo5evA77nFc0YF0LWbH3+p
         lbthpQf1FV9WZE80f2o0IRJOzJSl1S2ImCt8Ks7hv2SyHqQBiJgxaLc2zxiM77rqyJNF
         yhZqu5VxT03uK2AUUqHQZjKCJlaAZ2/4MiK5TMVeZQIVn/c7IjAGc2QVKbCNS2UZtrVO
         2sRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733833008; x=1734437808;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yf1CFLxebCAG5P70tlgOYPGg7XUceZtr9bdXkbq3ysE=;
        b=b27ufNBQIRItyIc4mnz8qg+7PksJ+OodWO6R3JrBZRDheJiE9QvxK1VO2Y7L2vbYqt
         7pqSc4Y/uhcahUA6UteAToCm35L0tjpchUmefLLv6Nl0P+tbfNLTK4Ll0fd5PljdHScZ
         DJC/MIsvgGKszq7Vo79edZrQ36EbGG7jnaHulc3032i7QGELPO5uvJ18aKrGY4eJon4Q
         bQtVxlC5tuB55IbAabOtQ/Y/28INTa9I+SaFa7K+jz72IoI7HCKo3OEqOZYijnas+VEE
         8uAf0jQq/ObHxgM5yxmPyYt9l5dTuUvbeG/xoPmbF92rcQ3YbVu8YwywpgFwxSBrNblQ
         SX6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5a5pU7D8rxs5WpGy/vfvx0sPFa5oK2PiQ4KVBSeQCf0+ajsn1hryr+0D7fN3Z9Rvgtn/DmhrU+HWK@vger.kernel.org, AJvYcCVX5FPzWl4ge9R6TiXu2BF+AlV+2lkX2PK8DPPTB6qyjVzjrzGwDKLNfUKyylcW1EOcKTUa3NuX6tYNlJ+5@vger.kernel.org, AJvYcCWmWT2BPgDJJawvismslFrdq0kpCF0SGLYjF5R45K1lCSTrcFLQeFLm2gupJpGoI4HsxKfpMJGEaXt7NcW2@vger.kernel.org
X-Gm-Message-State: AOJu0Yw20btfVHcmeTBnB9Tb3DTZTOh2Hf75MzHKNCTrLkLsRwOC953v
	6eVXsxX2ECCcFusjR7QHTvvoB+KqtFmWxgShVwDnHg5LyEO8eLKf
X-Gm-Gg: ASbGnctz49PFk2SKaVM0rEP4KjNKvJH6WbwnXyu4yv8bDvIOxWvOa9F/lnC9KzVL6BY
	ys/TLIeGjR1IeFhWHMflJmxiGju4flp3uAh1XQuxFsWNDb9zx/EobpK6+VGNycX86YZyss2uWwh
	JKY07+9rBUVDdDzjFWkeCr3JrbbFE3M0x3vFsze4uU8uUjB8ZMvUpzG+nalGUssrJOCOLGph9UD
	X4tWOzftzIg3rOZvxqAvJob5Qo03GCh5JWy9ainGnckiYlA8NJg22H/DF7XOudk7B6vV3PH3PnT
	fX68WLLlDQ==
X-Google-Smtp-Source: AGHT+IFBSN43Psq6k+DTijIAspWlXZR8HbAtwGfM6dwGhrpaSfysjOOAtiOSQbKYF3yUXI06CWd3KA==
X-Received: by 2002:a5d:64eb:0:b0:386:3918:16a8 with SMTP id ffacd0b85a97d-3863918193dmr7873771f8f.13.1733833008325;
        Tue, 10 Dec 2024 04:16:48 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3863afc16b0sm7398163f8f.37.2024.12.10.04.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 04:16:47 -0800 (PST)
Message-ID: <6758312f.df0a0220.100594.1c3a@mx.google.com>
X-Google-Original-Message-ID: <Z1gxKlFB5qeuJpfc@Ansuel-XPS.>
Date: Tue, 10 Dec 2024 13:16:42 +0100
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
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
 <Z1e0LHycNGcWqd2q@gondor.apana.org.au>
 <67582c1b.050a0220.83ef5.c8df@mx.google.com>
 <Z1guyCJy-Cpo7U11@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1guyCJy-Cpo7U11@gondor.apana.org.au>

On Tue, Dec 10, 2024 at 08:06:32PM +0800, Herbert Xu wrote:
> On Tue, Dec 10, 2024 at 12:55:02PM +0100, Christian Marangi wrote:
> >
> > The main problem here is that .update only enqueue packet to be
> > processed and we don't wait for it to finish as that would result in
> > really bad performance.
> 
> You can return from update prior to finishing the hash.  However,
> you must return -EINPROGRESS in that case.
> 
> Once the hash has completed then you must export the hash state
> from the hardware into the request object, and then invoke the
> callback to inform the user that the update has finished.
> 
> At that point, the user may call export.
> 
> The user cannot call export prior to the update completing.
>

Oh! Ok, that is neat. Just to make sure everything is clear,
to complete the request it's the same used for final, the
ahash_request_complete(). I tought the -EINPROGRESS,
ahash_request_complete() pattern was only for final.

With the following implementation this is totally ok. Thanks for the
clarification on this.

-- 
	Ansuel
