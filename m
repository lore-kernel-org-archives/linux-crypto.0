Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95669C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Apr 2022 09:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbiDJJrb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Apr 2022 05:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiDJJra (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Apr 2022 05:47:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F542AE1B;
        Sun, 10 Apr 2022 02:45:20 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649583917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PwDpLp/IMcJeecAEvyOp/CYm1m3XWAQNJ0gM0y66GTQ=;
        b=kCx397iONgJx+LSvUgmZu29Rb44BWTfWoCL8Pzjc8ufkItUIIR38qbeJLReuhNk3rb1DHM
        whqWSjLgo7Scvl4fH+JNTnOJAWd+kO7w+LBmanIMJhiy9/0fMpWzg4Ak99I57kQBbsOM2e
        tSwe6jeCdrX4uj/rRBaCwVCHbV6hVXsdb/oJtcq2Vrd0wBm7+vwl9GACvpYTOqdjeEOsuU
        9agKG1r8ekyRkF35jQbAP/4ToufmpVClp2HtjZmBsFTBUX7YqszQZHEwW8xExBkmnLmB0d
        daniebCRqDDa09QEqnyirTAOCKDUqZPZm3O/GGPmsqfrrfoYgk1WrYti6apQlg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649583917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PwDpLp/IMcJeecAEvyOp/CYm1m3XWAQNJ0gM0y66GTQ=;
        b=qLi11xHyICneogaEQzyv/PpMpYfwMLTmvBluPhW0NzoHdx4mAe6pomo5wn0wHOrpeSBkY0
        gDS6wRX8cCadJTAg==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: make random_get_entropy() return an unsigned long
In-Reply-To: <20220408175317.140778-1-Jason@zx2c4.com>
References: <20220408175317.140778-1-Jason@zx2c4.com>
Date:   Sun, 10 Apr 2022 11:45:16 +0200
Message-ID: <87tub1gtlf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 08 2022 at 19:53, Jason A. Donenfeld wrote:
> Some implementations were returning type `unsigned long`, while others
> that fell back to get_cycles() were implicitly returning a `cycles_t` or
> an untyped constant int literal. That makes for weird and confusing
> code, and basically all code in the kernel already handled it like it
> was an `unsigned long`. I recently tried to handle it as the largest
> type it could be, a `cycles_t`, but doing so doesn't really help with
> much. Instead let's just make random_get_entropy() return an unsigned
> long all the time. This also matches the commonly used
> `arch_get_random_long()` function, so now RDRAND and RDTSC return the
> same sized integer, which means one can fallback to the other more
> gracefully.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
