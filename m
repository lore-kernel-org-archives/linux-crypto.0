Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C033F39C
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 22:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777413607; cv=none; b=MJ/H5ZlDVTP7p0rDrIZnDgjXqP3Za848XJC2lU+pOZ/k3GR/dPDuj/0bfNQkE5QUCVWNkd0P7JNLTv53e4cZ4nxPBEMuOAwCgk/0TUcW6d3YJqLjq65cwAHhxrpwvL4wTbsN8RzMpCtJVZQ55ElgECtoPCQ4rmjXWqNlnxBlzMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777413607; c=relaxed/simple;
	bh=VoYzJaWRdp1h+CDLkJx1M+CFVba50lVH7z4SaaYxOGk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBjRC6O7ty7HqRboWY8OsvzWTo3LNbDcjr1mzn+jIJ4FbOPoK0t7blx+Xae1drQ3YJU5XTCouAAnILtD02oZl3/yq6Qj5/gdee0e+MNDyNZeGKVxHSWbK2PdO+IuVMp854ROtHroDsRggoyf52YGc9nq6ZN0dviGonp9QLfx2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AR7G9B7c; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AR7G9B7c"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488ba840146so106724955e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 15:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777413605; x=1778018405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+ir5t3PaX/DWkAs1o8I5rosOinQMQa+UnM53hyy14A=;
        b=AR7G9B7cFH9EnCAe8zDJRzT3h+sdPBRAnyzxhHYNZAD/h2oRWzYBBZoYp3uq/ZukQF
         YYX8TGfv6ktWoDpxR1qMYJNUgWK9ULN4onRZc5nc16Ns4615d1pGqr1qSClNxZ0ngqIn
         UuY9FgzOAXuJqQnHAqGhyBpB5U3XhGnNcMCJ0iYXpK1Mh7UHVmPZ4tbiyc3SkVndVuvP
         2VtLBoJAYH/aiKSeCyggsQVYbcO7KYf+5Y9WzxpgLtLSKOpJLCmxCZ4mORgMxqQFNFMX
         n6qO5GiV2e7RjSt1uiZC3yipXDLQ3XNzuwKGtBr9qpAtTlhvUQQ3GbK2TOwxtNQxNCRr
         pdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777413605; x=1778018405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+ir5t3PaX/DWkAs1o8I5rosOinQMQa+UnM53hyy14A=;
        b=GrqZuEKLuiL1Cb8Brc8oRv/yH3EtWOSh4K/IPgPPE98ZDDdQhobueHxc9tihU+wDhn
         4AcBpNGMHyRCmbpckQ+/dNzpsJTsB2j/V538IvlEVONG3OB2su82FWANwCHnEpKG/WVs
         udLSkSsjVLTWSwxNvTG1rD3plGUCL3/KeGIHA5tagWGb6bQxKd/cIDDCyBn0mXq0s0Bi
         RduZ1HxAtIreF2eqO0I7w1NVloQdF8aOgaHAUsIp/VqGDfXUUVUjloKEWF1DlUdLJKYf
         AULDHd/8v7LLK/HiNNYOkAO/G53RqTlYcr/EadGxVTfotg3PBy4jGg4jTiTe1ENnsWaw
         xknQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Wsx5RYODunIqBuWGgpsA1aFbSfEcC9fHMwcHN28jUdxBBx9LYd8WyOypVF9Nxys25zdYUH8Bm/1rIrw0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcf+hGw1JnlBKqGowx9K+LZ8gWSCImcoM7x4rCzq6sVvDJi9Kw
	9Re8+HctHo+uDNqXZ3ThHiag9F5P4KttbxOwn29cO4Emke/1rSB0Mijo
X-Gm-Gg: AeBDieu1y23u2KaEAQqPQTIrbpXEWY9MxgkZdrFQlWo96211EL0p467I/fl4KXlADes
	Mg/pEhyQ7IOzi1D4zFuG5bDuONMnJ/Tb9v4P8mvY/el4VEz1tijNMGVLy1+CD35ts+H6LGELUKV
	td7Tdiq7uLll66lSpg6XkCOqHUYra5VjdRz2NmQ40SwXS3Xq0+N8RQFSMe0IG1SQ6LmUnpFN9v/
	QVrOwK+OkTBEmwBB0T+pdbcrOhP/Zh4BA49ThIK8RqFkQ8cFovggnnD9+hELJcWm7A58qCFnPIz
	kegZvsBwHAdTj+FFzYxp+mAWNvasQ2bK10P2SWhl3yp885B0ILG2auymZRpH9ZX8We78MCoygGZ
	Zwjr0Zg7ZVx1/hea39uv9zugskMjIoAzJhr3FSwEDo+2yyAQ1shWE38DnEb5Oq8+pEdRbm6phj9
	96w1xTwpGElYLNspqzL1r6rPiiynSzM72InNRNtq8/pD9mCzQgTzA4Ka7bh6jnJC9T/6VFneT+b
	TKmWc9yjwMHcA==
X-Received: by 2002:a05:600c:1e28:b0:489:ecee:c4ef with SMTP id 5b1f17b1804b1-48a77b050dfmr75265055e9.13.1777413604277;
        Tue, 28 Apr 2026 15:00:04 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c310048sm3120025e9.22.2026.04.28.15.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 15:00:04 -0700 (PDT)
Date: Tue, 28 Apr 2026 23:00:02 +0100
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
Message-ID: <20260428230002.448bd8e7@pumpkin>
In-Reply-To: <97b79659-5fa1-4085-8c2b-3140fb663acc@app.fastmail.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
	<20260427172727.9310-3-ebiggers@kernel.org>
	<20260428022445.65e14a27@pumpkin>
	<bab8b5b6-6ee7-4e0b-9999-becf8f28ce71@app.fastmail.com>
	<20260428111008.6ab7981b@pumpkin>
	<97b79659-5fa1-4085-8c2b-3140fb663acc@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Apr 2026 18:38:51 +0200
"Ard Biesheuvel" <ardb@kernel.org> wrote:

> On Tue, 28 Apr 2026, at 12:10, David Laight wrote:
> > On Tue, 28 Apr 2026 08:34:47 +0200
> > "Ard Biesheuvel" <ardb@kernel.org> wrote:
> >  
> >> On Tue, 28 Apr 2026, at 03:24, David Laight wrote:  
> >> > On Mon, 27 Apr 2026 10:27:24 -0700
> >> > Eric Biggers <ebiggers@kernel.org> wrote:
> >> >    
> >> >> Currently the kernel's TCP-AO implementation does the MAC and KDF
> >> >> computations using the crypto_ahash API.  This API is inefficient and
> >> >> difficult to use, and it has required extensive workarounds in the form
> >> >> of per-CPU preallocated objects (tcp_sigpool) to work at all.
> >> >> 
> >> >> Let's use lib/crypto/ instead.  This means switching to straightforward
> >> >> stack-allocated structures, virtually addressed buffers, and direct
> >> >> function calls.  It also means removing quite a bit of error handling.
> >> >> This makes TCP-AO quite a bit faster.
> >> >> 
> >> >> This also enables many additional cleanups, which later commits will
> >> >> handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
> >> >> removing more error handling, and replacing more dynamically-allocated
> >> >> buffers with stack buffers based on the now-statically-known limits.
> >> >> 
> >> >> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> >> >> Signed-off-by: Eric Biggers <ebiggers@kernel.org>    
> >> > ...    
> >> >> @@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
> >> >>  	struct kdf_input_block {
> >> >>  		u8                      counter;
> >> >>  		u8                      label[6];
> >> >>  		struct tcp4_ao_context	ctx;
> >> >>  		__be16                  outlen;
> >> >> -	} __packed * tmp;    
> >> >
> >> > That looks a bit horrid.
> >> > I also had a feeling that the compiler sometimes rejects non-packed structures
> >> > inside packed ones.
> >> > Perhaps nest the whole thing inside another structure that has an initial
> >> > u8 pad and is marked __packed __aligned(4).
> >> > Then the assignments to the fields of 'ctx' will be known to be aligned
> >> > even when tcp4_ao_context is also __packed.
> >> >    
> >> 
> >> Agree with Eric that this has no bearing on this patch,  
> >
> > true - just the in the same code.
> >  
> >> but I'm not sure
> >> I see the problem here. 'ctx' will not be packed, and appear misaligned
> >> in struct kdf_input_block, but that would only matter if the address of
> >> the ctx field were taken and passed to a function taking a pointer to
> >> struct tcp4_ao_context (which would expect it to appear naturally
> >> aligned).
> >> 
> >> Having a feeling about what the compiler sometimes rejects is not
> >> actionable feedback - could you be more specific about which problem
> >> you think needs to be solved here? Are you concerned about unaligned
> >> accesses when populating the struct?  
> >
> > (It was 2am and the side effects of a cold were stopping me sleeping...)
> >
> > I tend to double-check __packed because it gets misused in places
> > where you really want the compiler to error implicit padding rather
> > than generate expensive misaligned access code.
> >
> > But I am sure I remember some build warning that needed __packed added
> > to the definition of a structure embedded in a __packed structure.
> > I don't think it was only the arm OABI (which pads structures to 2 bytes).
> > Historically this has never mattered (even the 'address of packed member'
> > error is moderately recent - well sometime in the last 20 years).
> >
> > In this case (and the ipv6 code) 'struct tcp4_ao_context' can just be
> > marked __packed.
> > Or, since this is the only place it is used, possibly just inlined
> > into 'struct kdf_input_block' - which may not even need to be named.
> >  
> 
> What would that achieve, exactly? You still haven't explained what is
> wrong with the code. Or are you really claiming that structs lacking
> the packed attribute are not permitted as fields in __packed structs?

My brain probably misfiled something :-(

	David
