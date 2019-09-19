Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0210C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADDC22067B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388639AbfISOH7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:07:59 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39944 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387729AbfISOH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 10:07:58 -0400
Received: by mail-qt1-f196.google.com with SMTP id x5so4357890qtr.7;
        Thu, 19 Sep 2019 07:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cxoOCzciOIRUmGCqyjlsgINy4NQTOCEgzeg4ovLh364=;
        b=EmQfLV/lExPB7whTzZ6ypsrApa3MZ20V9toLnApO1hPAkNo77RzQf71M7oZrcXGAhN
         rs0blTAVDE0tw2hSVrRGhC7FtvcMJ0tv57MXufCqIsdiae1WKhKzMqKsZf+teO2Xff7Y
         eH3tELBaBpWXMBXNPSPYCv/svEqNE+hQwB/ucQ+HgkzgsFnFo1Najmn2XlqCvSGgPvdQ
         496qXuLmoIgCCnOlYfxVyMzQOrLqmHwXA4HXTWxOGEcagmM/ngMK0xhRSfEr6Bpb13Ku
         JS4rQjbWWEMFjHEMKN+VpFMkyoKNE0DVedQcqtfy108RF/n2JcY7rJibcvIH0rXVRrbR
         DQsg==
X-Gm-Message-State: APjAAAVjm81ERUPemh6/9ycoGJj3LaDqIkMzOOX16mrT+yHE+eaMHpst
        zIEPsRYXBtHkj6uAL8694Tarapqud6bcmZZreGQ=
X-Google-Smtp-Source: APXvYqxp9XwIdKdieheUSfger0G1a2hQOOM18F3Vp8toqKNPWaEiuqIsjbwq7SYflxqHQsx5t4BctbkPx+KKCeJNscI=
X-Received: by 2002:ac8:342a:: with SMTP id u39mr3343955qtb.7.1568902077622;
 Thu, 19 Sep 2019 07:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190906152250.1450649-1-arnd@arndb.de> <20190906152250.1450649-2-arnd@arndb.de>
 <20190913091718.GA6382@gondor.apana.org.au> <5D833821.5000504@hisilicon.com> <20190919134813.GB29320@gondor.apana.org.au>
In-Reply-To: <20190919134813.GB29320@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 19 Sep 2019 16:07:41 +0200
Message-ID: <CAK8P3a0gw0rZ-gfeh+VWL3t2qmj=a3aVV0s12tGw92fbUcfpxQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: hisilicon - avoid unused function warning
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 19, 2019 at 3:48 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 19, 2019 at 04:11:13PM +0800, Zhou Wang wrote:
> > On 2019/9/13 17:17, Herbert Xu wrote:
> > > On Fri, Sep 06, 2019 at 05:22:30PM +0200, Arnd Bergmann wrote:
> > >> The only caller of hisi_zip_vf_q_assign() is hidden in an #ifdef,
> > >> so the function causes a warning when CONFIG_PCI_IOV is disabled:
> > >>
> > >> drivers/crypto/hisilicon/zip/zip_main.c:740:12: error: unused function 'hisi_zip_vf_q_assign' [-Werror,-Wunused-function]
> > >>
> > >> Move it into the same #ifdef.
> > >>
> > >> Fixes: 79e09f30eeba ("crypto: hisilicon - add SRIOV support for ZIP")
> > >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > >> ---
> > >>  drivers/crypto/hisilicon/zip/zip_main.c | 2 ++
> > >>  1 file changed, 2 insertions(+)
> > >
> > > Please find a way to fix this warning without reducing compiler
> > > coverage.  I prefer to see any compile issues immediately rather
> > > than through automated build testing.
> > >
> > > Thanks,
> > >
> >
> > Sorry for missing this patch.
> >
> > Seems other drivers also do like using #ifdef. Do you mean something like this:
> > #ifdef CONFIG_PCI_IOV
> > sriov_enable()
> > ...
> > #else
> > /* stub */
> > sriov_enable()
> > ...
> > #endif
>
> For an unused warning the unused compiler attribute would seem
> to be the way to go.

I sent an update patch now that also removes the first #ifdef, plus one
that enables compile-testing on x86 (with some caveats).

      Arnd
