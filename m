Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E912C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 10:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiGUKiH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 06:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiGUKh4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 06:37:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CA082453
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 03:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1887AB8239E
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 10:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C4C3411E;
        Thu, 21 Jul 2022 10:37:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="USSNHXfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658399867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qL6csTschoKuPAKognDOCGUnaIXOClzcoQdsKJanjuU=;
        b=USSNHXfyIgJHU3aJvzWyxikEIh1r5PxuQT8cUEVVwtjX7t5oTzObM4zQVMKCiYIXLemj8/
        vzg6oRkmcxoSZXljLmXHWol7C0gSwms0f0egR5jZMziO2UX3qOdXz5QE1r6YZGIRppyzVp
        akvFs913xejhHmc4mhLnfhUri7AIR9A=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b107dad6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 21 Jul 2022 10:37:47 +0000 (UTC)
Date:   Thu, 21 Jul 2022 12:37:45 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Guozihua (Scott)" <guozihua@huawei.com>,
        linux-crypto@vger.kernel.org, luto@kernel.org, tytso@mit.edu
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <YtksefZvcFiugeC1@zx2c4.com>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ytj3RnGtWqg18bxO@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Guozihua,

On Wed, Jul 20, 2022 at 11:50:46PM -0700, Eric Biggers wrote:
> On Thu, Jul 21, 2022 at 02:44:54PM +0800, Guozihua (Scott) wrote:
> > 
> > Hi Eric
> > 
> > We have a userspace program that starts pretty early in the boot process and
> > it tries to fetch random bits from /dev/random with O_NONBLOCK, if that
> > returns -EAGAIN, it turns to /dev/urandom. Is this a correct handling of
> > -EAGAIN? Or this is not one of the intended use case of O_NONBLOCK?
> 
> That doesn't make any sense; you should just use /dev/urandom unconditionally.

What Eric said: this flow doesn't really make sense. Why not use
/dev/urandom unconditionally or getrandom(GRND_INSECURE)?

But also I have to wonder: you wrote '-EAGAIN' but usually userspace
checks errno==EAGAIN, a positive value. That makes me wonder whether you
wrote your email with your code is open. So I just wanted to triple
check that what you've described is actually what the code is doing,
just in case there's some ambiguity.

I'm just trying to find out what this code is and where it is to assess
whether we change the userspace behavior again, given that this has been
sitting for several years now.

Jason
