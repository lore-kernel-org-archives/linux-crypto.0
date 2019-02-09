Return-Path: <SRS0=cN3k=QQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C5DC282C4
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Feb 2019 21:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0094121919
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Feb 2019 21:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfBIVmp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Feb 2019 16:42:45 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:39330 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbfBIVmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Feb 2019 16:42:44 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 05C3972CC53;
        Sun, 10 Feb 2019 00:42:41 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id D6CEF4A4A14;
        Sun, 10 Feb 2019 00:42:40 +0300 (MSK)
Date:   Sun, 10 Feb 2019 00:42:40 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190209214240.56gq7ivn3pw3bssf@altlinux.org>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190106133608.820-1-vt@altlinux.org>
 <20190106133608.820-2-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190106133608.820-2-vt@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jan 06, 2019 at 04:36:05PM +0300, Vitaly Chikunov wrote:
> Some public key algorithms (like ECDSA) keep in parameters field
> important data such as digest and curve OIDs (possibly more for
> different ECDSA variants). Thus, just setting a public key (as
> for RSA) is not enough.
> 
> Introduce set_params() callback for akcipher which will be used to
> pass DER encoded parameters array, with additional argument of
> algorithm OID.
> 
> This is done with the intent of adding support for EC-RDSA (ISO/IEC
> 14888-3:2018, RFC 7091, and basically ECDSA variant) public keys (which
> will be finally used in IMA subsystem). Thus, also oid_registry.h is
> updated.
> 
> Rationale:
> 
> - For such keys just setting public key without parameters is
>   meaningless, so it would be possible to add parameters in
>   crypto_akcipher_set_pub_key (and .set_pub_key) calls. But, this will
>   needlessly change API for RSA akcipher. Also, additional callback
>   making it possible to pass parameters after
>   crypto_akcipher_set_priv_key (and .set_priv_key) in the future.
>
> - Algorithm OID is passed to be validated in .set_params callback,
>   otherwise, it could have the wrong value.
> 
> - Particular algorithm OIDs are checked in x509_note_params, (because
>   this is called from AlgorithmIdentifier (ASN.1) parser, which is
>   called multiple times, as it's used multiple times in X.509
>   certificate), to distinguish a public key call from a signature call.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---

> @@ -263,6 +274,11 @@ int public_key_verify_signature(const struct public_key *pkey,
>        if (pkey->key_is_private)
>                ret = crypto_akcipher_set_priv_key(tfm,
>                                                   pkey->key, pkey->keylen);
>        else
>                ret = crypto_akcipher_set_pub_key(tfm,
>                                                  pkey->key, pkey->keylen);
>        if (ret)
>                goto error_free_req;
> +	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
> +					 pkey->paramlen);

Nobody said anything if this is a good idea to call set_params after
set_{pub,priv}_key and not before.

When `struct crypto_akcipher' is allocated ctx data is never zeroed,
thus either call will be the first to zero ctx, making these calls not
swappable in the future.

Also, algorithm parameters could be interpreted without knowing the key,
but the key cannot be interpreted without knowing the parameters.

> +	if (ret)
> +		goto error_free_req;
> +
>  	ret = -ENOMEM;
>  	outlen = crypto_akcipher_maxsize(tfm);
>  	output = kmalloc(outlen, GFP_KERNEL);
