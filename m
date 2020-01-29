Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9DFC35240
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 09:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E5220708
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 09:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="AB5tIAhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgA2JRe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:17:34 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40097 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgA2JRd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 04:17:33 -0500
Received: by mail-vs1-f67.google.com with SMTP id g23so9963296vsr.7
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jan 2020 01:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bNAC2+oIozcnNbPThp/wFML15nI58BBOU0+BFe2CZdw=;
        b=AB5tIAhPfSaTUA30b2rz5nRhgwFARjT/wGDh/jXm589vlqC83Oc2T6QUmOtSTs4C5U
         ii0gtU5y/tXxYG4+s59v464GcBzW2yVF52O6FaIHNmHPSfvGeolEnZh9s/1doMOx+4ZW
         JApBsw9NjruJop5KT1CwDLLMmh2eBLTMAr9L0IG74JFKCDAOy2tXQchChyx57VDDMZBp
         BCK5Ibw1MbOG2iMXVUyNWT43B9G8aEMkiu0TSmf6O0OpD2fT9ThSeXva5TZzS/5aZ3uM
         Ec6OkU8ADPyWrUvHheawMHJP+tlU84XeAMlDQLZfVQo5B8rtWkrCXiso33tdrfEfrms3
         9skQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bNAC2+oIozcnNbPThp/wFML15nI58BBOU0+BFe2CZdw=;
        b=cUutYZtcmFDgcczxppNuD+/FpWZVuGfWcjrggXlK2dtLhk+ssfBVpg1jVyvvQvKktT
         Fi81CI94LDY/DS5SnDZMrarcfOijn/60WfhssI/XA7HgsxLioj6JPWxHBh9QTp7Kvf4p
         K6J0mjXCfwz8uuw+dfNBQluZe7NuI45ZoOKCrgd3XGu15ReK7LQ1yEGBlEMsUL/bPruJ
         /DMuURxaxSzdMMfNPf3/nidJKXr7I+/oLwSBevi1usUXTJ780Ogs0wqq0yQStbJ4WDff
         mAekY77cx5T0kRu5fOqzLEeRjyk8MEFrQEw+YyZo4XipYfxxETg2A8wlCmnCBVNQP9/r
         ATXA==
X-Gm-Message-State: APjAAAUtnMdtK27pLMVag5t/isJJ/6VlhAGb2nELRocbvPuvqRnEuy06
        nTJfX4iSmltKVakmOjQc5l0hRRMJNVt6F4ODz2VrVg==
X-Google-Smtp-Source: APXvYqyT9AjfuxiZkQLTBthqWh9Qhawn64PCRqSKs9oxee+UzBlV+bTnb4G3Vj19hooUj+iG1WxQj29hKiFWdU6MeZg=
X-Received: by 2002:a67:f683:: with SMTP id n3mr15974310vso.117.1580289452828;
 Wed, 29 Jan 2020 01:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20200128190913.23086-1-geert+renesas@glider.be> <CAOtvUMfoND5iJi7p9YRb6C3To6FGTKGBSoD+cBhkHnLXSppKEw@mail.gmail.com>
In-Reply-To: <CAOtvUMfoND5iJi7p9YRb6C3To6FGTKGBSoD+cBhkHnLXSppKEw@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 29 Jan 2020 11:17:22 +0200
Message-ID: <CAOtvUMdWHPsGMbwkOwoGzAkeD=Vko=gD=wCn02pfEM9pmNWsfw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] crypto: ccree - fix retry handling in cc_send_sync_request()
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 29, 2020 at 11:11 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> On Tue, Jan 28, 2020 at 9:09 PM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> >
> > If cc_queues_status() indicates that the queue is full,
> > cc_send_sync_request() should loop and retry.
> >
> > However, cc_queues_status() returns either 0 (for success), or -ENOSPC
> > (for queue full), while cc_send_sync_request() checks for real errors by
> > comparing with -EAGAIN.  Hence -ENOSPC is always considered a real
> > error, and the code never retries the operation.
> >
> > Fix this by just removing the check, as cc_queues_status() never returns
> > any other error value than -ENOSPC.
>

OK, it took me a minute but I now see what you mean... your patch does
the right thing.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad
