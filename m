Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339B5C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 23:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3130206A5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 23:48:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rqL6bhr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390606AbfIMXsj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 19:48:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45783 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390597AbfIMXsi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 19:48:38 -0400
Received: by mail-io1-f68.google.com with SMTP id f12so66282162iog.12;
        Fri, 13 Sep 2019 16:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GM8PB7dX+o/8qn6bAAUtttU+f7SZoyImDe+8xUZo7YE=;
        b=rqL6bhr+wZpI82VpkH0lghLYPfFzKW4vpMBu+cKu3dpDnhRTyKkTiZ+rxx2RHFQlpr
         yHzrOMmqcPVi3Br7ng3sP5MF5dz0U5XL++uzjStYZ5RrmYY89pPcCQgmd/aXPWIJAw3b
         SAEGanmvh6MEWQDoONuQvOurbv0fqYF6S3jsgtKSs+xIR9TCCbCsa2HNRgU8wvXgAwvW
         zJN7ulRnCCi13T5n/DCC9uoRvhaGloOkuA5bWhxXAXSfSUgXPG6jV41BSbTm42+JCTPu
         aDR2I9HKSk6LB+7l4LFELVpiaPhSFRgTsHD2e3RnKUTEYERChCk0Ywj0egzbV1MZmT68
         SQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GM8PB7dX+o/8qn6bAAUtttU+f7SZoyImDe+8xUZo7YE=;
        b=U9ksryWF1LtznJEA3z3Nck2ZkK0yftDssgeRP2yPx8CT3e0UtL73s6sci6Zle699VP
         TWfxIYzPjPSG+sO+K98an4ihuEU0jubGeX+mSG5nbt5XjuIm7bA+eRFE0/BVzmycoFdo
         Tja0P4ZTxWElqWwc/bsKOjrLx5QFCW+dgaOucRaiXFTeSL2lSwwlZwRR27M6IygXa9Xt
         IgmddbBVev7S+d53el1D4trVdj5EDxAj8WPAg+9SPuFcd4ZbypA5GIqQPptLu27crgb9
         Mf1harAJohZ1ZpwvU5fgz4Zd7ZdxmfovCgOCfl605DlOHlT/zbHKQTm6WVUfZNyNVGWo
         ZzZQ==
X-Gm-Message-State: APjAAAUiUtkAFMHmQfP106c9m/bxVzYTKDZXKji8KptLkcJlcO91KPIT
        w3IHlZhjYyp3i2QNEShdenQ=
X-Google-Smtp-Source: APXvYqwybFQ8OXkHoqS/pXQXiUwqO4qQLl6hFL1gJ7ZtFFEOb4A+/dKBgPQ4EPKEbKamlLAFJFcLgQ==
X-Received: by 2002:a5e:c107:: with SMTP id v7mr3041743iol.200.1568418516590;
        Fri, 13 Sep 2019 16:48:36 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id t9sm3944122iop.86.2019.09.13.16.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 16:48:36 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - release hmac_buf if ccp_run_sha_cmd fails
Date:   Fri, 13 Sep 2019 18:48:23 -0500
Message-Id: <20190913234824.8521-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In ccp_run_sha_cmd, if the type of sha is invalid, the allocated
hmac_buf should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/crypto/ccp/ccp-ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 9bc3c62157d7..cff16f0cc15b 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1782,6 +1782,7 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			       LSB_ITEM_SIZE);
 			break;
 		default:
+			kfree(hmac_buf);
 			ret = -EINVAL;
 			goto e_ctx;
 		}
-- 
2.17.1

