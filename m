From: David Howells <dhowells@redhat.com>
Subject: Re: KEYS: Use skcipher for big keys
Date: Wed, 22 Jun 2016 15:23:14 +0100
Message-ID: <687.1466605394@warthog.procyon.org.uk>
References: <20160622141353.GA456@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Kirill Marinushkin <k.marinushkin@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbcFVOXQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:23:16 -0400
In-Reply-To: <20160622141353.GA456@gondor.apana.org.au>
Content-ID: <686.1466605394.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> I'm in the process of removing blkcipher/ablkcipher which have
> been replaced with skcipher.  It would be nice if we stop adding
> new users of these two interfaces :)
> 
> Anyway, if you guys are OK with this patch I'd like to push it
> through cryptodev so I can carry on with the removal of blkcipher.

As long as it only touches the big_key code inside keyrings, I think that's
fine.

Acked-by: David Howells <dhowells@redhat.com>
