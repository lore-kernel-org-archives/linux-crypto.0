Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D721A2EC54B;
	Wed,  3 Sep 2025 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892625; cv=none; b=pHM5gsvKQZZ2ijHTjD2FgFvuqXIN8uqVbYfS+SL6sYzD6xuUh799lfxVDybYrnRRXmI45Vp534poMhaplDwis9YNH7kGPhSEffnUwIzVlbv1ZcAS2FqlyUK5TTX5S8BjsSqIDWRoJYE/VqOL+cbWibAb7B4mhXIiWNsqAjfThmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892625; c=relaxed/simple;
	bh=OQ+vrx681tl71W0sH3I5ZAXi5loKlF7ExWzTgxUxM7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pR8pFufyRZimgJcYztGTtdXX8rbj9t2oM/WM7dZzWiiOgMqtajFzkRaNmjTEESXxGM4rVwUi9gvXrE+T+c3Zgxj/CP3xIenkdkGO+TYAdGNhZ0KWoYBA2ZgQ5TIIe6hordOxC6+hc6jaU/3wmCsSvKrvzPRgKZum1CwfIanlnfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dIi62obN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dIi62obN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9d+/WbJg6wj+VAm0aoql4nUkSVy5cPH3NRVopYML9gc=; b=dIi62obN5xJX1j9ka4sKZiPa6u
	11938ggborukj0RLrNk9t8fyxuz5BIt37F5gKZ2/wC5a8V3AJQv5xXket2LLv6QBA3BP5b92VBVzV
	y2n3St7BEiQE12b3dmF6Y+y95jegZQP0DKLixs5POz7oTGj+Q8is9uNYdVFqFFjQ3f7PGl9DdflG1
	Rpcta2RxqeZmltueLi649ACvix1X3kvKQ0vc20881nkizo2zM5palovMyqY2vlUCx3fs/t8KV/RQs
	q5lMpiOIL/ETeIIyGrUlA9CFrimYl46n6lZM7Kd0Y/nbdQb47t2txRUf+jpGpC9OTki6VgfGCM1Zf
	A7kLMdsA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1utjm3-002Gp8-2s;
	Wed, 03 Sep 2025 17:43:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Sep 2025 17:43:24 +0800
Date: Wed, 3 Sep 2025 17:43:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>, tgraf@suug.ch,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] tracing: fprobe: fix suspicious rcu usage in fprobe_entry
Message-ID: <aLgNvJ3vBtgD9Mq0@gondor.apana.org.au>
References: <20250829021436.19982-1-dongml2@chinatelecom.cn>
 <20250828222357.55fab4c2@batman.local.home>
 <d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
 <20250901170655.0757884ad7c2afb63ced3230@kernel.org>
 <615da75d-cb2f-4e7e-9e11-6b19f03fea6c@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <615da75d-cb2f-4e7e-9e11-6b19f03fea6c@paulmck-laptop>

On Mon, Sep 01, 2025 at 08:00:15AM -0700, Paul E. McKenney wrote:
>
> If this is happening often enough, it would be easy for me to create an
> rcu_dereference_all_check() that allows all forms of vanilla RCU readers
> (but not, for example, SRCU readers), but with only two use cases,
> it is not clear to me that this is an overall win.

Hi Paul:

Please create such a helper.  Because the alternative is for me
to do something like this in rhashtable:

#define rht_dereference_rcu(p, ht) \
	rcu_dereference_check(p, lockdep_rht_mutex_is_held(ht) || \
				 rcu_read_lock_any_held())

This really makes no sense because rcu_read_lock_any_held is an
internal RCU implementation detail and has nothing to do with
rhashtable.

rhashtable is just a middle-man like RCU.  The actual context
(be it vanilla, bh or sched RCU) used is entirely up to the user.

Actually what puzzles me is why can't we just get rid of the
bh and sched variants of rcu_dereference? After all, there is
only one synchronize_rcu/call_rcu and it supports all three
variants.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
