Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C336CE1C;
	Fri, 27 Mar 2026 03:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774582793; cv=none; b=shyml8zVl3itGzgA8ekf9Ow6E9avF5ZxfZjNxE+Bb3Pd9R1MHBHHTuu+0mQdC81GWGuGeoQGn7R9E5wC0gWqb+Ng76nPcHXPxxzwW8wDhpnspvXdOD6QUpH0/A2g4oUgYdj7A+V6Zw47IMc5IzojB/XgyoIA+Nwpcgbp9akHNX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774582793; c=relaxed/simple;
	bh=oy5o0DM18vI4VdDt0Aq9llGLV8Fz/4BqygI6EWd0Oqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDvnzjPSIu4x5lxBIOfHqEg5T7kZWhEsp+qs8AtL/wFy/D/zp22rO+R56jz3KqudiWisqazaQr450wj4g0ha8w0C3Nb3bB63m6Eu8mqvtdVG4P6U4cqqg85JIk0bsCZiyEpkcx04rR89l7m2pRr5ZZPFePa/VbwTaXgupr3THi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UIhMZeAr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UIhMZeAr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YnZo8b3bifyJM6mVuETlxCWrI9dG2rBwWudA2hagk1Q=; 
	b=UIhMZeArgnvFFdlx1zVzf2oDrm1cxDx737hNXtX++eCDb9JZ8yn4HWzON7NezxLsW0Pf5yF2Oyy
	Q2Te4nbHr0xEPeY9g5QPu6VeFUMtLRtnx87D2t9I7yXu8jwCaMTYAaOEc8P7xvAGdp9k3eSY0yvl0
	ecucHPHu/UmosfcUfTJQnWoLOrPCf/sTSoGWS8iZbkRi/Tg9GEnXDjftRcGmPRQCkLWyxP6HPxYS/
	2ttkI3Hirdeuh9RUg7Z3l9/MJ+w4D365FLDKt6SieZteCfCRKbmvEuVG7UhMS4TABG23kBBGfHzlf
	8tJy29WbHneFh+nb8DWl/CuYc3+B2gpeHihw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5xdV-001X1O-2E;
	Fri, 27 Mar 2026 11:39:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 12:39:44 +0900
Date: Fri, 27 Mar 2026 12:39:44 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herve Codina <herve.codina@bootlin.com>
Subject: Re: Need some clarification about CRYPTO_AHASH_ALG_BLOCK_ONLY
Message-ID: <acX8AA6SYYkZ4444@gondor.apana.org.au>
References: <4f93481a-a0e5-4a9f-8aae-00d3189ccc58@bootlin.com>
 <b53feadd-8246-43cf-a768-740cb73d2553@bootlin.com>
 <acTt7q5nXMBsDcxv@gondor.apana.org.au>
 <5a91d084-a1f6-4911-8592-a4f5dd3f3e13@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a91d084-a1f6-4911-8592-a4f5dd3f3e13@bootlin.com>

On Thu, Mar 26, 2026 at 10:46:26AM +0100, Paul Louvel wrote:
>
> I agree. I am currently working on the talitos crypto driver, which includes
> code to handle partial blocks. The SEC1 (currently supported by the talitos
> driver) is older hardware that only accepts data with a length that is a
> multiple of the underlying hashing algorithm's block size. Would it make
> sense for the crypto API to have a flag to handle such limitations
> automatically?

Yes it should be fairly easy to handle this if you use the BLOCK_ONLY
interface.  If you have a last partial block you could either feed
it to a software fallback, or manually generate the padding data
and feed it to the hardware with no finalisation.

The aspeed driver is an example using the second method to generate
the final block by hand.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
