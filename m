Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC402E3380
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 02:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743562701; cv=none; b=G1zXDKfVGUaowvn0I62auPm4WD5MhJI/SD+KvuwWBRsUxKnzpLu63x4ZB07vB7LCj/Jd6gcnpRxACspE/Pb6jJ8P6jzCm4qnfx8fnloZ5zcuCc8raHg7qm6BOd27rjfzeKr8tLE01C5/0/7qdI1ANz9jhmM/X4KCylzbMhRgvYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743562701; c=relaxed/simple;
	bh=9GQUBkY9ToTHSY9yB7f0qnlw5DZXeVLMlCCy3VIb48I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lc3IkIpntbb8jqCx62M2TygIxibRTFP+aSNZLgRnXR5AKfvLVL4s3ApPblKqIki0IdNphHKADJxuBQFWAwb7l/VnilBYtYfY3qvhTGyL55o9kCsP4wVO4JO3E5+U/DIY9rqIMUcAU0hAydVOLipq6Kz0dymxlyRIclrQsGdfC6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RSyt7sqL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RSyt7sqL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yhXQ2xoN3PD9VRPVqKkYTXXx07jPA7mPUP6RQVjrVCY=; b=RSyt7sqLIcpx6iJSgmPqA8iixY
	q3FxH8JhxGhHJqvVfHnxfAN8+hGDht0CHVMB0LFck7+etJM0Pq2fRqiHG2AKw/zmYW6J0RG5MiH0n
	gH/yThPrRLGNvz/8TQnseqwNgagghCo+XfrocOFTympgDAmISngyuqvhABFnuP21R0N7cn64YUkP7
	IdgVTxUwgDtyW4kFSxXz7aa7l0+DKu9RoYn43Ij3pFkZxiFtjvaZdHo2rmWqGSlD1ePDHBx4JzhNL
	JE/OqrYW/TCWXTYzi/UpNeOLlQ1+IC5RUrm8I40uiYoVpNbgNqAR4+ENcZmABoA2pIYR6xgEn3mjh
	f0Dd+TkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzoIv-00C10R-0E;
	Wed, 02 Apr 2025 10:58:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 10:58:13 +0800
Date: Wed, 2 Apr 2025 10:58:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, andriy.shevchenko@intel.com,
	qat-linux@intel.com
Subject: Re: [PATCH 0/8] crypto: qat - fix warm reboot
Message-ID: <Z-ynxYw7OYHjfSaF@gondor.apana.org.au>
References: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326160116.102699-2-giovanni.cabiddu@intel.com>

On Wed, Mar 26, 2025 at 03:59:45PM +0000, Giovanni Cabiddu wrote:
> This series of patches addresses the warm reboot problem that affects
> all QAT devices. When a reset is performed using kexec, QAT devices
> fail to recover due to improper shutdown.

Thanks for the quick fixes Giovanni!

As this is not a new regression, I think they should go through
the usual release cycle.

Just one comment on a possible improvement though, while it's good
to shut down the device properly, the initialisation side should
also do as much as is possible to reset a device that is in an
unknown state.

This is because the previous kernel might have had a hard crash,
in which case there is no chance for the correct shutdown sequence
to be carried out.

Of course it's not always physically possible to reset something
that is in an unknown state, but we should design the driver to be
as resilient as possible.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
