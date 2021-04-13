Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B418C43460
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 09:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59CB1613C0
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 09:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbhDMJVG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 05:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhDMJVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 05:21:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039AAC061574;
        Tue, 13 Apr 2021 02:20:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d8so7872430plh.11;
        Tue, 13 Apr 2021 02:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yxv+W5Wy6TsnwXCzdMCOFEotN7zXApShJqhmV4+mIq0=;
        b=ohFH+/YCt9wTZmSwx+HqMUzJ0sYKgLByyeFn3GZdswLcoGCGXudV8r/mMZYUVfcKRP
         KNajmOg2tbXpipVVlc1BbnJwjS4c4neIu7kY8E1BEvq06u0AUlSYIBIVnNMZu++fDglJ
         Yq6G7mzxrHfeK0QuAJ+6NsHM68MFoZvpDlkvsvvepG2DBl3zwff1eeWEQxJdFVyG26/+
         RZiJpgKTh+tGCqItQpGYMgAboehdG0LI+29Gjki1ObQRQ2HRCmLy5jMN+3xhucJ7MvwT
         mMUdYhhgZoCBMOo3dPbw+q0v4+myURzJGpQgDJNJoD+lbGi5YAvMk14bwgzg6jaXabCE
         6mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yxv+W5Wy6TsnwXCzdMCOFEotN7zXApShJqhmV4+mIq0=;
        b=MNFgZZPT3+4oladHw29hnKB68EVtLIZ2K2y+e9H6bJGOYg8rsFIVqUz8Gst6+gN2+m
         MunVoAoyiq0k+fTs8o1sKP/lfBX+u7mElOoNQd1PKAtXEpYmPQ4dmvdsdtEoYA3xplOE
         wL/JtVoxU6boQzx5BH5cEPE14wYNMAwa6KwJLXIuZa/9eOFYS719RX+JeQEMoIKm7sHS
         ytuoQgDIgOmlzRLCnvBDxdu4GJqK+w2bnJaYiWTScVDkeJsThYGFNpX++xGGzXPmrfAE
         P8yCoM7/2cyuJnNWTac4wtDSyTaeFhbhRMFyKCXqHpWfmsh09+FFzz4oU+v9VD7qCztN
         0NNQ==
X-Gm-Message-State: AOAM530nzNf4J+TAJJGKJNHcgbqA7wE5Baf9Klc/CVde3w0XECCtiLO8
        b/Zn9fztJPhED+s3CXUt+zmr2rjkyKk=
X-Google-Smtp-Source: ABdhPJzTuaYu3hPOPpMqcStKDDJxVN7QSf9avxZd504RoaFKbO9KSZbg/5hEcT4EU6DzPAkqaTehhA==
X-Received: by 2002:a17:90a:a78c:: with SMTP id f12mr3851977pjq.219.1618305646463;
        Tue, 13 Apr 2021 02:20:46 -0700 (PDT)
Received: from varodek.localdomain ([171.61.181.173])
        by smtp.gmail.com with ESMTPSA id x194sm13388570pfc.18.2021.04.13.02.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:20:45 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     vaibhavgupta40@gmail.com, Kishon Vijay Abraham <kishon@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Update dt-bindings and sa2ul driver for AM64x SoCs
Date:   Tue, 13 Apr 2021 14:45:56 +0530
Message-Id: <20210413091559.154169-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210316220558.GA3754419@robh.at.kernel.org>
References: <20210316220558.GA3754419@robh.at.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Vaibhav Gupta <v_gupta@ti.com>

This patch series aims to modify necessary files before an entry for sa2ul
can be made in the respective am64 device tree.

v2?
  - Simplify the dt-binding changes.

Peter Ujfalusi (3):
  dt-bindings: crypto: ti,sa2ul: Add new compatible for AM64
  crypto: sa2ul: Support for per channel coherency
  crypto: sa2ul: Add support for AM64

 .../devicetree/bindings/crypto/ti,sa2ul.yaml  |  24 +++-
 drivers/crypto/sa2ul.c                        | 133 ++++++++++++------
 drivers/crypto/sa2ul.h                        |   4 +
 3 files changed, 120 insertions(+), 41 deletions(-)

-- 
2.31.0

