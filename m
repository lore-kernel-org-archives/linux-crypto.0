Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30BDC43603
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 03:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E832073B
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 03:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576207733;
	bh=/hDJVq7RsibwklbuOF/858jCKzciBNwHFxNj4hVkbmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kejprDk6wMrnHdwrkULYcKqVMnvq6hHtMvrAZNLFk3Csdwolr2TaDkOfVu6ccg/Qs
	 /LVSv8NmWky1Sk5PkBF8GPb/7XqdkoyDZYwBCNJMj0OkXFefTPGWJnrQXLkevb/0Ah
	 TkBeevIZd/9GWJ760y9Q0gVcas64dog4iQfUcKzM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfLMD2v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 22:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731631AbfLMD2v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 22:28:51 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83E324656;
        Fri, 13 Dec 2019 03:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576207730;
        bh=/hDJVq7RsibwklbuOF/858jCKzciBNwHFxNj4hVkbmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D6yqxtKuQRnEA/+hludQkuZ526lfGrCa5n6B9AyVmDKyMHNOOKZZa3TvpG2HzUYKI
         ojXcS4LssbOpIhI6WzT4lSskueSZ/944Cidm45l2v4FRAm9ZQEI0NDvwh5ea4WgQj3
         0rKBTLtSHXRKvUXBS0uist1vKQ3zgjbWrrGRj1Ok=
Date:   Thu, 12 Dec 2019 19:28:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
Message-ID: <20191213032849.GC1109@sol.localdomain>
References: <20191211170936.385572-1-Jason@zx2c4.com>
 <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
 <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
 <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
 <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
 <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com>
 <7d30f7c912a5565b1c26729b438c1a95286fcf56.camel@strongswan.org>
 <CAHmME9rP_AAH6=R7ZRPnu3UPTvZ+c32-XYOr2jstSyQvCaQhnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rP_AAH6=R7ZRPnu3UPTvZ+c32-XYOr2jstSyQvCaQhnA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 12, 2019 at 04:35:04PM +0100, Jason A. Donenfeld wrote:
> On Thu, Dec 12, 2019 at 4:30 PM Martin Willi <martin@strongswan.org> wrote:
> > > The principle advantage of this patchset is the 64x64 code
> >
> > If there are platforms / code paths where this code matters, all fine.
> 
> It does matter.
> 
> >
> > But the 64-bit version adds a lot of complexity because of the
> > different state representation and the conversion between these states.
> > I just don't think the gain (?) justifies that added complexity.
> 
> No, there's no conversion between the state representation, or any
> complexity like that added.
> 
> I think if anything, the way this patch works, we wind up with
> something easier to audit and look at. You can examine
> poly1305-donna32.c and poly1305-donna64.c side-by-side and compare
> line-by-line, as clean and isolate implementations. And this is very
> well-known code too.

It's inherently more complex to have multiple alternate implementations, and it
reduces testability because there's no obvious way to even test your 32-bit
version on x86_64 (which most developers use), as it seems your 64-bit version
always gets built instead.

Now, it's possible that the performance gain outweighs this, and I too would
like to have the C implementation of Poly1305 be faster.  So if you'd like to
argue for the performance gain, fine, and if there's a significant performance
gain I don't have an objection.  But I'm not sure why you're at the same time
trying to argue that *adding* an extra implementation somehow makes the code
easier to audit and doesn't add complexity...

- Eric
