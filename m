Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE918A93F
	for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 02:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779071658; cv=none; b=AzwTg2ruBiZA8JawxyCEVbHyjlb5RX69mPgjU6wHmDsBF7dHNDiewp9oC8J+sTD2YjsUyUE3bhULdOt+9ehf1Es5crXnyZSEEuAda1jXn4PvjqOi2anceyOXMWiSc2Omjt9vdo6Mg+7WMv3wDufsPIIw9RQgPhys11//Atlwh9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779071658; c=relaxed/simple;
	bh=JSW3FE0vBfGwpz1mB/ToJVkdesMhuwCl0SKg8UTTEPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AggMLnDRy7ASKR4sJxROUGliPrBXKxjxgDFXgO3bURYX7CZU+PU22ezJuD3co4CTetJCGYwTXfZeOgX9V1YVK90/fyQ0eZZBiPBrRPzCSwW88UwO11AVt5PFpNHanOgzvHL498YWht51gsj4KXByp1me/Rymn9FvU034pLL3zjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UmqfZ1GV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UmqfZ1GV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1132c1S4IhqRdans0NG6cOj0Bru7RvZ1oD4ErLowCWw=; 
	b=UmqfZ1GV0ASpU6ZUbGhe6IaZcb8ALOqq4wPOqM/aOdai4xvIZpmtzX9MHKZOZdkZ9wBUMMXUyU5
	gApKtjrMswhxGsVlqTE4cNmuCUMsDBO+e411w0dy70PPvkvjKlDhVr5LoEkkrc6MaTAG2jRnNu20z
	xu0caujj2SYf9VxsdGHO0U5QGM1z6Slk7YtVFokBSWDMxxcpPgqYxc2l2AdDAMF6Y7PsUsehPZDal
	8jzc9bRigH7tq9uZ5DLGIStujqFrovveO3xNu8ic2VTFsH/bekuyIe9CNuRIcYSLR/pN0A9MA06gJ
	d4Nal88KnJP3URkQ1eN/2CyoikAagFQ0JMMQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wOnno-00F1DG-1l;
	Mon, 18 May 2026 10:33:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 18 May 2026 10:33:56 +0800
Date: Mon, 18 May 2026 10:33:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Scott Guo <scott_gzh@163.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Scott GUO <scottzhguo@tencent.com>
Subject: Re: [PATCH 0/2] authencesn: Refactor in-place decryption
Message-ID: <agp6lDddmDZaoH6L@gondor.apana.org.au>
References: <20260515083645.4024574-1-scott_gzh@163.com>
 <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
 <8aaa00f3-d8e0-4de0-918b-1f025b632eb9@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aaa00f3-d8e0-4de0-918b-1f025b632eb9@163.com>

On Fri, May 15, 2026 at 07:01:43PM +0800, Scott Guo wrote:
> Another thought: even with this fix, Fragnesia should still funciton. It
> just block current PoCs which pass in the page cache in the position for
> auth data.
> 
> Avoid changing the auth part would not be enough because attacker would
> still be able to link a page cache page within the cryptlen part and
> override it with the 4 bytes from sequence number.

Exactly.  The real fix is to not put read-only pages into the
destination scatterlist.

The whole point of a destination is that it will be written to.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
