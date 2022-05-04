Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B3BC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 09:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346083AbiEDJsV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 05:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbiEDJsV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 05:48:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C786027152;
        Wed,  4 May 2022 02:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A626B817A7;
        Wed,  4 May 2022 09:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08298C385A4;
        Wed,  4 May 2022 09:44:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ESm0TNuT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651657480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k0AKfOp0KFILlr9QrROsIvi4TRs9KZaNQ7cPaY69aZM=;
        b=ESm0TNuTZOwExi98x1XZP4BViZ+x8/cwEWxuLWdR/3JxTAMq1fGCGaHhZQyXvzFaui8U99
        7jC+/SB/zUl6yY/G2KxHug/jsycUJCIFBDRtVb9lHJsUcD2IXaD7b6Of0lU8kxOzUoFFYU
        ikAro6N/jHHTJ8jMoF2gpFlWU2Y/bk8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0e40ddb6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 09:44:40 +0000 (UTC)
Date:   Wed, 4 May 2022 11:44:37 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Stafford Horne <shorne@gmail.com>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] hex2bin: make the function hex_to_bin constant-time
Message-ID: <YnJLBfONnbqZlv6j@zx2c4.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec>
 <YnJI4Ru0AlUgrr9C@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnJI4Ru0AlUgrr9C@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 04, 2022 at 11:42:27AM +0200, Jason A. Donenfeld wrote:
> (which might be semantically better anyway) and then
> let the function itself do the sign change (see below).
 
Actually, probably worse, not better. Didn't realize cu was being used
after the masking.
