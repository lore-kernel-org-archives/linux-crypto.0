Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428BD2D781B;
	Mon, 10 Aug 2026 08:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350809; cv=none; b=K4pMA2rt0xngGB3thvWiRJR3z4UqyaIfbDUSuWkGnVq5i+YtCcjGhN4eIttXKYejc8q/CHmZzIFYPAGjXrRQoNuAUcldZ2GDSYKgPQ6onBFAHjq6Z4Yx4BdLzUvpMjm8pb/z69a7cT4/mrrm2/Pqvp/4+x35UNq7eBKjP+MjUtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350809; c=relaxed/simple;
	bh=1+wkDr1JLnRDtjECD5Udg6anjChxPiOPL3ZooM0Tt8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dk5X0kO+QW6hjWvfGCEp9kcpC5DyxpF8H2BJcDlSBLEKtinWFDAZcxvsM9qL0ykdSR+8e2/g4vILvQvWmFDHvAaUHs8luDrNEzR6iSI8nxrNphp0Ko5ay8DgwToHMfmWlBvHwd7zpTz54eEipQkrgBQphddMplpg3j66RlrgqiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kAr6miZm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kAr6miZm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KOewNMeR5sEUX0Avild3EU2DCWFcVN8j/3+8ousOBdE=; 
	b=kAr6miZm5cXIpTIFRhV6/T4i1E1NySPrLm9bVr68Udbg2gwOzGAtxig6+u3iZUCiDmduNZgi39V
	yuHp/mrTSm0OwmGaJNkhsExOC7ls9sPKFHh71+vtzVKhYWvE+RtjuVJiv3hCdoXKmayfrMKZ9B3oi
	mWlg5BWJIJRcz3PDHO0QXQvq49X+RhZiXplBEK8C7HdFJaMAcXmbuxszCgP0aO7pkwngJnMZOyPoi
	ZiZh8p8LHTDdAaeYESlfhaACEY9KX6y9M6QZqbRPLT5dwQLPzx2k1AQdth19cw2r2xyoyrptjucbH
	JNoMbLvMRXjH2EQNQVrNlY9LSfgkg/Ponzcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLRj-00000003WmY-1lnE;
	Mon, 10 Aug 2026 16:33:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:33:23 +1000
Date: Mon, 10 Aug 2026 18:33:23 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam: simplify probe resource and IRQ handling
Message-ID: <anmM0464U8l2vzku@gondor.apana.org.au>
References: <20260730204722.1101805-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730204722.1101805-1-rosenp@gmail.com>

On Thu, Jul 30, 2026 at 01:47:22PM -0700, Rosen Penev wrote:
> Convert the interrupt acquisition from irq_of_parse_and_map() to
> platform_get_irq(), which resolves the IRQ from the device's interrupts
> property via of_irq_get(). Flip the error check from testing for zero to
> testing for a negative errno, and drop the now-unused
> caam_jr_irq_dispose_mapping() callback and its devm_add_action_or_reset()
> cleanup, since platform_get_irq() manages the mapping internally.
> 
> Replace the open-coded platform_get_resource() plus devm_ioremap()
> sequence with devm_platform_ioremap_resource(), which fetches the
> resource, requests the region and maps it in one call.
> 
> Each fsl,sec-*-job-ring node has a distinct 0x10000 reg region and
> interrupts property, so the region reservation added by
> devm_ioremap_resource() is exclusive and does not introduce overlap
> failures.
> 
> Assisted-by: opencode:hy3-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/caam/jr.c | 46 +++++++++++-----------------------------
>  1 file changed, 12 insertions(+), 34 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
