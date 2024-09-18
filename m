Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E8176AD4;
	Wed, 18 Sep 2024 08:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726647658; cv=none; b=e5YmYM69CjhXEaIKKqAintH/ct0e2Q/PkolKkC9pztvKr7m7SiBNpfok3juXmMX13bY2Q5/UmGXHRqZRwuYf3ncx6Htdntzt5FGf3+62e0twlLAgDRdVEaYGZx5pznm5wORCg79f+lwKrlLzeABnaT+j8F4pkURAuy8Vv8x3GvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726647658; c=relaxed/simple;
	bh=zOzFdIqmKGH4EfL83QSxIgZy7bFTceIaGLQrK9tn7w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXUexVXEN+EqBywIIAQm9Im1e5iimER+0yNDnbkYWXLx8uA9aFgBcB/hRQjWy0HnNDB2LrQeZyQRWHBVoVrlx+GNNcd9xuA0mBdt5iimVuHDmNrrvy62pZlOergx5kYja206BCp59xpVqsYSqwgQ4b/4qiNxZINuulC4wMriHr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GsynOEt6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GsynOEt6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qIaOOW59Q8Ci8YktXi6m8UMkAKM+uan776/TphhokNo=; b=GsynOEt6p6C8TONJfWoTb+mK7p
	no+VEJ9v0W+wVAX2t/lDZQvI+xA07HWwgRvCa/R7aImRfRrTsjGjpQpzI0Hbiy0RD75edGQ7l1zxm
	8V4XNmIIwaUjfw5lSJ/IhL9L9zvgMr4pvM0lxUokMAFFOd8BYW7LJOePz4+jsFiOZdF4JBPZJlvDL
	CR6nkVK6Zo1bX70zIIgX2A1oqG2ei298FFJdSgkrHlqTL/Uy+P3XBvg7LUcanQOH4Tn6KxlLRQviQ
	+5+CmSRWvd4D2VJoFtw2D8usngizCYW/ClWwJVrHfuWDW6IGUiMMNv4BfmZLm22C2MZRwYIi4hFDh
	NfqoK1lg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sqpld-003AK8-2y;
	Wed, 18 Sep 2024 16:20:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 18 Sep 2024 16:20:43 +0800
Date: Wed, 18 Sep 2024 16:20:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH] crypto: s390/paes - Fix module aliases
Message-ID: <ZuqNW78cj5Gs0Fl_@gondor.apana.org.au>
References: <6399cdf3-3bf4-4623-8be6-cd8978d11770@linux.ibm.com>
 <ZulMEyvIWNtbZJHD@gondor.apana.org.au>
 <4b694c31-5d5c-40b8-8f2e-da858c3001d9@linux.ibm.com>
 <ZupQq2os75c_BFRz@gondor.apana.org.au>
 <4c413338-808f-430c-bc03-624ac789cfff@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c413338-808f-430c-bc03-624ac789cfff@linux.ibm.com>

On Wed, Sep 18, 2024 at 08:50:29AM +0200, Ingo Franzki wrote:
>
> Trough which tree should we carry this patch forward? 
> Through the crypto tree or the s390 tree? 
> @Heiko @Harald @Herbert opinions?

I can take this and then push it to Linus.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
