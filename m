Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE76EC4361A
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 13:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5165225A9
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 13:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgLDN1X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 08:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgLDN1W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 08:27:22 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78476C061A51;
        Fri,  4 Dec 2020 05:26:36 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 3so6986745wmg.4;
        Fri, 04 Dec 2020 05:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XgNU+dzto7OQpmm9kdWO0aa6LMlX6sRVNSs+awB7ho4=;
        b=kO2QkYxzveznpg7gl8oGm4q6tcngV2R5tzYtnDVHzxy4egtUYwUwOCFQpigkO+ADZY
         0yBrZacO0QrDPrPm3N5rQp2R5lvYqsQZi96FLOM3w/eXzwsWNG8VaOF3ZegNY9ZeTEQA
         v9eg7pXn1yBoB7+GQgav3CVU9/v7WyFI/ytoeJUfL4KRpu7Tj0V83QA63Rg0aY5MzmW+
         kUa+JDe6znciHbDAdAzaV+gx+gXaW9SUvzagZyOCI7wxnlEIIyDIstVeQXJIDnmmewgG
         vX8sQjjE5BBe4MH8mK8cGfb3raErvcMJx/bI8HJsV1ZcnpH0PCHIGVDP8EoMYVIMCPgc
         zo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XgNU+dzto7OQpmm9kdWO0aa6LMlX6sRVNSs+awB7ho4=;
        b=VF0gYpMxVJYhWVA3z/7axd1Zk3kAjGfP8uo0oyyhZn+Gykd0VJwNxejehL1YDsDYYR
         sqNFLjr+YVTbqQislh5cwTLn7fNCgh8nk5ckl91bx/KIznt0uz95MfSm55lAkaDo+LYn
         L6jZtDedBxK6eLtVI/jlbF6rs42cBWp+gN1UpShpYCtBTXtfE27+WLiBHf4T1FmtuAp6
         jZMYdO5vUlO5p8EcQly66mItdiBVSQzOPHVVe3MPadj5TfmwtgO0xAk0qJsq9QNquIzL
         tTbgC8qm466kMsYTu5mr5ZvEQZCqjsIc1z7wW/3SJcloOOAXz2a8VvOp+z1A70sywkPR
         cbCA==
X-Gm-Message-State: AOAM530Uyr/KArNnFCZfOXDlSSh0yfmto17pdBIFCTjVs8m4h/MzoUc0
        RaciIx3K2BuE+F6z4GXQclk=
X-Google-Smtp-Source: ABdhPJx5diu1RXTDbROUYmuDJFLzn1ChHMtuDsWWAgCQL9BQ3s9sMJEghNoSwNg8VUIUubIE8wkcFg==
X-Received: by 2002:a7b:c00b:: with SMTP id c11mr4328900wmb.122.1607088395251;
        Fri, 04 Dec 2020 05:26:35 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q1sm3576353wrj.8.2020.12.04.05.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 05:26:34 -0800 (PST)
Date:   Fri, 4 Dec 2020 14:26:31 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201204132631.GA25321@Red>
References: <20201201130102.GA23461@Red>
 <87ft4phcyx.fsf@nanos.tec.linutronix.de>
 <20201201135252.GA9584@Red>
 <87y2ihfw6z.fsf@nanos.tec.linutronix.de>
 <20201201144529.GA6786@Red>
 <87v9dlfthf.fsf@nanos.tec.linutronix.de>
 <20201202195501.GA29296@Red>
 <877dpzexfr.fsf@nanos.tec.linutronix.de>
 <20201203173846.GA16207@Red>
 <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 04, 2020 at 12:34:05AM +0100, Thomas Gleixner wrote:
> On Thu, Dec 03 2020 at 18:38, Corentin Labbe wrote:
> > On Wed, Dec 02, 2020 at 09:59:36PM +0100, Thomas Gleixner wrote:
> >> On Wed, Dec 02 2020 at 20:55, Corentin Labbe wrote:
> >> > On Tue, Dec 01, 2020 at 04:15:08PM +0100, Thomas Gleixner wrote:
> >> >
> >> > The result could be seen at http://kernel.montjoie.ovh/129768.log
> >> > The log is 9Mb, but the ftrace dump seems not terminated, tell me if you need more.
> >> 
> >> Correct, the interesting entries right before the crash are missing. Can
> >> you try to make the trace buffers smaller or wait longer before
> >> terminating the thing?
> >> 
> >> 16k buffer size per CPU should be completely sufficient. That should
> >> give us roughly the last 100 entries per CPU.
> >> 
> >> 'trace_buf_size=16k'
> >> 
> >> is the command line option for that.
> >
> > I have set a longer timeout and now the job end with the crash:
> > http://kernel.montjoie.ovh/130094.log
> 
> Ok. So here is the problem:
> 
> [  996.933980] cryptset-316       0d..3 73943313us : __kmap_local_pfn_prot: kmap_local_pfn: 0 ffefe000
> [  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
> [  996.952080] cryptset-316       0d..4 73943419us : kunmap_local_indexed: kunmap_local: 1 ffefe000
> 
> There are two maps:
> 
>    1) index 0 vaddr 0xffefe000
>    2) index 1 vaddr 0xffefd000
> 
> Now comes the unmap and unmaps 0xffefe000 which is the first map and not
> the second one. -> Fail
> 
> [   74.017103] [<c0251824>] (kunmap_local_indexed) from [<c046ca58>] (sg_miter_stop+0xb4/0x164)
> [   74.025535] [<c046ca58>] (sg_miter_stop) from [<c046cef4>] (sg_miter_next+0xc/0xe4)
> [   74.033191] [<c046cef4>] (sg_miter_next) from [<c075f5dc>] (sun4i_ss_opti_poll+0x278/0x40c)
> [   74.041539] [<c075f5dc>] (sun4i_ss_opti_poll) from [<c075fc64>] (sun4i_ss_cipher_poll+0x4f4/0x5e4)
> [   74.050497] [<c075fc64>] (sun4i_ss_cipher_poll) from [<c0421394>] (crypto_skcipher_encrypt+0x38/0x5c)
> [   74.059713] [<c0421394>] (crypto_skcipher_encrypt) from [<c0432ba0>] (xts_encrypt+0x8c/0xd4)
> [   74.068146] [<c0432ba0>] (xts_encrypt) from [<c0421394>] (crypto_skcipher_encrypt+0x38/0x5c)
> [   74.076581] [<c0421394>] (crypto_skcipher_encrypt) from [<c043bfd4>] (skcipher_recvmsg+0x364/0x43c)
> [   74.085625] [<c043bfd4>] (skcipher_recvmsg) from [<c07c8da0>] (sock_read_iter+0xa8/0xf8)
> [   74.093713] [<c07c8da0>] (sock_read_iter) from [<c028ce94>] (vfs_read+0x2b8/0x2d8)
> [   74.101279] [<c028ce94>] (vfs_read) from [<c028d394>] (ksys_read+0xb0/0xe4)
> [   74.108237] [<c028d394>] (ksys_read) from [<c0100060>] (ret_fast_syscall+0x0/0x58)
> 
> The unmap comes from sg_miter_stop() and looking at the previous
> map/unmap cycles there are never nested maps.
> 
> [  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
> 
> is the first event which allocates a nested map. 
> 
> So something goes south either in sg_miter or in the crypto maze.
> 
> Enabling CONFIG_DEBUG_KMAP_LOCAL and function tracing might give us more clue.

Done, http://kernel.montjoie.ovh/130466.log
