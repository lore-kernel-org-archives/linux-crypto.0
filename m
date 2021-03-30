Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2A2C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 12:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35199619B1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 12:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhC3MpZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 08:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhC3MpY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 08:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32E9461957;
        Tue, 30 Mar 2021 12:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617108323;
        bh=CeJ4++sMVlMfilqcsFK96eYuyISeLwyu0ENP8ZyXN7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLHylBKg9SAq4TKe8FP5QoVt3kJaqkh88UdeafDlKovJ65J7fW/srg+XhWje0q+Ky
         qgTv38vNtFN6V1KHv9Tli1tfgRkXlQ352IxZzGEToLfF8UA3WbjjAFikZ40FPXrYiR
         G2QkvDht/t9pjuFDGt0h3t0UWvX/8y6FNDI+IBNg=
Date:   Tue, 30 Mar 2021 14:45:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     tanghui20 <tanghui20@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon - check if debugfs opened
Message-ID: <YGMdYZg9b5Gta58V@kroah.com>
References: <1616833980-11006-1-git-send-email-tanghui20@huawei.com>
 <YGCcQnFHXEMW9Jz/@kroah.com>
 <17d627e8-b89a-bbb8-f5d7-11210b859ac7@huawei.com>
 <YGMYKquXSaju9H+A@kroah.com>
 <4b3dc5bb-e6d0-4cfb-c3ca-d3b652879823@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3dc5bb-e6d0-4cfb-c3ca-d3b652879823@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 30, 2021 at 08:40:07PM +0800, tanghui20 wrote:
> 
> 
> On 2021/3/30 20:23, Greg KH wrote:
> > On Tue, Mar 30, 2021 at 08:09:46PM +0800, tanghui20 wrote:
> > > 
> > > 
> > > On 2021/3/28 23:09, Greg KH wrote:
> > > > On Sat, Mar 27, 2021 at 04:33:00PM +0800, Hui Tang wrote:
> > > > > 'xx_debugfs_init' check if debugfs opened.
> > > > > 
> > > > > Signed-off-by: Hui Tang <tanghui20@huawei.com>
> > > > > ---
> > > > >  drivers/crypto/hisilicon/hpre/hpre_main.c | 5 ++++-
> > > > >  drivers/crypto/hisilicon/qm.c             | 3 +++
> > > > >  drivers/crypto/hisilicon/sec2/sec_main.c  | 5 ++++-
> > > > >  drivers/crypto/hisilicon/zip/zip_main.c   | 3 +++
> > > > >  4 files changed, 14 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> > > > > index c7ab06d..f2605c4 100644
> > > > > --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> > > > > +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> > > > > @@ -779,6 +779,9 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
> > > > >  	struct device *dev = &qm->pdev->dev;
> > > > >  	int ret;
> > > > > 
> > > > > +	if (!debugfs_initialized())
> > > > > +		return -ENOENT;
> > > > 
> > > > Why?  What does this help with?  Why does the code care if debugfs is
> > > > running or not?
> > > > 
> > > When !CONFIG_DEBUG_FS, there is no problem if debugfs is not checked,
> > > but if checking debugfs, a series of stub functions of debugfs can be
> > > skipped and 'xx_debugfs_init' will be return immediately.
> > 
> > And have you measured an actual speed difference for that?  I would be
> > amazed if you could...
> > 
> 
> I think what you said makes sense.
> I am confused when to use 'debugfs_initialized'.

Never, you should not care about that at all.

thanks,

greg k-h
