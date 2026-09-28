Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74BD304976;
	Mon, 28 Sep 2026 05:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572387; cv=none; b=J/RJn14Tile9VXqz/ngzgNdpjKthHSJug15YSHhUTJLHgZKqugCu1Bpp+gM0BcCJGj8kUxHIe2VBLZwevHmwZCtWktRI2hFhokRWLWMDUWq8cOjzYvMeAiUdrD4bcrUwZIyvzAeDnzFzGJ15A0dUUh98Qany9ThYCWnoc5lqrEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572387; c=relaxed/simple;
	bh=ddjb+wjuvi1cOlP8e3yNBP7QmK6wSnxRalRF9qu2HR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGL73fcNWlZYdfiaRKYo0QT+3kgNJLxiTSoCTu8Z/z8ekecCZ+wLrhAYBrxlztnFB4DJG92XX52Iwgm6ydt27RfdH78BMjQX2Ao3b8WMRIuE1cQJ/Uor/ROlo43vjIx82Oe3mBrppQQH1G2mXWNxlO6f8vCUXjvAuTtr7NppYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rhKwLiz4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rhKwLiz4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=l4S3cZQ27xJ/MCj4M6F8Mpv2fXrMlqYJXkc2iABTX0w=; 
	b=rhKwLiz4sKZZusau9LVVQM/+91+ioCBjxfz8ZrHTblLR3yCkA96T3oRqeTaW9Fl4EIA52ppIngF
	LI1i1IEnTcePxI3MzomlDhqW8uimSbUjvwPnZaZXyAxg/zLt+hSr36neodVPUkp+r0dSFySF+ItAB
	FEOG7p5nkc83y1SEDmtw6R56Dp68b7tAsu6IwRVRqCRBmebk5VdC3YFqSzB2NOshNaUABdPE+AkPf
	X4b3Bmy/aFZjgnxWym9VZpGJXrKBafyXxMiej/LaINeKfL7uT3clva/Zg32CmEVNzaQAbtItARZFQ
	XDBq3d2otVr7Sgkbi4y/1yJ2Mt32iHMyoz8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xB3fV-00000000w3f-0AyE;
	Mon, 28 Sep 2026 13:12:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Sep 2026 15:12:48 +1000
Date: Mon, 28 Sep 2026 15:12:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Lici <ralf@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with
 accurate DMA directions
Message-ID: <arn3UFsriRlGMXwB@gondor.apana.org.au>
References: <arOOmSnC1NxvG1nw@gondor.apana.org.au>
 <20260923091318.194633-1-ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923091318.194633-1-ralf@mandelbit.com>

On Wed, Sep 23, 2026 at 11:13:17AM +0200, Ralf Lici wrote:
>
> There is no caller to identify for that particular single-entry layout,
> it was only a hypothetical example in response to your question. Even
> for out-of-place AEAD, the destination starts with space reserved for
> the associated data (as documented in the comment at the top of
> include/crypto/aead.h). A single linear destination entry can therefore
> contain both that reserved prefix, which the device does not write, and
> the ciphertext and tag, which it does write. Because the DMA direction
> applies to the whole entry, such a mixed entry is mapped
> DMA_BIDIRECTIONAL.

So why is it a problem if the dst SG list entries aren't pointing
to memory that's also occupied by the SG list entries?

Even if the hardware doesn't write to the data, it should be OK to
map them.

The only issue that I can see is if the same memory is present in
both the src SG list and the dst SG list, but that is expressly
forbidden for out-of-place operations, and indeed would be a grave
security issue.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
