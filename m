Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71FDC4167B
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 23:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 632192245C
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 23:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgLCXes (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbgLCXes (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Dec 2020 18:34:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C240C061A53;
        Thu,  3 Dec 2020 15:34:08 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607038445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FVgoT08TG5YvAmWotKxqMBk0yHe89AS+W1UPWM1cCOU=;
        b=Mk7xKoKfyWCXtaFR+J6/WwO9YqNoUcAKE7Gf37tx2eOi9XndcwIib9aC8OI+iUU861Xh+w
        pnKoSApDWCirVMss6phNCwU4RP3p6SQwTjFSh5pkYl/YIr4bEi13YaYhi5u05Qx2r2+3hk
        eJze6siGQp7I594Xy8lZph0WpKnNNxGfefureAmF0jn2NrCgL83F0qjc7fm87DzCwBejgU
        DcKYRjbD/fU4txtsow+7HM+rycWgqp743Tilo3u92hs3PzEw+vWSIooMVb3RdoXj4iXYVX
        STtTAGp1ix5c2frRNHJTI6XB/QOvEt6SwuFw9D9hkar3a6OYSHz6SJetglsSYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607038445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FVgoT08TG5YvAmWotKxqMBk0yHe89AS+W1UPWM1cCOU=;
        b=Qcd9yBaZDFqngG0LovOd+mh+dCvYjY0RhGey/ZjUu4WH8jUPh+UcEx7LD+xvrATX1m22Fa
        pi2TKOE1zwPT3JDg==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201203173846.GA16207@Red>
References: <20201201130102.GA23461@Red> <87ft4phcyx.fsf@nanos.tec.linutronix.de> <20201201135252.GA9584@Red> <87y2ihfw6z.fsf@nanos.tec.linutronix.de> <20201201144529.GA6786@Red> <87v9dlfthf.fsf@nanos.tec.linutronix.de> <20201202195501.GA29296@Red> <877dpzexfr.fsf@nanos.tec.linutronix.de> <20201203173846.GA16207@Red>
Date:   Fri, 04 Dec 2020 00:34:05 +0100
Message-ID: <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 03 2020 at 18:38, Corentin Labbe wrote:
> On Wed, Dec 02, 2020 at 09:59:36PM +0100, Thomas Gleixner wrote:
>> On Wed, Dec 02 2020 at 20:55, Corentin Labbe wrote:
>> > On Tue, Dec 01, 2020 at 04:15:08PM +0100, Thomas Gleixner wrote:
>> >
>> > The result could be seen at http://kernel.montjoie.ovh/129768.log
>> > The log is 9Mb, but the ftrace dump seems not terminated, tell me if you need more.
>> 
>> Correct, the interesting entries right before the crash are missing. Can
>> you try to make the trace buffers smaller or wait longer before
>> terminating the thing?
>> 
>> 16k buffer size per CPU should be completely sufficient. That should
>> give us roughly the last 100 entries per CPU.
>> 
>> 'trace_buf_size=16k'
>> 
>> is the command line option for that.
>
> I have set a longer timeout and now the job end with the crash:
> http://kernel.montjoie.ovh/130094.log

Ok. So here is the problem:

[  996.933980] cryptset-316       0d..3 73943313us : __kmap_local_pfn_prot: kmap_local_pfn: 0 ffefe000
[  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
[  996.952080] cryptset-316       0d..4 73943419us : kunmap_local_indexed: kunmap_local: 1 ffefe000

There are two maps:

   1) index 0 vaddr 0xffefe000
   2) index 1 vaddr 0xffefd000

Now comes the unmap and unmaps 0xffefe000 which is the first map and not
the second one. -> Fail

[   74.017103] [<c0251824>] (kunmap_local_indexed) from [<c046ca58>] (sg_miter_stop+0xb4/0x164)
[   74.025535] [<c046ca58>] (sg_miter_stop) from [<c046cef4>] (sg_miter_next+0xc/0xe4)
[   74.033191] [<c046cef4>] (sg_miter_next) from [<c075f5dc>] (sun4i_ss_opti_poll+0x278/0x40c)
[   74.041539] [<c075f5dc>] (sun4i_ss_opti_poll) from [<c075fc64>] (sun4i_ss_cipher_poll+0x4f4/0x5e4)
[   74.050497] [<c075fc64>] (sun4i_ss_cipher_poll) from [<c0421394>] (crypto_skcipher_encrypt+0x38/0x5c)
[   74.059713] [<c0421394>] (crypto_skcipher_encrypt) from [<c0432ba0>] (xts_encrypt+0x8c/0xd4)
[   74.068146] [<c0432ba0>] (xts_encrypt) from [<c0421394>] (crypto_skcipher_encrypt+0x38/0x5c)
[   74.076581] [<c0421394>] (crypto_skcipher_encrypt) from [<c043bfd4>] (skcipher_recvmsg+0x364/0x43c)
[   74.085625] [<c043bfd4>] (skcipher_recvmsg) from [<c07c8da0>] (sock_read_iter+0xa8/0xf8)
[   74.093713] [<c07c8da0>] (sock_read_iter) from [<c028ce94>] (vfs_read+0x2b8/0x2d8)
[   74.101279] [<c028ce94>] (vfs_read) from [<c028d394>] (ksys_read+0xb0/0xe4)
[   74.108237] [<c028d394>] (ksys_read) from [<c0100060>] (ret_fast_syscall+0x0/0x58)

The unmap comes from sg_miter_stop() and looking at the previous
map/unmap cycles there are never nested maps.

[  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000

is the first event which allocates a nested map. 

So something goes south either in sg_miter or in the crypto maze.

Enabling CONFIG_DEBUG_KMAP_LOCAL and function tracing might give us more clue.

Thanks,

        tglx
