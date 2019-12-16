Return-Path: <SRS0=5TcX=2G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3B4C43603
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 03:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF47A24679
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 03:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V8j2WG+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLPDIm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 22:08:42 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41665 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLPDIm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 22:08:42 -0500
Received: by mail-pl1-f195.google.com with SMTP id bd4so3810878plb.8
        for <linux-crypto@vger.kernel.org>; Sun, 15 Dec 2019 19:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Ek1qcsFUhuMBPbhgdrHw0tPJu23UDn9dVCl8iJXlhZI=;
        b=V8j2WG+Hw2/39WK4T7vivsA2ylObpV/431wS9D0v5LZQDzQA8MW93SN9/inDruJxFY
         pOId1DrISx7iXFPmITwUOI/K5FvVHBt8iIVqK9OaP7Y+Xz/04ri99wGvBGfZQinlG4lO
         Tp+EuagZRpqOzFM3ztvMs8gEWonNqD+jCiX+Qxi8fhrWGyaw59nQtiGF/aT9Eo0iYkvp
         hZJUaSn2EnNbnSRLDgsFAN7v9Ysgfh+O55wcaSoNWEKwyh87rxFx3TV3Co2nAWmPzSca
         +qsGE3MsaUUPFBjVrAOhGC2WFPqg3Kv4I/bZkuu3JNX29FMffdc7F/gOkz6ohxhzpByh
         1eNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ek1qcsFUhuMBPbhgdrHw0tPJu23UDn9dVCl8iJXlhZI=;
        b=MVrJR2biuFI0AoHQW7VaDMvIH89UMMii9jRH/pYDxujSDpzNt6vKHQOs6nibSSyjaI
         cW8vBu4hxcEph8hvvRfhmhwym8+gEJ2v7myHu9QJ3pCkJEUMA1NPffWy/H+3EoNA3G2I
         Yi+6caqd3rgD8GHyMcMlmba+cd1USbmHKNVCiLTdBwNN47BwxyUtzqJdzy9UiMQgpReK
         FNs0fNnZtlvv6IqT1vYoECYvcL6QGA6NMQmUVn6csNr05xWVNifhahstikX6nNp73Bxc
         KxOIfYZSfuP6NvZKMQsd5YjhvONto0AHbgVFLNmJmx8AiywEWt07BDfKjtPUy2AjZNGK
         P5iQ==
X-Gm-Message-State: APjAAAVufDkLQsPpRuYfPtHe/m6AFyf4/bmRSOJhMPPftXan26LTJkV5
        xb/4wZMWQgZvCbiNgIOlsrTokw==
X-Google-Smtp-Source: APXvYqymEWwjUeA6CA5IlZjbJrbJKB1P67eI7wet5hOwR4ywE3RjiWo0zzrgI7xpmvadUaY+g4SJ+A==
X-Received: by 2002:a17:902:104:: with SMTP id 4mr14246437plb.130.1576465721362;
        Sun, 15 Dec 2019 19:08:41 -0800 (PST)
Received: from localhost.localdomain ([240e:362:4f3:9700:194a:b273:fdd9:92e0])
        by smtp.gmail.com with ESMTPSA id k60sm18021687pjh.22.2019.12.15.19.08.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 15 Dec 2019 19:08:40 -0800 (PST)
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
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v10 0/4] Add uacce module for Accelerator
Date:   Mon, 16 Dec 2019 11:08:13 +0800
Message-Id: <1576465697-27946-1-git-send-email-zhangfei.gao@linaro.org>
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
https://github.com/Linaro/linux-kernel-warpdrive/tree/v5.5-rc1-uacce-v10

The library and user application:
https://github.com/Linaro/warpdrive/tree/wdprd-upstream-v10

References:
[1] http://jpbrucker.net/sva/
[2] http://jpbrucker.net/git/linux/log/?h=sva/zip-devel
[3] https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9

Change History:
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

 Documentation/ABI/testing/sysfs-driver-uacce |  37 ++
 Documentation/misc-devices/uacce.rst         | 176 ++++++++
 drivers/crypto/hisilicon/qm.c                | 236 +++++++++-
 drivers/crypto/hisilicon/qm.h                |  11 +
 drivers/crypto/hisilicon/zip/zip_main.c      |  47 +-
 drivers/misc/Kconfig                         |   1 +
 drivers/misc/Makefile                        |   1 +
 drivers/misc/uacce/Kconfig                   |  13 +
 drivers/misc/uacce/Makefile                  |   2 +
 drivers/misc/uacce/uacce.c                   | 628 +++++++++++++++++++++++++++
 include/linux/uacce.h                        | 161 +++++++
 include/uapi/misc/uacce/hisi_qm.h            |  23 +
 include/uapi/misc/uacce/uacce.h              |  38 ++
 13 files changed, 1341 insertions(+), 33 deletions(-)
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

