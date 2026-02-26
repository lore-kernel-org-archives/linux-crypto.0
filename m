Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AD82DC34E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114773; cv=none; b=SOo32QsvFIIso7nCipSzvEozPJ9YYGcH2tpDqXYGXCS/RHFYctn2s33rCH53/YHMLzlZvOAm9JIn5pJYc92b8SF3gloIouwPZIC7DSzjM2MkbTXszWq21az1ZCoOIDaWaatINL+t7iTgjt2rh298opcMaXxSpkfRhh61QpDCkME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114773; c=relaxed/simple;
	bh=uT9JiKcQKJ0pv2CawhWujaRPoPxzzMdg14SR3yeyED0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=exdmWvieYiGMVCUwFX3JRnWdwIdp5PI2VT3rDGQ9C9J7eJ+ccr6rUFI7JU8JFCe8fJGUYkKV1P4Y9jWqxava/S+lsG7KSQIwY2ds0qBjjQ1ABwn8j9Y/Yohmybyq40vZAxn0jz2yy/zykH+lINq5HB6eSx967BspGrxPMaIkc4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNce1AU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNce1AU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B43C19422
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772114773;
	bh=uT9JiKcQKJ0pv2CawhWujaRPoPxzzMdg14SR3yeyED0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=gNce1AU5hDdBnUgw/y7D770KbN4gDfCr9h/QlZDhl3Zl2VdQsgsZOvYs5OUuQ7hs0
	 qiIF0hYG5QliKM735I2/H1xWl4rn21oiYK4hEdnIqufSgoYILbXKSZAN5kYWTMaP3s
	 r7rMWo7CLoCQ9CZFHPzTf8L6Uwb3cPlGrPJaJuls1pnpsKkE42oL8/Xc1xXF/vrBu0
	 5jfetvki5JaohKdnkoeBbNiFvD5a2vxf587hf+2CyDYOeMJsDi5EV1sga188H+t/oF
	 dq7Le/vhLqc1qS7/uhxmRgmhwRPFDfYv0J7lqzAopaLFiX8duKzsaeHKN1LLmgqsfz
	 VIkqPkfDz4UMQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id EA8B0F40069;
	Thu, 26 Feb 2026 09:06:11 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 26 Feb 2026 09:06:11 -0500
X-ME-Sender: <xms:U1OgaVZ5N7C1bqo91QtGLAPuXrmbZd387hlYKFc9b_REatcqmbegrA>
    <xme:U1OgaXPBeClDqi6LTQxqD1c6fnwJmC1DODBcoX8cC-QQWJjbIkbYWFN1vOFvyZJIC
    e41Rm2aTVj9vApVfsKUoTd3kvdJQfUdR6NQCMV8y8NXPG_FrrL7KeI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeeivdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    jedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepshhmuhgvlhhlvghrsegthhhroh
    hnohigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdr
    ohhrghdrrghupdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopeguhhhofigvlhhlshesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    jhgrshhonhesiiigvdgtgedrtghomh
X-ME-Proxy: <xmx:U1OgaVvXnAE0wGIbvKKT6JBSt9Iy7yUclpsbg64P31S9EHlYuDyBgw>
    <xmx:U1OgaYeREID6UtbrBOU7TfPxZfx6ikyuayCzNYu9XvNUu62Oxg6nkw>
    <xmx:U1OgafbOf8wWkG_sVgOiTnYao-Y53LU-ZqwgEKLAph8MJ-TlUqIcVQ>
    <xmx:U1OgaaYg3OUAC-mGrevd1xEWx_KDgcl6tzF-DlXyLBHVxssW1KDzIg>
    <xmx:U1OgaUJb2jM0S_bHQNXhBBa0kUcPjbEn2SHjyn62qoTafvP-wXka7cgX>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C8586700065; Thu, 26 Feb 2026 09:06:11 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AkESWeXa1bhB
Date: Thu, 26 Feb 2026 15:05:50 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David Howells" <dhowells@redhat.com>,
 "Stephan Mueller" <smueller@chronox.de>
Message-Id: <d74eb790-83b7-42ef-bcbd-3a3c03ff1a51@app.fastmail.com>
In-Reply-To: <20260226010005.43528-1-ebiggers@kernel.org>
References: <20260226010005.43528-1-ebiggers@kernel.org>
Subject: Re: [PATCH v7] crypto: jitterentropy - Use SHA-3 library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 26 Feb 2026, at 02:00, Eric Biggers wrote:
> From: David Howells <dhowells@redhat.com>
>
> Make the jitterentropy RNG use the SHA-3 library API instead of
> crypto_shash.  This ends up being quite a bit simpler, as various
> dynamic allocations and error checks become unnecessary.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Co-developed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This is a cleaned-up and rebased version of
> https://lore.kernel.org/linux-crypto/20251017144311.817771-7-dhowells@redhat.com/
> If there are no objections, I'll take this via libcrypto-next.
>
>  crypto/Kconfig               |   2 +-
>  crypto/jitterentropy-kcapi.c | 114 +++++++++--------------------------
>  crypto/jitterentropy.c       |  25 ++++----
>  crypto/jitterentropy.h       |  19 +++---
>  4 files changed, 52 insertions(+), 108 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
