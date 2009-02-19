From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Thu, 19 Feb 2009 12:08:47 +0800
Message-ID: <20090219040847.GA973@gondor.apana.org.au>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au> <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43655 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237AbZBSEIv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 23:08:51 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 12, 2009 at 04:19:40PM +0100, Geert Uytterhoeven wrote:
> On Tue, 10 Feb 2009, Herbert Xu wrote:
> > On Thu, Feb 05, 2009 at 05:24:51PM +0100, Geert Uytterhoeven wrote:
> > > > Well with the netlink parameters these can have variable lengths
> > > > depending on how many parameters the user supplies.
> > > 
> > > How can this be exported to userspace?
> > > How does this variable length parameter passing work? Do you have an example?
> > 
> > See how we use it for rtnetlink, e.g., in net/ipv4/ip_gre.c.
> > 
> > > Nothing in crypto/ seems to already use nla_*?
> > 
> > Well we don't have a user-space API yet :) But checkout the
> > discussions on this list.
> 
> I'm sorry, but this is a totally separate change, so I'm not going to do it
> right now.

Sorry but I disagree.  We're working on the user-space API right
now and having to redo the compression parameters API later because
we didn't take take user-space into account is just not acceptable.

In any case, the nla stuff is not as hard is it looks.  It's
going to add tens of lines to the setup code and that's it.

In order to get started, all you need to do is call nla_parse.
You don't even need a policy for the simple attributes.

Please let me know if you need more help in getting nla_parse
going.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
