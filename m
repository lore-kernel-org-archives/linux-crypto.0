From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in crypto_aead_free_instance
Date: Wed, 20 Dec 2017 12:49:47 +0100
Message-ID: <12415329.MInO136rYd@tauon.chronox.de>
References: <001a11c14bc887c2c60560c0cdda@google.com> <18467907.EfXNf1iGip@tauon.chronox.de> <CACT4Y+bg6GjHbLpSkB6joS_dgu3ZYH=mJXHJ8AnuWiPVokhBdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+e5e6fab2d4dc3d9877ac240fed364027bb960ad0@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44474 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754692AbdLTLtu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 06:49:50 -0500
In-Reply-To: <CACT4Y+bg6GjHbLpSkB6joS_dgu3ZYH=mJXHJ8AnuWiPVokhBdA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 20. Dezember 2017, 11:15:38 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> 
> What will be its meaning? How will it differ from fix?

Maybe a short clarification would help: what is the meaning of the syz fix 
marker? Depending on this answer, all that I am thinking of is to mark bug 
reports for which there are fixes actively discussed, but yet not integrated. 
Thus, such marker should only help others to point them to active discussions 
instead of them trying to find fixes alone.

Ciao
Stephan
