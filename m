Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1453A9DB6;
	Fri, 27 Mar 2026 10:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606115; cv=none; b=Ml7qvBOidDjJtG+7ABSvLArpNok4k7ia6yCbwo1pK66vLqzuKjfGYumfD+qIH8is+oDy8NwreKLmNwxhLfitLTz+9HdDeKx6nGpaUiI0Gsz61223RWwBWhiPae3MZ1QEWIHKuqMywPgqTn9jOMF3I3LizqmXOOdqd3zVg+5nyRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606115; c=relaxed/simple;
	bh=puSl2yO9ZV9CVTozCqExjoi36fG0VGLPyyZZn/LlpZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP9g8iYLtD3NU2fKz1GXp7RESAaYtUXb5sjhhzp6BmU6werERhDtCkA4s8gOsn9JChk5GVcbhSQEdeT+KLaLgIxtwDSc5EsLNM2dRDSKLj1YVkgvu9pkf0Os4L3UoFJ0/j2FJiF6IerSp0Keu6HM3kUpWFkgmpO+7zohmD1lMPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=H/afi3co; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="H/afi3co"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AzWhhK4eypW2x0fSnkzpK6RerezFsNCiDwe+T8oeXdU=; 
	b=H/afi3co8SjSAQvj7/xp1Gw0//RvM0gbu7N+aeSZfyH7Zc0wcsg79e0eSM33lHu2PQyn+SZfpeZ
	uzYPVVKCx2B9ZbsQ2juVUZpR2XUtkE4AMmIq6FCduRKwS+8ZjTb9PI9QXDVoWS0dLqWc8CPpL/MwN
	O1wSv9U9L5stxIFFn/JprphFPxgWpGi7Up2oOvdvJgC5KZy90/nt9sxyD25u3TnrXdAXm8eke2up8
	JZsfMzmiHUMbzGikFyJu4CJ2sRuQgsFUmsG8LVNWly3lqNt2q13twYd+AdfdyA4KEXFWEw0ez5qwT
	dF3YpvTydz0/zlEQHxpj0a1TnQVtVn8l0JKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63hQ-001bnv-1f;
	Fri, 27 Mar 2026 18:08:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:08:11 +0900
Date: Fri, 27 Mar 2026 19:08:11 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),rfc3686(ctr(aes)))
Message-ID: <acZXC_Sj_54PLIQs@gondor.apana.org.au>
References: <20260319171128.10566-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319171128.10566-1-olek2@wp.pl>

On Thu, Mar 19, 2026 at 06:11:21PM +0100, Aleksander Jan Bajkowski wrote:
> Test vectors were generated starting from existing RFC3686(CTR(AES)) test
> vectors and adding HMAC(MD5) computed with software implementation.
> Then, the results were double-checked on Mediatek MT7986 (safexcel).
> Platform pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  crypto/testmgr.c |   7 ++
>  crypto/testmgr.h | 207 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 214 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
