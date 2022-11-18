Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DD4C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiKRJwF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiKRJwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:52:04 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7315F2D7
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+8jFeHfK53thFHUSFDBWh9hINMWFzglzAMyQx5Fn604=; b=UiAa1e2z+A7Oht8yNnwtAZDVxB
        tgU1GB2uJeLMog/5VKd5aEKsSyZ9cXRDofLwZwAxFIE7jOGi8LCVT8xFq8FV4noTJOBXCGGIa1qpd
        V9WwBIfIp4H3VwpV1WbGwdvbC2/HdSgAaPhOc7cwXg57lOELX85d8HUI2cVdcFzeNCBXcMKe9cLy5
        91pH4YzH6Z6k8wotndDLNPPwJO4uFFsDFilIBz/0vDjoPeUAA/GwZ3SX8H/8bosgrfn3lugRx7V9A
        VHvgjkcIZmGL0bQue53v0YMYWunvYLO7bmbFD3Tk2jyLs3n8b3XFb6P+3MxyBAPxojPmUOLFU91B1
        5nwakhqg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovy2Q-001wM9-Ru; Fri, 18 Nov 2022 09:51:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6DFF5300244;
        Fri, 18 Nov 2022 10:51:58 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4FDE8201A1023; Fri, 18 Nov 2022 10:51:58 +0100 (CET)
Date:   Fri, 18 Nov 2022 10:51:58 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 0/11] crypto: CFI fixes
Message-ID: <Y3dVvnLybvx3KUTf@hirez.programming.kicks-ass.net>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 01:02:09AM -0800, Eric Biggers wrote:
> This series fixes some crashes when CONFIG_CFI_CLANG (Control Flow
> Integrity) is enabled, with the new CFI implementation that was merged
> in 6.1 and is supported on x86.  Some of them were unconditional
> crashes, while others depended on whether the compiler optimized out the
> indirect calls or not.  This series also simplifies some code that was
> intended to work around limitations of the old CFI implementation and is
> unnecessary for the new CFI implementation.
> 
> Eric Biggers (11):
>   crypto: x86/aegis128 - fix crash with CFI enabled
>   crypto: x86/aria - fix crash with CFI enabled
>   crypto: x86/nhpoly1305 - eliminate unnecessary CFI wrappers
>   crypto: x86/sha1 - fix possible crash with CFI enabled
>   crypto: x86/sha256 - fix possible crash with CFI enabled
>   crypto: x86/sha512 - fix possible crash with CFI enabled
>   crypto: x86/sm3 - fix possible crash with CFI enabled
>   crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
>   crypto: arm64/sm3 - fix possible crash with CFI enabled
>   crypto: arm/nhpoly1305 - eliminate unnecessary CFI wrapper
>   Revert "crypto: shash - avoid comparing pointers to exported functions
>     under CFI"

These all look good. They will hoever conflict with the alignment
cleanups/changes we've got in tip/x86/core, but there's no helping that
I support.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
