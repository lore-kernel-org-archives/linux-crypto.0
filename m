Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD3618CC1C;
	Sat, 15 Mar 2025 09:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029605; cv=none; b=oEaUGDCCqWDs9Mi2cZ9z9uj5o8JiBBG+673tmEGXOAbwMC2y3T+KN+rrIbr7wCTVrxdRyzbQM0poNG40ApPNZeP3YoxkMeLu1+dDmHB8BLEMU2mLgyF36bEKh7kckBoUvT8r3aU/ujblEDHo2UOE6VBx1vLLPkilxm1lNVw1Y1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029605; c=relaxed/simple;
	bh=u66njXkfutMvpeLsWeSjQjOtgaxJeedtwPikncmTt+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgsstNfOFLVOYKwgEYtcWS8MCIFPLoj6dJwOTVRWT/UO8TLi1wIBt6BrQN5eeKXfJCbq2rDCk/NieQ1OYfGzaeaqm0b/WDf+Xie8jBpeNCfafEriZJehYCws8RlYOmBGhw1cNr8NsxZ3vwnC3lGUWF1c+gXHk9js3In1lR6pbH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=d/E0WETo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="d/E0WETo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5FEsw0Btjy0ZP8yr6Bky8g/Qzyy11CMnrty2nRXI+p0=; b=d/E0WEToHX0XhhFWpBsTnZ7LrT
	NCP3b/bl3VHH982uswRrov8wtg6o0GmmbUbOlSO/04f85Dfsv2oPVk6C95znNBmLHJLk1aVGCj1Yu
	8xyO+B/bjc6bBHZRcmPdMzsgkmfs1LxIcc6s97Fx4UaBl12YNyibtliT37mPe0OD1lbC4bPg9IVPP
	WoUuhSL/bsWshIbHbg+R5TaH8GMZb8xIb0JrwxwFvs2nztuNX32zKcmRsWnCwG2EK8syJ8436CKlj
	2GFnycJ8/bdh0lJLwzQX3Ov6eDd4x6POAAb1ddFIG6QpccXggmy+tWqKvzhYf1J4mUA0lcqOEFPRV
	4p+T0fYw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNTU-006nwz-0W;
	Sat, 15 Mar 2025 17:06:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:06:32 +0800
Date: Sat, 15 Mar 2025 17:06:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: dan.j.williams@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] async_xor: Remove unused 'async_xor_val'
Message-ID: <Z9VDGGEWIpcyfFK_@gondor.apana.org.au>
References: <20240929132148.44792-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240929132148.44792-1-linux@treblig.org>

On Sun, Sep 29, 2024 at 02:21:48PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> async_xor_val has been unused since commit
> a7c224a820c3 ("md/raid5: convert to new xor compution interface")
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  crypto/async_tx/async_xor.c | 26 --------------------------
>  include/linux/async_tx.h    |  5 -----
>  2 files changed, 31 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
