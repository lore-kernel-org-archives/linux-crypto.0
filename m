Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4548BC54E4B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 04:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12C0320733
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 04:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zKPMo9Vx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgELEJi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 00:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbgELEJh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 00:09:37 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D672FC061A0E
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2020 21:09:37 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k19so4814172pll.9
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2020 21:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6S28BNiWmQ/hEXUnU1MTnqXBi18kA3ePoZOYdtU1cwQ=;
        b=zKPMo9VxVy3jMqZvbDFZzd0rfMvjK8sIRqKU+RRM8fhiK3BsQbxVPPqNYrdq3CNlJp
         srwFwGJmFE53BiW8OELV7eGESL1CDt3+K4ya4VOcLbsiDUEhRhJL5Hsx5wYQmr4/a1ha
         npM2phtb/qYoGwQEx97t6GacPM8Z7YAe5eoPRlt84htL5JM81zMsdpd3BUasJ+/8QsnH
         dkV7TQ2UOgKSRXuw2IGL0NHMPpGwN/hPYlde9jC+uvFu5gspfztR7vKX+YVtfvubS0Zb
         /IgWuGFfL2eesthQolXE8F1dD/HdpBfJqLHJnovOiJQqYzfmg/aL8KblwwEQlXwQIPtH
         rPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6S28BNiWmQ/hEXUnU1MTnqXBi18kA3ePoZOYdtU1cwQ=;
        b=cVeX2dabuy5AgoPkXdvk2GOYhd1tZYHA/Tcfv7aJqamiB/Roo+9DdQonbximV5R3Qi
         OoBKPcUv1FoVBt8dNK/pdeQpjnHz5AtMBUD7Q07Ymp8wJpkzjWqsSrldrI0Uy/5DMeLW
         uzOuYGA9t731+cpSbVn+ey+nRIy/8+N5pRqTKMu8kBThmi2gIxibnp2iTmxQs7TGEtCU
         bqOqXidHjzZ898Bz7IldM78c/BWax9iFq+LRIiBwFMdPve4exw+LdfhMAusDnBj3kb1N
         Nbe7wBl0suXvkQWkAsyam5zSUXK8itZLm549u3uqoYWPALAALNc142EW/hOoy9ZAkaSW
         M3kg==
X-Gm-Message-State: AGi0Pub3/PpbBmOHKxLCk/0qy92WyblBYOuFWZkfCvJ4Z3lgEEuNPKJT
        jDGPJNvdlDW+lzCAvsZcz6YWmQ==
X-Google-Smtp-Source: APiQypIz5wcptWAsZSR4zFqLILzJ6EQ/AyMRL3bPtWuTsky6Bgy54mQMi2/qmxe6ZV1FPbWCHDML+A==
X-Received: by 2002:a17:902:728e:: with SMTP id d14mr18153543pll.107.1589256577364;
        Mon, 11 May 2020 21:09:37 -0700 (PDT)
Received: from localhost.localdomain ([240e:362:443:6f00:91af:f25c:441c:7ba4])
        by smtp.gmail.com with ESMTPSA id e4sm9471527pge.45.2020.05.11.21.09.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 21:09:36 -0700 (PDT)
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
Subject: [PATCH 2/2] ACPI/IORT: Let pci_fixup_final access iommu_fwnode
Date:   Tue, 12 May 2020 12:08:31 +0800
Message-Id: <1589256511-12446-3-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589256511-12446-1-git-send-email-zhangfei.gao@linaro.org>
References: <1589256511-12446-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Calling pci_fixup_final after iommu_fwspec_init, which alloc
iommu_fwnode. Some platform devices appear as PCI but are
actually on the AMBA bus, and they need fixup in
drivers/pci/quirks.c handling iommu_fwnode.
So calling pci_fixup_final after iommu_fwnode is allocated.

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/acpi/arm64/iort.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 7d04424..02e361d 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1027,6 +1027,7 @@ const struct iommu_ops *iort_iommu_configure(struct device *dev)
 		info.node = node;
 		err = pci_for_each_dma_alias(to_pci_dev(dev),
 					     iort_pci_iommu_init, &info);
+		pci_fixup_device(pci_fixup_final, to_pci_dev(dev));
 
 		fwspec = dev_iommu_fwspec_get(dev);
 		if (fwspec && iort_pci_rc_supports_ats(node))
-- 
2.7.4

