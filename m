Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773530;
	b=dxHLYdzPO8CCm+04qLstEzvkLJu21vp862mGPAGgebVivCuNeX//qfjCCNBaE2P937Bo
	 Y/Edua1DMtDr4fATlifWa2n4IYUPQH21XOeot9TqVS1HoBESromKDw8PWaMTaO1+UYUCf
	 CBgZSlS630LerAguUSDQognFif+NuyMKupaYSww58F5IgUd5TSpVA7GFZpAMm8ewnQECu
	 J7ei1NKVM1yx76p74aR2CisOG3+8nz7OBJTvfcHb8Jdh7xGfdSImMwK3IMXYi+pZixcJV
	 XYsQrZOP/JPxONfH4fxA90HryYqSeRaGYxnN2BggT64qe8mSaKZHYMDECMswG3zvs2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773530;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zDuV6g/pCqdwIIB8L63tabmwXtA/ctwK8ZJVX3nWzkM=;
	b=nyf8at1cMlBynLVDDejI92YkfVAJTM6xGGAuYsqHtb726R4TsdXBUlNTSl+/+rx2OeBl
	 AGoJKGVTqK5tnkDUENXY6f9VBIUr9gPFznVVQW2mN35OSHgLxxB8XYsUoKqTCNMG5tiOG
	 9JPCajdbPmp4VxS0sn/uUUKr38rZ9Vzk5qK4M9FXeKAcb7w/prevkZvuzRt24AzUj+/Um
	 E2OdmKBH7UZRiM3phdTQVaNmM4Bj7C1w5Un9Qjg4lERh6jEfJ33cOk/kTg9d04dLV+wzH
	 LXZYQD1JmPh3CPmzDYx0V7oZ2Ue04Ff8KUCYtsUIsdOm7p8yt8C7b1stEmEuqiO8XlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FIXBI4o0;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C66606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 16:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7C66606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FIXBI4o0
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so7914405e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 09:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792773528; x=1793378328; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zDuV6g/pCqdwIIB8L63tabmwXtA/ctwK8ZJVX3nWzkM=;
        b=FIXBI4o0JAqSIiEBTvQAwwk1JR8PDwRO8mTmvLgN+Q/O9ggR63Jiy3ZtOPMnL63QbN
         iMHks5ewoc4ZUkFkn/okpC+69g0ejHUmUpdi0B+roV1xwyx4fEh56YTr4lQhlRP7lGex
         Q6qLmDvE//022LpR2Vnha1x8uP+Im+lJF0xyQvtpPToEI4Nem6JtY3GQq0Q7yXqlBfzL
         BSPHDRB798vgBGLpyuRy7OEB3F/fLcJKP4w0LbhWSuI6JLtcq0Koblipulxr1EIwz1wv
         ZLvLFOmYtFzAsMH4ZrnWA03vjhFT2syiXyLWVT6Lds7P5JtKSuqYQdzkeAWF7QjL3A65
         2MXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792773528; x=1793378328;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zDuV6g/pCqdwIIB8L63tabmwXtA/ctwK8ZJVX3nWzkM=;
        b=Dl0eEJ88maD49lQpA1v6T9eGbLiKvmW/3NlVn4h8w0Qn+ghsn9F3OVYC3RwPKJrito
         broTzV7xjPkusnQWJC+mSNq3cGHiFWgxU4217ALaYhW0H/0C9UCIrl+Zm/0xfmvAxkCl
         rGDFWPHI0yiOsYm6g8jrKlh8kLP4tZdXoFNu+y9n1jPV3wsrK323wJE9H6Z6xlmz1iPL
         nFc+kjwws6D4iUod5cRpwet5IUwX9+zaH3shvkBj0Dj7qO6h5cyEsCiJPySl6b/uCn/K
         qoK9FYnCmAS9oMz5r7ExRdY2w411xGaA8L8SjKUm5IgX78u+Ik651vaxp08iG63hqH/v
         AHfg==
X-Forwarded-Encrypted: i=1; AKwUvBziDh33uw+dhnuktoAArwt93gR/l8Mp/K/MpjEifIgj78FEHv9K0wTwrRA6NhJSqdrPvO5K0Bt6htn73KM=@vger.kernel.org
X-Gm-Message-State: AFq9FYKmo54IlLet8Mxd+k4ZDxCaKG4KSbPBuQI2QWem16oVVKoN9LSI
	5sr/3JNR0hktiqSoeyE/H0F9kuFDL7YB1I4lHmYfQKRPETcgztnSIlw27HxbYsx+
X-Gm-Gg: AYBFou0ltHFYEJCnEKD29IqxN7Ka537pXBB+OKndH4GZPNaCLuwyDcxURP4Jlea7p0l
	wFe+Dhw0O1t8ZFpur1VHym1RWgfbyoCAzbXBrOspalAE4Lb0DGk4zpxPmgL7D0aj47UHtWoYiJm
	u507zDfrKfeRbyAu+ch8bqtlDy8q5X5vxhY7tP/rrhHWjYNoAgPVHc1W+60rt3eFQ4oA67QeSox
	UXkvWzB9Xs3gIYOpgY3Bh3SLYsHV945spJ57dlyLkJQsgW5CrjXeB+AOTkH3uIjf21JMRDwE2ag
	l7UUnH9nDKYr8quTgZVK9ileF5SpVmeke5xbL7le4Kva3wkuQiiKOopKkeLufHdqLObbX1nkl8L
	K5vq+qILb2rItUKS+Uw5AZ1+q0tc7u443WrDV2Hc7+8kyNlepP5N69u8uwmxfVQ2hc+CSrnSOwG
	DGlUxG1iXuOyWcoV8oAjx1QW3YJ1fDZzvXd1ofKji4pyph3HWLDzZRTf/4qr6GpPpb659z8mqDQ
	QZu16oAsF5gaOboCfK5rgfY/BZMPmsYRpHxGpGZKuPCoK+KL3x180Yq1CXfIUkM7XQyPNMiZWWz
	349JQ/KmeM+pNfgI
X-Received: by 2002:a05:600c:8b41:b0:4a0:1b21:2628 with SMTP id 5b1f17b1804b1-4a211cb289emr45180365e9.23.1792773527873;
        Fri, 23 Oct 2026 09:38:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2a9062ce5sm19750475e9.1.2026.10.23.09.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 09:38:47 -0700 (PDT)
Date: Fri, 23 Oct 2026 17:38:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Tzu-Ching Yang <shingekinocore@gmail.com>, Eric Biggers
 <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Jose E. Marchesi"
 <jose.marchesi@oracle.com>, "Jakub Kicinski" <kuba@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, "Simon Horman" <horms@kernel.org>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none
 function-like
Message-ID: <20261023173845.2ca86a63@pumpkin>
In-Reply-To: <3c25921c-7bdf-4edd-ba06-838dd1765db6@intel.com>
References: <20261016025613.2690485-1-shingekinocore@gmail.com>
	<0a38e0b0-2508-41c1-bd99-d15c27579307@intel.com>
	<20261022100140.101ddf52@pumpkin>
	<20261022110959.1173447-1-shingekinocore@gmail.com>
	<3c25921c-7bdf-4edd-ba06-838dd1765db6@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Oct 2026 15:42:28 +0200
Alexander Lobakin <aleksander.lobakin@intel.com> wrote:

> From: Tzu-Ching Yang <shingekinocore@gmail.com>
> Date: Thu, 22 Oct 2026 19:09:59 +0800
> 
> > On Thu, Oct 22, 2026 at 10:01:40AM +0100, David Laight wrote:  
> >> Is it possible to make the syntax:
> >> 	unrolled_for(....)
> >>
> >> Or is that made 'all hard and difficult' because he setting is sticky?  
> > 
> > The pragma binds only to the loop that follows it, so it can go inside
> > the macro:
> > 
> > #define unrolled_full_for(...) \
> > 	__pick_unrolled(clang loop unroll(full), GCC unroll 65534) \
> > 	for (__VA_ARGS__)
> > 
> > 	unrolled_full_for (int i = 0, j = 7; i < 8; i++, j--)
> > 		s += a[i] * b[j];
> > 
> > GCC 8 to 16 and Clang 17 to 23 unroll this fully, and the same works
> > with break and continue in the body, nested loops and a loop inside
> > another macro. The count form has the same shape:
> > 
> > 	unrolled_count_for (4, int i = 0; i < n; i++)
> > 		s += a[i];
> > 
> > As a fourth option, the _for forms would replace the four unrolled*
> > macros: no clash with identifiers, and the loop reads like
> > for_each_*(); the cost is a new loop spelling at every user. Olek,
> > Eric, would you prefer this over options 1 to 3 from my earlier reply?  
> 
> I had considered this option in the past, but IIRC the unrolled
> attribute can also apply to `while` etc, this would limit it to
> `for` only.

Is that really useful?
Partially unrolling a variable iteration count loop most likely just
trashes the I-cache.
(The unroll can't use simd instructions because they aren't normally
available in kernel - ok, some cpu have a 'load pair'.)
The only exception is very short loops where unrolling once can help
because the cpu cant execute a single clock loop.
The compiler is likely to make a pigs breakfast of those loops
so they end up in asm anyway - look at the xor parity code.

The blake code is really a special case where the massive unrolling
lets a load of iteration-dependant values be treated as constants.
(And I'm sure it can be coded so that they can be loaded and the
loops rolled up without slowing the code down, I've tried a couple
of times and failed - but there are enough clocks available for memory
reads that it should be possible.) 

Also while(foo) is just for(;foo;).

David

> 
> Honestly I think I'd just drop the unused versions (`unrolled` and
> `unrolled_none`) since they've gained no users for their entire lifetime
> (sorta understandable since the former relies too much on the compiler
> and the latter makes sense only in some very constrained environments
> where usually, the related compiler flags are used globally instead).
> 
> > 
> > Thanks,
> > Tzu-Ching  
> 
> Thanks,
> Olek

