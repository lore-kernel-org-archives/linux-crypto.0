Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6262C33CA2
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AF420721
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zon1z+fD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgAKCtU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 21:49:20 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50447 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgAKCtU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 21:49:20 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so1739837pjb.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jan 2020 18:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Src2nBsw9fEQNe6R1XRh63qOf6PvwHbP1eF/87qT/L8=;
        b=zon1z+fDBjXiRsMSwu05omQuZYvOqXql+zCa8Br5nqk4HK1jrNPzbOxLOEDgA3DPCc
         i1IP8u/jhgI3NLD3d9Ia02QqaqqxseH00p7gjFl4c5VXMH751nC/YQwayZhYWaDJRsbm
         WDnOfKdDagkiXAlm5HH7+kW7nuhdp25/yA02hx21xZSSduyhbwSHBjZjVc7sSBiOPJtr
         EDDHqtf+n6pTpIbn55WYvTJtvsqSAXOej2R1yrPD/0IA3lN9sX/DTqJCxFu2/uG4vw3I
         4K/VHYNzvM4n4dHGFTZ9hIo2qO9IS04uwR2qsuINqBr4pqA0Tfa2O8euXmyQN+QDlyoa
         5waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Src2nBsw9fEQNe6R1XRh63qOf6PvwHbP1eF/87qT/L8=;
        b=QR+FOtviuUzmervHLZ8bqkpb8sqHvQ95gnhdK5Ad5SLn0cLi+CFKWAM3u+qYNEY7y1
         ILh1/shJ3yU+SiVQQx0AUMcehajzg+RQROeIrrC5HiLHNtloSmu7Xwart2xEEGeawN10
         bsZaLNr5pmhfgx1Mezw0zTM+paQJVyMYGvawFdt09LPyUBMNr0U99uDD2vXzN4cgHmhy
         kHHHvYV6ZitDh99X9vVUqReyDZTATL06OuWa9nsY0/u1l/CFNiS2s2hLRLxEz+fz1wHr
         rD7ajKHVOtBX+74aWUQORuXX4VohGfQRxOYf8MtU5peib/Qxkr/oCw3LoMtPOBeP1FJH
         Leaw==
X-Gm-Message-State: APjAAAXMNm9MRk3HamBR5eRHKd/tY7AhcdAebNoIUCidKE77wwYisoH5
        dZAjId8q+fOkT5n4mGibg4kmJQ==
X-Google-Smtp-Source: APXvYqwHY/NFGM9xaKHobefOMhuMBwmLyhmyEkORUvj+2cyx2sCTy/sEb+YOYUjyqIFZSqh0ejOcrA==
X-Received: by 2002:a17:90a:c697:: with SMTP id n23mr8672088pjt.37.1578710959555;
        Fri, 10 Jan 2020 18:49:19 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.78])
        by smtp.gmail.com with ESMTPSA id r7sm4778472pfg.34.2020.01.10.18.49.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 Jan 2020 18:49:19 -0800 (PST)
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
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v11 1/4] uacce: Add documents for uacce
Date:   Sat, 11 Jan 2020 10:48:36 +0800
Message-Id: <1578710919-12141-2-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578710919-12141-1-git-send-email-zhangfei.gao@linaro.org>
References: <1578710919-12141-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

Uacce (Unified/User-space-access-intended Accelerator Framework) is
a kernel module targets to provide Shared Virtual Addressing (SVA)
between the accelerator and process.

This patch add document to explain how it works.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 Documentation/misc-devices/uacce.rst | 176 +++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)
 create mode 100644 Documentation/misc-devices/uacce.rst

diff --git a/Documentation/misc-devices/uacce.rst b/Documentation/misc-devices/uacce.rst
new file mode 100644
index 0000000..1db412e
--- /dev/null
+++ b/Documentation/misc-devices/uacce.rst
@@ -0,0 +1,176 @@
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
+::
+
+         __________________________       __________________________
+        |                          |     |                          |
+        |  User application (CPU)  |     |   Hardware Accelerator   |
+        |__________________________|     |__________________________|
+
+                     |                                 |
+                     | va                              | va
+                     V                                 V
+                 __________                        __________
+                |          |                      |          |
+                |   MMU    |                      |  IOMMU   |
+                |__________|                      |__________|
+                     |                                 |
+                     |                                 |
+                     V pa                              V pa
+                 _______________________________________
+                |                                       |
+                |              Memory                   |
+                |_______________________________________|
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
+::
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
+
+::
+
+   /**
+   * enum uacce_qfrt: qfrt type
+   * @UACCE_QFRT_MMIO: device mmio region
+   * @UACCE_QFRT_DUS: device user share region
+   */
+  enum uacce_qfrt {
+          UACCE_QFRT_MMIO = 0,
+          UACCE_QFRT_DUS = 1,
+  };
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
+::
+
+  struct uacce_interface {
+    char name[UACCE_MAX_NAME_SIZE];
+    unsigned int flags;
+    const struct uacce_ops *ops;
+  };
+
+According to the IOMMU capability, uacce_interface flags can be:
+
+::
+
+  /**
+   * UACCE Device flags:
+   * UACCE_DEV_SVA: Shared Virtual Addresses
+   *              Support PASID
+   *              Support device page faults (PCI PRI or SMMU Stall)
+   */
+  #define UACCE_DEV_SVA               BIT(0)
+
+  struct uacce_device *uacce_alloc(struct device *parent,
+                                   struct uacce_interface *interface);
+  int uacce_register(struct uacce_device *uacce);
+  void uacce_remove(struct uacce_device *uacce);
+
+uacce_register results can be:
+
+a. If uacce module is not compiled, ERR_PTR(-ENODEV)
+
+b. Succeed with the desired flags
+
+c. Succeed with the negotiated flags, for example
+
+  uacce_interface.flags = UACCE_DEV_SVA but uacce->flags = ~UACCE_DEV_SVA
+
+  So user driver need check return value as well as the negotiated uacce->flags.
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

