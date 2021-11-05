Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FC7C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 05:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D32661283
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 05:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhKEFiY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 01:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhKEFiX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 01:38:23 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9B8C061714;
        Thu,  4 Nov 2021 22:35:44 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id c2-20020a056830348200b0055a46c889a8so11584786otu.5;
        Thu, 04 Nov 2021 22:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LCuANbQ08TQDsovTPP9WH5ddv8Ij2wOI3eV0v3XKWuM=;
        b=Mc0+HD4ykhYt5yoBzMW27qAf8mtZXaQ9JKg32hBmHi8PF/bVabuXAjLNmgf04wAcOM
         JUrMFtVR7fwJR/Xd2nNXksq8ZUZQexUkcYwkm9U1e7BcW+qH0FHLtfO93lEPs13Kr/ly
         P0LnLR48EuZHRwi0XAoVOSQtaOZdk7GniyqGYO9xz+FPl2S8BG1tEGLnG5an/PYDVXuS
         HqKwGWACxVYmjJlYbJiSxobFlEDZoisjiE9hCU2m5wihf5DSODY2BgB2TZ30RtZEO5r8
         aYDvlDdxShLfUwM4SjygiEVyEv0MM5w1BY7pJiXFDgxtHYXI4EBVnYSsIzGgC3TorR2n
         fiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=LCuANbQ08TQDsovTPP9WH5ddv8Ij2wOI3eV0v3XKWuM=;
        b=sdAOU2CqQpD2AgHPLrIKxlkafWrxT4bZTn2XreToDMBVD4URmuptNHvLRH3PfzID/w
         6gGqdvIXmQqXwiXvI5WacWneBv4Cp3EsVxFBA8ad8kITzT5lOZQNryQXwTpcc7iZXCrk
         vmv05K1fdKPjz0mVnJd4BlY57IPIO7JQjRtcCbuUJXtIYlLDjRTRQL4wE1y0XpFIL4Nh
         ZsHKlroyKKpJ++Wne5jv5wowudpbpfPrpwSAfk4k1UlY14FaRXYevLj3fdqFEmBhYHyi
         iJ9Mpr1H9Ed+wkm+dUCDLfDqlutwx1raLmqsphsTf+/R2mf1dBHgJ8RGRTt08JD6U42C
         7NsA==
X-Gm-Message-State: AOAM532GPZq/zWxXzAL/afwFbqnUQiIknvl1KRdKdpqmpBmS9iWbQ6Tu
        Y7qYSIZsR+j9A8u6kunwzgLkK1BSliA=
X-Google-Smtp-Source: ABdhPJxyq8MzG2xT1PzAfx9rxcvEDviqLj3jTQ4DuheFRaEkzXwnFP+8c758fSFsC4u9x83k2m3BUQ==
X-Received: by 2002:a9d:4b12:: with SMTP id q18mr13317798otf.364.1636090543662;
        Thu, 04 Nov 2021 22:35:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j7sm2001550otn.59.2021.11.04.22.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 22:35:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: crashes in crypto_shash_update()
Message-ID: <ac79dba2-c527-783b-6d0f-b879908bb5b6@roeck-us.net>
Date:   Thu, 4 Nov 2021 22:35:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

I see the following pretty widespread crash in crypto_shash_update().

[    1.574992] Unable to handle kernel paging request at virtual address ffffffffffffffc8
[    1.575611] Oops [#1]
[    1.575698] Modules linked in:
[    1.575866] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.15.0-10159-gb8c4a6bfae4e-dirty #1
[    1.576120] Hardware name: riscv-virtio,qemu (DT)
[    1.576281] epc : crypto_shash_update+0xa/0x2e
[    1.576437]  ra : crc32c+0x2c/0x58
[    1.576553] epc : ffffffff80358b6c ra : ffffffff80395382 sp : ffffffd00021bc00
[    1.576760]  gp : ffffffff81513898 tp : ffffffe001aa8040 t0 : ffffffe001d10568
[    1.576966]  t1 : 000000006a138faa t2 : 0000000000000000 s0 : ffffffd00021bc10
[    1.577173]  s1 : ffffffff8149e500 a0 : ffffffd00021bc10 a1 : ffffffff81077e70
[    1.577378]  a2 : 0000000000000011 a3 : 0000000000000000 a4 : ffffffffffffffb0
[    1.577584]  a5 : ffffffffffffffb0 a6 : 0000000000000000 a7 : 0000000028292846
[    1.577797]  s2 : ffffffff81077e70 s3 : ffffffff81514008 s4 : ffffffff80c004e0
[    1.578005]  s5 : ffffffff81514038 s6 : ffffffff80c10910 s7 : ffffffff80c004a0
[    1.578212]  s8 : ffffffff811669a8 s9 : 0000000000000008 s10: ffffffff80a000ac
[    1.578421]  s11: 0000000000000000 t3 : 0000000000000009 t4 : 0000000042300000
[    1.578628]  t5 : 0000000000000000 t6 : ffffffe003075000
[    1.578785] status: 0000000000000120 badaddr: ffffffffffffffc8 cause: 000000000000000d
[    1.579010] [<ffffffff80358b6c>] crypto_shash_update+0xa/0x2e
[    1.579186] [<ffffffff80395382>] crc32c+0x2c/0x58
[    1.579332] [<ffffffff80a1459a>] btrfs_props_init+0x32/0x70
[    1.579505] [<ffffffff80a13e26>] init_btrfs_fs+0x12/0x16a
[    1.579670] [<ffffffff800020da>] do_one_initcall+0x36/0x15e
[    1.579838] [<ffffffff80a00f5c>] kernel_init_freeable+0x1a6/0x20a
[    1.580023] [<ffffffff808d6648>] kernel_init+0x1e/0x104
[    1.580181] [<ffffffff80002ffa>] ret_from_exception+0x0/0xc
[    1.580700] ---[ end trace 4bfa11496ef965ab ]---


The problem boils down to crypto_alloc_shash() returning -80 (-ELLIBBAD).

Before I spend time analyzing this further, is anyone already looking
into the problem ?

Thanks,
Guenter
