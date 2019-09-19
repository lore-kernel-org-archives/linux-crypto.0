Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2799CC49ED7
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 16:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1EA621927
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 16:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBvRSHwQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404061AbfISQFE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 12:05:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37739 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404060AbfISQFE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 12:05:04 -0400
Received: by mail-io1-f65.google.com with SMTP id b19so9034185iob.4;
        Thu, 19 Sep 2019 09:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I36Yq2VwXBdLTsy979OXOJLPrf5I1O04uwmTwfk7AV0=;
        b=mBvRSHwQhaiwSHy+grn5OzxBpH/5Wz/XXFK+oCIKRx1CQ42bj/yMQM7F8U9m20+5vp
         LsinHDd6aJQaqzp3ENiu6ksW/RNxH/miqtR8eZII+AbtMRWregMnmj6LAEbmw4khObgj
         YvMgUTZRGBWBvB6y28l7GhnSzcQIvIeZqS6k7cvDm2c76dtMBtSJx0ypJhbo3dqQ1zwQ
         gCSC3KCpTio4j1lt0TwrAw7XY2UEcTpJsxAKQHd83O5t1W4NsdCsGbQl+ucb3bIk92su
         UT6imsMlxAiuIwtVjO46s/t2UtOttudfVMD288QdJy8loTF6l98nue+4Sb8kZ6TWkNq1
         gn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I36Yq2VwXBdLTsy979OXOJLPrf5I1O04uwmTwfk7AV0=;
        b=el+Pnfg+Fbje+qxec2DzdDddnHu+vJDzMCKjGP0Fghi2KVKHk1pE6w8BJg2ps4JNmx
         E1l587E5bLTa7mdOxWR2bIYaZtYFOhcZorOlKaLXeVi+AV7q+8fqGdCxzLpncpM4zy5P
         /63qfy3KibwqMEttbu670JGr4z+fOubdCUtCZzuNnxBpBn0RuQEwKaGVJvqpz4hPh+7v
         qiVXONZ//G4wkcjJn6FM0amcczxe+HThcktIEexYlqvqrgGt6VoegggjuaZqvZ2LiW/s
         ClY+0Xwrh8iQN+evDuyAs0r7/Px5xHDIBjDJyDMMEPsC/r5HQ0dsPkii+McBImXW8kGd
         8uNg==
X-Gm-Message-State: APjAAAXVos459A0JGI50yZskZIHW+eMx/jBuU2Ccm4BV7yhf9aQeAp7H
        2O0CL6HXje2nIEQMUWSG4LOFiAY+eZ8=
X-Google-Smtp-Source: APXvYqy5MiUiVetTSZ6weYK7h2G0HbJvg8EoGoDMZN3TqjAR6UODgxa2cp1ASQ5wkOShprtBASzzbQ==
X-Received: by 2002:a5d:8908:: with SMTP id b8mr918621ion.237.1568909102290;
        Thu, 19 Sep 2019 09:05:02 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id g8sm5902449ioc.0.2019.09.19.09.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 09:05:01 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     ghook@amd.com
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: ccp - Release all allocated memory if sha type is invalid
Date:   Thu, 19 Sep 2019 11:04:48 -0500
Message-Id: <20190919160449.4303-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <7ffc6a77-f4e3-7db9-4ec6-53d6e01d881d@amd.com>
References: <7ffc6a77-f4e3-7db9-4ec6-53d6e01d881d@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Release all allocated memory if sha type is invalid:
In ccp_run_sha_cmd, if the type of sha is invalid, the allocated
hmac_buf should be released.

v2: fix the goto.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/crypto/ccp/ccp-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 9bc3c62157d7..440df9208f8f 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1782,8 +1782,9 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			       LSB_ITEM_SIZE);
 			break;
 		default:
+			kfree(hmac_buf);
 			ret = -EINVAL;
-			goto e_ctx;
+			goto e_data;
 		}
 
 		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
-- 
2.17.1

