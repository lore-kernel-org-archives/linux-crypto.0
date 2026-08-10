Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820A0397933;
	Mon, 10 Aug 2026 08:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349274; cv=none; b=smVVpAeE/JuTh7ydjYkgtYQOQf7vY72EFw0I4HMrAEP6YtJWF/FsOtD/B0FFVLk1XZVFgL+U5hcFIyuC3GMxHkNGokGP1W8qSC9hGQlkzti4MalUR55xEc845hsXmNdgmvfwFQBKUJpbCY4p58sGbforE75KcLw01sTnsJdY54o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349274; c=relaxed/simple;
	bh=c9Y4GPidiwWVChtPTr44Mmnqza0oMvswGcK/zPEOZ2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDRscHJY3q5Llspm8D7bIyeFvqoet1bqPALDleqpv+YXLBZIYacJj94LOQnno9VYq+c2bSHAkhdbxU9PQTiPKb4HWWIKQJnC0OdZtslQAhsoIcqXHcVUyOE0XpwJHvjR7RRiTPnkfjUAoCayzFk8sTEfTcEzPxDiNCRZhVdOsr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gA3F2SfI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gA3F2SfI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QiDGkgGa0xUcFAuneuvJUe4tLnPTHHV2AJ985yDoNpU=; 
	b=gA3F2SfIh1n1IkVuuWuG9Wd7RUn3hOQpYfDS92If8AFOhCkEeQRl+gl/Ra8y5w8RgHoBwtGnHbU
	K0g/Cay+c9+vXKDcPD7ShP6sk6aVXskRq5MYL6TF1/t+vFO6vVDkiu5Fi7VSQGorMkrbLcqBtC/Eu
	BpZ4OXNX5UY3I7nkgwKGiIPYLCf1rqWnwG0l4ZgF+rD9H9jQ0QTqm+HVb9eYwLVZxg69bKOo/i/U0
	eTqf6+Xp/OLd/mnYgMtGPYPRn7tL/Cdi0zS+8RJbljw4hyuEYofJrQiPZIOEH65/iQ8kiDCRPNKfw
	2mZl6n4djRS9/6wI0Rx3jIj0yNvzIVH0PB9Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtL2w-00000003WIo-36my;
	Mon, 10 Aug 2026 16:07:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:07:46 +1000
Date: Mon, 10 Aug 2026 18:07:46 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam: simplify probe resource and IRQ handling
Message-ID: <anmG0nnmQYtVwKdy@gondor.apana.org.au>
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

Please check the Sashiko comments on this patch:

https://sashiko.dev/#/patchset/20260730204915.1102403-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
