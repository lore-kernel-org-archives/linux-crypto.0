From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 1/6] SP800-90A Deterministic Random Bit Generator
Date: Fri, 11 Apr 2014 11:20:21 -0700
Message-ID: <1397240421.7113.39.camel@joe-AO722>
References: <2396177.vxvG2ljJL8@myon.chronox.de>
	 <3662681.npTzbSq3ye@myon.chronox.de> <1952806.u8ySj6rIyr@myon.chronox.de>
	 <3972168.arX3qfUzsN@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3972168.arX3qfUzsN@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2014-04-11 at 20:07 +0200, Stephan Mueller wrote:
> Changes v4:
>  * change return codes of generate functions to signed int to convey error
>    codes and to match the kernel crypto API expecations on the generate
>    function.
>  * add BUG_ON throughout drbg_healthcheck_sanity() since any failure should
>    should be caugth to prevent the DRBG from operating
>  * change layout of debugging printk

It looks like const could be used a bit more often.

For instance:
perhaps uses of key could be changed to const unsigned char *key

> diff --git a/crypto/drbg.c b/crypto/drbg.c
[]
> +#ifdef CONFIG_CRYPTO_DRBG_CTR
> +static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *key,
> +			  unsigned char *outval, struct drbg_string *in);
[]
> +/* BCC function for CTR DRBG as defined in 10.4.3 */
> +static int drbg_ctr_bcc(struct drbg_state *drbg,
> +			unsigned char *out, unsigned char *key,
> +			struct drbg_string *in)
[]
> +/* Derivation Function for CTR DRBG as defined in 10.4.2 */
> +static int drbg_ctr_df(struct drbg_state *drbg,
> +		       unsigned char *df_data, size_t bytes_to_return,
> +		       struct drbg_string *addtl)
> +{
[]
> +	unsigned char *K = (unsigned char *)
> +			   "\x00\x01\x02\x03\x04\x05\x06\x07"
> +			   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +			   "\x10\x11\x12\x13\x14\x15\x16\x17"
> +			   "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";
