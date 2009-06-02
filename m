From: Jarod Wilson <jarod@redhat.com>
Subject: Re: sha384 self-test failure oddity
Date: Tue, 2 Jun 2009 15:41:34 -0400
Message-ID: <200906021541.34774.jarod@redhat.com>
References: <20090602051027.GA24415@gondor.apana.org.au> <200906020901.42920.jarod@redhat.com> <20090602132038.GA29795@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39978 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZFBTm0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 15:42:26 -0400
In-Reply-To: <20090602132038.GA29795@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 02 June 2009 09:20:38 Herbert Xu wrote:
> On Tue, Jun 02, 2009 at 09:01:42AM -0400, Jarod Wilson wrote:
> >
> > > I can't reproduce this with 2.6.30-rc7.
> > 
> > I'll rebase my cryptodev tree to 2.6.30-rcX and see if I can still
> > reproduce the problem.
> 
> I just rebased cryptodev against 2.6.30-rc7 today so please let
> me know whether you can still reproduce it with cryptodev.

Still happens after the rebase. Kernel config here, if it helps:

http://jwilson.fedorapeople.org/misc/cryptodev-2.6-config

-- 
Jarod Wilson
jarod@redhat.com
