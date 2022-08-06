Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117DCC25B08
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Aug 2022 02:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbiHFCgz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Aug 2022 22:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbiHFCgy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Aug 2022 22:36:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F398C1260A;
        Fri,  5 Aug 2022 19:36:52 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M064W1XNzzmV6B;
        Sat,  6 Aug 2022 10:34:51 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 6 Aug 2022 10:36:50 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 6 Aug
 2022 10:36:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        <yekai13@huawei.com>
Subject: [PATCH v7 2/3] Documentation: add a isolation strategy sysfs node for uacce
Date:   Sat, 6 Aug 2022 10:29:42 +0800
Message-ID: <20220806022943.47292-3-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220806022943.47292-1-yekai13@huawei.com>
References: <20220806022943.47292-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
index 08f2591138af..e09fd160d3fa 100644
--- a/Documentation/ABI/testing/sysfs-driver-uacce
+++ b/Documentation/ABI/testing/sysfs-driver-uacce
@@ -19,6 +19,32 @@ Contact:        linux-accelerators@lists.ozlabs.org
 Description:    Available instances left of the device
                 Return -ENODEV if uacce_ops get_available_instances is not provided
 
+What:           /sys/class/uacce/<dev_name>/isolate_strategy
+Date:           Jul 2022
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
+Date:           Jul 2022
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
2.33.0

