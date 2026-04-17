Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E0D2D6407;
	Fri, 17 Apr 2026 13:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776433674; cv=none; b=l1mJU5EZdt6hHt+KNQNcNt8nnV6odg8TRtiduTTZ5pNRNZzBg7M4DLPEio8ssBWwE7yJR7X9yo8fjDdjqhuhcaWshjqu3AOO8boqzFopZIhifBvSFcNtP/ZHJPNTtzm1tuj1OuUoWusAadlAlYH8Xd6EIDqWjbh8ZQ/w8ye1FyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776433674; c=relaxed/simple;
	bh=D7Kxm+c+Kl1L4t5bZvLZUW6pGXBXAdsry+FgWxQziJU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=PtvWt1J58plpN1YDgXHNnjBFchX7K52ppJwkxYkdo5NAu3bK+wJNL5STJlLOxeQDQvBhERzp3ARD4PKM9Z1fJmkR/ZxRVKXJDhKHN4jlOGDMU544URIwI1/7eN2iufJKA/c4tHATIy89vuFkdN7UkIwKMIG/k9xlUR9rl0TCkcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4uLhjjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4uLhjjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969A5C2BCB6;
	Fri, 17 Apr 2026 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776433673;
	bh=D7Kxm+c+Kl1L4t5bZvLZUW6pGXBXAdsry+FgWxQziJU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=d4uLhjjHCdZH7nxvShbp67W1kDklCiqjVO+u1Gld1W7dodFDNNuH6iMHo++08ZlOs
	 fsm+CD6fuyNoNbJ/TFhsUFqzDkG+p68q6rnO75/6Rj09aZsLTQX+oETvW+n8vw5LsI
	 EBamlm/Xoi7lw2myIfl26sAfgko3Z1+HHYStvV8aDS14bqPbhQ4rj0HzWEtz/ogxAd
	 rTuwxl43HX6lgIw3ZIcyF4lGTGxD7XhMRpwMg8jXCBtlEy11j5tmQgRJSMLxWxriav
	 MJ3D66Hcq1ZHg6fH4mZOL/zao70J4V0u31hk1F/2GfSn0ZRQi2ql/ZN0vPn8q+wbaj
	 hkqoh2vsVZaPw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 78D3DF40085;
	Fri, 17 Apr 2026 09:47:52 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 17 Apr 2026 09:47:52 -0400
X-ME-Sender: <xms:CDriaTGseH6_-ya_RNl7ZCNL-ZAsfZEG347SGPILiZ4olcg5xpqAGg>
    <xme:CDriabIq0FofYsmXv4xSXM90sKMJaHm1IF4EAY9TCGAS0fvH5kzA4bV6DvSeBfZxS
    ucl8KFUC0TmRdF_DZwHcLppG63cpSGjX702zw_dm33X8eOxaYBamso>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehtddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtth
    hopehrughunhhlrghpsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvggsihhg
    ghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmtghhvghhrggsodhhuhgrfi
    gviheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheptghorhgsvghtsehlfihnrdhnvght
    pdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqughotgesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehjrghsohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:CDriaXQCBnSlMU2VTJDAIs_tWpqI2metuE4JekL2vXp_46GQdp4rjg>
    <xmx:CDriaey6tYClPJMpzhAKH9U6hnkRmHIeg078ydSuk-7Yu92l6Q9qLA>
    <xmx:CDriaXoHoaApjXHQysL2cQtPrmf62kEHssPFmWjSvkeZk5H4kc53hg>
    <xmx:CDriaZ3bMYTOH1sDL8R6QD8kImUhbDppBr6V6jV3V15swEmOvhYaWw>
    <xmx:CDriafxRwDgZ8cOp_L2rpd7iJ0LtEcfWXkOD00Tr7_vblB-HY0Vu4P8L>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 54A2D700065; Fri, 17 Apr 2026 09:47:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 17 Apr 2026 15:47:32 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>
Message-Id: <3bda17f4-c9b0-46f1-a3bf-50337b2e91e2@app.fastmail.com>
In-Reply-To: <20260417065529.64925-1-ebiggers@kernel.org>
References: <20260417065529.64925-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/2] Improve the crypto library documentation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 17 Apr 2026, at 08:55, Eric Biggers wrote:
> While the crypto library already has a lot of kerneldoc, it's not being
> included in the HTML or PDF documentation.  Update Documentation/crypto/
> to include it, and also add a high-level overview of the library.
>
> I'd like to take this series via the libcrypto tree for 7.1.
>
> Eric Biggers (2):
>   docs: kdoc: Expand 'at_least' when creating parameter list
>   lib/crypto: docs: Add rst documentation to Documentation/crypto/
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

I think this hits the spot wrt scope and level of detail.
