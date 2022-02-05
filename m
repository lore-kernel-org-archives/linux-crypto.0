Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53292C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiBEEbY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:31:24 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34028 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379333AbiBEEbW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:31:22 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCj5-00023y-Ln; Sat, 05 Feb 2022 15:31:08 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:31:07 +1100
Date:   Sat, 5 Feb 2022 15:31:07 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        tudor.ambarus@microchip.com, UNGLinuxDriver@microchip.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel: add support for AES and SHA IPs available
 on lan966x SoC
Message-ID: <Yf39izQzTigjYKVm@gondor.apana.org.au>
References: <20220127080408.15791-1-kavyasree.kotagiri@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127080408.15791-1-kavyasree.kotagiri@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 01:34:08PM +0530, Kavyasree Kotagiri wrote:
> This patch adds support for hardware version of AES and SHA IPs
> available on lan966x SoC.
> 
> Tested-by: Vradha Panchal <vradha.panchal@microchip.com>
> Signed-off-by: Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
> ---
>  drivers/crypto/atmel-aes.c | 2 ++
>  drivers/crypto/atmel-sha.c | 2 ++
>  2 files changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
