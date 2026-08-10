Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611BC37C0ED;
	Mon, 10 Aug 2026 07:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786348564; cv=none; b=lZekymwEydCebPG5sJzPqp33y0lm/IrOU9MoH8rX25E1Z0TSAV/sSrOJP0IMfJyGP4yM0OgQaUtREU5eTufbYP08yvh+y6AgkZPIuzimi/4uUrTcjJoupORbkvOc3s5sULMj4PBRMKnk7RkYTprr/eRshT6/DnKusvlZyKMDB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786348564; c=relaxed/simple;
	bh=frLP7yspn28WRUIN876nJ/FtvPDiHAlFJgD3FyMD8jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+7yfbITL8qjDxip2XD68NWC1BByUHLPtRdJkvTpfKyxqQXtXEtmiOqlMcdzvDEj3dql6GuLNysKSOHN1ppLej/z9SWhqrMjK8EHUoUDPaGo9mN4oR0Sv/Ig5lObamI6DJON9P4zJhE9aZDBwCO4Jo5kiQF6mASqIGH9VZMWg7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YhED9L8l; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YhED9L8l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VXJaggnVFOcRWsFCIBb9vOR8QUdCx2a5YMjwIgtZsQs=; 
	b=YhED9L8lAXTn79vy9IE0sT+ZTzeOSX7cQax43RmgCMyeTbtpozlzpMJXjDILKzW9uYojA0MZLqD
	YpU5Y2/stGJ8/UexUmqOn6AnuY6J6xA618hlJe4aCguWq/JNfhtRAO2MHDvVndVWGUOo2qi4Nsmi2
	vHuS8/L1Uf/WvxuffKwydUFi+0FngZEEByh60mMyFHKMI9P+QysEm+YchAra5i3E3uM5Wub98btzJ
	SjkSMK3SfyJJ7iSuJl6Z3D9+Td9f/EoamGSypFHgCLZ39MfYSUIQgFZDEpgL5NKYAKVsh5t1b93fi
	Q2FLV/3/CSa4pDlJQUkgmNZDs2pHXC8O7hGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtKrU-00000003W33-3mN6;
	Mon, 10 Aug 2026 15:55:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 17:55:56 +1000
Date: Mon, 10 Aug 2026 17:55:56 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jihong Min <hurryman2212@gmail.com>
Cc: Christian Marangi <ansuelsmth@gmail.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>, linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/4] crypto: introduce generic dynamic software fallback
 and EIP93 support
Message-ID: <anmEDI6cQxS1wGtH@gondor.apana.org.au>
References: <cover.1785226804.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1785226804.git.hurryman2212@gmail.com>

On Tue, Jul 28, 2026 at 05:43:28PM +0900, Jihong Min wrote:
>
> The tcrypt AES-128-CBC results are median cycles from five runs. Lower
> is better. Disabled uses cbc(aes-eip93) directly, while enabled uses
> fallback(cbc(aes-eip93)).
> 
>   Request   Disabled   Enabled   Cycle reduction
>    (bytes)   (cycles)  (cycles)
>        16        322        18             94.4%
>        64        274        43             84.3%
>       128        292        74             74.7%
>       256        312       138             55.8%
>      1024        434       439             -1.2%
>      1424        492       488              0.8%
>      4096        980      1023             -4.4%

Do these results vary that much at run-time that requires a run-time
test? Surely you can predict the outcome for the platforms involved?

It appears to me that you're simply adding complexity for something
that can already be easily tuned by the administrator through the
algorithm priorities.

In fact, why not implement the benchmark in user-space and then based
on that result adjust the priorities?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
