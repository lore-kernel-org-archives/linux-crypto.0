Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50490 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbeLMKbi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:31:38 -0500
Date: Thu, 13 Dec 2018 18:31:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cavium/nitrox - Enabled Mailbox support
Message-ID: <20181213103132.ux5z3yszsgbxv57d@gondor.apana.org.au>
References: <20181204125521.4714-1-Jampala.Srikanth@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204125521.4714-1-Jampala.Srikanth@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 04, 2018 at 12:55:54PM +0000, Srikanth, Jampala wrote:
> Enabled the PF->VF Mailbox support. Mailbox message are interpreted
> as {type, opcode, data}. Supported message types are REQ, ACK and NACK.
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> ---
>  drivers/crypto/cavium/nitrox/Makefile         |   3 +-
>  drivers/crypto/cavium/nitrox/nitrox_csr.h     |  12 +-
>  drivers/crypto/cavium/nitrox/nitrox_debugfs.h |  22 ++
>  drivers/crypto/cavium/nitrox/nitrox_dev.h     |  61 +++++-
>  drivers/crypto/cavium/nitrox/nitrox_hal.c     | 114 +++++++---
>  drivers/crypto/cavium/nitrox/nitrox_hal.h     |   2 +
>  drivers/crypto/cavium/nitrox/nitrox_isr.c     |   8 +-
>  drivers/crypto/cavium/nitrox/nitrox_main.c    |   3 +-
>  drivers/crypto/cavium/nitrox/nitrox_mbx.c     | 204 ++++++++++++++++++
>  drivers/crypto/cavium/nitrox/nitrox_mbx.h     |   9 +
>  drivers/crypto/cavium/nitrox/nitrox_sriov.c   |  57 ++++-
>  11 files changed, 441 insertions(+), 54 deletions(-)
>  create mode 100644 drivers/crypto/cavium/nitrox/nitrox_debugfs.h
>  create mode 100644 drivers/crypto/cavium/nitrox/nitrox_mbx.c
>  create mode 100644 drivers/crypto/cavium/nitrox/nitrox_mbx.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
