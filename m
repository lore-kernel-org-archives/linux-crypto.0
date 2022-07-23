Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3C8C43334
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jul 2022 22:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGWW7p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jul 2022 18:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGWW7o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jul 2022 18:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7AB175AA
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 15:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D6060A1E
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 22:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A4DC341C0;
        Sat, 23 Jul 2022 22:59:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YlW1jJsB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658617180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rUZ2WYyqHu2YDdmhaM7QXm09xBRQ00xbfJNBP1vbkFs=;
        b=YlW1jJsBz2kWnUnqnJWQo4VClIMCxPICmUC3ONQdJm3CKiVrVFe70a6YNZ8EHJxX5kpDKX
        wF7Ya3uD0qvE/FIQD2kfjrUvUla7qh+K/+KI6jwmBqIqBFTxdVWwkivMe6Vt5pIMB4GfrR
        Vwo8NLhda6uKcX6jq/In5b7/ytKYorM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 89d74c6a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 23 Jul 2022 22:59:40 +0000 (UTC)
Date:   Sun, 24 Jul 2022 00:59:37 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Ytx9WW4Z90lx8MQt@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Cristian,

On Sat, Jul 23, 2022 at 03:04:36PM -0400, Cristian Rodríguez wrote:
> On linux just making this interface call "something" from the VDSO that
> 
> - does not block.
> - cannot ever fail or if it does indeed need to bail out it kills the
> calling thread as last resort.
> 
> (if neither of those can be provided, we are back to square one)
> 
> Will be beyond awesome because it could be usable everywhere,
> including the dynamic linker, malloc or whatever else
> question is..is there any at least experimental patch  with a hope of
> beign accepted available ?

Doesn't getrandom() already basically have this quality? If you call
getrandom(0), it'll block until the RNG is initialized once (which now
happens pretty reliably early on in boot). If you call getrandom(GRND_
INSECURE), it will skip that blocking. Both mechanisms are reliable and
available on all current kernel.org stable kernels.

Is there something about these you don't like and think need fixing? I'm
open to suggestions on how to further improve that interface if it has a
notable shortcoming.

If somebody has a compelling performance case that's widespread and
can't be fixed in the kernel alone, I wouldn't be adverse to vDSOing it.
But such an undertaking would probably be contingent on doing this with
the glibc developers, rather than trying to retroactively bandaid an
addition that shipped broken with a documentation cop-out.

Jason
