Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35234C4361A
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 15:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AA5922B2D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 15:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbgLDPJK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 10:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDPJJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 10:09:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF621C061A51;
        Fri,  4 Dec 2020 07:08:29 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607094507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m+5fUfCGN4l8PttwLmFKEO9H2mckNeF24mD/TIdsWmA=;
        b=IMK9HWTOFmsmGjUiNSHj45Vv6+Y4MUAZ4rHxVC3aeoHN2rE5EBGlduOSi8RJbyfAANrFlR
        LvoWc0CDfTy7NXTHYTYsXnVED6ZyvuyBTu0a9o5jYQdphqrLvLPbskLSFNdS7uWI2tUzqz
        cBemexfhX7i3B63iOQUMo+oE/d/o4zpyumtdAlZEuRm8S1RezGtdjN3T+jpF3gwVy4yLqq
        7iP8XzvD/utBLvvxbLB0QOeJEFBwWoUuDHD8XVo8WC5mIwK2cUH+CEvlvaN/TDjn7U2OZL
        z/SvS8RdMz/hjlYEnAejzfQZW5mr/bR2gzQ0XB7qiehZGarVU+FzWkPfkh7pog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607094507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m+5fUfCGN4l8PttwLmFKEO9H2mckNeF24mD/TIdsWmA=;
        b=INkOrHiJFDwY6z7hGqBnk6yKA9vFBYJNsviMtfs2IwfBxi0PyZSJvR9EccALbcd/BAKPYz
        qCzaYhAQYTLVRtDg==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201204132631.GA25321@Red>
References: <20201201130102.GA23461@Red> <87ft4phcyx.fsf@nanos.tec.linutronix.de> <20201201135252.GA9584@Red> <87y2ihfw6z.fsf@nanos.tec.linutronix.de> <20201201144529.GA6786@Red> <87v9dlfthf.fsf@nanos.tec.linutronix.de> <20201202195501.GA29296@Red> <877dpzexfr.fsf@nanos.tec.linutronix.de> <20201203173846.GA16207@Red> <87r1o6bh1u.fsf@nanos.tec.linutronix.de> <20201204132631.GA25321@Red>
Date:   Fri, 04 Dec 2020 16:08:27 +0100
Message-ID: <874kl1bod0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 04 2020 at 14:26, Corentin Labbe wrote:
> On Fri, Dec 04, 2020 at 12:34:05AM +0100, Thomas Gleixner wrote:
>> The unmap comes from sg_miter_stop() and looking at the previous
>> map/unmap cycles there are never nested maps.
>> 
>> [  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
>> 
>> is the first event which allocates a nested map. 
>> 
>> So something goes south either in sg_miter or in the crypto maze.
>> 
>> Enabling CONFIG_DEBUG_KMAP_LOCAL and function tracing might give us more clue.
>
> Done, http://kernel.montjoie.ovh/130466.log

Does not provide more information with the debug enabled. So can you
please enable CONFIG_FUNCTION_TRACER and add 'ftrace=function' to the
command line?

Thanks,

        tglx
