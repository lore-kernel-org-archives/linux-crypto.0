Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F05C433C1
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 07:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E2561A48
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 07:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhCZHRM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 03:17:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33668 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhCZHQm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 03:16:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lPghR-00012L-1v; Fri, 26 Mar 2021 18:16:06 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Mar 2021 18:16:04 +1100
Date:   Fri, 26 Mar 2021 18:16:04 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Dragos Rosioru (OSS)" <dragos.rosioru@oss.nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Marek Vasut <marex@denx.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] crypto: dcp - add power management support
Message-ID: <20210326071604.GB14594@gondor.apana.org.au>
References: <1616113377-24703-1-git-send-email-dragos.rosioru@oss.nxp.com>
 <1616113377-24703-2-git-send-email-dragos.rosioru@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616113377-24703-2-git-send-email-dragos.rosioru@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 19, 2021 at 02:22:57AM +0200, Dragos Rosioru (OSS) wrote:
> From: Dragos Rosioru <dragos.rosioru@nxp.com>
> 
> Added suspend/resume operations for PM support in the DCP driver.
> After a suspend/resume cycle DCP would still be in a low-power mode
> and have its clocks gated, thus requiring state to be saved beforehand:
> - Control register value(DCP_CTRL)
> - Channel control register value(DCP_CHANNELCTRL)
> 
> Signed-off-by: Dragos Rosioru <dragos.rosioru@nxp.com>
> ---
>  drivers/crypto/mxs-dcp.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index d6a7784..6748a4a 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -23,6 +23,10 @@
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
>  
> +#ifdef CONFIG_PM_SLEEP
> +#include <linux/freezer.h>
> +#endif

Please find a way to rework this patch so that it's not full of
these ifdefs.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
