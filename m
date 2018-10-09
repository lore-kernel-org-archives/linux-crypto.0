From: Vitaly Chikunov <vt@altlinux.org>
Subject: Re: [PATCH 1/2] crypto: streebog - add Streebog hash function
Date: Tue, 9 Oct 2018 09:57:19 +0300
Message-ID: <20181009065719.5cb2lk7fdulfcyvp@sole.flsd.net>
References: <20181007094114.16777-1-vt@altlinux.org>
 <20181007094114.16777-2-vt@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        "Anton V. Boyarshinov" <boyarsh@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181007094114.16777-2-vt@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 07, 2018 at 12:41:10PM +0300, Vitaly Chikunov wrote:
> Add GOST/IETF Streebog hash function (GOST R 34.11-2012, RFC 6986)
> generic hash transformation.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/Kconfig            |   12 +
>  crypto/Makefile           |    1 +
>  crypto/streebog_generic.c | 1142 +++++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/streebog.h |   34 ++
>  4 files changed, 1189 insertions(+)
>  create mode 100644 crypto/streebog_generic.c
>  create mode 100644 include/crypto/streebog.h
> 
> diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
> --- /dev/null
> +++ b/crypto/streebog_generic.c
> @@ -0,0 +1,1142 @@
>> ...
> +static inline void add512(const struct streebog_uint512 *x,
> +			  const struct streebog_uint512 *y,
> +			  struct streebog_uint512 *r)
> +{
> +	u64 carry = 0;
> +	int i;
> +
> +	for (i = 0; i < 8; i++) {
> +		const u64 left = le64_to_cpu(x->qword[i]);
> +		u64 sum;
> +
> +		sum = left + le64_to_cpu(y->qword[i]) + carry;
> +		if (sum != left)
> +			carry = (sum < left);
> +		r->qword[i] = sum;

Last assignment should be: r->qword[i] = cpu_to_le64(sum).
