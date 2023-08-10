Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16D3C001B0
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Aug 2023 12:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjHJMQT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbjHJMQS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 08:16:18 -0400
X-Greylist: delayed 552 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Aug 2023 05:16:16 PDT
Received: from out-67.mta1.migadu.com (out-67.mta1.migadu.com [IPv6:2001:41d0:203:375::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FEDE4C
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 05:16:16 -0700 (PDT)
Message-ID: <92e61e90-2fa2-4225-8197-d47179d5ec49@metacode.biz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=metacode.biz;
        s=key1; t=1691669221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XzorW1ZpCeJJ+YH45zek0sDVbgFHNxo7WcIG/sx7IMA=;
        b=gCQ58I3YJMUIp9XRQqDB3Lr7CstE+4OZECG6u6bxNJlioarizcz3mufMkVERMT/Xs4KzPp
        WsATKHRCubTTMT2fpsE9q6iedSjdKG3Lp4yr/8W3ftqWu3wulO4dY69DxIaOYUstN/XiDJ
        8y7A+fB1n08NZmMbe3lsgNKzKfDdhNg=
Date:   Thu, 10 Aug 2023 14:06:54 +0200
MIME-Version: 1.0
Subject: Re: Kernel Crypto exposing asymmetric operations to userland via
 libkcapi
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Puru Kulkarni <puruk@protonmail.com>,
        Puru Kulkarni <puruk@juniper.net>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Stephan Mueller <smueller@chronox.de>,
        devel@lists.sequoia-pgp.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
References: <fd31dc60-67b2-8ed8-c941-2b5be777070a@metacode.biz>
 <CAMj1kXFDH+84WJiecBk+nJ+Ko6KuCZMUrbyspP7SrSEjMEYurw@mail.gmail.com>
Content-Language: en-US, pl-PL
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Wiktor Kwapisiewicz <wiktor@metacode.biz>
Organization: Metacode
In-Reply-To: <CAMj1kXFDH+84WJiecBk+nJ+Ko6KuCZMUrbyspP7SrSEjMEYurw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 29.07.2023 10:40, Ard Biesheuvel wrote:
> AF_ALG was never intended to provide a general purpose crypto library
> to user space, but only to expose asynchronous hardware crypto
> accelerators that are DMA based and managed by the OS.
> 
> Exposing the pure-software crypto implementations via AF_ALG was a
> mistake IMHO. Making system calls into a privileged environment just
> to run some algorithm that could easily run unprivileged as well is a
> bad idea both for performance as well as for security/robustness. (On
> top of that, SIMD based implementations need to execute with
> preemption disabled, increasing scheduling jitter)
> 
> Due to the kernel's rigid 'no regressions' policy, AF_ALG will retain
> support for the modes and algorithms it supports today, but I don't
> think we should extend this support unless we limit it to
> implementations provided by hardware accelerators. If it can be done
> in software, it should be done in user space, not in the kernel.

Thank you for the detailed explanation Ard. This makes sense to me.

I did a quick lookup for hardware crypto accelerators available on the 
market and, indeed, symmetric algorithms along with hashes constitute 
the vast majority of what these accelerators support [0].

I've found some accelerators that support asymmetric operations but it 
seems they are mostly targeted at microcontrollers and as such are 
probably outside of supported area here [1][2]. (The accelerator at [0] 
supports asymmetric operations but only public key ones).

[0]: https://www.rambus.com/security/crypto-accelerator-cores/
[1]: 
https://www.ibm.com/docs/en/ztpf/2020?topic=cryptography-hardware-accelerators-perform-rsa-operations
[2]: https://www.nxp.com/docs/en/application-note/AN12445.pdf
