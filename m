Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7D1F5408;
	Sat, 15 Mar 2025 09:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742030245; cv=none; b=olV1zdVm7omyJ1/MlrwNV8jJ6b/5f9YlhbVM/33hExRB2D5gKeZ6aGbq7tP70sTfxY+Ygc+SOBCse+OVBofjEMZ1e9+tkTLTIgYph8/WHgjCxrpFdHvyR7Z42q9SO1x1o9lOKisLPm/7hMBwGKeb1HrhzZPwQvqGI2LTLrRn2ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742030245; c=relaxed/simple;
	bh=0beMAWfhgdCIvWJb79ujpAgj8Z2U9lGWuEdLLbPUItQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=los7shRcNpF4oc6Wdtz9yMgbWllu97CSMQVWcx+OaSoM/PVsv3aURlBPnCtQXlbr5RxSXRddN061fllrNqVbhoLPyYWGSpHfNwxJ32IH49TNKVTiTP3IWue3Tw/mclxvoIhqdj4E+BnokCzWuAjsw+3lVEs/untJdjwgpF85s30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rPZj0bNg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rPZj0bNg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=22hK8/bevl1s3AaqYS1NuJfpl+tx1Ixqjh4iwSpRsDM=; b=rPZj0bNgXHDyAIZWb3eefweDCX
	MSJcgaEMTcD0c73eeX6ZJm3tuu0tfIFfJueQfLubJIbKi6Ur7u7Vw04IA038pWmBCkYhiBCEnmwp1
	05rHLY36NmfIvihVXzNV0+npvlBOOOkH6m52PeKqMSnaS9uh5SG9RDbL/YVAT6ASmgb8QQOEHUchS
	sWRMmepx6oqizqup8DAfa6XIUVIFHIOzogg3ZopBsNpdVo4OFrABjwcbtTbl/bxBoAvyp7hjmA3cF
	v92IAYGduYzm5I+m/7ovGHa/3AIxWRXRS4TpMlNKntcQMobWWqlaawEhlKjUpHsHdbWn8qVmLEVV/
	JVinzXIQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNdv-006o98-1h;
	Sat, 15 Mar 2025 17:17:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:17:19 +0800
Date: Sat, 15 Mar 2025 17:17:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>, stable@vger.kernel.org,
	Dionna Glaze <dionnaglaze@google.com>
Subject: Re: [PATCH] crypto: ccp: Fix uAPI definitions of PSP errors
Message-ID: <Z9VFn53H0-FcHeD4@gondor.apana.org.au>
References: <20250308011028.719002-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308011028.719002-1-aik@amd.com>

On Sat, Mar 08, 2025 at 12:10:28PM +1100, Alexey Kardashevskiy wrote:
> Additions to the error enum after explicit 0x27 setting for
> SEV_RET_INVALID_KEY leads to incorrect value assignments.
> 
> Use explicit values to match the manufacturer specifications more
> clearly.
> 
> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
> CC: stable@vger.kernel.org
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> Reposting as requested in
> https://lore.kernel.org/r/Z7f2S3MigLEY80P2@gondor.apana.org.au
> 
> I wrote it in the first place but since then it travelled a lot,
> feel free to correct the chain of SOBs and RB :)
> ---
>  include/uapi/linux/psp-sev.h | 21 +++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
