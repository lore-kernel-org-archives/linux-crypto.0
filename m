Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6F0C4332D
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 12:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9115C2072C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 12:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="jigqQtCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgCTMY6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 08:24:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33659 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgCTMY6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 08:24:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so2436323pgo.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2020 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=7j/gZWCgTveqAxJksxzETYlHVAwTk7I1BKebV7lwMSI=;
        b=jigqQtCURtINYdEgrdVGDagbUr2GGY2M/usZCtgaCG+zM/OYR31CKlpjIQVuiSTNE1
         LlbX4vMGCjyJMoWfRFYy54AffjMd48Smq1zGjj2jk3ZVpm5YQNf03nN97S2BtToMo++d
         mX2hH7acmqfBm2J5VLd05U86jpoKV7HSrPDTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7j/gZWCgTveqAxJksxzETYlHVAwTk7I1BKebV7lwMSI=;
        b=IBCKoOJO52V7kTePyv6rPtUDfbBBi9/si8M4sbIa2UDtKvD2XWgKgTpVbO1IuaB0H0
         z4MfjGTMngQsiY+RFHlmM+cKl6mnWoCUxF+TwC7Wxk1jdEmAlfPiIy81e2KZd1qMCtlx
         JmZ7IA3gy90KgOTV2dCeTD/VHjZAJSV1BnawNc9WA+/Ros0jUsFWfmF44hdQDc9oGRWx
         oZ+oDZ/91WL7ZISHraImoUL5ldkptjf7tPCgOe5cR56hXeJafMxTOsqkFmZBX2DKUA2f
         fqLHBbolfLsDwJbDM6AtiKkv+b+Ox/nYiaQRpYz8306k6cLm4op9An08yulio7E57x3Y
         cpkQ==
X-Gm-Message-State: ANhLgQ2zbQIh3pGp1vXoFDAh2cHCDj5c5MvNvuWeqZcydqC71YTh5fB4
        5M6JMC/4TDNeDfHG9o6cPQ1loQ0nb7w=
X-Google-Smtp-Source: ADFU+vs3qE1kqu10ggDM9jEgALLlR+aaHI0fgOVM6cUzo/zZbCL0txsH777WrJ4nTUR/yH2t8ovp1w==
X-Received: by 2002:a63:fd0d:: with SMTP id d13mr7339958pgh.302.1584707095927;
        Fri, 20 Mar 2020 05:24:55 -0700 (PDT)
Received: from localhost (2001-44b8-111e-5c00-5c35-14f7-8aa3-37c9.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:5c35:14f7:8aa3:37c9])
        by smtp.gmail.com with ESMTPSA id w138sm5737630pff.145.2020.03.20.05.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 05:24:55 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au
Cc:     mikey@neuling.org, npiggin@gmail.com, linux-crypto@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 9/9] Documentation/powerpc: VAS API
In-Reply-To: <1583541541.9256.50.camel@hbabu-laptop>
References: <1583540877.9256.24.camel@hbabu-laptop> <1583541541.9256.50.camel@hbabu-laptop>
Date:   Fri, 20 Mar 2020 23:24:51 +1100
Message-ID: <87blorw6wc.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Haren,

This is good documentation.

> Power9 introduced Virtual Accelerator Switchboard (VAS) which allows
> userspace to communicate with Nest Accelerator (NX) directly. But
> kernel has to establish channel to NX for userspace. This document
> describes user space API that application can use to establish
> communication channel.
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  Documentation/powerpc/index.rst   |   1 +
>  Documentation/powerpc/vas-api.rst | 246 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 247 insertions(+)
>  create mode 100644 Documentation/powerpc/vas-api.rst
>
> diff --git a/Documentation/powerpc/index.rst b/Documentation/powerpc/index.rst
> index 0d45f0f..afe2d5e 100644
> --- a/Documentation/powerpc/index.rst
> +++ b/Documentation/powerpc/index.rst
> @@ -30,6 +30,7 @@ powerpc
>      syscall64-abi
>      transactional_memory
>      ultravisor
> +    vas-api
>  
>  .. only::  subproject and html
>  
> diff --git a/Documentation/powerpc/vas-api.rst b/Documentation/powerpc/vas-api.rst
> new file mode 100644
> index 0000000..13ce4e7
> --- /dev/null
> +++ b/Documentation/powerpc/vas-api.rst
> @@ -0,0 +1,246 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +.. _VAS-API:
> +
> +===================================================
> +Virtual Accelerator Switchboard (VAS) userspace API
> +===================================================
> +
> +Introduction
> +============
> +
> +Power9 processor introduced Virtual Accelerator Switchboard (VAS) which
> +allows both userspace and kernel communicate to co-processor
> +(hardware accelerator) referred to as the Nest Accelerator (NX). The NX
> +unit comprises of one or more hardware engines or co-processor types
> +such as 842 compression, GZIP compression and encryption. On power9,
> +userspace applications will have access to only GZIP Compression engine
> +which supports ZLIB and GZIP compression algorithms in the hardware.
> +
> +To communicate with NX, kernel has to establish a channel or window and
> +then requests can be submitted directly without kernel involvement.
> +Requests to the GZIP engine must be formatted as a co-processor Request
> +Block (CRB) and these CRBs must be submitted to the NX using COPY/PASTE
> +instructions to paste the CRB to hardware address that is associated with
> +the engine's request queue.
> +
> +The GZIP engine provides two priority levels of requests: Normal and
> +High. Only Normal requests are supported from userspace right now.
> +
> +This document explains userspace API that is used to interact with
> +kernel to setup channel / window which can be used to send compression
> +requests directly to NX accelerator.
> +
> +
> +Overview
> +========
> +
> +Application access to the GZIP engine is provided through
> +/dev/crypto/nx-gzip device node implemented by the VAS/NX device driver.
> +An application must open the /dev/crypto/nx-gzip device to obtain a file
> +descriptor (fd). Then should issue VAS_TX_WIN_OPEN ioctl with this fd to
> +establish connection to the engine. It means send window is opened on GZIP
> +engine for this process. Once a connection is established, the application
> +should use the mmap() system call to map the hardware address of engine's
> +request queue into the application's virtual address space.
> +
> +The application can then submit one or more requests to the the engine by
> +using copy/paste instructions and pasting the CRBs to the virtual address
> +(aka paste_address) returned by mmap(). User space can close the
> +established connection or send window by closing the file descriptior
> +(close(fd)) or upon the process exit.
> +
> +Note that applications can send several requests with the same window or
> +can establish multiple windows, but one window for each file descriptor.
> +
> +Following sections provide additional details and references about the
> +individual steps.
> +
> +NX-GZIP Device Node
> +===================
> +
> +There is one /dev/crypto/nx-gzip node in the system and it provides
> +access to all GZIP engines in the system. The only valid operations on
> +/dev/crypto/nx-gzip are:
> +
> +	* open() the device for read and write.
> +	* issue VAS_TX_WIN_OPEN ioctl
> +	* mmap() the engine's request queue into application's virtual
> +	  address space (i.e. get a paste_address for the co-processor
> +	  engine).
> +	* close the device node.
> +
> +Other file operations on this device node are undefined.
> +
> +Note that the copy and paste operations go directly to the hardware and
> +do not go through this device. Refer COPY/PASTE document for more
> +details.
> +
> +Although a system may have several instances of the NX co-processor
> +engines (typically, one per P9 chip) there is just one
> +/dev/crypto/nx-gzip device node in the system. When the nx-gzip device
> +node is opened, Kernel opens send window on a suitable instance of NX
> +accelerator. It finds CPU on which the user process is executing and
> +determine the NX instance for the corresponding chip on which this CPU
> +belongs.
> +
> +Applications may chose a specific instance of the NX co-processor using
> +the vas_id field in the VAS_TX_WIN_OPEN ioctl as detailed below.
> +
> +A userspace library libnxz is available here but still in development:
> +	 https://github.com/abalib/power-gzip
> +
> +Applications that use inflate / deflate calls can link with libnxz
> +instead of libz and use NX GZIP compression without any modification.
> +
> +Open /dev/crypto/nx-gzip
> +========================
> +
> +The nx-gzip device should be opened for read and write. No special
> +privileges are needed to open the device. Each window coreesponds to one

s/coreesponds/corresponds/

> +file descriptor. So if the userspace process needs multiple windows,
> +several open calls have to be issued.
> +
> +See open(2) system call man pages for other details such as return values,
> +error codes and restrictions.
> +codes and restrictions.

You have 'codes and restrictions' twice here.

> +
> +VAS_TX_WIN_OPEN ioctl
> +=====================
> +
> +Applications should use the VAS_TX_WIN_OPEN ioctl as follows to establish
> +a connection with NX co-processor engine:
> +
> +	::
> +		struct vas_tx_win_open_attr {
> +			__u32   version;
> +			__s16   vas_id; /* specific instance of vas or -1
> +						for default */
> +			__u16   reserved1;
> +			__u64   flags;	/* For future use */
> +			__u64   reserved2[6];
> +		};
> +
> +	version: The version field must be currently set to 1.
> +	vas_id: If '-1' is passed, kernel will make a best-effort attempt
> +		to assign an optimal instance of NX for the process. To
> +		select the specific VAS instance, refer
> +		"Discovery of available VAS engines" section below.
> +
> +	flags, reserved1 and reserved2[6] fields are for future extension
> +	and must be set to 0.
> +
> +	The attributes attr for the VAS_TX_WIN_OPEN ioctl are defined as
> +	follows:
> +		#define VAS_MAGIC 'v'
> +		#define VAS_TX_WIN_OPEN _IOW(VAS_MAGIC, 1,
> +						struct vas_tx_win_open_attr)
> +
> +		struct vas_tx_win_open_attr attr;
> +		rc = ioctl(fd, VAS_TX_WIN_OPEN, &attr);
> +
> +	The VAS_TX_WIN_OPEN ioctl returns 0 on success. On errors, it
> +	returns -1 and sets the errno variable to indicate the error.
> +
> +	Error conditions:
> +		EINVAL	fd does not refer to a valid VAS device.
> +		EINVAL	Invalid vas ID
> +		EINVAL	version is not set with proper value
> +		EEXIST	Window is already opened for the given fd
> +		ENOMEM	Memory is not available to allocate window
> +		ENOSPC	System has too many active windows (connections)
> +			opened
> +		EINVAL	reserved fields are not set to 0.
> +
> +	See the ioctl(2) man page for more details, error codes and
> +	restrictions.
> +
> +mmap() NX-GZIP device
> +=====================
> +
> +The mmap() system call for a NX-GZIP device fd returns a paste_address
> +that the application can use to copy/paste its CRB to the hardware engines.
> +	::
> +
> +		paste_addr = mmap(addr, size, prot, flags, fd, offset);
> +
> +	Only restrictions on mmap for a NX-GZIP device fd are:
> +		* size should be 4K page size

Patch 3 seems to allow a 64k page if the system is compiled for 64k
pages... Should it restrict it to 4K?

> +		* offset parameter should be 0ULL
> +
> +	Refer to mmap(2) man page for additional details/restrictions.
> +	In addition to the error conditions listed on the mmap(2) man
> +	page, can also fail with one of the following error codes:
> +
> +		EINVAL	fd is not associated with an open window
> +			(i.e mmap() does not follow a successful call
> +			to the VAS_TX_WIN_OPEN ioctl).
> +		EINVAL	offset field is not 0ULL.
> +
> +Discovery of available VAS engines
> +==================================
> +
> +Each available VAS instance in the system will have a device tree node
> +like /proc/device-tree/vas@* or /proc/device-tree/xscom@*/vas@*.
> +Determine the chip or VAS instance and use the corresponding ibm,vas-id
> +property value in this node to select specific VAS instance.
> +
> +Copy/Paste operations
> +=====================
> +
> +Applications should use the copy and paste instructions defined in the RFC
> +to copy/paste the CRB.

In which RFC?

> +
> +CRB Specification and use NX
> +============================
> +
> +Applications should format requests to the co-processor using the
> +co-processor Request Block (CRBs). Refer NX workbook for the format of
> +CRB and use NX from userspace such as sending requests and checking
> +request status.

Where would someone find the NX workbook?

Regards,
Daniel

> +
> +Simple example
> +==============
> +
> +	::
> +		int use_nx_gzip()
> +		{
> +			int rc, fd;
> +			void *addr;
> +			struct vas_setup_attr txattr;
> +
> +			fd = open("/dev/crypto/nx-gzip", O_RDWR);
> +			if (fd < 0) {
> +				fprintf(stderr, "open nx-gzip failed\n");
> +				return -1;
> +			}
> +			memset(&txattr, 0, sizeof(txattr));
> +			txattr.version = 1;
> +			txattr.vas_id = -1
> +			rc = ioctl(fd, VAS_TX_WIN_OPEN,
> +					(unsigned long)&txattr);
> +			if (rc < 0) {
> +				fprintf(stderr, "ioctl() n %d, error %d\n",
> +						rc, errno);
> +				return rc;
> +			}
> +			addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE,
> +					MAP_SHARED, fd, 0ULL);
> +			if (addr == MAP_FAILED) {
> +				fprintf(stderr, "mmap() failed, errno %d\n",
> +						errno);
> +				return -errno;
> +			}
> +			do {
> +				//Format CRB request with compression or
> +				//uncompression
> +				// Refer tests for vas_copy/vas_paste
> +				vas_copy((&crb, 0, 1);
> +				vas_paste(addr, 0, 1);
> +				// Poll on csb.flags with timeout
> +				// csb address is listed in CRB
> +			} while (true)
> +			close(fd) or window can be closed upon process exit
> +		}
> +
> +	Refer https://github.com/abalib/power-gzip for tests or more
> +	use cases.
> -- 
> 1.8.3.1
