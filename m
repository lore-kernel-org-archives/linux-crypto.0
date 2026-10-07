Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9521C5D72;
	Wed,  7 Oct 2026 03:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791343284; cv=none; b=NVZowzDo7xVLu28ikTZOPYnI6JtZyJ0z6DYqjwuCnSfO74AtH6W/QN7qvrWqyF4R2/lOCeHwQk4EW69zFFWILJ44e4Dk+zS4aYGUMOgfZ5mmdc11t6JNqBoU3JF3ZRoBNMXIE3M5xXit0jGIKd3h9RxEUK1RUc/01ZYaujJG4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791343284; c=relaxed/simple;
	bh=T7pOsAaf3j03tqrZ5y6PhNW92WjQ81jbfp1a9oMGIjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8xHukEXw4eMl7pDWpoC1Etk9KXC0+h6+Hi9QSPBN2TAweWeiE+igrtiPxyVMCqmk9r9n+Emn26nj3AKVouPh0aijYwS3NXWgsJqJXGC97awV3MuGQ5tCQqgi/8znh+b9EZP7J6WfAl0uiv3Ze2+AnmOBaJO9Z6g7JPmzI1WsZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Uw8HHscq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Uw8HHscq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YNF2MgleN/chs3AY95VxBP/Ykum7GlsKFhi3C00XiMM=; 
	b=Uw8HHscqTQ3x/XWgx0jCmRpdonsBC6LLH/AXgvCC43BASszHOAxnaogWAfGumD9bvQ2b0c9xlla
	CC6WqH99aNlcZp4qPuOlTlDUvO4nb0cmzj/Yf/gScADESNpSpYRJsiCB3QyqRcaamn3l4B1IheogD
	OCa+Ez772/fWMaCHOgugQ42QKJRexaPcUFB1P3TcqIIj4DHQz5JKjKIXswIGtmZDjtzAYYuGoVpOj
	H4D0NV1QUbW6rxuK6fCOvPvcuJvXfKSJRDP6wwlAdyt72hYRsZiHNBB6GMMyBPszhk0aK2oRguqJg
	J67/tIY0HwUZJFkEf9zaYfbiohYuhpyP3CRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEIDK-00000001RSJ-39Yq;
	Wed, 07 Oct 2026 11:21:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Oct 2026 14:21:06 +1100
Date: Wed, 7 Oct 2026 14:21:06 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Song Li <songl@zju.edu.cn>
Subject: Re: [PATCH v2] crypto: ccp - Fix use-after-free in backlog cmd
 advancement
Message-ID: <asW6osf7KarT6E48@gondor.apana.org.au>
References: <20260929143825.21349-1-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929143825.21349-1-fanwu01@zju.edu.cn>

On Tue, Sep 29, 2026 at 02:38:25PM +0000, Fan Wu wrote:
>
> @@ -391,26 +372,61 @@ static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
>  		return NULL;
>  	}
>  
> -	if (ccp->cmd_count) {
> +	if (!list_empty(&ccp->cmd)) {
>  		cmd_q->active = 1;
>  
>  		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
>  		list_del(&cmd->entry);
>  
> -		ccp->cmd_count--;
> -	}
> -
> -	if (!list_empty(&ccp->backlog)) {
> +		if (!list_empty(&ccp->backlog)) {
> +			/* Transfer the freed slot to the backlogged
> +			 * command, so that concurrent submissions cannot
> +			 * claim the space meant for it.
> +			 */
> +			backlog = list_first_entry(&ccp->backlog,
> +						   struct ccp_cmd, entry);
> +			list_del(&backlog->entry);
> +		} else {
> +			ccp->cmd_count--;
> +		}
> +	} else if (!list_empty(&ccp->backlog)) {
> +		/* No command is available for execution, but a backlogged
> +		 * command is stranded: reserve a slot for it.
> +		 */
>  		backlog = list_first_entry(&ccp->backlog, struct ccp_cmd,
>  					   entry);
>  		list_del(&backlog->entry);
> +
> +		ccp->cmd_count++;

This seems dangerous.  Since you're keeping the cmd_count without
actually moving the backlogged entry over to the active list.
Wouldn't this increment potentially exceed the limit on the number
of active entries?

I think rather than spending time on fixing this mess, we should
just convert it over to crypto_engine and be done with it.  The
crypto_engine system is known to work without these subtle race
conditions and all drivers should use it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
