From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: drbg - Add select on sha256
Date: Thu, 11 Jun 2015 03:44:05 +0200
Message-ID: <2159049.9Iof2r5cDe@tachyon.chronox.de>
References: <20150611005510.GA9267@gondor.apana.org.au> <7796083.9xmz0KqbMC@tachyon.chronox.de> <20150611014004.GA9616@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46204 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbbFKBoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 21:44:12 -0400
In-Reply-To: <20150611014004.GA9616@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. Juni 2015, 09:40:04 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jun 11, 2015 at 03:37:38AM +0200, Stephan Mueller wrote:
> > Am Donnerstag, 11. Juni 2015, 08:55:10 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > > The hash-based DRBG variants all use sha256 so we need to add a
> > > select on it.
> > 
> > Would that be sufficient? We can have SHA1, SHA384 and SHA512 with the
> > current drbg_cores[] too.
> 
> Yes but only sha256 is used by default, no?

Yes, per default, that is true. Thus, if we care only about the default, then 
the patch is fine.

-- 
Ciao
Stephan
