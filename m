Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A99C48BE5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 20:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A563061076
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 20:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhFPUwN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Jun 2021 16:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbhFPUwM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jun 2021 16:52:12 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4D9C06175F
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 13:50:06 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so3913961oti.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 13:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0e8lLquy/RoPIexchfl/Dy42UhNJgpKcJRp8OKOo2mw=;
        b=lREE4F/+u3tfPzBJr/PWSAFl0A5hPQXvj5qk3D3NfohfrrusmynYlYzihuvLTf1Ah6
         aAwPfXpzge+KtBAKPenQbhWZzF4JCVeiibIwoCHJYNkC+OQbPbkqGKXvzCn150+lTRX6
         OsuAMohC8wjnFK7rcH9pA6KG+8ss9IRUNaV85BDL05E7Ki0ZAU8nYHoYCdGliC6nCsZW
         PZ9BFkX68xitJHTXA0Jp7HYLLVJmsRxxrywbylFtfd1RcYfjB/LxlfaYfGuqo+1waUy6
         2LBOIu2pf/Y8Gu1DLg8FJPHALESWktoNesF4Sp5gt9X1JZnzpO6hy+WpViYcbTjEzjLy
         VmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0e8lLquy/RoPIexchfl/Dy42UhNJgpKcJRp8OKOo2mw=;
        b=cmGoNoEnbXRCDTYeQDP6okrcUJA77cTu6zX9HGni0v0Z8lfKJ9uD7dTuWI3AbYKVCa
         Cfn0aNYyU5YrUstZ1PF1sfQ95KbgKEHLVXgHopd45EFIW2LRpryZza7Vdi5J3w5Ccqx3
         3kPmCNuz3bZPBNRJIiDMVJjbyuuaKKLBFN4a29xBbYsygEY7gTybLMk+NPhRIWnAS2rm
         H2FZDVxd9ydnSV0JQEUV9XEMe2I75GEM9UJ6uTu7z494cBvxHNBTZ525svrW7i0LTe4D
         YeOzzWWxsVY8jlarEcE80pDfD+E5DkMBphdZC5XK+ITFJ5t73aE5Y89zsc2nC9meRsQz
         /J4A==
X-Gm-Message-State: AOAM531fZ+7YksoeLTeJUTti2Mqm6MCsUa+Mf6TCl2BvCVltYTrQ7lfP
        gB6Zb+tVKch98LmqZJhE9F7LaYwOmXtrTIYqiYDsiQ==
X-Google-Smtp-Source: ABdhPJxlW2IfgGoCEId2VA9mgQdRrEJsE5cGXrU6XetkrHInBTk/URpCE1qYtWk8Tfw45jq9OfaYsqrLxExbzsq1IsA=
X-Received: by 2002:a9d:1b41:: with SMTP id l59mr1541479otl.8.1623876605241;
 Wed, 16 Jun 2021 13:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local> <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com> <20210611062153.GA30906@lst.de>
 <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
In-Reply-To: <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Wed, 16 Jun 2021 13:49:54 -0700
Message-ID: <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb) stable/for-linus-5.12)
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 11, 2021 at 3:35 AM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Fri, Jun 11, 2021 at 08:21:53AM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 10, 2021 at 05:52:07PM +0300, Horia Geant=C4=83 wrote:
> > > I've noticed the failure also in v5.10 and v5.11 stable kernels,
> > > since the patch set has been backported.
> >
> > FYI, there has been a patch on the list that should have fixed this
> > for about a month:
> >
> > https://lore.kernel.org/linux-iommu/20210510091816.GA2084@lst.de/T/#m0d=
0df6490350a08dcc24c9086c8edc165b402d6f
> >
> > but it seems like it never got picked up.
>
> Jianxiong,
> Would you be up for testing this patch on your NVMe rig please? I don't
> forsee a problem.. but just in case
>
I have tested the attached patch and it generates an error when
formatting a disk to xfs format in Rhel 8 environment:

sudo mkfs.xfs -f /dev/nvme0n2
meta-data=3D/dev/nvme0n2           isize=3D512    agcount=3D4, agsize=3D327=
68000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D131072000, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D64000, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
Discarding blocks...Done.
bad magic number
bad magic number
Metadata corruption detected at 0x56211de4c0c8, xfs_sb block 0x0/0x200
libxfs_writebufr: write verifer failed on xfs_sb bno 0x0/0x200
releasing dirty buffer (bulk) to free list!

I applied the patch on commit 06af8679449d.
