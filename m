Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5156205AB8;
	Mon, 23 Jun 2025 09:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670653; cv=none; b=YrrK0ZwFgzM0ltwsaLWi5fwXQtaroBgP05ybjBXi4Ywz7UQwWRKkWrBrxYJjWlO2ByHoHbWt6OWPF1C0ZWIB8zqgdJh5wnep9mClOVkm7A/5yG7/ya2ZAdOZK2SbJssX7/RBxDMvZU1vruLPsoGAVsJZFIN8D9Ti7tVDCV6aCzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670653; c=relaxed/simple;
	bh=sUYgdgNji6pFtaQGBZCPxanSgETs8enHJwPpiE3jE6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRRWNMa1n4KbN3emHI7tGq9/Em6Qxu1qLRTK9bB7kBIaxsdzCwbxqEdZQFo7jY2W4cUQ+fjBJkEOnxx6V/qhvAhXjmpmO8DjA54mN0jzR4sIH4LkmM8Ya4U45PG4Rdi1Skhuw9dOIFIhWPkgmdco7Qkjx5MBSPm3Vsxjw4UXK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=K4nsgBKf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="K4nsgBKf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LwrNG75V/Rl2Ivv7En10I994yIK+tkhnPSRKtDteLec=; b=K4nsgBKfOrmlGRy31S/+lqAybC
	9gJegLvhpjfA9K0GAkXsFJnSuMRg5D8Pfd9GEDOGtSRwIIb2t+wumH4Lhu5VZMF5f29XgeHYRO94z
	teQISOs9d+bS8g0yc2HmutZ7nD4uz22IcBEisUclHnioBAAz7lqlDOugRYnS3p2vS5gv4amiEQY/k
	2OrQ6Zrg5OoyaMotV6RceR+0E2NcYkLKUWvAmi1xB5vy9lbkI2MteWh6Mkb3qis2bT17J9Fi/YAxl
	ICpgx+nI/7nHtLHRVqW1yMJZ73nFIP+7zV36oNuuzQhrMTIYtC7a8JnYto5+KBV/81loRujtRVAl9
	cauQ7Eqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd9u-000Fdf-11;
	Mon, 23 Jun 2025 17:24:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:24:06 +0800
Date: Mon, 23 Jun 2025 17:24:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
Message-ID: <aFkdNoQFmr8-x4cu@gondor.apana.org.au>
References: <20250611101750.6839-1-AlanSong-oc@zhaoxin.com>
 <aEpgKQ1I0VDSfhO0@gondor.apana.org.au>
 <0575ec9d-a6b8-4932-a1aa-9646813957a2@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0575ec9d-a6b8-4932-a1aa-9646813957a2@zhaoxin.com>

On Mon, Jun 16, 2025 at 08:23:36PM +0800, AlanSong-oc wrote:
>
> The 128-byte buffer requirement is already included in 'descsize',
> as defined by PADLOCK_SHA_DESCSIZE. In the previous version of
> the padlock-sha driver, the 'struct sha1_state' variable and the buffer
> resided in separate memory regions. It allowed the driver to safely
> write initial hash constants into the buffer and retrieve hash results
> from buffer through memcpy() operations. Crucially, when the XSHA1
> instruction zeroed out the tail bytes of the buffer, it cannot affect
> the contents of 'struct sha1_state'. However, in the current driver
> implementation, the 'struct sha1_state' shares memory space with the
> buffer. Consequently, when the XSHA1 instruction executes, it
> inadvertently clears other members of 'struct sha1_state'. Specifically,
> when padlock_sha1_finup() is called, the 'count' member of
> 'struct sha1_state' no longer reflects the actual data length processed.
> Explain it using a graph as shown below:

Thanks for the explanation.  There is no requirement to use struct
sha1_state.  Just supply a custom version of the struct for the
shash descriptor that includes the necessary space.

IOW do the copy in the rarely used export/import functions, instead
of on every hash operation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
