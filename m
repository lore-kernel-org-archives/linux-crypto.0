Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F18EC54E76
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 04:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjAFEUf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Jan 2023 23:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjAFETy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Jan 2023 23:19:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E1D193DB
        for <linux-crypto@vger.kernel.org>; Thu,  5 Jan 2023 20:19:52 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z4-20020a17090a170400b00226d331390cso537035pjd.5
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jan 2023 20:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hu8NtloN+PgTYyanRIE7pi7y6G8HPaI/k/WMITVvahU=;
        b=OdblQNQsWkunarJky6ssowGDbfTut1JiehmR0XIbfzlvP9zGzN3UF6YHZ2YckEX8Lw
         Z2zNGXRwzroQNXlC6nccWRULvSTwJzUn0Ya9imOGqk6l2p0gUu4Iuyhry0Xs8gDJnnyi
         wYy6GF2eJ+E5R47SGTl55Tg4M2Nh0aoqF3Bbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hu8NtloN+PgTYyanRIE7pi7y6G8HPaI/k/WMITVvahU=;
        b=anE+TOsYKdJS56siYwPidE7aiwWVlOvZdeAbBshlwAb8G3El4IpXI5YEVJLhHkxFwu
         zWUiS3kM4Qawoide2HvaduQvxngkcTlsLkf5EvcmCNAZDjbtOT72rwuOs/VD0A3ygfTI
         C/wT26udUOIsvQpZnlhlh51BHwEBTJr7pt4H6zNYYklob0+idbJPT8k9y/hIZf2dLn7T
         hRrDY00MUIqCei/V+pKFvelWEIyzwV3OW8NMp4z0/GAVY1S9rzMdb0m+s6i7fPlE5JGW
         SFJ31TUE2iNgxkI//xzMIdwRiKidJ1Xtv8io0ra2hU4brgmP+UY974iE0e7M8kpCkXAv
         OJzA==
X-Gm-Message-State: AFqh2kp55LplmSIi15IEo4Cb0qUvmKPvMv9Q4X8eg2Q0OLm1zI5ZzSf2
        XvuxPv0NAdyPfrVGOid2FAA0Ow==
X-Google-Smtp-Source: AMrXdXv6veZlRCNlcFwIt6dCNcvq4fdJDguLdT7MM4nYKqXE81W9GfTvqrwpgwLqmn//fxJdOb56rw==
X-Received: by 2002:a05:6a20:3d84:b0:b0:1abd:8604 with SMTP id s4-20020a056a203d8400b000b01abd8604mr87791661pzi.41.1672978792438;
        Thu, 05 Jan 2023 20:19:52 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z4-20020aa79f84000000b00573a9d13e9esm99431pfr.36.2023.01.05.20.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 20:19:51 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Weili Qian <qianweili@huawei.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: hisilicon: Wipe entire pool on error
Date:   Thu,  5 Jan 2023 20:19:48 -0800
Message-Id: <20230106041945.never.831-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263; h=from:subject:message-id; bh=X6glahKc2K5AhGi573gEkEl/ZAg/qb6wVfjT5NagaeU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjt6FkGMo4DAMJrJ88UNYYHlYbEA3oaRLMDi+LMFt7 MlcyWbCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7ehZAAKCRCJcvTf3G3AJrdlD/ 9klXK0kVfveHuPruho8dg/ZvBbP1H/ZKgZMeuq9octPINgkBgqGgnphKdHv6I3FBz0h9lUC94M3vZ1 SN9snSK1U9rraulaAplsebe/ma5zOumYBITv4UDqmYIbgp5UraM8+Fu0Ws0r/z9spYVLFJvAx6onMk d8L66wpibWnBQ0Al7c6kam9MKYP6QXYpPqWtpj8TrCJT/N3ABy5qf87KeMHsbWR3sPjcTPPljQXu+y jfgmhbInslE/j5J01pGLMGhFcx1/9zwoT9Xg6l4pOsi3655bOXnBxyyIemp1YaM2yPmwmt66s0RfaL lw/8Y9iTp3B+ACjjjzDY5sJYepHtQPDeGCZdXwC/w7twxdWsvqLvfVjCS6fUdKnQj1aSN0IRZ+awki A9Cl1roFZ4iV2A77XiIXlZY5D4OBBQC5vNIVFBD7Qb3FyX8Nw7jWLyadPJmMzAj5mHYKpnyyH93I3N xKnyzi8+ouYZpohIVB1wLhHDoEEi4nqDBUDi9QV0KiDop2q3TMwT+23QF5eCCP2Ay8jKcVMk32QTO5 4A48zBSX3lRNTi56aeOlHCewiRgEIhj0SmO0+VUGLq2s4V/IWIA4H19honqvtwQH2I3+ojP+C5WZp9 HLp98EGjFlXr6HFpI4yUKG9sZzFAo02W03prZ+xnc2e9kwkcKyzE/9H6qE2A==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To work around a Clang __builtin_object_size bug that shows up under
CONFIG_FORTIFY_SOURCE and UBSAN_BOUNDS, move the per-loop-iteration
mem_block wipe into a single wipe of the entire pool structure after
the loop.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1780
Cc: Weili Qian <qianweili@huawei.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/hisilicon/sgl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 2b6f2281cfd6..0974b0041405 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -124,9 +124,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 	for (j = 0; j < i; j++) {
 		dma_free_coherent(dev, block_size, block[j].sgl,
 				  block[j].sgl_dma);
-		memset(block + j, 0, sizeof(*block));
 	}
-	kfree(pool);
+	kfree_sensitive(pool);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
-- 
2.34.1

