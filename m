Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C663C;
	Sat, 14 Dec 2024 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734183157; cv=none; b=iERXMTRBTAlBmK9VF3ORf0c+A3QavHgNPWKDlF+fsCq6pfHPCUCJL1krVCPfqZbPxLtwRK//HTY6ZiXpg9Az9WyvEUsICbzmKmzKxu54ffzQ4cDcU7IDjyeFIEBUfoeS7fs4Df85tPSiVYfwVf9VMmGjwqkEHLZzd6YOVwDjbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734183157; c=relaxed/simple;
	bh=rj7r3lu0zdXSXQRfn+FqEwD9DtqSI15OA0S9yniDho4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5aN8HuU4I4pUiJq5XkHRnNutmnZvmehWnuF6pCwrasB4EOfKPVNwIeI6Fjhzit8r/mtuHmX4fEGAlotPejabXi5iKUbl9s+iyFSqe6G3JoVKbmR4wYiJcslu07NqjpDbnnvLxY3uszG7lhOZxxTSjeck0ShxOrbozGzoyKmVw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=di9SNgx6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="di9SNgx6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso18858295e9.2;
        Sat, 14 Dec 2024 05:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734183154; x=1734787954; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9g/vBJjPtbTlrMR1/eypOk5GU1ytqwbwGWCidwQB9RM=;
        b=di9SNgx6PWZUDbZ5kHSHb8EIQzUI2Cych36JkP0cdL2CVKnLltgv4uPOW/SeuCPiJD
         lk8mZXdCcvJB09J/1xDZIVKfVoxu5VrvItq7AVxdeodPqBaEe8qz2fsBuX5L0rdFncLP
         o+3w7+syOUmk5XwLVDSC/G6ZsOaIMj0xlJs9byPfWp4Ic0efzq3dF7hSiGozTko05FbH
         zeFoKIs5MoBy6Gqr0KSL5CzA2sb84GI/tEs+JBBzE0QqAPPRGErYAunAPQ+SRobm9oHi
         NSpocIxV8/zvByGxF9thvspwigLmIaC6wODgFMBuWiDMvfE/MH5DmwkKAkN8CuQfmotU
         SSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734183154; x=1734787954;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9g/vBJjPtbTlrMR1/eypOk5GU1ytqwbwGWCidwQB9RM=;
        b=XnqYvb420Ovwa3nMeVVWqWPSb0opLRqFDwKJCRCe/aIsUKJhPzYB9ivzUgZicKUlfg
         X76qZT4E9I2RISJLHb8Bpc3dDct9jHgZLeS8Xvu/YWpzN6U3mC2LlwrMwl7bRBzBj1Yf
         S1kXnKd0hgklZ91MkgeSRS91Q6fHk3VU21968MdMHQeqaSjuFC4l82aWTj2G4rw/+prP
         7Q2iLNRM7d1eshiMcBxBtrj8I2fnlxpJeOAIBmGnqq3KTYjOwQe9fUydj3Wi4KluKCnJ
         h2oqUrhRlCRrt1uEfpOMEzr9v029KGtIlXq9H3BoEJWxoe6EEtXvL8tCz5auC2c9F2Oi
         +JUg==
X-Forwarded-Encrypted: i=1; AJvYcCULNcWu1qggzdrdjzNvMq4YJIH3Ow03k/7O67nv5lDNJk9l4oGIBpBeDvudQw9ph7+31Mt/nXtIP7Fdl64j@vger.kernel.org, AJvYcCW9cnXOFlJ2q/oRx0PVtxjVCwofxobLQgmNyn+yz6bvKtrMt+Xc1uWkaQ7Hsb0Lxn1xjvqTj2EgjSvm@vger.kernel.org, AJvYcCXJCNVYO7s0abPrKCSM8Bo6xbgPr+/Q+1063haul5sd5vo/LMnsPbdcQWiC5jL9/cd7k26lWJj7MZosXq7i@vger.kernel.org
X-Gm-Message-State: AOJu0YxKjBitL4FJL+Bvr6Ecks/zxHPkETn7nAMp3RozSVHMVD/9PRsq
	aQNmzX22vHwQOAQfHlJxIFcvLvvBJi2qczNzlLzAlfZRMgX+cFFb
X-Gm-Gg: ASbGncti7zvLx/b873T1HHKGh/n3gwUt2wZ9A9L3sf6SWWAk5X7qg31543TbhETDELn
	dPGpqDU21ANAXqe2uKwTWdrJyghNwAgnHwWdKCPbAHLcjAsPJRlj9Ht8W0qnNOfJADLA+E1fB5m
	tGEK17VfLBu66hi3kMWWPKM4XxPyk/oCJ6cdl63wvc5th94fEWrg7OTTucNqU/jheGWnMcx4icH
	xGufwulPKzEw5z+pFtVJ8yl6PM40UebS5BTUPwwxPNznbYWXZ/I6XeeSVgkOAjwHYm5cFC9dJC4
	PE9UxwtyyMRh
X-Google-Smtp-Source: AGHT+IG8g4EFy0ehsQjwuqYvjL5RmWXOXLQffYHq1JWYKvL48y3hP5A1jAeo0WRLGRPrGmDNGVoJCw==
X-Received: by 2002:a05:600c:511c:b0:434:fbda:1f36 with SMTP id 5b1f17b1804b1-4362aaa9cb5mr46725015e9.20.1734183153978;
        Sat, 14 Dec 2024 05:32:33 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4363602d76fsm24359015e9.18.2024.12.14.05.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2024 05:32:33 -0800 (PST)
Message-ID: <675d88f1.7b0a0220.325e04.7513@mx.google.com>
X-Google-Original-Message-ID: <Z12I6nlTPOqnIoi2@Ansuel-XPS.>
Date: Sat, 14 Dec 2024 14:32:26 +0100
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
 <675979e5.5d0a0220.207826.2bf1@mx.google.com>
 <Z10LgtZm4-qCB2aL@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z10LgtZm4-qCB2aL@gondor.apana.org.au>

On Sat, Dec 14, 2024 at 12:37:22PM +0800, Herbert Xu wrote:
> On Wed, Dec 11, 2024 at 12:39:13PM +0100, Christian Marangi wrote:
> >
> > Do you have quick example for this?
> 
> Just search for crypto_ahash_set_reqsize in drivers/crypto and see
> how they use the reqctx to store temporary data.  For each request,
> you're guaranteed to have exclusive ownership of the reqctx.
> 
> If you wish to DMA into the reqctx, search for ahash_request_ctx_dma
> to see how you should set it up.
>

Oh ok I didn't understood you were referring to the request_ctx API
thanks.

I just pushed v9 with the requested changes done. Now we map DMA only
when needed and use local struct instead of kmalloc. kmalloc is only
used for blocks. For that GFP_ATOMIC is used. The ALLOCATES_MEMORY was
already set in the algo flags.

Hope I'm making good progress on this.

-- 
	Ansuel
