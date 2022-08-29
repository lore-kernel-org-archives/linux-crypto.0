Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FA5C0502C
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Aug 2022 16:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiH2QkF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiH2QkD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2022 12:40:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A873055AA;
        Mon, 29 Aug 2022 09:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F18BB81162;
        Mon, 29 Aug 2022 16:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9B0C433D6;
        Mon, 29 Aug 2022 16:39:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LfnwDr2l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1661791194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oF1j60atJlDmJ/i/cn/SVD6+lw8BdA37ZDx7OhjUUlY=;
        b=LfnwDr2lKEuM/Iwq0wN8pMO7EITZzEXBK5Kj2tMINL0OnmV9YDrfbY2Q39x0MdvAPxPqU6
        fNfDUe+vtWaZF0gRIt21dYVm25wBfkrMt3+G7os0IBL6FyocNXA5YinK8TyR1pNh4fvn6Y
        6Am/7NMH2JQJRpwpE/jexjTKW7H4NVA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5635b464 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 29 Aug 2022 16:39:54 +0000 (UTC)
Date:   Mon, 29 Aug 2022 12:39:53 -0400
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adam Langley <agl@google.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: Should Linux set the new constant-time mode CPU flags?
Message-ID: <Ywzr2d52ixYXUDWR@zx2c4.com>
References: <YwgCrqutxmX0W72r@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwgCrqutxmX0W72r@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Thu, Aug 25, 2022 at 11:15:58PM +0000, Eric Biggers wrote:
> I'm wondering if people are aware of this issue, and whether anyone has any
> thoughts on whether/where the kernel should be setting these new CPU flags.
> There don't appear to have been any prior discussions about this.  (Thanks to

Maybe it should be set unconditionally now, until we figure out how to
make it more granular.

In terms of granularity, I saw other folks suggesting making it per-task
(so, presumably, a prctl() knob), and others mentioning doing it just
for kernel crypto. For the latter, I guess the crypto API could set it
inside of its abstractions, and the various lib/crypto APIs could set it
at invocation time. I wonder, though, what's the cost of
enabling/disabling it? Would we in fact need a kind of lazy-deferred
disabling, like we have with kernel_fpu_end()? I also wonder what
crypto-adjacent code might wind up being missed if we're going function
by function. Like, obviously we'd set this for crypto_memneq, but what
about potential unprotected `==` of ID numbers that could leak some info
in various protocols? What other subtle nearby code should we be
thinking about, that relies on constant time logic but isn't neatly
folded inside a crypto_do_something() function?

Jason
