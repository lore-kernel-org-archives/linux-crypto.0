Return-Path: <SRS0=8ohu=DG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F33CC4346E
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 10:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A90208FE
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 10:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ni7fscmq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zlKbLUvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgI2K2z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:28:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45360 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2K2z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Sep 2020 06:28:55 -0400
Date:   Tue, 29 Sep 2020 12:28:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601375333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZy1/JUjxBwS/xwCpto2G8UIj6PQNs3p6DoNNAVeFOw=;
        b=Ni7fscmqCScbEIjbvkmBZdsABowtrIUYy52UJ4kp2MXjEySrOS6SiYCW9uvFXljx2QAKyM
        XB+8X7sttmxZzqMW9OJgPZjIMlybKL+pn9+BaIC5U9sp06vYMq+dQUjdqaU6wLiiZ1Rtm4
        oDrfJeTRlARMzqNbE9+ZyOYf1XvbKUgEj9O8PqKB3yyyZSLVD2V8mVTZt0BirFUfoK39Qh
        TYAZBt0WwpDFGTGOnQfXqxbtt4odkyNZn3SbV0M1YmMeJncg3SOWZzeOSB5n4mQKvRVhla
        1Kgovvv6gvdboZaUv/7PEDjk2iemC+5HzYd6F29Uh6sKzMJruZmReqKbfH53sA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601375333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZy1/JUjxBwS/xwCpto2G8UIj6PQNs3p6DoNNAVeFOw=;
        b=zlKbLUvf92DXLQvjKZLjYOgI9RVQU34MJiDViUoZSqS6rJFLwnSSluK6SNIFWAJMiunGc7
        6IZVZpwaYUS47TDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "fanghao (A)" <fanghao11@huawei.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v6] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20200929102851.3m5ardu2orfbhe3d@linutronix.de>
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
 <20200928152432.l3auscdx2suyli4u@linutronix.de>
 <76bb2b545117413eb0879abcf91cf0f0@hisilicon.com>
 <20200929093113.3cv63szruo3c4inu@linutronix.de>
 <5951148aef79459192826f405a6fa5aa@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5951148aef79459192826f405a6fa5aa@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-09-29 10:02:15 [+0000], Song Bao Hua (Barry Song) wrote:
> > My point was that there will be a warning at run-time and you don't want
> > that. There are raw_ accessors if you know what you are doing. But=E2=
=80=A6
>=20
> I have only seen get_cpu_ptr/var() things will disable preemption. I don'=
t think
> we will have a warning as this_cpu_ptr() won't disable preemption.

Good. Just enable CONFIG_DEBUG_PREEMPT and tell please what happens.

> > Earlier you had compression/decompression with disabled preemption and
>=20
> No. that is right now done in enabled preemption context with this patch.=
 The code before this patch
> was doing (de)compression in preemption-disabled context by using get_cpu=
_ptr and get_cpu_var.

Exactly what I am saying. And within this get_cpu_ptr() section there
was the compression/decompression sitting. So compression/decompression
happend while preemtion was off.

> > strict per-CPU memory allocation. Now if you keep this per-CPU memory
> > allocation then you gain a possible bottleneck.
> > In the previous email you said that there may be a bottleneck in the
> > upper layer where you can't utilize all that memory you allocate. So you
> > may want to rethink that strategy before that rework.
>=20
> we are probably not talking about same thing :-)
> I was talking about possible generic swap bottleneck. For example, LRU is=
 global,
> while swapping, multiple cores might have some locks on this LRU. for exa=
mple,
> if we have 8 inactive pages to swap out, I am not sure if mm can use 8 co=
res
> to swap them out at the same time.

In that case you probably don't need 8* per-CPU memory for this task.

> >=20
> > > 2. while allocating mutex, we can put the mutex into local memory by =
using
> > kmalloc_node().
> > > If we move to "struct mutex lock" directly, most CPUs in a NUMA serve=
r will
> > have to access
> > > remote memory to read/write the mutex, therefore, this will increase =
the
> > latency dramatically.
> >=20
> > If you need something per-CPU then DEFINE_PER_CPU() will give it to you.
>=20
> Yes. It is true.
>=20
> > It would be very bad for performance if this allocations were not from
> > CPU-local memory, right? So what makes you think this is worse than
> > kmalloc_node() based allocations?
>=20
> Yes. If your read zswap code, it has considered NUMA very carefully by al=
locating various
> memory locally. And in crypto framework, I also added API to allocate loc=
al compression.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D7bc13b5b60e94
> this zswap patch has used the new node-aware API.
>=20
> Memory access crossing NUMA node, practically crossing packages, can dram=
atically increase,
> like double, triple or more.

So you are telling me, DEFINE_PER_CPU() does not allocate the memory for
each CPU to be local but kmalloc_node() does?

> Thanks
> Barry

Sebastian
