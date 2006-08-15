From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Warning: cryptodev-2.6 to be rebased
Date: Tue, 15 Aug 2006 17:09:38 +1000
Message-ID: <20060815070938.GA30796@gondor.apana.org.au>
References: <20060806104937.GA30095@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54539 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S965233AbWHOHJp
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Aug 2006 03:09:45 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1GCt3U-00064r-DJ
	for <linux-crypto@vger.kernel.org>; Tue, 15 Aug 2006 17:09:40 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1GCt3T-0008IV-00
	for <linux-crypto@vger.kernel.org>; Tue, 15 Aug 2006 17:09:39 +1000
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060806104937.GA30095@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 06, 2006 at 08:49:37PM +1000, herbert wrote:
> 
> Due to upcoming changes in the tree I've decided rearrange the patches
> which means that the cryptodev-2.6 will soon be rebased.
> 
> So if you've made your own changes based on it now is the time to save
> your changes before you clone it again.

Sorry, I've had to rebase it again due to conflicts in the mm tree.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
