Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB070C48BE5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 00:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804B8613B9
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 00:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhFQA3x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhFQA3w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jun 2021 20:29:52 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C08C061574;
        Wed, 16 Jun 2021 17:27:44 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id a15so3349534qtx.13;
        Wed, 16 Jun 2021 17:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KIvX93fO1J/dtkzHBZn8boN5+A8/IK0ceANMVQz1H7w=;
        b=qyWGlEfBCmuW1vkYP1a/17mpWZwFwo2b5T6H+eLhobsEMeZT9UI2+HPorM9Gaxj2TJ
         K+Pmp82x05L9FQvOlDVvPBw8SU6Id7yv/C5zy8Pu/j195dQDGp7mIDjoTA+f+4t9SX8A
         56+ONe+Ce1iadJJrIdcf0xlCKR2r0bFVDuP708nvc7PQL5ioQf7Xl1S0jDNnky2J9cLr
         WN7uqwghTSmqJHcsO9rWBJO7clEh5DG+MocU4I7rnYOowVJkXo8ozuNW1LaG/Mz4b6e9
         ylqKMrlWM2mtHfrykRQND+VsO9m/Xe9moKN42gmu+XTbXxQNOLm0V9FweP67GI93V7jd
         Jw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=KIvX93fO1J/dtkzHBZn8boN5+A8/IK0ceANMVQz1H7w=;
        b=q84JL6lZypDOI74c4l8/o7ZoCVCxqtdoqj23YqP5mppfZ48mwzxshPp6wjukZZF5O5
         TDBvMXkgmZgLv6WVhiD6BJt4BXXc9Wn4Nz8Q9Ub6/D86nCwTmtyC0eHNIK7/i1tVfHCY
         kNrH6Ow3DkoEqAx8WsDJC2ttYE5vqh4G4TNyQiaPTfK+Qa7Wg2lPF3Ipq0aBKUsI4T18
         PJ8mfVyiYfsxbegnBjWqFORxluvOcvthtp5Sq4x9/h7budLHlM4XvKUl6BbQri7Ejl/m
         ywH5MhdJQwMe5cu31njORSv3SRvnrS8kpsDycdWedlTdE9f1/3EF9x+yVTyJJeK5h6ih
         Hp+Q==
X-Gm-Message-State: AOAM530qoc88FGh2UkmrA1QIjcawN7j0Haz/nF9Ypu5ybNRsZXa/gR77
        Z3oqlaRVrYE2r0TlAJTXyB/tjmM8m628HA==
X-Google-Smtp-Source: ABdhPJw3JMIhmiMleh1odDPpGbOyCHN65qWDrIoPtWJ7bPJpDzLoarpEgqHnr4snhp+s2K9Zkc/uIA==
X-Received: by 2002:ac8:7d0c:: with SMTP id g12mr2469507qtb.248.1623889663317;
        Wed, 16 Jun 2021 17:27:43 -0700 (PDT)
Received: from fedora (cpe-24-59-204-221.twcny.res.rr.com. [24.59.204.221])
        by smtp.gmail.com with ESMTPSA id o12sm668710qki.44.2021.06.16.17.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 17:27:42 -0700 (PDT)
Sender: Konrad Rzeszutek Wilk <konrad.r.wilk@gmail.com>
Date:   Wed, 16 Jun 2021 20:27:39 -0400
From:   Konrad Rzeszutek Wilk <konrad@darnok.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
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
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Message-ID: <YMqW+/gQvM+uWUTw@fedora>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
 <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
 <20210611062153.GA30906@lst.de>
 <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
 <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 16, 2021 at 01:49:54PM -0700, Jianxiong Gao wrote:
> On Fri, Jun 11, 2021 at 3:35 AM Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > On Fri, Jun 11, 2021 at 08:21:53AM +0200, Christoph Hellwig wrote:
> > > On Thu, Jun 10, 2021 at 05:52:07PM +0300, Horia Geantă wrote:
> > > > I've noticed the failure also in v5.10 and v5.11 stable kernels,
> > > > since the patch set has been backported.
> > >
> > > FYI, there has been a patch on the list that should have fixed this
> > > for about a month:
> > >
> > > https://lore.kernel.org/linux-iommu/20210510091816.GA2084@lst.de/T/#m0d0df6490350a08dcc24c9086c8edc165b402d6f
> > >
> > > but it seems like it never got picked up.
> >
> > Jianxiong,
> > Would you be up for testing this patch on your NVMe rig please? I don't
> > forsee a problem.. but just in case
> >
> I have tested the attached patch and it generates an error when
> formatting a disk to xfs format in Rhel 8 environment:

Thank you for testing that - and this is a bummer indeed.

Jianxiong,
How unique is this NVMe? Should I be able to reproduce this with any
type or is it specific to Google Cloud?

Dominique, Horia,

Are those crypto devices somehow easily available to test out the
patches?

P.S.
Most unfortunate timing - I am out in rural areas in US with not great
Internet, so won't be able to get fully down to this until Monday.
