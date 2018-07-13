From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] AF_ALG: Initialize sg_num_bytes in error code path
Date: Fri, 13 Jul 2018 18:34:10 +0800
Message-ID: <20180713103410.5ox6imgi75w47kpv@gondor.apana.org.au>
References: <00000000000092ad87056950ef9e@google.com>
 <1612449.5GibSviISC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1612449.5GibSviISC@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jul 07, 2018 at 08:41:47PM +0200, Stephan Müller wrote:
> Changes v4:
> * Add Fixes and CC line
> 
> Changes v3:
> * Fix syz testing line
> 
> Changes v2:
> * Addition of syz testing line
> 
> ---8<---
> 
> The RX SGL in processing is already registered with the RX SGL tracking
> list to support proper cleanup. The cleanup code path uses the
> sg_num_bytes variable which must therefore be always initialized, even
> in the error code path.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reported-by: syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com
> #syz test: https://github.com/google/kmsan.git master
> CC: <stable@vger.kernel.org> #4.14
> Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
