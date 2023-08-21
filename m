Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73839EE49AF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjHUUrn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjHUUrd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 16:47:33 -0400
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADC891
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 13:47:31 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id E64682B0011E;
        Mon, 21 Aug 2023 16:47:27 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 21 Aug 2023 16:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1692650847; x=1692658047; bh=Uc
        Ca1oJRtOpDbgPcFNAxbzQXgymu8/0CJLfNDhr/y04=; b=CUzwBP29TivIBKLdFV
        giaIC/MM8O88y28s7pGXEe0qMeO4fhK6J0PZtUqf7NILjTg6v4BiqzAQSq2piW3i
        mhddTCyFKsmtOIAGoh+I5RCEH/+DycWEOYsnlpCXCcc/vFIoHjur7MhS7iiLMBC/
        ZUP/7R8+ANIc1gy+ZwXizm6W1cFe/9MX3K+RruZa/a7S+euq9XI1O3b/k71haUKZ
        JJjrRqgcEtlcYqOMqlUzSpStAUSlubOMNsqu/6S0G6eF2LBHydqTUKOQ+ky+DCzL
        0b8KqX2plg7Cpg1SYdyY+f7Lpknpb0dhS6jFrGk+RYVBtBIUj/4S0K0ytu7zqGVh
        saWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1692650847; x=1692658047; bh=UcCa1oJRtOpDb
        gPcFNAxbzQXgymu8/0CJLfNDhr/y04=; b=VIEC0KMUu7Al8EZw5ueXB9dV3CbZ/
        IP4FWdHq+d87gzna+OVs1ykwHVTxlKy88x/xPgrGqJl1+Y/64bDBScC0ccAutGnu
        qXQib2H0SLQaL03Fb9U7b6I3PK1/Sm4wMoQ8ux+oDLFizIkFC/Kj1mFN9H6KfpNu
        HuJqzpIz6mJFjlPAjVoAt8S3aXPp4nTFVRbYSK5npfeqPVDQw+bHCBRUqG1Tt9yL
        XKe6tyHQKVH5HiEI2vx6JkFv61ssgHIqDo26uUAsPg1Go1RokWhixmVmE6B22RCT
        nqrq7oHfuG2ghARsxl6NenWTtAtDxyoJkkVUWlKCJ+iZfiB7EL0EOEiFw==
X-ME-Sender: <xms:Xs3jZAFjiNQg2I7dQxeTwERf9__plzelbpQUL_XTg0kuJb-uboy_OA>
    <xme:Xs3jZJUp53GSbIEoolOfv0UdI1IH3dj9_SqnNnvzzKZvmmfrCynseyouZJMlbaSd-
    PmsJa_rk8hz2lQqboU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudduledgudehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Xs3jZKLqhLGtPuMYuxYrpzxR5cMZm4wNd4QPCe3ammYlja5LhHnXOA>
    <xmx:Xs3jZCHfoA5ReDngu5UEAkDBn8NiUKW_WVqspX00ash3ShGfRtZUtA>
    <xmx:Xs3jZGVrpk-WDnHtVa60a4jZL3LbyGDYP-DualHIU4tTUbOXuatQ-w>
    <xmx:X83jZEz4hpQuhdMvmDInswAXCl5xJEopzbRfVUhaUsc-e-leSFdN4bgiVWc>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 591E8B60089; Mon, 21 Aug 2023 16:47:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-647-g545049cfe6-fm-20230814.001-g545049cf
Mime-Version: 1.0
Message-Id: <1373841d-28d4-4dd5-aff5-a6f05d317317@app.fastmail.com>
In-Reply-To: <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
 <20230821102632.GA19294@willie-the-truck>
 <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
Date:   Mon, 21 Aug 2023 16:47:06 -0400
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Weili Qian" <qianweili@huawei.com>,
        "Will Deacon" <will@kernel.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     "Ard Biesheuvel" <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        shenyang39@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox configuration at
 one time
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 21, 2023, at 08:45, Weili Qian wrote:
> On 2023/8/21 18:26, Will Deacon wrote:
>> On Mon, Aug 21, 2023 at 04:19:54PM +0800, Herbert Xu wrote:

> Thanks for the review.
>
> Since the HiSilicon accelerator devices are supported only on the ARM64 
> platform,
> the following 128bit read and write interfaces are added to the driver, 
> is this OK?
>
> #if defined(CONFIG_ARM64)
> static void qm_write128(void __iomem *addr, const void *buffer)
> {

The naming makes it specific to the driver, which is not
appropriate for a global definition. Just follow the
generic naming. I guess you wouldn't have to do both
the readl/writel and the ioread32/iowrite32 variants, so
just start with the ioread/iowrite version. That also
avoids having to come up with a new letter.

You have the arguments in the wrong order compared to iowrite32(),
which is very confusing.

Instead of the pointer to the buffer, I'd suggest passing the
value by value here, to make it behave like the other ones.

This does mean it won't build on targets that don't
define u128, but I think we can handle that in a Kconfig
symbol.

> unsigned long tmp0 = 0, tmp1 = 0;

Don't initialize local variable to zero, that is generally
a bad idea because it hides cases where they are not
initialized properly.

> 	asm volatile("ldp %0, %1, %3\n"
> 		     "stp %0, %1, %2\n"

This is missing the endian-swap for big-endian kernels.

> 		     "dmb oshst\n"

You have the barrier at the wrong end of the helper, it
needs to before the actual store to have the intended
effect.

Also, you should really use the generic __io_bw() helper
rather than open-coding it.

> 		     : "=&r" (tmp0),
> 		     "=&r" (tmp1),

The tmp0/tmp1 registers are technically a clobber, not
an in/out, though ideally these should be turned
into inputs.

> 		     "+Q" (*((char __iomem *)addr))
> 		     : "Q" (*((char *)buffer))

wrong length

> 		     : "memory");
> }

The memory clobber is usually part of the barrier.

> static void qm_read128(void *buffer, const void __iomem *addr)
> {
> 	unsigned long tmp0 = 0, tmp1 = 0;
>
> 	asm volatile("ldp %0, %1, %3\n"
> 		     "stp %0, %1, %2\n"
> 		     "dmb oshst\n"
> 		     : "=&r" (tmp0),
> 		       "=&r" (tmp1),
> 		       "+Q" (*((char *)buffer))
> 		     : "Q" (*((char __iomem *)addr))
> 		     : "memory");
> }

Same thing, but you are missing the control dependency
from __io_ar() here, rather than just open-coding it.

> #else
> static void qm_write128(void __iomem *addr, const void *buffer)
> {
>
> }

This is missing the entire implementation?

      Arnd
