Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053AE1A682D;
	Sat,  7 Mar 2026 05:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861599; cv=none; b=kfL8d0Dd745PolLgJO2GCJibdPWmchu1DpqntDQ9tm5Lu765MDF4cBZAq+uPrdxCqUCQ3juyxIV53jsZ+iqdQ1NvUMtH2EZ/E8TN03kCn+pbP4aBurDtsf3S3YEp5yhF1C72sdH0KIZhq4ZYwb/Eo5AXit2thQ2j/ixjhcCQUk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861599; c=relaxed/simple;
	bh=IiZs38fXIBUHcX3k8H1N47+fArJO194TrcoiNrJ3jjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUy+rA6CWvbBRQrWp3YvwOex05BvfB2GzPerlTsGJK33bsbO7MP+dq8LUf9g59SDq09SmmgbCZOfoPq0FUDM8RTu7dTspbgWvE9AJjPx2wy8t+/t5WQRyKIwsIMH8YH1uUikq573n0zSNWdFYa03aenJnd6ROXcuMQsjXVhYYbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eexA7cWZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eexA7cWZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PYP9yHpWOZRbrEWMSr+QtQEN75JRCFb5x8h/H9Pxbnc=; 
	b=eexA7cWZqtVTAZvPV3+MT/R/ma17rGXWuWHk5kpzNnJhhEOqKX5rkkviguAxtDoGQuW0QYIppd7
	EJkmepLTSr/9hiPVCyc09RA3Y5b1dIPAW5m4QgNsCe5lA8fO06lS8dEKzt5PQ+Vm0F2CIXI70nr7k
	ZLhNxy3dDZBYIrz4X+DOLnwLVZLZv1Rccqm8VLeMJlK0+VrgSEIxGzfSgb5mbXX1AFt9JeqJyiwUT
	LQP0rIh8rDbdpIQCcFOQ4ROS/8Khm9XIUCIB2xaz3Q53uGvtC9YxzhUvSX2uN+Lm7lXqzMDkPJTP6
	YGmmtFF97r0sUgJ5Omhk3SKijgw6Uu7tsufA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykHV-00CJZO-2O;
	Sat, 07 Mar 2026 13:32:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:32:53 +0900
Date: Sat, 7 Mar 2026 14:32:53 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aau4hTzIYEVKyAT3@gondor.apana.org.au>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
 <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
 <aZ3Uqaec79TUrP2I@wunner.de>
 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
 <aZ6vF1CHpcp5d5qk@wunner.de>
 <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>
 <aZ_zfnKVnTaG_4bk@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ_zfnKVnTaG_4bk@wunner.de>

On Thu, Feb 26, 2026 at 08:17:18AM +0100, Lukas Wunner wrote:
>
> That's fine for the RSA software implementation in crypto/rsa.c but
> I could very well imagine it causes problems with an RSA accelerator,
> particularly because rsa_edesc_alloc() in drivers/crypto/caam/caampkc.c
> now maps the same buffer with DMA_TO_DEVICE and then DMA_FROM_DEVICE.

That's definitely not good.  It needs to handle in-place encryption
by using DMA_BIDIRECTIONAL.  If the hardware is not capable of that
then an extra copy must be performed by the driver.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
