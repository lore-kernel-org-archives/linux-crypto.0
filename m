Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96706C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 13:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D1C02076A
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 13:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="Kfy/sLZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgCPNEK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:04:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37107 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbgCPNEK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 09:04:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id f16so7987668plj.4
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2020 06:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gm3nq+v+QGkPerUNlfinQphw8ITuvw6SnqWBKvCOlbs=;
        b=Kfy/sLZ2EJ8aIHhCS04gM9F/jxgjFnksWPjtofT3qFbPgmsCJvVSILgnVnJ9JopX7r
         /6iQbFuvpTGcks/S4vd7OboaCmKYRrF9fU54K8Ai/l5br9Ets4/O6n4IObJOV/PL6IDm
         Z4uMmAhFuXiX+LLk4v/IQ+2isK6vhxak/HuMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gm3nq+v+QGkPerUNlfinQphw8ITuvw6SnqWBKvCOlbs=;
        b=nPfOABttN9RkP46Op32SuG6NCOXt0QWPEqdo9uEmLXaTzkEAvZD+FXnyBgsI3OeYdw
         K46869zSMA9J2b7GQgvyqWo7jeTD55QqzWX9mIMF9G6CmhtsTUuSvirie2JhFLnheJti
         qsPJrSrO9p+2jfUhT55YCruxPuJBNGL6JX7mUqXaIBUavJwlPT9McDbjES3dHiNzmsm9
         AxUzMdb+LFt7TqpcQYOcBLgbnXuPrFN9UI3m8YXCBwFjcBHOtsQ5ncx0iAR/5W70VYKT
         wPGD71t9LFAi5aU9iqKbM2muz9dVKzAsE6JhUe9SCPHe5q3TSZwvEClxM1audGNPovzU
         /FjQ==
X-Gm-Message-State: ANhLgQ2ueM3h/FgqmwVb5ygPexD9Vj0Nq1H5hB2FbWXeWbrxl0wwusDm
        Al70nSbsOxh5eWw0erw6dABoP1ROXIE=
X-Google-Smtp-Source: ADFU+vskn1/3oxwY8FsGP4p1/BKcID7x94CYnVnY3jeAL5V0sf+PfLygADfeW6PK2s6r/iybZGCsmA==
X-Received: by 2002:a17:90a:bf0b:: with SMTP id c11mr26426966pjs.28.1584363846927;
        Mon, 16 Mar 2020 06:04:06 -0700 (PDT)
Received: from localhost (2001-44b8-1113-6700-789d-cd2c-42e1-23af.static.ipv6.internode.on.net. [2001:44b8:1113:6700:789d:cd2c:42e1:23af])
        by smtp.gmail.com with ESMTPSA id h22sm65481456pgn.57.2020.03.16.06.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 06:04:05 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        mpe@ellerman.id.au
Cc:     mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        npiggin@gmail.com
Subject: Re: [PATCH v3 0/9] crypto/nx: Enable GZIP engine and provide userpace API
In-Reply-To: <1583540877.9256.24.camel@hbabu-laptop>
References: <1583540877.9256.24.camel@hbabu-laptop>
Date:   Tue, 17 Mar 2020 00:04:02 +1100
Message-ID: <87y2s0o3i5.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Haren,

If I understand correctly, to test these, I need to apply both this
series and your VAS userspace page fault handling series - is that
right?

Kind regards,
Daniel

> Power9 processor supports Virtual Accelerator Switchboard (VAS) which
> allows kernel and userspace to send compression requests to Nest
> Accelerator (NX) directly. The NX unit comprises of 2 842 compression
> engines and 1 GZIP engine. Linux kernel already has 842 compression
> support on kernel. This patch series adds GZIP compression support
> from user space. The GZIP Compression engine implements the ZLIB and
> GZIP compression algorithms. No plans of adding NX-GZIP compression
> support in kernel right now.
>
> Applications can send requests to NX directly with COPY/PASTE
> instructions. But kernel has to establish channel / window on NX-GZIP
> device for the userspace. So userspace access to the GZIP engine is
> provided through /dev/crypto/nx-gzip device with several operations.
>
> An application must open the this device to obtain a file descriptor (fd).
> Using the fd, application should issue the VAS_TX_WIN_OPEN ioctl to
> establish a connection to the engine. Once window is opened, should use
> mmap() system call to map the hardware address of engine's request queue
> into the application's virtual address space. Then user space forms the
> request as co-processor Request Block (CRB) and paste this CRB on the
> mapped HW address using COPY/PASTE instructions. Application can poll
> on status flags (part of CRB) with timeout for request completion.
>
> For VAS_TX_WIN_OPEN ioctl, if user space passes vas_id = -1 (struct
> vas_tx_win_open_attr), kernel determines the VAS instance on the
> corresponding chip based on the CPU on which the process is executing.
> Otherwise, the specified VAS instance is used if application passes the
> proper VAS instance (vas_id listed in /proc/device-tree/vas@*/ibm,vas_id).
>
> Process can open multiple windows with different FDs or can send several
> requests to NX on the same window at the same time.
>
> A userspace library libnxz is available:
>         https://github.com/abalib/power-gzip
>
> Applications that use inflate/deflate calls can link with libNXz and use
> NX GZIP compression without any modification.
>
> Tested the available 842 compression on power8 and power9 system to make
> sure no regression and tested GZIP compression on power9 with tests
> available in the above link.
>
> Thanks to Bulent Abali for nxz library and tests development.
>
> Changelog:
> V2:
>   - Move user space API code to powerpc as suggested. Also this API
>     can be extended to any other coprocessor type that VAS can support
>     in future. Example: Fast thread wakeup feature from VAS
>   - Rebased to 5.6-rc3
>
> V3:
>   - Fix sparse warnings (patches 3&6)
>
> Haren Myneni (9):
>   powerpc/vas: Initialize window attributes for GZIP coprocessor type
>   powerpc/vas: Define VAS_TX_WIN_OPEN ioctl API
>   powerpc/vas: Add VAS user space API
>   crypto/nx: Initialize coproc entry with kzalloc
>   crypto/nx: Rename nx-842-powernv file name to nx-common-powernv
>   crypto/NX: Make enable code generic to add new GZIP compression type
>   crypto/nx: Enable and setup GZIP compresstion type
>   crypto/nx: Remove 'pid' in vas_tx_win_attr struct
>   Documentation/powerpc: VAS API
>
>  Documentation/powerpc/index.rst                    |    1 +
>  Documentation/powerpc/vas-api.rst                  |  246 +++++
>  Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>  arch/powerpc/include/asm/vas.h                     |   12 +-
>  arch/powerpc/include/uapi/asm/vas-api.h            |   22 +
>  arch/powerpc/platforms/powernv/Makefile            |    2 +-
>  arch/powerpc/platforms/powernv/vas-api.c           |  290 +++++
>  arch/powerpc/platforms/powernv/vas-window.c        |   23 +-
>  arch/powerpc/platforms/powernv/vas.h               |    2 +
>  drivers/crypto/nx/Makefile                         |    2 +-
>  drivers/crypto/nx/nx-842-powernv.c                 | 1062 ------------------
>  drivers/crypto/nx/nx-common-powernv.c              | 1133 ++++++++++++++++++++
>  12 files changed, 1723 insertions(+), 1073 deletions(-)
>  create mode 100644 Documentation/powerpc/vas-api.rst
>  create mode 100644 arch/powerpc/include/uapi/asm/vas-api.h
>  create mode 100644 arch/powerpc/platforms/powernv/vas-api.c
>  delete mode 100644 drivers/crypto/nx/nx-842-powernv.c
>  create mode 100644 drivers/crypto/nx/nx-common-powernv.c
>
> -- 
> 1.8.3.1
