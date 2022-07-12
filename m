Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D646C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 10:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiGLKXn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 06:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbiGLKXl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 06:23:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D828A639E;
        Tue, 12 Jul 2022 03:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93054B817AF;
        Tue, 12 Jul 2022 10:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E601C3411C;
        Tue, 12 Jul 2022 10:23:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DQ+KzUll"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657621414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=64CwWFhDiA66SPWX7jSlTPjF/UHhQb9V81IcYXuJGsM=;
        b=DQ+KzUllrM55QUvXfjff8N+dF4HyBe8YjAmZulSva90IIOtAe/7F037lBlXZOoi0brxzR8
        lgu3TTm3enNcQxz9xZ9Mlr6aZAjjqgdfRtvj3Ei/X0qkuPc0niO3P+KkyTy3dR4oFTYK2m
        A/0dueW6wzoLyqL9RrhRdk9AfPN2hKg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id da62eb63 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 12 Jul 2022 10:23:33 +0000 (UTC)
Date:   Tue, 12 Jul 2022 12:23:31 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in
 interrupt context
Message-ID: <Ys1Loyu21C48Zm6n@zx2c4.com>
References: <20220712100829.128574-1-freude@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712100829.128574-1-freude@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Harald,

On Tue, Jul 12, 2022 at 12:08:29PM +0200, Harald Freudenberger wrote:
> This patch introduces two things:
> 1) The arch_get_random_seed_int() implementation now always
>    returns false. There is no user in the whole kernel using
>    this function.

Please do not do this. It has nothing to do with the rest of the patch,
but also this isn't really the right place to decide on that. As we
discussed last week with the arch_get_random_words{,_seed} branch of the
conversation - https://lore.kernel.org/all/YsQ%2FvZSkzWPLwIte@zx2c4.com/
- there are a few things that might be suboptimal about the API. When we
fix these, I'd prefer for it to be done in some coherent step. What
you're doing here is just gimping the present API, which preemptively
rots the entire thing and *forces* us to remove it for all architectures
since it would become non-dependable. And I don't like having our hands
be forced here. I'd much rather carefully consider this.

So please remove this snippet.

> 2) For the arch_get_random_seed_long() make sure the CPACF trng
>    instruction is never called in any interrupt context.

I don't object overly loudly to this. However, based on your comment in
https://lore.kernel.org/all/7e65130c6e66ce7a9f9eb469eb7e64e0@linux.ibm.com/
, I was under the impression that this wasn't necessary. If you think it
is, it'd be useful to show some measured latency numbers on actual
systems. Otherwise it seems like premature optimization? Anyway, if you
have solid rationale, I'm fine with this as I mentioned in the other
thread. I'm just a bit confused now on the particulars of the "why" part
given your earlier comment.

> This is done by adding an additional condition in_task().

That doesn't seem right. Instead use `!in_hardirq()`, or perhaps
`!in_nmi() && !in_hardirq()`? Otherwise you also disallow this when
serving softirqs, which based on the discussion, I don't think you
really want to do. Or do you? Without actual latency measurements and a
real world look at the implications, it's hard to see what we're after.
 
> which confirms that the call is in softirq context. So in_task() covers exactly
> the cases where we want to have CPACF trng called: not in nmi, not in hard irq,
> not in soft irq but in normal task context and during kernel init.

You've gone through the troubles of confirming experimentally what
in_task() does, but that doesn't answer *why* it should be disallowed
variously in each one of these contexts.

Regards,
Jason
