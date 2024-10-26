Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A2E178CE4;
	Sat, 26 Oct 2024 06:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925994; cv=none; b=b9OG5qqZkQ3UYFnqzrBwqlav1FBU5tO3BF9AfKDMzdJQVNvq3BFKGQhO1eACFz2acG3qXSrS820XSGt/THnx/Sb9kGP4r1abW5z2dc4TJRJAHqoBeqUsk6QvSAOGb+wIBSVBO/9JmmbJ4pKRuw64Ccli6L2m6GW2Y6XgB+zH9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925994; c=relaxed/simple;
	bh=2lylmapr26FcY6VAt4CK6htJwEG/81kIdEgAks+Edcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gwi58+ST8Xlmflz7n1bohyOvt+8KLES7CWb/5Jc5+q0z8enSIfKHeFI+Y3XUlswJMaIefSEX1QWQ4LWFhfxKOmd5ToycLrXGjnTRgUD0blpOG/xHeD3PfRhkIgY4Hw86psj/SSMvO+t3t2TiGEVyijL4MX7Rtiq0ilaBc5LWuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Y4d/5jL/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Y4d/5jL/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZPsBHEpOK123r5cGqapoJFLRdNvm02bGsyN7ON55vDk=; b=Y4d/5jL/xJZP9kahr0TXobeHJz
	jx6Io7XOo1H/dwY5aukA0km+u7LKEC/fuLNU8wgxXrKYI0qMKg6Ym/fqpih6ecXTfBZowPMw6aCfw
	vTZfO6KzOVR8I2cknnUDCZCRGE+0Gti8coJemdsSXY32jjekUi02unxdJ1Y1HnoFAANZZvSNX7vz2
	c8ypdxMeLo8VS1ZJ8oXGD9x10L4vkckrr4PE1C8ulY0so2TWYscXHJ/M6EDBFAw43BP1fHXlzDjwe
	xt4wpxyLAYzolcTrmK60p87Fb0pSMrldvCGrnLdCNXMXgOwRRzjQytsvl+NBDeK3T+JvHfMVVRBK2
	AXc+JbrQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4am1-00CFzP-01;
	Sat, 26 Oct 2024 14:59:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:59:45 +0800
Date: Sat, 26 Oct 2024 14:59:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: WangYuli <wangyuli@uniontech.com>
Cc: giovanni.cabiddu@intel.com, davem@davemloft.net, jie.wang@intel.com,
	dong.xie@intel.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bo.cui@intel.com, bruce.w.allan@intel.com, karen.xiang@intel.com,
	pingchaox.yang@intel.com
Subject: Re: [PATCH] crypto: qat - Fix typo "accelaration"
Message-ID: <ZxyTYROWhW404rXA@gondor.apana.org.au>
References: <1D2B5A3330DAD82E+20241017082946.314361-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1D2B5A3330DAD82E+20241017082946.314361-1-wangyuli@uniontech.com>

On Thu, Oct 17, 2024 at 04:29:46PM +0800, WangYuli wrote:
> There is a spelling mistake of 'accelaration' in comments which
> should be 'acceleration'.
> 
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_hal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
