From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Tcrypt output for HIFN 795x driver.
Date: Mon, 1 Oct 2007 21:15:57 +0800
Message-ID: <20071001131557.GA21361@gondor.apana.org.au>
References: <20071001124822.GA16017@2ka.mipt.ru> <20071001125105.GA19945@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3049 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754194AbXJANQD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Oct 2007 09:16:03 -0400
Content-Disposition: inline
In-Reply-To: <20071001125105.GA19945@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 01, 2007 at 04:51:06PM +0400, Evgeniy Polyakov wrote:
> Notice that 'testing ecb(aes) decryption across pages (chunking)' fails.
> I will investigate this further.

Thre aren't any ecb chunking tests.  Looks like it's the cbc
test that's failing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
