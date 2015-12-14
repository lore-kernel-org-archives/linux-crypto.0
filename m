From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: WARNING in crypto_wait_for_test
Date: Mon, 14 Dec 2015 20:52:19 +0800
Message-ID: <20151214125219.GA1514@gondor.apana.org.au>
References: <CACT4Y+bws9Scv7o3AB2wPM0ZJAeDvO+kZ45h-p5viDk9ZAe9KQ@mail.gmail.com>
 <6672511.rbcxt2K4Lk@tauon.atsec.com>
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
In-Reply-To: <6672511.rbcxt2K4Lk@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 10, 2015 at 03:14:24AM +0100, Stephan Mueller wrote:
>
> Herbert, alg_bind currently blacklists one bit in the mask and type bit array. 
> Shouldn't we instead white-list the allowed bits?

Well a bogus mask shouldn't lead to the warning anyway.

The warning in question is triggered only if crypto_schedule_test
returns NOTIFY_OK, which can only happen if try_module_get fails,
kzalloc fails, or if kthread_run fails.  All of these would be
real bugs (well except for the kzalloc failure perhaps).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
