Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59723C33CB6
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 14:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AA832467E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 14:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j62U0x2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgAOOO7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 09:14:59 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43619 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729813AbgAOONO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 09:13:14 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so8268534pga.10
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2020 06:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=h9PTvyejN3GRMSB4AbO4jpkYqH5z22ZkrxL2zHuZkz0=;
        b=j62U0x2odNFPewJF2dP4EiazwuQIaPW/CDcVJvfclCUQlH/ZGplVap+L9EqJEZFpNq
         ZZoAeRMIr1JikgeI0gQ81eEvqFJUfeRB7fTF8ChD9RzhXXA9fgUw0vcJHlZFSgoymdKw
         Ih6LXnmqN4Fmpt6iPzLC54P6BLGJ87iueFON0VhBrzoQyKipnp6tkWYprkfl9KYlHIRK
         SbjUdwIeZWu9eOQSQcisjf9HmHlP7pZnN5LC4QP8g0LxxXWzLXZlijRyQ/gcGO23r6f0
         eXCSqLNSJR9fqBjhfgwtPDclabtJtU+7aSzWOp4iXHQWkqdVnoaaoRHxlThci+fc/Id/
         JKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h9PTvyejN3GRMSB4AbO4jpkYqH5z22ZkrxL2zHuZkz0=;
        b=K57tMLJHVm9w9Gd950IpmlyQKEwLc7xP7o3boX5UJE3xOS80+o1P6FZoHw7fcqz1gl
         q2BC1uAzJaN6+5BWOpfyP/veEGwLedNEIU74aV6GaLYcAv/GDRgmO0+Rf0hpr/FtP08R
         eGra/UbqKxs9EnAAvjqQGuwb9f2n/q2/27CoMGgnDY8Unj3QShfh2kAOOjiHnAfQc9G1
         CBcmMqQZXSnlnXrXDT4HJGxOZXKZA6NqI7ONVR7ACAFzO2ipmOAvkyydJxd1fjtxZQQ7
         COJKVL5aXBp5W2s7LMI//RRm5btEbm1jCHFfLi5Nqj/D80sTnJ122WcIdWCDoxvWYaoG
         mrkA==
X-Gm-Message-State: APjAAAUaCtdt5hTvcKYANAum/87wSj8g98u794zo571DWJdIGQcznaSn
        Yp3xQnkZFFE+DrfPC41HSFA8oA==
X-Google-Smtp-Source: APXvYqx/AyZTgKS/OwX8pKt3RXL9gJGlo5L4x0HpFRZf54d+scAma22P4ilKR85dZtHwfM5Uytx5zg==
X-Received: by 2002:a65:58ce:: with SMTP id e14mr33169456pgu.153.1579097593582;
        Wed, 15 Jan 2020 06:13:13 -0800 (PST)
Received: from localhost.localdomain ([104.238.63.136])
        by smtp.gmail.com with ESMTPSA id a15sm22591980pfh.169.2020.01.15.06.12.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 Jan 2020 06:13:13 -0800 (PST)
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
Subject: [PATCH v12 0/4] Add uacce module for Accelerator
Date:   Wed, 15 Jan 2020 22:12:44 +0800
Message-Id: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
provide Shared Virtual Addressing (SVA) between accelerators and processes.
So accelerator can access any data structure of the main cpu.
This differs from the data sharing between cpu and io device, which share
data content rather than address.
Because of unified address, hardware and user space of process can share
the same virtual address in the communication.

Uacce is intended to be used with Jean Philippe Brucker's SVA
patchset[1], which enables IO side page fault and PASID support. 
We have keep verifying with Jean's sva patchset [2]
We also keep verifying with Eric's SMMUv3 Nested Stage patches [3]

This series and related zip & qm driver
https://github.com/Linaro/linux-kernel-warpdrive/tree/v5.5-rc1-uacce-v12

The library and user application:
https://github.com/Linaro/warpdrive/tree/wdprd-upstream-v12

References:
[1] http://jpbrucker.net/sva/
[2] http://jpbrucker.net/git/linux/log/?h=sva/zip-devel
[3] https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9

The series contains 4 patches,
Patch 1 & 2 are for uacce
Patch 3 & 4 are an example using uacce, which happens to be crypto, can be merged later.

Change History:
v12:
Suggested by Greg,
Remove module_get and module_put in uacce, which blocks rmmod parent module when
application are running, while application should not forbid a module from being unloaded

v11:
add Reviewed-by, and fix one mismatch with sys

v10:
Modify the include header to fix kbuild test erorr in other arch.

v9:
Suggested by Jonathan
1. Remove sysfs: numa_distance, node_id, id, also add is_visible callback
2. Split the api to solve the potential race
struct uacce_device *uacce_alloc(struct device *parent,
				 struct uacce_interface *interface)
int uacce_register(struct uacce_device *uacce)
void uacce_remove(struct uacce_device *uacce)
3. Split clean up patch 03

v8:
Address some comments from Jonathan
Merge Jean's patch, using uacce_mm instead of pid for sva_exit

v7:
As suggested by Jean and Jerome
Only consider sva case and remove unused dma apis for the first patch.
Also add mm_exit for sva and vm_ops.close etc


v6: https://lkml.org/lkml/2019/10/16/231
Change sys qfrs_size to different file, suggested by Jonathan
Fix crypto daily build issue and based on crypto code base, also 5.4-rc1.

v5: https://lkml.org/lkml/2019/10/14/74
Add an example patch using the uacce interface, suggested by Greg
0003-crypto-hisilicon-register-zip-engine-to-uacce.patch

v4: https://lkml.org/lkml/2019/9/17/116
Based on 5.4-rc1
Considering other driver integrating uacce, 
if uacce not compiled, uacce_register return error and uacce_unregister is empty.
Simplify uacce flag: UACCE_DEV_SVA.
Address Greg's comments: 
Fix state machine, remove potential syslog triggered from user space etc.

v3: https://lkml.org/lkml/2019/9/2/990
Recommended by Greg, use sturct uacce_device instead of struct uacce,
and use struct *cdev in struct uacce_device, as a result, 
cdev can be released by itself when refcount decreased to 0.
So the two structures are decoupled and self-maintained by themsleves.
Also add dev.release for put_device.

v2: https://lkml.org/lkml/2019/8/28/565
Address comments from Greg and Jonathan
Modify interface uacce_register
Drop noiommu mode first

v1: https://lkml.org/lkml/2019/8/14/277
1. Rebase to 5.3-rc1
2. Build on iommu interface
3. Verifying with Jean's sva and Eric's nested mode iommu.
4. User library has developed a lot: support zlib, openssl etc.
5. Move to misc first

RFC3:
https://lkml.org/lkml/2018/11/12/1951

RFC2:
https://lwn.net/Articles/763990/


Background of why Uacce:
Von Neumann processor is not good at general data manipulation.
It is designed for control-bound rather than data-bound application.
The latter need less control path facility and more/specific ALUs.
So there are more and more heterogeneous processors, such as
encryption/decryption accelerators, TPUs, or
EDGE (Explicated Data Graph Execution) processors, introduced to gain
better performance or power efficiency for particular applications
these days.

There are generally two ways to make use of these heterogeneous processors:

The first is to make them co-processors, just like FPU.
This is good for some application but it has its own cons:
It changes the ISA set permanently.
You must save all state elements when the process is switched out.
But most data-bound processors have a huge set of state elements.
It makes the kernel scheduler more complex.

The second is Accelerator.
It is taken as a IO device from the CPU's point of view
(but it need not to be physically). The process, running on CPU,
hold a context of the accelerator and send instructions to it as if
it calls a function or thread running with FPU.
The context is bound with the processor itself.
So the state elements remain in the hardware context until
the context is released.

We believe this is the core feature of an "Accelerator" vs. Co-processor
or other heterogeneous processors.

The intention of Uacce is to provide the basic facility to backup
this scenario. Its first step is to make sure the accelerator and process
can share the same address space. So the accelerator ISA can directly
address any data structure of the main CPU.
This differs from the data sharing between CPU and IO device,
which share data content rather than address.
So it is different comparing to the other DMA libraries.

In the future, we may add more facility to support linking accelerator
library to the main application, or managing the accelerator context as
special thread.
But no matter how, this can be a solid start point for new processor
to be used as an "accelerator" as this is the essential requirement.


The Fork Scenario
=================
For a process with allocated queues and shared memory, what happen if it forks
a child?

The fd of the queue is duplicated on fork, but requests sent from the child
process are blocked.

It is recommended to add O_CLOEXEC to the queue file.

The queue mmap space has a VM_DONTCOPY in its VMA. So the child will lose all
those VMAs.

This is a reason why Uacce does not adopt the mode used in VFIO and
InfiniBand.  Both solutions can set any user pointer for hardware sharing.
But they cannot support fork when the dma is in process. Or the
"Copy-On-Write" procedure will make the parent process lost its physical
pages.


Difference to the VFIO and IB framework
---------------------------------------
The essential function of Uacce is to let the device access the user
address directly. There are many device drivers doing the same in the kernel.
And both VFIO and IB can provide similar functions in framework level.

But Uacce has a different goal: "share address space". It is
not taken the request to the accelerator as an enclosure data structure. It
takes the accelerator as another thread of the same process. So the
accelerator can refer to any address used by the process.

Both VFIO and IB are taken this as "memory sharing", not "address sharing".
They care more on sharing the block of memory. But if there is an address
stored in the block and referring to another memory region. The address may
not be valid.

By adding more constraints to the VFIO and IB framework, in some sense, we may
achieve a similar goal. But we gave it up finally. Both VFIO and IB have extra
assumption which is unnecessary to Uacce. They may hurt each other if we
try to merge them together.

VFIO manages resource of a hardware as a "virtual device". If a device need to
serve a separated application. It must isolate the resource as a separate
virtual device.  And the life cycle of the application and virtual device are
unnecessary unrelated. And most concepts, such as bus, driver, probe and
so on, to make it as a "device" is unnecessary either. And the logic added to
VFIO to make address sharing do no help on "creating a virtual device".

IB creates a "verbs" standard for sharing memory region to another remote
entity.  Most of these verbs are to make memory region between entities to be
synchronized.  This is not what accelerator need. Accelerator is in the same
memory system with the CPU. It refers to the same memory system among CPU and
devices. So the local memory terms/verbs are good enough for it. Extra "verbs"
are not necessary. And its queue (like queue pair in IB) is the communication
channel direct to the accelerator hardware. There is nothing about memory
itself.

Further, both VFIO and IB use the "pin" (get_user_page) way to lock local
memory in place.  This is flexible. But it can cause other problems. For
example, if the user process fork a child process. The COW procedure may make
the parent process lost its pages which are sharing with the device. These may
be fixed in the future. But is not going to be easy. (There is a discussion
about this on Linux Plumbers Conference 2018 [1])

So we choose to build the solution directly on top of IOMMU interface. IOMMU
is the essential way for device and process to share their page mapping from
the hardware perspective. It will be safe to create a software solution on
this assumption.  Uacce manages the IOMMU interface for the accelerator
device, so the device driver can export some of the resources to the user
space. Uacce than can make sure the device and the process have the same
address space.


References
==========
.. [1] https://lwn.net/Articles/774411/

Kenneth Lee (2):
  uacce: Add documents for uacce
  uacce: add uacce driver

Zhangfei Gao (2):
  crypto: hisilicon - Remove module_param uacce_mode
  crypto: hisilicon - register zip engine to uacce

 Documentation/ABI/testing/sysfs-driver-uacce |  39 ++
 Documentation/misc-devices/uacce.rst         | 176 ++++++++
 drivers/crypto/hisilicon/qm.c                | 239 ++++++++++-
 drivers/crypto/hisilicon/qm.h                |  11 +
 drivers/crypto/hisilicon/zip/zip_main.c      |  47 +-
 drivers/misc/Kconfig                         |   1 +
 drivers/misc/Makefile                        |   1 +
 drivers/misc/uacce/Kconfig                   |  13 +
 drivers/misc/uacce/Makefile                  |   2 +
 drivers/misc/uacce/uacce.c                   | 617 +++++++++++++++++++++++++++
 include/linux/uacce.h                        | 161 +++++++
 include/uapi/misc/uacce/hisi_qm.h            |  23 +
 include/uapi/misc/uacce/uacce.h              |  38 ++
 13 files changed, 1335 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
 create mode 100644 Documentation/misc-devices/uacce.rst
 create mode 100644 drivers/misc/uacce/Kconfig
 create mode 100644 drivers/misc/uacce/Makefile
 create mode 100644 drivers/misc/uacce/uacce.c
 create mode 100644 include/linux/uacce.h
 create mode 100644 include/uapi/misc/uacce/hisi_qm.h
 create mode 100644 include/uapi/misc/uacce/uacce.h

-- 
2.7.4

