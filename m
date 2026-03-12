Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2834835836F;
	Thu, 12 Mar 2026 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773303885; cv=none; b=h6lt/lntnGalSjk6lYeHo6vLEY6CMzDu3C7H+upyy66hSENkkTPLy78WLdizRrVK4m+tlU7BQSdRW7ue1Q6ieFGUhxcJ82HtiUmbOuwQohhmNbzBempwsd6B2CBOmN/KJr+0r2Mmhq5Fw2E0uQXHn8euOwaVloit9vqnJTVN+5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773303885; c=relaxed/simple;
	bh=ReRqdJ2O2suhdN1AGySEIcJYpF4NU5DTlplHwxXGvig=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DrpxTzP9dLb1As/KgQ0bqcDzMLkqkGEbzcF1I+uTn/BBnU9lLzZsrL6Z6ueuXkx+HxrIK/llY4m1rlXw3dkmC4kjC1GFw7KDZP3Bqsg1s1Tr6IDrEMZQkcTX//dQ+W+J6fyTINgqN4O2t0UyUJqmsnROtkv6oRDbGbbvCoP6zOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIep8L8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIep8L8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5C4C4CEF7;
	Thu, 12 Mar 2026 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773303884;
	bh=ReRqdJ2O2suhdN1AGySEIcJYpF4NU5DTlplHwxXGvig=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=aIep8L8PvTO9QsEOnFmjPGV1O4Jal/EKmLHSs2cN+FmpfGMtiseckKRvu8EZ12/Mz
	 cLKuvPtKEbp/DhqlmnLbAX+MgpOUu1ZjXCQCIBi9I+qYytFDrMBGLz/lHhgXvYnBNi
	 WehsJSODNz3TX0p3WqFRh2N7F420E928gQmqtt4ZkWjABRGlq/D/V451vkhOo/fIMu
	 k56eM5TfSBFiKh9aiFSx9gtj9vOm5yrX5u6eMxFERAPWzFkIdqN/HAZQddUHoH/qQf
	 B7Qfkz2RBsNDAX6PfxVFoVdZkgof/IiUnB7qGCUU4glZegm/FbE8yvEiDMDvAi2Arv
	 h+W/AbU8946gA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D4817F40068;
	Thu, 12 Mar 2026 04:24:42 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 12 Mar 2026 04:24:42 -0400
X-ME-Sender: <xms:SniyaVPO8MH2B3baW4sm6V2BE2TgvExpbekmugxzcsJKpT8neVJKfA>
    <xme:SniyaSw_-fZxUQz7NniiBX5nZI9Hq_BBeKuFKtynSyX9KyrK7uqU9776PLqhVUSqa
    DjP4LsxgYybXbQsNxe5qXuyBh1xWiq6RMg7N9e5Pzw3vzZYJpSABc8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeeivdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehmphgvse
    gvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopehnphhighhgihhnsehgmhgrihhl
    rdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorh
    hgrdgruhdprhgtphhtthhopegthhhlvghrohihsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehthhhorhhsthgvnhdrsghluhhmsehlihhnuhigrdguvghvpdhrtghpthhtohepmh
    grugguhieslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdq
    uggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtohephhgrrhgvnhesuh
    hsrdhisghmrdgtohhm
X-ME-Proxy: <xmx:SniyaQcnQrOrKvFl4vVFb_DO1WEHvLtndEh8NY_hteV88ZRdjql_TA>
    <xmx:Sniyaelnjw9DL9AYYcDJpXCULGRnVJhewuOzEqt9p49RuOm3A60TRw>
    <xmx:SniyaV8l8pI7Xm9nryC45L3LmDBaI01r5sLWmwhmMxmGoDAoVN1Yxw>
    <xmx:SniyaUFYdnu5XMmNclHK8dXVk-1rpWL-vdqUYesCntOKGG4_SX101w>
    <xmx:SniyaZKZYEu_JhKFyFb-aL2upc_8LJpmJCkabG4487PfZ59MIlcXZo-H>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id ABA34700065; Thu, 12 Mar 2026 04:24:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AUCAS038dxvZ
Date: Thu, 12 Mar 2026 09:24:22 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thorsten Blum" <thorsten.blum@linux.dev>,
 "Haren Myneni" <haren@us.ibm.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <8b29d93a-2437-4e77-8348-83dce77501a6@app.fastmail.com>
In-Reply-To: <20260311155645.397083-6-thorsten.blum@linux.dev>
References: <20260311155645.397083-4-thorsten.blum@linux.dev>
 <20260311155645.397083-6-thorsten.blum@linux.dev>
Subject: Re: [PATCH 2/2] crypto: nx - fix context leak in nx842_crypto_free_ctx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 11 Mar 2026, at 16:56, Thorsten Blum wrote:
> Since the scomp conversion, nx842_crypto_alloc_ctx() allocates the
> context separately, but nx842_crypto_free_ctx() never releases it. Add
> the missing kfree(ctx) to nx842_crypto_free_ctx(), and reuse
> nx842_crypto_free_ctx() in the allocation error path.
>
> Fixes: 980b5705f4e7 ("crypto: nx - Migrate to scomp API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/nx/nx-842.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index 661568ce47f0..a61208cbcd27 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -115,10 +115,7 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
>  	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
>  	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
>  	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
> -		kfree(ctx->wmem);
> -		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
> -		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
> -		kfree(ctx);
> +		nx842_crypto_free_ctx(ctx);
>  		return ERR_PTR(-ENOMEM);
>  	}
> 
> @@ -133,6 +130,7 @@ void nx842_crypto_free_ctx(void *p)
>  	kfree(ctx->wmem);
>  	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
>  	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
> +	kfree(ctx);
>  }
>  EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
