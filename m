Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A4FC43334
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jun 2022 07:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380404AbiFQHI6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 03:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380437AbiFQHIy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 03:08:54 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE5A63395
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jun 2022 00:08:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m14so3170739plg.5
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jun 2022 00:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tKM3xvFOU9BbHzW/2uuQbOBzRGB1RdsYKFUv60RJdxg=;
        b=cRelYOHqlySdg56lDY7wDD8qCGwBPr6ibudSH7Nv65Po/RJ/3CLzsfO0mgLoMjfgCD
         L38K4ISu+JEI74X/i0H2oH+u6N0O9BUdCrfPbBkZIZ5WjqamLz5/6/bfLLQukSkWalnF
         Wo5bwLmyB1OE85RLdcwEBcBAXGCIPrfSXYvpcQhXhR99s+U6YyDsAPSzz/2SIMyNjV5Q
         7oH3X51UibU84QBz2HVuCsI0oYFEVf1OjU4rFhtOXnP8DFN7frZjtFAwA8Zudgaki/Xt
         2SJucg4GGn6clqwKgtOB98sV2PyApzJYCqRiwb501ccwZn08pfr4/rPeJ/N6MpIYcM1I
         SQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tKM3xvFOU9BbHzW/2uuQbOBzRGB1RdsYKFUv60RJdxg=;
        b=lZU0dZI7iDETFOH/QAiCQ51EPJbMslIo9KZete7OQiGF2tkYcz305TrL1bmkkJxuu/
         6AbR8I7Mxc1I8JLtJlcye1A69kcb5bPytBbxwVLtolegRgE86aL/pzXESMF45n8tFdtT
         USXrfTrxQkc7wIQK+Pp4yQeA9RlmQGzUGqSn2yp7oXAsOQ1CH/mmo8wct7754Sb+eqo6
         jupzsiTb+LrAYYFpZjqEtSLvWG590BH4N+zj9q4lIvkcoJXOq6yXYZHTQHLM4wI0w8oA
         xz708H2ONWdCDOSfHDMGZi3hcHD2LA027/QEOd3cTtMbmTxfTcM6i4yRAJAsQZC4BEdx
         RQqw==
X-Gm-Message-State: AJIora+xUJpL/4SIZc+YhgxBf2MVZL68vt1R7bXQneFclNQes4MbMakP
        KdvpBBVTX6xNnP/zuRzfQiTghQ==
X-Google-Smtp-Source: AGRyM1vh2901KtWuAh/a/NRuzghOqX+27vND6C04We/BO58wByPDazd2slZkqQgFHUupQSy9H5DqLQ==
X-Received: by 2002:a17:902:728f:b0:168:b18e:9e0d with SMTP id d15-20020a170902728f00b00168b18e9e0dmr8130408pll.174.1655449719851;
        Fri, 17 Jun 2022 00:08:39 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903028100b00163d4c3ffabsm2757868plr.304.2022.06.17.00.08.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jun 2022 00:08:39 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        dhowells@redhat.com, mst@redhat.com
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com, helei.sig11@bytedance.com,
        f4bug@amsat.org, berrange@redhat.com
Subject: [PATCH 3/4] crypto: remove unused field in pkcs8_parse_context
Date:   Fri, 17 Jun 2022 15:07:53 +0800
Message-Id: <20220617070754.73667-5-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220617070754.73667-1-helei.sig11@bytedance.com>
References: <20220617070754.73667-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

remove unused field 'algo_oid' in pkcs8_parse_context

Signed-off-by: lei he <helei.sig11@bytedance.com>
---
 crypto/asymmetric_keys/pkcs8_parser.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index e507c635ead5..f81317234331 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -21,7 +21,6 @@ struct pkcs8_parse_context {
 	struct public_key *pub;
 	unsigned long	data;			/* Start of data */
 	enum OID	last_oid;		/* Last OID encountered */
-	enum OID	algo_oid;		/* Algorithm OID */
 	u32		key_size;
 	const void	*key;
 	const void	*algo_param;
-- 
2.20.1

