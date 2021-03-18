Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B54C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5371664F4D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhCRQV5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhCRQVq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 12:21:46 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BECC06174A;
        Thu, 18 Mar 2021 09:21:45 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id f12so4505652qtq.4;
        Thu, 18 Mar 2021 09:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7VgRXV2jiSQknwo24vXmP8SBaCgfC+hQjO+51l0g2/k=;
        b=bJBC+JuohpQjJ+K8y5G7q9pE3ICUnO3iOh5uuiz+UFBgu2FWPQE67qbC1UbBkd6kiM
         TYN4xt0MTMKllMcDX7jgCjAgfJSsNzo3IfRfe3Q1wtKFIVZSoQF1NZHa3PlqcbYgRRsW
         SLYr5Ustul95K9g6M8PU1UixV4JBbOSM1ZqoDFChY3PEjmwae/qDnPNWR9yVd3/z+uus
         yhzQz3lhc5hHxijFdgBWllAAy9jnjMxQs1Og5d+L8lS/Q192LfTXotY0wgmcFQyAqCwq
         kHnTGCpFAWLFfYbmwsn8XhZEjYndJ1FRoYn+PP60blNwfU9INFwE2u0jlqFonE5nGZND
         c/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7VgRXV2jiSQknwo24vXmP8SBaCgfC+hQjO+51l0g2/k=;
        b=hk5OUFqBaIUZVAuVPJZDNNK5jOGApqpmuzCgM+twwvP+gJ1gnbYLzd+3BVy+6HrCag
         rX0QKlGfidIPXc4GXLxr2qwgJ2oDxZ9heyouwg2HJr2woXlYVweRaFx+xr2doxbXonYQ
         fCyyPS2+1hrbLJlffwhkqhxFlpes+ShAO/Ysqss7Pk3QnspvNw9fCCXordFPIXjomfUF
         JH7TLsHbzsL2Haq1ukLt3r7ECGnEDpdMOwSNfdZHdrM3oBQC+xVv6iXAor4vAyPUd1e9
         0JYosz65ObGvR09qAFeCJIztqXIjCUjfUmUo4H788nQH1B6SUqkeFAjzOAzVhWD4u60j
         4O8w==
X-Gm-Message-State: AOAM531uIdG5QN2xEkWAmXOEu5piqI+K43pkjTWdUM8ds4OFEoAOQK3e
        aWzagGEJ0EBYHqayMBwX6dM=
X-Google-Smtp-Source: ABdhPJzf/ww+AjA8rav8NcjphE9/IqW1BpMySzFaZgolimJ5hF2DRXBQMQux9RWhGENQPpd8VND2Qg==
X-Received: by 2002:ac8:5510:: with SMTP id j16mr4423751qtq.339.1616084505202;
        Thu, 18 Mar 2021 09:21:45 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:d4e9:423a:4aca:b208])
        by smtp.googlemail.com with ESMTPSA id d14sm2230722qkg.33.2021.03.18.09.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 09:21:44 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v4 0/2] crypto: qat: fix couple crashes duing error handling
Date:   Thu, 18 Mar 2021 12:21:03 -0400
Message-Id: <20210318162105.378239-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YFN6hlz/L7erLO0H@silpixa00400314>
References: <YFN6hlz/L7erLO0H@silpixa00400314>
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

