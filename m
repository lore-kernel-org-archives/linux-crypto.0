Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6149031D39F;
	Sat,  7 Mar 2026 05:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861784; cv=none; b=KLbAIewX1Xd/CQE817JqkLpuzGY9t9fzzKao9AJUmH8AtX+ukva/sLSsXzzPV+HuwknEPZkEcHs9cgdkvKB4oT8Wg00bFqaKfnssqtR7a/D2EurrRV19dOk8eQY6MFktQajkTnsoEWhQwzADvlvTxNwZ47FRPZzGu7blIR/D430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861784; c=relaxed/simple;
	bh=ZdzcH+Hh6NLzLHh/lLske2GjdhK2v0tVyqzw+LG4zI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5Kufn7NvUcXKQdGiCBH9mMITsHBfwTpSXEauGPvTN/VIyiuR1Wdy3olaWZj09Ztb0IBFvXneECpJ5hL+Je6FKIvtbc2yZ22kKFA5W6zUJwGwWsCj59cOyzdxpUNwzcAWie8QEMAZmfMsvXRRoWyMtj9ePMs5haFITEFt/lWjsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TAXIO1Y+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TAXIO1Y+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=R6ep0y2VYUHIT01D4pSd67oDm1gvM+ZVt8Zp2M5Q7xM=; 
	b=TAXIO1Y+cBXI54+q/7VT+zvDmWThIkUCxN+xlkSjmhVz9XSEtwYQ5+YjfUDhxjRcFuFClr4aae1
	R+nzNfiXf+A8Xoa+r5TWpCzldyvb8TyGt3sOHnhBFa5ctRIfbINOWVxZVX/Pt26qhrJN7aP/klXbE
	AXatqrSeXPkPI7oo7P7bmTMIOSGCOtnCjq9PeKL3/9RSaqSqbYThrWHpG2zcrVjeGSByqOL9aRifT
	kLLbVpINXK18A8tPIQZVkkHhtEe+ThOtgAdBrhw+iJZ7uaLKmvRSOnpT04nFubTrI2JNRD4trv3dm
	0rWo2bWXlk3+P4a5HOm3z3ttI2jJppipS2Jw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykKi-00CJek-2U;
	Sat, 07 Mar 2026 13:36:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:36:12 +0900
Date: Sat, 7 Mar 2026 14:36:12 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - Drop redundant local variables
Message-ID: <aau5TPsW7e19ZuAb@gondor.apana.org.au>
References: <20260227115359.804976-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227115359.804976-1-thorsten.blum@linux.dev>

On Fri, Feb 27, 2026 at 12:53:56PM +0100, Thorsten Blum wrote:
> Return sysfs_emit() directly and drop 'ret' in cap_rem_show().
> 
> In cap_rem_store(), use 'ret' when calling set_param_u() instead of
> assigning it to 'val' first, and remove 'val'.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
