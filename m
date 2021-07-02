Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FC6C11F68
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jul 2021 14:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B493613FE
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jul 2021 14:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhGBOma (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jul 2021 10:42:30 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:50824 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhGBOma (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jul 2021 10:42:30 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id C611172C8B4;
        Fri,  2 Jul 2021 17:39:56 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 96A5B4A46ED;
        Fri,  2 Jul 2021 17:39:56 +0300 (MSK)
Date:   Fri, 2 Jul 2021 17:39:56 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        Elvira Khabirova <e.khabirova@omp.ru>
Subject: Re: [PATCH v3] pkcs7: make parser enable SM2 and SM3 algorithms
 combination
Message-ID: <20210702143956.h3d55suhw5ekbag4@altlinux.org>
References: <20210624094705.48673-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210624094705.48673-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 24, 2021 at 05:47:05PM +0800, Tianjia Zhang wrote:
> Support parsing the message signature of the SM2 and SM3 algorithm
> combination. This group of algorithms has been well supported. One
> of the main users is module signature verification.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

This will conflict with the patch of Elvira Khabirova adding the same
for streebog/ecrdsa. Otherwise,

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,

> ---
>  crypto/asymmetric_keys/pkcs7_parser.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
> index 967329e0a07b..6cf6c4552c11 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -248,6 +248,9 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
>  	case OID_sha224:
>  		ctx->sinfo->sig->hash_algo = "sha224";
>  		break;
> +	case OID_sm3:
> +		ctx->sinfo->sig->hash_algo = "sm3";
> +		break;
>  	default:
>  		printk("Unsupported digest algo: %u\n", ctx->last_oid);
>  		return -ENOPKG;
> @@ -269,6 +272,10 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
>  		ctx->sinfo->sig->pkey_algo = "rsa";
>  		ctx->sinfo->sig->encoding = "pkcs1";
>  		break;
> +	case OID_SM2_with_SM3:
> +		ctx->sinfo->sig->pkey_algo = "sm2";
> +		ctx->sinfo->sig->encoding = "raw";
> +		break;
>  	default:
>  		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
>  		return -ENOPKG;
> -- 
> 2.19.1.3.ge56e4f7
