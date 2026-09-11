Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA44930568B;
	Fri, 11 Sep 2026 05:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104537; cv=none; b=iB76/lZh8qUaP94qKYrKLNTUrVTegAOYP7iCsOzDgpzYX3o5rkyouZIAYSRujWD9qICTyuzXTiroKqMRT1MPL76yhoQiXyqwGr0Wm5rrgJslnl9XtSM2ESfbldAWTEByRvE8vfbjql3bPSsl2vygvMsJ8nEvDMPE+Xpy4Rnnfgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104537; c=relaxed/simple;
	bh=GKX4rQktsgnizLiAg5fK9a6hyrpMCI3Q9X57bzFKvYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yc13UeC/mtRxqu7BSyLfJ4jqtzRXRO4kpx5JbvVTshppO4yw2hb7cJASWscdYSBKgwf5S+0hfzheC/ebogRRceHUd3xO7KnDpWgGZSzOB712yNUN0xO9D4sWvSKjMDR+NjyzzYbuk32VEEV7R9bTWkw/qDCTM1kObFjJ95XW7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AQbqKm6Q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AQbqKm6Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=U8/ESTI0sv5i6ZIO5e9uA53yIncS9/3oP+Vgj5ogqWU=; 
	b=AQbqKm6QpnjZYb4c4fjBykh38bnlM0ubK3qOdRXawjVGa1o2yYVRr4uxira64Z72Fi1HdlQeZkB
	YE0uG8BiG71V4dYymfORVNUZoVWOCry/d0s2ngvNQpflXDFYM8m9qIgif7788LChLEbbvMWn3oTdv
	wmMsqdnP0LkWXYQm0qLPRLxUPIbJmpPCPJm0vQoj80ybSkjFzzLA8siIPjvP2uWij0Gq6Ik66l+Jp
	DrpPt2Ka6BiLKRSJf2HGDsskvejcQc2EJRm4WZDH8Iih7ISNNFdnYWqGrmdZroFBTia6k0wtIELcc
	coQznXqZLfs66h70wNLV/PwItrg3/+r3TzJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tog-0000000Cu78-0jfa;
	Fri, 11 Sep 2026 13:28:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:28:50 +1000
Date: Fri, 11 Sep 2026 15:28:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	Prabhjot Khurana <prabhjot.khurana@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - Remove bouncing maintainer
Message-ID: <aqORksTlHEM1smmV@gondor.apana.org.au>
References: <20260827155120.2334898-1-dave.hansen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827155120.2334898-1-dave.hansen@linux.intel.com>

On Thu, Aug 27, 2026 at 08:51:20AM -0700, Dave Hansen wrote:
> The email for Mark Gross is bouncing. Remove the entry.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Prabhjot Khurana <prabhjot.khurana@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
