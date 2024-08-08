Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589EC189BAD
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113422; cv=none; b=M5HJ8nOpf41Y3Z4qwANzssY8EzeuaScGHp26erNrsfMCWFeb5MF8MH1FCpAEJJ/ys/Bw0OZL2QgdYPQ3xhzDokFWsKKQyakyDVD5pO+aas1p8eBoHouPFdZzZLLk/FtoiNTuLRsHnu+/g4rRzixmhjmhp5DKcUUBgsqTNapQcsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113422; c=relaxed/simple;
	bh=UUooHXsfMCfo8LmVpujeXA679VFqFuGvf/olazHcIHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0TAu+pcqF3w9CnhPNgnOL5khCRMNV2yY28BHEzso5yYRHQU2qhS65JxcS7DgvxO2SuTTFZ8hL7WxauIcjJDV/5CYIPgiZzOMFscY0vxjAs+oAGlmNzvKAF7AbWls8PbzXpaRUxtWYOU7bqc0fHOiSDcte7Xjdsui6vzxt96gwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sc0N6-003Hlw-0g;
	Thu, 08 Aug 2024 18:36:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Aug 2024 18:36:37 +0800
Date: Thu, 8 Aug 2024 18:36:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Yi Yang <yiyang13@huawei.com>, davem@davemloft.net,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	lujialin4@huawei.com, linux-crypto@vger.kernel.org,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
Message-ID: <ZrSftdpqJnlxd7Gx@gondor.apana.org.au>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
 <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au>
 <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
 <ZrSbGs646zd20TBe@gauss3.secunet.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrSbGs646zd20TBe@gauss3.secunet.de>

On Thu, Aug 08, 2024 at 12:16:58PM +0200, Steffen Klassert wrote:
>
> Maybe pcrypt can call the crypto layer directly without
> parallelization in that case.

Yes that should work.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
