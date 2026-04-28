Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9763115AF;
	Tue, 28 Apr 2026 05:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777354939; cv=none; b=SMhZkW5/AQIQfCIF4D7QJz9jk+k/T4wYPflzxkCvdEMQkf3pnQejQNvjYHFVINWTLowSn1ihaRxwUw8fxiAsnsjC0vOdADi6K9VOJCDFy0k9aJP/HCrE3nei6NRkvMDQtQxLOHukDu53PP4B2AvUFmGoGuwvQHYIdGNfItIIPBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777354939; c=relaxed/simple;
	bh=qo5vRuAiZ5shJ6Ei1mLjY/jgzTrGIUBhYCvJ/yKzkJM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=bM60vZcMBpwocIUgFtrSRMNOjVAa1Fur0IQNsvm771sjwCivlD0lmXdk2wHPlqGClcZ/r/W5T7J3QucHXDc83DSkYPi6E0KjGTgeUBAa0nNqZsU30yXtRQ/zv3hI5VWNeyypWgqdUWnZVhscshGphATntQQGq0/CSlUAWsJhveg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VE5Mdvf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VE5Mdvf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FA1C2BCB7;
	Tue, 28 Apr 2026 05:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777354939;
	bh=qo5vRuAiZ5shJ6Ei1mLjY/jgzTrGIUBhYCvJ/yKzkJM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=VE5Mdvf1L11srgxqI0fu8IQkXAwHWJRquKsXN+oi0hvK30UU7v3HHJmRw6PGRCqU3
	 R5wWGcSe9DwInoIakwEe1ZHe3vtDh7wj/aNCSveRQF65Zckd5Gw8b0SpRUN57KXaxs
	 0ZDb1bz1kvVyTK9+ICt6zKKRDmCUTVsfwP35iJnEy+ZuJTqsgkM05HjT64eMiCr5Qb
	 P0YbMw8rl3PIb4MKxabFEpw7PE1UaFSRWti3xbhQ8hrI+bqrDsCF3rRTa25yN+T6hQ
	 t4Cq4rEUHn/r1R1Hd7q0U9WKuRCWVuIwbViYywY9Y1IGVk4eyYi+Rxw3XPYKLAJw39
	 uBua1VHYTU7LQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 47211F40068;
	Tue, 28 Apr 2026 01:42:17 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 01:42:17 -0400
X-ME-Sender: <xms:uUjwadNnbsIFPafuw-OVEQpwwRXHXq740CnTMLfTCXSFvdZm_u67IA>
    <xme:uUjwaayaXIa0-S75f3xS9QxCKvCZNwbOUC2CUgriajprgyxNeJwTlSCZQ_A0ORk_t
    MLQsPnSBhOy5Q-5It-ew2UCmORmBSBNaY2IwR0s_8wRo1PpDk0qBK4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdektdejiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeguihhmrgesrghrihhsthgrrdgtohhmpdhrtghpthhtohepuggrvhgvmhesuggrvh
    gvmhhlohhfthdrnhgvthdprhgtphhtthhopedtgiejfhegheegtgegieesghhmrghilhdr
    tghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrgh
    drrghupdhrtghpthhtohepvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdprhgtphht
    thhopehkuhhnihihuhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepnhgtrghrugifvg
    hllhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepughsrghhvghrnheskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:uUjwaUXMG2Lz-xrukyp70uaUwyl6jE_hKE-KwQZmMzOj9BKcG6n3gA>
    <xmx:uUjwaZh1MCFSSEgYXvqDqzs6KhGm9NpyF1MHic5Guk_RvDV9reav-w>
    <xmx:uUjwaYunFcLFyYjB8OiZPeST60NNFBHq7dI9msTG_LCZMDfFnnz2ew>
    <xmx:uUjwaRwCZcMRJAAZ_YV8JezKoFHS5TQHwbpB6W99OjhSfSeZkHtCQg>
    <xmx:uUjwaVawrOVkw_I8ZMGsX79oJKrBc27L0_3driL40KXRuiv5EXtHCiU8>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 222A6700065; Tue, 28 Apr 2026 01:42:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A-XTvJNalJ4N
Date: Tue, 28 Apr 2026 07:41:56 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Dmitry Safonov" <0x7f454c46@gmail.com>,
 "Jakub Kicinski" <kuba@kernel.org>
Cc: "Eric Biggers" <ebiggers@kernel.org>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Eric Dumazet" <edumazet@google.com>, "Neal Cardwell" <ncardwell@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Dmitry Safonov" <dima@arista.com>
Message-Id: <c557c50d-95ea-4e72-bff4-587508a0273c@app.fastmail.com>
In-Reply-To: 
 <CAJwJo6Zh_1V009JSBGwAmR7GWj=2HdG6f=uBxK8krE4B1YrGkA@mail.gmail.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
 <20260427155538.2e1b8488@kernel.org>
 <CAJwJo6Zh_1V009JSBGwAmR7GWj=2HdG6f=uBxK8krE4B1YrGkA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 28 Apr 2026, at 02:00, Dmitry Safonov wrote:
> On Mon, 27 Apr 2026 at 23:55, Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Mon, 27 Apr 2026 20:09:05 +0100 Dmitry Safonov wrote:
>> > I do like these numbers quite much! Yet, as I mentioned in version
>> > 1, removing a fallback for other algorithms' support does not sound
>> > good to me. There are two reasons:
>> > - Ronald P. Bonica (the original RFC5925 author), together with
>> >   Tony Li do have an active RFC draft to support the additional
>> >   algorithms
>> > [1], potentially in addition to TCP Extended Options [2]
>> > - There is at least one open-source BGP implementation (BIRD) that
>> >   allows using the algorithms that you are removing [3]. Without a
>> >   deprecation period and communication with at least known open
>> >   source users, it implies intentionally breaking them, which I
>> >   can't agree with.
>> >
>> > I don't feel like Naking as we don't have any customers using
>> > anything other than the 3 algorithms above (and BGP implementation
>> > is [unfortunately] closed-source, so that would not feel
>> > appropriate even if we had such customers), yet I do feel like it's
>> > worth and appropriate to express my thoughts/concerns.
>>
>> What do you want to happen? You are the maintainer of this code, you
>> don't get so say "i don't want to nack it but also no" :)
>
> Yeah, that's not what I meant. I see value in Eric's contribution, and
> I like getting rid of tcp-sigpool. So, anything but "nack" is not "no"
> :-)
>
>> Like Eric says if there are no real users code can be deleted. Adding
>> deprecation warnings upstream is quite slow, IDK if injecting
>> deprecation warnings to stable has been discussed..
>
> FWIW, I've written to bird's mailing list inviting them to this
> thread; in case if they need other algorithms to be supported,
> hopefully that should avoid any breakages on their side. I'm aware
> that ciena and fortinet use tcp-ao too, but I'm less concerned, as
> they aren't open source.
>

Strongly agree with Eric here.

We've been well aware for some time now that the LEGO brick model
doesn't really work that well with crypto, and being able to combine
arbitrary cryptographic primitives to construct your own algorithms from
user space is not a feature, it's a bug.

Sure, you can use HMAC to construct a MAC algorithm from any hash
algorithm. But hashes are typically much more costly in terms of
performance, due to the fact that they need to protect against
collisions. MAC algorithms do not have this requirement, because they
involve a secret key which is used symmetrically, i.e., both for signing
and for authentication. IOW, forging a message to match a given MAC
would require knowledge of the secret key, at which point an attacker
can just use it to sign the message.

This is the reason why more modern algorithms involving MACs use GHASH
or Poly1305 instead (or KMAC256 as Eric suggested), which perform much
better. Even AES-CMAC is not a great choice in this context. But these
algorithms need to be constructed carefully, not just swapped in.
