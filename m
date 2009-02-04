From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: sha-s390 - Switch to shash
Date: Wed, 4 Feb 2009 11:05:22 +1100
Message-ID: <20090204000522.GA15100@gondor.apana.org.au>
References: <20090118225517.GA30510@gondor.apana.org.au> <20090128035615.GA13051@gondor.apana.org.au> <1233577246.18006.1.camel@localhost> <1233597667.1536.10.camel@localhost.localdomain> <20090203014806.GA32506@gondor.apana.org.au> <1233674182.1536.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Martin Schwidefksy <schwidefsky@de.ibm.com>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46829 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753280AbZBDAF3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2009 19:05:29 -0500
Content-Disposition: inline
In-Reply-To: <1233674182.1536.28.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 03, 2009 at 03:16:22PM +0000, Jan Glauber wrote:
>
> With this little typo-patch shash works fine on s390.

I'll fold this into the patch before pushing.  Thanks for testing!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
