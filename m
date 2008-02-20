From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 01:26:20 +0800
Message-ID: <20080220172620.GE27726@gondor.apana.org.au>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, johnpol@2ka.mipt.ru
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52588 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753855AbYBTR0W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Feb 2008 12:26:22 -0500
Content-Disposition: inline
In-Reply-To: <47BC1E12.9050201@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 20, 2008 at 01:33:22PM +0100, Patrick McHardy wrote:
>
> I saw the discrepancy between the elen value used
> for aead_request_set_crypt() in esp_input() and the
> req->nbytes value seen in hifn_setup_session().

OK that is normal.  esp_input is now using the AEAD interface
so the size for the request includes the ICV.  By the time the
request gets to hifn it no longer has the ICV so it would be
12 bytes elss.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
