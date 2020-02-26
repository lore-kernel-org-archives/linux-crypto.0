Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E8CC4BA06
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 01:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 770E121927
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 01:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eSRfJrrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgBZB3B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 20:29:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43757 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgBZB3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 20:29:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so530867pfh.10
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2020 17:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vHnoiE2Lvw7hwJiHoxNVUEj7j+4ABzT2vnGBT++TeTk=;
        b=eSRfJrrbKwAkCJ/OfjPbB07snFeA90jhWtm3D1d/Ao4a8YWY5b/butwclrugMtQyto
         YUBnjKdnkb/m4/PV0VlWgwZVMENu91ZfRJQD4h9ez7V68ZunetMSLyhRCo8QCnFeTBAu
         3AeMMOOGQdycc11Tsvka8XDTeif5lp7H5oneJs1a+o+hFsafhWOXzMrMLf+N01NSzxDA
         manhXFzq0Gs/cLY8UO7k5q5LuPRSKBV1JTSuu+5L0hWMYk/2CeEkIvjGuRwFdUEHNx6Z
         TKD0Wd/29fJQexSTPplm65QkreJV7c+Tr7NZQEVC4ctA4Rov2zX6Y7hKVXbufTeQkbQg
         VE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vHnoiE2Lvw7hwJiHoxNVUEj7j+4ABzT2vnGBT++TeTk=;
        b=aHpJX9y5hJPSpeFxTxuv46th4rW/hbSJRF3/iJYdLD05ofI7wq4IC7XGri++M88A4E
         gCoY/J7pvR7JdWh+RxedbfUoZdRWtght5j8Y2Igj7V3eqS56N6GnfxkINA+Y/qAd3VM8
         1PB/dTtNQqZTlCtMuQoLfs9SK1o3Zfx8s2fQd9K31paMs5kMSgCD/eohfyVxBznWCEen
         hz8DiI4IwFLkzz4IBRRKpkoYrpBvVUbPFRJ9tB5NvYcXXBGUnbAL7CbK/4Opvw5WJ01B
         7dELmxwpckzzM+dOP1lA7xwyuwKDWrymxOi7k1HzyWaVSItpBqoRlDCX/SosjKQolLDP
         mBDg==
X-Gm-Message-State: APjAAAVBrz2d57g1Orhw6qa93QAJRX9Z8nYG3E74z4EV/rrH9a3qCVxM
        bHlmnFvegohjaE0gy3rKXkJV0g==
X-Google-Smtp-Source: APXvYqwUNwVRv+swWTZ2eRfOm2MCq483DsIDj+WOD8rH3A5r3EhuhbWBu8Nj/QxikFbvKlieVP4Edw==
X-Received: by 2002:a63:214e:: with SMTP id s14mr1264455pgm.428.1582680538680;
        Tue, 25 Feb 2020 17:28:58 -0800 (PST)
Received: from localhost.localdomain ([240e:362:4c3:8800:a057:bb7f:18d7:2e])
        by smtp.gmail.com with ESMTPSA id q11sm326994pff.111.2020.02.25.17.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Feb 2020 17:28:58 -0800 (PST)
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
Subject: [PATCH v2] MAINTAINERS: add maintainers for uacce
Date:   Wed, 26 Feb 2020 09:28:28 +0800
Message-Id: <1582680508-596-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add Zhangfei Gao and Zhou Wang as maintainers for uacce

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
Add list, suggested by Dave

MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38fe2f3..b5bdef8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17039,6 +17039,18 @@ W:	http://linuxtv.org
 S:	Maintained
 F:	drivers/media/pci/tw686x/
 
+UACCE ACCELERATOR FRAMEWORK
+M:	Zhangfei Gao <zhangfei.gao@linaro.org>
+M:	Zhou Wang <wangzhou1@hisilicon.com>
+L:	linux-accelerators@lists.ozlabs.org
+L:	linux-kernel@vger.kernel.org
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

