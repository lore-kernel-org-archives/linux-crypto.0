Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91ECC4332D
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 19:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7E62311B
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 19:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhAFTTG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jan 2021 14:19:06 -0500
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:58802 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbhAFTTG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jan 2021 14:19:06 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 14:19:05 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id A447E1801A818;
        Wed,  6 Jan 2021 19:11:27 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id BB2925C0;
        Wed,  6 Jan 2021 19:10:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: push15_3e110e4274e4
X-Filterd-Recvd-Size: 2304
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 Jan 2021 19:10:39 +0000 (UTC)
Message-ID: <b84dadc2e98b1986dc800c5f6f202880ed905b38.camel@perches.com>
Subject: Re: [PATCH 05/10] dma: tx49 removal
From:   Joe Perches <joe@perches.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Date:   Wed, 06 Jan 2021 11:10:38 -0800
In-Reply-To: <20210105140305.141401-6-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
         <20210105140305.141401-6-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2021-01-05 at 15:02 +0100, Thomas Bogendoerfer wrote:
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[]
> diff --git a/drivers/dma/txx9dmac.h b/drivers/dma/txx9dmac.h
[]
> @@ -26,11 +26,6 @@
>   * DMA channel.
>   */
>  
> 
> -#ifdef CONFIG_MACH_TX49XX
> -static inline bool txx9_dma_have_SMPCHN(void)
> -{
> -	return true;
> -}
>  #define TXX9_DMA_USE_SIMPLE_CHAIN
>  #else
>  static inline bool txx9_dma_have_SMPCHN(void)

This doesn't look like it compiles as there's now an #else
without an #if


