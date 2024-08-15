Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F219B9475
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 02:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723687598; cv=none; b=f1ApnQAGC68uus2nERQuC9FDMaqEN1u1CsWyugfSj1F86aeAmGC5PwJdXMS6Gwa1UW28VLwDwUW2UPM2Vns86+GZaVNjEO8fFIKd3EV2XzpziB2mC2f9kUVE8nYgp+JAAomWdAkzExthG/l19OCz0IUJk07DrW6EqWHiK8P5IK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723687598; c=relaxed/simple;
	bh=s2Hj9SC7jQcy9U43ScFjHj+Y51Mq37bQXSIGZKPk3qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYsvdJxLP6e5YrY1QNE8sbEvaJLuNzaZGg2+MKMLTmmD234ZFZelhsxPKGSE7vHAP+VA8/bY03aHfbZCRf9hZZTQZQ2R4Uturbt1VEO9snUR5vIVjUt9OJg+TKEUvo1BL93IEEgNJKKJDbwExCGcRmpDrpBmvGk3aoMQMOA7/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sePju-004lEk-2y;
	Thu, 15 Aug 2024 10:06:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Aug 2024 10:06:07 +0800
Date: Thu, 15 Aug 2024 10:06:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "yiyang (D)" <yiyang13@huawei.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, davem@davemloft.net,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	lujialin4@huawei.com, linux-crypto@vger.kernel.org,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
Message-ID: <Zr1ij_rbPicAc6-f@gondor.apana.org.au>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
 <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au>
 <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
 <ZrSbGs646zd20TBe@gauss3.secunet.de>
 <ZrSftdpqJnlxd7Gx@gondor.apana.org.au>
 <a47169a3-b357-8c8c-7c21-bf6cf1f61e5b@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a47169a3-b357-8c8c-7c21-bf6cf1f61e5b@huawei.com>

On Thu, Aug 15, 2024 at 09:25:39AM +0800, yiyang (D) wrote:
>
> Does this mean that the user needs to call the interface of the crypto layer
> in this case? rather than requiring the kernel to handle this.

No it means that pcrypt should intercept the error and retry the
request without going through padata.  Could you please redo the
patch through pcrypt?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
