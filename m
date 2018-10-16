Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:59238 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbeJQF0P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 01:26:15 -0400
Date: Wed, 17 Oct 2018 00:33:53 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: streebog - add Streebog test vectors
Message-ID: <20181016213353.z2v3kqshhunmb77g@sole.flsd.net>
References: <20181010121254.12220-1-vt@altlinux.org>
 <20181010121254.12220-3-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20181010121254.12220-3-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 10, 2018 at 03:12:52PM +0300, Vitaly Chikunov wrote:
> Add testmgr and tcrypt tests and vectors for Streebog hash function
> from RFC 6986 and GOST R 34.11-2012.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/tcrypt.c  | 27 +++++++++++++++++++++
>  crypto/testmgr.c | 12 ++++++++++
>  crypto/testmgr.h | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 110 insertions(+)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index bdde95e8d369..d66cb167daa2 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1914,6 +1915,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  		ret += tcrypt_test("sm3");
>  		break;
>  
> +	case 53:
> +		ret += tcrypt_test("sb256");
> +		break;
> +
> +	case 54:
> +		ret += tcrypt_test("sb512");
> +		break;
> +

I am requested by Dmitry Eremin-Solenikov off-list to also add
hmac(sb256) and hmac(sb512) tests. I think this is a reasonable request
since IMA have such a mode of use and IMA is planned as one of the main
users of this hash. I may resend v3 with this, or as follow-up PATCH as
maintainers would prefer.

Thanks,
