Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD66C3524D
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 09:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9262070A
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 09:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgBCJzI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 04:55:08 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:58209 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgBCJzI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 04:55:08 -0500
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MYcy3-1j22n30H0l-00Ve4V; Mon, 03 Feb 2020 10:55:06 +0100
Received: by mail-qt1-f177.google.com with SMTP id v25so10922209qto.7;
        Mon, 03 Feb 2020 01:55:05 -0800 (PST)
X-Gm-Message-State: APjAAAXayw9ab16LOK21AgEd0lxUsYho5mtNcu66Wi0RkBaatjsfQjZJ
        QJ+pGyM0AwC1hJF8xieNXBnvnGjm4/ySOsWfVVA=
X-Google-Smtp-Source: APXvYqy6+v9jhWwlyFzCmvPj6FYnUGsrTB9Nh92b9LW7+F8pu5Zr3Tk51OmqHmojYKDT3Q6CDxzqbjHbal9X0W6ejfg=
X-Received: by 2002:ac8:34b2:: with SMTP id w47mr22353154qtb.142.1580723704779;
 Mon, 03 Feb 2020 01:55:04 -0800 (PST)
MIME-Version: 1.0
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 3 Feb 2020 10:54:48 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3C7hfCQwupKQqtnOmwu7faoeKH9fcEZFQW3WmrScKzUw@mail.gmail.com>
Message-ID: <CAK8P3a3C7hfCQwupKQqtnOmwu7faoeKH9fcEZFQW3WmrScKzUw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] hw_random: introduce Arm CryptoCell TRNG driver
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:2kNRGSn8mD8fztnzDOZ4453fdsXLWQVkYcjEjq19+MXcTDRlRfj
 6RSPW498pqvA7nX0QvVkzWk3sr+bXKJYLoNs0v87JN8Ddt7ttxoezyhxhpApv9GAE7t4Z52
 P+E+sAJLWrSWP9DU+l0oCpBrzlSrYfdrS9jrJZ85W1akTi+QgK6n+bLQx7kttk2hNoYKaB0
 7XFgF38IfZMnKhTXPQvkA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bQNM/1/Sv1U=:WDiBf8dOswSkZBYWYJwh7W
 gSduKWT7O6TkmOG+fNudlBbUEjr3XaYonkGCH6QNqKzFP61KcSu3ibwkrv5yjZr52yz1HLkfK
 b6zZ0BtcZdZC+h920iAIQsvvqrm9NQadFhOZxOStPonyEGbL1XoIlW/yruAkpTMCExmngxbJ7
 OWqC0c1pji+LAaRQPoCzooHW2Uy61EBGzh8KkIysuffI0eX1R6KDzwJOhi32zQf+LikAhUXmK
 BrLFsowxuAwlllqkMRXH05lCfRf0ka/3RtwymwfG9xH4Yv1cGfxPauPhxy7zynrrCHjWJyXdU
 aKMyvh1BVoBz277kZdRGQ9TUqP+LZKKea8vRnQt1W5E8MpdrRBQqLSX/xRjiHQakA+T3F5mqm
 bmOtjNpjDmqEuNwDhSnwTWrvqbtA6+DW5iSSVhATQbOnY68e+tDML5OL/kR+Y3k0p0GrBYk8U
 WAcas9OvZOLDC1oZbL/sld8zlWRIrO0Q7vPze+I+HOxy1OVj4ISJ3Do9c6v5WhQ6Nnm7RMa6u
 KMvYfBh6uYok/iVAuw7/AhSoaF8LSO7T4t+EaS1YX/VWKm1YeL86sRRqg/9C47nB/V0p8NKai
 jNmVDSxoZa3jwPRNlTVfa3L6RYxf+HT984Xpu4krfD5NXD4SVpMPwr3J0LwmcJHWii2WOe3es
 JiL7oOScaO3txbhhXIxx98Q4E+F/SYQZH5Ld4e5EehecJwk8eMCC3ojqixwPJjmcjrvTDUCQb
 Ucr+i6QBdpaqmprBPDsscYxfK6iydjD49heFYXfhGtUeWzz4lh4G43+R2TFdJc+c1ESXPivHl
 TBd1rI7GdfnUFPJslXFUEAIh86eMx68uCqODBn0E75ZEwF6vlY=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 2, 2020 at 2:27 PM Hadar Gat <hadar.gat@arm.com> wrote:
>
> The Arm CryptoCell is a hardware security engine.
> This patch introduces driver for its TRNG (True Random Number Generator)
> engine.
>
> Changes from previous veriosn: fixed 'make dt_bnding_check' errors.
>
> Hadar Gat (3):
>   dt-bindings: add device tree binding for Arm CryptoCell trng engine
>   hw_random: cctrng: introduce Arm CryptoCell driver
>   MAINTAINERS: add HG as cctrng maintainer

I looked at the patches briefly and everything makes sense to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>

There are two style issues that you could improve:

- The header is only included from a single file, so I would just fold
  its contents into the driver itself.

- You have a lot of "#ifdef CONFIG_PM" that are easy to get wrong
  with various combinations of config symbols. It's often better to
  leave that all compiled unconditionally and have the logic in
  UNIVERSAL_DEV_PM_OPS() take care of dropping the unused
  bits, with a __maybe_unused annotation on functions that cause
  a warning otherwise.

       Arnd
