Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:54264 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbeK2VS0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 16:18:26 -0500
Date: Thu, 29 Nov 2018 18:13:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Nagadheeraj, Rottela" <Rottela.Nagadheeraj@cavium.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
Subject: Re: [PATCH 1/1] crypto: cavium/nitrox - crypto request format changes
Message-ID: <20181129101332.ungdx2lqijadq7ql@gondor.apana.org.au>
References: <20181121073628.17039-1-rottela.nagadheeraj@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121073628.17039-1-rottela.nagadheeraj@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 21, 2018 at 07:36:58AM +0000, Nagadheeraj, Rottela wrote:
> nitrox_skcipher_crypt() will do the necessary formatting/ordering of
> input and output sglists based on the algorithm requirements.
> It will also accommodate the mandatory output buffers required for
> NITROX hardware like Output request headers (ORH) and Completion headers.
> 
> Signed-off-by: Nagadheeraj Rottela <rottela.nagadheeraj@cavium.com>
> Reviewed-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_algs.c   | 111 ++++++++++-
>  drivers/crypto/cavium/nitrox/nitrox_req.h    |  94 ++++++----
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 266 ++++++---------------------
>  3 files changed, 227 insertions(+), 244 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
