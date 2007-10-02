From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] blkcipher: Add IV generation
Date: Tue, 02 Oct 2007 14:17:57 +0800
Message-ID: <E1Icb4v-0007St-00@gondolin.me.apana.org.au>
References: <200710020556.l925uG73011608@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: latten@austin.ibm.com (Joy Latten)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3361 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751596AbXJBGSA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Oct 2007 02:18:00 -0400
In-Reply-To: <200710020556.l925uG73011608@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Joy Latten <latten@austin.ibm.com> wrote:
>
> So, I am thinking CTR and some of the other modes,
> other than CBC, that use an IV will fail with this 
> change since they currently don't have an alg->geniv... 
> should they have a geniv similar to that of CBC, which 
> is gotten randomly?

The only other mode in the tree currently is ECB, which has
no IV at all.  Yes CTR should implement its own geniv that
simply uses the supplied sequence number (zero extended or
truncated if necessary).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
