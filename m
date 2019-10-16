Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E94FECE588
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 08:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDCB421848
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 08:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KoFI9lql"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfJPIex (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:34:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38935 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbfJPIew (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 04:34:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id p12so4520042pgn.6
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 01:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yPciJhjBGijA5Tk8kPbmBpHq770aimEFdMTnh8bKlZU=;
        b=KoFI9lqlUvhU9OQRdZAKtFP9dcAQvGmc7M3nTu6kBY33kj24/RvQBWfK5E/CQsvo5e
         ZCjKxFA1mqwg1vskJPK9Rlgb/OTgVcsk9ZDDgOEiz/Q5BAR6I8orL4yUgKJPaCylJ/aL
         xy7R+jjL74WP16nrCB+x4iQ01spNwBiDCh8ytqomJnqnqZ8SIMHawpi3H1rBzPfIU7RN
         3RGyHnCNym4fErAJccqxP5BtLygIb8L0zFunOPKfLMUm6i7py5srYeuIspT1KIZZXvBH
         XjXzE/PE5SCr2er6dvUKV8C0Gcv6SbdL1MqhUGoO+Wk+IpF3t9YK2LzqFqWxObwTVso3
         TWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yPciJhjBGijA5Tk8kPbmBpHq770aimEFdMTnh8bKlZU=;
        b=RjW1mx3/jsBLNhXv8+JTXl2cpqCBMEWeOFfWyJuQx4V4DPbjh1kfkARgSaEY2Rwmdj
         rfU6FEaM0j2AQEa+Btcb5vbZrT1Loj8J0/VrINEdjZakpa070oRmb03AqmdkLJGyDPSZ
         5JnDXs4KlsH06tPmfcEj21NQ/Ap8V/MrThjjKs67YpBEWHFWo6L6xidZ9ej5aCMURohi
         r01j0Xincwc/Paw8m14zPI/FtGqHNpJwrG0PmRJP5knE6zmBG7LTKF2Qw3glI3wR+d3H
         usloGmEkZ2MpB293rrpATfrLZ4meUtG9UXsTvry9PQ9QT8J6eTBiaG/Ag592hNPYZqO7
         2ZMw==
X-Gm-Message-State: APjAAAUF7K19w7sRZbII4YowekiuoTklPNg6bt/Nfa2yCc7xeWILHxva
        F3Ggd/9NhOntSzfkCEAQap4BXA==
X-Google-Smtp-Source: APXvYqzT3971FRskPissUbWC+ew2Ux89qM+6v3JeeTg/8sIzwvn4epIQeCYORhkoDCLwiMrrRQrQ5Q==
X-Received: by 2002:a65:434c:: with SMTP id k12mr44313645pgq.141.1571214891878;
        Wed, 16 Oct 2019 01:34:51 -0700 (PDT)
Received: from localhost.localdomain ([85.203.47.199])
        by smtp.gmail.com with ESMTPSA id d19sm1745960pjz.5.2019.10.16.01.34.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 01:34:50 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 0/3] Add uacce module for Accelerator
Date:   Wed, 16 Oct 2019 16:34:30 +0800
Message-Id: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
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
We have keep verifying with Jean's sva/current [2]
We also keep verifying with Eric's SMMUv3 Nested Stage patch [3]

This series and related zip & qm driver
https://github.com/Linaro/linux-kernel-warpdrive/tree/5.4-rc1-uacce-v6

The library and user application:
https://github.com/Linaro/warpdrive/tree/wdprd-v1-upstream

References:
[1] http://jpbrucker.net/sva/
[2] http://www.linux-arm.org/git?p=linux-jpb.git;a=shortlog;h=refs/heads/sva/current
[3] https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9

Change History:
v6:
Change sys qfrs_size to different file, suggested by Jonathan
Fix crypto daily build issue and based on crypto code base, also 5.4-rc1.

v5: 
Add an example patch using the uacce interface, suggested by Greg
0003-crypto-hisilicon-register-zip-engine-to-uacce.patch

v4:
Based on 5.4-rc1
Considering other driver integrating uacce, 
if uacce not compiled, uacce_register return error and uacce_unregister is empty.
Simplify uacce flag: UACCE_DEV_SVA.
Address Greg's comments: 
Fix state machine, remove potential syslog triggered from user space etc.

v3:
Recommended by Greg, use sturct uacce_device instead of struct uacce,
and use struct *cdev in struct uacce_device, as a result, 
cdev can be released by itself when refcount decreased to 0.
So the two structures are decoupled and self-maintained by themsleves.
Also add dev.release for put_device.

v2:
Address comments from Greg and Jonathan
Modify interface uacce_register
Drop noiommu mode first

v1:
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

Kenneth Lee (2):
  uacce: Add documents for uacce
  uacce: add uacce driver

Zhangfei Gao (1):
  crypto: hisilicon - register zip engine to uacce

 Documentation/ABI/testing/sysfs-driver-uacce |  65 ++
 Documentation/misc-devices/uacce.rst         | 297 ++++++++
 drivers/crypto/hisilicon/qm.c                | 254 ++++++-
 drivers/crypto/hisilicon/qm.h                |  13 +-
 drivers/crypto/hisilicon/zip/zip_main.c      |  39 +-
 drivers/misc/Kconfig                         |   1 +
 drivers/misc/Makefile                        |   1 +
 drivers/misc/uacce/Kconfig                   |  13 +
 drivers/misc/uacce/Makefile                  |   2 +
 drivers/misc/uacce/uacce.c                   | 995 +++++++++++++++++++++++++++
 include/linux/uacce.h                        | 168 +++++
 include/uapi/misc/uacce/qm.h                 |  22 +
 include/uapi/misc/uacce/uacce.h              |  41 ++
 13 files changed, 1875 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
 create mode 100644 Documentation/misc-devices/uacce.rst
 create mode 100644 drivers/misc/uacce/Kconfig
 create mode 100644 drivers/misc/uacce/Makefile
 create mode 100644 drivers/misc/uacce/uacce.c
 create mode 100644 include/linux/uacce.h
 create mode 100644 include/uapi/misc/uacce/qm.h
 create mode 100644 include/uapi/misc/uacce/uacce.h

-- 
2.7.4

