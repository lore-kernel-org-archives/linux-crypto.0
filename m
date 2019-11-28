Return-Path: <SRS0=AT0s=ZU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FE9C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 02:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1CB2166E
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 02:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfK1CdU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 21:33:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:38572 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfK1CdU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 21:33:20 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ia9cC-0002xV-Vu; Thu, 28 Nov 2019 10:33:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ia9c8-0002j8-DD; Thu, 28 Nov 2019 10:33:04 +0800
Date:   Thu, 28 Nov 2019 10:33:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tudor.Ambarus@microchip.com
Cc:     Nicolas.Ferre@microchip.com, alexandre.belloni@bootlin.com,
        Ludovic.Desroches@microchip.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: atmel-tdes - Set the IV after {en,de}crypt
Message-ID: <20191128023304.m2uttrl7n55gydxj@gondor.apana.org.au>
References: <20191115134854.30190-1-tudor.ambarus@microchip.com>
 <642709fe-8cee-4c08-9a4a-05aa47d43c08@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642709fe-8cee-4c08-9a4a-05aa47d43c08@microchip.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 27, 2019 at 04:56:37PM +0000, Tudor.Ambarus@microchip.com wrote:
> 
> 
> On 11/15/19 3:49 PM, Tudor Ambarus - M18064 wrote:
> >  static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
> >  {
> >  	struct skcipher_request *req = dd->req;
> > @@ -580,6 +605,8 @@ static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
> >  
> >  	dd->flags &= ~TDES_FLAGS_BUSY;
> >  
> > +	atmel_tdes_set_iv_as_last_ciphertext_block(dd);
> 
> ECB mode does not use an IV, I should probably exclude the update of IV for the
> ECB mode. v2 will follow.

Please send an incremental patch as this one has already been
applied.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
