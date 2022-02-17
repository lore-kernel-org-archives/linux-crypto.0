Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24AEC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Feb 2022 19:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiBQTSZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:18:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbiBQTSZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Feb 2022 14:18:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851EDC2E4B;
        Thu, 17 Feb 2022 11:18:10 -0800 (PST)
Date:   Thu, 17 Feb 2022 20:18:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645125489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCin5ygrpBsE7zD6si65r+YVbvKS66A/QsQ3ZrIRoDs=;
        b=wj84dHxGq//td/JnJiGIo4OlkBeb1iUsbSKmW6uLZttVdxPQe03if76JU8kfvO3y4YKnMU
        SBwOiqJ5AdoTADdWJKTKHXtmJ/1PMk5zTindMBUitjAb3X7u3vsqtax8/Qw9U0VLrM90ya
        wb41+lNNARsWwB2EytlOEUEj7/etV1vCl/WQlHItTO20FyN51z+Yw9qVC/4sdbcp1ULA8c
        DRRxHTK1ZntmebTgQFCPbI/KskIskO/zP961yfdpK13fGOG95DUdrNMuPF1MTUSYInhDSl
        C+uYvto6wBR7OwcZ6+mIf+2aKHpsvps+XMjaWxtdHPprFBLxEQYmEZ6Xij9Olg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645125489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCin5ygrpBsE7zD6si65r+YVbvKS66A/QsQ3ZrIRoDs=;
        b=Q3jXS0qCLOJg66uNIW2rqKiNczEgml33xjYY4HpHu57a/nPliLYmEYuHR0vXv7kxumTseQ
        EcPkbmZ/+m4ikoAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v6] random: clear fast pool, crng, and batches in cpuhp
 bring up
Message-ID: <Yg6fbwtNghu76z2V@linutronix.de>
References: <CAHmME9prO9dop7iBRwN54=GMtLH7amS3m_VqGUzL44G1h=R+2A@mail.gmail.com>
 <20220217180409.13151-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220217180409.13151-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-02-17 19:04:09 [+0100], Jason A. Donenfeld wrote:
> For the irq randomness fast pool, rather than having to use expensive
> atomics, which were visibly the most expensive thing in the entire irq
> handler, simply take care of the extreme edge case of resetting count to
> zero in the cpuhp online handler, just after workqueues have been
> reenabled. This simplifies the code a bit and lets us use vanilla
> variables rather than atomics, and performance should be improved.
> 
> As well, very early on when the CPU comes up, while interrupts are still
> disabled, we clear out the per-cpu crng and its batches, so that it
> always starts with fresh randomness.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Sultan Alsawaf <sultan@kerneltoast.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> v6 improves the comments around each of the cpuhp functions, as
> requested.

Perfect thank you.
Did you miss my question regarding cross-CPU init in
random_prepare_cpu()?

Sebastian
