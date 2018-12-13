Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50436 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbeLMKUS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:20:18 -0500
Date: Thu, 13 Dec 2018 18:20:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: s.hauer@pengutronix.de, linux-crypto@vger.kernel.org,
        aymen.sghaier@nxp.com, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - fix setting IV after decrypt
Message-ID: <20181213102008.vlgnsy665poju27i@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB34855C6F8F7B08C0DF884B8898A50@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Horia Geanta <horia.geanta@nxp.com> wrote:
> On 12/7/2018 1:32 PM, Sascha Hauer wrote:
>> The crypto API wants the updated IV in req->info after decryption. The
>> updated IV used to be copied correctly to req->info after running the
>> decryption job. Since 115957bb3e59 this is done before running the job
>> so instead of the updated IV only the unmodified input IV is given back
>> to the crypto API.
>> 
> Saving IV before running the decryption was done to address in-place cbc
> decryption - when the last block is overwritten with plaintext before having the
> chance to copy it.

The API expects the IV to be set to the next IV value so that
chaining can be performed.  This can mean different things depending
on the algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
