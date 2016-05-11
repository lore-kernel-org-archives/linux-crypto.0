From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [RFC PATCH 5/8] KEYS: Provide software public key query function
 [ver 3]
Date: Wed, 11 May 2016 16:50:05 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605111624090.16566@mjmartin-mac01.local>
References: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk> <20160511142230.4743.12500.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160511142230.4743.12500.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Wed, 11 May 2016, David Howells wrote:

> Provide a query function for the software public key implementation.  This
> permits information about such a key to be obtained using
> query_asymmetric_key() or KEYCTL_PKEY_QUERY.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
> crypto/asymmetric_keys/public_key.c |   96 ++++++++++++++++++++++++++++++-----
> 1 file changed, 82 insertions(+), 14 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 96983906d2a2..e9967e5a2c25 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> +static int software_key_query(const struct kernel_pkey_params *params,
> +			      struct kernel_pkey_query *info)
> +{
...
> +	len = crypto_akcipher_maxsize(tfm);
> +	info->key_size = len * 8;
> +	info->max_data_size = len;
> +	info->max_sig_size = len;
> +	info->max_enc_size = len;
> +	info->max_dec_size = len;

If len > UINT16_MAX, should UINT16_MAX be reported as the max size? 
Similar question for len*8 and key_size.

--
Mat Martineau
Intel OTC

