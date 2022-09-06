Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10229ECAAA1
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 10:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiIFKRQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238753AbiIFKRP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2022 06:17:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFBD2BB14
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 03:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F279B816E9
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 10:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD3BC433B5
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 10:17:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ezp2eceY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662459428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eHVUWtQk9RffrDk2YTOoYnHBvKTAStl/d5Z+VJs6vYI=;
        b=ezp2eceYaZSehIns26h+Mie5sxUAM3eH7dFse+Ik0FOLV8D19StglOJtJTWLXemRNbCbwX
        TnOgn7OoeiK3rjFaVc879zT7z4s64dKzJrLsMSC4ghZo3H7T7WV0HMZiLCeQqkB9NNAiIS
        Tyjj7odfwVxRJy3ducMx5pEJWyRjkeg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 03b9887e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 6 Sep 2022 10:17:08 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-344fc86d87cso77055827b3.3
        for <linux-crypto@vger.kernel.org>; Tue, 06 Sep 2022 03:17:08 -0700 (PDT)
X-Gm-Message-State: ACgBeo1h7NJiG24raoFjQ/8AI+wTfCnKvphbyx+Jaq9KMCkAPesWturx
        a2wLz0j1g7Q8wgrtMEN4sGZPsipnAfasW2cxDbE=
X-Google-Smtp-Source: AA6agR47uTuvRvxAe3J51FFNZabjNnhBzGr+/vNUqI8Ml3ve6wkYd5DJKYyUouiR6r4w85Kvm4XI9QQW2NdijOlfzTo=
X-Received: by 2002:a81:a093:0:b0:345:c52:945c with SMTP id
 x141-20020a81a093000000b003450c52945cmr12335653ywg.341.1662459427131; Tue, 06
 Sep 2022 03:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com> <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain> <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain> <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com> <Yt/LPr0uJVheDuuW@zx2c4.com>
 <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com> <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
In-Reply-To: <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 6 Sep 2022 12:16:56 +0200
X-Gmail-Original-Message-ID: <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
Message-ID: <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        zhongguohua <zhongguohua1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 28, 2022 at 10:25 AM Guozihua (Scott) <guozihua@huawei.com> wrote:
>
> On 2022/7/26 19:33, Guozihua (Scott) wrote:
> > On 2022/7/26 19:08, Jason A. Donenfeld wrote:
> >> Hi,
> >>
> >> On Tue, Jul 26, 2022 at 03:43:31PM +0800, Guozihua (Scott) wrote:
> >>> Thanks for all the comments on this inquiry. Does the community has any
> >>> channel to publishes changes like these? And will the man pages get
> >>> updated? If so, are there any time frame?
> >>
> >> I was under the impression you were ultimately okay with the status quo.
> >> Have I misunderstood you?
> >>
> >> Thanks,
> >> Jason
> >> .
> >
> > Hi Jason.
> >
> > To clarify, I does not have any issue with this change. I asked here
> > only because I would like some background knowledge on this flag, to
> > ensure I am on the same page as the community regarding this flag and
> > the change. And it seems that I understands it correctly.
> >
> > However I do think it's a good idea to update the document soon to avoid
> > any misunderstanding in the future.
> >
>
> Our colleague suggests that we should inform users clearly about the
> change on the flag by returning -EINVAL when /dev/random gets this flag
> during boot process. Otherwise programs might silently block for a long
> time, causing other issues. Do you think this is a good way to prevent
> similar issues on this flag?

I still don't really understand what you want. First you said this was
a problem and we should reintroduce the old behavior. Then you said no
big deal and the docs just needed to be updated. Now you're saying
this is a problem and we should reintroduce the old behavior?

I'm just a bit lost on where we were in the conversation.

Also, could you let me know whether this is affecting real things for
Huawei, or if this is just something you happened to notice but
doesn't have any practical impact?

Jason
