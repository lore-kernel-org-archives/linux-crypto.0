Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48080C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 01:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297E6616E8
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 01:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhEKBvW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 21:51:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46345 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhEKBvW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 21:51:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FfLTf71vzz9sWq;
        Tue, 11 May 2021 11:50:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1620697815;
        bh=6Tbo2+XuK01CmUlRQdE2eT23+kAa6cyfz+ps43fG7SA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HjbE8xHKcqqTsWtctdsK21GDasEq9DlzCCvR44yW6x3Uhjgzq9FTTmRiXjGU8iN9r
         SIYgNfKRu6xpvlTsluzqwq4BD3X0ZoJ3FwEIo+CE8YUYsFVcrwWzuowawT3SqhwHI5
         R4Nu9PHRpoc1zJPNijiKIcF24Q8BPIvP8xhqvFGjaxtkpyHzhn7+k4Pp35N4/LBoCy
         u9IMde+S7uwk9JlTt/LvKZaO0m/2+7MYswus8hiv8qAG+NhZdxTSgb6Jgdcx6v2alp
         3X81B6Ez3v4fBCAQWPJceoMk7fLH9I5r2kzAaZ9A1p+fEE3wcY1s8Dpzj+b3oBJBbN
         hw4Eke7P0568w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Haren Myneni <haren@linux.ibm.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Subject: Re: [PATCH V3 02/16] powerpc/vas: Move VAS API to common book3s
 platform
In-Reply-To: <1620623481.kmr54zmxzv.astroid@bobo.none>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
 <163867b893124434dfe3e13c6ba2f081c309e96f.camel@linux.ibm.com>
 <1620623481.kmr54zmxzv.astroid@bobo.none>
Date:   Tue, 11 May 2021 11:50:11 +1000
Message-ID: <87pmxyxcmk.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> Excerpts from Haren Myneni's message of April 18, 2021 7:02 am:
>> 
>> Using the same /dev/crypto/nx-gzip interface for both powerNV and
>> pseries.
>
> The pseries NX driver will use the powernv VAS API ?
>
>> So this patch creates platforms/book3s/ and moves VAS API
>> to that directory. The actual functionality is not changed.
>> 
>> Common interface functions such as open, window open ioctl, mmap
>> and close are moved to arch/powerpc/platforms/book3s/vas-api.c
>> Added hooks to call platform specific code, but the underline
>> powerNV code in these functions is not changed.
>
> Even so, could you do one patch that just moves, and another that
> adds the ops struct?
>
>> 
>> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>> ---
>>  arch/powerpc/include/asm/vas.h                | 22 ++++++-
>>  arch/powerpc/platforms/Kconfig                |  1 +
>>  arch/powerpc/platforms/Makefile               |  1 +
>>  arch/powerpc/platforms/book3s/Kconfig         | 15 +++++
>>  arch/powerpc/platforms/book3s/Makefile        |  2 +
>
> The usual place for these would be arch/powerpc/sysdev/vas. E.g., see
> arch/powerpc/sysdev/xive.

You're right that is the usual place, but is it a good place? :)

Using platforms/book3s was my suggestion:

  https://lore.kernel.org/linuxppc-dev/87k0p6s5lo.fsf@mpe.ellerman.id.au/


But I don't feel that strongly about it, maybe just dumping things in
sysdev is easier.

cheers
