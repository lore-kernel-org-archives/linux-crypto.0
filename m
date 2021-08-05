Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40EEC4338F
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Aug 2021 08:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8895B61078
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Aug 2021 08:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbhHEIyn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Aug 2021 04:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbhHEIyn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Aug 2021 04:54:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F93C061765;
        Thu,  5 Aug 2021 01:54:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso7690296pjo.1;
        Thu, 05 Aug 2021 01:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TziLtL+sARxh/qxYNF2Uhc00DMrpSx0VoD8GtPIdbOk=;
        b=kBVAbmT108V9EURr4THvvr3zJgFojwcFM0XvqybjxLRu7e1rqQ/v6bW81R1AVUfC1Q
         XII87OLaCGc3ynl4ASmIXxz1hBbsaPJwZ7qFInQmVa1H7U5gPeL324vLWq97bQDxqwUK
         TpuYOcZLbXi/Jgi2GIUoqf9JBbLROruST33GuMlUDeGtyYYrlK14QlvZBbuGT+yhxCef
         VPGz2Vy0vDYUgyp+UF4UEoHSrLQbEvTdRD/iv6yIXUEzTmmsy+FdgF84oW33O5sQS3ZU
         FstFTi096QgO0teITY1vBZLZFxZlN3KEVYTgEskjwZehv2Yqfqn7VA/YMy0+X4VQJ3Qt
         flNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TziLtL+sARxh/qxYNF2Uhc00DMrpSx0VoD8GtPIdbOk=;
        b=Cmqmb2VWE5mRZBP8Eb0DkCaVSXhkzLZyn17A/NpzhVi+aathuWpAIgsf9I2Ngb3mcW
         oAbCFywSy84ZvYzvppJx9yJi9KUqa+xvbLabbNb/twcj9bXTjWVljnMzOkGASnvSh1Ji
         moWZVmsy1DzvHlcj8MgRcu7//QxDQygxOrqN/IbARZBoDkUeQkmK0UnZRDbLFpgMjwu4
         THNR2C0y+VTQK7jlMWIKaHS1stoAqxGBrKsC7Vw/SJ12NPIZlctr8fUXjbKcmQLRrHSV
         d7DRr89QnmzgMUcmW3bGhe44ThklxGojEGv07GJTO4qXx7VvDLS/Zc39S52KS3cTuW90
         h57g==
X-Gm-Message-State: AOAM531GaueCfxSqQORPvZBnJaGDdxU6iK6JzQU5LJKDCB/154RulVg7
        yUGqR4pVevRfjlVYKcCecwZdyiT5kfc=
X-Google-Smtp-Source: ABdhPJxTa/yRwWkII0EHrJcOn29TMXkCE7CeSA1CVmtGwFMejxu7Ri9Un1h/weRVO2TxirVC/b3S/w==
X-Received: by 2002:a63:e0c:: with SMTP id d12mr531109pgl.386.1628153667689;
        Thu, 05 Aug 2021 01:54:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id z15sm5986233pfn.90.2021.08.05.01.54.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Aug 2021 01:54:27 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] lib/mpi: use kcalloc in mpi_resize
Date:   Thu,  5 Aug 2021 16:53:32 +0800
Message-Id: <1628153612-14419-1-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

We should set the additional space to 0 in mpi_resize().
So use kcalloc() instead of kmalloc_array().

In lib/mpi/ec.c:
/****************
 * Resize the array of A to NLIMBS. the additional space is cleared
 * (set to 0) [done by m_realloc()]
 */
int mpi_resize(MPI a, unsigned nlimbs)

Like the comment of kernel's mpi_resize() said, the additional space
need to be set to 0, but when a->d is not NULL, it does not set.

The kernel's mpi lib is from libgcrypt, the mpi resize in libgcrypt
is _gcry_mpi_resize() which set the additional space to 0.

This bug may cause mpi api which use mpi_resize() get wrong result
under the condition of using the additional space without initiation.
If this condition is not met, the bug would not be triggered.
Currently in kernel, rsa, sm2 and dh use mpi lib, and they works well,
so the bug is not triggered in these cases.

add_points_edwards() use the additional space directly, so it will
get a wrong result.

Fixes: cdec9cb5167a ("crypto: GnuPG based MPI lib - source files (part 1)")
Signed-off-by: Hongbo Li <herberthbli@tencent.com>
---
 lib/mpi/mpiutil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/mpiutil.c b/lib/mpi/mpiutil.c
index 3c63710..e6c4b31 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -148,7 +148,7 @@ int mpi_resize(MPI a, unsigned nlimbs)
 		return 0;	/* no need to do it */
 
 	if (a->d) {
-		p = kmalloc_array(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
+		p = kcalloc(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 		memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
-- 
1.8.3.1

