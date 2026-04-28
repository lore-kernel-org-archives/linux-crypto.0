Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613F83E5ECA
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777371014; cv=none; b=nTH491e583w+L+iUSwBhgkwHVKh7AKFog4e0jIRy0oV3ML4ZnWEmL5NIToyFTGnaiLhaliS78cYGLMKawj2u9O4hzQ4eow/ffdF2x+8H1ekhxasueZNXv+Jo9PmrMLA9KRXKEcpRWewrxtBHVjoEF09LPW86W//KoPSykbpmjJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777371014; c=relaxed/simple;
	bh=ZqIskksECjgqlrMhpopw9+qM4q+q5+z+/1bdrmopkhs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qiNhJ/qKpO8Cb3ns37rQCHMUECtb8KY4kWpec/N1wkYNlRV8rRUzGXLGIg5XykERNqBaBXwB40/BlcJOK9vhpiGGBluYCyBTKmECfq+6EMzT7yr/33asF2VhfTu29BV5ulOd+sfZ5jLKia7ZSjTYKFejdTmNA93E0s9eKQ24xPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhepOoVP; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhepOoVP"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488ba840146so101209285e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 03:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777371011; x=1777975811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DeU99boB6vx+XraW8EtOdcOn2iNfoMQwjQgjHwduqTo=;
        b=ZhepOoVPA4tGdGP67TnV8ZntNhU513tu4Wiw5NW/BqJfoMz9kJSdf9FIUqiABxu4ZZ
         sImDMQO11AFBnSy1N2RfHEKIEoN9pjw6ig3glKzRGX0BUUD6x5Wehf/Hx6nbJIPKmSlT
         57MUaHB6h5SDQa9t2bcS2hEEa0Su06QiUro46rcZsagBdL9sHI3jz5aGQD9xSE14dLCh
         B63/nvEG9s8zlymEogin+0onAFW6vAVg9QLrLPhNWwt19etqmCLoZibfpSWta9vSZbwM
         CW3WsenROTHaFR1/drAkOB9z11BFobJMgeme4oQPW7rNUG66R8zzRcKb6U1oyqHJayB8
         3oqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777371011; x=1777975811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DeU99boB6vx+XraW8EtOdcOn2iNfoMQwjQgjHwduqTo=;
        b=qte4LTNrX2ZbzCWOOeGolQDq5H7N0YPHlhF3V2I8fty308mNgTKJyx4LAVOE6UwKVY
         F32K9SYkbljURdtaP7eeTkNR6w/aP8GoA1Uaj8aKr3mxKk3CCbwgkZdWqiT/ZW9sc4qg
         QkPKlBTS5ewMKYNl9cENX0f3XIwioREHHUY4owBl2yIu8o/T/rvkKK+ZJuKcRsKzmTbd
         JG1tCa2vyyXi4IDwzZBkfEYd7aYlefshGDLaHQKoPLH5OyoOBWHPoRl3UBSZc3CtYL8o
         8mviNzWwMdR+tG9eqiyN8BXwGLYbtvxuLQLmFyXMFa8afq+yle8lplZnajNi2BRuW5B2
         oZ2Q==
X-Forwarded-Encrypted: i=1; AFNElJ9mNVRtorhsVX5MATN04J6Dg65pSm3P0KyyKENKGKLc/X804RIBQHEaJDhHx7QUKx9b7EfKuMsQZWPr6zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKznEbnkSfLf2XY0DGZqzAjsWsNQYXx9G/qtdCAZhKb6tZmnrd
	CfRcuV4XP9w08gdl6jZ6MPrBN8NMO37OPgphc/PjzI35y3tYrBaltH40
X-Gm-Gg: AeBDieuQ+cFx3GG3G7evUKIIoBLP0Z7valhf6EWpCq2ZUyhpjeRIN4bq9+sioHXYFZg
	oQRPnIXjpukxVhsihWgfzW/6dzT/NBskNhltGESGgqKywyekH83G1fQTW8bjVKaCTI9qAQSQnkL
	dtsjIzzDJX1Si4hm9tCiRuXs5IBgzBO1IhYIks7C70zSfT0QFqrL4FwlTE0CG+D9n9T7qipUDKQ
	YUe7CSSWl/xkJnQ4CXcDK0Y+QJ5VXtrweWG84h2sH73HJV9o3eEDGVNNZVMNKpZPjY4R5gVgbEB
	bdKVG2cjTKaJHsCbge0gXcqPvc0BgO7//d/velAQl5DOzr2sJfS2YAEChz5RZqCUBCnBgnEfCS6
	NYbHiUpDSLkor37FU6rsr2ApSjlwgLOZNfHwCoY8OVLXXJhRdFjLT1bC1yy4rTfQAqkbb1yNWc2
	pNBDC5ub4aO0cXP10jQoTW1pNTY9oDnkN/9taQ1+vtPxJR/MKCBj9RytxGRX1ReziKftysF4ees
	HE=
X-Received: by 2002:a05:600c:8b85:b0:487:243f:dc3e with SMTP id 5b1f17b1804b1-48a77af3dcdmr39658525e9.6.1777371010611;
        Tue, 28 Apr 2026 03:10:10 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775eb91dsm15268125e9.20.2026.04.28.03.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 03:10:10 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:10:08 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: "Eric Biggers" <ebiggers@kernel.org>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, "Eric Dumazet"
 <edumazet@google.com>, "Neal Cardwell" <ncardwell@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "David S . Miller" <davem@davemloft.net>,
 "David Ahern" <dsahern@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "Dmitry Safonov" <0x7f454c46@gmail.com>
Subject: Re: [PATCH net-next v2 2/5] net/tcp-ao: Use crypto library API
 instead of crypto_ahash
Message-ID: <20260428111008.6ab7981b@pumpkin>
In-Reply-To: <bab8b5b6-6ee7-4e0b-9999-becf8f28ce71@app.fastmail.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
	<20260427172727.9310-3-ebiggers@kernel.org>
	<20260428022445.65e14a27@pumpkin>
	<bab8b5b6-6ee7-4e0b-9999-becf8f28ce71@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Apr 2026 08:34:47 +0200
"Ard Biesheuvel" <ardb@kernel.org> wrote:

> On Tue, 28 Apr 2026, at 03:24, David Laight wrote:
> > On Mon, 27 Apr 2026 10:27:24 -0700
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >  
> >> Currently the kernel's TCP-AO implementation does the MAC and KDF
> >> computations using the crypto_ahash API.  This API is inefficient and
> >> difficult to use, and it has required extensive workarounds in the form
> >> of per-CPU preallocated objects (tcp_sigpool) to work at all.
> >> 
> >> Let's use lib/crypto/ instead.  This means switching to straightforward
> >> stack-allocated structures, virtually addressed buffers, and direct
> >> function calls.  It also means removing quite a bit of error handling.
> >> This makes TCP-AO quite a bit faster.
> >> 
> >> This also enables many additional cleanups, which later commits will
> >> handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
> >> removing more error handling, and replacing more dynamically-allocated
> >> buffers with stack buffers based on the now-statically-known limits.
> >> 
> >> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> >> Signed-off-by: Eric Biggers <ebiggers@kernel.org>  
> > ...  
> >> @@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
> >>  	struct kdf_input_block {
> >>  		u8                      counter;
> >>  		u8                      label[6];
> >>  		struct tcp4_ao_context	ctx;
> >>  		__be16                  outlen;
> >> -	} __packed * tmp;  
> >
> > That looks a bit horrid.
> > I also had a feeling that the compiler sometimes rejects non-packed structures
> > inside packed ones.
> > Perhaps nest the whole thing inside another structure that has an initial
> > u8 pad and is marked __packed __aligned(4).
> > Then the assignments to the fields of 'ctx' will be known to be aligned
> > even when tcp4_ao_context is also __packed.
> >  
> 
> Agree with Eric that this has no bearing on this patch,

true - just the in the same code.

> but I'm not sure
> I see the problem here. 'ctx' will not be packed, and appear misaligned
> in struct kdf_input_block, but that would only matter if the address of
> the ctx field were taken and passed to a function taking a pointer to
> struct tcp4_ao_context (which would expect it to appear naturally
> aligned).
> 
> Having a feeling about what the compiler sometimes rejects is not
> actionable feedback - could you be more specific about which problem
> you think needs to be solved here? Are you concerned about unaligned
> accesses when populating the struct?

(It was 2am and the side effects of a cold were stopping me sleeping...)

I tend to double-check __packed because it gets misused in places
where you really want the compiler to error implicit padding rather
than generate expensive misaligned access code.

But I am sure I remember some build warning that needed __packed added
to the definition of a structure embedded in a __packed structure.
I don't think it was only the arm OABI (which pads structures to 2 bytes).
Historically this has never mattered (even the 'address of packed member'
error is moderately recent - well sometime in the last 20 years).

In this case (and the ipv6 code) 'struct tcp4_ao_context' can just be
marked __packed.
Or, since this is the only place it is used, possibly just inlined
into 'struct kdf_input_block' - which may not even need to be named.

	David



