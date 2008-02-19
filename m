From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Tue, 19 Feb 2008 14:23:23 +0800
Message-ID: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au>
References: <47B2EDF9.6020900@trash.net>
Cc: linux-crypto@vger.kernel.org, johnpol@2ka.mipt.ru
To: kaber@trash.net (Patrick McHardy)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33739 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbYBSGXa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Feb 2008 01:23:30 -0500
In-Reply-To: <47B2EDF9.6020900@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
>
> I couldn't figure out where in the crypto code the
> nbytes decrement by 12 bytes compared to the length
> seen when setting up the crypto operation happens
> or I might have tried to properly fix it myself.
> I'll happily test patches in case someone more
> familiar with the code does a proper fix.

The usual ICV is 12 bytes long so that could be where it's coming
from.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
