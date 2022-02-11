Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47350C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348372AbiBKJJe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:09:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348378AbiBKJJd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:09:33 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38BEC30;
        Fri, 11 Feb 2022 01:09:30 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nIRvY-0003Ts-2e; Fri, 11 Feb 2022 20:09:17 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:09:15 +1100
Date:   Fri, 11 Feb 2022 20:09:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolai Stange <nstange@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Hannes Reinecke <hare@suse.de>, Torsten Duwe <duwe@suse.de>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH v3 11/15] crypto: dh - allow for passing NULL to the
 ffdheXYZ(dh)s' ->set_secret()
Message-ID: <YgYnu8ZzhSnr+OgZ@gondor.apana.org.au>
References: <20220202104012.4193-1-nstange@suse.de>
 <20220202104012.4193-12-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202104012.4193-12-nstange@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 02, 2022 at 11:40:08AM +0100, Nicolai Stange wrote:
> Ephemeral key generation can be requested from any of the ffdheXYZ(dh)
> variants' common ->set_secret() by passing it an (encoded) struct dh
> with the key parameter being unset, i.e. with ->key_size == 0. As the
> whole purpose of the ffdheXYZ(dh) templates is to fill in the group
> parameters as appropriate, they expect ->p and ->g to be unset in any
> input struct dh as well. This means that a user would have to encode an
> all-zeroes struct dh instance via crypto_dh_encode_key() when requesting
> ephemeral key generation from a ffdheXYZ(dh) instance, which is kind of
> pointless.
> 
> Make dh_safe_prime_set_secret() to decode a struct dh from the supplied
> buffer only if the latter is non-NULL and initialize it with all zeroes
> otherwise.
> 
> That is, it is now possible to call
> 
>   crypto_kpp_set_secret(tfm, NULL, 0);
> 
> on any ffdheXYZ(dh) tfm for requesting ephemeral key generation.

Why do we need to support the non-NULL case? IOW what in the kernel
will be using these new templates with a non-NULL parameter?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
