From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Problems encountered with latest cryptodev-2.6 under UML
Date: Thu, 6 Dec 2007 10:42:28 +1100
Message-ID: <20071205234228.GA25314@gondor.apana.org.au>
References: <fd3e431c0712020759tbc41c91o39c0c3e56be66734@mail.gmail.com> <20071202212841.GA7343@gondor.apana.org.au> <fd3e431c0712050859x2e6c2d7bqc7c3e39cf243637@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3353 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbXLEXmc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Dec 2007 18:42:32 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712050859x2e6c2d7bqc7c3e39cf243637@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 06, 2007 at 12:59:27AM +0800, Tan Swee Heng wrote:
> Sorry for the lousy bug report. I misinterpreted git-pull's "Already
> up-to-date" to mean that it matches your tree exactly. Apparently that
> is not the case. I just git-clone and the current tree works fine.

Sorry, I had rebased my tree so you'd need to rewind your local
version before it would match.  I should've made an announcement :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
