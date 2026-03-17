Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B5135B642;
	Tue, 17 Mar 2026 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745849; cv=none; b=RwkAVbcswTH+wLsrKlIOGmGZNiXHz/KkWaD7b1+lgjU/u26BJdBrp4Fp1LR6WdqsVTQwlod3NAymsGA0fK5lsemDBK4omSSuGzLqzeoYoGR7Cal1qY506VGicWZGAvyAQutMDCUOeRXbO7N+Q/293K3NptghR4e6/C0Wfq+yIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745849; c=relaxed/simple;
	bh=x9PElXOzLo/fiDVFYlUls3v9y8szisUMmw++Ydf0KLg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=U4OlqhThoUJgv5uCL2WllCiqGGyKkiEXDtahWpcbkVOP17vLpPygE16wB/JhWKQETpcKn2LIufANli3vMkf233eT4W/wI/TRsF7sHKnJf/OpgqUu4xT8IfxbgVem+nB2VZrz4c1bg3IVRF8BOQlyLu+kk4A9P89tT/uIk3zZqsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtR1LjW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtR1LjW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADC5C4CEF7;
	Tue, 17 Mar 2026 11:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745849;
	bh=x9PElXOzLo/fiDVFYlUls3v9y8szisUMmw++Ydf0KLg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=UtR1LjW7eM3X8eASnPvPpiI2W/Mc94IRgBHpNkDMDHG3gO4s3RP7ISXYWGl1MoPQ9
	 WOL5d/3Gsn25UlPtncpT4CwyQwa/7adobuzGeD1b3c/SvJEuKV8b/AtW45TntGrDo6
	 zxGRHm9+nBdg/nIL89BF2/hnN6nt2WT62qfqyzD1/2yDIzTtb3c/oyu7fhU1K/79+T
	 eKNrsGb3SJpJB9gl0UGr2m8fLwJMreMMCMovWus/jUlmehy1BDiu4OB1ntjgqI0qVC
	 tSQBD2nN9B4Rm3GjkzN9lU0Pi7wEP4LGXhKoDb+vKQhd64Kb4shAZx8NNLqVGuZIz9
	 7otVjIan+LF3A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4210BF4006A;
	Tue, 17 Mar 2026 07:10:48 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:10:48 -0400
X-ME-Sender: <xms:uDa5aQOPwpwjgZf9ERKtQ19OlrJ2hXkSc8vi5SwYwr9ykraNNRq1Yg>
    <xme:uDa5aRxqpteQriWaWLwL-po-Npdj_7C5js-yIbWBLfJm7IH2eaYNjZBbQaA3936-P
    QGal2--JjcisCXRdPt2RV5KiIWM7k4mL5KYjFttk5yj9Sg-c0JFKPuB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:uDa5aTxKhRSg_P_sRXroClI9_u5E3Vw8NVoRr_7EOXuXB8mFjuNSZw>
    <xmx:uDa5abYEVP-dJF1ulz9AoWr6QqDw7CKzVAupnfi6XpNFYdWw1iJPgg>
    <xmx:uDa5aVSPnMz2kGm58kRD-Tj8bApkgEGTi0bW3Q7unjhyfdDNvs41Sw>
    <xmx:uDa5aVw_DSQIGRBt3Li9GMFyPmHn22riNXyhFqiuiYsGV25bLB3oRQ>
    <xmx:uDa5af2vSt_FmLdQjGgJPTlSXfpqn2CqzFjCsFQgssnRM_s8Vac_Y2kt>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 22D10700065; Tue, 17 Mar 2026 07:10:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A5Cm1KdKaf2g
Date: Tue, 17 Mar 2026 12:10:27 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Message-Id: <7ffbc472-69a3-4350-a19f-1349650ae4da@app.fastmail.com>
In-Reply-To: <20260316205659.17936-1-ebiggers@kernel.org>
References: <20260316205659.17936-1-ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: crc32c - Remove another outdated comment
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 16 Mar 2026, at 21:56, Eric Biggers wrote:
> This code just calls crc32c(), which has a number of different
> implementations, not just the byte-at-a-time table-based one.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting crc-next
>
>  crypto/crc32c.c | 5 -----
>  1 file changed, 5 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/crypto/crc32c.c b/crypto/crc32c.c
> index 1eff54dde2f7..3754985ab948 100644
> --- a/crypto/crc32c.c
> +++ b/crypto/crc32c.c
> @@ -47,15 +47,10 @@ struct chksum_ctx {
> 
>  struct chksum_desc_ctx {
>  	u32 crc;
>  };
> 
> -/*
> - * Steps through buffer one byte at a time, calculates reflected
> - * crc using table.
> - */
> -
>  static int chksum_init(struct shash_desc *desc)
>  {
>  	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
>  	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
> 
>
> base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
> -- 
> 2.53.0
