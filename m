Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9835113C69B
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717754343; cv=none; b=lXcus3NMj9YQU8h5eH2+xL5QNSwCG9pfmw8s/GWrNcsawhsKkeDdKeI15J3Ghh5JjLGFKTI2pZUvhcCw4KLiFcawzoqkcEzSCqpBEnlVJi4OejJxSiWeFlITMf2WmJrFjcsGPF+ojZRSC52Iv9YnAAQlC87SmQRRA8z5VPehlK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717754343; c=relaxed/simple;
	bh=C1pEbPP4W4ZSHPVd4+MD2fQrekaKBtHEPPY8yuL4pLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxUoYXIXuDGvqodMJYGmmdBqFx0qiwuOg4GFQFbGXZn6Q76ABiPcVW6FptjCQ9cA5eyB1yQ6ZlWLK1kW6T8FKADeOplXR92I7W2Cp0r4ss5MzjxBi9SChwxfnnI6Erj/CUYZbzgMT60AHR8C+0Bl10IlsGE6wkj4mAo9qLLA0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFWMx-006mV5-14;
	Fri, 07 Jun 2024 17:58:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 17:58:49 +0800
Date: Fri, 7 Jun 2024 17:58:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, vigneshr@ti.com,
	j-choudhary@ti.com
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
Message-ID: <ZmLZ2Zl8HUQc0jST@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
 <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <ZmEYiw_IgbC-ksoJ@gondor.apana.org.au>
 <875xum9t2a.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xum9t2a.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>

On Thu, Jun 06, 2024 at 05:33:41PM +0530, Kamlesh Gurudasani wrote:
>
> Also, the size that can be held by one sg list [0] is 204 entries,
> which can hold upto 800KB of data. I'm not sure if this is still true.
> Old article. If we consider chaining we can have more data, not sure how
> HW handles that.

If it's the SG list size that's limiting you then we should look
into allowing bigger SG lists for af_alg to be constructed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
