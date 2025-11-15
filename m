Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D7D17D2
	for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763227983; cv=none; b=XDLUMazHO4+Ph2Ik1uW2BerQc70FPRHL7eOj6dFI6/VCGzv913mFDUBb7xhmH7vwOZr7ikUXI8F9fJRhucB2lHjejH97bCD0riUOqluHK4E9sZ1u/Dch+Y6KrgxZA6HCwRllQhh7BcGaki5RcMGzcRrNxCGjll1e4pOMcWZvhrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763227983; c=relaxed/simple;
	bh=N5EfWfkTxcSMCbZhCCSgQXa/a3aUlOu58R3V1BUXqjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SgccOtt+eiCuH6DsjsXzjoGsJVmW49vhZRJtgB16ZyYQ1YYZz34ME9b2JWW8IwlRZdYHKMVD8YIpVmNMSpeZjAo0YQDRC/LYdnrCJDQ4GWe+MOTeAeB69vOiCwxw7iLwB654RZXZh6i8zUolZ8OTwSeJB3Do+38gka4zH5QwJq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CR1vwOtS; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CR1vwOtS"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso714769a12.0
        for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 09:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763227978; x=1763832778; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b+DJUsWkgqyBmJ1jAtjkESyvT36ah/YsERcVPj24zSA=;
        b=CR1vwOtSuj21X9DjMS1J1+fHB9+3BN48zxLcN20ecETINyIOogMlIasMpg9UVFnfSF
         4vUBG9CZywBpoyIDr6ZQS3wZWtGamzY7O8zf3t7aMAwvJI8Gijv4Fqnx8bPB4Pxr4wI4
         bHR1LbXBe9GWUqU+Pbo4g2CDNSSIe4pcoGMio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763227978; x=1763832778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+DJUsWkgqyBmJ1jAtjkESyvT36ah/YsERcVPj24zSA=;
        b=dgtf71KecAyQBoK0THGGf0bnnrr5V/kltonRNuR5d21sUhobGAz+R5e9D85vAywZuY
         s2bKrfKcV9aE7hLCGRx9j+NGFmLiezcnCGh9PHTXuc0vOkqb+Hx3Lr4i4ClPuoD+FbC7
         qeUyFPPwUf6IzcUOIcnzc9DNJdBevnzgcB5rQJhWp/yIJJfsMviZxTHZN766y2DRLq/S
         V76uJCUu45Kc1ZPjdOO0MIAiYyNL11lmw5ODMZqypwhadLC7nnOK7cokROPjh+g3dRlZ
         X5eo9KYWxLNQxhWXLJ8tADNEbmaA7k2E4Q4Am4RaEVDwqyB6NpEtRirPSYMU71lorrch
         ITzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa81u366wLuuRvIszHmQqnyumWkKEf92UG0pvkWIF7JG32tmKmav0s+Y+KeWXQ/PbVvRHy5VV3kLKnAzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhBIl6TPSQkh1m8xE0/F28p4vm8csG93WK3k8Oa0hxSr0muo7Z
	xq2v5a0NXKp6ZH9yw41TYo8tPGX3OmRMwrZ09/5Y+AcsjH8uHNSD4bg/MPSo8wfHnGdFgpN/lAd
	JsYB7zKI=
X-Gm-Gg: ASbGnct7N/WPkQZzpF12idnutI+A4r516g5cBqqG5zjqqQkhGzz0blWx2eXf+Hzbgg2
	BG7iJBLAL73S7H9cAFkgsfn7kNzruGjNJSBwGgF+QzlyrLnrMmtlnMiytvi9s7pqrPemGAooM8t
	MH8w53LJg91K97eJvbqL5WvHkILuDX5LZkbFgzMkb/3idGLwf1YWBaqOFjURcTiUgSxZAGTcy1D
	R8q3NzxV574ndJnHkfnB1hLwke7GJlMkheQ95XMTV2e8juozyetHbPrmTDiqjCl3qnTAO8azjL4
	zmwcY8oGqhALlH+dRW9Jk7xj1SHDBpkq58H4X/U6xzeWYGeCG5jaDl1i0i7rv9B+whRqUbe3IzV
	dXIG/N4skNTHfNWHfAtgw/AzjijmiAN73xJNfJ5eT++SW6TVeeDS4Kh386YGaXuXj/GMJtGMFM1
	JNwZjFj+fspkpZ+9Q/ySrzS9njSsszltnTq0+mz0JOdIkZoDQCdw==
X-Google-Smtp-Source: AGHT+IEHXHvrAYqc1ZhG8W9SSvjmluutaV19BiYEny55AqD0vxtPdqA4g3r+R1zTKPiDIAhflPMFVg==
X-Received: by 2002:a05:6402:1469:b0:63c:3f02:60e7 with SMTP id 4fb4d7f45d1cf-6434fa7f209mr7298097a12.17.1763227978200;
        Sat, 15 Nov 2025 09:32:58 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a497f1csm6069327a12.23.2025.11.15.09.32.55
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Nov 2025 09:32:57 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso6425617a12.1
        for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 09:32:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW6cr2ACs3GZF+vU5xiwLlSIUZJGvzBuHw54dmYO/FH+Q/taBcAAtsLe1l2t1w5iDqazVVjjlB7kAvaDtY=@vger.kernel.org
X-Received: by 2002:a17:907:9813:b0:b70:4f7d:24f8 with SMTP id
 a640c23a62f3a-b7365af8746mr787031466b.22.1763227975583; Sat, 15 Nov 2025
 09:32:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114180706.318152-2-ardb+git@google.com> <aRePu_IMV5G76kHK@zx2c4.com>
 <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com>
 <20251115021430.GA2148@sol> <CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com>
In-Reply-To: <CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Nov 2025 09:32:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi4HPbkY__Gi1dLaKXSqys_y-uOJSy7TMxUq_9zEr7kSg@mail.gmail.com>
X-Gm-Features: AWmQ_bmruSjSViPRjsk_MyyobJEsp9ga2vrmXa4NyOHITMltRwIIwtkbO29dp70
Message-ID: <CAHk-=wi4HPbkY__Gi1dLaKXSqys_y-uOJSy7TMxUq_9zEr7kSg@mail.gmail.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org, arnd@arndb.de, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 15 Nov 2025 at 09:11, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And we already have existing users of this syntax, so it's not even
> new to the kernel - it's just obscure and unusual.

Actually, looking around, people removed one of the users because
sparse didn't understand it.

But that was over a decade ago: see commit 1ee9fcc1a021
("powerpc/perf/hv-24x7: Remove [static 4096], sparse chokes on it").

And sparse was updated to understand that extended array declaration
syntax back in 2020, so that's no longer an issue.

             Linus
