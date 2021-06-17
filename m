Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C29C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 07:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D196101A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 07:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhFQH73 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 03:59:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50718 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhFQH73 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 03:59:29 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ltmtt-0003dD-2X; Thu, 17 Jun 2021 15:57:21 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ltmtk-0002jm-Gv; Thu, 17 Jun 2021 15:57:12 +0800
Date:   Thu, 17 Jun 2021 15:57:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Haren Myneni <haren@us.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: nx - Fix RCU warning in nx842_OF_upd_status
Message-ID: <20210617075712.GA10496@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function nx842_OF_upd_status triggers a sparse RCU warning when
it directly dereferences the RCU-protected devdata.  This appears
to be an accident as there was another variable of the same name
that was passed in from the caller.

After it was removed (because the main purpose of using it, to
update the status member was itself removed) the global variable
unintenionally stood in as its replacement.

This patch restores the devdata parameter.

Fixes: 90fd73f912f0 ("crypto: nx - remove pSeries NX 'status' field")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 67caff73f058..1491cbfbc071 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -538,13 +538,15 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
  * The status field indicates if the device is enabled when the status
  * is 'okay'.  Otherwise the device driver will be disabled.
  *
+ * @devdata: struct nx842_devdata to use for dev_info
  * @prop: struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 - Device is available
  *  -ENODEV - Device is not available
  */
-static int nx842_OF_upd_status(struct property *prop)
+static int nx842_OF_upd_status(struct nx842_devdata *devdata,
+			       struct property *prop)
 {
 	const char *status = (const char *)prop->value;
 
@@ -757,7 +759,7 @@ static int nx842_OF_upd(struct property *new_prop)
 		goto out;
 
 	/* Perform property updates */
-	ret = nx842_OF_upd_status(status);
+	ret = nx842_OF_upd_status(new_devdata, status);
 	if (ret)
 		goto error_out;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
