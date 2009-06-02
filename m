From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha384 self-test failure oddity
Date: Tue, 2 Jun 2009 23:20:38 +1000
Message-ID: <20090602132038.GA29795@gondor.apana.org.au>
References: <20090602051027.GA24415@gondor.apana.org.au> <200906020901.42920.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57948 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753763AbZFBNUi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 09:20:38 -0400
Content-Disposition: inline
In-Reply-To: <200906020901.42920.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 02, 2009 at 09:01:42AM -0400, Jarod Wilson wrote:
>
> > I can't reproduce this with 2.6.30-rc7.
> 
> I'll rebase my cryptodev tree to 2.6.30-rcX and see if I can still
> reproduce the problem.

I just rebased cryptodev against 2.6.30-rc7 today so please let
me know whether you can still reproduce it with cryptodev.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
