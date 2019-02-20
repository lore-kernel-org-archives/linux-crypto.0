Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1903C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 19:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2802147A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 19:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7R3S4RE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfBTTgy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 14:36:54 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:55976 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfBTTgy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 14:36:54 -0500
Received: by mail-it1-f196.google.com with SMTP id z131so18148174itf.5;
        Wed, 20 Feb 2019 11:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ppb/u3SFrXBWgwv2zbu2ul9dkfAm25vx2h3mzviuQGw=;
        b=P7R3S4REPkyG1d2oGDfwI0WAyG7zSZPrnMeZuWEs2nbFg5KvscnkLk1cb/32y7he+q
         saDBPZDelRIBlyNep7tl4x1VoRnM3h2XoG3BaH8i4/QSGy9ypMKLNc3X7nT0Y84iApjj
         cClJzQdH3+ik/VYaGvcFQDkDj/Q5OkVZ7doHAhVziIEymJdJXCyyHCFt7S2zKIydPmlz
         DQHBCgF0mPAqnlDy9lywakKsAMY/TLSvVK4aUjjHRV8uCICmljNbpriMZQ572r9U6zvf
         NPjoWf3Ky8/Kg6C5fevmp0Ovaf1vdHRJPK0G6FKDfdfxrNPCRB+6EKAr2vs9Ph12Zgnt
         bngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ppb/u3SFrXBWgwv2zbu2ul9dkfAm25vx2h3mzviuQGw=;
        b=S7VlfoynUsSX6fXWXoDxlUT/sYR7a7sboEfI4w3ly6jCNM42XAgf0iQSJTvTXXNNV7
         3SQ9dwXShDU+O7xd5zUXUwXMeGhAnzwmPF79RE5tNHtgMgXlhcV/lWbnUtNj+85k63rg
         KOu+vaJ1g1/smojq1HgBFktrJ+6KerL7WZSVso5Zi/HxWinoN10xuFneLqBwZyq+lQR/
         UuMZDrUygPVGL3QmCZx1rjdcglxNQeS2Rk4gor4fMtFwjGsQOdIhVXkElV4N8eP+eitn
         RmXPdRZG5V6GDgwtirU1Bl/3MkMARlOie32U4c/ncr2Hd6LcO052tC15ch1x5QuS9Cbr
         fxBA==
X-Gm-Message-State: AHQUAub11rDb8yVMXqKJYI+XtrIy6jjrDeiUpiKyLbsNJ9qa545cGJ1s
        ZUsdets8ZVLIOTT/eQ5Ii7j9fkQyr2Yb5riSYh7xvw==
X-Google-Smtp-Source: AHgI3IZNp4IYgwgoFpbfT1IIkLWeoKq7RVIDfrOS6rQ8gsEQCeJp5j4cmCzYx8Ma7EJucMQa5PQwP5PxRjlIkub5rjc=
X-Received: by 2002:a24:3a12:: with SMTP id m18mr5843976itm.5.1550691413217;
 Wed, 20 Feb 2019 11:36:53 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
In-Reply-To: <20190220093458.159208-1-weiyongjun1@huawei.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Wed, 20 Feb 2019 14:36:40 -0500
Message-ID: <CAH8yC8nBUUZHUrag9EDVrZ10vpFdiN5zxurdegxLo_u+RAH6AQ@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Sumit Garg <sumit.garg@linaro.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 4:23 AM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> Fixes the following sparse warning:
>
> drivers/char/hw_random/optee-rng.c:265:35: warning:
>  symbol 'optee_rng_id_table' was not declared. Should it be static?

Static limits visibility to the current translation unit. Static is
like private visibility.

Maybe you are thinking if it should be declared extern so other
translation units can find the symbol. extern is like public
visibility.

Jeff
