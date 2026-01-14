Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7408A341062
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 05:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768367195; cv=none; b=KMRlzDZAJ56PfpRWujJehDPM3UBeT1Onjd8GuhRX3x38pLTTK14t7/dq44hUsh1V6mLaBbadoccG+PLUFDKsPYUi5EFs6lG2N4z5oPjdsQdlwLsmJC/wpm6nKhvj7+mzk4EwI6U06RlzQtWEBJL2Nw9VyqE8D5xYYtOIRKhT4d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768367195; c=relaxed/simple;
	bh=7dJ0DNqpmPaMyuYxkkAZrgzaTjwxZbljfI8/zYVol+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HS5vpbqStp63NirOH9Igl4HX8tLQmu8l5z4/Ip9yJL/F+H72sDEUxRdOq0RV1SDgFl2X8a7DnWdU6cxecWhvzhnchTzXpHW/naMKFAJ6L1ow3+/u29TKbK5Datg81KNHe7arIEebMPhbYQR+1nHV7x23yifYRIqZuD6zNi+XvwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Hylk7ED4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Hylk7ED4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OU8MTlxy2rMKoQH+jhB+57uV9jRTwDKEYLxJMMG+ZOg=; 
	b=Hylk7ED4s8bjaLCuSCis17SqI14WRMDWhA60zp5YGl7gWvlYqCdTcUmpnO25ojEJbIhKKcAg4kO
	H/IV0SKVlHxhzAp3KtwxRnvL+/JtuFsML4Y8t78iG0AZD6oFfuiKSj6u9V9EdWhh6NVkeneFl8DT8
	Ej0Sp3UgZsiPuhBZsuWi2TLTxz1z7FMeFbZtTQdw6m3iEzyJlbt+iFj4SAp7a4uUrQb7ox2Y8ty1/
	jw8o67zwXLO6Po7NmA5Hck6Rs7KC4fSOshnz6vuSfSlBeS7U12mMiEtqvUQiTPxRHi8Ux+KcqcIlP
	ZEEyK6CvFE+DAzBcFJPWUyQCck3Cmi9KUeGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vft54-00Gap8-2U;
	Wed, 14 Jan 2026 13:06:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 Jan 2026 13:06:06 +0800
Date: Wed, 14 Jan 2026 13:06:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>
Subject: Re: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Message-ID: <aWckPqfPJ98clqnb@gondor.apana.org.au>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
 <9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au>
 <SA1PR11MB8476DC4555BAABB5734BE314C984A@SA1PR11MB8476.namprd11.prod.outlook.com>
 <SA1PR11MB8476CABAA90DCF9B492B001AC98FA@SA1PR11MB8476.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR11MB8476CABAA90DCF9B492B001AC98FA@SA1PR11MB8476.namprd11.prod.outlook.com>

On Wed, Jan 14, 2026 at 02:14:58AM +0000, Sridhar, Kanchana P wrote:
>
> Just wanted to follow up and get your suggestions on whether I should go
> ahead with incorporating the segmentation API patches into v14 of my zswap
> compression batching patch series, with the changes I had to make, as described
> earlier? I would appreciate your letting me know.

Yes let's go ahead with your changes.  Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
