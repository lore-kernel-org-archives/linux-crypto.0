Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B01CCA47B
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 13:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiGEN71 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 09:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGEN7N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 09:59:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4A428E10;
        Tue,  5 Jul 2022 06:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7499616C5;
        Tue,  5 Jul 2022 13:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78815C341C7;
        Tue,  5 Jul 2022 13:42:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gtXqbFEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657028543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=se6L8p5H3lyi4cYsraIxRpM/o0jGdXXLjH1kl8y+UVI=;
        b=gtXqbFEnKtFFGPYQoSCGeXjV3K6cLu8poukGGBUMIJn0geErF4t8toYjTETYKzbmhkdrdg
        XXy1mpj8gVno/g27HQ3o9f03PKAfhK/+DfyoKXuxqxWbR9DnrRY7DcMI76Eun46B8dSbXh
        3TN1RblXRwuwWqtK3cWatR0IWOoQeyc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2493cf55 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 13:42:23 +0000 (UTC)
Date:   Tue, 5 Jul 2022 15:42:21 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Holger Dengler <dengler@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Message-ID: <YsQ/vZSkzWPLwIte@zx2c4.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com>
 <YsQ6OOrOWPhdynoM@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsQ6OOrOWPhdynoM@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey again,

On Tue, Jul 5, 2022 at 3:18 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Tue, Jul 05, 2022 at 01:27:12PM +0200, Holger Dengler wrote:
> > The trng instruction is very expensive and has a constant runtime for
> > getting 0 to 32 bytes of (conditioned) true random data. Calling trng for

Thinking about this a bit more, though, makes me think that maybe the
API itself is suboptimal.

First, we never use arch_get_random_int() anywhere in the kernel, so in
theory it could be removed. Next, we could change the signature of it to
be something like:

  static inline size_t arch_get_random_words_seed(unsigned long *buf, size_t num_words);
  static inline size_t arch_get_random_words(unsigned long *buf, size_t num_words);

Since it's a static inline, when words==1, the code would be constant
folded to the same thing it is now on x86. And when it's larger, we'd
get more bang for our buck on s390.

An unfortunate complication is that the uses in random.c currently
follow the pattern of:

  if (!arch_get_random_seed_long(&v) || !arch_get_random_long(&v))
      v = random_get_entropy();

And in that way things cascade down nicely per word, depending on
current bus activity. The cascade would get a little bit uglier with
what I suggested above. So we'd need to figure out something there to
make that not hideous or result in awful codegen or something. This is,
no doubt, a snag.

Anyway, If you want to work on a tree-wide cleanup of this, I'd be happy
to consider something like that in the random.git tree for 5.20.
But, alternatively, maybe you think none of the above is really worth it
just to get more per call from the TRNG, and so emphatic "meh" on what
I've described. I can see this perspective well too.

Jason
