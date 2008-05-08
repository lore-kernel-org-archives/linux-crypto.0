From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC, TCRYPT]: Catch cipher destination memory corruption
Date: Thu, 08 May 2008 13:52:14 +0800
Message-ID: <E1Jtz38-0000J0-00@gondolin.me.apana.org.au>
References: <482164FE.4020208@trash.net>
Cc: linux-crypto@vger.kernel.org
To: kaber@trash.net (Patrick McHardy)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42471 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbYEHFwT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2008 01:52:19 -0400
In-Reply-To: <482164FE.4020208@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Patrick:

Patrick McHardy <kaber@trash.net> wrote:
> 
> This patch adds checks to tcrypt to catch destination buffer
> corruption for cipher tests across pages, which was useful
> while fixing corruption caused by the HIFN driver.

This seems like a pretty useful check.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
