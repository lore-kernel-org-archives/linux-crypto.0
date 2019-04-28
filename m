Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E197C43218
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 07:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131A720881
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 07:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="JZ7uyOa7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfD1HL5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 03:11:57 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42418 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfD1HL5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 03:11:57 -0400
Received: by mail-vs1-f66.google.com with SMTP id b74so1085477vsd.9
        for <linux-crypto@vger.kernel.org>; Sun, 28 Apr 2019 00:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0/S6B6NWgBdbisjBXWpRt6zfXJMqlxYauy0OrhI+WGI=;
        b=JZ7uyOa7qj8XncuBu2COdGhfC4Yv3Mnc3/GPLsqtGxe1PdKdB4wRy8YLQdvN1V1SRM
         88l/dqEearUqRDRfsN4c2z7uR9wwhlgGzssINQSME7c0ZhDm9khr/gSKNDnU3llmGZCK
         Q7vBHD/VBO5vq4IXDnPCtlOYuGuVmGqZhXCrGgIpc9l6ov/r9ztZrziXyKcUEoejao21
         eC3QS5zgykOPh7UcmFw3imiHWW7qXfnhbgZYxMCiHx+oHIVKQ9cyA1iHLyBpBsoKoRLZ
         tsaojAzUozJ4FugbHm8/X1uqyS8vPxR5EATRsYdvLg9hoUuC9O6m14FKBwCDtLh5rZEH
         FWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0/S6B6NWgBdbisjBXWpRt6zfXJMqlxYauy0OrhI+WGI=;
        b=VkOja0Y/C/KdLLOdbkzlJMziIsYo4NkNpxFT25FDoodz4fP/GJLkDm5YF6dqSRS/Yi
         bHcKmSdKboIPRAy2XmK7TdamLNhT9inFPb7mvCqnitJQ7X6c2EWH+Z9sEKptVV1u7OzW
         8OCBLrLNpnaIB5ENvtv17HG6T6f9TVl247wmF6VbLGT26WjlRLixZUl909G4SOEWQpnh
         CungZDAnrfXOlmITTAQv+TK5fFifiXd6LUYQlCgggqxrJdBlKbpX8MycoHIGw8CD7XDD
         ZU6QfwYSeH4FAgT1AiWyF2BgXvxkkuY3jc3NNkJ1gkwnb8FYqAAu6BW2bLgcImayuXaq
         1b8A==
X-Gm-Message-State: APjAAAXn1+uWCmAXQi6zQU45vbUqJPmzzrXImnb/gp4FR63ACe/NcY9A
        d6nc/XjSld2jDqN/Kr0+C+gopP+8AJKIzVKLpLF44qPhdlY=
X-Google-Smtp-Source: APXvYqzO1gESEeXWppboA4chvYTcglgRF5LNuAbKekOMh6nWsT4upCekcBujfd2WDRfxftVcxeeW73pXSGj66el3zns=
X-Received: by 2002:a67:6f07:: with SMTP id k7mr3886602vsc.117.1556435516192;
 Sun, 28 Apr 2019 00:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190426131835.27258-1-colin.king@canonical.com>
In-Reply-To: <20190426131835.27258-1-colin.king@canonical.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 28 Apr 2019 10:11:44 +0300
Message-ID: <CAOtvUMdHx4SK6CceCxfHOXic=bymA13HZMviuto98GysDwasMw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree: fix spelling mistake "protedcted" -> "protected"
To:     Colin King <colin.king@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 26, 2019 at 4:18 PM Colin King <colin.king@canonical.com> wrote=
:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a dev_dbg message, fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-By: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks!

Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
