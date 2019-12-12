Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559BFC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 13:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11AA621655
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 13:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="3aV9BqcQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfLLNJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 08:09:09 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:33917 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbfLLNJJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 08:09:09 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2009c6b5
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=mXe+fFi68UesrIG9DZLqgKEnDo8=; b=3aV9Bq
        cQPWY/+WZu9I5WZ1dmHu0lK21PlNV/ElcxIWMQPSo59DVS717yS54a2xmM5YzsQ0
        loYt+DWqYBWHBjzz46KbJJu2v5gLwqa8Tw90SbhCCQKLyuvOHfa1NNsMzkbiiRt+
        S3kYUiBL2+fOvJ4ksO945vlU1oXQ6/+IuomKOuLcdGyx/bE6G4p0fnr6BOfJ7yfB
        9IJB+7KjTa1JqtY8ixvMcTSQHRpRuV9NSkYXnTbjvpLjzBmJjm9F0pCdRKNZTauT
        1/cXKiuh1sYotDYrAnhfdzyVp+76NzKm8VAzZn1m8RyhCRQLGrv1oL/pSV6Mts+y
        Py6HLG3QqsZUrB/Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 31c70c87 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 12:13:19 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id b8so354926oiy.5
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 05:09:07 -0800 (PST)
X-Gm-Message-State: APjAAAXBO7HmablKTSM4iHi19U/A6RTB9SDyeGCNU5fYyWCCMzv7VKdi
        4dzGuabWq6eSuZpUM08C+sI8m4CH9SW84KcYIuU=
X-Google-Smtp-Source: APXvYqwjNeN69zrY40sE5oKW8mAfQ0pMJhMPdFoS7Qad01Bgso5Qs5ZN6VfGqlqovCaqDGM6FNQgbuuk+Ty2E7BMyOI=
X-Received: by 2002:aca:5cc1:: with SMTP id q184mr4078014oib.122.1576156146330;
 Thu, 12 Dec 2019 05:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
In-Reply-To: <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 14:08:54 +0100
X-Gmail-Original-Message-ID: <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
Message-ID: <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Martin Willi <martin@strongswan.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Martin,

On Thu, Dec 12, 2019 at 1:03 PM Martin Willi <martin@strongswan.org> wrote:
> Can you provide some numbers to testify that? In my tests, the 32-bit
> version gives me exact the same results.

On 32-bit, if you only call update() once, then the results are the
same. However, as soon as you call it more than once, this new version
has increasing gains. Other than that, they should behave pretty much
identically.

> The 64-bit version is roughly 10% faster. However, what are the
> platforms where the 64-bit version matters? Won't any SIMD version
> outperform the 64-bit version anyway?

Depending on the platform, it's sometimes more than 10% faster. Not
all 64-bit platforms have the luxury of a SIMD version. And not all
code paths wind up hitting the SIMD version, either. The code is very
short and simple -- and compiles shorter than the 32-bit one actually
-- and placed side by side with the new 32-bit one, you can pretty
easily compare them as clean standalone things. I think there's no
good reason for being attached to your old code here; it's all mostly
Andrew's stuff anyway.

Jason
