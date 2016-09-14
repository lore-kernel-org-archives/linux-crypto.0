From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH] crypto: squash lines for simple wrapper functions
Date: Wed, 14 Sep 2016 11:10:40 +0900
Message-ID: <CAK7LNAQs2KverOhd2rcG96=fZzsE3M5yfkZJ2ojdTU0Xvunb-Q@mail.gmail.com>
References: <1473708474-32359-1-git-send-email-yamada.masahiro@socionext.com> <1473709457.11006.31.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from conssluserg-04.nifty.com ([210.131.2.83]:57778 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755296AbcINCKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 22:10:46 -0400
In-Reply-To: <1473709457.11006.31.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Joe,

2016-09-13 4:44 GMT+09:00 Joe Perches <joe@perches.com>:
> On Tue, 2016-09-13 at 04:27 +0900, Masahiro Yamada wrote:
>> Remove unneeded variables and assignments.
>
> Was this found by visual inspection or some tool?
>
> If it's via a tool, it's good to mention that in the changelog.


I used Coccinelle, but I did not mention it
in case somebody may say "then, please provide your semantic patch".

As a Coccinelle beginner, I do not want to expose my stupid semantic patch.



-- 
Best Regards
Masahiro Yamada
