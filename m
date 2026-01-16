Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434601548C;
	Fri, 16 Jan 2026 02:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768530625; cv=none; b=cZZgiirSY80JIX1VCG5SFi530GTccT6xNQMzbSHXBncxS26BcIvQWhaj7ZFHhsDajuX9ls63SgdH0zUgIV+BcfOZ/7bzvFj1vv4IN5vokJoxG2POP/DVQDodZhMuWvJdKHbKLe7R/pksJECskhyF+BYIzX08IBLjxkgDBkWsoUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768530625; c=relaxed/simple;
	bh=ffv7g16iO9m8UHX0RTA4uXKz6o/2qcq4Jy0yQyafcKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvEAMGCO25DMEddlBznZxd9Fre69AEakgnpHJwIjcBBkEhXR42B5tHx9PuYr6wF1tE1V9s0fno2FyxVmnWhNToZCp8DWXcg8FXDVPPDoAXo4tn9jwKTjmlt/Y50oNpybtw6+KlI+uPwUJMlQSoxI1f9vEd4TCyiIdtiId1JHIvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bPkPPIdE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bPkPPIdE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1co2DSI7IDkF2hLIPTUYj9KgEg5ywlQ2PtakaHKd1jY=; 
	b=bPkPPIdE+602gYmio3hdhcd9POegg9H08kwz/ri38RjHxoCDsAZGiLmDNY0TAMVfs8CF3CswpYv
	U2SNMIbDVEeKgWT+0JbJs5fLgwJfDT+1/3zkWWRrcZwb8GBdcNjnLzEoOHMM91e3NuxqisrcyVsim
	VF7k+tmjFJfXCNdW+JGzFLnXxp3klX8r9N8LyzQiyCmLzZBmlNrqV7lOqQ0tCuhMYdO3OVP9RLcLt
	oMGkPsoxU90gVaZ/VgSXU+eV25pXU2PDg7w90fZ+kuxF/lNit42xeNp8QjSQjKwpY0lQlvIRmYrfl
	s+g2cbVa76IqbXGfeagJFzTn8WtsBeBt4lew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vgZbF-00HBTO-1C;
	Fri, 16 Jan 2026 10:30:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jan 2026 10:30:09 +0800
Date: Fri, 16 Jan 2026 10:30:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Manorit Chawdhry <m-chawdhry@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>
Subject: Re: [BUG] crypto: tcrypt - data corruption in ahash tests with
 CRYPTO_AHASH_ALG_BLOCK_ONLY
Message-ID: <aWmisYTEC07wOO2i@gondor.apana.org.au>
References: <70710115-6bde-465b-91f2-a005bede1602@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70710115-6bde-465b-91f2-a005bede1602@ti.com>

On Thu, Jan 15, 2026 at 03:38:50PM +0530, T Pratham wrote:
>
> However, in tcrypt, the wait struct is accessed as below:
> 
> crypto/tcrypt.c:
> static inline int do_one_ahash_op(struct ahash_request *req, int ret)
> {
> 	struct crypto_wait *wait = req->base.data;

This is just broken.  Even before the partial hash block handling
there are code paths where req->base.data will be modified prior
to final return.  That's why the completion function takes a void *
instead of just passing the request back.

So we should fix tcrypt to not do this crazy thing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
