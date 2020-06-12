Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BABAC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 06:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED65F20836
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 06:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgFLGA1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 02:00:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38746 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgFLGA1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 02:00:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjcjn-0000GF-Jw; Fri, 12 Jun 2020 16:00:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Jun 2020 16:00:23 +1000
Date:   Fri, 12 Jun 2020 16:00:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Radu Solea <radu.solea@nxp.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Subject: crypto: caam - Fix argument type in handle_imx6_err005766
Message-ID: <20200612060023.GA943@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function handle_imx6_err005766 needs to take an __iomem argument
as otherwise sparse will generate two warnings.

Fixes: 33d69455e402 ("crypto: caam - limit AXI pipeline to a...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index f3d20b7645e0..8ecfa97c3188 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -469,7 +469,7 @@ static int caam_get_era(struct caam_ctrl __iomem *ctrl)
  * pipeline to a depth of 1 (from it's default of 4) to preclude this situation
  * from occurring.
  */
-static void handle_imx6_err005766(u32 *mcr)
+static void handle_imx6_err005766(u32 __iomem *mcr)
 {
 	if (of_machine_is_compatible("fsl,imx6q") ||
 	    of_machine_is_compatible("fsl,imx6dl") ||
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
