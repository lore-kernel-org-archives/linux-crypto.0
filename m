From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 13:41:36 -0400
Message-ID: <20150318174136.GD5663@thunk.org>
References: <20150318095345.GA12923@zoho.com>
 <1712478.ujdQuuIYol@tauon>
 <1426681147.2164835.241982149.0C3DD661@webmail.messagingengine.com>
 <1867652.j97RWRfxn1@tauon>
 <550972A7.9030100@iogearbox.net>
 <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Stephan Mueller <smueller@chronox.de>,
	mancha <mancha1@zoho.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47485 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbbCRRlm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 13:41:42 -0400
Content-Disposition: inline
In-Reply-To: <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Maybe we should add a kernel self-test that automatically checks
whether or not memset_explicit() gets optimized away?  Otherwise we
might not notice when gcc or how we implement barrier() or whatever
else we end up using ends up changing.

It shold be something that is really fast, so it might be a good idea
to simply automatically run it as part of an __initcall()
unconditionally.  We can debate where the __initcall() lives, but I'd
prefer that it be run even if the crypto layer isn't configured for
some reason.  Hopefully such an self-test is small enough that the
kernel bloat people won't complain.  :-)

							 -Ted
