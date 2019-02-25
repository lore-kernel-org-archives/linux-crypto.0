Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C405C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 07:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C311B20842
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 07:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="McjGvKrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfBYHvF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 02:51:05 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38919 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfBYHvF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 02:51:05 -0500
Received: by mail-ot1-f65.google.com with SMTP id n8so7044652otl.6
        for <linux-crypto@vger.kernel.org>; Sun, 24 Feb 2019 23:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uob8Od0nIATs4DQMsc55yK+ZS2pObQ2v45InsKOuig0=;
        b=McjGvKrMoGmPul42PUDjrajt+HU4QhgaTQYft1Ebw0f7pIynV1F0Hospiw+6B0O6lF
         ljeTjhKwIg7nJJ+fCaFvYAlhp17miKj66WGopUj283sSkGGcYsnbNwoEYQzM8HRmRjwn
         29hxLA6Cz3FCPGk647kaj65EVSp1rFos3PtWvl7bQanuewOBDUMFVLrs9uHjBt19IVn1
         9pYaiIxiQUJbFFzkc8Lidjo472BEz9Msr6Rn9jROYA79roCpxXFeDe3kJJs5lVMsB52h
         9FkaqW9Td9CwEBWbuXP7bdkX3YiwJa2Wqomp4NLyXer9SdxIHgcw4jCRqpWRQf4JbYto
         f1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uob8Od0nIATs4DQMsc55yK+ZS2pObQ2v45InsKOuig0=;
        b=A+mJtcfML3aDdsJhgEOoxZ0CBjFBhjQXBZIOvtJWI82Gooiwq5/spZeBklAQ/VHvS8
         SLJf/8t5aPk6y+1p9hIJJRj9GAGhC1eGUcSnP1WGYh23oGGi9XThSZZRYhFTfRUwhdWX
         N5Qp53C8FWy8XzxDd4nMho9PMxhcrOLQVvHdWTDcMA7n0YMN9xkuBzhgI1oKXi/fZDob
         0J7lAQMHCNJ4xCytO4nRgiwRiQWI/49lhv+y1sO5MH/NUlnC67zXUsVtqH3zy4Deuaf0
         oD40YKqpzDi//n/tIEXaQnx+/ZvnW6BZl5nWQON+HkH06asmFXQxbsduiIAcsve0Q0Ne
         wi4g==
X-Gm-Message-State: AHQUAua2BW/3CZiZPZLe3UQWVUBSQNgyX2iPTwIN0tR2XxJqvFQ2TXa6
        R7vKjpvW5qk61E8xV5bVINIGneJTu8vk4ak9lIQ=
X-Google-Smtp-Source: AHgI3IYZIOqxjkNRWmZJZ74WblchnYMYjQln7nPMYqtHy/egustnIYHEha1kBPeT+UHdOV8La6M/ZqWOuL5Pz15LXuk=
X-Received: by 2002:a9d:5889:: with SMTP id x9mr10535776otg.109.1551081064426;
 Sun, 24 Feb 2019 23:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk> <20190222100613.2290-2-christopher.spencer@sea.co.uk>
In-Reply-To: <20190222100613.2290-2-christopher.spencer@sea.co.uk>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Mon, 25 Feb 2019 07:50:53 +0000
Message-ID: <CAGUNXRSKXZdw_M-4RCyckVS_-MxfWe+H6Cw+kPU6=DorxZWmTg@mail.gmail.com>
Subject: Re: [RFC 1/4] crypto: caam - fix detection of i.MX8 SoC
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     linux-crypto@vger.kernel.org,
        Chris Spencer <christopher.spencer@sea.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 22 Feb 2019 at 10:07, <spencercw@gmail.com> wrote:
> From: Chris Spencer <christopher.spencer@sea.co.uk>
>
> The i.MX8 does not currently have an SoC driver so soc_device_match does
> not recognise it. Check the machine compatible instead.
>
> Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>

Turns out there is already an outstanding patch to add the SoC driver
[1], so I will drop this one from the next version.

Chris

[1] https://lore.kernel.org/patchwork/patch/1038272/
