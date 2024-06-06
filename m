Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3869D1640B;
	Thu,  6 Jun 2024 02:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717639215; cv=none; b=Cgl3n4fjw6m7mQqZ0O+rb2igMm6NbYlpl2gkaHNWe4qK+VmA90/Kxb6qjXtUAXyYWDh6+GsMXeABRszqQkywpYx6sHq1DOci2juQaf6yHalGW5GAzt8yUEBUa5S43ooHuzYRjRSins6nd9o7lktyzFL8P8sV+UVasC1nbeFeHrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717639215; c=relaxed/simple;
	bh=kkvO7EElqVqextV2I737BAyQ3mN/zZQaz2lFoD4r/yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdpQH3FKzEHufjolF5SVR15mROadksCOrZH363I3+SpQE+QX1OXIbmrZBzr3DigatON6xyVOWEpP0hsYPQXbiov02XQKcm3ja8hNsahJ/y+ZMzLoEcB1/cqX7+MvkvmzYL+gB38oLyHw0noOF/ouODPDkkVevYxqt0y3cw1s6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sF2Q6-006DkZ-2b;
	Thu, 06 Jun 2024 10:00:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jun 2024 10:00:05 +0800
Date: Thu, 6 Jun 2024 10:00:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au>
 <20240605191410.GB1222@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605191410.GB1222@sol.localdomain>

On Wed, Jun 05, 2024 at 12:14:10PM -0700, Eric Biggers wrote:
> 
> This would at most apply to AH, not to ESP.  Is AH commonly used these days?

No AH is completely useless.  However, this applies perfectly to
ESP, in conjunction with authenc.  Obviously we would need to add
request linking to authenc (AEAD) as well so that it can pass it
along to sha.

BTW, does any of this interleaving apply to AES? If so we should
explore adding request linking to skcipher as well.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
