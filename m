Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EE9286412
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 05:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861710; cv=none; b=mNMdLPkTksYi1AZg4sIHP+piVG98DSWXlZ9pQe5vAuqBXMcCIGfC31JFilXqUPSbr9LkZYOU/bIrPPwvXrchHpfEIbZlVrFTV3wRmDWmlgW9mxfvCEHWmxkQ2JugCIpgiNYj7d1/PmH9IfWxzrlJ3YrTQU0OwM3LJWB+fvJ/06s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861710; c=relaxed/simple;
	bh=7DgMraHzRqehubDPXKH54Si2hWCKEMw3ks6wA/hqh8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDc8E8FuzoYjvIgfN8W569rv5zbm82jIuDliU8s5q2xjhPZSV83isTZdeBBXPg+siX/m7Yf/UAflukldrKRUsrlUWtzGMfaFU3tsXSQ5cd6Ty+11PZd7jlk+P94nykzl1Js4gYv54f+YAyShwP7L255lrd3xBX24ZPkFQc5+JsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Tr0Nh7EZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Tr0Nh7EZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MWsYFFH7pmGOLUaa8Rg9s+ePeiZlV9bEpzS3p8ZBgPA=; 
	b=Tr0Nh7EZ0xKdqEgGU0FMLQO/o/VTcovDvJ9s0WseNUmzzir6Z9xKxERkNpy/hu8/uPoymqGerkR
	eLO4x4JfxEnmANCM2MXBQ0+GC3VrgWfK8j4VglttOovPE389VpKtCGAz91wM8kJ+bdXlOAfb/NPWH
	isddSRxuc9LEfE36L8kc/0MUyv3H5cW0IgPI4+nLyXYe5LrpJTHv5n59lr7OJi7aMIb1n/eTEyXsE
	GtP4+Hbq+ZTPSO21uRKmXrz3H11rb2+PGUz8N7b7jQh8bZeMUB2j+EsxPMaE3tBx7+jR6EVIJHLFG
	WCBEsypBIkWyWqu/2KTqQMdP8f2A5J1kzWvw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykJP-00CJcr-30;
	Sat, 07 Mar 2026 13:34:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:34:51 +0900
Date: Sat, 7 Mar 2026 14:34:51 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] padata: Remove cpu online check from cpu add and
 removal
Message-ID: <aau4-491Zxwc6JPB@gondor.apana.org.au>
References: <20260226080703.3157990-1-zhouchuyi@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226080703.3157990-1-zhouchuyi@bytedance.com>

On Thu, Feb 26, 2026 at 04:07:03PM +0800, Chuyi Zhou wrote:
> During the CPU offline process, the dying CPU is cleared from the
> cpu_online_mask in takedown_cpu(). After this step, various CPUHP_*_DEAD
> callbacks are executed to perform cleanup jobs for the dead CPU, so this
> cpu online check in padata_cpu_dead() is unnecessary.
> 
> Similarly, when executing padata_cpu_online() during the
> CPUHP_AP_ONLINE_DYN phase, the CPU has already been set in the
> cpu_online_mask, the action even occurs earlier than the
> CPUHP_AP_ONLINE_IDLE stage.
> 
> Remove this unnecessary cpu online check in __padata_add_cpu() and
> __padata_remove_cpu().
> 
> Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
> Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>  kernel/padata.c | 26 ++++++++------------------
>  1 file changed, 8 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
