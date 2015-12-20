From: Stephan Mueller <smueller@chronox.de>
Subject: Re: WARNING in crypto_wait_for_test
Date: Sun, 20 Dec 2015 22:32:34 +0100
Message-ID: <2207331.ptLrPvxQO5@myon.chronox.de>
References: <CACT4Y+bws9Scv7o3AB2wPM0ZJAeDvO+kZ45h-p5viDk9ZAe9KQ@mail.gmail.com> <20151218084917.GA20345@gondor.apana.org.au> <20151218111657.GA21126@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151218111657.GA21126@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 18. Dezember 2015, 19:16:57 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Dec 18, 2015 at 04:49:17PM +0800, Herbert Xu wrote:
> > OK turns out I was looking at the wrong WARN_ON line.
> > 
> > This particular bug is a legacy of the geniv construct we have
> > for ablkcipher.
> > 
> > It should disappear once we remove geniv which I will do as part
> > of the skcipher conversion.
> 
> This patch should fix the problem.

Yes, it does. Thanks.

Tested-by: <smueller@chronox.de>

-- 
Ciao
Stephan
