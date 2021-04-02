Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D35C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 17:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E1561151
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 17:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBRON (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 13:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbhDBROM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 13:14:12 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38D6AC0613E6;
        Fri,  2 Apr 2021 10:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=hJAQBlrcqq
        but7M44YqwCJpykdNmawW00vYX7ato53A=; b=Pv8vmbIUPLmFzbW7VHsxE2Do36
        4Ar7ZJud54YpCBpOeHPzf3VeE4N73EqvabS7+S8+f1V98yxQHXVEouE6wN3/ed+g
        P9AlSQvmLTyo6v/OWwjL5tomRSd/VSnZk40Uswc+sCpwYYWj3hSzx1vqTYIaadWT
        ega6opm6Y96m8N4rI=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHD0POUGdgy0yMAA--.93S4;
        Sat, 03 Apr 2021 01:13:50 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, andriy.shevchenko@linux.intel.com,
        wojciech.ziemba@intel.com, fiona.trahe@intel.com
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] crypto: qat: Fix a double free in adf_create_ring
Date:   Fri,  2 Apr 2021 10:13:48 -0700
Message-Id: <20210402171348.3581-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAHD0POUGdgy0yMAA--.93S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr45AF1ftrykKw45tFyxXwb_yoWkZrc_Cw
        4v9a9rWws8Kan3Ww4DWFWYvryI934YvFWkurnrt392g3s8ArZFgF1xA3Wqvw1xCrWrury5
        C392qr12yr10vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
        FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
        0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
        x2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY02Avz4vE14v_GwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU8zuWUUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In adf_create_ring, if the callee adf_init_ring() failed, the callee will
free the ring->base_addr by dma_free_coherent() and return -EFAULT. Then
adf_create_ring will goto err and the ring->base_addr will be freed again
in adf_cleanup_ring().

My patch sets ring->base_addr to NULL after the first freed to avoid the
double free.

Fixes: a672a9dc872ec ("crypto: qat - Intel(R) QAT transport code")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/crypto/qat/qat_common/adf_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 888c1e047295..8ba28409fb74 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -172,6 +172,7 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 		dev_err(&GET_DEV(accel_dev), "Ring address not aligned\n");
 		dma_free_coherent(&GET_DEV(accel_dev), ring_size_bytes,
 				  ring->base_addr, ring->dma_addr);
+		ring->base_addr = NULL;
 		return -EFAULT;
 	}
 
-- 
2.25.1


