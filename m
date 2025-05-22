Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1886DF58;
	Thu, 22 May 2025 03:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747883644; cv=none; b=rgJlBX3u5HiiJTyqL6sO1Txye/b7Ojd14O+uwZriq2coCPDQmCG9TgdKgVtDFLK7bmVSZYWsgVaBudgka8magwkzShSqtTJRgE1gA5i1fHtNGnYf5z3XX1fx4nnbrwQwTTesUuSq34+17gyApfAcftJEFQSrwOXL7cFDoueRcEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747883644; c=relaxed/simple;
	bh=wiT1vr9uF2pjY3S1MwJnyp5i3k/Wihi0DO7LrevA+aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZ6AUlKFaeVGjElfxiTH6MdC+lkO3jKf0DIHUIl4DwsIJpjAPwkUe1p9oU6y4ey3v3wUWgEWQvAPT5hkTPVYyOA3nSVoPDK/fGE4du45eXZD1yDw5PQSggrieSCNPu6n0GQNHyW4Jc7U9uGISddItV/Am1giPsrTwatjoNDTYaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NExLDvSx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NExLDvSx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1iz/dspRKGJfames/a2O7Pg1SnBVWfkpTF65gemphXY=; b=NExLDvSxb1qc8PL4JvKo1XZ1la
	CAb8bkNQsxxXF1HlmIOsTK4uHmeqz2WkUgDOjMqtPNRvV7LLTWFkF7GvblqJkyNS4fbqeIah2LGSC
	+LEIo0rcSiui9no3MS+90HlMah1PjD9HqolOS2vFFuSBqsz/tWenHukCC6wFuWnU+Z1SWKDoGBIDx
	9p5uO1LVE4H2dx+zHwHdrRo1vPD+B9CXvJcmb7olF7Jc641nLNSQ1M+guqpI0Zwbk5acBwY8d8EuR
	Ton8Im7y4V/OWfzVAn08B+buzOomnbm1k1TCD/k/Vd6UnO8K/B15E7xjY0TgGZ38IiCDdU0B6Ldah
	ebuLvYZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHwNY-007yxj-2z;
	Thu, 22 May 2025 11:13:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 11:13:56 +0800
Date: Thu, 22 May 2025 11:13:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"'bbrezillon@kernel.org'" <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aC6WdO4E6ugCm42K@gondor.apana.org.au>
References: <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <23fe1dec-032a-41fb-8e60-3a1b6c098c4e@app.fastmail.com>
 <aC2p6xkMz4BtzPYH@gondor.apana.org.au>
 <1024b1b7-9d58-4db4-a71a-108f6df7b623@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1024b1b7-9d58-4db4-a71a-108f6df7b623@app.fastmail.com>

On Wed, May 21, 2025 at 01:36:06PM +0200, Arnd Bergmann wrote:
>
> Ok. Which SoC exactly is this on? Armada XP or Armada 385?

I have no idea :) Corentin, can you tell Arnd what you're using
for the tests?

> I see. Just a few more ideas what it could be in case it's not
> what you suspect:

It appears to be proven now.  After replacing the coherent memroy
with kmalloc + dma_map_single, it actually works reliably to pass
all the crypto fuzz tests (hmac is still failing but I think that's
a different issue).

Maybe I'm misreading the code, but I thought that dma_map_single on
this machine should actually be a no-op because the device is marked
as coherent? Arnd, Christophe?

But it's clearly making a difference.  My suspicion arose because
the fully linear hash digests where all data came from the user
were never failing.  It was only failing when some of the data was
coming from the bounce buffer within the driver.  That bounce buffer
was setup with dma_map_pool (each being 64 bytes long).

> - the SRAM gets mapped into kernel space using ioremap(), which
>   on Armada 375/38x uses MT_UNCACHED rather than MT_DEVICE as
>   a workaround for a possible deadlock on actual MMIO registers.
>   It's possible that the SRAM should be mapped using a different
>   map flag to ensure it's actually consistent. If a store is
>   posted to the SRAM, it may still be in flight at the time that
>   the DMA master looks at it.

AFAICS we're not touching the SRAM directly.  Everything is mediated
with the tdma unit on the cesa device.  So the cesa tdma unit is
copying the data to and from the SRAM with DMA.

> - I see a lot of chaining of DMA descriptors, but no dma_wmb()
>   or spinlock. A dma_wmb() or stronger (wmb, dma_mb, mb)
>   is probably required between writing to a coherent descriptor
>   and making it visible from another one. A spinlock is
>   of course needed if you have multiple CPUs adding data
>   into a shared linked list (I think this one is not shared
>   but haven't confirmed that).

Yes that chaining is definitely broken.  However, I don't think
it's causing the corruption.  We've already tried disabling the
chaining and it makes no difference whatsoever.

In any case the tip of cryptodev now disables the broken chaining
so it should no longer be an issue going forward.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
