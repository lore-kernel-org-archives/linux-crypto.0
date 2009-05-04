From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] add infrastructure for ansi_cprng self-tests
Date: Mon, 4 May 2009 19:48:03 +0800
Message-ID: <20090504114803.GA5445@gondor.apana.org.au>
References: <200904282127.33190.jarod@redhat.com> <200904282128.14153.jarod@redhat.com> <20090429105501.GE7227@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39752 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbZEDLsI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2009 07:48:08 -0400
Content-Disposition: inline
In-Reply-To: <20090429105501.GE7227@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 29, 2009 at 06:55:01AM -0400, Neil Horman wrote:
> On Tue, Apr 28, 2009 at 09:28:13PM -0400, Jarod Wilson wrote:
> > Add some necessary infrastructure to make it possible to run
> > self-tests for ansi_cprng. The bits are likely very specific
> > to the ANSI X9.31 CPRNG in AES mode, and thus perhaps should
> > be named more specifically if/when we grow additional CPRNG
> > support...
> > 
> > Successfully tested against the cryptodev-2.6 tree and a
> > Red Hat Enterprise Linux 5.x kernel with the follow-on
> > patch that adds the actual test vectors.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > 
> Thanks Jarod!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Both patches applied.  Thanks!

In future this should be moved to user-space where we can perform
more complicated tests such as entropy testing.

Of course we need to finish the user-space API first :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
