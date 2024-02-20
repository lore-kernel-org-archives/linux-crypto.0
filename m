Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5685D74F
	for <linux-crypto@vger.kernel.org>; Tue, 20 Feb 2024 08:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708418977; cv=none; b=WL7SkxM8RDLmzy+JYMCMlTGVNNFFngCzZywiT9iulTj3/fGlWA91qMPiTadaHyJA7w7CFiTOsAoY9OzdVtv/9jDNmZna6ABlhFWepz6B8GW1G+xEPRA9MHHwZaMbxgCnvFd5dtBSmB16gUqK7Jjc2MbqErL3nIQ8KhIpRNCf83Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708418977; c=relaxed/simple;
	bh=5dTQua/4eoYo1e3mu6mcmLxlf/y5x+ztg5UyCt3akzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7EMejQh4nkwzxMLMLgGC2lo/1WUBO+Hq17zZFsDjvcL3sGKTh2rYTnM7XvXLEVm98HOAC0l8H4K8w9M0ixakM+7QRg7qH1rG2e5x4D4YWm/Sz+ySgUYRgx472FWA2pSjtqW91XT2q//1bEj5R3avhMbRbTgP0u96PONVLy0ZYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rcLof-00FaSz-18; Tue, 20 Feb 2024 16:49:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 Feb 2024 16:49:43 +0800
Date: Tue, 20 Feb 2024 16:49:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Damian Muszynski <damian.muszynski@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix arbiter mapping generation algorithm
 for QAT 402xx
Message-ID: <ZdRnpyUNdOVUS9nf@gondor.apana.org.au>
References: <20240119161325.12582-1-damian.muszynski@intel.com>
 <Zaqp5+mL/Gg2i/Oo@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zaqp5+mL/Gg2i/Oo@gcabiddu-mobl.ger.corp.intel.com>

On Fri, Jan 19, 2024 at 04:57:11PM +0000, Cabiddu, Giovanni wrote:
> Hi Herbert,
> 
> would it be possible to send this as a fix for 6.8?

Hi Giovanni:

The firmware file qat_402xx_mmp.bin does not appear in linux-firmware.
Is it supposed to be there?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
