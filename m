Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291F623BD1A
	for <linux-crypto@vger.kernel.org>; Sat, 16 Aug 2025 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755344684; cv=none; b=eirSEJVSeWQWVBqniY6zzKryRiHMsP40sBa+j26SAoEmgmBrgVnPnH4i/NFZgQ1fWBBLudOw/f0lzbGTc1xDenKo0syvAfOmDCdnf9qD7/B+UgJoohc5Hn/vWC/PMR/jmQmDNllzf504HLHAchedJVK6fTrjvQT5R+t8oVzYgkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755344684; c=relaxed/simple;
	bh=Zikt8hfe2LUHFiNx+TYQPgRgWGrp/+TAkRI71TzgiP0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:Subject:Content-Type; b=PXOAyL6d1q7/l+rl3qkwc0WBpjm4Y+lWxpOsXO9FnIVVT41WAjNk/AgACdZ28zuxuzu6MmLtj1WHG8A6RJSOxPRISvN81kPpLLXtnFRZLhme8Pe6XJy7UtGYdo6Aghfm4bUf1bbF2VEMt1tcYSIDjBpAm7Boa9OleNs2YwLgX3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fs88.email; spf=pass smtp.mailfrom=fs88.email; dkim=pass (2048-bit key) header.d=fs88.email header.i=@fs88.email header.b=KjaU0OmL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=I51ytY11; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fs88.email
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fs88.email
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fs88.email header.i=@fs88.email header.b="KjaU0OmL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="I51ytY11"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 122D21D00226;
	Sat, 16 Aug 2025 07:44:41 -0400 (EDT)
Received: from phl-imap-07 ([10.202.2.97])
  by phl-compute-03.internal (MEProxy); Sat, 16 Aug 2025 07:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fs88.email; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1755344680; x=1755431080; bh=Zi
	kt8hfe2LUHFiNx+TYQPgRgWGrp/+TAkRI71TzgiP0=; b=KjaU0OmLTjgQLnpF1p
	R7FCIackZn465FHvzeS7DepmG+cKjAKAWREQrHl238iE2PBdIGSeGGzU/PEmpWah
	DtK78RCg8WRz//DjCrpK0HK1PdIulNI4fd+1Eedx4ygGyM6/5fBs3oInyC42APAO
	Brg8Poaa0rEffoZFBz2Vs/3vB8UEBOA45em98QViTIp6mJmHi8wJpGBFGvZHfZV4
	Sl4M93flK/zy4VkHU+El70mX/WYK1Dp4WB26+OFgqB5PP1mUoKpF7JLM3F+zdElV
	PC3wwmUeFQpMXtqRL1BaaR1NDg1nVl4B0wWgZ/zJ3ai4fza5nLaHzDu2AIWuHmvO
	HUvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1755344680; x=1755431080; bh=Zikt8hfe2LUHFiNx+TYQPgRgWGrp
	/+TAkRI71TzgiP0=; b=I51ytY11PUFXnYd9Gr27BcHhOAcNIIPkraMPko7uMZCR
	WTqhhQAFaFAbKPBdb/yRpQnOhcLkJmUod3JlEkM3EaJ2pkgPy3L3dpb25Dk8BsKo
	FsczVOwGwxELsGubzSMtRwRSQo3BeviOpgIqMEY471ZQAiX7811wBAXMG29wjGtz
	gD0dM1h9e+KflK6/U1ae+SrO93VH7iNpPO9qclvaQIhVjkwVqNXzyBGeLDhAG3hp
	iWqdX9TJfKNcam84JpPPTmJcbJO7DZWQ2ExPUZ6wS9tLv8jIY35qN1MbRT6AiATC
	8vcqqtDuptUItBGIPGTlAXf2KhC/vS/K/hnKQRikKQ==
X-ME-Sender: <xms:KG-gaBrPh8_Z34jS1eaHQJ6Ac4Qli5Pmg8HPvmpVlluA5oe-DoJIBA>
    <xme:KG-gaDqm0iCc79cjE6LXo0dQrPPBgAxwu8qde3mW1HWf3DJk0W9FLuQqF6SVrjweB
    UkWIGP-texTM4G-vsY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeeijeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefoggffhffvvefkufgtgfesthejredtre
    dttdenucfhrhhomhepfdfhrggsihhoucfutggrtggtrggsrghrohiiiihifdcuoehlihhn
    uhigqdhkvghrnhgvlhdqhhektdhgvdefsehfshekkedrvghmrghilheqnecuggftrfgrth
    htvghrnhepueduudeuledvuddujeegjeehfffhheeivddtffduvdetveehfedugfeliedu
    jeegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehlihhnuhigqdhkvghrnhgvlhdqhhektdhg
    vdefsehfshekkedrvghmrghilhdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhg
    rdgruhdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:KG-gaNyR_BodMyGMIUK3d7hE8T8RRwg6HAtqdDYOJ3Z3YX-XyXuLAA>
    <xmx:KG-gaAjL49v_38PKEXfuNfpXqNUTyHGNPLFwEazxgy2-kbBrX0lbPQ>
    <xmx:KG-gaAwmkUzR3wtgl-y1VqEKRLrLCiAhI9rkLq_C1MmnRwCr4GqzUQ>
    <xmx:KG-gaLJ2befaWfqblZkrZovejI0UYJ9qb7hdPfzfAFNkod3NuYqOAA>
    <xmx:KG-gaEIuY7MVivQ67mJ-QA2l5djAKANmavIUznozJ08FppRbLJk09gEB>
Feedback-ID: if26e4832:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0B8F61EA0066; Sat, 16 Aug 2025 07:44:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 16 Aug 2025 12:44:18 +0100
From: "Fabio Scaccabarozzi" <linux-kernel-h80g23@fs88.email>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au
Message-Id: <0e568af0-7eb7-4b19-bba0-947e95418c56@app.fastmail.com>
Subject: Bug #220387 - 6.16.0 CFI panic at boot in crypto/zstd.c
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

I reported the bug in subject on the kernel bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=220387

Kernel 6.16.0 crashes with a CFI panic at boot in crypto/zstd.c (am compiling with Clang+thinLTO).
I bisected, did some digging and managed to produce a working patch (I'm not sure of the correctness of it).
Can you please take a look at the bug and apply/rework the patch as you see fit?

I guess this could be added to stable in 6.16.2 then (patch still applies cleanly on 6.16.1).


Thanks,
Fabio
