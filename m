Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977E48F40;
	Thu, 12 Jun 2025 05:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749704760; cv=none; b=FeLUSbA9vDXltUsNuQiPCnzqK21CbHfZS4UIOkkJUWn3fFLY0g6ZA3WUFq7ZY2UiWjUiQqs2d59bF+rOV8jcId+JTKNe+YPmq0kH14VWxfOEd0TgS8OOjWso3TGjxVchlzpylaSsWFOZpf4KAm4dCBhfIcWPOFK55mTwEt9a2so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749704760; c=relaxed/simple;
	bh=xHKDJ8piiYQ7eHY9QtOGSOWLmnShMrPtnJRjyxzHE6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1HKZtOIJxN+U1HwqIAbyKgUH8IOee7WWh1Cp9xSIyH7I2O4s8Q915ypbZQMgw58gtrXpROwUgGizhlutzNBsFJ0dWZYCSWUVOYBt5igbbN8TBqI7tq/nfIpXvNmlxm944onsZyBwMJQb2zn58ri1MnP8xGhUqFrWrdCFWwLoEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oaPfGOUq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oaPfGOUq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UvRSMDir+pqswhNL9W0Ch0KcXXgEpc3Xl+MMfHD/mDU=; b=oaPfGOUqrE7LvodMqjmVGJaa67
	7P8iY0NAuD/NsCKKJ7MkFqBy8ArnIdRtHf1CIVaJqhqlynEx+lw/TEhP01KMM6pRbiYr7WX0nSJc6
	Wg05Q1eXko57/yCOMcT/5kJaEF7qQMTMQ3kbEmRs4H9LhixxXYq1iKu1Ylp6fsKmYOPHqNPUhx/5j
	vb/yGEiseP5pZN5TBmIQBn++IGotOabFW7JxIoSzUuIbVTLs/rSAaLkTI4tC3+91S9dKjydzavFFX
	P8EN61vAzc6eBformydP5IH/csqUH5S8xKP0K6WpMxE/DSZUCcX09QX6tOQ+bUxhj8qLettg+cGCt
	2ARDvzqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPa8H-00CXv0-2p;
	Thu, 12 Jun 2025 13:05:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Jun 2025 13:05:45 +0800
Date: Thu, 12 Jun 2025 13:05:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
Message-ID: <aEpgKQ1I0VDSfhO0@gondor.apana.org.au>
References: <20250611101750.6839-1-AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611101750.6839-1-AlanSong-oc@zhaoxin.com>

On Wed, Jun 11, 2025 at 06:17:50PM +0800, AlanSong-oc wrote:
>
> +static int padlock_sha1_update_zhaoxin(struct shash_desc *desc,
> +                                   const u8 *src, unsigned int len)
> +{
> +       struct sha1_state *state = padlock_shash_desc_ctx(desc);
> +       int blocks = len / SHA1_BLOCK_SIZE;
> +
> +       /* The xsha1 instruction requires a 32-byte buffer for execution for Zhaoxin processors */
> +       u8 buf[32 + PADLOCK_ALIGNMENT - 1];
> +       u8 *dst = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);

The padlock has always had an alignment requirement.  We already
deal with this by using PADLOCK_ALIGNMENT.  So rather than re-inventing
it here, you should simply change PADLOCK_ALIGNMENT to 32 for Zhaoxin.

You should also fix the comment to state that 32 is for alignment
rather than the size.  The Nano already requires an 128-byte buffer
and we cater for that so it can't be the size that's the problem
here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
