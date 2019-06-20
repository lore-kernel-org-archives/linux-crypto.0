Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EC4C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2109420449
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfFTIF4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 04:05:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43568 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfFTIFz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 04:05:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hds4o-0002CJ-VD; Thu, 20 Jun 2019 16:05:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hds4k-0007C0-6f; Thu, 20 Jun 2019 16:05:42 +0800
Date:   Thu, 20 Jun 2019 16:05:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, stefan.wahren@i2se.com,
        wahrenst@gmx.net, linux-crypto@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH 0/2] hwrng: Support for 7211 in iproc-rng200
Message-ID: <20190620080542.b5hrd2c5lxl7pejp@gondor.apana.org.au>
References: <20190510173112.2196-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510173112.2196-1-f.fainelli@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 10, 2019 at 10:31:09AM -0700, Florian Fainelli wrote:
> Hi Herbert,
> 
> This patch series adds support for BCM7211 to the iproc-rng200 driver,
> nothing special besides matching the compatibile string and updating the
> binding document.
> 
> Florian Fainelli (2):
>   dt-bindings: rng: Document BCM7211 RNG compatible string
>   hwrng: iproc-rng200: Add support for 7211
> 
>  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
>  drivers/char/hw_random/iproc-rng200.c                       | 1 +
>  2 files changed, 2 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
