Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32876C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 19:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A72C21841
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 19:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfCVTta (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 15:49:30 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:40604 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfCVTta (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 15:49:30 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2B3B672CC6C;
        Fri, 22 Mar 2019 22:49:26 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 145264A4A16;
        Fri, 22 Mar 2019 22:49:26 +0300 (MSK)
Date:   Fri, 22 Mar 2019 22:49:25 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 05/11] KEYS: do not kmemdup digest in
 {public,tpm}_key_verify_signature
Message-ID: <20190322194925.w3i2esq6u2zaff2q@altlinux.org>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
        keyrings@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190301175918.29694-1-vt@altlinux.org>
 <20190301175918.29694-6-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190301175918.29694-6-vt@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David,

Can you please Ack this patch, it changes ASYMMETRIC KEYS tree, and
incorporates modifications you requested before.

Thanks,

On Fri, Mar 01, 2019 at 08:59:12PM +0300, Vitaly Chikunov wrote:
> Treat (struct public_key_signature)'s digest same as its signature (s).
> Since digest should be already in the kmalloc'd memory do not kmemdup
> digest value before calling {public,tpm}_key_verify_signature.
> 
> Patch is split from the previous as suggested by Herbert Xu.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: keyrings@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/asymmetric_keys/asym_tpm.c   | 10 +---------
>  crypto/asymmetric_keys/public_key.c |  9 +--------
>  2 files changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
> index 4e5b6fb57a94..402fc34ca044 100644
> --- a/crypto/asymmetric_keys/asym_tpm.c
> +++ b/crypto/asymmetric_keys/asym_tpm.c
> @@ -748,7 +748,6 @@ static int tpm_key_verify_signature(const struct key *key,
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
>  	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>  	uint32_t der_pub_key_len;
> -	void *digest;
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> @@ -780,14 +779,9 @@ static int tpm_key_verify_signature(const struct key *key,
>  	if (!req)
>  		goto error_free_tfm;
>  
> -	ret = -ENOMEM;
> -	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
> -	if (!digest)
> -		goto error_free_req;
> -
>  	sg_init_table(src_sg, 2);
>  	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> -	sg_set_buf(&src_sg[1], digest, sig->digest_size);
> +	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
>  	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
>  				   sig->digest_size);
>  	crypto_init_wait(&cwait);
> @@ -796,8 +790,6 @@ static int tpm_key_verify_signature(const struct key *key,
>  				      crypto_req_done, &cwait);
>  	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
>  
> -	kfree(digest);
> -error_free_req:
>  	akcipher_request_free(req);
>  error_free_tfm:
>  	crypto_free_akcipher(tfm);
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 338f2b5352b1..4dcfe281b898 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -235,7 +235,6 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	struct akcipher_request *req;
>  	struct scatterlist src_sg[2];
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
> -	void *digest;
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> @@ -268,14 +267,9 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	if (ret)
>  		goto error_free_req;
>  
> -	ret = -ENOMEM;
> -	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
> -	if (!digest)
> -		goto error_free_req;
> -
>  	sg_init_table(src_sg, 2);
>  	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> -	sg_set_buf(&src_sg[1], digest, sig->digest_size);
> +	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
>  	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
>  				   sig->digest_size);
>  	crypto_init_wait(&cwait);
> @@ -284,7 +278,6 @@ int public_key_verify_signature(const struct public_key *pkey,
>  				      crypto_req_done, &cwait);
>  	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
>  
> -	kfree(digest);
>  error_free_req:
>  	akcipher_request_free(req);
>  error_free_tfm:
> -- 
> 2.11.0
