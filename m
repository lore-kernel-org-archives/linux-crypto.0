From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v7 2/3] crypto: rsa: add a new rsa generic
 implementation
Date: Wed, 17 Jun 2015 10:36:30 +0800
Message-ID: <20150617023630.GA7791@gondor.apana.org.au>
References: <20150616173101.1248.55033.stgit@tstruk-mobl1>
 <20150616173050.1248.21847.stgit@tstruk-mobl1>
 <18687.1434492657@warthog.procyon.org.uk>
 <5580DC30.4030301@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47741 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbbFQCgx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 22:36:53 -0400
Content-Disposition: inline
In-Reply-To: <5580DC30.4030301@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 07:32:16PM -0700, Tadeusz Struk wrote:
>
> I thought that -EBADMSG was mainly used for authenticated ciphers in case when verification of auth data fails.
> Since this are input params I thought that -EINVAL would be more appropriate.
> I can change it to -EBADMSG, no problem.
> Herbert, what do you think?

The existing crypto/asymmetric_key errno scheme doesn't really
mesh in with the rest of crypto.  So you'll just have to pick one
scheme and stick with it.

I don't really mind either way as long as the error codes are
unique and meaningful.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
