From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: unaligned access in pkcs7_verify
Date: Tue, 13 Oct 2015 21:39:37 +0800
Message-ID: <20151013133936.GB7267@gondor.apana.org.au>
References: <20151008131519.GA24362@gondor.apana.org.au>
 <20151008144343.GE19655@oracle.com>
 <20151012133209.GA27746@gondor.apana.org.au>
 <20151012.070634.1545145319630456859.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sowmini.varadhan@oracle.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41900 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbbJMNjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:39:44 -0400
Content-Disposition: inline
In-Reply-To: <20151012.070634.1545145319630456859.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2015 at 07:06:34AM -0700, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Mon, 12 Oct 2015 21:32:09 +0800
> 
> > The sparc sha algorithms themselves need to declare the alignment
> > that they require.  Currently they claim to be able to handle any
> > alignment which appears to not be the case.
> 
> The sparc SHA assembler can handle arbitrary alignment.

Right.  The warnings that originated in sha1_sparc64 are probably
just the result of an unaligned desc structure caused by the bug
in pkcs7_verify.

Thanks for the confirmation.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
