Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331872595;
	Fri, 31 May 2024 05:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717133014; cv=none; b=ag+yYu/R5wQ84XihLSjP43lIagiccBTGCmfS/BOearnyc6gBtRvGLpY1UmnUWx1xyBSxNWLW/2YSZuSP+5MFs8eKsrWoh0sj20x+ST54praBImdzZTGGPl6urWl6HfER64dSN24F7hNHWnb6FXtLg420ZeEw3Gy3s9bQ/aR64A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717133014; c=relaxed/simple;
	bh=ZlypaGOxQu0lcdkVBS5VrWOXHjkJFNvCOH98fFtukus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBtHynqTybgdz9DDiFqPDihuHjuXqenbJPAiNsYEieaKQ1oU8PGcg8t3BEXYMt0aGelfjmqC995HtiFA2LWSl1eBJEti88UzCiC8aFVQnYJYyXS22lprRhGe3YDDT6u+zvWwBnzJPzRMk+LP6otTzUthn3QIGq0YMfbzO846EXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCujU-0044nD-1M;
	Fri, 31 May 2024 13:23:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 13:23:18 +0800
Date: Fri, 31 May 2024 13:23:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Message-ID: <Zllexnetg3eu6dSW@gondor.apana.org.au>
References: <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
 <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>

On Wed, May 29, 2024 at 06:53:42AM +0000, Akhil R wrote:
> > The only iommu function call in this driver is a
> > tegra_dev_iommu_get_stream_id() which does not allocate anything and does
> > not take any reference.
> > 
> > More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed in the
> > probe.
> 
> I did not completely understand what is being tried to convey here.
> If I understand it right, iommu_fwspec_free() does not do anything
> with the "devm_kzalloc"ed variable. 
> 
> It would probably be a good idea to remove this line from the commit message.

I think he means that as the memory was allocated via devm, it will
be automatically freed by the kernel and the driver does not need
to (and should not) free the memory by hand.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
