Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592932309B6;
	Tue, 18 Feb 2025 08:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739867857; cv=none; b=SmAxM37Zl7iWFjG0BwQXAij06ukSnRPsemioto+Kn4sVxjfX21nV9C3iQedfO1C3UD+AR5oTVpMFb16mxB2X3yz6h5Gf4iG7yvyg/WOxA3qgquOjmZgu/MqncOXms4QWHdXSH2KZqBrzN7gfwNXiuDgU8ivcBq75JKUG3+g4Hhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739867857; c=relaxed/simple;
	bh=t8ya/t1G3whzwy4abpFTKD46+lSOSltLTjgq6opU1PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qarYSg3etBl/QrOKux7K2n6Oth1/XBpbipg9paO6+VYIoKxrRo8f4DWdwHfD8wdQL5URMGaCI+UctAJiQHwnsozhEJQ+qRc9kiz2ecvGIuFFY5tUgG+1TTptvG6Klr9HHZ4L4nikzpvRyNLpdrb+Z8zn+hI+OOAHdL+f26+lNjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=q+T8dPHM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="q+T8dPHM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZqfEr2IqxhLtqyCvqqpJalwtiPRJPsXMgYfoDKAIWO0=; b=q+T8dPHMXwBow2nZZ3CAmxWT6O
	O18UJ4HOVAaFVj6uTmPtqFfayvQxP48R+vcELEbpnepO8zt76cUDV2OCSgzeT9IgL4Po/ml23D1Lu
	K04RFcENCGOMDX9sPEzFtZzn9LGai4zjpZCX+awpzCCfL5PuOOi4gI8dOiET51uJKHST5XAGsrcaF
	GdEC9AqfzcEV08QbrBgi+wmfXKRffQpSPvrHtc53ncZtcU5807eL6tDypAK4rokdl7cp9PHzUntqv
	PwLMvw6Bdam3x3qQ7h0BR9yl/n3EfZzO8W7Fmncd1ok1SPgdK8i1iZARy6lt8QPRrhnVy1N1KJzwP
	s0x4LZpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tkItd-001BwH-2L;
	Tue, 18 Feb 2025 16:37:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Feb 2025 16:37:22 +0800
Date: Tue, 18 Feb 2025 16:37:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qat-linux@intel.com" <qat-linux@intel.com>,
	"heinzm@redhat.com" <heinzm@redhat.com>,
	Horia Geanta <horia.geanta@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <Z7RGwot_t0RLc3-F@gondor.apana.org.au>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
 <20230705201205.GA866@sol.localdomain>
 <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
 <ZKXnUeueV6ncaJM6@gondor.apana.org.au>
 <PAXPR04MB8301C112A114A6AC5A19D69B8E452@PAXPR04MB8301.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB8301C112A114A6AC5A19D69B8E452@PAXPR04MB8301.eurprd04.prod.outlook.com>

On Wed, Feb 07, 2024 at 06:22:06AM +0000, Meenakshi Aggarwal wrote:
> 
> What are your plans for this change?

I finally have a solution for you.

The answer is to use a software fallback.  As software fallbacks
do not need to allocate memory, they can be used in an OOM situation
and you fail to allocate memory in the driver with GFP_ATOMIC.

This can either be done using the existing shash interface through
SHASH_DESC_ON_STACK, or with my new hash interface where you can
use HASH_REQUEST_ON_STACK.

Once you have implemented this fallback strategy you may remove
the CRYPTO_ALG_ALLOCATES_MEMORY flag from your driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
