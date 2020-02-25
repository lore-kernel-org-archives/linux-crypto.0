Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA39C35DF2
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 06:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351E621744
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 06:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LD38JGPy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgBYGSh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:18:37 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34585 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYGSg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 01:18:36 -0500
Received: by mail-pg1-f194.google.com with SMTP id j4so6368897pgi.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2020 22:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=e+7bx8lUSmVrpWTazNQW1i3Mowvkih4cewfdKjPmTy4=;
        b=LD38JGPy04uN1yjFhWdfFm1TtlN5JgFs3svtOJ1YyG0FCVGaxcb5+GNmYLZ51tZSyo
         oAFCOPJ1OYAZHQJwG7Za4U0bB6QEtc5CYqQMpI640/Le3MUj84E7pAFPupiEhd4GHTUa
         PJRNaM+SkDUbk8YDrrJo7PECOudld1MQA6fnnKufEfkQ76Kn+sSN/ZT9n56DiWAVMh4g
         NR1ZvHsHxp0isifDUS+lnFU3+yJMOxtP7iM+Kri8CXZwOe01S448gTpYYtW561G2pDlo
         SJDOKuPlUN42+hZpH2ux8o20rUcLHP7fOvXOO/T3c/yMRxwETFsrsX/31tRRWw1Tl6OR
         /sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e+7bx8lUSmVrpWTazNQW1i3Mowvkih4cewfdKjPmTy4=;
        b=gcdP0YaXfxs+aHiKudOdCGAUj9FvU+qa8P8JAyPohjDdsXhh8cydBqK0A0LWA/KSl5
         DIk1Tkp1Tuw3f9DdbOxhW1rguFDUrhaJGGOBQg5kHm0neh/h6FkUXTbIoXri42LM1jy4
         +RXY1aPltNPkz/Sq324DceMGT7LRKBN5ZV5akoYHDr5FKK2Ib0b2Jb2KvtbxQN0u1RpG
         b/v2KBzRSJpySV2ZqM4mCVTeTQSiMyaC1e10o8m618Y+cswfAKyw1c9WiYPA1WQ1QGa3
         lrZMFFHZckorKxSec3APo9a74rL59MBiPthrbW0pI3AOLaaJX62ezFiRR+jJHFF3YlPQ
         eydg==
X-Gm-Message-State: APjAAAUQbkCwnkoUwOyb46X+dfHeLh2L/QIPoCfAavu5PP5GfVzmqTSv
        +agjsSTwOyyvanrVhsIixtgg3Q==
X-Google-Smtp-Source: APXvYqxEzw4tKr8TWATiCEQ2SB4wrPgMGenyQG6KArzN8Y17gzlGpHwMZyTpBuJ3nI6rVsIaKjJepA==
X-Received: by 2002:a65:4b83:: with SMTP id t3mr55484000pgq.195.1582611514690;
        Mon, 24 Feb 2020 22:18:34 -0800 (PST)
Received: from localhost.localdomain ([240e:362:421:7f00:524:e1bd:8061:a346])
        by smtp.gmail.com with ESMTPSA id q17sm15038327pfg.123.2020.02.24.22.18.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Feb 2020 22:18:34 -0800 (PST)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] MAINTAINERS: add maintainers for uacce
Date:   Tue, 25 Feb 2020 14:17:55 +0800
Message-Id: <1582611475-32691-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add Zhangfei Gao and Zhou Wang as maintainers for uacce

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38fe2f3..22e647f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17039,6 +17039,16 @@ W:	http://linuxtv.org
 S:	Maintained
 F:	drivers/media/pci/tw686x/
 
+UACCE ACCELERATOR FRAMEWORK
+M:	Zhangfei Gao <zhangfei.gao@linaro.org>
+M:	Zhou Wang <wangzhou1@hisilicon.com>
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-driver-uacce
+F:	Documentation/misc-devices/uacce.rst
+F:	drivers/misc/uacce/
+F:	include/linux/uacce.h
+F:	include/uapi/misc/uacce/
+
 UBI FILE SYSTEM (UBIFS)
 M:	Richard Weinberger <richard@nod.at>
 L:	linux-mtd@lists.infradead.org
-- 
2.7.4

