Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0AFC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B32F64DE2
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhCSDkO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhCSDkH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 23:40:07 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C57BC06174A;
        Thu, 18 Mar 2021 20:40:07 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id a11so5819892qto.2;
        Thu, 18 Mar 2021 20:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LGZ68rwCVNVHKwuAfcljDj4m2eJQFUfuhSIiWIeFBhg=;
        b=Eccp74tv8+3YPGXQqeJJ/19UOzjqKJ+1+BxZpIvc/r+QI9EN1z6IM48RSvJyQvDHR3
         wDH4RaXmB9ph3LMDKEtMlwoz9PfkuWpMR6CWB0WlLM4XA3TKpgMyw6AieO70q+2AVdM6
         8gkCZKu84PQxWU93nRNmfsDeRmn77tp4TvoF/iFrtnWIbC247shHH/xytpigUt7npA9J
         hPk8i3GAh3mPNB6fAfN+RGKEKylO1T84vOqJBuda0XoFq1JOSvRTZO0PlcgaZtyolVAX
         5ps5J+TbNbgZci53aiW0Ap7rOQcQx1XAxWavGTi1DATqvRjpZKueTl/hLp/k15TVzJhU
         iIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGZ68rwCVNVHKwuAfcljDj4m2eJQFUfuhSIiWIeFBhg=;
        b=Mbk3LVnA/h/LjW1pK7wcvrx7nmUi+bvuGUUSyQAL/cA8l3uS7IK9UwjAGY5DX+c33V
         KE6gJsiOYvUJFwIqQg9V20hyHZnWxtIrs0mxcJ9LkbaczGjAaie3bHKNKLcIwLhkdBrq
         bPtjNQBShqjUoIwPwfs/7q+Q0HR9mfrpBC29fhlwxFPN2FqWsZasEPTr6NqX2LCZZhCw
         PZ+ll8ih7qLH+JMDSN9Fz+UDm3eu+Wx5JyBuBVJ8n0+Eg+/aNZVo/L5vDmv9yqUBigQP
         jzeWMRUiASUvp+2P8MF3j6xPsaKDAYL31fnvY/YUSSDof4LP4ZdZjqK3ceyneZoxv+HF
         bXKA==
X-Gm-Message-State: AOAM530I9A77DJNwC3mVtBpzMJlZ4Jt3AQGrtNyvkIKNF6X1s+FkZdsE
        MQI/yKmMu1oxpd8qgKbhbgv3rnkPldwPwA==
X-Google-Smtp-Source: ABdhPJyJhH1QeeywqOsm/Bv2jCbi3sASIIvXRkAD7ACaecgB3uMvSAzj3asp4sfK/4NfgfnFLMgnPA==
X-Received: by 2002:ac8:d87:: with SMTP id s7mr6658151qti.32.1616125206449;
        Thu, 18 Mar 2021 20:40:06 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:ed59:df3e:7ad8:c600])
        by smtp.googlemail.com with ESMTPSA id 19sm3344621qkv.95.2021.03.18.20.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 20:40:06 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] crypto: qat - fix couple crashes duing error handling
Date:   Thu, 18 Mar 2021 23:39:58 -0400
Message-Id: <20210319034001.435117-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YFOLPn31KF7bW6T/@silpixa00400314>
References: <YFOLPn31KF7bW6T/@silpixa00400314>
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
v4: fix commit log typos
v5: fix headline

Tong Zhang (2):
  crypto: qat - don't release uninitialized resources
  crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    |  4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     |  4 ++--
 drivers/crypto/qat/qat_common/adf_vf_isr.c  | 17 +++++++++++++----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c |  4 ++--
 4 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.25.1

