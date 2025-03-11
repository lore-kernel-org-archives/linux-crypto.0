Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C972566DF;
	Tue, 11 Mar 2025 12:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741696374; cv=none; b=sdSE50FZcZYvL98JMdRi5Scz5y0YsF9KImVqJAxmuowF5kgrsFZUxAM4uGakawKjjONO6uCxHMLHNr5ChNI8tmwL2P6WRrKRUbUq+NIF0ZRECaTZUyZtRu88B50m2PFLSPRKL6xb/+/s7ja6+WBRctitCbit5qOWMWCQaE5wupM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741696374; c=relaxed/simple;
	bh=fnfUwCVpxgGFnIhUtch5ji1/4WPSF8TxZw77sXyT+W0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QKXEhw2KFnLDsielmo2BeK7svkpSnFmp6Paetm4L9avSyBpXjRCIX40CI6sDj7iK/x53MOxai5gDfQp96voleQYmy1KkRUsbYWhr8t1IZbwIftmvVFjS5iP4sRMi9msnHmRkLluRVB3rHKU9WXdXM1j6eofZueFgb6Nbbc/LYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=PuR4A86a; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iSRaSERv; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="PuR4A86a";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iSRaSERv"
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 5272E1140153;
	Tue, 11 Mar 2025 08:32:50 -0400 (EDT)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-07.internal (MEProxy); Tue, 11 Mar 2025 08:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1741696370;
	 x=1741782770; bh=AHRUDiDL+udOA0j+pbNQc9o/g3Xg+29U5On+bEc2WEI=; b=
	PuR4A86a2ISknob+LndBjLNMKvP7Wv2423VT1nrr9ARvYJjGaxQVBtiLRKjRLLVc
	RC4VSu8toeGZA0AL+RgM5ohK0Oc/h2D+EslwAzHUFpsLd8ByX0LwRDiMbEOCsAkP
	BGdgdEttwqyMzWvcR6EwM4XQnAwdKcWltgKdzSAsSBrRwCStwKVfV0laqN/5Fygb
	YJEXxALluMepOYdmIreEkZhJc+xRm3L4Yk1WMPQVjnAProPpgfDphg0sQN8pTQZT
	2t0bsyiK1qACK+t7dAofor1HpnnavK/vx/ABTaTiZpPw1mu3iyYN+dyJxv9yAfiI
	tCq6QfQTosUJDD95XU4zvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1741696370; x=
	1741782770; bh=AHRUDiDL+udOA0j+pbNQc9o/g3Xg+29U5On+bEc2WEI=; b=i
	SRaSERvRIUzwuvDbNKkrrLBhjDwc8ZawxUmlu8YGWw45md73Png1zy5Fvp7/PAFe
	zQrvobhl0B08DRcrY++sCgPHtqhlEuJE5d26g2AKeXEZEv+SJm9Z14FrXOhHaZWE
	v83OJjOD+lESGutH7fo1DeZC7xDF3nyPjwUtWGW38eCMS5n87VqQT039QN7+OCqc
	ByUKBbJ0YA4acyJI5HGZveGC/WBhYFYgvnCmuuw7E3BUvKi/xiq8wf3/h0GWFvAo
	wWuC4pyT9zkZzVcr5CVV0AbwHdnPQGyvJT2boVUrYDGKYHfbyu6po4ZBkCxrYn+h
	eqVx1YZvk3GFcvuV0ofpw==
X-ME-Sender: <xms:cC3QZ5VvmQv6af1sYcTh4L2sVCSIPb852VduAnglhAiOej0LubyVkQ>
    <xme:cC3QZ5l85iX5kWWtvAVbgkSuVRfPtzYU9sUdn93_tkithsX7qDJDsSPrLjACv3yaS
    HtlHNYBkvLVK0MV6GU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduvddvvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnug
    gsrdguvgeqnecuggftrfgrthhtvghrnhepfefhheetffduvdfgieeghfejtedvkeetkeej
    feekkeelffejteevvdeghffhiefhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnuges
    rghrnhgusgdruggvpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopehsmhhuvghllhgvrhestghhrhhonhhogidruggvpdhrtghpthhtohepuggr
    vhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehhvghrsggvrhhtsehgoh
    hnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtoheprghruggssehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgt
    rhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehluhhkrghs
    seifuhhnnhgvrhdruggv
X-ME-Proxy: <xmx:cC3QZ1bbgLm91JnS19xYkrR6P8IQvD8nkfLL67KrWDqfhTo-ZLGhJQ>
    <xmx:cC3QZ8UTGM0h1qv3E9e4tgFW8VEANX2qjYO15tDNFLOmddC8b9aihQ>
    <xmx:cC3QZzkt40D7dGmwXby_7I4nxQYayu0p5O2G-ghRrAO3h7x1cyXaTQ>
    <xmx:cC3QZ5cTzlqW1toGdUTeFSNyD328KlBcWTJ762bcgxCdCTOsenCrBA>
    <xmx:ci3QZ15FFfbibcUpl4OtJIdYJjvb2Gu0ZFeNstm6CxgczfbbhVoIlhrr>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8BF532220071; Tue, 11 Mar 2025 08:32:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 11 Mar 2025 13:32:27 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Eric Biggers" <ebiggers@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, "Ard Biesheuvel" <ardb@kernel.org>,
 "Lukas Wunner" <lukas@wunner.de>, "Stephan Mueller" <smueller@chronox.de>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <684865c2-c214-4b51-9742-a56119c83e6e@app.fastmail.com>
In-Reply-To: <20250310172403.GD1701@sol.localdomain>
References: <20250310132647.3256818-1-arnd@kernel.org>
 <20250310172403.GD1701@sol.localdomain>
Subject: Re: [PATCH 1/2] crypto: fix dependencies on lib/crypto modules
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Mar 10, 2025, at 18:24, Eric Biggers wrote:
> On Mon, Mar 10, 2025 at 02:26:39PM +0100, Arnd Bergmann wrote:
>
> Looks the same as
> https://lore.kernel.org/linux-crypto/Z8UdUoaKtDKzgPph@gondor.apana.org.au/ which
> was already applied.
>

Right, I see it in today's linux-next. I should have waited a day...

     Arnd
