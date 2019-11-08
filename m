Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FEEFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 13:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ADEB215EA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 13:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AlnvKrZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfKHNct (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 08:32:49 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41840 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfKHNcs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 08:32:48 -0500
Received: by mail-pf1-f196.google.com with SMTP id p26so4569239pfq.8
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 05:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cfpg9lXoO3GI47l6Tfb34t3Cc2krZOv/mwnJIDHcsuU=;
        b=AlnvKrZSDjhFhHQKGbJ0yHRmOF2f7eIwvtbPB1f41P0mADSoSuFRC5XLKstkF5GyGv
         jpTLnHqB1NyIHWMicumN4qfjGO924EMzn/9RHGR/mwZhWiK9EwUbbN3rKHGoxi9wA1lo
         TfVxZALVVWqPj5L/5rwjTyzRD+PhWofziNJvxSI7QIzsHhlENwK5G+2yukGGyFAcP0pL
         pY7XYWE/vl42bdjafrethrK/+mD4mctyfaZzVjBcJ0hU1bOipYBPaeHat8JUTV9RirE9
         zqAdIPp5rA9PadF/JOq/HhtvvwmnBn6LhUKaFtNyD/GWvHNgoOQMUlNLY2IUKFVuUnf8
         ddxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cfpg9lXoO3GI47l6Tfb34t3Cc2krZOv/mwnJIDHcsuU=;
        b=HIUmSWLl7UKwGGckSi2/zHvkEggtHC1PRfz8Tu3kOePM0Tz4vSI/iLo/nF2vup4zTf
         +w7xSH3HaAaRhlrRmagvpsbav+uU/xrnY38z0jeCuePnsQoE7oJPtCgkQ5QHcUt4O27u
         6PGIUtu3A+g5BnZhHrdMs1ljuV8IgLxLkA4bIR68GtOzo5H3ssQnXlip07ht5JZptNUo
         MQs6ASp0huYpBTXFl6oAjS3XqtivODIL30v5SeIhqNqhkGbgyZy+gwd4ueTbeaku+hoe
         g1/qmvMOoGlWZZCnpWE0oumUje9bwIWpHPV14qEK+lpiOku1MO5iW3cnBk85t9X1mwfr
         Cg5A==
X-Gm-Message-State: APjAAAUMfpKuGcAvXOVOlPxxEMTgDEQPTRlLgZhIi3tX+QSp1s/r2t9t
        /ZxmurxqJAmyfknrzaKNMWut5A==
X-Google-Smtp-Source: APXvYqzsQci13mj/NN354men4VxF5/iUCTIRRJuRiUNMB9If1jjY8p3pbhWQuTF7cemrHzE1n3y7Tw==
X-Received: by 2002:a17:90a:a102:: with SMTP id s2mr13734284pjp.48.1573219968023;
        Fri, 08 Nov 2019 05:32:48 -0800 (PST)
Received: from localhost.localdomain ([240e:362:48f:8f00:79bd:a8a7:1834:2d1a])
        by smtp.gmail.com with ESMTPSA id 12sm7626483pjm.11.2019.11.08.05.32.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 05:32:47 -0800 (PST)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [RESEND PATCH v8 1/3] uacce: Add documents for uacce
Date:   Fri,  8 Nov 2019 21:31:42 +0800
Message-Id: <1573219904-17594-2-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573219904-17594-1-git-send-email-zhangfei.gao@linaro.org>
References: <1573219904-17594-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

Uacce (Unified/User-space-access-intended Accelerator Framework) is
a kernel module targets to provide Shared Virtual Addressing (SVA)
between the accelerator and process.

This patch add document to explain how it works.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 Documentation/misc-devices/uacce.rst | 159 +++++++++++++++++++++++++++++++++++
 1 file changed, 159 insertions(+)
 create mode 100644 Documentation/misc-devices/uacce.rst

diff --git a/Documentation/misc-devices/uacce.rst b/Documentation/misc-devices/uacce.rst
new file mode 100644
index 0000000..733521a
--- /dev/null
+++ b/Documentation/misc-devices/uacce.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Introduction of Uacce
+---------------------
+
+Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
+provide Shared Virtual Addressing (SVA) between accelerators and processes.
+So accelerator can access any data structure of the main cpu.
+This differs from the data sharing between cpu and io device, which share
+only data content rather than address.
+Because of the unified address, hardware and user space of process can
+share the same virtual address in the communication.
+Uacce takes the hardware accelerator as a heterogeneous processor, while
+IOMMU share the same CPU page tables and as a result the same translation
+from va to pa.
+
+	 __________________________       __________________________
+	|                          |     |                          |
+	|  User application (CPU)  |     |   Hardware Accelerator   |
+	|__________________________|     |__________________________|
+
+	             |                                 |
+	             | va                              | va
+	             V                                 V
+                 __________                        __________
+                |          |                      |          |
+                |   MMU    |                      |  IOMMU   |
+                |__________|                      |__________|
+		     |                                 |
+	             |                                 |
+	             V pa                              V pa
+		 _______________________________________
+		|                                       |
+		|              Memory                   |
+		|_______________________________________|
+
+
+
+Architecture
+------------
+
+Uacce is the kernel module, taking charge of iommu and address sharing.
+The user drivers and libraries are called WarpDrive.
+
+The uacce device, built around the IOMMU SVA API, can access multiple
+address spaces, including the one without PASID.
+
+A virtual concept, queue, is used for the communication. It provides a
+FIFO-like interface. And it maintains a unified address space between the
+application and all involved hardware.
+
+                             ___________________                  ________________
+                            |                   |   user API     |                |
+                            | WarpDrive library | ------------>  |  user driver   |
+                            |___________________|                |________________|
+                                     |                                    |
+                                     |                                    |
+                                     | queue fd                           |
+                                     |                                    |
+                                     |                                    |
+                                     v                                    |
+     ___________________         _________                                |
+    |                   |       |         |                               | mmap memory
+    | Other framework   |       |  uacce  |                               | r/w interface
+    | crypto/nic/others |       |_________|                               |
+    |___________________|                                                 |
+             |                       |                                    |
+             | register              | register                           |
+             |                       |                                    |
+             |                       |                                    |
+             |                _________________       __________          |
+             |               |                 |     |          |         |
+              -------------  |  Device Driver  |     |  IOMMU   |         |
+                             |_________________|     |__________|         |
+                                     |                                    |
+                                     |                                    V
+                                     |                            ___________________
+                                     |                           |                   |
+                                     --------------------------  |  Device(Hardware) |
+                                                                 |___________________|
+
+
+How does it work
+----------------
+
+Uacce uses mmap and IOMMU to play the trick.
+
+Uacce creates a chrdev for every device registered to it. New queue is
+created when user application open the chrdev. The file descriptor is used
+as the user handle of the queue.
+The accelerator device present itself as an Uacce object, which exports as
+a chrdev to the user space. The user application communicates with the
+hardware by ioctl (as control path) or share memory (as data path).
+
+The control path to the hardware is via file operation, while data path is
+via mmap space of the queue fd.
+
+The queue file address space:
+/**
+ * enum uacce_qfrt: qfrt type
+ * @UACCE_QFRT_MMIO: device mmio region
+ * @UACCE_QFRT_DUS: device user share region
+ */
+enum uacce_qfrt {
+	UACCE_QFRT_MMIO = 0,
+	UACCE_QFRT_DUS = 1,
+};
+
+All regions are optional and differ from device type to type.
+Each region can be mmapped only once, otherwise -EEXIST returns.
+
+The device mmio region is mapped to the hardware mmio space. It is generally
+used for doorbell or other notification to the hardware. It is not fast enough
+as data channel.
+
+The device user share region is used for share data buffer between user process
+and device.
+
+
+The Uacce register API
+----------------------
+
+The register API is defined in uacce.h.
+
+  struct uacce_interface {
+    char name[UACCE_MAX_NAME_SIZE];
+    unsigned int flags;
+    const struct uacce_ops *ops;
+  };
+
+According to the IOMMU capability, uacce_interface flags can be:
+
+/**
+ * UACCE Device flags:
+ * UACCE_DEV_SVA: Shared Virtual Addresses
+ *		  Support PASID
+ *		  Support device page faults (PCI PRI or SMMU Stall)
+ */
+#define UACCE_DEV_SVA		BIT(0)
+
+struct uacce_device *uacce_register(struct device *parent,
+				    struct uacce_interface *interface);
+void uacce_unregister(struct uacce_device *uacce);
+
+uacce_register results can be:
+a. If uacce module is not compiled, ERR_PTR(-ENODEV)
+b. Succeed with the desired flags
+c. Succeed with the negotiated flags, for example
+   uacce_interface.flags = UACCE_DEV_SVA but uacce->flags = ~UACCE_DEV_SVA
+So user driver need check return value as well as the negotiated uacce->flags.
+
+
+The user driver
+---------------
+
+The queue file mmap space will need a user driver to wrap the communication
+protocol. Uacce provides some attributes in sysfs for the user driver to
+match the right accelerator accordingly.
+More details in Documentation/ABI/testing/sysfs-driver-uacce.
-- 
2.7.4

