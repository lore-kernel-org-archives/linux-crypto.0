From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 18:56:19 +0100
Message-ID: <1426701379.2258085.242143049.7A720D00@webmail.messagingengine.com>
References: <20150318095345.GA12923@zoho.com> <1712478.ujdQuuIYol@tauon>
 <1426681147.2164835.241982149.0C3DD661@webmail.messagingengine.com>
 <1867652.j97RWRfxn1@tauon> <550972A7.9030100@iogearbox.net>
 <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
 <20150318174136.GD5663@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Stephan Mueller <smueller@chronox.de>,
	mancha <mancha1@zoho.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42537 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbbCRR4U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 13:56:20 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id EC03820AB6
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2015 13:56:17 -0400 (EDT)
In-Reply-To: <20150318174136.GD5663@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 18, 2015, at 18:41, Theodore Ts'o wrote:
> Maybe we should add a kernel self-test that automatically checks
> whether or not memset_explicit() gets optimized away?  Otherwise we
> might not notice when gcc or how we implement barrier() or whatever
> else we end up using ends up changing.
> 
> It shold be something that is really fast, so it might be a good idea
> to simply automatically run it as part of an __initcall()
> unconditionally.  We can debate where the __initcall() lives, but I'd
> prefer that it be run even if the crypto layer isn't configured for
> some reason.  Hopefully such an self-test is small enough that the
> kernel bloat people won't complain.  :-)
> 
> 							 -Ted

Maybe a BUILD_BUGON: ;)

__label__ l1, l2;
char buffer[1024];
l1:
    memset(buffer, 0, 1024);
l2:
  BUILD_BUGON(&&l1 == &&l2);
