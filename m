Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90EAC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhKTE32 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:29:28 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56894 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhKTE31 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:29:27 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moHx6-0001I6-1k; Sat, 20 Nov 2021 12:26:12 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moHwy-0006i2-1a; Sat, 20 Nov 2021 12:26:04 +0800
Date:   Sat, 20 Nov 2021 12:26:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     weo@reccoware.de, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-aes: Reestablish the correct tfm context
 at dequeue
Message-ID: <20211120042603.GA25752@gondor.apana.org.au>
References: <20211027133001.332635-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027133001.332635-1-tudor.ambarus@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 27, 2021 at 04:30:01PM +0300, Tudor Ambarus wrote:
> In case there were more requests from different tfms in the crypto
> queue, only the context of the last initialized tfm was considered.
> 
> Fixes: ec2088b66f7a ("crypto: atmel-aes - Allocate aes dev at tfm init time")
> Reported-by: Wolfgang Ocker <weo@reccoware.de>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/crypto/atmel-aes.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
