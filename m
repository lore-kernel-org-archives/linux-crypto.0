Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE18C54E8B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 04:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3B220730
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 04:09:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MbXe+HW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgELEJY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 00:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725946AbgELEJY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 00:09:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B62C061A0C
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2020 21:09:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so8850474pjh.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2020 21:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7aGIDKJhsEoY1eFnx3GCg/ODucM/74uibRkoUrBNgnI=;
        b=MbXe+HW+y1nKNTeJX7Rkc7vQR92xitRyMqVJP0a6SsxnDbH6iUYomnq74hWzkTZ68f
         VsDEXcDNI+WiQL7KRKURgC+DnubpxvtlSqRn6orZ3t6ahJUtWU/jba1VmPfGbrAQFqe9
         d0BOXtDZ+KmfLxAs01EAm+ZevUv5lCcWOdbmkxj/n/F+TajL6AyfojV7uQRSExlmsqBt
         LzIIpV/HCvUMd5y8iKO9j+SJ+YZ0MESDLDGKnwdAtg4g2nGjok30yTiubZY4Wdh/s4tp
         eZT6ISiSZ2ssxGHdJ8crKSCVmJ+01cXY+GFP12rW456eaMSvowo+kn4HrkR1btVPh/JZ
         jPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7aGIDKJhsEoY1eFnx3GCg/ODucM/74uibRkoUrBNgnI=;
        b=jh+4Ms8oDGxV9qSMkHtMakjzNFPrcSGfz8v7TZqO5kLclh6E4B34G0m8U/3+ISbiP0
         CkJtInfxPGRl+GD+y+hNzQG8mvz4SvdZSNN+afBKkY793ASp5XrtNBGra2C/H03clfa+
         /BZuuOMkDhJCVGOwfctf0H3SdXx0nxx9essmXbqde/m+UaHlZVATW2FjwhdET79PrvWY
         N2quKik/FDH65yFJcs2jxCnqu9gpTMReNBJdT/Ap0yNzTv7bu++xtErIkI3MwFBezfhl
         IeBGhh0m9vSZSX2AZzQ13hLcr33W1ovKzZxB6Uy8JAH/O9NEhAihoZUGc5s4dU94osnG
         nqnw==
X-Gm-Message-State: AGi0PuYGBhB3+f/lxnr3yROJFairj8EAg8BA7sECt7lbY7IWk8Hv7Pwl
        WueFBi9Ph6XdDuh83ltOfe8iTA==
X-Google-Smtp-Source: APiQypLaB23RJirP/v+StJWLJjQaMOF0325fVzznuPTbvKpEkcQWNB3eHs32G8ciUzq8DPIby5tNug==
X-Received: by 2002:a17:902:c281:: with SMTP id i1mr18100582pld.85.1589256563703;
        Mon, 11 May 2020 21:09:23 -0700 (PDT)
Received: from localhost.localdomain ([240e:362:443:6f00:91af:f25c:441c:7ba4])
        by smtp.gmail.com with ESMTPSA id e4sm9471527pge.45.2020.05.11.21.09.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 21:09:23 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Joerg Roedel <joro@8bytes.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        jean-philippe <jean-philippe@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 1/2] iommu/of: Let pci_fixup_final access iommu_fwnode
Date:   Tue, 12 May 2020 12:08:30 +0800
Message-Id: <1589256511-12446-2-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589256511-12446-1-git-send-email-zhangfei.gao@linaro.org>
References: <1589256511-12446-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Calling pci_fixup_final after of_pci_iommu_init, which alloc
iommu_fwnode. Some platform devices appear as PCI but are
actually on the AMBA bus, and they need fixup in
drivers/pci/quirks.c handling iommu_fwnode.
So calling pci_fixup_final after iommu_fwnode is allocated.

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/iommu/of_iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index 20738aac..c1b58c4 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -188,6 +188,7 @@ const struct iommu_ops *of_iommu_configure(struct device *dev,
 		pci_request_acs();
 		err = pci_for_each_dma_alias(to_pci_dev(dev),
 					     of_pci_iommu_init, &info);
+		pci_fixup_device(pci_fixup_final, to_pci_dev(dev));
 	} else if (dev_is_fsl_mc(dev)) {
 		err = of_fsl_mc_iommu_init(to_fsl_mc_device(dev), master_np);
 	} else {
-- 
2.7.4

