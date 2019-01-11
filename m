Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33208 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfAKGb1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:31:27 -0500
Date: Fri, 11 Jan 2019 14:31:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Harsh Jain <harsh@chelsio.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: chtls - remove set but not used variables
 'err, adap, request, hws'
Message-ID: <20190111063112.celuobsvgo6jjius@gondor.apana.org.au>
References: <1545099974-39327-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545099974-39327-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 18, 2018 at 02:26:14AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/chelsio/chtls/chtls_io.c: In function 'csk_wait_memory':
> drivers/crypto/chelsio/chtls/chtls_io.c:925:6: warning:
>  variable 'sndbuf' set but not used [-Wunused-but-set-variable]
> 
> drivers/crypto/chelsio/chtls/chtls_io.c: In function 'chtls_pt_recvmsg':
> drivers/crypto/chelsio/chtls/chtls_io.c:1411:6: warning:
>  variable 'request' set but not used [-Wunused-but-set-variable]
> 
> drivers/crypto/chelsio/chtls/chtls_io.c:1407:18: warning:
>  variable 'adap' set but not used [-Wunused-but-set-variable]
> 
> drivers/crypto/chelsio/chtls/chtls_io.c: In function 'chtls_recvmsg':
> drivers/crypto/chelsio/chtls/chtls_io.c:1701:6: warning:
>  variable 'request' set but not used [-Wunused-but-set-variable]
> 
> drivers/crypto/chelsio/chtls/chtls_io.c:1697:20: warning:
>  variable 'hws' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/chelsio/chtls/chtls_io.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
