Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA4156661
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 11:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745680; cv=none; b=QJGvwAYywK+Kr6NapNWVkt5S7eWclVD09ivphWjRNSimW1xc5mMeba+6FYVWRbPvxFZSUJ2KVBDH4APTVkeRk0yQ1gjqpW0UTsIDSrAHrhH37WpjiaF2bBOcvtObEjHE3RJ2rl8vE624CRePO7APi+EurcEWuwEglOTm5bWCnzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745680; c=relaxed/simple;
	bh=VJykopToX6LJ8tQfSw1XZB9c5CF98eXzH50MCcxi64k=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UOwHYy/B+GuFRt3oai1brAe5b0vR/+oid9cP5h3G+k6eAh5O4/6QYsbi7AjyGWE+7tmSr/bOG12GSGqTkmagfMXRycknDHednY77B9YL4igMTMAWrB44So4jgJY7mVvehDlQbyeV/mMF5yV2O3mjxpkz3dYG7GKOLV3Q78Jr1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFmuPB0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFmuPB0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B7CC19425
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 11:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745680;
	bh=VJykopToX6LJ8tQfSw1XZB9c5CF98eXzH50MCcxi64k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=SFmuPB0/4xPfyaYrzEyxY3XoLaO9v3CyK2iQe/mzp/1lVw7bRhp1r5Ra4+KqWk+Y3
	 YUFwTtvVJuAuwGfYSv8YRQ7EbQH7ydefFbUqjtujUTck/J+16oCtufMusaWlii1/J9
	 7xLteOdXYWxbszl5yQ8rTvxFKTJkd5tR7EW2BaB4OQkTtoqOiZUb5JGWTpNuTJ0hNZ
	 NXCqFlAAjW2og2UavbXVHAqv5FwxfPSYGhjumEjj70pBONNCg3NwaQEyQemxsBIh6O
	 nk7dVbrxMuNIrstdIoOKGUurk/kQicr+7leDLZ8NglkMLRa1Gx5kziAqW/HLfnWdk0
	 IwZZeFiWDVg1w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 14639F40069;
	Tue, 17 Mar 2026 07:07:59 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:07:59 -0400
X-ME-Sender: <xms:Dza5aeUyOMMZCFNUT-2FhLUx_5p9GKcAYjYkzn9YBuuZKWZObLbf0Q>
    <xme:Dza5aVY9Uvkc4EBqpQVsj-xs_WlZ0CVtC0zKrSIpLRoYZz_bLinzQwi9mnZBNyJ1Z
    MsrExmeS3PgUDi7WXMxmXYFSBLCDdB6ST0_wDhxRHhrCdwr7T9MqzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegouf
    hushhpvggtthffohhmrghinhculdegledmnecujfgurhepofggfffhvfevkfgjfhfutgfg
    sehtjeertdertddtnecuhfhrohhmpedftehrugcuuehivghshhgvuhhvvghlfdcuoegrrh
    gusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpedutdehvddvteeuteev
    leffhfeiteefvefggfefieekgeetudfhtdfhgfeuveejteenucffohhmrghinhepshhouh
    hrtggvfhhorhhgvgdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqd
    duieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhg
    seifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmth
    hpohhuthdprhgtphhtthhopehgvggvrhhtodhrvghnvghsrghssehglhhiuggvrhdrsggv
    pdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Dza5aTcCAbRywkPgSVRxyf81YED-stbRkR9_y0dBCDZnoDhxwHqYSw>
    <xmx:Dza5aUqptZfn-Kq5ZwiZpntWMBxl5AR6IncFxynKnQ4zTw_IgNJYyA>
    <xmx:Dza5aQCklJIzRx9EAp8Q83tzM5APgFzugCYfzKnOVRiQRQVuYG8i9w>
    <xmx:Dza5aZa6zj-UflGhKnGRh3QlpT3x_HXTfoZJ21vPqZlI1ddRrGXfSw>
    <xmx:Dza5ab7IAqBq9a4TM_38X0wulScSNzA96LvbXf-Ivm3hzjvEUmEAG28T>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E5B8E700069; Tue, 17 Mar 2026 07:07:58 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AQoSPC2uuQ3N
Date: Tue, 17 Mar 2026 12:07:38 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
 "Geert Uytterhoeven" <geert+renesas@glider.be>
Message-Id: <092c1681-c863-49fc-aa3a-5780532be8bd@app.fastmail.com>
In-Reply-To: <20260314173130.16683-1-ebiggers@kernel.org>
References: <20260314173130.16683-1-ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: crc32c - Remove more outdated usage information
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 14 Mar 2026, at 18:31, Eric Biggers wrote:
> Remove information from the crypto/crc32c.c file comment that is no
> longer applicable now that nearly all users of CRC-32C are simply using
> the crc32c() library function instead.  This continues the cleanup from
> commit 0ef6eb10f2e0 ("crypto: Clean up help text for CRYPTO_CRC32C").
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting crc-next.
>
>  crypto/crc32c.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/crypto/crc32c.c b/crypto/crc32c.c
> index 1eff54dde2f74..c6c9c727b25b4 100644
> --- a/crypto/crc32c.c
> +++ b/crypto/crc32c.c
> @@ -1,10 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  /*
> - * Cryptographic API.
> - *
> - * CRC32C chksum
> + * crypto_shash support for CRC-32C
>   *
>   *@Article{castagnoli-crc,
>   * author =       { Guy Castagnoli and Stefan Braeuer and Martin Herrman},
>   * title =        {{Optimization of Cyclic Redundancy-Check Codes with 24
>   *                 and 32 Parity Bits}},
> @@ -13,20 +11,10 @@
>   * volume =       {41},
>   * number =       {6},
>   * pages =        {},
>   * month =        {June},
>   *}
> - * Used by the iSCSI driver, possibly others, and derived from
> - * the iscsi-crc.c module of the linux-iscsi driver at
> - * http://linux-iscsi.sourceforge.net.
> - *
> - * Following the example of lib/crc32, this function is intended to be
> - * flexible and useful for all users.  Modules that currently have their
> - * own crc32c, but hopefully may be able to use this one are:
> - *  net/sctp (please add all your doco to here if you change to
> - *            use this one!)
> - *  <endoflist>
>   *
>   * Copyright (c) 2004 Cisco Systems, Inc.
>   * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
>   */
> 
>
> base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
> -- 
> 2.53.0
