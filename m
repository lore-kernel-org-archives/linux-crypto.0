Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D285C182C5
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 08:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042379; cv=none; b=cj0IOP7LZsOPg/W0vuIJaianUpagNEhnI3QckjheHhYye3nNb1yHOdTrrey5fRYKktzdJwpQFGCtsZBf8/kXPSp6GyWO6qTdhaQhD4K13n67iacd+bpZ+SoriMR/sQl9Nc7mgz5z3tw4PQ9S8Sxp8d47Sq0Y/ped7FFCjyemsIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042379; c=relaxed/simple;
	bh=OSG0K2iglxPMHvaEVwH0kPy4nGQgWwtpvhxynVWE8Jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhC5SlVVjYC1FYltQDLFFQ38aeS44YrmO3MRs3pTT9b9DEpNyInexYYcnZ1uu8pK7xTufIURgwZ60T5el7aTVJ34KYpE2i0vDgl21VIAWJxhZnmkFB8ofGYyzA9h0Nj2Jqfq6M/rCIrdl9pu4q2CaEoDXFM3jXsumjbwJgC5eHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VhwSJ24P; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VhwSJ24P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1tNR8DDvn+V6KtjGOM/DHfLLycpGW2+TpAKgIEKzc8I=; b=VhwSJ24P4U4HvT8u03vCNTlqlO
	kmAYP9Z2t9wrLs/L6XZdGCXF5ZEc73T5V8K9Ayq9epH3ylv1hSjZkEQV8uBaReY/27gHxm9324vBh
	U9LEbynhd3N6BCIsX7DTDotvebz02C90IfcuQpcExvfi03+jcsEBcAIC7n1JqeDxXFIJLJz66cnw9
	CGDsgfkPv0J6AoqJDKT5Tb/oBXeyA2D1fyi+BfBtvGBqZl6yfTEJ6RSgRu/+xXkfoEE1YYflwENOG
	IRBicPPPWu8y7vohjC8rr8kiivaGOF9RQen13o5UMIgZlw4CeMcPzmbYJ1kXs7xuLbxPt/D+KHahL
	2NpgPFkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1soIJB-001ey1-1Y;
	Wed, 11 Sep 2024 16:12:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Sep 2024 16:12:51 +0800
Date: Wed, 11 Sep 2024 16:12:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: algboss - Pass instance creation error up
Message-ID: <ZuFRA7c_stkYI5Rr@gondor.apana.org.au>
References: <7f5c4907-ac4f-4b41-90d0-e00c1e552bf6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f5c4907-ac4f-4b41-90d0-e00c1e552bf6@stanley.mountain>

On Wed, Sep 11, 2024 at 11:08:01AM +0300, Dan Carpenter wrote:
> Hello Herbert Xu,
> 
> Commit 795f85fca229 ("crypto: algboss - Pass instance creation error
> up") from Sep 1, 2024 (linux-next), leads to the following Smatch
> static checker warning:
> 
> 	crypto/algboss.c:67 cryptomgr_probe()
> 	warn: passing zero to 'ERR_PTR'
> 
> crypto/algboss.c
>     50 static int cryptomgr_probe(void *data)
>     51 {
>     52         struct cryptomgr_param *param = data;
>     53         struct crypto_template *tmpl;
>     54         int err = -ENOENT;
>     55 
>     56         tmpl = crypto_lookup_template(param->template);
>     57         if (!tmpl)
>     58                 goto out;
>     59 
>     60         do {
>     61                 err = tmpl->create(tmpl, param->tb);
>     62         } while (err == -EAGAIN && !signal_pending(current));
>     63 
>     64         crypto_tmpl_put(tmpl);
>     65 
>     66 out:
> --> 67         param->larval->adult = ERR_PTR(err);

This is intentional.  If adult is NULL then the caller will retry
the lookup in crypto_larval_wait.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
