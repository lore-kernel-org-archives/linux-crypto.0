Return-Path: <SRS0=VxYc=5Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA91C2D0EA
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Apr 2020 09:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 957C42087E
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Apr 2020 09:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgDIJaj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Apr 2020 05:30:39 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:42561 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIJaj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Apr 2020 05:30:39 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mi2eP-1irpap1Lwv-00e4zx; Thu, 09 Apr 2020 11:30:38 +0200
Received: by mail-qt1-f177.google.com with SMTP id 14so2252573qtp.1;
        Thu, 09 Apr 2020 02:30:38 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ2b5Pb7xTzUT4FnAA6YSZFxp7FzTFlMgLv4RorS8vIQCwortg4
        +e/Bb3u+WTEoBCcCAn3EKGODOqRqXJ9WfSXNpgI=
X-Google-Smtp-Source: APiQypLeWInEsRV0WKrdMUsAMwL5UXK2NYRqfW/x4jIjhbwpXqQB+5nF1GJW4mtRdXGTaGysVemV3g16soBD0GqaIYQ=
X-Received: by 2002:aed:3b4c:: with SMTP id q12mr10945684qte.18.1586424637129;
 Thu, 09 Apr 2020 02:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200408162718.4004527-1-arnd@arndb.de> <5E8E7E0D.4090702@hisilicon.com>
In-Reply-To: <5E8E7E0D.4090702@hisilicon.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 9 Apr 2020 11:30:21 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2U-fiDD34kKUVx-KCV3Vq9TtrA6nDkFc1tS_yVnMKa7Q@mail.gmail.com>
Message-ID: <CAK8P3a2U-fiDD34kKUVx-KCV3Vq9TtrA6nDkFc1tS_yVnMKa7Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: hisilicon: add more dependencies
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, Hao Fang <fanghao11@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Mao Wenan <maowenan@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ipoSbm2snF0HZUjDUsz1P2IdKQmaRjdB024Ocb/rGc9PdWCpxSn
 DY5ofMqGhWn+jGdAhTZ2ljzOE0ar/JiP0xOqq8KUNsMtsPOl9f1tZ9narkDRYOS/KxGbKi1
 Xjr1JjikPGZ8C9xc5Qd/+bA7MZRty9Vd1qUGnPmbhuM0NkeAu1oi2ItJauKiN/+Kt2ZJBmV
 Y7hsJfegNEVWvob7OJEsw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3XunXxijaSg=:Nq7s6FrVrWhZ+/i09uiiqn
 2PhFFHbwPb73ARUSRxckjXSCxYNs1rI81Ez2Xylxoath6D79mvPROFjpjXKqMn5gEoiCh34Uj
 10qUoKY40SxfjLOOlp97MYdc9l0+ZHYi0z06LZ/ZDEd+9ICJRqJ0MhxM+tomTWTNHxNmY6ky5
 rSYEKrYo54LrsDo63gDoKcKpFEfrZ79wFTB0b5KmfEzA3/GMG+wpiwVoRGysINlXSbHXczglb
 GL/vg/nESedypEeusS0ME+KHQbGwddFHyMrBsWk0VxyTUoVOVPe24fpncca26qpv47Hd8be0S
 aZlcMXUxMTCdkxhe+3fgLRIwMVyTC7+mGMEE+cfMHCHFRz1HZc9rJVReh2Qe7puh6Q5wi76VS
 wciUBm6FxiHGvpUF5PQkk0QRMYjsSLI8RpYP7K6OHVerAG5KLaPKjDR+sWU9PdoN3SiNnB7GQ
 uU2+KQq0KG6Xf02ULdu0Ch5Erc6YyFyNGcD0kC9TSd8ixlYRsjb2lgAevfvuRHIkEW/5bvhGw
 XJam54XQKxhQawRkP6l3FCeSQjFbS+RQTj+SIOA1zweur/Fed2+5ybHgx84KSNF2GT3h4DbcD
 z2Ei3HaEHw6eXkhItan7trxwpa+8An+5GthYWyCec3mRwW7BDqYKkvZrN24fB7E/oQJPTqYPD
 0RS2Te/caxIz/mrSG5AstQ2KRWJaUqxkM4f0RyfuVrk9mjHg8KgZ3RtL3NtEl7LQhy5tM8NKH
 oab/BN+QQ3cGnewHupi0VB9SYZrc5raElYsOWcRWStmr415+JPBSP505iukXnNuOGGoDQgff4
 epNzbjPXSIfpH23cr7JInrfFI3XxcFzKiysUH7CHybmMEr3AbI=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 9, 2020 at 3:45 AM Zhou Wang <wangzhou1@hisilicon.com> wrote:
>
> On 2020/4/9 0:27, Arnd Bergmann wrote:
> > The added dependencies must be applied recursively to
> > other modules that select CRYPTO_DEV_HISI_QM, to avoid
> > running into the same problem again:
> >
> > WARNING: unmet direct dependencies detected for CRYPTO_DEV_HISI_QM
> >   Depends on [m]: CRYPTO [=y] && CRYPTO_HW [=y] && (ARM64 [=y] || COMPILE_TEST [=y]) && PCI [=y] && PCI_MSI [=y] && (UACCE [=m] || UACCE [=m]=n)
> >   Selected by [y]:
> >   - CRYPTO_DEV_HISI_SEC2 [=y] && CRYPTO [=y] && CRYPTO_HW [=y] && PCI [=y] && PCI_MSI [=y] && (ARM64 [=y] || COMPILE_TEST [=y] && 64BIT [=y])
> >   - CRYPTO_DEV_HISI_HPRE [=y] && CRYPTO [=y] && CRYPTO_HW [=y] && PCI [=y] && PCI_MSI [=y] && (ARM64 [=y] || COMPILE_TEST [=y] && 64BIT [=y])
> > ld: drivers/crypto/hisilicon/qm.o: in function `hisi_qm_uninit': qm.c:(.text+0x23b8): undefined reference to `uacce_remove'
> >
> > Fixes: 47c16b449921 ("crypto: hisilicon - qm depends on UACCE")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
>
> Seems we already have a fix: https://lkml.org/lkml/2020/3/30/173 with your reviewed-by :)

Ah, of course. I even remembered that patch when I saw the problem in mainline,
but for some reason assumed it was yet another instance of the same bug, rather
than a patch that had I was just missing in my tree.

      Arnd
