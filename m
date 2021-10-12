Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DE9C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38410610C7
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhJLCU4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 22:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhJLCUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 22:20:53 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253D6C061570;
        Mon, 11 Oct 2021 19:18:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 133so12463853pgb.1;
        Mon, 11 Oct 2021 19:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0iTHD8zuIlPTE898HuuCtTAOQQCCVuFMCLG1W0mYvD8=;
        b=P2RRLYW2P+6ZQjAVcMQE8mVNiG8JTD+yuCRfTI6RUEX7oFZs4IhaanzXqdaiH1SOUs
         vbF+alIZ5kszD8u48/4QZE1e0bScJ2HdEO9vaxex+sLsKRzCuLuMteoD12Nvr3Uy9pRY
         t2VYXoIUPe2M61QcjpVKIcKBHn2n70GIHkDP3q/DMu6DiVOrijhmHdeJbCiaDcOM8DEO
         0yMAzKsOA86vimBToPPWm6OIx2ljyxw55Y3po68daI7oceX/YgaBGl+m3IQkxzdUYcvi
         4yK2gqbUEcZg98cwiUs5x+ipESvBQxaN70izFHCauVxbzIUgIarMU7exG3O3aHz9C1+V
         f9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0iTHD8zuIlPTE898HuuCtTAOQQCCVuFMCLG1W0mYvD8=;
        b=64OB0nqXC2oPZIITn/oeHFAgnYwvZQRp1dcVjt9+l4oJK0n6wi3kbh0uZviVnkIztP
         IA7SEtZ74Pc0+7oe9B2ZEgB3hTga/oRp4Rkto3OkNYtYR0cf7QryUTF05KiGLp2ROYHz
         W2ML4q/7hryPP4SJI+vJpxMqdKY1jH/ACTVZ8pv6Nxa77pLknaHktsdf3S3AHRBmOehk
         1qDEkWrqoKQtfrdffhx5yxXwx5Bpc0V3EBBR0winYrQmmUJ0zY89qb7gAUSzs4fjniTH
         JJclvFN4RFLfkn6WdVxy7uYMCCXpZu1QO/GlxmqXgAgbsFqPE1A9fTzA5bzgil00sUW1
         W4Hw==
X-Gm-Message-State: AOAM532+bNeEM0NlAg6SM2AtgMqOxiCMOXfRseRrNfI5L3jNRXh9uDyY
        xDNIM/VUIszIRKluKDTFNVSUgD6W5iA=
X-Google-Smtp-Source: ABdhPJzso082q3V5CGDif2ATwU5qTNZZ/n1WIC1v46BePkMCbR4isq39B6lqw4Ms2SoPK7ABSKmh/A==
X-Received: by 2002:aa7:9d91:0:b0:44d:2778:561f with SMTP id f17-20020aa79d91000000b0044d2778561fmr5909561pfq.15.1634005132312;
        Mon, 11 Oct 2021 19:18:52 -0700 (PDT)
Received: from localhost.localdomain ([162.14.23.249])
        by smtp.gmail.com with ESMTPSA id l207sm8963835pfd.199.2021.10.11.19.18.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Oct 2021 19:18:51 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] lib/mpi: export some common function
Date:   Tue, 12 Oct 2021 10:17:52 +0800
Message-Id: <1634005076-17534-2-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
References: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

Export mpi_add_ui() and mpi_sub() that are used by the following
eddsa patch.

Signed-off-by: Hongbo Li <herberthbli@tencent.com>
---
 lib/mpi/mpi-add.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/mpi/mpi-add.c b/lib/mpi/mpi-add.c
index 2cdae54..d34c6c1 100644
--- a/lib/mpi/mpi-add.c
+++ b/lib/mpi/mpi-add.c
@@ -62,7 +62,7 @@ void mpi_add_ui(MPI w, MPI u, unsigned long v)
 	w->nlimbs = wsize;
 	w->sign   = wsign;
 }
-
+EXPORT_SYMBOL_GPL(mpi_add_ui);
 
 void mpi_add(MPI w, MPI u, MPI v)
 {
@@ -138,7 +138,7 @@ void mpi_sub(MPI w, MPI u, MPI v)
 	mpi_add(w, u, vv);
 	mpi_free(vv);
 }
-
+EXPORT_SYMBOL_GPL(mpi_sub);
 
 void mpi_addm(MPI w, MPI u, MPI v, MPI m)
 {
-- 
1.8.3.1

