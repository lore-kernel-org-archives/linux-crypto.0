Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405ED38AC75
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 04:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789447770; cv=none; b=lT6XLy1mAq4pC5d+r03vlvYTy2GAfsERKJ0H8ils9gdtsaRjSDmU+VsLh+DIoj0pALSpQdT5f5NLLkLzmS0x3JoGyDfP/7bZXVEOF7qe1tum3sEncsNObj8tEa3e9t8rMRUVIOP9MSx3hFXAVPO4iDJHAGb1pR7G8j4kivYDnr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789447770; c=relaxed/simple;
	bh=XdZHG/hVMhGfQs4yachFvB/gW86XFTs+BV5J/xH+sLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVtsy2XnXN8rNIwvbHFD3Od/lFlXaAd79YFP3peapYCZYdtDIlcCe6bzw+qcVkocxhJYZtSn0DNGMzFL4pWlMnESgIisjckrF8kIFHZpgyzEZHiQ7Wl3FgVShTybUCAllMOj83EXVbbyyA/6cil8hkqTlCU2GsxY98qJMPMI9ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BQjYVs13; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BQjYVs13"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Kzb3bSF1XG3tai1wJD9Oyv5crfzSu8dbTEf0jgt7mX4=; 
	b=BQjYVs130EvcxH7Xr4QZ/iuv0LSkqN35wQosqi8/sK4JsKLuiVG7365Uoj4mg82QJBYvyor1nOd
	WnUXF6FiCNScG3k9fQCrmIW3FGoKoTLITal438jgtW0IaD6qywsR9je+b43ZGml2rfzldPRAvYEjn
	oT54M8kbTJo4p5FIUMVLBYtkZukUjTsZi/NcablUTeebEIzlVKhywkSLKWuSxowQdElGH4tSz1UZB
	uqKSz2lfhmHUf0a0ezOucQljwOfad5oibCy4vocuWBSdvHAN3uwNWMkkwLXlCrPLI1sR9zIW/wv8B
	7K1laH8pnQFisaQYoBwyLQhuY+hbeAETmNdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6L6d-0000000E53l-47iD;
	Tue, 15 Sep 2026 12:49:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Sep 2026 14:49:19 +1000
Date: Tue, 15 Sep 2026 14:49:19 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqjOTzlY6acaOaTg@gondor.apana.org.au>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
 <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
 <aqfJgFY73ZYtFJmH@strlen.de>
 <aqfPeIDmYPI8-ZTb@gondor.apana.org.au>
 <aqgKwiRQ5oz-Mwc-@strlen.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgKwiRQ5oz-Mwc-@strlen.de>

On Mon, Sep 14, 2026 at 04:54:58PM +0200, Florian Westphal wrote:
>
> Are you OK with this small change?

Sure.

> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 63129a8e223b..511383708e19 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -358,8 +358,8 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
>          * table, and thus no references to the old table will
>          * remain.
>          * We do this inside the locked region so that
> -        * rhashtable_walk_stop() can use rcu_head_after_call_rcu()
> -        * to check if it should not re-link the table.
> +        * rhashtable_walk_stop() can check tbl->dying before it
> +        * re-links the table.
>          */
> 
> I can mangle this locally here.

Please also change the added mutex_lock calls to mutex_lock_nested
with depth 1:

	mutex_lock_nested(&ht->mutex, 1);

I forgot about Neil's recent change to lockdep depths when writing
this.

Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
