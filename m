Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468FEC7EE22
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 07:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbjEKHnM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 03:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237535AbjEKHnH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 03:43:07 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992F210FD;
        Thu, 11 May 2023 00:43:02 -0700 (PDT)
Received: from martin by viti.kaiser.cx with local (Exim 4.89)
        (envelope-from <martin@viti.kaiser.cx>)
        id 1px0x2-0005kb-GR; Thu, 11 May 2023 09:43:00 +0200
Date:   Thu, 11 May 2023 09:43:00 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hwrng: imx-rngc - use bitfield macros to read fifo
 level
Message-ID: <20230511074300.ocfrmynne7e6wdkj@viti.kaiser.cx>
References: <20230427185357.923412-1-martin@kaiser.cx>
 <20230427185357.923412-2-martin@kaiser.cx>
 <ZFx6PXL9LzyDRoER@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFx6PXL9LzyDRoER@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: Martin Kaiser <martin@viti.kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thus wrote Herbert Xu (herbert@gondor.apana.org.au):

> On Thu, Apr 27, 2023 at 08:53:55PM +0200, Martin Kaiser wrote:

> > @@ -133,9 +133,7 @@ static int imx_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
> >  			break;

> >  		/* how many random numbers are in FIFO? [0-16] */
> > -		level = (status & RNGC_STATUS_FIFO_LEVEL_MASK) >>
> > -			RNGC_STATUS_FIFO_LEVEL_SHIFT;
> > -
> > +		level = FIELD_GET(RNGC_STATUS_FIFO_LEVEL, status);

> Wouldn't it be simpler to just get rid of the shift?

Yes, we're only checking that level > 0, there's no need for the shift.
I'll submit a new version of the patch.

Thanks,
Martin
