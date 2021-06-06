Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC40C47096
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Jun 2021 10:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 102DA60FEE
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Jun 2021 10:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhFFKJE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Jun 2021 06:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhFFKJE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jun 2021 06:09:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5040C061766
        for <linux-crypto@vger.kernel.org>; Sun,  6 Jun 2021 03:07:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g20so21654122ejt.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Jun 2021 03:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7+MDpZbhCCON3M2CQK9ooFKS0Z3A4ieFQqrLiLPPz+Q=;
        b=mRkbRnWUjCiSy/JOpWtNHNU0BESuBgkzh4vP4QFfAHLJof+aGBgsp2WMvQF3ltE97U
         MF0graLXOXZ79jZ0kFONdENClRleoDurmpjAHL9sfWvGASRXC2hBgBAmsPDBjZYqg7IZ
         JK+no9rMqkWqo4mFqdYGXNm124F3B3ptJU1PWGUKaZdC/WeYPXcV0bDcfsN/26F2Gj7V
         Yc7L35MDjcfhojXosTaQAi7kDqsDt8FXoRNTc4kJzgtBxwn5cxlrarckLffRKgqxeKkI
         v2Y4GLoBdHHB5Fei16GPMmSmQp18Gy+Ts3QBiXefMzlKgMcK4rbmf2RF7wSwzb4j1ysj
         9QDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7+MDpZbhCCON3M2CQK9ooFKS0Z3A4ieFQqrLiLPPz+Q=;
        b=i5QTE7wMIch2m08YrSvKx/HsZsbsQd3QIHlxHcJ37Ilr0K1dHJvkTEGMc7O+CHKGgs
         +tktqNfjnDWwWXO8/Coy8EHw435mPLC4YQ+WQjRc6SlNWswCVRj9GTxyFe5NjMFqwJFh
         ZCE7DWP+mOTbow3gxF//ta2+aaabMHhU3hie20lvFarfQVXGE7za6/tzjN9ca37wLwjb
         V/x+B8lI5RM6f7kZ7nzSTQ5X+Ku0G5CmIbPg5fqGKnNYGB9YcRsOVEjlpDXD2ZlzNdHk
         rtN4U6dtOkGAd3sjm5IXUwWNE6Flm4Hj9RcXF2FV1xvOEAc5Uzil0cBJMK8U0aX5nPUm
         92BQ==
X-Gm-Message-State: AOAM5337G+2D0jjVFQb8bhNCFYeCQJSxmHkxndx98dS1ycuJQp5jRqCA
        CTEgrmJmVnq9SZSPj/EnFj8OrNPLF7E=
X-Google-Smtp-Source: ABdhPJz6S2rMifCykDFu9tdRaeB58R7Dw2hWVtc0qA6H9+tPNHIqpnikZr3ldizfCwNgvBC+AMtceg==
X-Received: by 2002:a17:906:a0d3:: with SMTP id bh19mr13320244ejb.205.1622974033247;
        Sun, 06 Jun 2021 03:07:13 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff12ab00d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff12:ab00:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id g4sm6182700edw.8.2021.06.06.03.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 03:07:12 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94.2)
        (envelope-from <chunkeey@gmail.com>)
        id 1lpnoL-0004sy-CG; Sun, 06 Jun 2021 12:07:10 +0200
Subject: Re: Qualcomm Crypto Engine performance numbers on mainline kernel
To:     Ard Biesheuvel <ardb@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <bc3c139f-4c0c-a9b7-ae00-59c2f8292ef8@linaro.org>
 <CAMj1kXGRb=_tozRAMA+ZFbAHU4P7ocLbWq+B3s0ngoRoo82V6g@mail.gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <0bd651ea-a062-3883-77ee-6ac275d66741@gmail.com>
Date:   Sun, 6 Jun 2021 12:07:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGRb=_tozRAMA+ZFbAHU4P7ocLbWq+B3s0ngoRoo82V6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/06/2021 17:32, Ard Biesheuvel wrote:
> Hello Thara,
> 
> On Fri, 4 Jun 2021 at 18:49, Thara Gopinath <thara.gopinath@linaro.org> wrote:
>>
>>
>> Hi All,
>>
>> Below are the performance numbers from running "crypsetup benchmark" on
>> CE algorithms in the mainline kernel. All numbers are in MiB/s. The
>> platform used is RB3 for sdm845 and MTPs for rest of them.
>>
>>
>>                          SDM845    SM8150     SM8250     SM8350
>> AES-CBC (128)
>> Encrypt / Decrypt       114/106  36/48       120/188    133/197
>>
>> AES-XTS (256)
>> Encrypt / Decrypt       100/102  49/48       186/187    n/a
>>
> 
> The CPU instruction based ones are apparently an order of magnitude
> faster, and are synchronous so their latency should be lower.
> 
> So, as Eric already pointed out IIRC, there doesn't seem to be much
> value in enabling this IP in Linux - it should not be the default
> choice/highest priority, and it is not obvious to me whether/when you
> would prefer this implementation over the CPU based one. Do you have
> any idea how many queues it has, or how much data it can process in
> parallel? Are there other features that stand out?

While I can't say much for the qce-crypto. I do know that "cryptsetup
benchmark" isn't the greatest for pitting the hardware accelerated
crypto against the CPU in some instances.

In my case (crypto4xx / CPU is a PowerPC 464 800MHz - Hardware is a
Western Digital My Book Live - NAS) the "benchmark" results look
exceptionally poor:
#     Algorithm |       Key |      Encryption |      Decryption
         aes-cbc        128b         8.0 MiB/s         8.7 MiB/s
         aes-cbc        256b         8.7 MiB/s         8.7 MiB/s
         aes-xts        256b         5.3 MiB/s         7.9 MiB/s
         aes-xts        512b         7.9 MiB/s         7.9 MiB/s
(Hardware doesn't have cts/xts, but aes-cbc, aes-ctr and aes-gcm)

(for comparison, these are numbers that are produced by only the
800 MHz PowerPC CPU)
         aes-cbc        128b        15.8 MiB/s        16.3 MiB/s
         aes-cbc        256b        12.3 MiB/s        12.8 MiB/s
         aes-xts        256b        12.5 MiB/s        15.1 MiB/s
         aes-xts        512b        11.9 MiB/s        12.0 MiB/s


and (openssl speed -evp aes-128-cbc --elapsed -seconds 3) software
manages similar numbers:

type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
aes-128-cbc      12646.42k    16806.66k    18349.31k    18762.07k    18896.21k    18879.83k

However, when I format a partition on the NAS HDD with
cryptsetup + crypto4xx and use hdparm -i / dd

# hdparm -t /dev/mapper/aes-cbc-hw-test

/dev/mapper/aes-cbc-hw-test:
  Timing buffered disk reads:  96 MB in  3.05 seconds =  31.46 MB/sec

# dd if=/dev/mapper/aes-cbc-hw-test of=/dev/null bs=8M status=progress
5318377472 bytes (5.3 GB, 5.0 GiB) copied, 143 s, 37.2 MB/s^C
639+0 records in
638+0 records out
5351931904 bytes (5.4 GB, 5.0 GiB) copied, 144.246 s, 37.1 MB/s

whereas without crypto4xx:

# hdparm -t /dev/mapper/aes-cbc-hw-test

/dev/mapper/aes-cbc-hw-test:
  Timing buffered disk reads:  34 MB in  3.14 seconds =  10.82 MB/sec

# dd if=/dev/mapper/aes-cbc-hw-test of=/dev/null bs=8M status=progress
46+0 records in
45+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 33.1952 s, 11.4 MB/s

This is 2-3 times the throughput that the CPU alone could do.

@Thara, Do you have a usb-3.0 + fast 3.0 usb-stick? If so, try
to format a partition on it for cryptsetup and try it there.

Cheers,
Christian
