From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: WARNING in crypto_wait_for_test
Date: Fri, 18 Dec 2015 16:49:17 +0800
Message-ID: <20151218084917.GA20345@gondor.apana.org.au>
References: <CACT4Y+bws9Scv7o3AB2wPM0ZJAeDvO+kZ45h-p5viDk9ZAe9KQ@mail.gmail.com>
 <6672511.rbcxt2K4Lk@tauon.atsec.com>
 <20151214125219.GA1514@gondor.apana.org.au>
 <3121405.vKidzTde2R@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3121405.vKidzTde2R@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 14, 2015 at 11:45:02PM +0100, Stephan Mueller wrote:
>
> But with the given code, when you remove the bogus mask setting (which in turn 
> leaves it as 0), the code works flawless.

OK turns out I was looking at the wrong WARN_ON line.

This particular bug is a legacy of the geniv construct we have
for ablkcipher.

It should disappear once we remove geniv which I will do as part
of the skcipher conversion.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
