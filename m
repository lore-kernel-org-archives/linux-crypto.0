Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF81C4078D3;
	Wed, 23 Sep 2026 08:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153304; cv=none; b=K7fhy8hf/vxCyYrHqKy3xYguJ6giwfQzams7uAuiUsouMrUyAGO+DYdDN1gDY4708eu1KgECNSPauQDHUggnymPDBVviFr3v0/wPH/IS/Phr5wOL/+zS1VD4g69TTJyF7jEJwmveY6tbHQk8cW9A2UM++v50pTw4Gd0PAzK3APE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153304; c=relaxed/simple;
	bh=MQpkX3Snh5VHVGcZLB1eCmxYLpt6FlppdcuYDw3YjvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WN7ySt1dp5zID1axTDO9UN3ZQvKtbHT00m46VWtpJJCBSX5ff8YeRpzJyk/7sOnLDXr26/tHYms5rpSXWyAhnrSm48Yq+epqULubMO7irbo5hF5hU/HXra8SaJp86yw9N+7ACey3U2AfYf/pYKc8GNG3/Qkvsiat8H4SDJMK30g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LqFrMxqz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LqFrMxqz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DKwHpNfD+fFL3JytQZJq2OXObw0NMpBCMGz3UBEDPyE=; 
	b=LqFrMxqzP3pav1+ceQtnVoGnrLxW9IgtZ0Us0jw/Th2tyvTjC9h15uh4N97B7uOuZfP3rPmI+bK
	sB0W0XiyaVHGFNqguUHOirjx1gKRTnZ8fFAqnHcbHiLA6c2GI+wBZ8HdbYl+M85B6APTrMTXGGgnx
	e8TuTc6JGH5QJHN2vGgRt3thMTRZK5AaKCmF4ZUcsyqnzzDjp+RlCvbQlbh6CTyKCRtnQB0bsWwIZ
	EKdcRTliUJIt5OJU3/XEGeC/Jr9V4U2PZxRm2ZfbseJlW9nfxsHSd5Ube8HQaYqfq71/t0bZf1O/H
	qR71j8Wq8XfMnUAFwWBHzT+PaLZ62ALmKRgg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Ie7-0000000GyAR-2cQQ;
	Wed, 23 Sep 2026 16:48:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:48:07 +1000
Date: Wed, 23 Sep 2026 18:48:07 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/vmx - clean up includes, metadata, and
 p8_init()
Message-ID: <arOSR3rO1seclSBb@gondor.apana.org.au>
References: <20260914081500.65737-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914081500.65737-2-blum@kernel.org>

On Mon, Sep 14, 2026 at 10:15:01AM +0200, Thorsten Blum wrote:
> In p8_init(), remove the goto statement and return ret directly.
> 
> Remove any redundant includes, add a missing space in MODULE_AUTHOR(),
> and join the MODULE_DESCRIPTION() strings for better grepability.
> 
> Also remove MODULE_VERSION(). It has never been updated and the kernel
> release better reflects the module version.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  arch/powerpc/crypto/vmx.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
