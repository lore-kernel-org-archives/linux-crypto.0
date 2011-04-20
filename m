From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 7/8] tcrypt: disable 384 bit key XTS test
Date: Wed, 20 Apr 2011 08:33:50 +0800
Message-ID: <20110420003350.GB10285@gondor.apana.org.au>
References: <20110419192913.888086020@linux.vnet.ibm.com> <20110419193250.074519442@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: jang@linux.vnet.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50928 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1DTAdz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 20:33:55 -0400
Content-Disposition: inline
In-Reply-To: <20110419193250.074519442@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 19, 2011 at 09:29:20PM +0200, jang@linux.vnet.ibm.com wrote:
> From: Jan Glauber <jang@linux.vnet.ibm.com>
> 
> XTS mode is only defined for 256 and 512 bit key lengths. s390 only
> implements these two modes and running the test with a 384 bit key
> will stop the speed test with an error. Remove the superfluous key
> lenght.
> 
> Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

That's a limitation specific to your hardware.  As the existing xts
currently supports 384-bit keys, we can't remove it for compatibility
reasons.  So please add it as a fallback to your implementation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
