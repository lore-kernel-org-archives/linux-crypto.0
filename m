Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F21198A2F;
	Fri, 18 Jul 2025 10:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752834687; cv=none; b=n1dsjgkinKUgc16PqBP0aMnbrt9/+cXVsKPpDagZRTGjmILtnmy8HapbIbNCTI00r/XoFOuU0syVGKeyl2bjjbSPZX6WOg08JD6zXTy7E8F3mHdEkg3f2qqnbqrsTQ6aTigfOHvjiLOAVR1h5pkI6VZb95zABjBV3J7Hoo3SJVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752834687; c=relaxed/simple;
	bh=59VSGdV+1J+G46yTP2chmQXs4clXZPvyWRI+wjhGLSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFD2raQBdmIJkdDpQA62Pxj5motx2GEhtm6k/hDbESNTxoHR+Hxn3/08UNztmOtKfY1GtjKewUwhMkiqTHFTA0yHca5SE+qPLMRvOgbelJr2fenW4ADMwxFAZZ1zfCF5pa+5xwh1JeUoh+3OqGM+huCVUyXtvhdKuN9y0HKLrrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rpAEHbP+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rpAEHbP+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TmeP+yow1RBgKJBVVeBNniATmYMII+R0E6wQz5nLZbI=; b=rpAEHbP+kkF0IarNY+5A8dM+yJ
	DMpUEBbVkIFB+H62c5liwl2Yiyr1uFNOH28mKTsXgv++cqlrA0CnI/NPhbAI/MwkHyZlGViKM6SFB
	W/uxdQvhWSAfeggnjE7CgTN6zqq5XyuWEB0MOl+VXMIGMbfJHXa58K9TdpX3QsNrSK6KOUCfqlpA1
	IfW6YTpNKb2h9e44PGzIzlxr2bUxMIecNUgWQIPhzpKTgjD9HDxoACnTJD7EKwVeZNpUnR3S9RiLt
	5yaE/HZfIq3VYegTTWRq7m6UubdRzeQr8vnmTQEn92JI71Ii8K39f+ge1OS367qE3wKgz/9pjeitX
	pVJfS07w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uci7T-007yBt-22;
	Fri, 18 Jul 2025 18:31:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:31:08 +1000
Date: Fri, 18 Jul 2025 20:31:08 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
	dhowells@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 0/4] crypto: Add support for shake128/256 XOFs
Message-ID: <aHoibPpl7CHM3FGd@gondor.apana.org.au>
References: <20250630143834.2748285-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630143834.2748285-1-stefanb@linux.ibm.com>

On Mon, Jun 30, 2025 at 10:38:30AM -0400, Stefan Berger wrote:
> This series adds support for shake128/256 extended output functions (XOFs)
> along with test cases to verify the produced digest and XOF output. A new
> squeeze method is added to the shash_alg structure to get an arbitrary
> number of bytes from these XOFs.
> 
> Regards,
>    Stefan
> 
> 
> v2:
>  - Refactored crypto_shake_squeeze_bytes to be called for arbitrary number
>    of bytes to return
>  - Adjusted XOF test case parameters to better test modfied squeeze
>    function

Please post this along with the actual user so that it can be
evaluated in the proper context.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
