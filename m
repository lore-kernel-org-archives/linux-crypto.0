Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA53C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 08:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127A520850
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 08:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfDLIyy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:54:54 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:36628 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfDLIyy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 04:54:54 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hErxS-0006eR-DH; Fri, 12 Apr 2019 10:54:50 +0200
Date:   Fri, 12 Apr 2019 10:54:50 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
Message-ID: <20190412085450.c7bmgi3pqym67vzm@linutronix.de>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
 <20190411040734.GA2292@roeck-us.net>
 <20190411043933.GA5866@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190411043933.GA5866@sol.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019-04-10 21:39:34 [-0700], Eric Biggers wrote:
> Well, from a quick read of the patch, it's probably because it uses
> raw_cpu_ptr() instead of per_cpu_ptr() when allocating/freeing the buffers, so
> they are unlikely to actually be allocated for all CPUs.

memory is allocated in crypto_scomp_alloc_scratches() before the
algorithm is first used for for_each_possible_cpu. So all CPUs should
have it. 

> Also Sebastian, I don't understand the point of the spinlock.  What was wrong
> with get_cpu()?  Note that taking the spinlock disables preemption too...  Also
> now it's possible to spin for a long time on the spinlock, for no reason really.

The long spin is only possible PREEMPT kernel if the context switches
the CPU between getting the pointer and acquiring the CPU. Should this
really become a problem I could try to think of something.
That spin_lock gives us lock annotation and a lock context. With
preempt_disable() it is just a BKL like thing with no context. And this
basically kills PREEMPT_RT.

> - Eric

Sebastian
