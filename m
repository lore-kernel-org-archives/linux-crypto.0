Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEB3C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23C3206D8
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="czDZLiSP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLTTDJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:03:09 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32853 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTDJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:03:09 -0500
Received: by mail-pl1-f194.google.com with SMTP id c13so4498537pls.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmyFDlcXcGUVwErxtLyLopVyByLsVIPIf4ZzlaJLh54=;
        b=czDZLiSPrCJQPEoDcJ+GHqutg2NlGxGlFhDnfzeETg+3xNjKoFpULauNEoQPcjKNfG
         cTDThmMxT80dLntbUdoh6AVLnbdGZyR6ocxF5feT2AmU6uF26eIfAgyG/+HlRxWgQXfn
         w1EYCaz2owJYPDWY1o2sfwkCkY0GrV0DCPqysdgN36seiJRB6JlRHfuMZdQeRgRlNA9m
         y0NhqKuwYSXxABU2POXsCssBwqu3AlVB2VFTOkDetUdvdOCpDDICPIFhhjXkX0G9fwMQ
         Icfb+TXcyaDyMKtHVt7k7qRtoHMEJtc+LANDjb00TVHYYwN4kZiTXLS3LPXIiv4zts3N
         VKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmyFDlcXcGUVwErxtLyLopVyByLsVIPIf4ZzlaJLh54=;
        b=Sz4hsssCQgwZyHvKmdk50B2oqVYjUDv2d/s8vO7rpTSzGy3Aegbl5RnDFgBnT2X2Eu
         BBm5wEGXQbUrpHzKBqLSci3sZaY+I8WjLxpVb9YliGJ/oW+9iKkSIYGzaLimXL1HTScR
         7aQa3LUSF9P6MVZITnJgbg0hzfvxRqHjxvtYnxRtV8LBya+xKEIUKzIzSGdM94PtZU5h
         6hs6+ejbgM/uiiU8PZi+RGt1JykAhdwtciiNJjbrhKq6Z0rpBsjpP0cxdXs7bmMB5nG3
         mFz2BHWfv3DtO3ScajF4ElFplgHBDTAoZJ9/ZCnVn2AEMwkL5HV+pUXZOBm511mlsxQB
         5CjQ==
X-Gm-Message-State: APjAAAUuCNs3mR/elbjRxxTnqnyOzTYuDNH4sKm1HBiRzS7XCFR0B92W
        +K9SgMYNCUHaxvuPQsveoPY=
X-Google-Smtp-Source: APXvYqx4B2IsR1nvhs+SJFpcDsxGvyDxL8HILTRabukLywiUu/vPr1T11V9CyrMQzL+2uG39mRGxng==
X-Received: by 2002:a17:902:6bcc:: with SMTP id m12mr16358252plt.272.1576868588173;
        Fri, 20 Dec 2019 11:03:08 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:03:07 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH 4/6] crypto: qce - update the skcipher IV
Date:   Fri, 20 Dec 2019 16:02:16 -0300
Message-Id: <20191220190218.28884-5-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the IV after the completion of each cipher operation.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
---
 drivers/crypto/qce/skcipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index a9ae356bc2a7..d3852a61cb1d 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -21,6 +21,7 @@ static void qce_skcipher_done(void *data)
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(crypto_skcipher_reqtfm(req));
 	struct qce_device *qce = tmpl->qce;
+	struct qce_result_dump *result_buf = qce->dma.result_buf;
 	enum dma_data_direction dir_src, dir_dst;
 	u32 status;
 	int error;
@@ -45,6 +46,7 @@ static void qce_skcipher_done(void *data)
 	if (error < 0)
 		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
+	memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
 	qce->async_req_done(tmpl->qce, error);
 }
 
