From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v2 3/3] crypto: scompress - defer allocation of scratch
 buffer to first use
Date: Wed, 26 Jul 2017 00:36:53 +0100
Message-ID: <20170725233653.GB28789@silv-upstream1.ir.intel.com>
References: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
 <20170721154238.21697-4-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:16380 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdGYXhM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 19:37:12 -0400
Content-Disposition: inline
In-Reply-To: <20170721154238.21697-4-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ard,

On Fri, Jul 21, 2017 at 04:42:38PM +0100, Ard Biesheuvel wrote:
> +static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
> +{
> +	int ret;
> +
> +	mutex_lock(&scomp_lock);
> +	ret = crypto_scomp_alloc_all_scratches();
> +	mutex_unlock(&scomp_lock);
> +
> +	return ret;
> +}
If you allocate the scratch buffers at init_tfm, don't you end
up with a situation where if you allocate two tfms of the same algo
then you get twice the number of scratches?
If that is the case, we should implement a reference count
mechanism.
Am I missing something?

Regards,

-- 
Giovanni
