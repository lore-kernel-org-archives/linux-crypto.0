Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0155CCA6F
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2024 02:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722308208; cv=none; b=fwZ2iwVAbQuc5oVqsYJ1/qPFejhDzRA0jDgN0jlq71Zmv3sG0OjJXu9owtgwXq6KZdZum6JMHruWwDiIZov/b7Bc3rqvZ05NC2dwdm3Lf7lgxYbmq1iAHFY5r8PXgJZg6EN2WmRHNPjcGU6ZX0jBSzjO//qj9haPZ3QkzpYQsgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722308208; c=relaxed/simple;
	bh=Z+dpfELzHk4KdWS/EpByLNZKJEEfRT5q1v6V1XpbIhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JoF+s3/bUlo39eg1uDAkDcg4smD/L4DElZMG1JRWmfThFMpk0Vf3qVGfBtzHQgzREX/QaEcM1nSjEiHPedPB134qWYU7oEPjizJm90sqQdlqD3d1GR9sM1hXgE5cBAuaoXOVkJ+DfwUjYheb4BFMSpqqPYsOBMv8YMRVIjeabko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sYcu2-0014Sd-1N;
	Tue, 30 Jul 2024 10:56:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Jul 2024 10:56:39 +0800
Date: Tue, 30 Jul 2024 10:56:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi2 - use cpumask_var_t in
 dpaa2_dpseci_setup
Message-ID: <ZqhWZ6yrP4n6awn-@gondor.apana.org.au>
References: <Zqdd5VASjaXaac9Z@gondor.apana.org.au>
 <39d32499-d41d-4cbd-be3e-25f92ebd8df9@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39d32499-d41d-4cbd-be3e-25f92ebd8df9@nxp.com>

On Mon, Jul 29, 2024 at 02:50:00PM +0000, Horia Geanta wrote:
>
> 1. This patch does not apply cleanly on crypto tree
> 
> Patch depends on the patch set
> https://lore.kernel.org/linux-crypto/20240702185557.3699991-1-leitao@debian.org/
> which was merged via net-next.
> 
> I assume the dependency will be fixed with the crypto tree moving to v6.11-rc1.

Yes this is meant to be based on rc1.

> 2. I was not able to reproduce the issue
> 
> I tried on arm64 and i386 (with COMPILE_TEST=y) defconfigs.

I'm building on x86-64 with NR_CPUS set to 8192.

> I could reproduce the issue on arm64 only when modifying
> CONFIG_FRAME_WARN=2048 -> 1024.
> 
> Still, I would like to know your configuration, since there is a similar case
> in caam_qi_init() (drivers/crypto/caam/qi.c) which might need attention too.

Oops you're right.  Somehow this file didn't get rebuilt so I
missed the warning.  It does indeed give the same warning when
I force it to be rebuilt.

I'll send an updated patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
