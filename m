Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF431581E5;
	Sun,  9 Feb 2025 10:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096747; cv=none; b=rr1q/vzQhNmFlxk/KAsH2d6CqXplyEqt3N51MuQ1iRcT1vep13XHouGPOMsTw5gHg/rer8g3AYnOE0OnKBE04CkkPzykDBXaJtrPNKK7gQTUzB4s6Mwy5GEVUAN5fBo/Bhi38xy2eqUvU19MuaEiYy+5ns7RA2r6fr+2vcHZHn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096747; c=relaxed/simple;
	bh=56AiyWWAPmqUuIe3wpQsaB1KGID+cdJYyD3tuB1DMhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aaANEsg8HrRCvHs2sDFtULKaJVbRqMtz6qgf8jrNBb/HfPfQr7WE50fomY+vuOrfl6ve/fIEfS/0Yu/ISfsY2SoXElGhMp2HUinbp00A5ceKaYMYmn/fPhunbm0g2/7fiFsZ/WnI2kAq0OF9cHtuAJjHqCLXeE/DzFbPA4d79n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O3p3Jg4O; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O3p3Jg4O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1iBm607sBxcA6KdkZ1ibPdZIisFBHiGLsffWZjG6130=; b=O3p3Jg4OPyqL2e3J+baquR0gL/
	JdgazGqX94YfNiEpSOt0/1NJBX1KVhhD1XVSo4CBlkaeQIFwEkTpUXkDkM3xxAWlvHQ3OM7+/IHKt
	WUy+KJ7J4GpRjKOMDGPhREj7t2qZwuoQ1BSxHicAIcd1vkTokZTRJp1sfScV//bCs/DXxDVYofSKx
	uwnVEFPyZC4HQ/JbUc4fGBh+Y9WV6wQu1f/tMl4KLuUji8U4RX6wIajyo1pSEpXs2PaygzqplTn/k
	sWak4NBN3qDcJmtyVMTLVIHBXviJ3BZxyaoC4kyQC18PbL8HwJq/ZlNmDqeRJuyj1+lzxUycfQoQK
	kGdwts7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4IR-00GIsF-0Y;
	Sun, 09 Feb 2025 18:25:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:25:35 +0800
Date: Sun, 9 Feb 2025 18:25:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Kaiser <martin@kaiser.cx>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Kamlesh Gurudasani <kamlesh@ti.com>
Subject: Re: [PATCH v2] hwrng: imx-rngc - add runtime pm
Message-ID: <Z6iCn97oKQuXZd-Y@gondor.apana.org.au>
References: <20250118160701.32624-1-martin@kaiser.cx>
 <20250201183907.82570-1-martin@kaiser.cx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250201183907.82570-1-martin@kaiser.cx>

On Sat, Feb 01, 2025 at 07:39:07PM +0100, Martin Kaiser wrote:
> Add runtime power management to the imx-rngc driver. Disable the
> peripheral clock when the rngc is idle.
> 
> The callback functions from struct hwrng wake the rngc up when they're
> called and set it to idle on exit. Helper functions which are invoked
> from the callbacks assume that the rngc is active.
> 
> Device init and probe are done before runtime pm is enabled. The
> peripheral clock will be handled manually during these steps. Do not use
> devres any more to enable/disable the peripheral clock, this conflicts
> with runtime pm.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
> v2:
>  - remove unnecessary err = 0; assignment
> 
>  drivers/char/hw_random/imx-rngc.c | 69 +++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
