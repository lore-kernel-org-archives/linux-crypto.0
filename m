Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2332FFA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 18:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5842067D
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 18:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nDM0ii6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733033AbfJPSgp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:36:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39151 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfJPSgo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 14:36:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so29248232wrj.6
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 11:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N2GwwyEWtwePqahliLM+b4a2OzggNm6U6Np9WnsRLwA=;
        b=nDM0ii6PkLAY7VF28heb/3qosAGN9iXAM/pZo5b3opKcF8/D1lHUJTRJtdKTt0mek6
         xWuKLmS5mQRl3WWAZTIvmZbClB+CwUUQNr8HmgJGFsjC2mGqLb1dkgn64+CnBwMDtXxb
         aK/fItcwg53TyVs/YMf7v6BveL884YBAidpzCKb+f2ehheFLIM8rhPs0p2U8ZBzhhEzC
         QwdBXkLDf36EyRamcERA1kqCFU15RO6u1pqVbjCNfQMH+VJlWQsLqxXTcxvFtneRFGI7
         RINq0an6FMV6e5tzoQCUfWALj7G9npSAm073gw+pS1BXy/427C1lVOgidZEFroxaXZbT
         eHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N2GwwyEWtwePqahliLM+b4a2OzggNm6U6Np9WnsRLwA=;
        b=HzL9m6JhNGjf3M/h0zi6EHjNxUb9Qzgz3bF/GXVIgSF99/1cy55WUyPChzxqWVRqo9
         j0JWrZLDk4qkZkPHU/TzSn3gXdnAw033M1BVy1X7XVX6WpkbnPnf3ukGhVUHHFbX4WFe
         XF9FIvl3UnLbR4GBCUHALN5NEcGhmkeLZhTzisYJ8g6O+q83YWIQx2Nz/gjXqeyAK/+d
         6HDyAuphgDskJYZUKGi+QFvStbI4blaUEVkhAUNVU+urMPgfumhuNQ2VcDef7irwRM7Q
         gRelj2yrFQvUO2ioxS9AU7Bs89fgPwOfhFIzzlpjsVpTj/FbT4rkiDV2ERIVq+WNGzkM
         +2UA==
X-Gm-Message-State: APjAAAW57v56GdZ+4eFMDuSYMUwEX4UcAK9HbIXvTIG/4qGmKslw6BZG
        W9s7XrZAVo3trHQY/2jD/Aln5Q==
X-Google-Smtp-Source: APXvYqwI7LUT/xSQEMOFfiDXjOvY8G9ccptVbDicGp9A/kBnUFDehzDfTMzNDNBNar1NO1dR7aH+2g==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr4209084wrq.9.1571251001521;
        Wed, 16 Oct 2019 11:36:41 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id 207sm4133088wme.17.2019.10.16.11.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 11:36:40 -0700 (PDT)
Date:   Wed, 16 Oct 2019 20:36:38 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v6 1/3] uacce: Add documents for uacce
Message-ID: <20191016183638.GB1533448@lophozonia>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-2-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571214873-27359-2-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I already commented on the interface in patch 2/3, so I just have a few
additional comments on the documentation itself.

On Wed, Oct 16, 2019 at 04:34:31PM +0800, Zhangfei Gao wrote:
> +The user API
> +------------
> +
> +We adopt a polling style interface in the user space: ::
> +
> +	int wd_request_queue(struct wd_queue *q);
> +	void wd_release_queue(struct wd_queue *q);
> +	int wd_send(struct wd_queue *q, void *req);
> +	int wd_recv(struct wd_queue *q, void **req);
> +	int wd_recv_sync(struct wd_queue *q, void **req);
> +	void wd_flush(struct wd_queue *q);
> +
> +wd_recv_sync() is a wrapper to its non-sync version. It will trap into
> +kernel and wait until the queue become available.
> +
> +If the queue do not support SVA/SVM. The following helper functions
> +can be used to create Static Virtual Share Memory: ::
> +
> +	void *wd_reserve_memory(struct wd_queue *q, size_t size);
> +	int wd_share_reserved_memory(struct wd_queue *q,
> +				     struct wd_queue *target_q);
> +
> +The user API is not mandatory. It is simply a suggestion and hint what the
> +kernel interface is supposed to be.

Maybe move this to the beginning of the section, to make it clear that
you're describing an example API. On first read I found it odd that we're
documenting a userspace library in this document.

[...]
> +
> +The Memory Sharing Model
> +------------------------
> +The perfect form of a Uacce device is to support SVM/SVA. We built this upon
> +Jean Philippe Brucker's SVA patches. [1]

I don't think this belongs in the doc, more on a cover letter. Since the
SVA API is now upstream (implementation in progress), you could simply say
something like "the uacce device is built around the IOMMU SVA API". 

> +
> +If the hardware support UACCE_DEV_SVA, the user process's page table is
> +shared to the opened queue. So the device can access any address in the
> +process address space.
> +And it can raise a page fault if the physical page is not available yet.
> +It can also access the address in the kernel space, which is referred by
> +another page table particular to the kernel. Most of IOMMU implementation can
> +handle this by a tag on the address request of the device. For example, ARM
> +SMMU uses SSV bit to indicate that the address request is for kernel or user
> +space.

That might be a bit too detailed, you can just say that the device can
access multiple address spaces, including the one without PASID. All IOMMU
architectures with PASID support this now.

> +Queue file regions can be used:
> +UACCE_QFRT_MMIO: device mmio region (map to user)
> +UACCE_QFRT_DUS: device user share (map to dev and user)
> +
> +If the device does not support UACCE_DEV_SVA, Uacce allow only one process at
> +the same time. DMA API cannot be used as well, since Uacce will create an
> +unmanaged iommu_domain for the device.
> +Queue file regions can be used:
> +UACCE_QFRT_MMIO: device mmio region (map to user)
> +UACCE_QFRT_DKO: device kernel-only (map to dev, no user)
> +UACCE_QFRT_DUS: device user share (map to dev and user)
> +UACCE_QFRT_SS:  static shared memory (map to devs and user)
> +
> +
> +The Fork Scenario
> +=================
> +For a process with allocated queues and shared memory, what happen if it forks
> +a child?
> +
> +The fd of the queue will be duplicated on folk, so the child can send request
> +to the same queue as its parent. But the requests which is sent from processes
> +except for the one who opens the queue will be blocked.

Would it be correct and clearer to say "The fd of the queue is duplicated
on fork, but requests sent from the child process are blocked"?

> +
> +It is recommended to add O_CLOEXEC to the queue file.
> +
> +The queue mmap space has a VM_DONTCOPY in its VMA. So the child will lose all
> +those VMAs.
> +
> +This is a reason why Uacce does not adopt the mode used in VFIO and
> +InfiniBand.  Both solutions can set any user pointer for hardware sharing.
> +But they cannot support fork when the dma is in process. Or the
> +"Copy-On-Write" procedure will make the parent process lost its physical
> +pages.
> +
> +
> +Difference to the VFIO and IB framework
> +---------------------------------------
> +The essential function of Uacce is to let the device access the user
> +address directly. There are many device drivers doing the same in the kernel.
> +And both VFIO and IB can provide similar functions in framework level.
> +
> +But Uacce has a different goal: "share address space". It is
> +not taken the request to the accelerator as an enclosure data structure. It
> +takes the accelerator as another thread of the same process. So the
> +accelerator can refer to any address used by the process.
> +
> +Both VFIO and IB are taken this as "memory sharing", not "address sharing".
> +They care more on sharing the block of memory. But if there is an address
> +stored in the block and referring to another memory region. The address may
> +not be valid.
> +
> +By adding more constraints to the VFIO and IB framework, in some sense, we may
> +achieve a similar goal. But we gave it up finally. Both VFIO and IB have extra
> +assumption which is unnecessary to Uacce. They may hurt each other if we
> +try to merge them together.

I don't know if this particular rationale belongs here rather than a cover
letter, but some of this section can be useful to let users decide if they
need uacce or VFIO.

For the record I'm still not entirely convinced that a new solution is
preferable to vfio-mdev.
* Existing userspace drivers such as DPDK may someday benefit from
  adding SVA support to VFIO.
* Patch 2/3 does seem to duplicate a lot of VFIO code for the !SVA mode.
  I'd rather we avoided !SVA support altogether at first, to make the code
  simpler.
* The issue with fork should be fixed in VFIO anyway, if it's an actual
  concern for userspace drivers.

On the other hand, I do agree with the following paragraph that a lighter
solution such as uacce focusing on shared address space and queues could
mean less work for device drivers and libraries.

It would be interesting to write a device driver prototype that implements
both vfio-mdev (with added SVA support) and uacce interfaces and compare
them. But since I'm not the one writing this or the corresponding
userspace libs, I'll stop advocating vfio-mdev next time and focus on the
implementation details :)

Thanks,
Jean

> +
> +VFIO manages resource of a hardware as a "virtual device". If a device need to
> +serve a separated application. It must isolate the resource as a separate
> +virtual device.  And the life cycle of the application and virtual device are
> +unnecessary unrelated. And most concepts, such as bus, driver, probe and
> +so on, to make it as a "device" is unnecessary either. And the logic added to
> +VFIO to make address sharing do no help on "creating a virtual device".
> +
> +IB creates a "verbs" standard for sharing memory region to another remote
> +entity.  Most of these verbs are to make memory region between entities to be
> +synchronized.  This is not what accelerator need. Accelerator is in the same
> +memory system with the CPU. It refers to the same memory system among CPU and
> +devices. So the local memory terms/verbs are good enough for it. Extra "verbs"
> +are not necessary. And its queue (like queue pair in IB) is the communication
> +channel direct to the accelerator hardware. There is nothing about memory
> +itself.
> +
> +Further, both VFIO and IB use the "pin" (get_user_page) way to lock local
> +memory in place.  This is flexible. But it can cause other problems. For
> +example, if the user process fork a child process. The COW procedure may make
> +the parent process lost its pages which are sharing with the device. These may
> +be fixed in the future. But is not going to be easy. (There is a discussion
> +about this on Linux Plumbers Conference 2018 [2])
> +
> +So we choose to build the solution directly on top of IOMMU interface. IOMMU
> +is the essential way for device and process to share their page mapping from
> +the hardware perspective. It will be safe to create a software solution on
> +this assumption.  Uacce manages the IOMMU interface for the accelerator
> +device, so the device driver can export some of the resources to the user
> +space. Uacce than can make sure the device and the process have the same
> +address space.
> +
> +
> +References
> +==========
> +.. [1] http://jpbrucker.net/sva/
> +.. [2] https://lwn.net/Articles/774411/
> -- 
> 2.7.4
> 
