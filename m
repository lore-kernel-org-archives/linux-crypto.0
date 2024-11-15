Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDBD1B6D15
	for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2024 11:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671846; cv=none; b=DqTvMlB6ppwz7Hd+7CaJqxpibWbVgimiA2KZzsLn1alK50oo0m8tT8666DBOCPeA6nBpL9uUFv8JUWU4PT9wOh6+qxram0o/zw/VTOJLx7LEU/mbDwTUNxEjVtZpUufZNhNM71F97wHiHedYYxK7zqfcQI6BIToQsMeeciEatCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671846; c=relaxed/simple;
	bh=NQ/MBF019xgP0eJs25KNr1ueXAaV6YzAmNP21ECM3zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2BiI8pExlkrvYsGX2JU+ps+0XM4xaZVppyGQss97LviOeoHFIqkMsGdmjU/wn0Kiro+5C6ARocalwq4w/NvTYVl+wJYja9eK2Qz/kp/EVlE1Z2Fljua62mrzCeOg+cJD0lAWzwT+WdlKEplC0x4xlw4T3A6wVzwRLW0lNd5J3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RRdCcm4E; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RRdCcm4E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O6EdRPuJ8L9SPlw+0jo0ZrWQZTF0BvKAp3vlMpdN8VE=; b=RRdCcm4EMqNCNyzCMdVH45YlW9
	JddP/cATBiGIn4jpGL2vhJFOa6nJGmfsVmzldgT6jwRUGXiWD/WBm8OLI5kwg32pM/L4eyIzxBslX
	FFHVZbej0we9U3EUX7h9aF3L1ctXslsEJlAXRmhEH5XIRCs5WS0d/eWiU0CCGjqtVKCpp9WAfXYYZ
	iaZeNVhtOGJMOq5qH914qKFTs01LNIzbRBejreCF8hZJQqBe/yMrYnKa/ElMwB/hvfgdWhkx7o2JP
	ycfxILhNdLCx69fhyYBJNO07RiVXg8FWPs8jJGZv/acGP5mHG4WAm56hjMCQWPu63wz7L2KWfrzq6
	2fWf+BKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBuwp-00H1x5-15;
	Fri, 15 Nov 2024 19:57:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:57:11 +0800
Date: Fri, 15 Nov 2024 19:57:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: davem@davemloft.net, u.kleine-koenig@baylibre.com,
	rob.rice@broadcom.com, steven.lin1@broadcom.com,
	linux-crypto@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH] crypto: bcm - add error check in the ahash_hmac_init
 function
Message-ID: <Zzc3Fz1bYWSzX4wL@gondor.apana.org.au>
References: <20241104121745.1634866-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104121745.1634866-1-chenridong@huaweicloud.com>

On Mon, Nov 04, 2024 at 12:17:45PM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The ahash_init functions may return fails. The ahash_hmac_init should
> not return ok when ahash_init returns error. For an example, ahash_init
> will return -ENOMEM when allocation memory is error.
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  drivers/crypto/bcm/cipher.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
