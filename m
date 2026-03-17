Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3193D338936
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 11:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745827; cv=none; b=cnNPDJTgLvMWZmF5lwMBpu0B3Lpwk3OuS4Mie3tWOtDqYssxk9lu7UF4Mpo8UqCj9BVa2jS9d6t1Uw4SoSsgh56dIe5WIM+BgNPDZq/R03Agg8nfHWnRClNTPAZwrKYW20pKyo1yIl4IfjOCYMvotMwGdCICvJBySwdn+mQXNuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745827; c=relaxed/simple;
	bh=0Lr6Nt9XErThwDSfrPsQ/yXnKWCRtxxMB/fbTlmjbzI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QLMqNJgpxthqetMtcKWxte2iYyHrQm+FLVYNuXuCsh7PSH4x/v3XBWDnWUiYNccNXeMn1yCjG7DlBDNUdaD0GhI3kYdB5xky2ZaX64cZPtjWdERNvs8xiPlCoN8hFq2gkNCpm3Emw1cwOX+03WZZbr4GNR2Eou+DJAcHU9fYxCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUuLDKn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUuLDKn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7497C4CEF7;
	Tue, 17 Mar 2026 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745826;
	bh=0Lr6Nt9XErThwDSfrPsQ/yXnKWCRtxxMB/fbTlmjbzI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=OUuLDKn67fqwOKo9XbkXtvzSCSCO970Esvu4h7rT+g8QFFbo4raQ7E3NYBmrfuRE6
	 WBCshlWiPD+WOfbWl8IbS7nHo9NF5P8sc5iznuWIiS7wLN1F1obat2SfPrblHQoddU
	 z6cf2ld91MLnXykXWtxMLZGqLdEYo/eFjLQ4T8wg3VvD+ZMi6i3ueNAbI2aGxAAOS1
	 DLlb+HniLl4HgOTdzUyBsa4qc66k3TwmTvKfETUGW8yC/vSi3FYiR5QeP9CI7csSBd
	 uiYhNDDLQ21U3Ouvek4giWABCNqf6jq/wAadx2yi090S74ZAD+V4D7xlA9xf0Xsjec
	 n0Q/dif3UiNTQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id B540AF4006A;
	Tue, 17 Mar 2026 07:10:25 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:10:25 -0400
X-ME-Sender: <xms:oTa5aRREPaI867nWqvmwmQzNVPWfAO19S9WOLX43q-vLAfnbG4Hj-g>
    <xme:oTa5aVnIPhW8hE6bShS99kVBUO8dGX3eWwiJwWxxUD4tzcCJMdPBOX863NjMtT6mk
    PJyu8ieBmFf6r6hukm1r-ra806hy3zd2_ANkYUgo69utQUn2MX2s2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepkhhunhhithdquggvvhesghhoohhglhgvghhrohhuphhsrdgtohhmpdhrtghpthht
    ohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    gtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghsoh
    hnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:oTa5aYKiVM5uRXw9i1M2uA6ryiD8ffQdA_xLzdTN0BMXnL43jbR3iw>
    <xmx:oTa5aY1rkf4dOUn6MQfETUTTCfYAEfAq0FAJ0NqoX1g4QXSxNMjIdg>
    <xmx:oTa5aW5NPL6TcPSqdEPEP887UhTgTr4d7mYvLEg3xBAS8DGGfkHycA>
    <xmx:oTa5aZ8r80SXEnbuBop9UqQKZkIJwlzNhCE5Sm4aloBMtQ8fjxYcig>
    <xmx:oTa5aVXIKGGd3eW5RmebAMNwuKsjh_rCbfANCN9eU7IpAgcKrUDGwRRi>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 95C42700069; Tue, 17 Mar 2026 07:10:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A18XS3shSXrs
Date: Tue, 17 Mar 2026 12:10:05 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com
Message-Id: <4b141383-9bb5-4396-8d4d-479e177bc698@app.fastmail.com>
In-Reply-To: <20260317040626.5697-1-ebiggers@kernel.org>
References: <20260317040626.5697-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: tests: Drop the default to CRYPTO_SELFTESTS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 17 Mar 2026, at 05:06, Eric Biggers wrote:
> Defaulting the crypto KUnit tests to KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
> instead of simply KUNIT_ALL_TESTS was originally intended to make it
> easy to enable all the crypto KUnit tests.  This additional default is
> nonstandard for KUnit tests, though, and it can cause all the KUnit
> tests to be built-in unexpectedly if CRYPTO_SELFTESTS is set.  It also
> constitutes a back-reference to crypto/ from lib/crypto/, which is
> something that we should be avoiding in order to get clean layering.
>
> Now that we provide a lib/crypto/.kunitconfig file that enables all
> crypto KUnit tests, let's consider that to be the supported way to
> enable all these tests, and drop the default of CRYPTO_SELFTESTS.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next
>
>  lib/crypto/tests/Kconfig | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
