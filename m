From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha256_ssse3 - fix stack corruption with SSSE3
 and AVX implementations
Date: Tue, 28 May 2013 13:53:05 +0800
Message-ID: <20130528055305.GA23966@gondor.apana.org.au>
References: <20130521140941.15997.83258.stgit@localhost6.localdomain6>
 <1369269124.27102.356.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, Julian Wollrath <jwollrath@web.de>,
	"David S. Miller" <davem@davemloft.net>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55845 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932844Ab3E1FxN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 01:53:13 -0400
Content-Disposition: inline
In-Reply-To: <1369269124.27102.356.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 22, 2013 at 05:32:04PM -0700, Tim Chen wrote:
> On Tue, 2013-05-21 at 17:09 +0300, Jussi Kivilinna wrote:
> > The _XFER stack element size was set too small, 8 bytes, when it needs to be
> > 16 bytes. As _XFER is the last stack element used by these implementations,
> > the 16 byte stores with 'movdqa' corrupt the stack where the value of register
> > %r12 is temporarily stored. As these implementations align the stack pointer
> > to 16 bytes, this corruption did not happen every time.
> > 
> > Patch corrects this issue.
> 
> Thanks for catching and fixing the issue.
> 
> Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
