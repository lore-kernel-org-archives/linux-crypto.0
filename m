From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509
 certificate (-2)
Date: Thu, 5 May 2016 14:46:23 +0800
Message-ID: <20160505064623.GB4325@gondor.apana.org.au>
References: <45d1a06b-4ec4-17f5-2888-3068558da0bb@gmail.com>
 <20160503172536.GC20775@cucamonga.audible.transient.net>
 <20160430083248.GA20775@cucamonga.audible.transient.net>
 <26795.1462266613@warthog.procyon.org.uk>
 <11323.1462307740@warthog.procyon.org.uk>
 <20160504022608.GF20775@cucamonga.audible.transient.net>
 <21436.1462352509@warthog.procyon.org.uk>
 <d9898765-6024-ab7c-fbcb-8c5103e10173@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tstruk@gmail.com>,
	Jamie Heilman <jamie@audible.transient.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56419 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbcEEGqb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 02:46:31 -0400
Content-Disposition: inline
In-Reply-To: <d9898765-6024-ab7c-fbcb-8c5103e10173@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 06:38:46AM -0700, Tadeusz Struk wrote:
> Hi David
> On 05/04/2016 02:01 AM, David Howells wrote:
> > Do you want to push this via Herbert's tree?
> > 
> 
> Yes, I think Herbert has some more patches queued for rc-7.
> Let me also send a proper one with the signed-off tag.
> 
> ---8<---
> Subject: crypto: rsa - select crypto mgr dependency
> 
> The pkcs1pad template needs CRYPTO_MANAGER so it needs
> to be explicitly selected by CRYPTO_RSA.
> 
> Reported-by: Jamie Heilman <jamie@audible.transient.net>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
