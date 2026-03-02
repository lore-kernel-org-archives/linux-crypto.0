Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F29239E88
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464041; cv=none; b=NQPUcEbT5sIIhA9wN0Kt2IHdtg4PR41JYrfI2+C/YFg2R8oG0zhSF1BZ4RPSdF28UYdLuUZZn7l+WpUcBJ5fpV1sR8wVqZE19JEYgCOIZ99Rff3CcjiFVPRaqZVl9U4yApr9Zpt9MJQgBoORwIigPyl69BDaQHCeSszdIHMVGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464041; c=relaxed/simple;
	bh=ODDd4lYneiECSGW5Q5K4OMs77T82tglNOAaANRA0IqM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ifjvXCPQNdPDLSl5U7BdtLQw50MtJEY8MaxKi60zn2a+Jse5daoTS33HYl59y8jLoPneJ+wtikRkoqZ3ybSRzPBOEW5HZxO+y4tQ91uLjLbR395NChvrwGQYJOC7Ilq+dOj4B/0kGkntky1dCW+cU5p9ravkCXQNQUt8o0D60+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j41caqtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j41caqtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB38C2BC87;
	Mon,  2 Mar 2026 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772464041;
	bh=ODDd4lYneiECSGW5Q5K4OMs77T82tglNOAaANRA0IqM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=j41caqtI5viNHtXPTMfUPPbw66e6Rs8w2/INUxRxAodH3veOuMkMBrVV1qaEVXRx8
	 WmgzFMA7xEhkhNbRlltivY9MAbURvQPLvLBCcVBhgQjJ7i6BoekJIwpQDxqZ1i2Ivt
	 z8ZGcpNICFq86SkxySjzAgnQBmhYg4hEspLv/5/shOsNihbuYzfQr7q7X9t4kEyYVE
	 Te/ijdZQRGcAZ+VL4LJmcV1vtm0Dqbfk//5NDc97Tp7/GIfWwkBVppqvpA2Kyce6i/
	 MXnB9jXmiYmuaQoipc51xlDZCvkOTI4DZjaJY+p4P2dHqITklsiplJYHhpSXi0h24j
	 O10o5+TaDwmpw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1A6A3F40070;
	Mon,  2 Mar 2026 10:07:20 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 02 Mar 2026 10:07:20 -0500
X-ME-Sender: <xms:qKelaTNuocR7xAIbe7OizZvEuRyiHv-gugrLM7IS-ZEICr8VUZSYZw>
    <xme:qKelaYyRUG7V-unjHiqmnZnDVH6ixuDSia3oMrw-EeIAyeRTlVfk0rMSOfrvIXelc
    8mGvSZEuw2D9FxpxXI57_0oAAYuSA9d4teAwuOPe9EejAh6tCuN2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheejleelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtph
    htthhopehsrghgihesghhrihhmsggvrhhgrdhmvgdprhgtphhtthhopegvsghighhgvghr
    sheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhvmhgvsehlihhsth
    hsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohephhgthheslhhsthdruggvpdhr
    tghpthhtohepkhgthhesnhhvihguihgrrdgtohhmpdhrtghpthhtohephhgrrhgvsehsuh
    hsvgdruggvpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhg
X-ME-Proxy: <xmx:qKelaWzplHH2832W_V-iqk1Wkjydqod0wD7l3ZtTi2Byn9V2elWGUw>
    <xmx:qKelaeI9k_SxynOJm3vrBHbZNE5FHfBw3ALNhDiCqdo4jTzFF2m_hg>
    <xmx:qKelaVWAbUT-i66LbGaLeJt-WRN8QtXu9B0BRLFMl_Da9ugXAujp2g>
    <xmx:qKelaRZteUWGEDcRzbyC1UCXrkiZXaD_wsU1Ts9wa4sIBapfqDrhkA>
    <xmx:qKelacxvThnlK-YRD9jWS-TlHhfcz2wP5cjCAYWPAhR3Zf39esABvRod>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E5C76700069; Mon,  2 Mar 2026 10:07:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A1Akm2M3he9s
Date: Mon, 02 Mar 2026 16:06:58 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 "Chaitanya Kulkarni" <kch@nvidia.com>, "Sagi Grimberg" <sagi@grimberg.me>,
 "Christoph Hellwig" <hch@lst.de>, "Hannes Reinecke" <hare@suse.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <4b07ba4e-c5bf-4a05-8560-9660f40f8e70@app.fastmail.com>
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Subject: Re: [PATCH 00/21] nvme-auth: use crypto library for HMAC and hashing
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 2 Mar 2026, at 08:59, Eric Biggers wrote:
> This series converts the implementation of NVMe in-band authentication
> to use the crypto library instead of crypto_shash for HMAC and hashing.
>
> The result is simpler, faster, and more reliable.  Notably, it
> eliminates a lot of dynamic memory allocations, indirect calls, lookups
> in crypto_alg_list, and other API overhead.  It also uses the library's
> support for initializing HMAC contexts directly from a raw key, which is
> an optimization not accessible via crypto_shash.  Finally, a lot of the
> error handling code goes away, since the library functions just always
> succeed and return void.
>
> The last patch removes crypto/hkdf.c, as it's no longer needed.
>
> This series applies to v7.0-rc1 and is targeting the nvme tree.
>
> I've tested the TLS key derivation using the KUnit test suite added in
> this series.  I don't know how to test the other parts, but it all
> should behave the same as before.
>
> Eric Biggers (21):
>   nvme-auth: add NVME_AUTH_MAX_DIGEST_SIZE constant
>   nvme-auth: common: constify static data
>   nvme-auth: use proper argument types
>   nvme-auth: common: add KUnit tests for TLS key derivation
>   nvme-auth: rename nvme_auth_generate_key() to nvme_auth_parse_key()
>   nvme-auth: common: explicitly verify psk_len == hash_len
>   nvme-auth: common: add HMAC helper functions
>   nvme-auth: common: use crypto library in nvme_auth_transform_key()
>   nvme-auth: common: use crypto library in
>     nvme_auth_augmented_challenge()
>   nvme-auth: common: use crypto library in nvme_auth_generate_psk()
>   nvme-auth: common: use crypto library in nvme_auth_generate_digest()
>   nvme-auth: common: use crypto library in nvme_auth_derive_tls_psk()
>   nvme-auth: host: use crypto library in
>     nvme_auth_dhchap_setup_host_response()
>   nvme-auth: host: use crypto library in
>     nvme_auth_dhchap_setup_ctrl_response()
>   nvme-auth: host: remove allocation of crypto_shash
>   nvme-auth: target: remove obsolete crypto_has_shash() checks
>   nvme-auth: target: use crypto library in nvmet_auth_host_hash()
>   nvme-auth: target: use crypto library in nvmet_auth_ctrl_hash()
>   nvme-auth: common: remove nvme_auth_digest_name()
>   nvme-auth: common: remove selections of no-longer used crypto modules
>   crypto: remove HKDF library
>

For the series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>
