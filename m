Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2122147EA;
	Thu, 24 Apr 2025 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745500476; cv=none; b=Uu31ErxrxQ+bC0C4beSuJ2WqUCrSGtFqiYts5Q20lO5VBSYAYQlNK+O7VNy/lV5A9qD1JcH9foIHz8cGNJYKJvDbY7iEhUpisBl8qoicau8ceUgq9wJDjO1cJNbH9/c96yxEeiQCYhNwoKgZ1laQGQ51E1G7Cu6+bKdQHgU4EL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745500476; c=relaxed/simple;
	bh=I2i99aHi0qJAUqO/2/DJBXLUtKgmegp/TeSC0Ka4s20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2ILpYwjcnx1BRpbPMZaw9dn+ixO3aMHV2flz+0kVWmm0b3wBPH0xT7P7M6Y8yBzZk5XlhNubrvwutuFSP/8jDS2UjkcN5JyFYVKprOw02TeYUF0nn1ZjnC/xESsBzWjzKdb7OV1DS5qUvQ7hB8eZi0mT8W8PsGZcywzK0a7JIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LoaMtnCG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LoaMtnCG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jc4Dqgr1+sIg9Fxm3v/T5YH4h+0NNoZJChe61jXA3sQ=; b=LoaMtnCGdrai05xPQ9PbOztt3p
	LYy9heByDqLL8r9tMdGoE12TqVENroWoDRHRo34jcsID58LvyF2p4VMWJSpXCtzO22H7qcnI6v0BT
	D7YOkU1bYdtpiLo+Iz0KEDxKqvSwV2FnvSr57pf+AbzRAs7l2RRp3XNbmLifOcfbbetLQHpONrXjU
	N6tORE4oEvgk57WPD/rB9qjGcjqVyXu9U62gGJr4oXdqq753TrS+J1jfv8Q/bZ8M+D6IcyRGTx8Pi
	vFUUBx2CdoxY7KoePCjCS9sfHureYWB/1WYJDdEm7CgqtLx2rIjp8IGpOfxm6fm03vCdjrcN3QiGN
	nbxGqOMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7wPN-000hv9-1S;
	Thu, 24 Apr 2025 21:14:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 21:14:29 +0800
Date: Thu, 24 Apr 2025 21:14:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: all crypto selftests failed on linux-next-20250424
Message-ID: <aAo5NSAHocIiN7t-@gondor.apana.org.au>
References: <aAop_uMhxVh2l5Fy@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAop_uMhxVh2l5Fy@Red>

On Thu, Apr 24, 2025 at 02:09:34PM +0200, Corentin Labbe wrote:
>
> Example for arm
> [    0.293756] alg: self-tests for sha1 using sha1-ce failed (rc=-22)
> [    0.293762] ------------[ cut here ]------------
> [    0.293766] alg: self-tests for sha1 using sha1-ce failed (rc=-22)

Please attach the complete dmesg.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
