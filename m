Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E0928313D
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774622778; cv=none; b=Yxn9s/hp8rsGJfnGSdiQWcTkNEusZjNVPx2WVJ30o3VjmIaBDvJ2k9QGs/OwqykIlEvJAl+Uzasp6aKHsKomN5srgPCk6RH5oo9z5KYD6r8DuSDwWdextixNEnKXZsOybFBi1myDhLuAZj8Itc3CF0LwwPnPyHRYLcuYYW0+Wq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774622778; c=relaxed/simple;
	bh=SbAKA/26LwcK0q6dnMapaGU5thIjIo4BFuftIcsI5lY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=rkmBwgcpHQSfz/qPfllQbDGS46YAlSlJ2ubVbMSv/SqN+PQGBo0xzD8ArLEPC9WKQxBJA1/90AVrh6Upc1ZuEwwL6dpyaRoBBqxvs/2citVxWD9Icx16WtqJeMNjbq9uX+/NpQVSL4BZK5mOrvph3wkcpZ8mhiVkZRsP8Io4Bo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqszAYyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqszAYyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BC4C2BCB1;
	Fri, 27 Mar 2026 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774622778;
	bh=SbAKA/26LwcK0q6dnMapaGU5thIjIo4BFuftIcsI5lY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=nqszAYyreIRCife/vpIN9/huQ3fE2pwToGH/nZJFyR9x/kziTa8XBKe+Hf9Sq587B
	 k7vczpCVD/R67EjPkF001zU0l+B8QkezAbLyXM4BfzIzJpwH08jey2VAZ55fFaTpAa
	 UWk56zktKiz+H3eEp5EicsCHHEAV+RzukCLooVLfhv0z72BhAOn22AYa+Xordd3fWj
	 DZ1kv1R6+9yWS29R1UnghQM5fXSC0a+rQYXSY9knHq7KBYcTkmOxKsF4ssQ89pMtjk
	 giRpeA1puUVqa43oAietYqgmHlKtr7QIw7uYY86XdAzCZ8o3RtTVxClBkR91DJKnjj
	 UBE2TFve7tdfg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 04F02F40069;
	Fri, 27 Mar 2026 10:46:17 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 27 Mar 2026 10:46:17 -0400
X-ME-Sender: <xms:OJjGabeK1xgOJy27hyTavZFZ0BZJCaT2m241Zo6OE1NmV_-t6GoBmw>
    <xme:OJjGacBNqagaEeXB8zEFwXswzcInEt-nPdgWwx-kDfJnFfXyHB_rocRHEeD1aLmKj
    S7DGSsPbfu_Z9TRfMilXhqov39ReLD-4Xsw3vAONL28t9DZDUa30NY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffedtheeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehlihhnuhigsegrrhhmlhhinhhugidrohhrghdruhhkpdhrtghpthhtoheprghrnh
    gusegrrhhnuggsrdguvgdprhgtphhtthhopegrrhgusgdoghhithesghhoohhglhgvrdgt
    ohhmpdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopehhtghhsehlshhtrdguvgdprhgtphhtthhopehlihhnuhigqd
    gtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:OJjGaS6Po9-4bXBSer7-ZkhqFNfP8OL95UK2T4hi3RcjCoj-cbA0Vg>
    <xmx:OJjGaQ0APBvxXavPcuwNj07qkbZM6BpV0URyWA9PmCsEsFVeVxf8OQ>
    <xmx:OJjGaVvjE1TzRL1QgJYMMARQo0RR9Fh3mhSrDccjHUeV8PslstPbzg>
    <xmx:OJjGae5FQT5bj2TQ-FBCcLRFm13TD2Or97f2rTu1Mv71cJXK2gXbRw>
    <xmx:OJjGaZeWDcvkzfZHIYoZu8Avzm9bW-HaR8wAO-WJnG1JoFc3jvMj-9Aa>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CEC2C700065; Fri, 27 Mar 2026 10:46:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ANyOC1R28h8-
Date: Fri, 27 Mar 2026 15:45:56 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 "Arnd Bergmann" <arnd@arndb.de>, "Eric Biggers" <ebiggers@kernel.org>
Message-Id: <cca6facc-6c37-48d0-81e6-f8568f36b91d@app.fastmail.com>
In-Reply-To: <20260327135051.GA739@lst.de>
References: <20260327113047.4043492-7-ardb+git@google.com>
 <20260327113047.4043492-11-ardb+git@google.com> <20260327135051.GA739@lst.de>
Subject: Re: [PATCH 4/5] xor/arm64: Use shared NEON intrinsics implementation from
 32-bit ARM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 27 Mar 2026, at 14:50, Christoph Hellwig wrote:
> On Fri, Mar 27, 2026 at 12:30:52PM +0100, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> Tweak the arm64 code so that the pure NEON intrinsics implementation of
>> XOR is shared between arm64 and ARM.
>
> Instead of hiding the implementation in a header, just split xor-neon.c
> into two .c files, one of which could be built by arm32 as well.

That is what patch 3/5 does. This patch wires up that version into arm64, and drops the copy that has become redundant as a result.

> probably
> in the arm/ instead of the arm64/ subdirectory, but we can also add a
> new arm-common one if that's what the arm maintainers prefer.

Having the shared pure NEON version in arm/ is perfectly fine.

Building it as a separate compilation unit for arm64 should also be straight-forward, the only issue is that the 2-way NEON version needs to be shared with the EOR3 compilation unit.


