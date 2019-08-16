Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3D0C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CB58206C1
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CsAKE+2X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfHPHCk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 03:02:40 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43277 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfHPHCk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 03:02:40 -0400
Received: by mail-pg1-f173.google.com with SMTP id k3so2465344pgb.10
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 00:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WWDcS1MtmkAPxQpLDIQPln5wnsWSy27rRb70gzCDixU=;
        b=CsAKE+2XFHczapDtYLQMpdAdya4ovVmg0OrT93AWcTGkpueJj+wCuoBVvWt5RDsVSU
         QwmwfNa6KY1Bi5fEbXpval7RHUDW3uk25bnJ67kmEIxZer2R2TtnDhpB7J+QIufgwBAS
         A38mQPWzmYcRMt/MXKvql7Luc6jIdzz4RiL/bhIMJ+aqofuXQxWUob9rdqu2VfejkfHf
         Vo5rmPntxJplKK3Jk69UhpgP92VOfmIMBHno2R+6juzExnOgx5iJCf1B9VYBvMQVeSao
         33tdwoxian/XnA6NcupijgqRyA+HrFOZeDFU9eoOOnriV77v4muRB9hyKfTYiD9Uv1Gx
         9ovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WWDcS1MtmkAPxQpLDIQPln5wnsWSy27rRb70gzCDixU=;
        b=OmgbkthHRpxcNAnva/w46C0Tn+Tct+OBT/xCtIBsoHsvip+fyjsekTJ8MLlGcaI9jd
         WYQRnkjn5JkIiPyF97tWgpYB3UC3y04lPdxAcTEl//CxF0ebyk+JalLa85+Xnwq6WU2n
         G/xhk+uMozOHNH1f6x3EaxKCrX6ME4rrbWW/hKYSZ4tkEnsjOLaqNM8iBPMRBzorlyIs
         2cjhd1rH05AeLgrUkGjNNKVPKuAuZ4mCJmtewdMg7R2L/4drcUzsli6lrmfMP2Yzrsll
         LgAVKimFrVbJnfUNexgYq+dSYlk5WkX9+nqgnlQybgqGUifzb1xjO8+FgPL3iJjnyYb+
         XCmQ==
X-Gm-Message-State: APjAAAWhFF2WJ3HQsOrVQKA9eliRjaJW/Ly5At4UCQLuEPoJPZZW3Ljy
        frDTvY044gr9K2WM36Q0VT1b62WeMr7QVF9Jo6QbrGW5W+U=
X-Google-Smtp-Source: APXvYqyD41u4F+8Y08zOevSgThaIg4PKCYVSPlThvRndRI7n2MnFawGdMgUM9xiTgpChu4alMgS8waCs6FbuR9BSg9o=
X-Received: by 2002:a63:b10f:: with SMTP id r15mr6421028pgf.230.1565938959380;
 Fri, 16 Aug 2019 00:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190815120313.GA29253@gondor.apana.org.au> <5D556981.2080309@hisilicon.com>
 <20190815224207.GA3047@gondor.apana.org.au>
In-Reply-To: <20190815224207.GA3047@gondor.apana.org.au>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Fri, 16 Aug 2019 09:02:27 +0200
Message-ID: <CAAUqJDsvG-c=svGzszE8nCXwjGSYUa9BB1Jj0srY+_rX0X-jyw@mail.gmail.com>
Subject: Re: crypto: hisilicon - Fix warning on printing %p with dma_addr_t
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Zhou Wang <wangzhou1@hisilicon.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

pi 16. 8. 2019 o 1:52 Herbert Xu <herbert@gondor.apana.org.au> nap=C3=ADsal=
(a):
> On Thu, Aug 15, 2019 at 10:17:37PM +0800, Zhou Wang wrote:
> >
> > > -   dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%pad\n", q=
ueue,
> > > -           cmd, dma_addr);
> > > +   dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%#lxad\n",
> > > +           queue, cmd, (unsigned long)dma_addr);
> >
> > Thanks. However, to be honest I can't get why we fix it like this.
> > Can you give me a clue?
>
> dma_addr_t is not a pointer.  It's an integer type and therefore
> you need to print it out as such.

According to Documentation/core-api/printk-formats.rst, %pad is the
format specifier intended specifically for dma_addr_t [1], so perhaps
the kbuild robot warning was in fact bogus?

[1] https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#dma=
-address-types-dma-addr-t

>
> Actually my patch is buggy too, on some architectures it can be
> a long long so we need to cast is such.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
