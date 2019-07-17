Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA25CC76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 10:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C321C21743
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 10:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfGQKN7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 06:13:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43816 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfGQKN7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 06:13:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so16943895qka.10;
        Wed, 17 Jul 2019 03:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ydiSyI4VXzh3zwStu1DezvNmkPT/fY5oXBVsiFA5W2o=;
        b=ausJYawhEzVyfA4gKkINvXh5b6jXesE9jBUu9a8yPFClKPmJNlns2zkvzqoshUpmXV
         HHNF9PBr/Tmierpn5hfmZWjwRpn1YwvDVD5J5zSFJcWvrPr7G40lSogX725HuLMDHtVC
         PL+1BGtkK60G/5eYZZ72xOAFuuVDWNZm/+ZLBamZqqYYwEgCW7DhmKjb3kx8kdA1LHID
         FBnJpyBpIdVLQ8rHFBzCpLeNSi28Kfvdf4IXBHScpkVuoutR7DtfRqle2wKz/rCrfrVh
         DJkICpIbgTzOyKNPmtJ8d+7eZMGwa8xF+/yNSw34gN8+6T2227p1fzXC7798IqjPilRv
         pScQ==
X-Gm-Message-State: APjAAAURfKKcN1U212d335QFzRipxX9F7cT80QSjqtINFC8o9eexju47
        31QI8AJJ3Y2jgwFeqLvEUZth3+L/IW4/Pofmi4Y=
X-Google-Smtp-Source: APXvYqz74sf0zQMwIgSKx0dWLQuwU1Y+rjwpOBcH/2vc6J1LxldCUAQqB70LmnswEuy2Ve9BFykDlWeG3fM4zb5gMwE=
X-Received: by 2002:a05:620a:b:: with SMTP id j11mr25818064qki.352.1563358438144;
 Wed, 17 Jul 2019 03:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190717090438.31522-1-Anson.Huang@nxp.com>
In-Reply-To: <20190717090438.31522-1-Anson.Huang@nxp.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 17 Jul 2019 12:13:41 +0200
Message-ID: <CAK8P3a2nBkxk_qEQm7kT6pQtQXS1GECND_b1d-bEu09A_ttnyw@mail.gmail.com>
Subject: Re: [PATCH 1/2] char: hw_random: imx-rngc: use devm_platform_ioremap_resource()
 to simplify code
To:     Anson Huang <Anson.Huang@nxp.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        gregkh <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Richard Fontana <rfontana@redhat.com>, allison@lohutok.net,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-imx@nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 17, 2019 at 11:14 AM <Anson.Huang@nxp.com> wrote:
>
> From: Anson Huang <Anson.Huang@nxp.com>
>
> Use the new helper devm_platform_ioremap_resource() which wraps the
> platform_get_resource() and devm_ioremap_resource() together, to
> simplify the code.
>
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>

Both patches

Acked-by: Arnd Bergmann <arnd@arndb.de>
