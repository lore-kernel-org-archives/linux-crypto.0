Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191F2241CB5;
	Thu,  3 Apr 2025 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743669361; cv=none; b=YofA7v7HSRX2MIuAl4Co6FI+jL3IODM/OTThjKPtaRLs5owo2q3zTB0z+JS7QiB/OoBMQWL7uKxZyAhJZLs6EWtf3OyN7oV8jQlJ6XvGWtloyXGkZ1j+tlazfUaoQIcDKu3x8coWMa6JEntng8C0zmNjE8LnO0hpnlAkI8tA8Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743669361; c=relaxed/simple;
	bh=RxobrwT29kSBqg5/kW1CWGwWwx1oqZ+EtUFfYtbwFxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MujpQ2hliXvQIoPoP+MyJNe7MwcGywfaiVIIbfk0Jl+Bf+P13utDtSFChOqmiSXMk0x8TyTHfIGF1LP6SBVPIgfDCOImrUtx1XCm9GAr/PKUeTgEnqq2/8+6vj6UDE/UcHHQ8aLCQoeWAbL1TNDoTY0IPQWVZOwSfARWPOIMB7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oANG7Rnd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oANG7Rnd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z1F0eUzIlzQgXKYY6D2OQdKUeDzeUwEoBj5SqqBYqg0=; b=oANG7Rnd8U/urn3pMmjOt242ni
	8Du2VvtjCJPweNzCtGREvUKP3TuKFBvKL6o/v5I4hIvdchG+cc3dyWXW4sGRHYy+0LXLLR31zoYx1
	lDP7RX5LwGzjCWGe+BI4HeKOCD/zoq2ayRJ7RCcAKY9cX8CrUOsX+uNyCOqNB7qclJDHY2Re7kUMc
	cvxSs5Vbn/HpJI3E4MgQ1uNfSY5cD2zu6yCB7qybNBU+WlOnONX+Y2bDFYBAS4ElWQO95DMAmpORA
	4Sdu3k60Zr4lg16PAKP5tDmXqhpLWJEY8S69pLPlv9JktBmxUJWEXqcLBjsApYn35VFZKjouh7r2K
	XF47ZqNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0G3F-00CQBv-0k;
	Thu, 03 Apr 2025 16:35:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 16:35:53 +0800
Date: Thu, 3 Apr 2025 16:35:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>

On Thu, Apr 03, 2025 at 01:58:47PM +0530, T Pratham wrote:
>
> I'm so sorry, for it slipped out of my mind that `u8 phash_available`
> also needs to be restored at import. It's just stores a boolean 0/1. How
> to go about handling this?

You should be able to derive that from digestcnt.  IOW if you have
previously submitted data to the hardware, then phash is available,
and vice versa.

Note that if you go down this route (which many drivers do), then
you're going to need to initialise a zero hash partial state in
the export function like this:

static int ahash_export_zero(struct ahash_request *req, void *out)
{
	HASH_FBREQ_ON_STACK(fbreq, req);
 
	return crypto_ahash_init(fbreq) ?:
	       crypto_ahash_export(fbreq, out);
}

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
