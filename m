From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: key retention service: DH support
Date: Wed, 25 May 2016 18:25:28 +0800
Message-ID: <20160525102528.GA16101@gondor.apana.org.au>
References: <1884439.7dZQH0lY4q@tauon.atsec.com>
 <2025704.nsKCcck7Ux@tauon.atsec.com>
 <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com>
 <1542958.TuajgKVjUG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59862 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbcEYKZp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 06:25:45 -0400
Content-Disposition: inline
In-Reply-To: <1542958.TuajgKVjUG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 24, 2016 at 06:45:09PM +0200, Stephan Mueller wrote:
> Am Dienstag, 24. Mai 2016, 09:22:22 schrieb Mat Martineau:
> 
> Hi Mat, Herbert
> > 
> > KDF transformations would be extremely useful, but transforming the DH
> > output using a KDF needs to be configurable. There are enough different
> > uses for DH that it's important to have access to the raw values.
> > 
> > Since the KDF patches are not yet merged, I'm not sure of the best way to
> > accomodate the future feature. We could future-proof KEYCTL_DH_COMPUTE by
> > adding a 5th arg, an optional pointer to KDF configuration (NAME and
> > LABEL). Or a separate KEYCTL_DH_COMPUTE_KDF command can be added later.
> 
> With that statement, Herbert, should we start looking into my KDF patches 
> after the merge window closes?

Sure.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
