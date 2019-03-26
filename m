Return-Path: <SRS0=ouVC=R5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FAFC4360F
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 16:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE9342070D
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 16:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdhTapfN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbfCZQOl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:14:41 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55349 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfCZQOl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Mar 2019 12:14:41 -0400
Received: by mail-it1-f194.google.com with SMTP id z126so20451234itd.5;
        Tue, 26 Mar 2019 09:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rFvBXRm8WNqPtkRNcJevgn2xUqxaLWFWWjeD/B7vNEg=;
        b=KdhTapfNMHGa3J4SsWfoesRU8ipCQdxcbDflanC1iTlHTuE+p1WGcBAwI7FrX1P7Li
         fUr7eqjC3+G0flYrlhxj5LjBAMuZK3aUg/KC/7Gsqv5gMOSOFq+BDbBIX9AUVsHoDtJo
         wPOiuWhfTYAzvLv8TTXJNvLFCUntyNn7G+/abu3FJFbffXgFN/xS4KWgROLYjmfbp9U6
         Or2UIbTW8kbUAQzUdYYNp6pIUOJt6tul/Jq47ZOQsIRCXhTopzABnuQbLeKE9hbavp3+
         7dgrMMVsui5gUP2U3ViIPU47ykPYPxgMji5nE6sZhxVGBoQjadXdcL7P1eRYhHPOcUbi
         E0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rFvBXRm8WNqPtkRNcJevgn2xUqxaLWFWWjeD/B7vNEg=;
        b=DlWNIGlKUsq443IBxT2/5Pmm06l4YVUsNavdQ1ZK1oELdQqpaDXgIT2FwlxKWLXRZU
         q8NVNb295DbciMq8W/vvv68aE6vrRhoQHNMzdjzLogrGYZUjyVUFjxnREzRcpjKRXtQ/
         nWsYjnSAMP1nBjQrotbS2d6PHaUesGkPYfG9FKkC1X/yDBta/nEJB1jzGQNRCP6hg1Zk
         tLJ45vHCEIqjPOj1rWRdyAhPDsDQRHAiMXu2CNc38voQ8u8bIBzSQWV2CW/dagOo07H5
         DbvWCzmD05iagQGzcY1zjPLC3Tmg69Ulqk74Gi8Np1qIFbSZsm04d5kyS6oe1nAHTy7H
         W6Pg==
X-Gm-Message-State: APjAAAWzJ5sc/QZX+763+uhGwMVZnWQEif9+omYlfGHVRgMyq7kCUTKx
        v0T6+Nv5Dn6SvvbrMlT4/1PNFVQq
X-Google-Smtp-Source: APXvYqwF9RDUq+Uz00PHgN3w9HPsJ3PtBQBo1GV8iNuPErkdxBPqhousBFZvW/W/wasM4i0j7qFOSw==
X-Received: by 2002:a24:2e0a:: with SMTP id i10mr860313ita.162.1553616879920;
        Tue, 26 Mar 2019 09:14:39 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id u197sm7563003itb.9.2019.03.26.09.14.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 09:14:38 -0700 (PDT)
Subject: Re: [PATCH v8 05/10] X.509: parse public key parameters from x509 for
 akcipher
To:     Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190326125842.24110-6-vt@altlinux.org>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <e302ad90-98c7-1e82-4d49-8ad214fd6ee7@gmail.com>
Date:   Tue, 26 Mar 2019 11:14:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190326125842.24110-6-vt@altlinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vitaly,

On 03/26/2019 07:58 AM, Vitaly Chikunov wrote:
> Some public key algorithms (like EC-DSA) keep in parameters field
> important data such as digest and curve OIDs (possibly more for
> different EC-DSA variants). Thus, just setting a public key (as
> for RSA) is not enough.
> 
> Append parameters into the key stream for akcipher_set_{pub,priv}_key.
> Appended data is: (u32) algo OID, (u32) parameters length, parameters
> data.
> 
> This does not affect current akcipher API nor RSA ciphers (they could
> ignore it). Idea of appending parameters to the key stream is by Herbert
> Xu.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: keyrings@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>   crypto/asymmetric_keys/asym_tpm.c         | 43 ++++++++++++++++--
>   crypto/asymmetric_keys/public_key.c       | 72 ++++++++++++++++++++++++-------
>   crypto/asymmetric_keys/x509.asn1          |  2 +-
>   crypto/asymmetric_keys/x509_cert_parser.c | 31 +++++++++++++
>   crypto/testmgr.c                          | 24 +++++++++--
>   crypto/testmgr.h                          |  5 +++
>   include/crypto/akcipher.h                 | 18 ++++----
>   include/crypto/public_key.h               |  4 ++
>   8 files changed, 168 insertions(+), 31 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
> index 402fc34ca044..d95d7ec50e5a 100644
> --- a/crypto/asymmetric_keys/asym_tpm.c
> +++ b/crypto/asymmetric_keys/asym_tpm.c
> @@ -395,6 +395,12 @@ static int determine_akcipher(const char *encoding, const char *hash_algo,
>   	return -ENOPKG;
>   }
>   
> +static u8 *tpm_pack_u32(u8 *dst, u32 val)
> +{
> +	memcpy(dst, &val, sizeof(val));
> +	return dst + sizeof(val);
> +}
> +
>   /*
>    * Query information about a key.
>    */
> @@ -407,6 +413,7 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
>   	struct crypto_akcipher *tfm;
>   	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>   	uint32_t der_pub_key_len;
> +	u8 *pkey, *ptr;
>   	int len;
>   
>   	/* TPM only works on private keys, public keys still done in software */
> @@ -421,7 +428,16 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
>   	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
>   					 der_pub_key);
>   
> -	ret = crypto_akcipher_set_pub_key(tfm, der_pub_key, der_pub_key_len);
> +	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
> +	if (!pkey)
> +		goto error_free_tfm;
> +	memcpy(pkey, der_pub_key, der_pub_key_len);
> +	ptr = pkey + der_pub_key_len;
> +	/* Set dummy parameters to satisfy set_pub_key ABI. */
> +	ptr = tpm_pack_u32(ptr, 0); /* algo */
> +	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
> +

Why not do all of this inside derive_pub_key?  The only reason for that 
function is to take a TPM-blob formatted public key and convert it to 
ASN.1 format understood by crypto_akcipher_set_pub_key.  So if you're 
changing the format, might as well update that function.

> +	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
>   	if (ret < 0)
>   		goto error_free_tfm;
>   
> @@ -440,6 +456,7 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
>   
>   	ret = 0;
>   error_free_tfm:
> +	kfree(pkey);
>   	crypto_free_akcipher(tfm);
>   	pr_devel("<==%s() = %d\n", __func__, ret);
>   	return ret;
> @@ -460,6 +477,7 @@ static int tpm_key_encrypt(struct tpm_key *tk,
>   	struct scatterlist in_sg, out_sg;
>   	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>   	uint32_t der_pub_key_len;
> +	u8 *pkey, *ptr;
>   	int ret;
>   
>   	pr_devel("==>%s()\n", __func__);
> @@ -475,7 +493,15 @@ static int tpm_key_encrypt(struct tpm_key *tk,
>   	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
>   					 der_pub_key);
>   
> -	ret = crypto_akcipher_set_pub_key(tfm, der_pub_key, der_pub_key_len);
> +	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
> +	if (!pkey)
> +		goto error_free_tfm;
> +	memcpy(pkey, der_pub_key, der_pub_key_len);
> +	ptr = pkey + der_pub_key_len;
> +	ptr = tpm_pack_u32(ptr, 0); /* algo */
> +	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
> +

Same comment as above

> +	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
>   	if (ret < 0)
>   		goto error_free_tfm;
>   
> @@ -500,6 +526,7 @@ static int tpm_key_encrypt(struct tpm_key *tk,
>   
>   	akcipher_request_free(req);
>   error_free_tfm:
> +	kfree(pkey);
>   	crypto_free_akcipher(tfm);
>   	pr_devel("<==%s() = %d\n", __func__, ret);
>   	return ret;
> @@ -748,6 +775,7 @@ static int tpm_key_verify_signature(const struct key *key,
>   	char alg_name[CRYPTO_MAX_ALG_NAME];
>   	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>   	uint32_t der_pub_key_len;
> +	u8 *pkey, *ptr;
>   	int ret;
>   
>   	pr_devel("==>%s()\n", __func__);
> @@ -770,7 +798,15 @@ static int tpm_key_verify_signature(const struct key *key,
>   	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
>   					 der_pub_key);
>   
> -	ret = crypto_akcipher_set_pub_key(tfm, der_pub_key, der_pub_key_len);
> +	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
> +	if (!pkey)
> +		goto error_free_tfm;
> +	memcpy(pkey, der_pub_key, der_pub_key_len);
> +	ptr = pkey + der_pub_key_len;
> +	ptr = tpm_pack_u32(ptr, 0); /* algo */
> +	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
> +

And here

> +	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
>   	if (ret < 0)
>   		goto error_free_tfm;
>   
> @@ -792,6 +828,7 @@ static int tpm_key_verify_signature(const struct key *key,
>   
>   	akcipher_request_free(req);
>   error_free_tfm:
> +	kfree(pkey);
>   	crypto_free_akcipher(tfm);
>   	pr_devel("<==%s() = %d\n", __func__, ret);
>   	if (WARN_ON_ONCE(ret > 0))

Regards,
-Denis
