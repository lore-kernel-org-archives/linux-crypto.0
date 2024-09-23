Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BA241C77
	for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2024 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727077048; cv=none; b=D0gDCWfx/V2TvfTnsC+aX8jayDRti3zE8thB16Ir7W8gD+oSrN4K9Rx90S/DEEs/sJxrqWvMS/apGKb1j4qxJeXNVNxsdTx2+tGST2Fc7GJ/ouNWt7q6/whIA9mly8SFA7w24yU/KPjCrttaIZmiCVZeN8o89zqHQCGKZ1NAjl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727077048; c=relaxed/simple;
	bh=2sSiI/ZntOW++ykKXasmq4YRVom8VodZgede2Iwkz/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEQTKg9B6bboJx3sMCIJjyBZ8qHDvzXv5KtnShtD6pBOF59ceuBt9ds/oBoXNBsXc/zQRLq4QFm257S+dygsx4YxTu8ys5mLvWIcM+2w/RWyIusSiRHMKmfd6DOdIvupovzkgqz/y7ltxFU/LLFDQqRFPkC1IxMXYdzOSJpYbJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=n9f188OH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="n9f188OH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q9ZuijASA1kl2apvY91w1Swf6C9X5DvZVj+WXQ3x2ik=; b=n9f188OH1w+MjPZ6RG+3g1ZejL
	48L1FjXia1fs4qwvZuHBgs2YK9nfsx1YpN7sEia2kdELVtKRpXudbEK728KjK7YhQEtK2E/XMafwj
	z9U8k7+/I9irugo8sM8ROn9Fij9znyZQ0bXNpo/3r6QxyRBI/EVVnRDNZWpkOjbH9tOlmrT+6hp1Y
	o/kurrKtC90QP2xHQpzw4bygxze76zKgQbfJdwAWaQ8LY1HPBlsm2QWSA/CWIIULj9Zt9HxDJRKqI
	9NhcnXY0gaIYbg6B10AH3rYkE8W8qHosPvRblC/Va81T/QBDNjDPWq/oxu8xOlpAtjO3+AvYG72Dz
	dQJaCi6Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ssdTP-0042zs-0K;
	Mon, 23 Sep 2024 15:37:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Sep 2024 15:37:20 +0800
Date: Mon, 23 Sep 2024 15:37:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harshjain.prof@gmail.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>, h.jain@amd.com,
	harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Subject: Re: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
Message-ID: <ZvEasINIFePe1tE7@gondor.apana.org.au>
References: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>

On Mon, Sep 23, 2024 at 12:39:11PM +0530, Harsh Jain wrote:
>
> What should be the preferred fix for this.
> 1. Increase the size of HASH_MAX_DESCSIZE macro by 8.
> 2. Register "versal-sha3-384" as ahash algo.

Please hold onto your algorithm for a while.  When I'm done with
the multibuffer ahash interface hopefully we can say goodbye to
shash once and for all.

The plan is to allow ahash users to supply virtual pointer addresses
instead to SG lists (if they wish), and the API will provide help
to the drivers by automatically copying them and turning them into
SG lists.

For the shash algorithms the API will walk the input data for them
and if the input is a virtual pointer, then there will be no overhead
at all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
