Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8190D1ADC6B;
	Tue, 14 Jan 2025 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736849890; cv=none; b=ZXFl/wjS6OZUDlN9DzQ2+KDm2UhHXUIia+NHAJlxYAmWXZCRMFTpx/44xt3AEiZiZG7qawK4vX2PqQh0TWsEHvyDHv6R0aPDeCFdepa9JyelnDhsSsn4dy3lut03nhnxoBVjpJDMt7mWs3SJo5stM4pGqfV0mdCRl39ULFlzTCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736849890; c=relaxed/simple;
	bh=e/YZ7TSBPpc2KI8mUPLyvdnoN/SsoLZoUY3MifIJxlI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pWqYpHrcPLsNCyJr9jDmmPuUZgUv15ov3cjFhaH9H7x6XRRodceE6vcydufWvDMFCQqT98bzxjUe0Xpey1eeD73p6e16YZ8GLa9svCGJjDg/JvkSjdgDT1KuDeA7MnR6cFV130PKujsP0Km7SMkqAP2E3krn++KgI9ftvsCToq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=1rTAHHFo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=P1OJXwFH; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="1rTAHHFo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P1OJXwFH"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6AC5725401D2;
	Tue, 14 Jan 2025 05:18:07 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Tue, 14 Jan 2025 05:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1736849887;
	 x=1736936287; bh=RrPOcy24DWtUriH9/ruiRC8wuZz2cuney9hk5PPUmE8=; b=
	1rTAHHFo2fZsb+zXDv+W6f+tKcbsm7LbfC0PU6a5nHi5/hxurp9q32uM43xCReN8
	II/CSrfeacYZQDh446Gwg72fHGt9Nit8mmQSMFXfGjHZJ8bVBwylbuawxHzxohOQ
	SQGcjzlZQqQ8cawL1Xiv6y6y28xoZdAwY2p4Sl5sgannoYD5ghzIMaX0KzlRCKcK
	Ziz/eUw3Rilx6H5ByRjqVdlBbqnZ4b7xZioUJCy6IfJEUXwsD8W69xcW71juMvQM
	1B/pmGL9R/HbFFVvBeg9WbKG0jm6d5oFulirw5ZYqBlXARq0uRmt7+zFriug2onK
	hb5zd9uVZUE2iAsQAy42Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1736849887; x=
	1736936287; bh=RrPOcy24DWtUriH9/ruiRC8wuZz2cuney9hk5PPUmE8=; b=P
	1OJXwFHZXZ8jHqIVxv2YGOxt1ACfPCqwpEVoByC8KQQ95MiXbcplA4WAZNcRgbcS
	jtSh/GZegGjCP6+WMOsfuGauB1o9Rt7HbTGCaV3nSHifM8bzUJk5KJBzYATEgUE3
	V0WpLndCf5uZ1ZHinWG+v+hzrQdM7qBbNNwOtEitemLHboA4LXWev3v32ScIuV+4
	iwq8HXRiCmJB/EAU8hcpjWRN7kzjayveVb9WPHhsuYiF6QiTCZiD6sBdu0eRfA45
	SSlfy41NAx3+s0fkszTqfgsOAJLnr6UGAuREQvEU8S2fsW5VDOHgGv6SIjcu4JsB
	51Q8hBZF7zT01ADmpruHQ==
X-ME-Sender: <xms:3TmGZ6Dw3DPEzKo10PMlFFkfG6iUb6IvO_hLA2A4iypi5RC-Mx_8WA>
    <xme:3TmGZ0hQuHDdwFM9braoWxBVIywRMILwtN5yJjLngUnvwhZgBPH8A1V1EVW_RQT1b
    fJvTyenA_0V_Wv86bI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudehiedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddt
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefg
    gfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepuddu
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeguvghrvghkrdhkihgvrhhnrghnse
    grmhgurdgtohhmpdhrtghpthhtohepughrrghgrghnrdgtvhgvthhitgesrghmugdrtgho
    mhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtoh
    ephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthho
    pehlvggvsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrhgvghhkhheslhhinhhugi
    hfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlohhonhhgrghrtghhsehlihhs
    thhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepghhuhihinhhgghgrnhhgsehlohhonh
    hgshhonhdrtghnpdhrtghpthhtohepiihhrghoqhhunhhqihhnsehlohhonhhgshhonhdr
    tghn
X-ME-Proxy: <xmx:3TmGZ9k2WwBeZOtTgnkZhRiH38jquJl8591Pt9bAbR945r7r46ta5A>
    <xmx:3TmGZ4y8DB2cafmwuQnOM_VZn1N0_ly7eRaexDHt8aZbFSiiSfsn7A>
    <xmx:3TmGZ_TTJUV7ckr9Q2ZeKtQsMALDZiMU-hQn8Bp-KwGyoikpxmU96g>
    <xmx:3TmGZzYTX-vJEINKceHCnOp7gQnX0UKxpbbrhYr4j3ZyeZZDDfsbsw>
    <xmx:3zmGZ0JLOfUxtnyHRBp7MKJv49vyrNIb96pN1h6GKRnIfvghMg1CAmQD>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DBF702220074; Tue, 14 Jan 2025 05:18:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 14 Jan 2025 11:17:45 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Qunqin Zhao" <zhaoqunqin@loongson.cn>, "Lee Jones" <lee@kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 "derek.kiernan@amd.com" <derek.kiernan@amd.com>,
 "dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
 "Yinggang Gu" <guyinggang@loongson.cn>
Message-Id: <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
In-Reply-To: <20250114095527.23722-4-zhaoqunqin@loongson.cn>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson 6000SE SDF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
> Loongson Secure Device Function device supports the functions specified
> in "GB/T 36322-2018". This driver is only responsible for sending user
> data to SDF devices or returning SDF device data to users.

I haven't been able to find a public version of the standard, but
from the table of contents it sounds like this is a standard for
cryptographic functions that would otherwise be implemented by a
driver in drivers/crypto/ so it can use the normal abstractions
for both userspace and in-kernel users.

Is there some reason this doesn't work?

     Arnd
