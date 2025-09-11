Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9EE329F31;
	Thu, 11 Sep 2025 05:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757570010; cv=none; b=Q6BZS2rzyO8J/OlJiaGKMLn6Cmx0q/BRjDyqXCkL4CCK61wGc5ebrwAyyTtIn+SDX2Hr1VN/2VsXoakCrSNrPphuugJ4kvzX2jx15SrLe7FM5vHcFsvKE3WMLQ7xsU3Vn85piSItqRZ/wYF+va1FifckONJrPj95yedOOGfBT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757570010; c=relaxed/simple;
	bh=ITWLWKy8AlUpgDZttrThcT+EgF2UV9AGs2oicq0LdsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7SLHrk4KmO+evuYhI/UgjSCDHJLsJDcdo5lSY0PZfUhs/zL8mcJShDk3t3XzQIjkQ2WQ0BSFQrC+VFGpiJYmdBPQDw6aqtd2Cr7Zexz3kpklpddk5pGDTAvpRy+NDeFfurQ7xZYQMKo9MqrM3VVnjIjxRrWOzS3webC4v7VGzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fen9NHAk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fen9NHAk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xA6ve8VcmlZCcCYbMHB7io3C2+OIbdqEs/n2Q3A3UIg=; b=fen9NHAkbEF1TH43wtuFWzmXMI
	nRb4tNlLVlrXzQGo/RTEdgErBLZZEsXRGRBPVk8WDENq+JTWwgbmmH7MZqUWJ3qpDLinVCr9IY3KQ
	907LH7ndhKRFThZ21uwxpDXYFlNbZnDplwV4ERLh5PX6O4dFYzkcudgk9oekUBhO97iLIaU6p8R5/
	KFVU2TzSRZ62qmQXjEzdWFfVtUABxoTubAbOU0NtAaxI+m3mOirBXbAi/rzFLmg8BWYpk5yqR1y90
	KEitngFF28veoWhxIYBUGP9W/5glt3K+/HZwTlrbOOU2CZbcV7C4vyfaNNMZIeJZpSa9mh4mvSVhz
	rkxQle8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uwZzX-004RX4-0m;
	Thu, 11 Sep 2025 13:53:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Sep 2025 13:53:03 +0800
Date: Thu, 11 Sep 2025 13:53:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
	Vladis Dronov <vdronov@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-modules@vger.kernel.org
Subject: Re: [RFC] crypto: support for a standalone FIPS 140 module
Message-ID: <aMJjv89vpCmxMl0F@gondor.apana.org.au>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>

On Thu, Sep 04, 2025 at 05:50:32PM +0200, Vegard Nossum wrote:
> Hi all,
> 
> This patch set adds support for building and loading a standalone FIPS
> 140 module. This is mostly useful for distributions that want to certify
> their kernel's crypto code with NIST. Please see
> Documentation/crypto/fips140.rst for more details.
> 
> I apologize for the large patch series. I could have squashed
> it down to fewer commits but it would really make it harder to see
> what's going on.

Perhaps we can divide this by layer? The public key crypto sits
on top of the Crypto API, which in turns sits on top of lib/crypto.
So it would seem natural to divide this into three parts.  The
code in lib/crypto can be converted without affecting anything on
top of it, and then the Crypto API could be converted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
