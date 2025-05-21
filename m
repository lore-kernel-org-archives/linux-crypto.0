Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0A259C8A;
	Wed, 21 May 2025 09:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747821553; cv=none; b=RT/0g6wSmtcOgOrOkIqy9qjMy32jZZ/JKNnAukgQjBzkVsE7eMZjmlCPcRbnr+DZ0iGi221w6jj5aXbrFqzkffWiksnAZ8ocXGoWPFcSpMruLO3zAaevIfG8560bXF+fBqHvtoajRe7SvgtvoNB9GowrFGkwuzPcZE5DBtL8Ldw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747821553; c=relaxed/simple;
	bh=jyde3s06VgWD57m+zrKKNTq7N69GZF6igxybPwDzLuM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Z9ksHl/NxPbewnXujfM/tSl7sEO8IPCzCkVvyw2OELFIhPuvqA8jAtYz2IpzuCA/lF0SPy7x7kk0z3VTjHx4VVuD3hflnKAyIRhUJY+MLr47iecCIeKgxydPKwPrSIemtUis75N53q2/vJwYwan9M9HBpx2b+gKeuNkjTmZ50AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Inx+yu0S; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K7zxLBvy; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Inx+yu0S";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K7zxLBvy"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 002E91140105;
	Wed, 21 May 2025 05:59:09 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Wed, 21 May 2025 05:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1747821549;
	 x=1747907949; bh=UG/KB3NNoq9MP0crX6HplYzYM7rr5Mg7jq5FkZGA3rI=; b=
	Inx+yu0S2ZWpx4eUBp5vOrSvTJC1e/f1yyzw0NsKAPeovc8VXWz+Do4oXhgVE5ub
	79pWQZEksGrKeYqNyBonE8dhikPDLKxrU+evGY7IHudQ78Q6Nq7Ksoxu65GoQXbW
	n32mQjbm0XdK1c8VciL7u/H7KftwKIz4zlhUiIhg0EEHpx+GXrliKHYWWXYESBTL
	pWorO9fg2B0+iImNUlfKc8WJNZJDGjSdXXOO1hTjYun8+5qA/DY6ChrCGdem/8W8
	guaYZ6eL490xcx5E+UjSIJM2Ax0MS08kKRJKfXJNEBlWXb2+BTkwMAbdln/gHwfO
	dILUiOWLCNB8noyGqrlFrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1747821549; x=
	1747907949; bh=UG/KB3NNoq9MP0crX6HplYzYM7rr5Mg7jq5FkZGA3rI=; b=K
	7zxLBvyKDedkAOY285f7Q2z3U6oGgmuEBbx3kMKTxzj0LXWdKoB4+cELyYbecXDC
	3McCpksyhK3wJOkcz6CJqlOkjHA92tKSagSKWVp3pq/JJ+MFscLXoAB8Nfni55o+
	m9UyhcYqAtGEnBb0IfE940qe8yVDViXDgzNcBN1VCOO+ilsDNxz3nOcaHYZucUkJ
	VOR2woCnKnEkAvFkYL2ZvRbIFjqdbjQuIUXXc2T5GXeRkgIWOAYTz6ws8ffyW4kg
	AOevrBNu04I0r04MciM9Q0gZ4V6GCuxqWzVg1RwB0OQDSEyCiU8poa6A2cVXTuX8
	2Vgb8nytFYr4jr/mh7ZWQ==
X-ME-Sender: <xms:7aMtaBp0nD-RLEaWlWsCK9RZFaIYLSQrKBwI7lFhduKPsBmREdEhkw>
    <xme:7aMtaDrn2oGtV2cseM1WFQI7J7OJTxIxOMuALGlWhTQMdp3_bddF_o3C1qPq5RLuR
    _XXj4srrAogZRCP3LE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgddvjeelucdltddurdegfedvrddttd
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
X-ME-Proxy: <xmx:7aMtaOPnymJwr2wpHDQBRC2x00CqWYtX1tOxVtHCduQhb_E7VTCkbA>
    <xmx:7aMtaM4Z4kCExLARjAi-Rn6HCkLv5-02xbhywcrh5AzLr84C_9lyew>
    <xmx:7aMtaA7Vn20AkyEdA3qGVfL32iq4UtV7zYAOXTvqccKHmO_DGe43qw>
    <xmx:7aMtaEjnRlRMwiqVICwObW7AlaGVknelLuUY2XPWM0Rxjq3yPViJdg>
    <xmx:7aMtaFL5dipbM-UeosY6-ZKq1UvjcII7wbvSSK8denLrbK3DoTvvLpNn>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 63F6B1060060; Wed, 21 May 2025 05:59:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Te525b7ee476102fc
Date: Wed, 21 May 2025 11:58:49 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Corentin Labbe" <clabbe.montjoie@gmail.com>
Cc: "Klaus Kudielka" <klaus.kudielka@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
 "'bbrezillon@kernel.org'" <bbrezillon@kernel.org>,
 "EBALARD Arnaud" <Arnaud.Ebalard@ssi.gouv.fr>,
 "Romain Perier" <romain.perier@gmail.com>
Message-Id: <23fe1dec-032a-41fb-8e60-3a1b6c098c4e@app.fastmail.com>
In-Reply-To: <aC2aAvX07Aaho08d@gondor.apana.org.au>
References: <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au> <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au> <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au> <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, May 21, 2025, at 11:16, Herbert Xu wrote:
> On Wed, May 21, 2025 at 01:06:43PM +0800, Herbert Xu wrote:
>>
>> Can you please try this patch to see if it makes a difference?
>
> Actually, please try this one instead.
>

> 
>  	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
> +	arch_sync_dma_for_device(ahashdreq->cache_dma, creq->cache_ptr, 
> DMA_TO_DEVICE);
> 
>  	return mv_cesa_dma_add_data_transfer(chain,
>  					     CESA_SA_DATA_SRAM_OFFSET,


I did not see the entire background of the discussion, but would
point out that this is not supposed to work at all:

- arch_sync_dma_for_device() is not callable from drivers,
  on a streaming mapping one would instead have to call
  dma_sync_single_for_device() with the correct device.

- in the mainline kernel, the memory comes from a coherent
  dma pool, and the devices that the driver binds (Marvell
  Armada 32-bit) do not have cache-coherent DMA, so the
  buffer itself is in an uncached page and you must never
  do cache management operations on it.

If the allocation is changed from a coherent dma pool to
a dma_alloc_noncoherent() call, then the
dma_sync_single_for_device() would indeed be the correct
interface for passing the buffer to the device, but for
a coherent buffer, a simple 'dma_wmb()' as you suggested
earlier would be the right interface.

Depending on the size of the data, the streaming mapping
would likely be significantly faster than the coherent
dma pool object.

      Arnd
