Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50113C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jan 2022 17:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiAVRJ6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jan 2022 12:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiAVRJ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jan 2022 12:09:58 -0500
X-Greylist: delayed 108 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Jan 2022 09:09:57 PST
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A146C06173B
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jan 2022 09:09:57 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc3a.ko.seznam.cz (email-smtpc3a.ko.seznam.cz [10.53.10.75])
        id 7719c8bb89ed7a11779746a3;
        Sat, 22 Jan 2022 18:09:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1642871395; bh=fpq8Nbwu1MXscMCBs7feSbWaonKy3kOVxBmxvPkfOH0=;
        h=Received:From:To:Subject:Date:Message-Id:Mime-Version:X-Mailer:
         Content-Type:Content-Transfer-Encoding:X-szn-frgn:X-szn-frgc;
        b=Y3/lp7INXlrw/ThPXwP3+zGX0P6nVeneFds/uK1hiy9N5p30dJRySrVCa2QXIgy9x
         ibfIP8uXhsdoS8ZD7oJCTc+Pp2KmR3PfCfAYpsv4DgOcuoGmHA93UoyX1jywGWqfhR
         mUvucJlH/rhHdYl5grbWlkme4YUntG+TQdLkezYo=
Received: from unknown ([::ffff:95.182.76.34])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Sat, 22 Jan 2022 18:07:53 +0100 (CET)
From:   "Tomas Paukrt" <tomaspaukrt@email.cz>
To:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: mxs-dcp - Fix scatterlist processing
Date:   Sat, 22 Jan 2022 18:07:53 +0100 (CET)
Message-Id: <T0R.ZXsl.2soFymqM66b.1Xx3df@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <697b78df-1da0-408b-ad5e-fb0bf38ccfe1>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a bug in scatterlist processing that may cause incorrect =
AES block encryption/decryption.

Fixes: 2e6d793e1bf0 ("crypto: mxs-dcp - Use sg_mapping_iter to copy data")=

Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
---
 drivers/crypto/mxs-dcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d19e5ff..d6f9e2f 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -331,7 +331,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async=
_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, sg_nents(src), i) {
+	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf =3D sg_virt(src);
 		len =3D sg_dma_len(src);
 		tlen +=3D len;
-- 
2.7.4 
