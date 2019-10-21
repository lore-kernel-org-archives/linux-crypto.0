Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6787CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 11:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A1DE206C2
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 11:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ioREJ64l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfJULye (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 07:54:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35046 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfJULye (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 07:54:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id l10so13203139wrb.2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 04:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8znLK64oR6m+WMtoqtJ/qmfu/KEPwEA/nE3GfDxh8hQ=;
        b=ioREJ64lLbLaSBhaRRUg6Dx3bxm+Y/elWE703Zvcj+PURox+9XxDaeh3wSmrKfKft5
         A2NQpYbVnavmgLNg3ZW4Bqc1Tz0UP7k56JSxim2Nbh0ipFgPVBv9tK2CivyLv432Xs30
         2Y5OXvgqYXRri1vu/K2DSv/WDlLGiwctV+9+vbJHIi4+V/p1jShiSopFSrIi0roQO7tr
         +Tn/qV50GjMoIL3g9O3QaMhDO/1zu46DBqhvXVhPIAA/7K6GQ8UeFtVkE9T5RMJZMZl3
         1JsFizrNvMr+EjWodzbvp1MMuX6iS7FjNv6znfN758Vs1hLxC66lw8K6foUbkCe7hPQb
         Y4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8znLK64oR6m+WMtoqtJ/qmfu/KEPwEA/nE3GfDxh8hQ=;
        b=bp8rIecGM7xhb+YEse7Wh+X3qGCQJYtVp/ajDFQfV8OSpKnYdYTdY2RBfqn6tYNd7P
         Iyabzhc9/TG7TinPIr8YOPQsEivCiE8w69bLndTF3wUq1XmlBhN/n6Zj0VykRTe2htPw
         Yti5jTdcI/p8IQ5ZgJZg6JiDu0q/h2tVpUsDkXrY/CVFAB3dl70Yoc1bbsUTJog6v1Ef
         S5aXlqq1xsZjavhh9Y4I+aUijq0wUWgaEPBgyMV4i5w1P0Ht7FZgQTObAOuRL9jKopnP
         st6qNkobYGmy/x2Zvqw1b+Hkw4lKrSEqJI2WA2+pmcNFFhG4RQFoUHBBzeb4P4GYW3aw
         DM1w==
X-Gm-Message-State: APjAAAXHtr1OUnWuTjg1Nh57YqRwa9rAg53ou2LODqZRKNoe7tMCMkWF
        jeb6C+7yKpV5Wo9fo0dkCx1bdxT54theo143r/I2iA==
X-Google-Smtp-Source: APXvYqwKGm96Q9kgL95vWZyCh0BWaRSya1Qi9MLuZo73EyyeGESlijn7Oq6Ry307gmP2VBRy4VIx2foq5meLn9aLd8U=
X-Received: by 2002:adf:f685:: with SMTP id v5mr16516665wrp.246.1571658870855;
 Mon, 21 Oct 2019 04:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
 <20191014121910.7264-5-ard.biesheuvel@linaro.org> <eba53bde-f7ae-cb77-a7c0-98d4e58d6d44@amd.com>
In-Reply-To: <eba53bde-f7ae-cb77-a7c0-98d4e58d6d44@amd.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 13:54:25 +0200
Message-ID: <CAKv+Gu9YzEPsJknDTSF4Hx6-qYTsX=Cms5sX_diOL95M3J0VPQ@mail.gmail.com>
Subject: Re: [PATCH 04/25] crypto: ccp - switch from ablkcipher to skcipher
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Oct 2019 at 16:15, Hook, Gary <Gary.Hook@amd.com> wrote:
>
> On 10/14/19 7:18 AM, Ard Biesheuvel wrote:
> > Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> > dated 20 august 2015 introduced the new skcipher API which is supposed to
> > replace both blkcipher and ablkcipher. While all consumers of the API have
> > been converted long ago, some producers of the ablkcipher remain, forcing
> > us to keep the ablkcipher support routines alive, along with the matching
> > code to expose [a]blkciphers via the skcipher API.
> >
> > So switch this driver to the skcipher API, allowing us to finally drop the
> > blkcipher code in the near future.
> >
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Gary Hook <gary.hook@amd.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Reviewed-by: Gary R Hook <gary.hook@amd.com>
> Tested-by: Gary R Hook <gary.hook@amd.com>
>

Thanks Gary
