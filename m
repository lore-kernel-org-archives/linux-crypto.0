Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962E71DACB8;
	Fri,  7 Mar 2025 08:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741336615; cv=none; b=KZovgq76iQFJO8OYa6Mek+ijtopwrnayWEWqeBQUjPgTA0GNMQtTL15cO2Q0TK4rPde9igLfehU4UD6r0hvbdAsOgtvHlsVpm6JOHW25v2tkLhvhXGINiNkOjrql7JIlLjH0JdH5GU4G694wRCvjvORN6Em1o1bynHRtgwCY03k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741336615; c=relaxed/simple;
	bh=RPEpUTKQKr9PCaZ1EGbuPrOSsOoKS1XRRyU2/cDwiFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfulmCsoDu7oltFE9nhigT7R9lFVcu8J0PECBMRrmXkYDlmRDn8ig5eIn3lt/49HFe41FFTO1WZ5zXUHgGrCbr76Hp9DWlV6D6BbtEnAfKzj2I32KI4a64Fv9ixLzi80UHJcWfDa3FDkFPqFyXVHj8gpga6t2NcxetZSiATZVTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FS8Oa+0A; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FS8Oa+0A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=l/PNSc+3s2Wu8+WfDLaTSkpZ+5bG55XIBrFY2BgUIKU=; b=FS8Oa+0AcLI0GrRb2Y6brjp4vD
	MoOsVdKi+IoYsGDD4Jn2C0BQGwKsFp2RmhJP1nUkf9SVlGZ5a6YGFQC8jHO0EvFdFGFdnVj1nfFCV
	1S6iIaZ5YB67Zzacctb9u8oXS97OFMOSTcbe5MmdWUQJAhNpkqpx3lFtQdkIol1My7nLsz7EhIY5i
	sirjPv0TKGyKS/GrNJXUIyUFoyglSJWRLVe07tQpoMJmmoo+pAofauPaWw020aX+qO0VjOoPDBlrN
	dNmLvz1HeW0QH5AUTCymv6KCMVGeuQI7ift5yij4CzrMo8w3xpyiW0wrJ2MvMi3kQ04ZIiUxtagn7
	0jCiPFRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqTCD-004XgT-1G;
	Fri, 07 Mar 2025 16:36:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 16:36:41 +0800
Date: Fri, 7 Mar 2025 16:36:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/crypto: Rework protected key AES for true
 asynch support
Message-ID: <Z8qwGRsGKz3fs22m@gondor.apana.org.au>
References: <20250306171201.17961-1-freude@linux.ibm.com>
 <20250306171201.17961-2-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306171201.17961-2-freude@linux.ibm.com>

On Thu, Mar 06, 2025 at 06:12:01PM +0100, Harald Freudenberger wrote:
>
> -static inline int __ctr_paes_set_key(struct s390_paes_ctx *ctx)
> +static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long modifier)
>  {

...

>  
> -	/* Check if the function code is available */
> -	ctx->fc = (fc && cpacf_test_func(&kmctr_functions, fc)) ? fc : 0;
> +	req_ctx->req = req;
> +	req_ctx->modifier = modifier;
> +	INIT_DELAYED_WORK(&req_ctx->work, xts_paes_wq_crypt_fn);
> +	queue_delayed_work(paes_wq, &req_ctx->work, 0);
> +	rc = -EINPROGRESS;

Please use the existing crypto_engine code to do the queueing
rather than rolling your own.  First of all it should result
in less code, but more importantly it will avoid pitfalls such
as not having a limit on the number of queued requests.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
