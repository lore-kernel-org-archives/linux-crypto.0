Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1AD18E1A;
	Sat,  5 Apr 2025 01:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743816793; cv=none; b=kv1QEoII/mnT5Gm5BZMUg0gfi1vAg9w4K4yMrDsw2xKcm+NhtPoVGJcN34jtOOMVGnl11bfI4/ZMce99hOzP2qp+RZ4YUBxY/MbnwrRkEuR5cQ9JWEMOia8UyTeMddqa9pvLkx/qbcQJMCtqFNeHYwr+oFYsxei4807mER+aOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743816793; c=relaxed/simple;
	bh=2eEUfZrQmONh2+QkgYFkGtRKBRksWrPkTA9DvTBAReY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INFoVMibJG52+oac/0FG67ulfkKCKCOclAbw7UBPkjMOfb0ekUa+blrSwYa6dAtBwuUCOWlLC46ZUisDaWyc8VbjaZupLA2NvqSfCYPmKr40UAcMpHezoYG46B+D6PwppoUTPaBbrtVxC1l3xliFtPM9Aoj10NKDUWB/4j5Gp1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TFeJWOyu; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TFeJWOyu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4XLol8aNEJ1m7Sxu1W+BTllvM4H67xotQ2IX5pXjh9A=; b=TFeJWOyu4VttF5izfpzqSDalKa
	UkSFnAfTIzbAMJUJZwN0kqvkPp+q47N7utj5dYnLu/6vctPYxJkH4lWVm1CSEGnqlPPpuucX2wicD
	cPc6Z2HL9ndl8PY5Hj4cyjjD+LAps5ptA8sFkxcAxn+fetfLqrsohGP2efNNVocaeocDXg8Ls1S74
	mucfIEx9yPevuxyZ/nIbtuIWEg/AtMreuu696nxolllqkMX5tLOPI6nXiHbFQrc5ZPigEGZYFsiFn
	tDtRSzxQN/eZxiufX06TF5xxYpN3WOApxaf9dlcPCwybTIBp7uY0I+6PaVOa/i7fsNb337PNp4RNq
	e5PMLkOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0sPB-00CxSp-1D;
	Sat, 05 Apr 2025 09:33:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Apr 2025 09:33:05 +0800
Date: Sat, 5 Apr 2025 09:33:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z_CIUXS-YfiRJxi5@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
 <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
 <8aa65022-8adc-4c4a-a812-11bfd64e628c@ti.com>
 <Z--zFB8Rm007AMzP@gondor.apana.org.au>
 <8536cdf7-f4bd-4f9a-9eaf-9e38fba67741@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8536cdf7-f4bd-4f9a-9eaf-9e38fba67741@ti.com>

On Fri, Apr 04, 2025 at 06:10:23PM +0530, T Pratham wrote:
>
> Our hardware can accept data as multiple packets, each of which can be
> of any length. The only restriction it has is that only the last packet
> can have arbitrary length, rest have to be a multiple of BLOCK_SIZE. The
> hardware needs a bit to be set to indicate that the packet to be
> submitted is the last data packet.

This is not unique either.  Even the software implementation has
to deal with this.

This needs to be dealt with in your update function.  Simply buffer
leftover data and only feed whole blocks to the hardware, until
fina/finup is called.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
