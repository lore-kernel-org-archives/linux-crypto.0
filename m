From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Transferring applied X.509 patches from crypto/next to
 security/next
Date: Tue, 9 Feb 2016 16:40:29 +0800
Message-ID: <20160209084028.GA9415@gondor.apana.org.au>
References: <20160206142705.GA23978@gondor.apana.org.au>
 <20160206074731.GF22220@gondor.apana.org.au>
 <20160202180848.2887.9937.stgit@tstruk-mobl1>
 <11215.1454752821@warthog.procyon.org.uk>
 <25680.1454939914@warthog.procyon.org.uk>
 <alpine.LRH.2.20.1602091200580.6966@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48965 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbcBIIkl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 03:40:41 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.1602091200580.6966@namei.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2016 at 12:01:19PM +1100, James Morris wrote:
> > 
> > If you can back them out, I'll apply them to my keys-next branch.  Unless
> > James is willing to rebase security/next on top of your crypto branch?
> > 
> 
> I don't want to rebase my tree.

OK, I've just reverted the patches and pushed it out.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
