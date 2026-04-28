Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBCC313552
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777394353; cv=none; b=QQig1OQN+byHI8gJMMNikIZF3ErcsYtn3V/uAYg4j+ib4iyUS/tcG1WaUITKGWxccSuxbj8d54TApJoMEsDplzXsABPuF4/CG9FB7ynLp5+eSLFGn3kGHzLRhxCXYANd3iT9fgyAAaW6yn8TxQTl4lgTV5cqetd7yoKbUskuQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777394353; c=relaxed/simple;
	bh=8BKRz7v9LJXyy81HqR7ppCe82BxQLZvK6fQh/te99Q0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=crvzRtRMqflujVaNgmXrazT6NqvM59VKwAHYk+K7JV6JBpoX0DI1x8eJeIytY0ZVVJZugSqSe5qQUjT6lvRoq3xPqloFbIb/2cZKvIkcB8Q8UaZ0eTs18GRLTTer4r2NG0coWnBARkcgY2wErMT3AfrtaAal+YCTmt4HOyyKDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LbWgqLM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LbWgqLM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B0AC4AF0B;
	Tue, 28 Apr 2026 16:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777394353;
	bh=8BKRz7v9LJXyy81HqR7ppCe82BxQLZvK6fQh/te99Q0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=LbWgqLM0EZUA3GY/PMsHH/Li2bl6tAUr8o+6EKI/37s3xsX0kRxRkc1JwrODF7O6o
	 DsXZ0J8INB2Ei944mX5Fw7v46MiMD33pV85U9ArSmmtgsjzQ3Bz/aqjaMk2+a6Hwaj
	 IkgtRDtRFLscvTXN5oGtOAui5LM+oku48d4v6kfXKQC6ZEq0Zd19qiZRwz8L3NissX
	 RwocNvXABE8PgS6Inc9WYqIJiAQCg04T7q/mg8uGhfKLWLdFzcnBFmua+2XDJ9Ynq8
	 1oeKBZCU/DEQKDXtI8Ct3L7QtZ4iWtAi6cIot+ZTXIcf1oMR/D5M0hxaNjNB6wzl52
	 kA5kARZQsU/Ag==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 02F36F4006C;
	Tue, 28 Apr 2026 12:39:12 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 12:39:12 -0400
X-ME-Sender: <xms:r-LwaZJ9VwAYp-HSd9E_zA4pIem45ubJmK8OK2RgGxW6NCOgLF_9OA>
    <xme:r-Lwaf92OPqSMaRr0cREjOJkJHga95mYbrt3gKVLVgc4Pfa5iUfP_WDwHEEhmkxR1
    lAK1a8YzabvglCrbQqIgPa4vIA_qUr3CHa6Ty5fMXrBbIrd7pV4GXye>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekvddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtoheptdigjehfge
    ehgegtgeeisehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggrvhhiugdrlhgrihhghhht
    rdhlihhnuhigsehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonh
    guohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopegvughumhgriigvthesghho
    ohhglhgvrdgtohhmpdhrtghpthhtohepkhhunhhihihusehgohhoghhlvgdrtghomhdprh
    gtphhtthhopehntggrrhgufigvlhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopegu
    shgrhhgvrhhnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegvsghighhgvghrsheskh
    gvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:r-LwaVRAuC3uv127vQ7lJ1MJgW-jXmLqlqb2qsKmWVBy0lCOA_Hhew>
    <xmx:r-LwaftZ52LBe-9Orv4CyFF4bgOXPbHTVL01UUxU_eVZWYl5lbpBBw>
    <xmx:r-LwabLXaXN57PSJKh1HqVB1rYE0nv7kvUornNc2H0D6HNddG3K2Tw>
    <xmx:r-LwabeMdB1294RwC4CL_kIqG8QbXAQ9UZBkChGvTq1L4BBYPlJapQ>
    <xmx:r-LwaVX2tWXAx8guspGyT7cwDA33mexqWXt9TRTD3S4dt7C5WvDCBPRx>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D66AE700065; Tue, 28 Apr 2026 12:39:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 18:38:51 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "David Laight" <david.laight.linux@gmail.com>
Cc: "Eric Biggers" <ebiggers@kernel.org>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Eric Dumazet" <edumazet@google.com>, "Neal Cardwell" <ncardwell@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Dmitry Safonov" <0x7f454c46@gmail.com>
Message-Id: <97b79659-5fa1-4085-8c2b-3140fb663acc@app.fastmail.com>
In-Reply-To: <20260428111008.6ab7981b@pumpkin>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <20260427172727.9310-3-ebiggers@kernel.org> <20260428022445.65e14a27@pumpkin>
 <bab8b5b6-6ee7-4e0b-9999-becf8f28ce71@app.fastmail.com>
 <20260428111008.6ab7981b@pumpkin>
Subject: Re: [PATCH net-next v2 2/5] net/tcp-ao: Use crypto library API instead of
 crypto_ahash
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 28 Apr 2026, at 12:10, David Laight wrote:
> On Tue, 28 Apr 2026 08:34:47 +0200
> "Ard Biesheuvel" <ardb@kernel.org> wrote:
>
>> On Tue, 28 Apr 2026, at 03:24, David Laight wrote:
>> > On Mon, 27 Apr 2026 10:27:24 -0700
>> > Eric Biggers <ebiggers@kernel.org> wrote:
>> >  
>> >> Currently the kernel's TCP-AO implementation does the MAC and KDF
>> >> computations using the crypto_ahash API.  This API is inefficient and
>> >> difficult to use, and it has required extensive workarounds in the form
>> >> of per-CPU preallocated objects (tcp_sigpool) to work at all.
>> >> 
>> >> Let's use lib/crypto/ instead.  This means switching to straightforward
>> >> stack-allocated structures, virtually addressed buffers, and direct
>> >> function calls.  It also means removing quite a bit of error handling.
>> >> This makes TCP-AO quite a bit faster.
>> >> 
>> >> This also enables many additional cleanups, which later commits will
>> >> handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
>> >> removing more error handling, and replacing more dynamically-allocated
>> >> buffers with stack buffers based on the now-statically-known limits.
>> >> 
>> >> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
>> >> Signed-off-by: Eric Biggers <ebiggers@kernel.org>  
>> > ...  
>> >> @@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
>> >>  	struct kdf_input_block {
>> >>  		u8                      counter;
>> >>  		u8                      label[6];
>> >>  		struct tcp4_ao_context	ctx;
>> >>  		__be16                  outlen;
>> >> -	} __packed * tmp;  
>> >
>> > That looks a bit horrid.
>> > I also had a feeling that the compiler sometimes rejects non-packed structures
>> > inside packed ones.
>> > Perhaps nest the whole thing inside another structure that has an initial
>> > u8 pad and is marked __packed __aligned(4).
>> > Then the assignments to the fields of 'ctx' will be known to be aligned
>> > even when tcp4_ao_context is also __packed.
>> >  
>> 
>> Agree with Eric that this has no bearing on this patch,
>
> true - just the in the same code.
>
>> but I'm not sure
>> I see the problem here. 'ctx' will not be packed, and appear misaligned
>> in struct kdf_input_block, but that would only matter if the address of
>> the ctx field were taken and passed to a function taking a pointer to
>> struct tcp4_ao_context (which would expect it to appear naturally
>> aligned).
>> 
>> Having a feeling about what the compiler sometimes rejects is not
>> actionable feedback - could you be more specific about which problem
>> you think needs to be solved here? Are you concerned about unaligned
>> accesses when populating the struct?
>
> (It was 2am and the side effects of a cold were stopping me sleeping...)
>
> I tend to double-check __packed because it gets misused in places
> where you really want the compiler to error implicit padding rather
> than generate expensive misaligned access code.
>
> But I am sure I remember some build warning that needed __packed added
> to the definition of a structure embedded in a __packed structure.
> I don't think it was only the arm OABI (which pads structures to 2 bytes).
> Historically this has never mattered (even the 'address of packed member'
> error is moderately recent - well sometime in the last 20 years).
>
> In this case (and the ipv6 code) 'struct tcp4_ao_context' can just be
> marked __packed.
> Or, since this is the only place it is used, possibly just inlined
> into 'struct kdf_input_block' - which may not even need to be named.
>

What would that achieve, exactly? You still haven't explained what is
wrong with the code. Or are you really claiming that structs lacking
the packed attribute are not permitted as fields in __packed structs?





