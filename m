Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0511C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 22:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiGFWe5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 18:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiGFWe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 18:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB4F17071;
        Wed,  6 Jul 2022 15:34:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78C1DB81F19;
        Wed,  6 Jul 2022 22:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205DAC3411C;
        Wed,  6 Jul 2022 22:34:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J5jWKyqR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657146890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IuVxuJqdylU3gWij8O/TNNT+VdlEevMmcCcayulVOng=;
        b=J5jWKyqRuIR+5+6lP6fAsgea065aj+YhHC34hgIt8CeB5GwNxbGD/EfcqhdBcft4xt+fQc
        5XMtx1NcH/A1u2zq98w5I2HyV9AzShngM4nlbZ1GH7wI0QoL+CRt2TofY9AFYJJyWra7yY
        AkLi4xk7cVLnZA/bFv5lO9KvqgP97tM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 25a43ca3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 6 Jul 2022 22:34:49 +0000 (UTC)
Date:   Thu, 7 Jul 2022 00:34:44 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Message-ID: <YsYOBE3ujfvPzMwo@zx2c4.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com>
 <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
 <7e65130c6e66ce7a9f9eb469eb7e64e0@linux.ibm.com>
 <YsW3qWkIwXboHgim@zx2c4.com>
 <386ec16c-2561-2fcf-2eea-deaab45f349c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <386ec16c-2561-2fcf-2eea-deaab45f349c@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christian,

On Wed, Jul 06, 2022 at 08:29:49PM +0200, Christian Borntraeger wrote:
> >> However, with so few invocations it should not make any harm when there
> >> is a
> >> even very expensive trng() invocation in interrupt context.
> >>
> >> But I think we should check, if this is really something to backport to
> >> the older
> >> kernels where arch_get_random_seed_long() is called really frequency.
> > 
> > I backported the current random.c design to old kernels, so the
> > situation there should be the same as in 5.19-rc5.
> > 
> > So if you feel such rare usage is find even in_hardirq(), then I suppose
> > there's nothing more to do here?
> 
> I think up to 190µs in interrupt can result in unwanted latencies. Yes it does not
> happen that often and it is smaller than most timeslices of hypervisors.
> So I would likely turn that question around
> what happens if we return false if in_hardirq is true? Any noticeable
> delays in code that uses random numbers?

I think I already answered this here with mention of the hwrng driver:
https://lore.kernel.org/all/YsSAn2qXqlFkS5sH@zx2c4.com/

Anyway, I would recommend keeping it available in all contexts, so that
s390 isn't a special case to keep in mind, and because Harald said he
couldn't measure an actual problem existing for real. Plus, it's not as
though we're talking about RT kernels or a problem that would affect RT.
But if you're convinced that even the extremely rare case poses a issue,
doing the !in_hardirq() thing won't be the end of the world either and
is partly mitigated by the hwrng driver mentioned earlier. So I think
it's mostly up to you guys on what the tradeoffs are and what's
realistic and such.

Jason
