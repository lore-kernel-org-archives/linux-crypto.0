From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v2 3/5] crypto: dh - Don't permit 'key' or 'g' size longer
 than 'p'
Date: Mon, 6 Nov 2017 12:29:07 +0200
Message-ID: <7bc602b4-5d78-f587-9620-c15a964630fd@microchip.com>
References: <20171106023048.8067-1-ebiggers3@gmail.com>
 <20171106023048.8067-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Stephan Mueller <smueller@chronox.de>, <qat-linux@intel.com>,
        <keyrings@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        <stable@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:18086 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdKFK3O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 05:29:14 -0500
In-Reply-To: <20171106023048.8067-4-ebiggers3@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 11/06/2017 04:30 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The "qat-dh" DH implementation assumes that 'key' and 'g' can be copied
> into a buffer with size 'p_size'.  However it was never checked that
> that was actually the case, which most likely allowed users to cause a
> buffer underflow via KEYCTL_DH_COMPUTE.
> 
> Fix this by updating crypto_dh_decode_key() to verify this precondition
> for all DH implementations.
> 
> Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> Cc: <stable@vger.kernel.org> # v4.8+

Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   crypto/dh_helper.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
> index 708ae20d2d3c..7f00c771fe8d 100644
> --- a/crypto/dh_helper.c
> +++ b/crypto/dh_helper.c
> @@ -83,6 +83,14 @@ int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
>   	if (secret.len != crypto_dh_key_len(params))
>   		return -EINVAL;
>   
> +	/*
> +	 * Don't permit the buffer for 'key' or 'g' to be larger than 'p', since
> +	 * some drivers assume otherwise.
> +	 */
> +	if (params->key_size > params->p_size ||
> +	    params->g_size > params->p_size)
> +		return -EINVAL;
> +
>   	/* Don't allocate memory. Set pointers to data within
>   	 * the given buffer
>   	 */
> 
