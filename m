From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Make several functions static
Date: Thu, 15 Feb 2018 23:52:43 +0800
Message-ID: <20180215155243.GP7352@gondor.apana.org.au>
References: <20180206233642.14591-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206233642.14591-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 06, 2018 at 11:36:42PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Functions qat_rsa_set_n, qat_rsa_set_e and qat_rsa_set_n are local to
> the source and do not need to be in global scope, so make them static.
> 
> Cleans up sparse warnings:
> drivers/crypto/qat/qat_common/qat_asym_algs.c:972:5: warning: symbol
> 'qat_rsa_set_n' was not declared. Should it be static?
> drivers/crypto/qat/qat_common/qat_asym_algs.c:1003:5: warning: symbol
> 'qat_rsa_set_e' was not declared. Should it be static?
> drivers/crypto/qat/qat_common/qat_asym_algs.c:1027:5: warning: symbol
> 'qat_rsa_set_d' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
