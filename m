Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B3C346A08;
	Tue, 28 Apr 2026 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358110; cv=none; b=TcxWWGPuGtwkV+AIJvQWsO9lxbFM/nrG/RxwU+lWBZ+G9OI41S4b05k9vQM9KpAD42wh748m533ldxXoqA8LdkV8qGhoqvhg/bd12jTcK4uoFS0zWFb5PCLLQzrjexDdmmje7U6IV0o70hxy+CGP+qnPPiZY8z7sRHQS+DAAw7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358110; c=relaxed/simple;
	bh=yAWKuMRsoQqcbJReiLmmzNCI1BW4EVyDWe08mRI36yA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qBXvmu2p6+z7kIM+uaCR62EIWSiIE+h6irx4ay+XmG/Da52Jov3IQrntF2+dUfBunOtd5/fcwKvf7SocsXqcIzI3DLguSd17YVWrR61N/eXXCwP3vXckZqPBwfyjfK4wQwji6BdrdDNG9nd/8pc+3C17Tk5mQq4ss3OnZnBKVw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5070Gxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5070Gxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F732C2BCB5;
	Tue, 28 Apr 2026 06:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358110;
	bh=yAWKuMRsoQqcbJReiLmmzNCI1BW4EVyDWe08mRI36yA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=c5070GxmA4SSaYTDsVHL3zyYi2V552S2QVhZyMIFi6Kpak2NGK0zVhrGDZXk8RVHJ
	 gyc21w8yrrt+7Zaq1tPqbl/4uOzviSOzI0NwncWMhoj/735GIHymmQpY5sSNrgm85t
	 4depS/Ep4KjaYMVKtQ7gdWjSNIQB0FgIPWGKerKYo1Z6jY/4IRSF1dYs9dCX23gogz
	 +EhaNg6KGiGMFbKu/Dxh6G/tGiNoEz2TfT6SpKl6ouvB7Ykghem8B525A7aJKrb/DG
	 SOq4tbYjdZJzjJaoYZwLC8GT2fwRAkvSgGzGmQYGSRW1eARIwRVN1Lm78mkc/2OoXO
	 w5VRciEZKwvdA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 71AA3F40069;
	Tue, 28 Apr 2026 02:35:08 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 02:35:08 -0400
X-ME-Sender: <xms:HFXwafWUxCZKzuP1KfzTalnMhmP8iWmLRYYB7YBQNi7ZNJ7MB6DZJA>
    <xme:HFXwaSZe8sKhmEP3Rfvl2_j5rfngTvlUEn5Fyd-WahoTlP0cIJ6JQqHkwXP1c4lxU
    bTxCFEzm8ng3ATGYMFmN4R4dJFLBAz16cy4yHX00lZ2m_72aPBe4hU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdektdekiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:HFXwafIeDBqIlfSO4apW_WQZbzrqf-vsv3HljIv26e2Vpy_-uu8e8Q>
    <xmx:HFXwad2euzxNjufg_hv5atsg3JLI9Y6WSsSL8B7A_RJMNsi41CPJHA>
    <xmx:HFXwaQb82jMdFF7W3ZYKcc-fTxYN8gZk3sBwhZfp3u3x9sJPhmI4dw>
    <xmx:HFXwafhUKBb8i2WH9lfljVdeHYmhzP6vZmMU1D7JEn5-vPi8Bkwu6g>
    <xmx:HFXwaX-8Z1nZvll5qkuoQs4J2gZzDALDHEDUwJQOYyWE02zrEz4HbC6w>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 47103700069; Tue, 28 Apr 2026 02:35:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AFCxTjHw2LfJ
Date: Tue, 28 Apr 2026 08:34:47 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "David Laight" <david.laight.linux@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>,
 "Neal Cardwell" <ncardwell@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Dmitry Safonov" <0x7f454c46@gmail.com>
Message-Id: <bab8b5b6-6ee7-4e0b-9999-becf8f28ce71@app.fastmail.com>
In-Reply-To: <20260428022445.65e14a27@pumpkin>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <20260427172727.9310-3-ebiggers@kernel.org> <20260428022445.65e14a27@pumpkin>
Subject: Re: [PATCH net-next v2 2/5] net/tcp-ao: Use crypto library API instead of
 crypto_ahash
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 28 Apr 2026, at 03:24, David Laight wrote:
> On Mon, 27 Apr 2026 10:27:24 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
>
>> Currently the kernel's TCP-AO implementation does the MAC and KDF
>> computations using the crypto_ahash API.  This API is inefficient and
>> difficult to use, and it has required extensive workarounds in the form
>> of per-CPU preallocated objects (tcp_sigpool) to work at all.
>> 
>> Let's use lib/crypto/ instead.  This means switching to straightforward
>> stack-allocated structures, virtually addressed buffers, and direct
>> function calls.  It also means removing quite a bit of error handling.
>> This makes TCP-AO quite a bit faster.
>> 
>> This also enables many additional cleanups, which later commits will
>> handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
>> removing more error handling, and replacing more dynamically-allocated
>> buffers with stack buffers based on the now-statically-known limits.
>> 
>> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ...
>> @@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
>>  	struct kdf_input_block {
>>  		u8                      counter;
>>  		u8                      label[6];
>>  		struct tcp4_ao_context	ctx;
>>  		__be16                  outlen;
>> -	} __packed * tmp;
>
> That looks a bit horrid.
> I also had a feeling that the compiler sometimes rejects non-packed structures
> inside packed ones.
> Perhaps nest the whole thing inside another structure that has an initial
> u8 pad and is marked __packed __aligned(4).
> Then the assignments to the fields of 'ctx' will be known to be aligned
> even when tcp4_ao_context is also __packed.
>

Agree with Eric that this has no bearing on this patch, but I'm not sure
I see the problem here. 'ctx' will not be packed, and appear misaligned
in struct kdf_input_block, but that would only matter if the address of
the ctx field were taken and passed to a function taking a pointer to
struct tcp4_ao_context (which would expect it to appear naturally
aligned).

Having a feeling about what the compiler sometimes rejects is not
actionable feedback - could you be more specific about which problem
you think needs to be solved here? Are you concerned about unaligned
accesses when populating the struct?
