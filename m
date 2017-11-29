From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Wed, 29 Nov 2017 08:17:25 +0100
Message-ID: <2948680.ShXD61QQGe@tauon.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <2865588.MNjhcg78tp@tauon.chronox.de> <20171129071049.GA23023@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42618 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbdK2HR3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 02:17:29 -0500
In-Reply-To: <20171129071049.GA23023@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 29. November 2017, 08:10:49 CET schrieb Herbert Xu:

Hi Herbert,

> 
> But anyway this isn't suitable for stable where we should just fix
> it by making it not crash.

I will send a patch right away moving the wait out.

Later on I will elaborate on your suggestion to move the context-specific 
information on a list.

Ciao
Stephan
