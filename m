Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E974C3F2D1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF9D2073B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCFBtb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:49:31 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46046 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFBtb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 20:49:31 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA273-0005lA-UF; Fri, 06 Mar 2020 12:49:19 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 12:49:17 +1100
Date:   Fri, 6 Mar 2020 12:49:17 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Dragos Rosioru (OSS)" <dragos.rosioru@oss.nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Horia Geanta <horia.geanta@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: dcp - fix scatterlist linearization for hash
Message-ID: <20200306014917.GE30653@gondor.apana.org.au>
References: <1582643152-17278-1-git-send-email-dragos.rosioru@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582643152-17278-1-git-send-email-dragos.rosioru@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 05:05:52PM +0200, Dragos Rosioru (OSS) wrote:
> From: Rosioru Dragos <dragos.rosioru@nxp.com>
> 
> The incorrect traversal of the scatterlist, during the linearization phase
> lead to computing the hash value of the wrong input buffer.
> New implementation uses scatterwalk_map_and_copy()
> to address this issue.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
> Signed-off-by: Rosioru Dragos <dragos.rosioru@nxp.com>
> ---
>  drivers/crypto/mxs-dcp.c | 58 +++++++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 30 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
