From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] remove unnecessary variable in xfrm_output_resume()
Date: Wed, 13 Aug 2008 11:16:04 +1000
Message-ID: <E1KT4y4-0007n6-00@gondolin.me.apana.org.au>
References: <200808120812.26363.jcd@tribudubois.net>
Cc: linux-crypto@vger.kernel.org
To: jcd@tribudubois.net (Jean-Christophe Dubois)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44059 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbYHMBQH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Aug 2008 21:16:07 -0400
In-Reply-To: <200808120812.26363.jcd@tribudubois.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jean-Christophe Dubois <jcd@tribudubois.net> wrote:
> Small fix removing an unnecessary intermediate variable.
> 
> Signed-off-by: Jean-Christophe DUBOIS  <jcd@tribudubois.net>

Please send this to davem@davemloft.net and cc netdev@vger.kernel.org.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
