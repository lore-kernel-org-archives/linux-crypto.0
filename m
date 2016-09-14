From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: squash lines for simple wrapper functions
Date: Tue, 13 Sep 2016 19:29:19 -0700
Message-ID: <1473820159.32273.18.camel@perches.com>
References: <1473708474-32359-1-git-send-email-yamada.masahiro@socionext.com>
         <1473709457.11006.31.camel@perches.com>
         <CAK7LNAQs2KverOhd2rcG96=fZzsE3M5yfkZJ2ojdTU0Xvunb-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK7LNAQs2KverOhd2rcG96=fZzsE3M5yfkZJ2ojdTU0Xvunb-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2016-09-14 at 11:10 +0900, Masahiro Yamada wrote:
> 2016-09-13 4:44 GMT+09:00 Joe Perches <joe@perches.com>:
> > On Tue, 2016-09-13 at 04:27 +0900, Masahiro Yamada wrote:
> > > Remove unneeded variables and assignments.
> > Was this found by visual inspection or some tool?
> > If it's via a tool, it's good to mention that in the changelog.
> I used Coccinelle, but I did not mention it
> in case somebody may say "then, please provide your semantic patch".
> As a Coccinelle beginner, I do not want to expose my stupid semantic patch.

If you get it "exposed", you'd likely learn something from others
that would give a few suggestions/tips on how to improve it.
