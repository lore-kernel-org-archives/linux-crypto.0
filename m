Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38B6C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Dec 2021 22:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhLOW4B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhLOW4B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Dec 2021 17:56:01 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E16EC06173F
        for <linux-crypto@vger.kernel.org>; Wed, 15 Dec 2021 14:56:01 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id j11so21344957pgs.2
        for <linux-crypto@vger.kernel.org>; Wed, 15 Dec 2021 14:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yDdWM1yXl+0uRGP+ii65Qcqo9uZymJOI1yKvjKO5Bo=;
        b=nfAQR8261KPTU/DmR/cBzNRbjAa09R2mWOcDWtVgrihXVScenl4gegVn9oFlX67f4d
         mtQTuIY10AeskZxY1z1B4OpBOmOl6WuOoku2BsrIOyONUWErkjHg0gabeXByrMjz5jRX
         N6dwZMMBNsk5fmNae4TYunWL99rZvITISbxII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yDdWM1yXl+0uRGP+ii65Qcqo9uZymJOI1yKvjKO5Bo=;
        b=a699jLof3uEQH/WSCAPldpvmDl77ULhHCdgm1X9kkQF+sbw4U5M5917p7Z9K3nNHP3
         BcFlomZEvv9F+0MQVNoHlwTszjeDBaPMZDKbkcvPK1YRMSEOicscQtLvTDcQheA50d7Z
         M2x4iQCiu+6okVqWB8BzeDg8AJQxqER8Hbe6WBvQe8321DetGA+Iugrin4JVCLutgUQS
         8KqTcm6JrP5VKqbmm2V/V9G1dM2KDtyuW0/gb4u/e+/nyS8ZTYqn3mcWLQgxQnp08Hu7
         CadfCFK4yyhrCG08gKPREu5Oi+v7meJ23qxNE2dC2j4myxsKfH14wXup6Rn0q8J/KOWa
         zaTA==
X-Gm-Message-State: AOAM5319e99lnjuqJ948Ro63Y7BrbyaNDBPocVY1sofuYrrC+80sLiEJ
        iX8XpWGZOVRfn3bzO5N7mmdYNQ==
X-Google-Smtp-Source: ABdhPJztqkoNURW5JbBJ/LJVnZlKutO225EVHf0VyNSmqU7HtLHqCbI57tLKulVHLvFMUAPEBU49Mw==
X-Received: by 2002:a05:6a00:248a:b0:4b0:b882:dfc4 with SMTP id c10-20020a056a00248a00b004b0b882dfc4mr11094178pfv.37.1639608960561;
        Wed, 15 Dec 2021 14:56:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n15sm3353053pgs.59.2021.12.15.14.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:56:00 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Suheil Chandran <schandran@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - Avoid stack variable overflow
Date:   Wed, 15 Dec 2021 14:55:58 -0800
Message-Id: <20211215225558.1995027-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2736; h=from:subject; bh=w5Fv0a995X+d0i79FZ0Vl+vUson7Nirz5CGVRqYWg1c=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhunJ+Obd9sKybjgpf3E8a1GCX6bhw4M1GOPGBONoK MpK7F2OJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbpyfgAKCRCJcvTf3G3AJkF7D/ 45d5PbP9WE+p8E63nh8IAwiCfTQJl0YUHe7/aOf+4NDLpjfqlhJ0qsw8fmRxygV99Z4qdw1ao308HZ BCg/jtmD3bfsMqthOs6/XxmnN2UMhLf5e0FcfXOEyoMVphARYJKeLZRmiiVnsO78t1FLStl+Pfui4O B3qKvcBct/A5hy+MNMVxQQU9wzD5ZTSoyEkG0GJ21CXBarWuDdCE3rJyjhq8hlRuhp8BBbD2LIEHAT SxMS2oPefB7uHzwkbGw9Y6xv5rdwjcHlKyVXtJEy6L7SiKUwRnaYTZFiX+QvYXkY+p1eoi1nT49H7u tEHagcp1e0j9Tfi++PJQU6a+EpxcP/eXzpu8KIPWQe4agawiKe8t98uoUBp14HBsd1OsLozEOwJRaE 1CmVx83xcvxD2/UDjP/WxiGrWkK07EZKBRfLUhQOGPP76FpjJSuBwfFJ8hIAyeuKLfrFE55lHJZ33a XdvGgsH9cikVINQ/NYFSKgMm/Ylsc8eBKWG9rbmP5oR13pP+l/l0Aifi2uQCLwR0zttZRP7B9qYcX0 PkTe5Au+FOyb3L2t2+gEMbMCv3HJCxf4l6knhTgu6Ja99rJYSxKeoDkm6t+/hXK8nGQ9MEL1xsE32C xFz5A56QSAHCE1im/v61tGb8Knf1VvLuQEo5bb/nWvGSufez0gocPmK7CxsA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building with -Warray-bounds showed a stack variable array index
overflow. Increase the expected size of the array to avoid the warning:

In file included from ./include/linux/printk.h:555,
                 from ./include/asm-generic/bug.h:22,
                 from ./arch/x86/include/asm/bug.h:84,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/gfp.h:5,
                 from ./include/linux/firmware.h:7,
                 from drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:5:
drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c: In function 'otx2_cpt_print_uc_dbg_info':
./include/linux/dynamic_debug.h:162:33: warning: array subscript 4 is above array bounds of 'u32[4]' {aka 'unsigned int[4]'} [-Warray-bounds]
  162 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
      |                                 ^
./include/linux/dynamic_debug.h:134:17: note: in definition of macro '__dynamic_func_call'
  134 |                 func(&id, ##__VA_ARGS__);               \
      |                 ^~~~
./include/linux/dynamic_debug.h:162:9: note: in expansion of macro '_dynamic_func_call'
  162 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
      |         ^~~~~~~~~~~~~~~~~~
./include/linux/printk.h:570:9: note: in expansion of macro 'dynamic_pr_debug'
  570 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
      |         ^~~~~~~~~~~~~~~~
drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1807:41: note: in expansion of macro 'pr_debug'
 1807 |                                         pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x %8.8x",
      |                                         ^~~~~~~~
drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1765:13: note: while referencing 'mask'
 1765 |         u32 mask[4];
      |             ^~~~

Fixes: d9d7749773e8 ("crypto: octeontx2 - add apis for custom engine groups")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 57307eac541c..7ed3c18eca19 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1762,7 +1762,7 @@ void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
 	char engs_info[2 * OTX2_CPT_NAME_LENGTH];
 	struct otx2_cpt_eng_grp_info *grp;
 	struct otx2_cpt_engs_rsvd *engs;
-	u32 mask[4];
+	u32 mask[5];
 	int i, j;
 
 	pr_debug("Engine groups global info");
-- 
2.30.2

