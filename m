Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2220142E7C;
	Sun, 10 Nov 2024 11:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731239976; cv=none; b=WEhHruf3B/qQ7Q22elRmJ4Li+Jju2gDUS1HfycyUut4fnyBWlEW/XpowvB1oZpRb7EWmBWSb0vPJA6lqZZEnihKth/rLBjrugT4eT4glUXyCucb6IkRAK0U1EPIxDmGz7oFNOuIEqKkSjaXmzr/LVeqzg8lztDqyTiRPwIgn8sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731239976; c=relaxed/simple;
	bh=zfgHxG2V7R6MBYczHFOAGh8VsRb1hk8pspj/yDEss10=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKf/jq2+VYbSwSzK4LNl4wErS+TcxUeEMMawrsMC2vx9zdOzm3DSOagMvAAINNqdNSyBX06G25ZRzhqfr5C9B6LASFOtx4e3Shax5AcFva0zPf+mGZlhFpX5XckwqUDB7MbCjQ28Cy7bjF1iHgwCK2U5DdJk2+iUKAO7G1Gj85s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X0v1M+Oc; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X0v1M+Oc"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d47b38336so2843693f8f.3;
        Sun, 10 Nov 2024 03:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731239973; x=1731844773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yFaKqABtVje41PveytIEZx/xFmb5usiiYyWy+vMnsAA=;
        b=X0v1M+OcYsO2giFnVbywt70Tm0ZDtANNSMRha1Yt6I+WLtBYsigIc/gBWFC0ONqUVZ
         cTv+4NQgeropFbbzZX80lvn0riHgkT3DQJSrQNx2BSmOMn+TR4SmqVJD7XLS9SY4+Q+T
         FDGQ8Xb6jzoHwnXVslssB0l+LKYRmeUDTCzyzL/Bt+msUmGcZJ2SBuS2WTYuZCujiLyV
         Osgw+ujL+urqqIg6NZJ4pB9BN3axIHiO45z+hF95qghFXj6kk7GYpxEgsztrxVUbCz0A
         mNIi7/PBy6eWFOAAI7k1gd80oTgI4y71vNWeoxJmr8o46Cvg/TVXJg3CgjgJP32cyaZf
         TVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731239973; x=1731844773;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFaKqABtVje41PveytIEZx/xFmb5usiiYyWy+vMnsAA=;
        b=UUX+hPPlBrZx/bn+sHPvZqvjEuQuqM+1WJHinlgVLtGi+ifDcDleB+D5H03Xls130q
         L4QHhcKmSuhEPFGgo20JetMUYP5nVf1P1KRN5+1CukzlwKCoPGUQGZLjZ13RSutG84Bu
         9x/99b73A6PrN5bxJdGwxwl7O4wzKCx2/ll3tIsYhN9TLckcsJDVRb3THAhKi7AePoQD
         v8gmI3tcAXJkWdSCsIQdbc/vb6O+S/HM5l1bBMdYWd0NPcmB59jOO03Y8kjVZ+0beEmf
         Ks0HJeQV8+IwIAs5VmSestwtUifqAmuH5PbFdmBFXLqtgKcxSpbapW8PTu5ocfnqzZJb
         1WFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAmgAUBtELjLPZ2qyiwvTcqdUtLoa7V6p+UU8Ega6CuAYNREAqiUhmrjDvQVs7EP4kBkN7ka1SjU/v@vger.kernel.org, AJvYcCW3FeyN8Pv6d7uzyHzUId4Uvwrea50Sj9DwRrLcnhiFngiYCm13Xxk22cfafaRoKQsb/KneAujk1EjQ5EcV@vger.kernel.org, AJvYcCW5tnq5F7yIutJblgi3ZNu47kRiw+mhCY+f2reKi5fpfURdQ3UDREXxyLuytqweqBjYV+VYnAVUCXHCGXma@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ7+eHFsZP+Krqol79aczK2U8JRqqRnEEIXgqbFfWY/YBEOf7/
	ZpfjWy+e0WnFaC+TLgKHQP6VG6DGeLhc/UBCqU2H5zKzu3oCbRkD
X-Google-Smtp-Source: AGHT+IE+w+f1yqAk37VzarCVULMGirAo8M7q+uexJAXDVO4xf99ztjU27W78o86exqp0sU3HrqQqpQ==
X-Received: by 2002:a05:6000:402c:b0:37c:d183:a8f8 with SMTP id ffacd0b85a97d-381f186b35bmr6512046f8f.19.1731239972786;
        Sun, 10 Nov 2024 03:59:32 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa74abb9sm179621495e9.42.2024.11.10.03.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 03:59:32 -0800 (PST)
Message-ID: <6730a024.050a0220.17c784.0c41@mx.google.com>
X-Google-Original-Message-ID: <ZzCgIUla8ENQPT_5@Ansuel-XPS.>
Date: Sun, 10 Nov 2024 12:59:29 +0100
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
Subject: Re: [PATCH v6 3/3] crypto: Add Mediatek EIP-93 crypto engine support
References: <20241102175045.10408-1-ansuelsmth@gmail.com>
 <20241102175045.10408-3-ansuelsmth@gmail.com>
 <ZzAskOZyclM9dWsg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzAskOZyclM9dWsg@gondor.apana.org.au>

On Sun, Nov 10, 2024 at 11:46:24AM +0800, Herbert Xu wrote:
> On Sat, Nov 02, 2024 at 06:50:35PM +0100, Christian Marangi wrote:
> >
> > +static int eip93_hash_import(struct ahash_request *req, const void *in)
> > +{
> > +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> > +	const struct eip93_hash_export_state *state = in;
> > +	int ret;
> > +
> > +	ret = _eip93_hash_init(req, state->sa_state, state->sa_state_base);
> 
> You cannot export/import any kernel pointers.  The state is meant
> to be a serialised version of the hash state.
> 
> So state->sa_state_base has got to go.
>

Hoped it was OK since it greatly simplify the logic but OK will do this
change.

-- 
	Ansuel
