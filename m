Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C321D585;
	Wed, 21 May 2025 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747827390; cv=none; b=VkPn0gOmq8o1Ub+WOBbLO2edFAVoHWBuPrVrVlePiELTYK2VKbc1n/sljxRqiWq6yxBK1EC2IsbFOsqLxLQ6cijTKh3IZKq1aVpuC2DBXjRsCrYZ28Va9o8iY4qTZd4HZirmNi8+VpZ2fcLTlUx/DlPgrs+nppWYCTBZkWdG4kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747827390; c=relaxed/simple;
	bh=xTbNpjfZN34GRRoRHO5aWamaazzkYztBSsMKGrn1dvE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=HsM7+lc8bf5ctaRMHnoAfpJhxPCIu+9f93Ln9on41weafjvxpDEb/xHWa1MNX6X5A0sUg6uKkvw67ZgmqBQ4ls2Hv3QLqEEKTy8szYRbnW+LpKdrt1ocb3RQcds6JvfpL5LdsDscYzMRTtgQn1Y5uJPS3s3gmaSAL2tt64lc5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=vfTiLOfE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Qm26I6T6; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="vfTiLOfE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Qm26I6T6"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 6A04611400F9;
	Wed, 21 May 2025 07:36:27 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Wed, 21 May 2025 07:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1747827387;
	 x=1747913787; bh=CIqSpvAb/w6MeH6RH67fY52ebgYd8rXK46WCijqn65A=; b=
	vfTiLOfE4IW0yqfJigIDkPtieD+Z62J7ROahJoOV3fbseZ7jUkYbDtIuSCEPqkuG
	+oCs6jwdHL3prGZtcjz7FFiArCeSVMo72jS6U4J/eki/TKQjL2nW2F1k1mEjX8uD
	HdqmN50HIhgxXnuE8p33LQMSrE3iYfX4/6eIsFswHfFbxHMHRkMbvSBvEdjgM8+y
	Qoh6ZOXnp8q5CWkDrHt6oWa+02Kgr8xNQSNCSjAcx5RBtvijBTVyOGICemU7ELiJ
	KwyOnzIpzhvkIZcBvVKZND0dRaDNWb+nHTiwUvptE6bzjwda0wax2YqiOX8BSJAO
	RnhG5VyMhhd7iD4Gsbcm4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1747827387; x=
	1747913787; bh=CIqSpvAb/w6MeH6RH67fY52ebgYd8rXK46WCijqn65A=; b=Q
	m26I6T6LBBO7C6YjNTdTE4YnRrssA4bKvIObFFS9nEnwZvcOqLmGcS2Y7bs6dd+6
	WRPR0AtmCfzFKMt3HHzpvHFYC88z7cTWKSvGDmXYnEGjxcw5w+M6j/lEjYAnzcRV
	mxs4inr+tHc6TfuMmSk7yJe9wHU1LgWXjxd1Jkp4OGZVqUexmfp5QCVBEQNTCggD
	axrlfpTnnqajL01h7xqhl6Ken+mj/Oe9j1f1xgtLLJQyMndVgUfFNeBFVWli0HQe
	a4pB8RvYyjy0MibHNKI9QWEWOZ4BoeMt+mhENMhst/IrXwtay6WbLtzDlai4+23J
	uhJqzcEqoyk7jks8bRN0w==
X-ME-Sender: <xms:urotaFEuekNqLsitrn6lKiIId9aYo-rtbMyuwo359I2Tu9F_aCijHg>
    <xme:urotaKWaRLl2lU9VtPgzqAoIu7au1wGwWHBNlTJYPhSdDA2k3DLL6holwe69tWkq0
    wlIRpTRerWh_cqlLbE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgddvleekucdltddurdegfedvrddttd
    dmucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgf
    nhhsuhgsshgtrhhisggvpdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttd
    enucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgj
    fhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuc
    eorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedu
    keetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdp
    nhgspghrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegtlh
    grsggsvgdrmhhonhhtjhhoihgvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepkhhlrghu
    shdrkhhuughivghlkhgrsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhhomhgrihhnrd
    hpvghrihgvrhesghhmrghilhdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhn
    ughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepsggsrhgviihilhhlohhnse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidrug
    gvvhdprhgtphhtthhopegrrhhnrghuugdrvggsrghlrghrugesshhsihdrghhouhhvrdhf
    rhdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdroh
    hrgh
X-ME-Proxy: <xmx:urotaHJuoiLvTugjsJt7qszTsX2Wvsj0CUYNtGCZ3I0Nz7YGYTujXg>
    <xmx:urotaLHeXqAIrP7KXbC1evzP4RyxPwoH2hv2IhusQ0z1Cev3Gh7j_w>
    <xmx:urotaLWb54lmDMOIFroeYrVI5uFAK3FWiINkdDX5c1tQF6LUOsGEVA>
    <xmx:urotaGOGRM9oYGiC-x-rJtcMZ59LY1gFHGxny_8RyjkkQXav2IsYkg>
    <xmx:u7otaNKUdx4VygAsSDKp3LfVXkd4eW1NGM8aXEvEKPVixVG9mFV8JztK>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C14631060061; Wed, 21 May 2025 07:36:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Te525b7ee476102fc
Date: Wed, 21 May 2025 13:36:06 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Corentin Labbe" <clabbe.montjoie@gmail.com>,
 "Klaus Kudielka" <klaus.kudielka@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
 "'bbrezillon@kernel.org'" <bbrezillon@kernel.org>,
 "EBALARD Arnaud" <Arnaud.Ebalard@ssi.gouv.fr>,
 "Romain Perier" <romain.perier@gmail.com>
Message-Id: <1024b1b7-9d58-4db4-a71a-108f6df7b623@app.fastmail.com>
In-Reply-To: <aC2p6xkMz4BtzPYH@gondor.apana.org.au>
References: <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au> <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au> <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au> <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <23fe1dec-032a-41fb-8e60-3a1b6c098c4e@app.fastmail.com>
 <aC2p6xkMz4BtzPYH@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, May 21, 2025, at 12:24, Herbert Xu wrote:
> On Wed, May 21, 2025 at 11:58:49AM +0200, Arnd Bergmann wrote:
>>
>> I did not see the entire background of the discussion, but would
>> point out that this is not supposed to work at all:
>
> We're trying to find out why this driver fails under concurrent
> load.  It works perfectly if you do one request at a time, but
> when you hit it with load coming from both CPUs, it ends up
> corrupting the data.

Ok. Which SoC exactly is this on? Armada XP or Armada 385?

> My suscipicion right now is DMA corruption.  One common thread
> seems to be that if you only use dma_map_sg it works, but if
> dma_alloc_coherent memory is used then it is corrupted (this
> isn't proven yet, it's just what the printk patch was showing).

I see. Just a few more ideas what it could be in case it's not
what you suspect:

- the SRAM gets mapped into kernel space using ioremap(), which
  on Armada 375/38x uses MT_UNCACHED rather than MT_DEVICE as
  a workaround for a possible deadlock on actual MMIO registers.
  It's possible that the SRAM should be mapped using a different
  map flag to ensure it's actually consistent. If a store is
  posted to the SRAM, it may still be in flight at the time that
  the DMA master looks at it.

- I see a lot of chaining of DMA descriptors, but no dma_wmb()
  or spinlock. A dma_wmb() or stronger (wmb, dma_mb, mb)
  is probably required between writing to a coherent descriptor
  and making it visible from another one. A spinlock is
  of course needed if you have multiple CPUs adding data
  into a shared linked list (I think this one is not shared
  but haven't confirmed that).

       Arnd
