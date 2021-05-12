Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B56C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 14:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC5B61407
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 14:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhELOY6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 10:24:58 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:33506 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhELOY5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 10:24:57 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id D107B72C8B4;
        Wed, 12 May 2021 17:23:47 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 03B614A46E8;
        Wed, 12 May 2021 17:23:47 +0300 (MSK)
Date:   Wed, 12 May 2021 17:23:46 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Elvira Khabirova <e.khabirova@omp.ru>
Cc:     keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, dhowells@redhat.com
Subject: Re: [PATCH] pkcs7: support EC-RDSA/streebog in SignerInfo
Message-ID: <20210512142346.kui3zeyheo7wlnwm@altlinux.org>
References: <20210511174744.4f3c6c59@msk1wst204>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210511174744.4f3c6c59@msk1wst204>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 11, 2021 at 05:47:44PM +0300, Elvira Khabirova wrote:
> Allow using EC-RDSA/streebog in pkcs7 certificates in a similar way
> to how it's done in the x509 parser.
> 
> This is needed e.g. for loading kernel modules signed with EC-RDSA.
> 
> Signed-off-by: Elvira Khabirova <e.khabirova@omp.ru>

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,

> ---
>  crypto/asymmetric_keys/pkcs7_parser.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
> index 967329e0a07b..39c260a04167 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -248,6 +248,12 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
>  	case OID_sha224:
>  		ctx->sinfo->sig->hash_algo = "sha224";
>  		break;
> +	case OID_gost2012Digest256:
> +		ctx->sinfo->sig->hash_algo = "streebog256";
> +		break;
> +	case OID_gost2012Digest512:
> +		ctx->sinfo->sig->hash_algo = "streebog512";
> +		break;
>  	default:
>  		printk("Unsupported digest algo: %u\n", ctx->last_oid);
>  		return -ENOPKG;
> @@ -269,6 +275,11 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
>  		ctx->sinfo->sig->pkey_algo = "rsa";
>  		ctx->sinfo->sig->encoding = "pkcs1";
>  		break;
> +	case OID_gost2012PKey256:
> +	case OID_gost2012PKey512:
> +		ctx->sinfo->sig->pkey_algo = "ecrdsa";
> +		ctx->sinfo->sig->encoding = "raw";
> +		break;
>  	default:
>  		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
>  		return -ENOPKG;
> -- 
> 2.25.1
