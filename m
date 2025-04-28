Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEAF1482F5;
	Mon, 28 Apr 2025 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745859323; cv=none; b=n16oJ0TG6GUv4g4nTw8VYZsV7C3E2SG9FCCwyPy3i/4yiLJLN2cHWspTbJqI9LyhSrkU0MHX2MB3U7CUPwqfEhOLxmXst6fOckn2AOTcIIbt8xwg2zUC7XAtdWehb6A9HglMMBpmwaXM9s/CKCNokDYLaduzCjw/aDlEcixJTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745859323; c=relaxed/simple;
	bh=909YTyXnv+FioI1QDqKx9WUhjHyfQliVMmccJ4PLsC4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=i6mE1JRl/Iss/yASFb9zIPWML/YVh8709nhI5E2E/j8KOLKLIJAgLV5UnxiY5ODrTopdWzdiTt9Ts5TvCx/tlmMnXQ6AHYg00ncFF7npUxohMfil++uJNkXuayDlSMjZc7OT4wS1PQ/3W7fTc8fbp0+FSgSntf8OTh9d2KeKpMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPyM51yB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPyM51yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E41DC4AF0B;
	Mon, 28 Apr 2025 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745859322;
	bh=909YTyXnv+FioI1QDqKx9WUhjHyfQliVMmccJ4PLsC4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=qPyM51yBk/wLich3f0V5zruVWxY6/7VddDdNqctsPtzRucnNtO6i9oXDX8nHc4W3i
	 1Y6zS1K0Aurvj0XG21jmTV3CfiWceqbf93WuInlh3Q7jBKq7jtyY59cl3DH/1h3p/i
	 mB2ACPD4pzfsWromsnNYb6vLbg7c5ABGigKGCx7tM0P+NU2RyQ3nyJdJv/2G6cIxcv
	 4bw+5kucVVBMMQ3Co61GhHCg3AGTH+PRsNSDh2MBrZ7Oqzgk58yu906kWP4GS4dyKj
	 AomGfB3O2egvhz+HIir+NXGK90Nt1uurXRDXzQPBorrJk5B2sTwhU0RU4ToiY63hzi
	 Dtx4ObLk/h6NQ==
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 95DED1200068;
	Mon, 28 Apr 2025 12:55:21 -0400 (EDT)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-05.internal (MEProxy); Mon, 28 Apr 2025 12:55:21 -0400
X-ME-Sender: <xms:-bIPaJFfoTc3-fnYmenkKEm9nE2RrhPtbpd0ouTFIi7U1gTqps6zyA>
    <xme:-bIPaOUSNMvsGvq_CY58CneLJhWJP_Vf_zlWLkisMSymsp8pG4mw3eInbWs8KSMkB
    zckAzRqJhOYqjSZhW4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddviedugeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusehkvghrnh
    gvlhdrohhrgheqnecuggftrfgrthhtvghrnhepjeejffetteefteekieejudeguedvgfef
    feeitdduieekgeegfeekhfduhfelhfevnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomheprghrnhguodhmvghsmhhtphgruhhthhhpvghrshhonhgr
    lhhithihqdduvdekhedujedtvdegqddvkeejtddtvdeigedqrghrnhgupeepkhgvrhhnvg
    hlrdhorhhgsegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    gvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghr
    hihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:-bIPaLIhoka83JZd-SEt_n9LbI-A-ZThyyEw0ua9QBchxLoJJdeCIA>
    <xmx:-bIPaPGwSW6k2jVQjv04L1M1I0FQuPWJNZ3Wy6X6-JCQF58rinuXkg>
    <xmx:-bIPaPWgyILoVeOSY23ZiqmQO31steDkfUBdZ-Ww87UeYjvekPyltQ>
    <xmx:-bIPaKNCy0gufKz8FwVq_nipjY1aMaf0sFgV4YxndhHPMLaup1xvCg>
    <xmx:-bIPaO1iS9cw2AnYuVXid3iXdvAAeTkBBpTAB-4Q1znQ26iWHqm5zIaN>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 70AA42220073; Mon, 28 Apr 2025 12:55:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Ta8fa89f94a212a52
Date: Mon, 28 Apr 2025 18:55:01 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, "Ard Biesheuvel" <ardb@kernel.org>
Message-Id: <35c777f9-9767-48cf-acdb-9b47789f6c8b@app.fastmail.com>
In-Reply-To: <20250428162458.29732-1-ebiggers@kernel.org>
References: <20250428162458.29732-1-ebiggers@kernel.org>
Subject: Re: [PATCH v2] crypto: crc32 - remove "generic" from file and module names
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Apr 28, 2025, at 18:24, Eric Biggers wrote:
>
> We could instead rename the library module to libcrc32.ko.  However,
> while lib/crypto/ uses that convention, the rest of lib/ doesn't.  Since
> the library API is the primary API for CRC-32, I'd like to keep the
> unsuffixed name for it and make the Crypto API modules use a suffix.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
