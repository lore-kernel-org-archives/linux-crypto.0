Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6F1C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 13:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D07BC20735
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 13:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="amZIJdm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgCWNca (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:32:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41490 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgCWNca (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 09:32:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so5914389plr.8
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2020 06:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=g5riz8OjOfvjpcTMb5LAWe/mn4WnsMYwvqIMoK6Thxs=;
        b=amZIJdm3oc70aUO+K4X1/MKKKXwX7maeZJZ7HAf2kMvfk2gzn7Ea8swOeepy4VZF4G
         Jz7AEjkPdJuFswXdOtZmsYIZAp821MwGhY3kJDPBmVERxsXnYaod6OSD4AZ+tWfJAsbu
         5nXnP1pri7XLOLKVZ4xakOYdGJ6Go4ajV5Jtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g5riz8OjOfvjpcTMb5LAWe/mn4WnsMYwvqIMoK6Thxs=;
        b=N1nv/nKnbYNAp7nUWcCB0ypahDVqNQShu6+gCkxUNO52q+Ha8VcE2/Dujoa5GpSTvc
         pz2fGUgNfP9ZnE9JSp+7Daooh3O+GoAsKzw9h5YZdC+O7LG33Q0Ct6Nq9fCX+ja9Bp9Q
         xw5KWjsq6Am9yS4/LSyM16kinarEQ6blJQRPRgt2vwTdtuyTtKUNKMlPc/gKGNLJK3t7
         y18OVMQH1iq9ROylDLYpaMbos/298kqP81kHg4MoVUoNOz/gmnd/Sd+B4mOxxJE/6/dw
         ScHO2MuoLnKJcI4jPT5luyBbYIU0jl6Xjly5jo8DoKS4ZRWiQEObG+HDdls5win3unje
         6ZKQ==
X-Gm-Message-State: ANhLgQ3rqtrbn+pQayLcRkGcPBTugWGSM6/NSNnKUJWX6Wn2ItKgdqH6
        i/8C3oC60Gcv2Hp+zjNerNHCQw==
X-Google-Smtp-Source: ADFU+vthijiC+5OEVWd8ZDNJ3tOvh4Sy2+PlMEZZ2OQ4Ldpfb8ODAgtpcD1VzHL7pYBf1Yk1kZBM7A==
X-Received: by 2002:a17:90a:d081:: with SMTP id k1mr26814556pju.57.1584970348373;
        Mon, 23 Mar 2020 06:32:28 -0700 (PDT)
Received: from localhost (2001-44b8-1113-6700-b01a-4ee1-5a87-afd3.static.ipv6.internode.on.net. [2001:44b8:1113:6700:b01a:4ee1:5a87:afd3])
        by smtp.gmail.com with ESMTPSA id 66sm13731522pfb.150.2020.03.23.06.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 06:32:27 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au
Cc:     mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        npiggin@gmail.com
Subject: Re: [PATCH v4 3/9] powerpc/vas: Add VAS user space API
In-Reply-To: <878sjrclmz.fsf@mpe.ellerman.id.au>
References: <1584934879.9256.15321.camel@hbabu-laptop> <1584936142.9256.15325.camel@hbabu-laptop> <878sjrwm72.fsf@dja-thinkpad.axtens.net> <878sjrclmz.fsf@mpe.ellerman.id.au>
Date:   Tue, 24 Mar 2020 00:32:24 +1100
Message-ID: <875zevw61j.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:

> Daniel Axtens <dja@axtens.net> writes:
>> Haren Myneni <haren@linux.ibm.com> writes:
>>
>>> On power9, userspace can send GZIP compression requests directly to NX
>>> once kernel establishes NX channel / window with VAS. This patch provides
>>> user space API which allows user space to establish channel using open
>>> VAS_TX_WIN_OPEN ioctl, mmap and close operations.
>>>
>>> Each window corresponds to file descriptor and application can open
>>> multiple windows. After the window is opened, VAS_TX_WIN_OPEN icoctl to
>>> open a window on specific VAS instance, mmap() system call to map
>>> the hardware address of engine's request queue into the application's
>>> virtual address space.
>>>
>>> Then the application can then submit one or more requests to the the
>>> engine by using the copy/paste instructions and pasting the CRBs to
>>> the virtual address (aka paste_address) returned by mmap().
>>>
>>> Only NX GZIP coprocessor type is supported right now and allow GZIP
>>> engine access via /dev/crypto/nx-gzip device node.
>>>
>>> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>>> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>>> ---
>>>  arch/powerpc/include/asm/vas.h              |  11 ++
>>>  arch/powerpc/platforms/powernv/Makefile     |   2 +-
>>>  arch/powerpc/platforms/powernv/vas-api.c    | 257 ++++++++++++++++++++++++++++
>>>  arch/powerpc/platforms/powernv/vas-window.c |   6 +-
>>>  arch/powerpc/platforms/powernv/vas.h        |   2 +
>>>  5 files changed, 274 insertions(+), 4 deletions(-)
>>>  create mode 100644 arch/powerpc/platforms/powernv/vas-api.c
>>>
>>> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
>>> index f93e6b0..e064953 100644
>>> --- a/arch/powerpc/include/asm/vas.h
>>> +++ b/arch/powerpc/include/asm/vas.h
>>> @@ -163,4 +163,15 @@ struct vas_window *vas_tx_win_open(int vasid, enum vas_cop_type cop,
>>>   */
>>>  int vas_paste_crb(struct vas_window *win, int offset, bool re);
>>>  
>>> +/*
>>> + * Register / unregister coprocessor type to VAS API which will be exported
>>> + * to user space. Applications can use this API to open / close window
>>> + * which can be used to send / receive requests directly to cooprcessor.
>>> + *
>>> + * Only NX GZIP coprocessor type is supported now, but this API can be
>>> + * used for others in future.
>>> + */
>>> +int vas_register_coproc_api(struct module *mod);
>>> +void vas_unregister_coproc_api(void);
>>> +
>>>  #endif /* __ASM_POWERPC_VAS_H */
>>> diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
>>> index 395789f..fe3f0fb 100644
>>> --- a/arch/powerpc/platforms/powernv/Makefile
>>> +++ b/arch/powerpc/platforms/powernv/Makefile
>>> @@ -17,7 +17,7 @@ obj-$(CONFIG_MEMORY_FAILURE)	+= opal-memory-errors.o
>>>  obj-$(CONFIG_OPAL_PRD)	+= opal-prd.o
>>>  obj-$(CONFIG_PERF_EVENTS) += opal-imc.o
>>>  obj-$(CONFIG_PPC_MEMTRACE)	+= memtrace.o
>>> -obj-$(CONFIG_PPC_VAS)	+= vas.o vas-window.o vas-debug.o vas-fault.o
>>> +obj-$(CONFIG_PPC_VAS)	+= vas.o vas-window.o vas-debug.o vas-fault.o vas-api.o
>>>  obj-$(CONFIG_OCXL_BASE)	+= ocxl.o
>>>  obj-$(CONFIG_SCOM_DEBUGFS) += opal-xscom.o
>>>  obj-$(CONFIG_PPC_SECURE_BOOT) += opal-secvar.o
>>> diff --git a/arch/powerpc/platforms/powernv/vas-api.c b/arch/powerpc/platforms/powernv/vas-api.c
>>> new file mode 100644
>>> index 0000000..7d049af
>>> --- /dev/null
>>> +++ b/arch/powerpc/platforms/powernv/vas-api.c
>>> @@ -0,0 +1,257 @@
> ...
>>> +
>>> +static int coproc_mmap(struct file *fp, struct vm_area_struct *vma)
>>> +{
>>> +	struct vas_window *txwin = fp->private_data;
>>> +	unsigned long pfn;
>>> +	u64 paste_addr;
>>> +	pgprot_t prot;
>>> +	int rc;
>>> +
>>> +	if ((vma->vm_end - vma->vm_start) > PAGE_SIZE) {
>>
>> I think you said this should be 4096 rather than 64k, regardless of what
>> PAGE_SIZE you are compiled with?
>
> You can't mmap less than a page, a page is PAGE_SIZE bytes.
>
> So if that checked for 4K explicitly it would prevent mmap on 64K
> kernels always, which seems like not what you want?

Ah. My bad. Carry on then :)

Regards,
Daniel

>
> cheers
