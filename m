From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Problems encountered with latest cryptodev-2.6 under UML
Date: Mon, 3 Dec 2007 08:28:41 +1100
Message-ID: <20071202212841.GA7343@gondor.apana.org.au>
References: <fd3e431c0712020759tbc41c91o39c0c3e56be66734@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1766 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbXLBV2q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 16:28:46 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712020759tbc41c91o39c0c3e56be66734@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 02, 2007 at 11:59:51PM +0800, Tan Swee Heng wrote:
>
>     ... snipped...
>     testing cbc(des) encryption
>     test 1 (64 bit key):
>     setkey() failed flags=200000
> 
>     testing cbc(des) decryption
>     test 1 (64 bit key):
>     setkey() failed flags=200000

Yes as I said earlier geniv was broken.  I've since removed it from my
tree.  I have a fixed version here which I'll post as soon as I've fixed
gcm to use it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
