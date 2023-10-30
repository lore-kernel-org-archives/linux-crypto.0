Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D8DC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 12:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbjJ3MFp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjJ3MFo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 08:05:44 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A087C9
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 05:05:41 -0700 (PDT)
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9F5673F213
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698667538;
        bh=7WB8+dzA+A9FwbTE3H0wb8DTd4y1xgyz1TXm5BpP+xY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PgDzzPHkaQaSIiTHAgPzsxlMhhOh1xplxctwqUpQoEnqyWl5wJQHlpdvJRxLScfNp
         MRBD28uuxJUv6gx+vK4HYq2meexeZIFH+OUhAMkynnyf0eCLtsUyoqSmU3Caa7hSZj
         /0p9Hl5vfheWkcWw5klP6X5R9yx+roCYGhtc74DNrL6QTI5o1FR/nHIhebZ8RjbscH
         LhAT6haczj8/UBo7ceSB8SCiEEuZL2AL7jc8EWGkmy8gmmbmDqgZykAfh0NV1S6AuW
         UuyBhwYlaD3HWO3qbqDGx1j4heHYxtA9ok0950n7eNwXHhnH+d0/iRSf77MiCXaGQh
         bQI2q5E141Tpw==
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5079f6c127cso4922364e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 05:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667538; x=1699272338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7WB8+dzA+A9FwbTE3H0wb8DTd4y1xgyz1TXm5BpP+xY=;
        b=p79dg02bsfRVPiu0C5zpJSieNPtQuu7EMKFS3TP2QgHH35t0ambwtztS1crCHd9rzz
         LPNdKjU8E/8825svklx3AzT7SdSM/VNx+YX3db9AZRy1yFkg52ZCVFQfPirm6S9p3duf
         ovNwucwGFqHHFW2xzy//4ft4pZNsSa0un/HxafY54ICTq+wBNssCfiQN5aAbe+HzrWV/
         S/bgd//Te727SjwuoUZtYsQ6rSlrZUoWyK9hgOgVhMGfGtP+mrm0L4DtVWvQI7wfS0p3
         /jswy1WouYma/hfr2DhDHAsxwhdJbIqSK2IoSJBNM9qG5bdeovnnpzoXPTKAmgkvekm0
         7WkQ==
X-Gm-Message-State: AOJu0YyfXKBzeM3OYRjUdaFtfZCZatbSUqwCsR6w1B1gE7vuFllFQ0Sn
        1TYyrSktruOCLXBUN01RLLCsqFnjTkitwJh8hhe2vG2MiM7J9MirVKzxyuc016K/o+HF7EgONlZ
        8ind1L0SRL3epGpg5KOH6B5zhehItfDqJg3sK8tkAEw==
X-Received: by 2002:ac2:44c4:0:b0:509:dd0:9414 with SMTP id d4-20020ac244c4000000b005090dd09414mr3826080lfm.24.1698667538079;
        Mon, 30 Oct 2023 05:05:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHsT8rkWtZkhjznGWEjGRHTYYV0lbpkqqzlBl/OJ07Ds5/1iMxxgqafP2qYC8sQC6/xf/vdg==
X-Received: by 2002:ac2:44c4:0:b0:509:dd0:9414 with SMTP id d4-20020ac244c4000000b005090dd09414mr3826063lfm.24.1698667537725;
        Mon, 30 Oct 2023 05:05:37 -0700 (PDT)
Received: from localhost ([159.148.223.140])
        by smtp.gmail.com with ESMTPSA id f18-20020ac25332000000b00507f0d2b32bsm1420458lfh.249.2023.10.30.05.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:05:37 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     smueller@chronox.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] drbg small fixes
Date:   Mon, 30 Oct 2023 14:05:12 +0200
Message-Id: <20231030120517.39424-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
References: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is v2 update of the
https://lore.kernel.org/linux-crypto/5821221.9qqs2JS0CK@tauon.chronox.de/T/#u
patch series.

Added Review-by Stephan, and changed patch descriptions to drop Fixes:
metadata and explicitely mention that backporting this patches to
stable series will not bring any benefits per se (as they patch dead
code, fips_enabled only code, that doesn't affect certification).

Dimitri John Ledkov (4):
  crypto: drbg - ensure most preferred type is FIPS health checked
  crypto: drbg - update FIPS CTR self-checks to aes256
  crypto: drbg - ensure drbg hmac sha512 is used in FIPS selftests
  crypto: drbg - Remove SHA1 from drbg

 crypto/drbg.c    | 40 +++++++++++++---------------------------
 crypto/testmgr.c | 25 ++++---------------------
 2 files changed, 17 insertions(+), 48 deletions(-)

-- 
2.34.1

