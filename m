Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5F8C6FD1D
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Mar 2023 04:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCOEeF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Mar 2023 00:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjCOEeD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2023 00:34:03 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8250A1C333
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 21:33:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pcI3K-004UZ5-SR; Wed, 15 Mar 2023 11:43:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Mar 2023 11:43:50 +0800
Date:   Wed, 15 Mar 2023 11:43:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ryan.Wanner@microchip.com
Cc:     linux-crypto@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Cyrille.Pitchen@microchip.com
Subject: Re: Crypto Testmgr test vector questions
Message-ID: <ZBE+9g5V7Mht6hQj@gondor.apana.org.au>
References: <818ff5fc-08cd-4081-4bbe-d0a66ea7d477@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <818ff5fc-08cd-4081-4bbe-d0a66ea7d477@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 14, 2023 at 09:20:27PM +0000, Ryan.Wanner@microchip.com wrote:
> 
> What is the goal of test vector 4 on alg:aead authenc-hmac-shaX-cbc-aes
> tests? I am trying to debug sam9x60ek board and only test vector 4 for
> authenc fails. I am curious what the goal of test vector 4 test is as
> this could help me in my debugging efforts.

Are you talking about "RFC 3602 Case 4"? The only difference that
I can see from "Case 3" (48 bytes) is that "Case 4" is longer (64 bytes).

You may want to insert some printks into testmgr.c to assess the
nature of the failure by dumping the output from your algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
