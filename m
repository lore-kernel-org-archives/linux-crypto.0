From: David Howells <dhowells@redhat.com>
Subject: Re: Transferring applied X.509 patches from crypto/next to security/next
Date: Tue, 09 Feb 2016 15:43:00 +0000
Message-ID: <5856.1455032580@warthog.procyon.org.uk>
References: <20160209084028.GA9415@gondor.apana.org.au> <20160206142705.GA23978@gondor.apana.org.au> <20160206074731.GF22220@gondor.apana.org.au> <20160202180848.2887.9937.stgit@tstruk-mobl1> <11215.1454752821@warthog.procyon.org.uk> <25680.1454939914@warthog.procyon.org.uk> <alpine.LRH.2.20.1602091200580.6966@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbcBIPnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 10:43:04 -0500
In-Reply-To: <20160209084028.GA9415@gondor.apana.org.au>
Content-ID: <5854.1455032580.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > > If you can back them out, I'll apply them to my keys-next branch.  Unless
> > > James is willing to rebase security/next on top of your crypto branch?
> > > 
> > 
> > I don't want to rebase my tree.
> 
> OK, I've just reverted the patches and pushed it out.

Thanks.  Can I copy your Signed-off-by line into the patches or put you down
as an Acked-by?

David
