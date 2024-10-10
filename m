Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201891BF322;
	Thu, 10 Oct 2024 08:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728549659; cv=none; b=nmDlQsrFU/hd3Mi9kPN7RcUHCfr8L31XfwutZc/zaNfZ70aAp4D9TjiZ4SCoKn32JgegxgE33+WjdvWNytMrUXiiBtKPj7PRLhrjzvyW4Y3EHcbUDg/WlXilOWsO4vMuD9KC2HMrsap+lYXExQSxiVaqnh3jcvMf9BqvGq3Q3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728549659; c=relaxed/simple;
	bh=90vxXsx2oRvzxGDopEo5+qSMo0jQCscmJyIdkiKViog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImuM4rJmGScE3ip+cwOn2MNP/4HRlnMIU8V7IMEmwtemTAg3DIPvClcSCZHDteI8kbgm0Ve6UFzVfsyw/gEqHKxgOOuv5tw4P3PtAGAlYGB0CJi6prRn+nLxuyQn/esyW+ZZT/OBQ4882oy5gyDxBRkf5FQNm7WdDjDnBIVp/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=L9P38nIn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="L9P38nIn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KNFeZPwsXdKsBcX3uUpDInf5sJ7Tv8OC8VcZMT67wdg=; b=L9P38nInvsOEuUuWw+wmWovqCz
	n271/H9ri/SK2ZXCtBZ1gDRCJWrwB26TUaXewjNnxyBJlOJun5g6QE0pkOdAxCDy0o96Lz1KbCTHH
	Q7kBWmMpI12hM61325TJ1AcjqOYjvzJN2pDFAmXVQ1UxRef+WhWEkBYsqgaXUe/SVLESn5NDEohRF
	yNpBgRWqROzSfxmCKkKNZ8kmN5lB94UH3Jzl7609esyFPgJdvwF3eFKw42t82p8iEH8/8fq0yXlLs
	qF1PhqprHj/WVdS9Qz2wUr1pOH40NJvjBOyxGbhJmE6orkJ8VMNgQhNbCYGhNPr51c3eyq+y37H9U
	akPSIyUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1syoZ0-008HQ1-1t;
	Thu, 10 Oct 2024 16:40:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2024 16:40:40 +0800
Date: Thu, 10 Oct 2024 16:40:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 RESEND] crypto: lib/mpi - Extend support for
 scope-based resource management
Message-ID: <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>

On Sat, Oct 05, 2024 at 08:27:03AM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 18 Sep 2024 11:06:35 +0200
> 
> Scope-based resource management became supported for some
> programming interfaces by contributions of Peter Zijlstra on 2023-05-26.
> See also the commit 54da6a0924311c7cf5015533991e44fb8eb12773 ("locking:
> Introduce __cleanup() based infrastructure").
> 
> Thus add a macro call so that the attribute “__free(mpi_free)” can be
> applied accordingly.

So where are the users of this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
