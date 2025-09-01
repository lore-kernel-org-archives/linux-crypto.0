Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD78A2367A0;
	Mon,  1 Sep 2025 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756721216; cv=none; b=GTkaLmz/UhEsHx0AescICYcRFmiKs92Pkmbv86X7opmsG8/gL9QBgv9/K9zEyPQ2cWLMyxp9RT0zcaFnqZQLfcSXHFNCkTB0gIlFcUoNAFUanpZKMqv3vY3hyEiDKILGYeQUZNXAtx6MVr8Z7zhqLX0vi3mtqhZPghqUz55Po5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756721216; c=relaxed/simple;
	bh=NMgT7+2Wu1L0Gg+EeuxGwfiiInSVvIlnJwF0phUs5fM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JBtn1/z1TjRCzxOhWlrfYvAwxK+b5G1cZMNgKuQlFWCHe7upOJd/YwO6lLpMjUudL6iSMkCffz1dl22xGGKQFwztln415820K8X4NPtwBufrLiGNJFGGR6cMW9FIZpWSTlLUKKjeVLcFDipnr0uLjWHbvuE3Tii0TF7WC2i95UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EDjZcTq4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EDjZcTq4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jYmFp/s17zT5FFf+UElBkSANVdadPOQBRRIUD3BBnbw=; b=EDjZcTq4Qzb82Ye67AL4ILth7a
	iBgJXikce6Rb9yLovJTBpT0/yVyLGfI72Qu9fa7zGPwWsfzR5/a7Z3HLayj5QB7hqdK62DXxWADWy
	UP6d3ltHktl5ZS9Q8y0XMNcPP5IaGonRKhyYDFVhMX3k5qtH95krwlCUFsbM7nmkgnSC+XvK5hO6l
	kBmIFTotvPpeYGQfEoatFBpgoKGcZRCGHVckbgd0B46N6RuMljeZ0OBdOk+FmRpdteHolIRB+iepJ
	5fKqvyEi1GnSdEQZX4oud6WT6J2E8qQDj1rSLZag8EZ/VvrNRh7cTWU5gwQcXSfhgY4KGnVXFKGDJ
	WzIbWMTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ut1Au-001fs3-2R;
	Mon, 01 Sep 2025 18:06:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 01 Sep 2025 18:06:05 +0800
Date: Mon, 1 Sep 2025 18:06:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: paulmck@kernel.org
Cc: rostedt@goodmis.org, dongml2@chinatelecom.cn, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, oliver.sang@intel.com,
	tgraf@suug.ch, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] tracing: fprobe: fix suspicious rcu usage in fprobe_entry
Message-ID: <aLVwDR_NJSAGaHdf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Paul E. McKenney <paulmck@kernel.org> wrote:
>
> Yes, preempt_disable() does indeed start an RCU read-side critical section,
> just as surely as rcu_read_lock() does.
> 
> However, this is a lockdep check inside of __rhashtable_lookup():
> 
>        rht_dereference_rcu(ht->tbl, ht)
> 
> Which is defined as:
> 
>        rcu_dereference_check(p, lockdep_rht_mutex_is_held(ht));
> 
> This is explicitly telling lockdep that rcu_read_lock() is OK and
> holding ht->mutex is OK, but nothing else is.

I think that's a deficiency in rcu_dereference_check.

Yes I could certainly add a preemption check to rht_dereference_rcu,
but that makes zero sense because this is an implementation detail
of RCU and there is no reason why this logic should be added to
rhashtable.

rhashtable never relies on the fact that turning off preemption
creates is safe for RCU reads, so it makes no sense to add this
logic to rht_dereference_rcu since RCU could conceivably (even
if it is unlikely) be changed on day so that turning off preemption
is no longer safe for RCU reads.

My preference would be to add the preemption test to
rcu_dereference_check, or if that is not possible for some reason,
create a new RCU helper that includes the preemption test.

Of course just adding RCU read locks as this patch does is also
fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
