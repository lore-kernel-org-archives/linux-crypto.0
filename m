From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/5] build warnings cleanup
Date: Thu, 31 May 2018 00:28:43 +0800
Message-ID: <20180530162843.urnovifr6hkg52zz@gondor.apana.org.au>
References: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, gustavo@embeddedor.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        davem@davemloft.net
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, May 27, 2018 at 09:15:17PM +0530, Atul Gupta wrote:
> Build warnings cleanup reported for
> - using only 128b key
> - wait for buffer in sendmsg/sendpage
> - check for null before using skb
> - free rspq_skb_cache in error path
> - indentation
> 
> v2:
>   Added bug report description for 0002
>   Incorported comments from Dan Carpenter
> 
> Atul Gupta (5):
>   crypto:chtls: key len correction
>   crypto: chtls: wait for memory sendmsg, sendpage
>   crypto: chtls: dereference null variable
>   crypto: chtls: kbuild warnings
>   crypto: chtls: free beyond end rspq_skb_cache
> 
>  drivers/crypto/chelsio/chtls/chtls.h      |   1 +
>  drivers/crypto/chelsio/chtls/chtls_hw.c   |   6 +-
>  drivers/crypto/chelsio/chtls/chtls_io.c   | 104 +++++++++++++++++++++++++++---
>  drivers/crypto/chelsio/chtls/chtls_main.c |   3 +-
>  4 files changed, 98 insertions(+), 16 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
