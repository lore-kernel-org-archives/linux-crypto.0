Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC77C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 14:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiGLOoz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiGLOol (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 10:44:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60AF27FC5;
        Tue, 12 Jul 2022 07:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602D2609FB;
        Tue, 12 Jul 2022 14:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFE3C341C8;
        Tue, 12 Jul 2022 14:44:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SKhR9YMk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657637074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FRjN/y/5Q9R+BRYskVsQtLtxtn9xVaAqa0IqqnonwGo=;
        b=SKhR9YMk3Ua/PF8vT+FV0c1lhYgnfMGvwJLQCyGg58PafsJoX6rC62PcX3LvW9ilZ8/3fm
        eZlg0SPsqHDjuKknE+Wwmvsayr/p/gE6p1aPEAsFw6oSmDZNch86IMfzsXfxiJRT0kWxXi
        fZ+bsX2YGegxeuJ/FS9yYoNc8wNIBBQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 52b081b0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 12 Jul 2022 14:44:34 +0000 (UTC)
Date:   Tue, 12 Jul 2022 16:44:30 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in
 interrupt context
Message-ID: <Ys2IzgYW4FHTHiu3@zx2c4.com>
References: <20220712100829.128574-1-freude@linux.ibm.com>
 <Ys1Loyu21C48Zm6n@zx2c4.com>
 <4881578c512c5420315abfef47068df0@linux.ibm.com>
 <Ys1olOgaw44dXeiT@zx2c4.com>
 <ac816519f9d8f4948434acb0db631041@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac816519f9d8f4948434acb0db631041@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Harald,

On Tue, Jul 12, 2022 at 04:35:41PM +0200, Harald Freudenberger wrote:
> On 2022-07-12 14:27, Jason A. Donenfeld wrote:
> > Hi Harald,
> > 
> > On Tue, Jul 12, 2022 at 02:09:35PM +0200, Harald Freudenberger wrote:
> >> > You've gone through the troubles of confirming experimentally what
> >> > in_task() does, but that doesn't answer *why* it should be disallowed
> >> > variously in each one of these contexts.
> >> 
> >> I think, I showed this. The only real occurrences remaining for the
> >> arch_get_random_seed_long() call is within softirq context when the
> >> network layer tries to allocate some skb buffers. My personal feeling
> >> about this is that it does not hurt - but I asked our network guys
> >> and their feedback is clear: no way - every delay there may cause
> >> high bandwidth traffic to stumble and this is to be absolutely 
> >> avoided.
> >> However, they can't give me any measurements.
> >> 
> >> So yes, the intention is now with checking for in_task() to prevent
> >> the trng call in hard and soft interrupt context. But still I'd like
> >> to meet your condition to provide good random at kernel startup.
> > 
> > That's too bad, but okay.
> > 
> > Final question: do you see any of the in_task() vs in_whatever()
> > semantics changing if arch_get_random_words{,_seed}() is ever
> > implemented, which would reduce the current multitude of calls to the
> > trng to a single call?
> > 
> > Jason
> 
> Hm, no, I can't see a way to provide trng random data in any whatever
> interrupt context for the next future. The only enabler would be to
> use a buffer ... I started to get in contact with our hardware guys
> to make the trng data internally buffered and this the invocation
> could be in no time give back random data. But this may be a
> hardware development thing for the next machine generation.

Alrightie then. Well, I'll Ack a v2 that keeps the _int variant. Sounds
like then we'll be done here.

Tangential topic: would be nice to add the TRNG instruction to QEMU's
TCG so that VMs in CI have a bit of randomness available.

Jason
