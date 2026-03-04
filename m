Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D5B28488F;
	Wed,  4 Mar 2026 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629769; cv=none; b=l8koFDluEKdkp7jK86zPSv1sne7SWRj5LtqMq/vhyJDPas30xsKiYNPkGs+Tu+Kfw+sk7Rta5G35/KWlb4OSAsTHzt2HkX4ftp9bYgaZBCKUa8liz9zFrNMfIkmoAmeNdgP5lyMKKgNcxYvkosZNOn+rEs/Kz2so5YYroAgnRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629769; c=relaxed/simple;
	bh=fDFqLm1nPU1BH5jsmrmqOsPYbIxHbiqwnteWMKJpR68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pY4la2Z0eScbTOWriu7psoBzu5GHsEMtecqXW+B5oxkY85Ssl37qHYGifYDyrb5g5Eo6AI8AtOIaOTZgUh5AEduloxQkH/TQFIzd4WcUDHHruINJ7EeYthbb0KATxHf/0RQw0O14nMYkw5blgESaEJ+7ac4NLZdvFErU+dcdFW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EiFqWqMK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EiFqWqMK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=inLNF6s7jzPXaIKhV0kcRGT2D6va2Ay+1uYeLl1r+fg=; b=EiFqWqMK7BsfbFMDk0QUaeMYaa
	GfT6HtqtizS422bakpkmyn0Aztqg27IwW4FyhoQg1VWdiEW6Rk7ZrrVio++m9/Gn73x7oXfXPek1b
	rqIBQAHqn3R4aheoao58W48/y2JeppyBTmktoNbBUtfO47qeq6Y9a03Hyq2esSa3ChmJUn862OrHl
	EjJwBJwrKQAdX5x5lvpnlS3iuAZdxJkdckSWjecvYtX4zbvYgRfe+MK5DW3mET7d58HgAtpVFIeYz
	JvkhHkMLU3oMk+WCjhs9In+uq3nDeoh9bzKy5cTuMIA+0cyctHPNTrl+0lxNSFMqC65vO0k7gQhNH
	V9p/CX8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlyf-0000000HE1n-0n19;
	Wed, 04 Mar 2026 13:09:25 +0000
Date: Wed, 4 Mar 2026 05:09:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Joachim Vandersmissen <git@jvdsn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
Message-ID: <aagvBY-XMfPIqkDO@infradead.org>
References: <20260303060509.246038-1-git@jvdsn.com>
 <aab5ptuamQ7d_tTi@infradead.org>
 <20260303193102.GA2846@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303193102.GA2846@sol>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 11:31:02AM -0800, Eric Biggers wrote:
> > It sounds like xxhash should be removed the crypto API entirely.
> > There's no user of it, it's not crypto, and doing xxhash through
> > the userspace crypto API socket is so stupid that I doubt anyone
> > attempted it.
> 
> dm-integrity, which uses crypto_shash and accepts arbitrary hash
> algorithm strings from userspace, might be relying on "xxhash64" being
> supported in crypto_shash.  The integritysetup man page specifically
> mentions xxhash64:

Oh, ok.  So at least for now we need it, although it would be nice to
convert dm-integrity to lib/crypto/ and limit it to the advertised
algorithms (including xxhash).

