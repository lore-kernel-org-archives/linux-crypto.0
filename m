From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 13 Dec 2016 20:53:54 +0530
Message-ID: <CANc+2y5zegViTsPnuWZwWLUwdRk+ac6upaWOjH7iRFL_zEBxGg@mail.gmail.com>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au> <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au> <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au> <20161213141059.GB10647@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        maxime.ripard@free-electrons.com, Chen-Yu Tsai <wens@csie.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:35272 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932277AbcLMPXz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 10:23:55 -0500
In-Reply-To: <20161213141059.GB10647@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> What do you think about those two solutions ?

I prefer the second solution's idea of using two files (/dev/hwrng and
/dev/hwprng). Upon having a quick glance it looks like (based on
current_rng == prng check) that your current implementation allows
only one rng device to be in use at a time. It would be better to have
both usable at the same time. So applications that need pseudo random
data at high speed can use /dev/prng while applications that require
true random number can use /dev/rng. Please feel free to correct if my
understanding of the code is incorrect. Along with this change I think
changing the algif_rng to use this code if this solution is going to
be used.

Regards,
PrasannaKumar
