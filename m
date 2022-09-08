Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5797CC38145
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Sep 2022 09:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiIHJwr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Sep 2022 05:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiIHJw3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2022 05:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221ADED381
        for <linux-crypto@vger.kernel.org>; Thu,  8 Sep 2022 02:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1DD061C3F
        for <linux-crypto@vger.kernel.org>; Thu,  8 Sep 2022 09:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A065C433D7;
        Thu,  8 Sep 2022 09:51:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XdLm58zL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662630714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cktj/OAEWCwgj/vvh4iNz2YlwZYbVmOB51+wg6+J9V4=;
        b=XdLm58zLo5JoVtZ8pdmosd+8lS9fOWT21X/k6HM+un3tp32kVitVboIinNJoJ4XQ5fqMkE
        a29z/pFOkbODZ0J+cFvEixsr/VYQjIOiakYlPGejV/yYBONY/v1tWcR492VPmfuhq3pfzg
        kQPeN9NbKA04sESnGXUOxm+btazaw90=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4d5bdc7a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 8 Sep 2022 09:51:54 +0000 (UTC)
Date:   Thu, 8 Sep 2022 11:51:52 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        zhongguohua <zhongguohua1@huawei.com>
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <Yxm7OKZxT7tXsTgx@zx2c4.com>
References: <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain>
 <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
 <Yt/LPr0uJVheDuuW@zx2c4.com>
 <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com>
 <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
 <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
 <YxiWmiLP11UxyTzs@zx2c4.com>
 <efb1e667-d63a-ddb1-d003-f8ba5d506c29@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <efb1e667-d63a-ddb1-d003-f8ba5d506c29@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Sep 08, 2022 at 11:31:31AM +0800, Guozihua (Scott) wrote:
> For example:
> 
> 
> -- 
> Best
> GUO Zihua
> 
> -- 
> Best
> GUO Zihua

Looks like you forgot to paste the example...

> Thank you for the timely respond and your patient. And sorry for the 
> confusion.
> 
> First of all, what we think is that this change (removing O_NONBLOCK) is 
> reasonable. However, this do cause issue during the test on one of our 
> product which uses O_NONBLOCK flag the way I presented earlier in the 
> Linux 4.4 era. Thus our colleague suggests that returning -EINVAL when 
> this flag is received would be a good way to indicate this change.

No, I don't think it's wise to introduce yet *new* behavior (your
proposed -EINVAL). That would just exacerbate the (mostly) invisible
breakage from the 5.6-era change.

The question now before us is whether to bring back the behavior that
was there pre-5.6, or to keep the behavior that has existed since 5.6.
Accidental regressions like this (I assume it was accidental, at least)
that are unnoticed for so long tend to ossify and become the new
expected behavior. It's been around 2.5 years since 5.6, and this is the
first report of breakage. But the fact that it does break things for you
*is* still significant.

If this was just something you noticed during idle curiosity but doesn't
have a real impact on anything, then I'm inclined to think we shouldn't
go changing the behavior /again/ after 2.5 years. But it sounds like
actually you have a real user space in a product that stopped working
when you tried to upgrade the kernel from 4.4 to one >5.6. If this is
the case, then this sounds truly like a userspace-breaking regression,
which we should fix by restoring the old behavior. Can you confirm this
is the case? And in the meantime, I'll prepare a patch for restoring
that old behavior.

Jason
