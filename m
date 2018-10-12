From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] crypto: streebog - add Streebog hash function
Date: Fri, 12 Oct 2018 14:16:59 +0800
Message-ID: <20181012061659.mextetc3v7urqkzx@gondor.apana.org.au>
References: <20181010121254.12220-1-vt@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vitaly Chikunov <vt@altlinux.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010121254.12220-1-vt@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 10, 2018 at 03:12:50PM +0300, Vitaly Chikunov wrote:
> Add GOST/IETF Streebog hash function (GOST R 34.11-2012, RFC 6986)
> generic hash transformation with appropriate testmgr and tcrypt
> tests and vectors.
> 
> Streebog Hash Function (GOST R 34.11-2012, RFC 6986) is one of the Russian
> cryptographic standard algorithms (called GOST algorithms).
> 
> References:
>   https://tc26.ru/upload/iblock/fed/feddbb4d26b685903faa2ba11aea43f6.pdf
>   https://tools.ietf.org/html/rfc6986
> 
> Tested using testmgr and tcrypt on x86_64, arm, arm64, and s390x on qemu.

We don't add algorithms purely used by user-space.

So please clarify who is going to be using this algorithm *within*
the kernel.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
