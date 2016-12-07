From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: AF_ALG - fix AEAD tag memory handling
Date: Wed, 7 Dec 2016 19:50:17 +0800
Message-ID: <20161207115017.GB20525@gondor.apana.org.au>
References: <2319539.qMqmu7oTgO@positron.chronox.de>
 <20161207114245.GA20486@gondor.apana.org.au>
 <1650428.hiZ6moN7tX@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44859 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752013AbcLGLuY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 06:50:24 -0500
Content-Disposition: inline
In-Reply-To: <1650428.hiZ6moN7tX@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 07, 2016 at 12:49:25PM +0100, Stephan Müller wrote:
> Am Mittwoch, 7. Dezember 2016, 19:42:45 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> > 
> > Hmm, I don't see the code that copies the AAD over.  Did I miss it?
> 
> You do not miss it. As I mentioned in a previous email, I would like:
> 
> - to include the current patch around the tag now as it has been on the 
> mailing list for a long time -- that current patch fixes the superfluous 
> copying of the tag value. That fix of the tag handling is unrelated to any AAD 
> logic. However, it changes the user-visible memory structure and therefore the 
> user interface (i.e. during decryption, the returned data is smaller than it 
> used to be and during encryption, less data is required as input).
> 
> - the AAD handling with the copying over of data shall come in the next 
> development cycle for 4.10. That change is not user visible as it does not 
> change the memory structure and thus the user interface. Also, the AAD change 
> is unrelated to the tag change provided with this patch.

OK, thanks for explaining this Stephan.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
