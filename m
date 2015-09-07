From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 7 Sep 2015 07:06:22 -0700
Message-ID: <55ED99DE.2000004@intel.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:16958 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbbIGOIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 10:08:00 -0400
In-Reply-To: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andrew,
On 09/05/2015 04:00 PM, Andrew Zaborowski wrote:
> +static int crypto_akcipher_init(struct crypto_tfm *tfm, u32 type, u32 mask)
> +{
> +	return 0;
> +}
> +

This is not needed I think.

> 
> +static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
> +{
> +	struct akcipher_request *child_req = akcipher_request_ctx(req);
> +	int pos;
> +	uint8_t *dst = child_req->dst;
> +
> +	BUG_ON(err == -EOVERFLOW);
> +
> +	if (err)
> +		goto done;
> +
> +	if (dst[0] != 0x00) {
> +		err = -EINVAL;
> +		goto done;
> +	}

This won't work I'm afraid, because MPI strips all leading zeors. 

> +	if (dst[1] != 0x02) {
> +		err = -EINVAL;
> +		goto done;
> +	}
> 
> +static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
> +{
> +	struct akcipher_request *child_req = akcipher_request_ctx(req);
> +	int pos;
> +	uint8_t *dst = child_req->dst;
> +
> +	BUG_ON(err == -EOVERFLOW);
> +
> +	if (err)
> +		goto done;
> +
> +	if (dst[0] != 0x00) {
> +		err = -EINVAL;
> +		goto done;
> +	}

same here the zero will be stripped off.
