Return-Path: <SRS0=8ohu=DG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF140C4346E
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 09:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6980F20848
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 09:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="A5Zbb/Dv";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3EnIof77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgI2Jbf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Sep 2020 05:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbgI2JbQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Sep 2020 05:31:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF49C0613D4;
        Tue, 29 Sep 2020 02:31:16 -0700 (PDT)
Date:   Tue, 29 Sep 2020 11:31:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601371875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2djAMpO5TFmJwF9yWVuXnnQCBlfzgcL1zzo3u7vPd8U=;
        b=A5Zbb/DvjeeCK2DUlLEoZrvkhgGJsS37gshTwYsb3aqDUyGzOCuyQR/JFhGPul9jWwCbae
        FCwQd92XgYGn96wE+HRHZnX9/lXWxL5UCQKikaQN3HJpMYQ7dnUuysi6REaMtPAuoUPu7Z
        z9P38bjbqIzIXwget4wZiZoywWP3u3cr8ZKlfCh3wPE23RhcX1u3//hzEcvxpTpT9SRI1F
        djjcpvjKvggYd+6zi005AyTdMMykFsP0ZbXiIzywn4RdT5hWSJtvpfIuH+a5wFTV2+UnL+
        Ls3Z2Fw3Oq3EOa2/sEMMtjZWiUlr4JWmE3WBOpZFmMXLo0cGpJpduAuwhl0d9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601371875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2djAMpO5TFmJwF9yWVuXnnQCBlfzgcL1zzo3u7vPd8U=;
        b=3EnIof77mO0TghjbFH5tQykZxy+5nn/AcwbZ4oiR5qNLmFhOp5rNJf4wsvWgkv1Zk9DKVb
        IGzg5Bz5Fr63y7Aw==
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
Message-ID: <20200929093113.3cv63szruo3c4inu@linutronix.de>
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
 <20200928152432.l3auscdx2suyli4u@linutronix.de>
 <76bb2b545117413eb0879abcf91cf0f0@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <76bb2b545117413eb0879abcf91cf0f0@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-09-29 05:14:31 [+0000], Song Bao Hua (Barry Song) wrote:
> After second thought and trying to make this change, I would like to chan=
ge my mind
> and disagree with this idea. Two reasons:
> 1. while using this_cpu_ptr() without preemption lock, people usually put=
 all things bound
> with one cpu to one structure, so that once we get the pointer of the who=
le structure, we get
> all its parts belonging to the same cpu. If we move the dstmem and mutex =
out of the structure
> containing them, we will have to do:
> 	a. get_cpu_ptr() for the acomp_ctx   //lock preemption
> 	b. this_cpu_ptr() for the dstmem and mutex
> 	c. put_cpu_ptr() for the acomp_ctx  //unlock preemption
> 	d. mutex_lock()
> 	  sg_init_one()
> 	  compress/decompress etc.
> 	  ...
> 	  mutex_unlock
>=20
> as the get() and put() have a preemption lock/unlock, this will make cert=
ain this_cpu_ptr()
> in the step "b" will return the right dstmem and mutex which belong to th=
e same cpu with
> step "a".
>=20
> The steps from "a" to "c" are quite silly and confusing. I believe the ex=
isting code aligns
> with the most similar code in kernel better:
> 	a. this_cpu_ptr()   //get everything for one cpu
> 	b. mutex_lock()
> 	  sg_init_one()
> 	  compress/decompress etc.
> 	  ...
> 	  mutex_unlock

My point was that there will be a warning at run-time and you don't want
that. There are raw_ accessors if you know what you are doing. But=E2=80=A6

Earlier you had compression/decompression with disabled preemption and
strict per-CPU memory allocation. Now if you keep this per-CPU memory
allocation then you gain a possible bottleneck.
In the previous email you said that there may be a bottleneck in the
upper layer where you can't utilize all that memory you allocate. So you
may want to rethink that strategy before that rework.

> 2. while allocating mutex, we can put the mutex into local memory by usin=
g kmalloc_node().
> If we move to "struct mutex lock" directly, most CPUs in a NUMA server wi=
ll have to access
> remote memory to read/write the mutex, therefore, this will increase the =
latency dramatically.

If you need something per-CPU then DEFINE_PER_CPU() will give it to you.
It would be very bad for performance if this allocations were not from
CPU-local memory, right? So what makes you think this is worse than
kmalloc_node() based allocations?

> Thanks
> Barry

Sebastian
