Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82256C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 13:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6300B247FA
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 13:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="jRmT+Bm6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgFUNVl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 09:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbgFUNVk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 09:21:40 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4A9C061796
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 06:21:39 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id j13so8167441vsn.3
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 06:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E6o3KOH9fz6ZsRBmU1LPAQDNXS/xDDfvfrV73KA+oRA=;
        b=jRmT+Bm6DQXuifVEDSs1F7To8oavw5ZUUdm2kxI+tAj4WsSyvWjSdtVyf/cLzCjedX
         sFVHqTcfGRVkVGvfs8I+Xok8NqlDo7PBHwz4Lc+vxRFzwHhstOHkKmVlWFJ+APLMJuUT
         rcx8OK1lXV9LkAnUTlFrNCpjpOPhCUW2pWZGb0ghFKOVtSJmOdvL4CEwy9dfJWLFRQQ/
         1lPkY88OEEw5XOirViRIHahIwVNVJNe1foaBZ3lpVDXuMIaOSmjdO1HdErNDg1HzzP/9
         s49qJhapYt3yKhc3W0dQWcUjFUY4nf6atqK056e+gaJXt12IhPP6X/pZN/9jbRkr1AMW
         cH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E6o3KOH9fz6ZsRBmU1LPAQDNXS/xDDfvfrV73KA+oRA=;
        b=L6zBtyvtMn3huHts5deWIclX93G5Wmwbn9ooue010R9paHek5wFCy0FDc0I33HchQg
         EqpVxSFIjSwH3KXTxdHDQFppolvWKuCD5jans4THYz/RFIrv/fOtI2f8BUT1bI5wSmGi
         CUhgaFb4hhiN5gzMgfTSl3EAZDrKeLhWJk9bnC2+mW+jZDZnTsvfvh1UFR6qeiT0Qhfp
         ENDa+ahofU6BxjnxHCGHrCTDCoJZLWMcsTmmb8z5dM6ik2K7//NorRTbJlDjk8+x7VMn
         NsKHgF8gBTlw1u3EOcoW5+ielkKYuA2je6vqGFKj2H/EHzHqjVPUtiXQIB99JbNVNWQb
         CowA==
X-Gm-Message-State: AOAM5324ggcUGHlbE3yaOkT3t5xBRxB2F51ktd82EOCvLtw+U1MNzEWh
        Awlwh82p/kaMGDBixIL8SiOWqFz2c0orrBNnnq8yk9/0
X-Google-Smtp-Source: ABdhPJzrsAG4vPo4wEgDonzktm6XiQlMwZ3RuajfIUwl9MX5ydA5heJlA/u//rHt2xSwIM0PpK7LUzvWXQnymY0EpOU=
X-Received: by 2002:a67:328a:: with SMTP id y132mr12839041vsy.11.1592745697668;
 Sun, 21 Jun 2020 06:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200621112000.31495-1-gilad@benyossef.com> <20200621112000.31495-2-gilad@benyossef.com>
 <2857f54e-e752-0555-f43a-a451f64f6302@web.de>
In-Reply-To: <2857f54e-e752-0555-f43a-a451f64f6302@web.de>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 21 Jun 2020 16:21:26 +0300
Message-ID: <CAOtvUMcVHfhiY=f0RutGWkQXPiWy_8e4QQ_ytgv5m=h+gg0bqA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] crypto: ccree: fix resource leak on error path
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ofir Drang <ofir.drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 21, 2020 at 4:07 PM Markus Elfring <Markus.Elfring@web.de> wrot=
e:
>
> > Fix a small resource leak on the error path of cipher processing.
>
> I find it more appropriate to resend this patch series with a cover lette=
r
> together with all update steps.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submitting-patches.rst?id=3D64677779e8962c20b580b47179=
0fe42367750599#n785
>
Indeed and I did but for some reason I cannot fathom the cover letter
did not make it to the list.

I will try to resend it now.

Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
