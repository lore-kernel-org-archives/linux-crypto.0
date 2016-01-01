From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: af_alg - Disallow bind/setkey/... after accept(2)
Date: Fri, 01 Jan 2016 21:12:40 +0100
Message-ID: <65988221.D1d1cZYMWB@myon.chronox.de>
References: <CACT4Y+Y0k-SuTCVMJOdymwvgEHiM+dSJ3hLOmEb6ZdK=t39gXA@mail.gmail.com> <20151230034753.GA8776@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151230034753.GA8776@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 30. Dezember 2015, 11:47:53 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 29, 2015 at 07:36:14PM +0100, Dmitry Vyukov wrote:
> > Hello,
> > 
> > On commit 8513342170278468bac126640a5d2d12ffbff106
> > + crypto: algif_skcipher - Use new skcipher interface
> > + crypto: algif_skcipher - Require setkey before accept(2)
> > + crypto: af_alg - Disallow bind/setkey/... after accept(2)
> 
> OK there is a silly bug in the last patch.  Here is an updated
> version.

With this patch, the AF_ALG interface stops working. I tested the HMAC 
operation and I am unable to set the key with the following call:

ret = setsockopt(handle->tfmfd, SOL_ALG, ALG_SET_KEY, key, keylen);

This call returns EBUSY.

The test can be performed with [1] using the following call:

test/kcapi -x 3 -c "hmac(sha1)" -k 6e77ebd479da794707bc6cde3694f552ea892dab -p  
31b62a797adbff6b8a358d2b5206e01fee079de8cdfc4695138bba163b4efbf30127343e7fd4fbc696c3d38d8f27f57c024b5056f726ceeb4c31d98e57751ec8cbe8904ee0f9b031ae6a0c55da5e062475b3d7832191d4057643ef5fa446801d59a04693e573a8159cd2416b7bd39c7f0fe63c599365e04d596c05736beaab58

Without the patch, all works.

[1] http://www.chronox.de/libkcapi.html

-- 
Ciao
Stephan
