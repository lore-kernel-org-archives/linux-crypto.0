Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08801C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 18:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDFEF6120F
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 18:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhJESTJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Oct 2021 14:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234366AbhJESTJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Oct 2021 14:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2400B61027;
        Tue,  5 Oct 2021 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633457838;
        bh=AnARCZEw/JiowVPdtlhB3pmC/uHkVNszNDedZdihlVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdg+hwdhZXljI9wBKpOfO2HqgvMcXLijby4htwBpmHA/aG8Qe98P8wvUPh8IHs741
         +omxrDIZALyZXVEC50woZAftN/BNw9AqCm8o+syOCD9BWciwiGoaF06UvjvZEQdBPi
         8tTmkWZomma8LNEuGlfbisSI1IKQfMRi/OpLON5Rqq3a1uSF4f/hIXApErg5wv44kn
         bN7MF7boEKmXPKMC+vvbcRV8h5YsxUgxxmoAxSWP/t/TrfLwioyaTh/mC5tdqILhiF
         0KUqppUqZ2S6vxDddl+uxxPccoIdKMGsLKy/n1mo7opJCyBsVb2EyKeCmxFhF0XJJV
         XEvsm4xIe3hZg==
Date:   Tue, 5 Oct 2021 11:17:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: testmgr - Only disable migration in
 crypto_disable_simd_for_test()
Message-ID: <YVyWrKUk81e10zM7@gmail.com>
References: <20210928115401.441339-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928115401.441339-1-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sebastian,

On Tue, Sep 28, 2021 at 01:54:01PM +0200, Sebastian Andrzej Siewior wrote:
> crypto_disable_simd_for_test() disables preemption in order to receive a
> stable per-CPU variable which it needs to modify in order to alter
> crypto_simd_usable() results.
> 
> This can also be achived by migrate_disable() which forbidds CPU
> migrations but allows the task to be preempted. The latter is important
> for PREEMPT_RT since operation like skcipher_walk_first() may allocate
> memory which must not happen with disabled preemption on PREEMPT_RT.
> 
> Use migrate_disable() in crypto_disable_simd_for_test() to achieve a
> stable per-CPU pointer.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The comment above the definition of migrate_disable() in include/linux/preempt.h
claims that it is a temporary workaround.

Is there a better way to do this that should be used instead?

- Eric
