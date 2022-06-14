Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9BEC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jun 2022 12:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiFNM6s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jun 2022 08:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244781AbiFNM6X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jun 2022 08:58:23 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AF42B18B;
        Tue, 14 Jun 2022 05:58:23 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LMnty2sHMzjXc0;
        Tue, 14 Jun 2022 20:34:34 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 20:36:03 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 14 Jun
 2022 20:36:03 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-accelerators@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
        <yekai13@huawei.com>
Subject: [PATCH v2 2/3] Documentation: add a isolation strategy vfs node for uacce
Date:   Tue, 14 Jun 2022 20:29:39 +0800
Message-ID: <20220614122943.1406-3-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220614122943.1406-1-yekai13@huawei.com>
References: <20220614122943.1406-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update documentation describing DebugFS that could help to
configure hard error frequency for users in th user space.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 Documentation/ABI/testing/sysfs-driver-uacce | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
index 08f2591138af..0c4226364182 100644
--- a/Documentation/ABI/testing/sysfs-driver-uacce
+++ b/Documentation/ABI/testing/sysfs-driver-uacce
@@ -19,6 +19,23 @@ Contact:        linux-accelerators@lists.ozlabs.org
 Description:    Available instances left of the device
                 Return -ENODEV if uacce_ops get_available_instances is not provided
 
+What:           /sys/class/uacce/<dev_name>/isolate_strategy
+Date:           Jun 2022
+KernelVersion:  5.19
+Contact:        linux-accelerators@lists.ozlabs.org
+Description:    A vfs node that used to configures the hardware
+                error frequency. This frequency is abstract. Like once an hour
+                or once a day. The specific isolation strategy can be defined in
+                each driver module.
+
+What:           /sys/class/uacce/<dev_name>/isolate
+Date:           Jun 2022
+KernelVersion:  5.19
+Contact:        linux-accelerators@lists.ozlabs.org
+Description:    A vfs node that show the device isolated state. The value 0
+                means that the device is working. The value 1 means that the
+                device has been isolated.
+
 What:           /sys/class/uacce/<dev_name>/algorithms
 Date:           Feb 2020
 KernelVersion:  5.7
-- 
2.33.0

