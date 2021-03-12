Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74D2C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDEE65006
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhCLQK7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbhCLQKs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 11:10:48 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DAFC061574;
        Fri, 12 Mar 2021 08:10:48 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id z9so3065181iln.1;
        Fri, 12 Mar 2021 08:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXQjkaEjuHifpRvakzIeYxlUKrS9FGrVnhTBxQmf8dg=;
        b=vKdztFZ36MpUZT4LYThpaaYTBCApts6d4TQ+fh33TrGGiN24oOWs2yE58sSEPonXzD
         8WqaaV1BUvv+3txU8xQkkI61jpPVuAdwQvMF7AF0RWW7+rPHqVegblG0uHQqviqlHBCQ
         su3b0bDRC9kw50MuS7JTr4vKHcBBHKiYYFHcO8JNhA3Ww7OdYDttcdgw+gPP+bsdiFND
         a2QwIVslKktioJbR7Ws3QF72G+Wz/eixVU1PtnCeF59k9YOZUDwFn5uqDuJ86CdH8tqw
         Ou+DIaZHw0SVx2FkxC1PPGnGjMIbLqSFEBtclOXJj4+chpiLCvGdznGITL7VRHAQdApR
         MzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXQjkaEjuHifpRvakzIeYxlUKrS9FGrVnhTBxQmf8dg=;
        b=DJDctupiyR+Hm5NwYUWNj5L7G+YURFO90gX53ip0MsjQIkXUFxR3nj9EQJj0onuVS2
         bc5VrsUPewBzJAd9BH63wa7tsJB8Ry38ieL7hzNpjNSy1kG/6twcuWPnEJwOqNqEJTLw
         7/vcBbm/WsB1qCBlJ/+B19BxlBXq2WdyEI6lJjM+aLGPDlZlSDr1auEAn2STspXlHszh
         jsPBSbgxqcnCWrAb9UnXqM2XS1UwqUJk6qq5Xki10xchwgpWSD2TEykcPCr6U842jbm5
         3o3BSr4EBwhcLbnfiZUMrcclJ9mDurN722+njtNLPqEWRvjgiGGUyHws4F4Z4c3yDMIS
         0lFQ==
X-Gm-Message-State: AOAM533065jWF8702EijF/bsA3HwGbEGCtRifHr5VvjMhpEiBDgSbiab
        i65+GJ4Je8jHE6NjA6Paeo0Z71aYFF55Xzm9gD0cXqhkXGk=
X-Google-Smtp-Source: ABdhPJwJEZ+F7HQ9jRYSNjjsBLuPEYvHCJ3soOjlMIq4UFFJBnX2gl8nWuzx4zJVJiZ7qdS87Meqjpa22xO7lQJDdCk=
X-Received: by 2002:a05:6e02:1baf:: with SMTP id n15mr3436053ili.190.1615565448081;
 Fri, 12 Mar 2021 08:10:48 -0800 (PST)
MIME-Version: 1.0
References: <20210312141908.2388121-1-ztong0001@gmail.com> <20210312141908.2388121-3-ztong0001@gmail.com>
 <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com>
 <CAA5qM4CM4noDtaedPpd0yh8R2f+jDV2DnCERKi_ycD5Lq-vKDw@mail.gmail.com> <CAHp75VcFDXTXcaFqOyRCdArx1bGED_jsEeK1yRQhxUvHp0goTg@mail.gmail.com>
In-Reply-To: <CAHp75VcFDXTXcaFqOyRCdArx1bGED_jsEeK1yRQhxUvHp0goTg@mail.gmail.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Fri, 12 Mar 2021 11:10:37 -0500
Message-ID: <CAA5qM4DPqtPWMydx41Ovx6DCQoEESewkZbQrbhdwfVhkcy0nCA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        qat-linux@intel.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andy,
I am not really sure this reviewed by line should be added by me --
IMHO from my past experience this line is added by the actual person
who reviewed it on a per-patch and version basis
I can send out another revision adding this Reviewed-by line if you
think this is something should be done by me,
but I don't feel I have such power to do this since I am not that guy
and I am not a maintainer.
Thanks,
- Tong
