Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0552C32774
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 07:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbiHYHYj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 03:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbiHYHY3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 03:24:29 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4855A1A73
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 00:24:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c93so227167edf.5
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 00:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=gQxcBHRJVShSIzuqu+fpVGD7v7pjrBC+Zi7khlDmHGk=;
        b=E9dreWTcFMDrG08mD2zYOd5+KBAjLourBUzCVtWN+m9wZjTDKS2aRAke/zcdRJM03p
         4gL0AINTNy7hL6GYAKgTLNwiMnS/HvDdZMQDfLRFhkNP7ZMkp1p5LEJpk43GxafYs1f8
         xrVQT2bPxrBCZag/y6LyFQSiteex1p35ULyKNa9CBmlY1IexoeF+QUdbcqF7SozrmKrw
         bbPFKFJ5AvxrNU+EMgpAyy4yAnU95AwOfCOKnVqPhPC9Pr5jVd0c65bpBXGGxwP5bTV2
         ZSFUtjfjKKOgxU+wNYQ3sFJjQ8BHPKHVMM24ndoCD8sw+bhAsgfZ8XmbrIsMzIQNdWef
         s7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=gQxcBHRJVShSIzuqu+fpVGD7v7pjrBC+Zi7khlDmHGk=;
        b=jRjjRd8TY9motBl51uf58FFtfqGlwbzf9DOa4uR98s7N+B1WAlHN6lfqlTkoIAuUtg
         1GpD0IQbZiIpcTogmShPHoCOMTeAl8IzoIUOctsWiUY3rJcvUucVJZjE+0LT58Efgycv
         BH5nPMHaHVDgr8b1zldPX+F96Fpkkne+wHpkoOBh4qSTziMLkGnVLel93cuzKe0zzZuo
         YjD7xdK/LYYQ3v6IEdqZCQqRqCZvjuDkrlNoDe6Ej5wwCs2bdX3am9YmRA5/8mJLrTRl
         TgBWkaBogcvq3VLEzbcEYfKEg+PvMDOL7/D1haEHDK7PsTNx1lOTlmSfPxgNscNOwR/h
         Mkvw==
X-Gm-Message-State: ACgBeo2KGpTIbbW4aEBNTD0aLAtRmp597+suygODYo3jwAkvAVehufPj
        s5818iF6GUFRw4M1IcA7yks6Rw==
X-Google-Smtp-Source: AA6agR7C2vugiPgsw55AUwQFi2XqEMlX2z/d1CXNwONha/b564bpRm1mgwbx7OIW7zqT/yvv3Cv1gA==
X-Received: by 2002:a05:6402:540f:b0:440:d9a4:aebf with SMTP id ev15-20020a056402540f00b00440d9a4aebfmr2046291edb.196.1661412267134;
        Thu, 25 Aug 2022 00:24:27 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:142d:a900:eab:b5b1:a064:1d0d])
        by smtp.gmail.com with ESMTPSA id ky12-20020a170907778c00b0073ce4abf093sm2032281ejc.214.2022.08.25.00.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 00:24:26 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] crypto: ccree: Fix dma_map_sg error check
Date:   Thu, 25 Aug 2022 09:24:21 +0200
Message-Id: <20220825072421.29020-7-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825072421.29020-1-jinpu.wang@ionos.com>
References: <20220825072421.29020-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dma_map_sg return 0 on error, and dma_map_error is not supposed to use
here.

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: ce0fc6db38de ("crypto: ccree - protect against empty or NULL scatterlists")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 6140e4927322..9efd88f871d1 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -274,7 +274,7 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 	}
 
 	ret = dma_map_sg(dev, sg, *nents, direction);
-	if (dma_mapping_error(dev, ret)) {
+	if (!ret) {
 		*nents = 0;
 		dev_err(dev, "dma_map_sg() sg buffer failed %d\n", ret);
 		return -ENOMEM;
-- 
2.34.1

