From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
Date: Thu, 3 May 2007 11:35:11 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0705031132220.24982@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au> <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
 <87r6pyqg2b.fsf@pelargir.dolphinics.no> <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
 <Pine.LNX.4.61.0705031719080.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seahorse.shentel.net ([204.111.1.244]:41994 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031125AbXECPlj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 11:41:39 -0400
In-Reply-To: <Pine.LNX.4.61.0705031719080.18504@yvahk01.tjqt.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> >There's no reason for any non-UTF-8 to be in the tree at all, so 
> >eventually it won't be a problem. I'm (slowly but surely) working on 
> >converting everything in the tree. GCC handles UTF-8 just fine, and all 
> 
> In fact, GCC gives a crap about comments :)
> and otherwise sees things as octets, not characters.
> I think GCJ is the only one that really pays attention to encoding.

The changes to the keymap files and so forth aren't quite as simple 
though. Have to convert the latin1 characters within character-constant 
expressions to \0 notation, while the comments can be left as utf8.

> >non-stupid/non-broken distributions of GNU/Linux and other major Un*ces 
> >should be based on (or at least compatible with) UTF-8 in basic 
> >operations. Files like the keymaps will be more work to convert, but they 
> >can be as well.
> >
> >I'm operating on the assumption that anything in the tree that isn't UTF-8 
> >is ISO-8859-1. Of course, I'm also checking it by hand to make sure a 
> >small-O-with-umlaut doesn't become the Klingon logo...
> 
> This is probably all you'll ever see:
> http://lkml.org/lkml/2007/1/8/222

Does this mean you're doing it and I'll be ignored, or that few people 
care and I'll be ignored? I figure if I just repost my patches to LKML 
once per month, they'll eventually get merged (or at least I'll get 
comments on how people actually want them). Things are tough on a 
high-volume list. I think the git method may have the best chance of 
success. We'll see.
