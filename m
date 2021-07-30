Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AD3C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 03:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC04460EB5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 03:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhG3DKZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:10:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51566 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhG3DKZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jul 2021 23:10:25 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m9Iud-0000dj-3J; Fri, 30 Jul 2021 11:10:15 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m9IuX-0003AU-LG; Fri, 30 Jul 2021 11:10:09 +0800
Date:   Fri, 30 Jul 2021 11:10:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] crypto: atmel-{aes, tdes}: Fix corner cases - crypto
 self tests
Message-ID: <20210730031009.GB12121@gondor.apana.org.au>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 20, 2021 at 11:55:26AM +0300, Tudor Ambarus wrote:
> The extra run-time crypto self tests hit some corner cases that were            
> not handled in the drivers. Fix some corner cases. Propose some cleaning        
> patches.      
> 
> Tudor Ambarus (9):
>   crypto: atmel-tdes: Clarify how tdes dev gets allocated to the tfm
>   crypto: atmel-tdes: Handle error messages
>   crypto: atmel-aes: Add blocksize constraint for ECB and CBC modes
>   crypto: atmel-aes: Add XTS input length constraint
>   crypto: atmel-aes: Add NIST 800-38A's zero length cryptlen constraint
>   crypto: atmel-tdes: Add FIPS81's zero length cryptlen constraint
>   crypto: atmel-{aes, tdes}: Set OFB's blocksize to 1
>   crypto: atmel-aes: Add fallback to XTS software implementation
>   crypto: atmel-aes: Allocate aes dev at tfm init time
> 
>  drivers/crypto/atmel-aes.c  | 146 +++++++++++++++++++++++++++---------
>  drivers/crypto/atmel-tdes.c |  66 +++++++---------
>  2 files changed, 138 insertions(+), 74 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
