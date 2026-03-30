Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D16E3B52E0
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 09:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774863517; cv=none; b=Q0iL1+yfoui2JiPCj+EKL1Od6HzEqttTS0veTsM3BKd12cM5ukMVc2fE4cYdCrEwHpgpyPMw/ZsozP0RHKscNqm7FyN+mdSW61rS12qwvIz3trR1dEfJaVfgL+8US3BXNmUZi0msVo8cEkzQi0Zf0cMrPJkYbFSSWIk3UUEQezo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774863517; c=relaxed/simple;
	bh=fAdYPy7Om/Grjcj3D4dgPx4d1A0YnUdkorPrk2YsD0Q=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=nHKKRCH8h5Zurz0+qtdOTB8Qw21pnymXTR5LGL/rVND0sU8BkSbUG9il5l3rH8VaFzHjcM5Cqi8/g0QPvZ+vizME9samZPjbH6+fNLvDDNefV0Xc1tBsvFi+RNREDLGY4u1Qe9ULEQn6r4xg5iERNMi7N3g4osfF0tznW0eJdvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAetkx6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAetkx6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0599C2BCB1;
	Mon, 30 Mar 2026 09:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774863517;
	bh=fAdYPy7Om/Grjcj3D4dgPx4d1A0YnUdkorPrk2YsD0Q=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=GAetkx6e+91KOEad750tVxF8nAPVBNnmGqy0JrJXOQnQFprwva1clNwxlkoFoYpYy
	 rtKBamzQYQcYAfEDzjLsULAG6VNwpe/xwbVGnq31n3QNa6lou1fDvdipywPIoHCKUc
	 VNJZ6Jq7/KlhUmi6K3yOF6vivybIWuYTGWaVwo4zYdYVPAS6IPHpmb95mWA+vBYGF9
	 Kqy2UGTsT9ufmG3QATyqCX0X81gvCTIGYUYrD4rBN3Ik8pRGiX6g/iRYGj9/YLxnl4
	 KP93qOupPXano4YXG2Uy65Kt7Qvi+Ng+6RNoFBVPcWQrWA0/jRZE3KhiqgFOWiW79o
	 VSQrEouybrOVg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D1516F4006A;
	Mon, 30 Mar 2026 05:38:35 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 30 Mar 2026 05:38:35 -0400
X-ME-Sender: <xms:m0TKaS7P4d8mZZTtNW1NjyFN_vHPm5SeJoijwqSpODH2iB_80MfYgw>
    <xme:m0TKaWteP_HfVeiGnwb0jWKhARaBykDFc5ByCZJhGcTx2MtcM3xCRelaYHWoUoXhz
    XIPbmWGw9lwHniuyRvlLI6-5_EBZEUQ59Xz_kFYFojM8UHeYNGC4JxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeekieegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:m0TKaR1in3FT9xqOwfpkqjxfDGryA9nN4D518OaL5fn7d9JEzGatVA>
    <xmx:m0TKadCJSzmOXxCIJGHfia8hIf1Za35o3CGPqXZ8424XlvL7Z4TF7w>
    <xmx:m0TKaWK9OjCORpI0xSB7dLUJP3QOeZKDf2Wo0d1sVhIUH9ARWaO1ww>
    <xmx:m0TKaelkIvPpasl8mTq5c7FztRy1DBrXrM7W7cVru34y45W2wcxW5w>
    <xmx:m0TKaXZJIUpnJGka1Yi6hm35V0b2UOekx-USUSxGeNoX7Wgtfwbht12w>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AAE92700069; Mon, 30 Mar 2026 05:38:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ANyOC1R28h8-
Date: Mon, 30 Mar 2026 11:38:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Ard Biesheuvel" <ardb+git@google.com>, linux-raid@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 "Russell King" <linux@armlinux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
 "Eric Biggers" <ebiggers@kernel.org>
Message-Id: <6bedf98e-a424-4baa-890c-806345c067c1@app.fastmail.com>
In-Reply-To: <20260330053233.GB4736@lst.de>
References: <20260327113047.4043492-7-ardb+git@google.com>
 <20260327113047.4043492-11-ardb+git@google.com> <20260327135051.GA739@lst.de>
 <cca6facc-6c37-48d0-81e6-f8568f36b91d@app.fastmail.com>
 <20260330053233.GB4736@lst.de>
Subject: Re: [PATCH 4/5] xor/arm64: Use shared NEON intrinsics implementation from
 32-bit ARM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 30 Mar 2026, at 07:32, Christoph Hellwig wrote:
> On Fri, Mar 27, 2026 at 03:45:56PM +0100, Ard Biesheuvel wrote:
>> On Fri, 27 Mar 2026, at 14:50, Christoph Hellwig wrote:
>> > On Fri, Mar 27, 2026 at 12:30:52PM +0100, Ard Biesheuvel wrote:
>> >> From: Ard Biesheuvel <ardb@kernel.org>
>> >> 
>> >> Tweak the arm64 code so that the pure NEON intrinsics implementation of
>> >> XOR is shared between arm64 and ARM.
>> >
>> > Instead of hiding the implementation in a header, just split xor-neon.c
>> > into two .c files, one of which could be built by arm32 as well.
>> 
>> That is what patch 3/5 does. This patch wires up that version into arm64, and drops the copy that has become redundant as a result.
>
> Yeah, sorry - I misread the series a little.
>
>> 
>> > probably
>> > in the arm/ instead of the arm64/ subdirectory, but we can also add a
>> > new arm-common one if that's what the arm maintainers prefer.
>> 
>> Having the shared pure NEON version in arm/ is perfectly fine.
>
> So here would be my preference:
>
>  - keep all the arm/arm64 code in lib/raid/xor/arm
>  - have the neon and EOR3 code in a single xor-neon.c file, with an
>    ifdef CONFIG_ARM64 around the EOE3 routines
>
> This avoid the including of .c files which is always a bit ugly.
> But if there is a strong argument to prefer including of the .c file I
> can live with that as well.
>

I've respun it without the include. Instead, I've added this to arm/xor-neon.c

+#ifdef CONFIG_ARM64
+extern typeof(__xor_neon_2) __xor_eor3_2 __alias(__xor_neon_2);
+#endif

so that __xor_eor3_2() exists in the arm64 build as an alias. That way, the arm64-only EOR3 implementation can just remain a separate compilation unit.

I could move the eor3 code under arm/ too, but that seems a bit odd given that it is arm64 only, and a arm64/ sub-directory exists.


