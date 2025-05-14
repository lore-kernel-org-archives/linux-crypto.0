Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F8C25F7AB;
	Wed, 14 May 2025 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747216469; cv=none; b=X/HkP12MkwNvIfaFQP79QaSs9mXJ9KnWCdtEdmHjhUF01Ddv8BHxSjDi2MiIm7jMp2SqeBUSdoC6aB8eKdwArevUP689TMTDBd6mCLt6IcVaoP6zl9B00DiQSu4eM/yhISD5yYz9ZCx6Dp2FCJjpBlCDRTA2HZaXMYSJaapmRHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747216469; c=relaxed/simple;
	bh=xJRu205muvimmnOERK1br8fSgz+PKau6h99JVGbMvkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGjm/B9LxCgyy5hTltDFURyBc5nP5e45IrHnbJDF/vAeutCan9ZmdK1HiH5ftG1VG5UWYmk4Bgvrq5/3XfiJ7vijHPhbCRQ02d3o2mb7Aw0fQX+mlwe7PIO5o0xnJhX/Gj5L4heLth/lXYHaZKI3de4YaSaEgZjTsEO3Yu0Gzfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FqHLQM61; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FqHLQM61"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WPWZBfEum618BqwEtmL57iPCgjdAwj1Te/R1Gu+4RHk=; b=FqHLQM61uA/rOmZEQxWzza3V6e
	eQE9M4X/CHs46P9Gi8kfEUMjKF6QZB7/++x0nnpp9MQSDMWehWha7wwy3pN8ISVe0eCfv0GCyXVi3
	yBNMxjUljNiePcREIhZKGkrjTwrichTnm176InAYy2HXfp4ttuxnMLh3VoQkhf6xqliRmi4jsJYf/
	0G1PfWACodspLnmZUmLUDyLTX3HijOGOHRhPdddo/+z4+2dmQ9cNynsPJtULYITZC8C02bwhucwCw
	OAevX/q04cGCUzmRomVp9evzbfDdDq20NnAkF7Uf/SqJElyL3K5GhKmitvoL4MIw4mMXg0XCkrZKd
	mD6nTJfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8oc-0060tO-2e;
	Wed, 14 May 2025 17:54:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:54:18 +0800
Date: Wed, 14 May 2025 17:54:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yury Norov <yury.norov@gmail.com>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Optimize rebalance_wq_table()
Message-ID: <aCRoStLRAibD-Jak@gondor.apana.org.au>
References: <20250508195952.391587-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508195952.391587-1-yury.norov@gmail.com>

On Thu, May 08, 2025 at 03:59:50PM -0400, Yury Norov wrote:
> The function opencodes for_each_cpu() by using a plain for-loop. The
> loop calls cpumask_weight() inside the conditional section. Because
> cpumask_weight() is O(1), the overall complexity of the function is
> O(node * node_cpus^2). Also, cpumask_nth() internally calls hweight(),
> which, if not hardware accelerated, is slower than cpumask_next() in
> for_each_cpu().
> 
> If switched to the dedicated for_each_cpu(), the rebalance_wq_table()
> can drop calling cpumask_weight(), together with some housekeeping code.
> This makes the overall complexity O(node * node_cpus), or simply speaking
> O(nr_cpu_ids).
> 
> While there, fix opencoded for_each_possible_cpu() too.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 35 +++++++++-------------
>  1 file changed, 14 insertions(+), 21 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
