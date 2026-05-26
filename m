Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050DF3CC323;
	Tue, 26 May 2026 09:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786890; cv=none; b=KxZaRpRnnJFkJ5veSGybg/aKyrHMDqcdZ0lOkhpI43iEoajTUgl/B/ypkRFzuM25PMhINZY0JhQg1eJHjkWx+9GmDPQY1hwMelvl4ONyJYB7C89IEeOzqUPAbGrIOicW2oSJKjGF13f5axoRjIhJlGxQHO2CL6hBieiUhGh5524=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786890; c=relaxed/simple;
	bh=sOl8Rkw9+/2M7d4UC3V7c5NPRKpoDkw8aO6CDXIdTo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHnIDHBozDOY1gZ/r8jEJhBqnN6R74C9tOppwKipkAI7v/8cFokzjNOWezX9s7Knxe7+D5WT9B8YSxcRVPp2ovM/43ztKQvALHgh533y/jR75BuN1e6YD2gGsY1yzbaE01Jfx/IkvC6iNJzwbF5IhdoQX4MfBRXeoaRDWE1fBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=daDTV9n9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="daDTV9n9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3fqQZx9ytkjXndoI9KFls1YMB4CbOPSPqjFXxHgjOco=; 
	b=daDTV9n9hgrHn7FiM/yu1kUzW8YwvMLGFoaMMe/YJSsQaOJcEdba0hs0HFM/JeLJkO0RIRWGYOE
	+0B5V+fDLXe5gxy6yfzwhDeGCPTL/GiahagjTnYvYLIGqtbIA8ZXaVpvNHr4d1r6pRHxlHdPFGa/f
	6in5k7BeduLPZoZXb/kjz38FXgawEPRfD5jw3fllXwK6ZnwoUmyAPFdm3YbaCscM0qcXYYc1kFSKq
	hMnR2dOS9j8TuxUkWmvtKa31/Z7vq6W4aLkyfh1q1sGtFiLWWt/EEG4fbeZ2tzoWzW68EfK8g53hk
	7M3CMafDSpMMjZyWzRmCRjvPSisW0kEcd5vA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wRnrY-00HKzZ-21;
	Tue, 26 May 2026 17:14:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 May 2026 17:14:12 +0800
Date: Tue, 26 May 2026 17:14:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sock: add sock_kzalloc helper
Message-ID: <ahVkZOxZtFes6Huf@gondor.apana.org.au>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
 <ahBRCxCXbCq5LeCc@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahBRCxCXbCq5LeCc@linux.dev>

On Fri, May 22, 2026 at 02:50:19PM +0200, Thorsten Blum wrote:
> Hi Herbert,
> 
> On Mon, Apr 27, 2026 at 12:41:30PM +0200, Thorsten Blum wrote:
> > Add sock_kzalloc() helper - the sock equivalent to kzalloc().
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  include/net/sock.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index dccd3738c368..20bf406dff2d 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1904,6 +1904,11 @@ void sock_kfree_s(struct sock *sk, void *mem, int size);
> >  void sock_kzfree_s(struct sock *sk, void *mem, int size);
> >  void sk_send_sigurg(struct sock *sk);
> >  
> > +static inline void *sock_kzalloc(struct sock *sk, int size, gfp_t priority)
> > +{
> > +	return sock_kmalloc(sk, size, priority | __GFP_ZERO);
> > +}
> > +
> >  static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
> >  {
> >  	if (sk->sk_socket)
> 
> Can you take this series or should I resend this to net-next?

This patch needs an ack from the netdev maintainers.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
