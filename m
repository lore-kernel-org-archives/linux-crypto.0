Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DE3C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75E5564F80
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhCLQWw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbhCLQWZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 11:22:25 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97795C061574;
        Fri, 12 Mar 2021 08:22:25 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id by2so4493281qvb.11;
        Fri, 12 Mar 2021 08:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A2UZVq4RWM1EK4WKKShJf3qblovDef5sWEZC7pI0LcQ=;
        b=kdNrQCA0SX7W8OuOXyJxWnj9EIQirUIR/ddyqiXJ4mtchy+yrtIZR/Kj+HSiciBUvh
         rHGxieqlfUL4Zg9lQ7qm1zeBtoz71elWwVkp1KLPUNKJX+WLfo4uTo6zYOpKY48htU4+
         4MdIcHbesAgRRadsWK2CK3p3zNJUhn+aqs4CYchGqDaNh30MSMVsFJG41XGKI4LRB9y+
         KBuIgkM59FzI69cz/9BXGdafuHFyDBxo9Rc4//jPoJSpi5j/LXZPyX17xlD5nyoCG7Um
         khZY9ZOY2DXinI8+rStAvu4Hy1pCAHsRYlmF2tprlu9aLJQcSirPRtECkCmn1hd15uiT
         qHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A2UZVq4RWM1EK4WKKShJf3qblovDef5sWEZC7pI0LcQ=;
        b=MbCiF7US1ZUma+xuZy3aAihlqJEq1c4jWhEsgFLRGlk/j3mPaTxkyFBc8WkNM+qCcl
         UZ0JNWKX7Y7Y5r5rQcQKGXBRhOEmw+4n6SklBKLPXjcX79vvmAzpfphTEUdBdfSLxj1o
         UUhEmawHk1Abm1L/NcOP/rfEBWMiaLnnfKpTDoXvrkb4R+692ub4X4GJiw0eYFiLT8Ea
         95HV35048Tu6AvEov6lSKvCmRKrFPwdlbmU7LTeiTeYIWBFIkWRw+tAspPXU7otM8Ovt
         CTNJpTI9gayZhre36uo0EdQgRwpKhGFvtNMIOJBRqX0u0mscnGlIZNLjHanIalFnA0Jk
         fefw==
X-Gm-Message-State: AOAM532iTr5w6IMQjqbOzZ1mFZ44tgXxqiPZ8XWFy/ixgssE6wu3c1ms
        J9g9g4N8y1ZDCO9+oTmnnjc=
X-Google-Smtp-Source: ABdhPJxKhDJ9EXGmmsXNlhQwE3+AQhGu+/arRJk/5uXBpIBozkvLaof/bOUB7r/Y/9DamIzjyQjJ2Q==
X-Received: by 2002:ad4:4581:: with SMTP id x1mr13144164qvu.9.1615566144660;
        Fri, 12 Mar 2021 08:22:24 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id e15sm4178623qti.79.2021.03.12.08.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:22:24 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tong Zhang <ztong0001@gmail.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] crypto: qat: fix couple crashes duing error handling
Date:   Fri, 12 Mar 2021 11:22:01 -0500
Message-Id: <20210312162203.2416149-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are a couple of issues in qat error handling. Those drivers tries to
release resources that is not initialized. This patch series tries to fix
crashes caused by incorrect error handling.

v2: removed excessive dump in commit log as suggested by Andy Shevchenko <andy.shevchenko@gmail.com>
v3: collect tags as suggested by Andy Shevchenko <andy.shevchenko@gmail.com>

Tong Zhang (2):
  crypto: qat - dont release uninitialized resources
  crypto: qat: ADF_STATUS_PF_RUNNING should be set after adf_dev_init

 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    |  4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     |  4 ++--
 drivers/crypto/qat/qat_common/adf_vf_isr.c  | 17 +++++++++++++----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c |  4 ++--
 4 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.25.1

