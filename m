From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/6] crypto: fixes and cleanups
Date: Mon, 9 Jul 2018 00:46:34 +0800
Message-ID: <20180708164634.x5uubnls2arlrqsv@gondor.apana.org.au>
References: <1530428560-4440-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530428560-4440-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 01, 2018 at 08:02:33AM +0100, Gilad Ben-Yossef wrote:
> The patch set fixes ccree IV handling, finup() operation (provided           
> by Hadar Gat) and CTS-AES mode of operation along a code cleanup.                                             
>                                                                                 
> Since our finup() method was obviously broken but was not detected              
> by testmgr, I've added finup() test to testmgr to catch it next                 
> time it happened.
> 
> Changes from v1:
> - Add missing "static" qualifier reported by kbuild bot
> - Add CTS-AES fix and some more cleanups
> 
> 
> Gilad Ben-Yossef (5):
>   crypto: testmgr: add hash finup tests
>   crypto: ccree: fix iv handling
>   crypto: ccree: remove dead legacy code
>   crypto: ccree: use CBC-CS3 CTS mode
>   crypto: ccree: rate limit debug print
> 
> Hadar Gat (1):
>   crypto: ccree: fix finup
> 
>  crypto/testmgr.c                 |  55 +++++++++++++---
>  drivers/crypto/ccree/cc_cipher.c | 137 +++++++++++++++++++++++++--------------
>  drivers/crypto/ccree/cc_driver.c |   4 +-
>  drivers/crypto/ccree/cc_hash.c   |  81 +++++------------------
>  4 files changed, 153 insertions(+), 124 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
