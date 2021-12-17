Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B0BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 05:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhLQFw6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:52:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58062 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhLQFw6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 00:52:58 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1my6AO-0007S3-2k; Fri, 17 Dec 2021 16:52:29 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Dec 2021 16:52:27 +1100
Date:   Fri, 17 Dec 2021 16:52:27 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolai Stange <nstange@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Hannes Reinecke <hare@suse.de>, Torsten Duwe <duwe@suse.de>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, keyrings@vger.kernel.org
Subject: Re: [PATCH v2 03/18] crypto: dh - optimize domain parameter
 serialization for well-known groups
Message-ID: <20211217055227.GA20698@gondor.apana.org.au>
References: <20211209090358.28231-1-nstange@suse.de>
 <20211209090358.28231-4-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209090358.28231-4-nstange@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 09, 2021 at 10:03:43AM +0100, Nicolai Stange wrote:
>> diff --git a/include/crypto/dh.h b/include/crypto/dh.h
> index 67f3f6bca527..f0ed899e2168 100644
> --- a/include/crypto/dh.h
> +++ b/include/crypto/dh.h
> @@ -19,6 +19,11 @@
>   * the KPP API function call of crypto_kpp_set_secret.
>   */
>  
> +/** enum dh_group_id - identify well-known domain parameter sets */
> +enum dh_group_id {
> +	DH_GROUP_ID_UNKNOWN = 0, /* Constants are used in test vectors. */
> +};

We try to avoid hard-coded ID lists like these in the Crypto API.

I've had a look at your subsequent patches and I don't think you
really need this.

For instance, instead of shoehorning this into "dh", you could
instead create new kpp algorithms modpXXXX and ffdheXXXX which
can be templates around the underlying dh algorithm.  Sure this
might involve a copy of the parameters but given the speed of
the algorithms that we're talking about here I don't think it's
really relevant.

That way the underlying drivers don't need to be touched at all.

Yes I do realise that this means the keyrings DH user-space API
cannot be used in FIPS mode, but that is probably a good thing
as users who care about modp/ffdhe shouldn't really have to stuff
the raw vectors into this interface just to access the kernel DH
implementation.

On a side note, are there really keyrings DH users out there in
the wild? If not can we deprecate and remove this interface
completely?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
