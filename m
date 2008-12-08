From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2 v4] crypto: sha512 - Move message schedule W[80] to
	static percpu area
Date: Mon, 8 Dec 2008 08:24:35 +0800
Message-ID: <20081208002435.GA17916@gondor.apana.org.au>
References: <20081207113302.GB13736@gondor.apana.org.au> <1228688249887-git-send-email-ken@codelabs.ch> <12286882501412-git-send-email-ken@codelabs.ch> <20081208000919.GA14357@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian-Ken Rueegsegger <ken@codelabs.ch>,
	linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42181 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751027AbYLHAYo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 19:24:44 -0500
Content-Disposition: inline
In-Reply-To: <20081208000919.GA14357@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2008 at 03:09:19AM +0300, Evgeniy Polyakov wrote:
>
> >  static void
> > -sha512_transform(u64 *state, u64 *W, const u8 *input)
> > +sha512_transform(u64 *state, const u8 *input)
> >  {
> >  	u64 a, b, c, d, e, f, g, h, t1, t2;
> >  
> >  	int i;
> > +	u64 *W = get_cpu_var(msg_schedule);
> 
> This should be protected by preempt_disable(), shouldn't it?

get_cpu_var does it implicitly.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
