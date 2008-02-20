From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Wed, 20 Feb 2008 08:53:29 +0800
Message-ID: <20080220005329.GA21565@gondor.apana.org.au>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, johnpol@2ka.mipt.ru
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55099 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755044AbYBTAxb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Feb 2008 19:53:31 -0500
Content-Disposition: inline
In-Reply-To: <47BB036D.7090701@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 19, 2008 at 05:27:25PM +0100, Patrick McHardy wrote:
>
> Yes, probably. So I take it the assumption in HIFN that the
> sg-list length matches req->nbytes is incorrect?

Where were you seeing the discrepancy? If it's at the point of
entry into the HIFN code then the bug is further up.  If it's
within the HIFN code then I don't know where 12 came from either
since the ICV is not visible to it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
