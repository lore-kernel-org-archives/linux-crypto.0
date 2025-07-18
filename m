Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE3C2BDC1D;
	Fri, 18 Jul 2025 10:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836246; cv=none; b=VYR2dJ9Qa9fdSsjhICrkSw3RMT5IBvichAg/fTPccjYfPdwnLxKrZHetnNYUYHEWhN5btsnxh+QtVswNcKL+hg70vKEIFPOT4rvvjmbu6kjJsu2Da4t8881KJou1x9SMNQre0gZ9iAcXmBFYf5WyDlP44PmVnhJ7KF62+feAjG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836246; c=relaxed/simple;
	bh=D/2ONEPn5x3RlP0XDxP4LGlt7iZhDJSvGf4xsnoV94k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLJh9WuETLlvh31d6ncX2arWMHt6MUpC7/Q+W3E5CCrrTPluE8BGiymPimN3MWLuy9flPH5m04+SG0L0EMIlTIwGEgQI+A5QVo/yax7k4wXXGKhgNqaUi3d4PEwUwBLKkg9PNuvyupOCp/hmMB5fHK88/+f5ruQiGcSe9TzIDug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=B/RhhnCn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="B/RhhnCn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GfeGVLqaTw3EciNfGKSrH0BlEFzoUtY7Zvcj2pNDEAE=; b=B/RhhnCnMk9cq0S+bhDYXWm5Kf
	+5hZrmpG+mKqbzUQUW1mvt/tQXVB7rE5sGka0pimRKR5Js7uzKZYnMo1dGn1zDeGH4yeZgVfhbEOb
	/kSS0zzx7zfEKlIupiZOXYJ8unGxs2r/vVxVkGqHtOGN3yJkgUfUWJxL1XAKS0VgM1FX4Re43ROB9
	PeGLeqbxNZSlaGbycdM+ETNy+DIfi8Q1hdHV5Yx/KxqRZQt4eo28UTD+aC/VipCUO3KfC3qHaiKfm
	TQXwm5CCoM7xg3fmwW2NScBrf9+z7BKvUS//pqjhjer7i/kg6syg5Y8IlYjzhDOX04R6NCjXuK8Fo
	RrGwwsjg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciWp-007yYe-2z;
	Fri, 18 Jul 2025 18:57:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:57:20 +1000
Date: Fri, 18 Jul 2025 20:57:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Cc: 
	Thomas Gleinxer <tglx@linutronix.de>;
Subject: Re: [PATCH] cryptd: Use nested-BH locking for cryptd_cpu_queue
Message-ID: <aHookKMOLn-Z9Tk9@gondor.apana.org.au>
References: <20250701060936.r4gtQv9v@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701060936.r4gtQv9v@linutronix.de>

On Tue, Jul 01, 2025 at 08:09:36AM +0200, Sebastian Andrzej Siewior wrote:
> cryptd_queue::cryptd_cpu_queue is a per-CPU variable and relies on
> disabled BH for its locking. Without per-CPU locking in
> local_bh_disable() on PREEMPT_RT this data structure requires explicit
> locking.
> 
> Add a local_lock_t to the struct cryptd_cpu_queue and use
> local_lock_nested_bh() for locking. This change adds only lockdep
> coverage and does not alter the functional behaviour for !PREEMPT_RT.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> This patch requires a prerequisite for __local_lock_nested_bh() which
> has been made available at
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git local-lock-for-net
> 
> It can be pulled in so that the crypto bits are independent of the TIP
> tree.
> 
>  crypto/cryptd.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
