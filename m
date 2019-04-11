Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9A4C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 17:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EA0320693
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 17:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rY1aYdap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfDKRSj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 13:18:39 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34470 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfDKRSj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 13:18:39 -0400
Received: by mail-ot1-f65.google.com with SMTP id k21so5946878otf.1;
        Thu, 11 Apr 2019 10:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7Ki5J1hlR1CKmSVR40eUi0RlHc65Eh3Ti4NIk/5ozpw=;
        b=rY1aYdapKEu++r6F+HvBd7YGdCWjEWFqygiTsolAG6Y85TMn80tup2IDd++pd2OB74
         ylaQHV0SobbRHNJ+63KD2DJXmARALDqB9Xt8LqCN+Ml+popV1Kvd6G5FwInRQeEUJKJl
         v6Ytt1BOOHtiDPgDjo5897toxSTP/m/Ni/41qGiraLCbcK7zCG40Eyd6ibL5B6pbvb4W
         X0tB7WvYhwREw40yZIgO6uKRtLOoWzgj5dlcbiierLBGDbOpMtfdHMNngznNEQFmUrX/
         KYl4vxULHQ6kmaQDnH7f2Z5nxqOIr5PZEhh/z80JNjyNmnjf2JvVvrHB8MvY5ZQkY9jn
         XzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Ki5J1hlR1CKmSVR40eUi0RlHc65Eh3Ti4NIk/5ozpw=;
        b=nAZ8sF5VuAOwZtRzBkx3a4T57xq4AIyTZksQ4V9v7FjyYXtVE2TCTKqbuvDbJkgxw+
         yLkgBj0eBvh1XYFxB3cbuz39bb2KSlwlgWsy6L5yH9vAyc7qqgHLwmwQuOBGkujGhUFp
         a6xFvJNEM+TwpOLo6okMCTyrTls/bWOshWT161R2OUdGxxN2ZT8QoP2i2cdsX0K5FLwl
         d8zUscDM7yTBRc0AWTPCDw+S7yuf5efd1HNYMKWbEt1ISz6FzRYlN3bS6E7naScP3vel
         YqgaopoWIdAjB/ON3N8nqL4Zc3MfVW69qLHGSsym4TcYlVAiIVMRtgMDxlZ9YZ3pb3h5
         mrng==
X-Gm-Message-State: APjAAAXxBVnnprAuME1EHg3G0wZWtElvJqNU9BjYIzrr2SyJZ8K/6jNd
        wCqLplrG5tDrLFjgyWipMxN4N74+
X-Google-Smtp-Source: APXvYqwZ+R6HEAGJPHmj+sI4c8YTSYl797qPL9IgJ3zojoXJDhL0+WPylrCcJJUZC7K67aakGGmeRw==
X-Received: by 2002:a9d:3b04:: with SMTP id z4mr31321999otb.1.1555003118598;
        Thu, 11 Apr 2019 10:18:38 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id x202sm15357183oix.54.2019.04.11.10.18.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 10:18:37 -0700 (PDT)
Subject: Re: [PATCH v9 05/10] X.509: parse public key parameters from x509 for
 akcipher
To:     Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190411155122.13245-1-vt@altlinux.org>
 <20190411155122.13245-6-vt@altlinux.org>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <48828e0e-0aef-dece-e7ad-4c0ea9cefbe7@gmail.com>
Date:   Thu, 11 Apr 2019 12:18:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190411155122.13245-6-vt@altlinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vitaly,

On 04/11/2019 10:51 AM, Vitaly Chikunov wrote:
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
> Cc: Denis Kenzior <denkenz@gmail.com>
> Cc: keyrings@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>   crypto/asymmetric_keys/asym_tpm.c         |  9 +++-
>   crypto/asymmetric_keys/public_key.c       | 72 ++++++++++++++++++++++++-------
>   crypto/asymmetric_keys/x509.asn1          |  2 +-
>   crypto/asymmetric_keys/x509_cert_parser.c | 31 +++++++++++++
>   crypto/testmgr.c                          | 24 +++++++++--
>   crypto/testmgr.h                          |  5 +++
>   include/crypto/akcipher.h                 | 18 ++++----
>   include/crypto/public_key.h               |  4 ++
>   8 files changed, 136 insertions(+), 29 deletions(-)
> 

Looks good to me.

Reviewed-by: Denis Kenzior <denkenz@gmail.com>

By the way:

> @@ -400,11 +401,12 @@ static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
>    * crypto_akcipher_set_priv_key() - Invoke set private key operation
>    *
>    * Function invokes the algorithm specific set key function, which knows
> - * how to decode and interpret the encoded key
> + * how to decode and interpret the encoded keya and parameters

Seems to be a stray 'a' after 'key'?

Regards,
-Denis
