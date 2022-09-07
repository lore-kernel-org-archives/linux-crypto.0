Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FFDC38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 13:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiIGNDd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiIGNDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 09:03:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF876C12F
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 06:03:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E90D618DC
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 13:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DA3C433D7;
        Wed,  7 Sep 2022 13:03:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M1Roq5Qj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662555807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7EEFaS3U7NKEZDeQU/Wq1ska++HOrCV8tO2oWqRVnoE=;
        b=M1Roq5QjSSSPe06FdwCktJMG3usP33MKEXiRNIKM0253LAvLRHcLvnU6IdkGGbaC53iF8r
        OXG8adyuafw7rmLJGPv69CUU5fXm/2XEuZkL2rAGqVAwQ06MUifsfQ+IfS4GtxtvUAVz9E
        1ux5NRFicvz6LFd142W1nz6P66LM0W4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e03051b8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 7 Sep 2022 13:03:27 +0000 (UTC)
Date:   Wed, 7 Sep 2022 15:03:22 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        zhongguohua <zhongguohua1@huawei.com>
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <YxiWmiLP11UxyTzs@zx2c4.com>
References: <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain>
 <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
 <Yt/LPr0uJVheDuuW@zx2c4.com>
 <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com>
 <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
 <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 06, 2022 at 12:16:56PM +0200, Jason A. Donenfeld wrote:
> On Thu, Jul 28, 2022 at 10:25 AM Guozihua (Scott) <guozihua@huawei.com> wrote:
> >
> > On 2022/7/26 19:33, Guozihua (Scott) wrote:
> > > On 2022/7/26 19:08, Jason A. Donenfeld wrote:
> > >> Hi,
> > >>
> > >> On Tue, Jul 26, 2022 at 03:43:31PM +0800, Guozihua (Scott) wrote:
> > >>> Thanks for all the comments on this inquiry. Does the community has any
> > >>> channel to publishes changes like these? And will the man pages get
> > >>> updated? If so, are there any time frame?
> > >>
> > >> I was under the impression you were ultimately okay with the status quo.
> > >> Have I misunderstood you?
> > >>
> > >> Thanks,
> > >> Jason
> > >> .
> > >
> > > Hi Jason.
> > >
> > > To clarify, I does not have any issue with this change. I asked here
> > > only because I would like some background knowledge on this flag, to
> > > ensure I am on the same page as the community regarding this flag and
> > > the change. And it seems that I understands it correctly.
> > >
> > > However I do think it's a good idea to update the document soon to avoid
> > > any misunderstanding in the future.
> > >
> >
> > Our colleague suggests that we should inform users clearly about the
> > change on the flag by returning -EINVAL when /dev/random gets this flag
> > during boot process. Otherwise programs might silently block for a long
> > time, causing other issues. Do you think this is a good way to prevent
> > similar issues on this flag?
> 
> I still don't really understand what you want. First you said this was
> a problem and we should reintroduce the old behavior. Then you said no
> big deal and the docs just needed to be updated. Now you're saying
> this is a problem and we should reintroduce the old behavior?
> 
> I'm just a bit lost on where we were in the conversation.
> 
> Also, could you let me know whether this is affecting real things for
> Huawei, or if this is just something you happened to notice but
> doesn't have any practical impact?

Just following up on this again...
