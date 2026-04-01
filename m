Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0610E38B159;
	Wed,  1 Apr 2026 07:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028710; cv=none; b=c7D7jijf4j8/z11dWN7bXQEwOfJYqjC0LDMyj2mfzzsv/1MYpRsy52OMYHmtpdFnNYL+XhOWK154Dq9zH3yrsUNryOYd9EufO5t7WoLD4dL8G7gyDEfwauEcZCdB3CnOI4oxAFzVX9E0wjRiQq8YCrci5eWOvwQkh7d5Q3A9dL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028710; c=relaxed/simple;
	bh=IZ+lq6z/zre6b9tz3T6OUxgEWHImu6aX2Wtg9rskWfk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=AZhjTOWO8WkRKvzuZjyDQWGhyndluOmblT6Gz/0Oq+1hgRztzpIMwrX9aLYOAlJZHvn7gECwBXoIyA2PGZsVSxNGHxqZ4qC6nudqB8RJllicXaFeR8PL+Zk7BE1Cv/mRPG/2YcbgSDhN0juv7dupYjFu9I+0Ki2vp/Yqcm+oR38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlUJKOsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlUJKOsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B947C4CEF7;
	Wed,  1 Apr 2026 07:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028709;
	bh=IZ+lq6z/zre6b9tz3T6OUxgEWHImu6aX2Wtg9rskWfk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=UlUJKOsRldvU9XmGgo4G4xKaAeCvD+h6hEQ9jwYGt8/ewvbqTcQ2q9AiMCYkCqYK5
	 +KJLSWWNprt8ry+D1z5mmyjP8+RQcM8LH2c7aN2e4DpfKAQMo+1gf4yQ1V98OpgRxr
	 qHzZUwm88dj5806tiqSfgnBRDYMJETmPF1KoWzLS6b1b2PbDYdKObCnUrCkEKHXDz1
	 wpK2850kxt3Aw0Tzf0HRvO9kBZadTlNcieS4ol1YlttXPS5Dz4DBgKh18QmYTOFbJe
	 2uOMiIJ4kbAsKZIiW+NAoZX52X9YvYOj1pzVU/etfK0fnFZAGYgns939c5vE4u7/sK
	 SY1/6GTJJkn0Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 65A5FF40068;
	Wed,  1 Apr 2026 03:31:48 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 03:31:48 -0400
X-ME-Sender: <xms:5MnMaeKg8A1q61tCZsM8venvrnLAz-sbzqWepjRwBedys6pwX81JYg>
    <xme:5MnMaQ9g5kfMHRttn6gGr7HTAlHIV0M5Qp0T-qvHNOH7AVPy695SPPm-3l_AhKdoN
    9pj0xELjZ6HXJc3MrgUvX0d1Qfps-LMEg1iYn-3tTHS3VI8siRUow8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtoh
    epvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgr
    rhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtth
    hopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtph
    htthhopehjrghsohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:5MnMaby4mtw-gACOFsUupxx4Pkwx1rFt_0YnBoUPOLjKwcjPoI4Hsg>
    <xmx:5MnMadXvdpfwQXqSJAWR3u_Ug0hX1IzdZY3pKg5gAFlU937gkyqElw>
    <xmx:5MnMaVPXU5v8oUnjZmyXXXM6pHTpbWiorTTciQiaQMef8iMKKrG9ZQ>
    <xmx:5MnMaXA7FH-ZnmRw-7YZ8vU7vYQxglgEODEFaHgPASd74M7bJ7tHWQ>
    <xmx:5MnMaaes0MfeYHxl76zBapdvrxOqz63mNr3G8aulUFUWgNP3Q8XJwVfg>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 48FA2700065; Wed,  1 Apr 2026 03:31:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AbuMglSPIfTN
Date: Wed, 01 Apr 2026 09:31:28 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org
Message-Id: <dd3a1dbb-4426-49e4-899c-a9377ec0939d@app.fastmail.com>
In-Reply-To: <20260401003331.144065-1-ebiggers@kernel.org>
References: <20260401003331.144065-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: arm64: Assume a little-endian kernel
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 1 Apr 2026, at 02:33, Eric Biggers wrote:
> Since support for big-endian arm64 kernels was removed, the CPU_LE()
> macro now unconditionally emits the code it is passed, and the CPU_BE()
> macro now unconditionally discards the code it is passed.
>
> Simplify the assembly code in lib/crypto/arm64/ accordingly.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next
>
>  lib/crypto/arm64/aes-cipher-core.S  | 10 -------
>  lib/crypto/arm64/chacha-neon-core.S | 16 -----------
>  lib/crypto/arm64/ghash-neon-core.S  |  2 +-
>  lib/crypto/arm64/sha1-ce-core.S     |  8 +++---
>  lib/crypto/arm64/sha256-ce.S        | 41 +++++++++++++----------------
>  lib/crypto/arm64/sha512-ce-core.S   | 16 +++++------
>  lib/crypto/arm64/sm3-ce-core.S      |  8 +++---
>  7 files changed, 36 insertions(+), 65 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
