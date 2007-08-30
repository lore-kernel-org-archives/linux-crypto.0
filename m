From: "Ronen Shitrit" <rshitrit@marvell.com>
Subject: RE: [PATCH 8/8] [CRYPTO] aead: Add authenc
Date: Thu, 30 Aug 2007 14:00:43 +0300
Message-ID: <B9FFC3F97441D04093A504CEA31B7C4101BB3D4D@msilexch01.marvell.com>
References: <20070830083900.GA15936@gondor.apana.org.au> <E1IQfas-0004C1-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Thomas Graf" <tgraf@suug.ch>,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shoshil.marvell.com ([199.203.130.250]:14268 "EHLO
	il.marvell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399AbXH3LB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 07:01:58 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi

That was quick :)

This patch is a wrapper for the encryption and hash operations, which
mean the HW engine will do the encryption, and then the SW will do the
hash.

Is this the combined mode that was discussed on the mailing list before?
Is there a plan to add support for HW engines that can run the
encryption and authentication as one operation?

BTW: will the kernel IPsec patch that uses this AEAD API will be
submitted on this mailing list as well?

Thanks
Ronen Shitrit


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Thursday, August 30, 2007 11:42 AM
> To: Linux Crypto Mailing List; Thomas Graf; Herbgert Xu
> Subject: [PATCH 8/8] [CRYPTO] aead: Add authenc
> 
> [CRYPTO] aead: Add authenc
> 
> This patch adds the authenc algorithm which constructs an AEAD
algorithm
> from an asynchronous block cipher and a hash.  The construction is
done
> by concatenating the encrypted result from the cipher with the output
> from the hash, as is used by the IPsec ESP protocol.
> 
> The authenc algorithm exists as a template with four parameters:
> 
> 	authenc(auth, authsize, enc, enckeylen).
> 
> The authentication algorithm, the authentication size (i.e.,
truncating
> the output of the authentication algorithm), the encryption algorithm,
> and the encryption key length.  Both the size field and the key length
> field are in bytes.  For example, AES-128 with SHA1-HMAC would be
> represented by
> 
> 	authenc(hmac(sha1), 12, cbc(aes), 16)
> 
> The key for the authenc algorithm is the concatenation of the keys for
> the authentication algorithm with the encryption algorithm.  For the
> above example, if a key of length 36 bytes is given, then hmac(sha1)
> would receive the first 20 bytes while the last 16 would be given to
> cbc(aes).
> 
