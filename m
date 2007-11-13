From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] stream: Stream cipher wrapper
Date: Tue, 13 Nov 2007 09:17:38 +0800
Message-ID: <20071113011737.GA29119@gondor.apana.org.au>
References: <fd3e431c0711061137lfa743abwa2be4d563d39e83b@mail.gmail.com> <20071111121151.GA14285@gondor.apana.org.au> <fd3e431c0711121144q30af79a3y577be15c1a842a8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4476 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825AbXKMBRk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 20:17:40 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711121144q30af79a3y577be15c1a842a8b@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 13, 2007 at 03:44:42AM +0800, Tan Swee Heng wrote:
>
> I agree that Salsa20 can be implemented this way as it is essentially
> a hash function in counter mode. However this is not true in general
> of other eSTREAM candidates. I am hoping to find a general solution
> for eSTREAM ciphers, not just Salsa20.

Well we already support at least one stream cipher, arc4 with
the cipher interface.

For stream ciphers that have IVs, they can just use the blkcipher
interface.  Is there anything else that's required?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
