Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24D0C43461
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 06:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED0021548
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 06:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2AjldAb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgINGiz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 02:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgINGiy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 02:38:54 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC35C06174A;
        Sun, 13 Sep 2020 23:38:53 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n133so15817827qkn.11;
        Sun, 13 Sep 2020 23:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4gDxIARdylysVEZqTCPJWfRAzP3d+r4GIZBwVlajYqQ=;
        b=c2AjldAbbnko1Fwc5/p4sm1tij8/BLM3tEiwvjoxL6Eawm2T8a21XZRvwLqBzilA/A
         d+FbK6SwwXNH3RvqkxUwP8Pv60FaJGgDhtj0Nw1wx5L+zydY72rbspDIBxGjO6k2NsdY
         HRQeiym9RaIxDCYi/s/ot3WIFxC56iei7Q1VYnPFplI6/qJs9xKOwWGLnISei9mBEbc0
         yXYBPa0OzrPFxKtS9h2OxcZnOyCc9IlqBGyVP+83DxUJxwUNOvOQffR8Qml/JAGW/yKF
         mvybDVx3IlrDK6NRSWA/EuE/uauatMs/w/5sbG10cvPsh5302DWwyOCN0qA8OmVUWb3L
         WGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4gDxIARdylysVEZqTCPJWfRAzP3d+r4GIZBwVlajYqQ=;
        b=bBqObxUhAKAb89VhPp9PtRHpltEqrFKvqphj5MN97EgCML4XuezRRgiBA+S531nrK5
         1giIoQqfaQZfS9fYrm52rD1zQALTahcZd/LTL81OWbcSBGTv8LBezM36ZW0tV1HFPM5N
         eNC7JQoKQ05U0G4Kxhq7zUKDbcQsccv+5yoqlf8POeMOS0j8PW6W8AzahBqdtrlsIN1K
         FsdsPN9RtpTa136STCVwR3LeTBS2DBNnw4Nt1R7cWpHmO9nRtEaysIXncjLRWo4uZgMs
         FV2RECldx8PxW9FI+QUht5jyqX5DN2BWe1wDrmjq5q/VzXrNcn/le1Kj5GYOLYCOmVy5
         IqzQ==
X-Gm-Message-State: AOAM530QeeuLIqrOtfpiSWyXblFtcBzmWTotzJQ/926zSMBIbadGB7zD
        sgu5iZix4yOnlZP5GoIVthYinkdZIFq2or7EG7gMRbNF
X-Google-Smtp-Source: ABdhPJxT930fcsuZMuPCqnCPR/H830Q4Pt6/guLtXNwFoZz/9J7K2V/7vf8LESMSjmzmpyRU3Da1V4zD9H0lQViXEfs=
X-Received: by 2002:a05:620a:78b:: with SMTP id 11mr11651462qka.370.1600065528579;
 Sun, 13 Sep 2020 23:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com> <CAFLxGvy0T-E-YecWbGZsDVPajuYVc8L-Uf8UCST_61+t+nfhrA@mail.gmail.com>
In-Reply-To: <CAFLxGvy0T-E-YecWbGZsDVPajuYVc8L-Uf8UCST_61+t+nfhrA@mail.gmail.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Mon, 14 Sep 2020 08:38:37 +0200
Message-ID: <CAFLxGvw4zvL0N5+wChKq3=_xLuuCYLKDOyKKnKFy3UiWMUwf-g@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>, David Gstir <david@sigma-star.at>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 16, 2020 at 4:12 PM Richard Weinberger
<richard.weinberger@gmail.com> wrote:
>
> On Mon, Jul 13, 2020 at 12:09 AM Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
> >
> > Tagged keys are keys that contain metadata indicating what
> > they are and how to handle them using tag_object API.
> >
> > Add support, for tagged keys, to skcipher algorithms by
> > adding new transformations, with _tk_ prefix to distinguish
> > between plaintext and tagged keys.
> >
> > For job descriptors a new option (key_cmd_opt) was added for KEY command.
> > Tagged keys can be loaded using only a KEY command with ENC=1
> > and the proper setting of the EKT bit. The EKT bit in the
> > KEY command indicates which encryption algorithm (AES-ECB or
> > AES-CCM) should be used to decrypt the key. These options will be kept in
> > key_cmd_opt.
> >
> > The tk_ transformations can be used directly by their name:
> > struct sockaddr_alg sa = {
> >     .salg_family = AF_ALG,
> >     .salg_type = "skcipher", /* this selects the symmetric cipher */
> >     .salg_name = "tk(cbc(aes))" /* this is the cipher name */
> > };
> > or for dm-crypt, e.g. using dmsetup:
> > dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/mmcblk2p10)
> > crypt capi:tk(cbc(aes))-plain :32:logon:seckey 0 /dev/mmcblk2p10 0 1
> > sector_size:512".
>
> How to use it with cryptsetup?
> I'm asking because it is not clear to me why you are not implementing
> a new kernel key type (KEYS subsystem)
> to utilize tagged keys.
> Many tools already support the keyctl userspace interface (cryptsetup,
> fscrypt, ...).

*friendly ping*

-- 
Thanks,
//richard
