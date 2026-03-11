Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0003BC68F;
	Wed, 11 Mar 2026 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773242199; cv=none; b=LwoALlxJ2VRMFVNzJ42PRdQVBmDvkdLynt8z89IpEmeSqvMTUCRHurUAVvgBSSFFlVW3l4adAbQgflWkK+5wc9enOjjeguapLOeRftbm69Wzq69APLssrAyV2yi1Wxt96BdFA/u5yqx4KkoO06ICe+PSQLGUX6iA8+CeuFDk9AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773242199; c=relaxed/simple;
	bh=F00Y1VOXMkGh5fI+xpEZJV+zT5hVxwEfpxSmPV9tdhA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=A25dMKSPEY0S9xTAMGvdS5InKa3ewYa0U7hiBSLhjI28MhiynR6/cj6mqmT0qEeOD+o7X7lw3LTbhJEMYcOlLPNBGBDTfnXqWrmJ8uaUhWB0a7bKqlrlCM8E9hnIbvsOGqkrPcWej2+Ng9/A7gxjSijuklfzIQEU5Ubfnzb/pb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c77hS1at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c77hS1at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7331FC2BCB2;
	Wed, 11 Mar 2026 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773242198;
	bh=F00Y1VOXMkGh5fI+xpEZJV+zT5hVxwEfpxSmPV9tdhA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=c77hS1at/JZblP0fVHkdgqdxmbNk0m29v/+B9SqPsQ0OJEPe7IYswS03++eyeezhM
	 1E5riyLZFGcHmsM2vknxf2FMbFwpwu2/IUx0Bc89GpVwxoFcX+M5BUtCF/dN2364kZ
	 eTYbgtTHSI8W7kTfRc5o8unvXlVBEWrKPo5B/DKOJUr7ZZig7fzrZgEhhDd2Lnp0B0
	 yjJPrfWhLMn060FOAgegTeUSHeC8WvsBEW8YAx7t0Kag4FcNCp2iRvlLjZrwalMQ0c
	 fVerqa3ahYYrA25+60L81YEzjrL/qTeyCza8Tq0AO6cCzkOheuY1Xi5j0tUpMSNlkG
	 IpVe59ZgiZfSQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 527FFF40068;
	Wed, 11 Mar 2026 11:16:37 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 11 Mar 2026 11:16:37 -0400
X-ME-Sender: <xms:VYexadI4kNrjs5As7xl3i7OxQxe8g963MATQjSe2AhXM2Bc5Lp9i2Q>
    <xme:VYexaT-xm_sBM_b5I6B2D0qfphLF9dGrxOS90Ah-Imot3bQ8VisbN2wVi3hojApem
    YwnMqfOZvomSY6D6VbTPUHhQKL8Hx06HS3_uyGiOiVrmiZm-qEK1AY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeegvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehmphgvse
    gvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopehnphhighhgihhnsehgmhgrihhl
    rdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorh
    hgrdgruhdprhgtphhtthhopeguughsthhrvggvthesihgvvggvrdhorhhgpdhrtghpthht
    oheptghhlhgvrhhohieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhhohhrshhtvg
    hnrdgslhhumheslhhinhhugidruggvvhdprhgtphhtthhopehmrgguugihsehlihhnuhig
    rdhisghmrdgtohhmpdhrtghpthhtoheplhhinhhugihpphgtqdguvghvsehlihhsthhsrd
    hoiihlrggsshdrohhrgh
X-ME-Proxy: <xmx:VYexaTa3KyQNAKenEWbm-legEnEE-14ZJ4WIf3sUpH219oAoRymVyQ>
    <xmx:VYexaTD24scrPaIp175ec8rwsHiGUjiQEl8WN7bIYXFinXP73xIyog>
    <xmx:VYexaRHCo-_iPPz20mcu1_t6aDW9mn_-ePP09NKn74psZdEVYaCEuw>
    <xmx:VYexaePxa-niW0sg38AOI014nJbCsxBBAT_xGxXwK3v4P2EahmII-g>
    <xmx:VYexaShPP-mq6-G7rZdHmFZ_TFtiXDTV8IcwvSqhGtNo3f1qqm1ZNngX>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2D7F6700065; Wed, 11 Mar 2026 11:16:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AZ_gtfwdS8bs
Date: Wed, 11 Mar 2026 16:16:16 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thorsten Blum" <thorsten.blum@linux.dev>,
 "Haren Myneni" <haren@us.ibm.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Dan Streetman" <ddstreet@ieee.org>
Cc: stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <47dd8932-7347-4744-be8d-79106bc76f4b@app.fastmail.com>
In-Reply-To: <20260311150922.382941-3-thorsten.blum@linux.dev>
References: <20260311150922.382941-3-thorsten.blum@linux.dev>
Subject: Re: [PATCH] crypto: nx - fix memory leaks in nx842_crypto_{alloc,free}_ctx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Thorsten,

On Wed, 11 Mar 2026, at 16:09, Thorsten Blum wrote:
> The bounce buffers are allocated with __get_free_pages() using
> BOUNCE_BUFFER_ORDER (order 2 = 4 pages), but both the allocation error
> path and nx842_crypto_free_ctx() release the buffers with free_page().
> Use free_pages() with the matching order instead.
>
> Also, since the scomp conversion, nx842_crypto_alloc_ctx() allocates the
> context separately, but nx842_crypto_free_ctx() never releases it. Add
> the missing kfree(ctx) in nx842_crypto_free_ctx(), and reuse
> nx842_crypto_free_ctx() in the allocation error path.
>
> Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
> Fixes: 980b5705f4e7 ("crypto: nx - Migrate to scomp API")

Thanks for the fixes.

Given that you are fixing two separate issues that were introduced ~10 years apart, I think it would be better to split this up.

