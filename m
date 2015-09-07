From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Mon, 07 Sep 2015 10:38:39 +0100
Message-ID: <30536.1441618719@warthog.procyon.org.uk>
References: <20150829065552.GA18342@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Marcel Holtmann <marcel@holtmann.org>,
	tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	dwmw2@infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbbIGJip (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 05:38:45 -0400
In-Reply-To: <20150829065552.GA18342@gondor.apana.org.au>
Content-ID: <30535.1441618719.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > I am not in favor of just hacking in this split until the semantics are
> > actually understood. As said, the right solution from my point of view is
> > to remove setkey from akcipher and replace it with setkeyid instead.
> 
> It's the keys system that should not be decoding the keys since
> it doesn't know what to do with them.  The keys system should not
> have any algorithm-specific knowledge in it.  You need to have
> algorithm-specific knowledge to parse the keys, so that's why
> the parsing should happen in the crypto API and not in the key
> storage system.

You're right and wrong, I think.

The asymmetric key type should be calling akcipher to do the algorithmic
stuff, yes, *but* the key must also be parsed on loading to check that the
bits we require for a particular algorithm are there.

Now this could be done by starting up an akcipher blob and loading the key
data into it to see if it croaks on initialisation (which will presumably
check the contents of the data blob), but we wouldn't necessarily be able to
actually *use* the key at this point.

David
