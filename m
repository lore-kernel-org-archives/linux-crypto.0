Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:54276 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbeK2VSd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 16:18:33 -0500
Date: Thu, 29 Nov 2018 18:13:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] crypto: cavium/nitrox - Enable interrups for PF in
 SR-IOV mode.
Message-ID: <20181129101340.tne6mlpop5kpmxaw@gondor.apana.org.au>
References: <20181121095200.6036-1-Jampala.Srikanth@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121095200.6036-1-Jampala.Srikanth@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 21, 2018 at 09:52:24AM +0000, Srikanth, Jampala wrote:
> Enable the available interrupt vectors for PF in SR-IOV Mode.
> Only single vector entry 192 is valid of PF. This is used to
> notify any hardware errors and mailbox messages from VF(s).
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_dev.h   | 15 +++-
>  drivers/crypto/cavium/nitrox/nitrox_isr.c   | 84 ++++++++++++++++++++-
>  drivers/crypto/cavium/nitrox/nitrox_isr.h   |  2 +
>  drivers/crypto/cavium/nitrox/nitrox_sriov.c | 51 +++++++++++--
>  4 files changed, 142 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
