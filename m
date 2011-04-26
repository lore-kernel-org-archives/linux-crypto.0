From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2] crypto: testmgr: add support for aes ofb mode
Date: Tue, 26 Apr 2011 16:38:31 +1000
Message-ID: <20110426063831.GC19539@gondor.apana.org.au>
References: <1303734686-2082-1-git-send-email-puneets@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1303734686-2082-1-git-send-email-puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 25, 2011 at 06:01:26PM +0530, puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org wrote:
>
> +static struct cipher_testvec aes_ofb_dec_tv_template[] = {
> +	 /* From NIST Special Publication 800-38A, Appendix F.5 */
> +	{
> +		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
> +				"\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
> +		.klen	= 16,
> +		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07\x08"
> +				"\x09\x0a\x0b\x0c\x0d\x0e\x0f",
> +		.input	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
> +				"\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
> +			  "\x77\x89\x50\x8d\x16\x91\x8f\x03\xf5"

What's with the indentation changes? Please reformat it so that
everything lines up properly.

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
