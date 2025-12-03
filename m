Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0057A398FAA
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764800687; cv=none; b=Hdnyuml6UsV5OyWfgmSyGrUDfphroydKhWd3QjXqtKJVWqY4MB7+heIZ3/1Vfgtp6UM9vnOxMJsVfySixUWqbXnTU6duqqP49NaO31r06SStWonoTpEqwnn+g5L3ppepLkN/pSVAJjMcgd4xMcbGbhBUhaCcHRsQQrVxz6fNcYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764800687; c=relaxed/simple;
	bh=ktnjUl1ORtOk9gOfrK+aFVLH90TH53r9NeiUmEZ/ryg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=kk+7vtDrINF2lUTEAZJ+4AlC2An/s6XGAnj6mbtEvS1Dgtr0bFdXUestOLEtbWIaFSKPpeEXKZSjGTMk5gvzipBj4/TM5pfRkHSFgpzr8GLvoJxgy3TnCzB8xLNh7UMncHT64gHIyQpApQ5DdVg9i6nTLDIp66IUQ+wxf18xjfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Udoamuh5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LsiMa+YK; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Udoamuh5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LsiMa+YK"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 15758EC052D;
	Wed,  3 Dec 2025 17:24:45 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Wed, 03 Dec 2025 17:24:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764800685;
	 x=1764887085; bh=9lUTorhr9OwWAdNbxeZxEZY5ulkhpFPcF+HCN7mtdb8=; b=
	Udoamuh5YwWw82QjAl/1pt2ZgIWIlhS2ZZvCcgVKbbU4JaAQ6WwlP24dr8jX6nRQ
	aYzvPDJVuHr8G/O1w+dD8cCc0jxryH4PAihe8BQZAB4oFZ7s/WGb8NFdLiHgybpa
	iXUg6jwO7DXrTFaH+bJ5GLiF8SHhWeSlxD3qd+fu1mzE3c7HQUJY+piG2WutfjGC
	5DLpT9nZl/MTpBFN4BiNpT8Ogw2MRklMw2ZMRLWxNsD43UA1TKymXnHdimMR8pdw
	w9+O4rZMpDKXBYXKfkpaV3dyGRKj7QpiNeWQXGOwcwaylWyCBQddrPDqrJ4qZTms
	JbNcY5u3xkP+sT0Ro4cQGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764800685; x=
	1764887085; bh=9lUTorhr9OwWAdNbxeZxEZY5ulkhpFPcF+HCN7mtdb8=; b=L
	siMa+YKFGmaOxrJSnFidUGorgL5N6LUdqfBDl+guaCP5OPdOFyTk8ok0O69fVBGC
	moYdGhvlLKJMyzHiA9mNv3yFWFilT/XUgaxAjm9+twzgbf1fe+h3JpMNjJYekVyu
	ix0bcfwhBN9jZljk7MFIJ0DSt++rQSCYvLDHj0O0ZaW0PNCVq2rLVj1IfsDvBZUm
	1XrIPDWciRzh2KTrC6FywxYarESTT9+c0v5++BSaDcLUpiDTx8AXW7ZDnjXBSCqX
	CfmsYKrgA3DFF9QbMjZMpXfqtiKtvdL4MeBrByleWapNtxWVx2L6emXbVGi/+Tyc
	AK8Y9iEjT2jnAx2tv/esA==
X-ME-Sender: <xms:rLgwaVOtonl4nD5i4p7N86phzxS8g54P_MfbcxpsoHwJRTxe3HVXjg>
    <xme:rLgwaSwyD5DSNYH15AIB22GzKQd2--kLTaeyo_s9y9YBVMw3PxvT2nLQQLGeCamgy
    --fD1qSxv5mnDAgSyenR7CtAaoLwLAL6Xb1FwhUTI_Bw1V7UR7JVozI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceu
    vghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnh
    ephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguse
    grrhhnuggsrdguvgdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprh
    gtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvggsihhgghgv
    rhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:rLgwaW7tovMS7Q38nHkk0ogH1nYdprYLeArOcNF6V2SaPNO6ZoRhWg>
    <xmx:rLgwaWzSRH66rKzXaR6wDoi6iezsAYZRr9VBfGlKtCuhG4rMg3CwcA>
    <xmx:rLgwadwy_d5XBiyiEgSf1YISku3ExROc_2OQNN2wrUY4PmoSFmKxOQ>
    <xmx:rLgwaex58Z1K8S1sVT1cFiX3-0Jm-PXFCfBqDRIeMMIDW1adHFvhuw>
    <xmx:rbgwaXjhXDFr6CxEer5ye1B858OS3JaTMb1OsGD7da0-J2Iht_JKGnZY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2E65DC40054; Wed,  3 Dec 2025 17:24:44 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ANq-RbeNOoYV
Date: Wed, 03 Dec 2025 23:23:23 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ard Biesheuvel" <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Eric Biggers" <ebiggers@kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <3ba58a63-d650-419a-8956-a9b5c690a606@app.fastmail.com>
In-Reply-To: <20251203163803.157541-4-ardb@kernel.org>
References: <20251203163803.157541-4-ardb@kernel.org>
Subject: Re: [PATCH 0/2] crypto/arm64: Reduce stack bloat from scoped ksimd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Dec 3, 2025, at 17:38, Ard Biesheuvel wrote:
> Arnd reports that the new scoped ksimd changes result in excessive stack
> bloat in the XTS routines in some cases. Fix this for AES-XTS and
> SM4-XTS.
>
> Note that the offending patches went in via the libcrypto tree, so these
> changes should either go via the same route, or wait for -rc1
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>
> Ard Biesheuvel (2):
>   crypto/arm64: aes/xts - Using single ksimd scope to reduce stack bloat
>   crypto/arm64: sm4/xts: Merge ksimd scopes to reduce stack bloat

I've tested a few of the configurations that I saw issues on
and they all look good so far.

Tested-by: Arnd Bergmann <arnd@arndb.de>

I'll leave randconfig builds running with this enabled to see if anything
was missing.

     Arnd
