From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 2.6.37
Date: Wed, 15 Dec 2010 12:40:48 -0800
Message-ID: <AANLkTikM4vQe7dsN8JJ1QSLeeTbRpSnuoJU=e4H2YFoz@mail.gmail.com>
References: <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au>
 <20100201195204.GA6953@gondor.apana.org.au> <20100305071043.GA3548@gondor.apana.org.au>
 <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au>
 <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101215115035.GA25248@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 15, 2010 at 3:50 AM, Herbert Xu
<herbert@gondor.hengli.com.au> wrote:
>
> This push fixes a build problem under certain configurations due
> to a missing include.
>
> Please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

You have a bad repo. Git says:

  fatal: loose object 52f6c5ad430e41736133acac179607b224eaaa11 (stored
in ./objects/52/f6c5ad430e41736133acac179607b224eaaa11) is corrupted

and it doesn't really seem to be corrupt as much as just unreadable
(ie you've made it readable only by yourself).

There's a few other objects like that too. How do you push to your
repo, and what changed?

                              Linus
