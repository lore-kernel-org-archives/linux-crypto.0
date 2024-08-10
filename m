Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42604409;
	Sat, 10 Aug 2024 04:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723262732; cv=none; b=JH/d8/tjZd8zjvElbbXIJ8TU9h0EcO/1ZpGbAY+0XZOxefvv1HQXtr7yVIdNts0GfH6oPSGUAeswfnXEKJrGflVMd7EhBZpRJ6C1Kmokp8sCnLSMoMrjoHhwFz9Sr+qZ8+H9Q9XsuF4o42iqawfeZyRQIF4x0DyTfL0BFVhFH3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723262732; c=relaxed/simple;
	bh=n1qTkf0PwQ59B//afhTL/1aAU9z2u2nd+TAWev/OX4M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=SStE4wbz2Tt1a7/D5zipePBV9KrSEuy5v48u3Yr6NpnumwBMKUoQc+D3w52zZRma5aw+DYV3CY5YYNFacUkNRFIqhk/PtHBhKKAZpWyUzxiMX/NH10ntatM1ZaLem7V/sTk4JeBFrs62iyM6qPJMRaS7y3QeRMiKFD/CjsErSAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scdDS-003hgG-10;
	Sat, 10 Aug 2024 12:05:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 12:05:15 +0800
Date: Sat, 10 Aug 2024 12:05:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Waiman Long <longman@redhat.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, longman@redhat.com
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806174647.1050398-1-longman@redhat.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Waiman Long <longman@redhat.com> wrote:
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 53f4bc912712..0fa6c2895460 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>        ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>        ps.chunk_size = roundup(ps.chunk_size, job->align);
> 
> +       /*
> +        * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
> +        * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
> +        */
> +       if (!ps.chunk_size)
> +               ps.chunk_size = 1U;

Perhaps change the first ps.chunk_size assignment to use DIV_ROUND_UP
instead?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
