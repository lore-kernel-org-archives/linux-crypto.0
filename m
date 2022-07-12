Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537E3C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 12:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiGLM1J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 08:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGLM1I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 08:27:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01115AA776;
        Tue, 12 Jul 2022 05:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7B57B817DE;
        Tue, 12 Jul 2022 12:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9982BC341C8;
        Tue, 12 Jul 2022 12:27:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nmAvebnd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657628822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YZIRjEv14tSXjCzag3Hx80j5e2Wjq/ASDZSp8N5bDFk=;
        b=nmAvebndOKs5BzD8Q7YSio8wyD9Y4kFexKe3k320FHatz8PWllya/zR2K9FGxbkNJppdMJ
        8ZE116Wv6mtq27RhdD0yXREv/l+9079Lgydcc6Gr/XZGplHTtRQVj6F8wHzQws6atu0BWK
        fFc19qs+WTtJtqhAMALwkXsrSuWXiHA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a5c466a7 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 12 Jul 2022 12:27:02 +0000 (UTC)
Date:   Tue, 12 Jul 2022 14:27:00 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in
 interrupt context
Message-ID: <Ys1olOgaw44dXeiT@zx2c4.com>
References: <20220712100829.128574-1-freude@linux.ibm.com>
 <Ys1Loyu21C48Zm6n@zx2c4.com>
 <4881578c512c5420315abfef47068df0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4881578c512c5420315abfef47068df0@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Harald,

On Tue, Jul 12, 2022 at 02:09:35PM +0200, Harald Freudenberger wrote:
> > You've gone through the troubles of confirming experimentally what
> > in_task() does, but that doesn't answer *why* it should be disallowed
> > variously in each one of these contexts.
> 
> I think, I showed this. The only real occurrences remaining for the
> arch_get_random_seed_long() call is within softirq context when the
> network layer tries to allocate some skb buffers. My personal feeling
> about this is that it does not hurt - but I asked our network guys
> and their feedback is clear: no way - every delay there may cause
> high bandwidth traffic to stumble and this is to be absolutely avoided.
> However, they can't give me any measurements.
> 
> So yes, the intention is now with checking for in_task() to prevent
> the trng call in hard and soft interrupt context. But still I'd like
> to meet your condition to provide good random at kernel startup.

That's too bad, but okay.

Final question: do you see any of the in_task() vs in_whatever()
semantics changing if arch_get_random_words{,_seed}() is ever
implemented, which would reduce the current multitude of calls to the
trng to a single call?

Jason
