From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Thu, 19 Feb 2009 18:42:51 +0800
Message-ID: <20090219104250.GA9633@gondor.apana.org.au>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au> <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au> <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41298 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751142AbZBSKmx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2009 05:42:53 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 19, 2009 at 10:12:18AM +0100, Geert Uytterhoeven wrote:
>
> IIUC, my setup() routines should decode the parameters using nla_parse()?

Right.

> And the caller of a setup() routine should encode the data. But how? All the
> nla_put*() routines seem to be targeted at skb's.

The callers in the kernel should just lay it out on the stack, e.g.,

	struct {
		struct nlattr foo;
		u32 foo_val;
		struct nlattr bar;
		u32 bar_val;
		...
	};

Note that the netlink alignment is 4 so u32 doesn't need any padding
though u8/u16 would need padding before the next nlattr.  Although
for our purposes u32 should be sufficient.

> The only place where nla_parse() is called with a void */length pair is
> net/sched/em_meta.c:em_meta_change(). But I can find no place where the actual
> TCA_EM_META_* fields are encoded.

For simple things like u32 the format is just header followed by
the u32.  See nla_get_u32 for details.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
