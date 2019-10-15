Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66B6ECE58C
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 20:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A66F20854
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 20:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1DZFIQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733163AbfJOUNp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 16:13:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43925 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733084AbfJOUNj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 16:13:39 -0400
Received: by mail-lj1-f195.google.com with SMTP id n14so21560061ljj.10;
        Tue, 15 Oct 2019 13:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MPbKpbEg5ppV5gaRQpYS65cgF3qRl3wNuMK75d1ehs=;
        b=L1DZFIQXFIVk/4vGGozIDAkO9Vm6PKjaokmEaMNpNwh4rMQtCE8XlKQHG+MoUzBb+8
         3QvpccDjUuPnuAJ9EWr6HuJPzjAHtxAVuxpeT9ZsG9l+Eu/HO6+3wtD1gEh77IahEmfF
         AtDI3oGd7cKX1KXIqWNLaarofb3G3MehoPOLMZe6wJ480A5m9z+lz3VD2m9S4eF2mp8B
         w5qavndp2JTEUewn6dyaz5/WN56qQwuV43yohYGM4d2GzEEF0lYgWat1U4C4prS9Tvug
         K5pCShh461WPF/hwUS3qKh6bwonbheOav9fUT2Qj8T3/K/3hpauNqvLl+KMZzSkdgJqR
         dfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MPbKpbEg5ppV5gaRQpYS65cgF3qRl3wNuMK75d1ehs=;
        b=o5CuPtiqjX3oPT0U+ZpvyOhg/u1hem+0CUZlRQj9xeXSy7Q+Z/M/W8rKVoPk1rgWfb
         HyPyvfcselv8GfL+4EgkFwitUjOHxUXU9kmIMLpRSMRHMpAAkPVDnhMiS/lm56KKH2en
         pDHxcgS8pTRkunkP48wXQGXI+V8W2Os03fM/08WvP6fSiurD43KUiT7uPgvTg9u1WeN/
         RAQ7lWKv0kD8q0AtRMdYoa6zB7Fuau2pfNI48ICucxzb3vv5MVxxybpRYZ2ZkVrTde2z
         XNZcNJicCsYXwZLNRme68PPKJ8sZvvR1faWjXQVPb9nErzl68pJFrjD5CNNR+F+4gYNS
         ATjg==
X-Gm-Message-State: APjAAAV0bKum9VqnMBhl/B3GU/u2B6EPQAZMIsBRfDylp3zzEJaEQsp/
        7LJKsiQ/f8FYt56rIV1N2o8=
X-Google-Smtp-Source: APXvYqy0DKP3fhfMO7V9Xm7rE2ISjPPe4qPOtzSK4w/gUpTATDATUg1HONJ/3rmQ7bEhIseglHCjwg==
X-Received: by 2002:a2e:584b:: with SMTP id x11mr23883879ljd.96.1571170417130;
        Tue, 15 Oct 2019 13:13:37 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-228-153.NA.cust.bahnhof.se. [98.128.228.153])
        by smtp.gmail.com with ESMTPSA id b10sm5335761lji.48.2019.10.15.13.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 13:13:36 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     xuzaibo@huawei.com
Cc:     davem@davemloft.net, forest.zhouchang@huawei.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        tanghui20@huawei.com, Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH] crypto: hisilicon: Fix misuse of GENMASK macro
Date:   Tue, 15 Oct 2019 22:13:30 +0200
Message-Id: <20191015201330.25973-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <1569835209-44326-2-git-send-email-xuzaibo@huawei.com>
References: <1569835209-44326-2-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Arguments are supposed to be ordered high then low.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
Spotted when trying to introduce compile time checking that the order
of the arguments to GENMASK are correct [0]. I have only compile tested
the patch.

[0]: https://lore.kernel.org/lkml/20191009214502.637875-1-rikard.falkeborn@gmail.com/

 drivers/crypto/hisilicon/hpre/hpre_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index ca945b29632b..34e0424410bf 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -116,8 +116,8 @@ static const struct hpre_hw_error hpre_hw_errors[] = {
 	{ .int_msk = BIT(7), .msg = "hpre_cltr2_htbt_tm_out_err" },
 	{ .int_msk = BIT(8), .msg = "hpre_cltr3_htbt_tm_out_err" },
 	{ .int_msk = BIT(9), .msg = "hpre_cltr4_htbt_tm_out_err" },
-	{ .int_msk = GENMASK(10, 15), .msg = "hpre_ooo_rdrsp_err" },
-	{ .int_msk = GENMASK(16, 21), .msg = "hpre_ooo_wrrsp_err" },
+	{ .int_msk = GENMASK(15, 10), .msg = "hpre_ooo_rdrsp_err" },
+	{ .int_msk = GENMASK(21, 16), .msg = "hpre_ooo_wrrsp_err" },
 	{ /* sentinel */ }
 };
 
-- 
2.23.0

