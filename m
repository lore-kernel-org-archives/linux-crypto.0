From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_skcipher - Require setkey before accept(2)
Date: Fri, 25 Dec 2015 15:41:12 +0800
Message-ID: <20151225074112.GA14723@gondor.apana.org.au>
References: <201512241831.VN3LufSe%fengguang.wu@intel.com>
 <alpine.DEB.2.02.1512250753010.2084@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1512250753010.2084@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 25, 2015 at 07:54:48AM +0100, Julia Lawall wrote:
> Lines 766, 767 don't look correct at all.

Thanks Julia.  I have sent an updated patch in the original thread.
I wonder why I haven't received the original kbuild test robot
email though.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
