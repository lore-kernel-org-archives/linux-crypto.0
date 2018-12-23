Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38984 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbeLWECv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:02:51 -0500
Date: Sun, 23 Dec 2018 12:02:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srikanth Jampala <jsrikanth@marvell.com>
Subject: Re: [PATCH] crypto: cavium/nitrox - Added AEAD cipher support
Message-ID: <20181223040248.b42xz7hxdjtbk63c@gondor.apana.org.au>
References: <20181214111856.32030-1-rnagadheeraj@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214111856.32030-1-rnagadheeraj@marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 14, 2018 at 11:19:51AM +0000, Nagadheeraj Rottela wrote:
> Added support to offload AEAD ciphers to NITROX. Currently supported
> AEAD cipher is 'gcm(aes)'.
> 
> Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
> Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
> ---
>  drivers/crypto/cavium/nitrox/Makefile          |   4 +-
>  drivers/crypto/cavium/nitrox/nitrox_aead.c     | 364 ++++++++++++++++
>  drivers/crypto/cavium/nitrox/nitrox_algs.c     | 559 +------------------------
>  drivers/crypto/cavium/nitrox/nitrox_common.h   |   6 +-
>  drivers/crypto/cavium/nitrox/nitrox_req.h      | 239 +++++++++--
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c   |  38 +-
>  drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 498 ++++++++++++++++++++++
>  7 files changed, 1103 insertions(+), 605 deletions(-)
>  create mode 100644 drivers/crypto/cavium/nitrox/nitrox_aead.c
>  create mode 100644 drivers/crypto/cavium/nitrox/nitrox_skcipher.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
