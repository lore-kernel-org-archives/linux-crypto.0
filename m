Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F46FECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 03:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiIBDTI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 23:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiIBDTF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 23:19:05 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BFE844C0;
        Thu,  1 Sep 2022 20:19:01 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJjgt1JsjzYd3N;
        Fri,  2 Sep 2022 11:14:34 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 2 Sep 2022 11:18:59 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 11:18:59 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        <yekai13@huawei.com>
Subject: [PATCH v8 2/3] Documentation: add a isolation strategy sysfs node for uacce
Date:   Fri, 2 Sep 2022 03:13:03 +0000
Message-ID: <20220902031304.37516-3-yekai13@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220902031304.37516-1-yekai13@huawei.com>
References: <20220902031304.37516-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update documentation describing sysfs node that could help to
configure isolation strategy for users in the user space. And
describing sysfs node that could read the device isolated state.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 Documentation/ABI/testing/sysfs-driver-uacce | 26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
index 08f2591138af..af5bc2f326d2 100644
--- a/Documentation/ABI/testing/sysfs-driver-uacce
+++ b/Documentation/ABI/testing/sysfs-driver-uacce
@@ -19,6 +19,32 @@ Contact:        linux-accelerators@lists.ozlabs.org
 Description:    Available instances left of the device
                 Return -ENODEV if uacce_ops get_available_instances is not provided
 
+What:           /sys/class/uacce/<dev_name>/isolate_strategy
+Date:           Sep 2022
+KernelVersion:  6.0
+Contact:        linux-accelerators@lists.ozlabs.org
+Description:    (RW) Configure the frequency size for the hardware error
+                isolation strategy. This size is a configured integer value.
+                The default is 0. The maximum value is 65535. This value is a
+                threshold based on your driver strategies.
+
+                For example, in the hisilicon accelerator engine, first we will
+                time-stamp every slot AER error. Then check the AER error log
+                when the device AER error occurred. if the device slot AER error
+                count exceeds the preset the number of times in one hour, the
+                isolated state will be set to true. So the device will be
+                isolated. And the AER error log that exceed one hour will be
+                cleared. Of course, different strategies can be defined in
+                different drivers.
+
+What:           /sys/class/uacce/<dev_name>/isolate
+Date:           Sep 2022
+KernelVersion:  6.0
+Contact:        linux-accelerators@lists.ozlabs.org
+Description:    (R) A sysfs node that read the device isolated state. The value 1
+                means the device is unavailable. The 0 means the device is
+                available.
+
 What:           /sys/class/uacce/<dev_name>/algorithms
 Date:           Feb 2020
 KernelVersion:  5.7
-- 
2.17.1

