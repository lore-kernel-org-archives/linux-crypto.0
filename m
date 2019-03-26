Return-Path: <SRS0=ouVC=R5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AC6C10F05
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 16:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644B92070D
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 16:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlNWQ6Bm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfCZQAr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:00:47 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33579 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729633AbfCZQAr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Mar 2019 12:00:47 -0400
Received: by mail-ot1-f68.google.com with SMTP id j10so5477147otq.0;
        Tue, 26 Mar 2019 09:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+X3y/qDiVyUZ6FE5er9C1/c3UdsMGx/nk0qkW7aHZhA=;
        b=TlNWQ6BmIrIz4ymM0k93Yp1tnJX1lqZA7Zzkst1AIVWpJPqNzD11PHm/Jaen/jXUIL
         vg0KQMo/mccl/la3CYRkYXqsoqbSrfv8IgLlEL2E8BKbNMWYFsInxvTNdxEY9TdEA/K1
         Wu5dkgug6LbAsOEIOTlCZ2gDR4Y9Jn55sYoJnfdRiL6FVzOHsuBVrQsJES30a88Ck4lk
         2I1h8kEY+vjpEuISwN5rARfbVlSzMP8dz9BZU66lpJEIyWkgtHhcsQS8rgxmc5gNxQXZ
         A5hBw3KabKOJk24TJWCB1s6JEe6Hxd+KiN1xHgHPDlCACI2Lk+9Nufi+VeqkIflha9xq
         P3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+X3y/qDiVyUZ6FE5er9C1/c3UdsMGx/nk0qkW7aHZhA=;
        b=b37G/DLWnQoGywavd7Pmb/EXxzz8/ymyxTOw4COKJrXwksGx2qROKrmttMo/YvAz8B
         ZZYiDFui67NGv7ZAJybzAABhZR2WGk9cMsN1Hm3yVPlCj19bBb4yo3TBgTiPljFEABJG
         pd+Gf3gkA2xAGGwnaFvIz+G9fvvMhZJDvgiUccxeAqq5KeS9rmtb2D8DUniPhbBnx4td
         4pGtoUf5hCwgcZ/3xn8esxYQ/IbU7dMRcNzA7Bz/g4E0dhQx0m3s+0jEAdBBARjjt8/1
         2XNSV4JNppxGm7+bwqTnDlG7RUsLzRKz5x2uPoA458107IWUHD03tjQXZm38uQP2gS8S
         OB1g==
X-Gm-Message-State: APjAAAVG17QvqdC9j124dii1NgmI/QeRmMpteQ0rKLgSPrrCyC+/AZ0p
        rjnccMQ3/NaDPeA4ztGTc1qIQogm
X-Google-Smtp-Source: APXvYqyZZwzSy1oMFCnWCyoBfM7ZWaT8w0fP+fx+5EipKTkzROWHiBhtzqXP2btg6Y0jQZDMpLIIDw==
X-Received: by 2002:a9d:5509:: with SMTP id l9mr21901554oth.195.1553616046287;
        Tue, 26 Mar 2019 09:00:46 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id f26sm7591795otl.20.2019.03.26.09.00.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 09:00:41 -0700 (PDT)
Subject: Re: [PATCH v8 03/10] crypto: akcipher - new verify API for public key
 algorithms
To:     Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190326125842.24110-4-vt@altlinux.org>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <ed78154e-2491-8e3e-3362-e45df4fda011@gmail.com>
Date:   Tue, 26 Mar 2019 11:00:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190326125842.24110-4-vt@altlinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vitaly,

On 03/26/2019 07:58 AM, Vitaly Chikunov wrote:
> Previous akcipher .verify() just `decrypts' (using RSA encrypt which is
> using public key) signature to uncover message hash, which was then
> compared in upper level public_key_verify_signature() with the expected
> hash value, which itself was never passed into verify().
> 
> This approach was incompatible with EC-DSA family of algorithms,
> because, to verify a signature EC-DSA algorithm also needs a hash value
> as input; then it's used (together with a signature divided into halves
> `r||s') to produce a witness value, which is then compared with `r' to
> determine if the signature is correct. Thus, for EC-DSA, nor
> requirements of .verify() itself, nor its output expectations in
> public_key_verify_signature() wasn't sufficient.
> 
> Make improved .verify() call which gets hash value as input and produce
> complete signature check without any output besides status.
> 
> Now for the top level verification only crypto_akcipher_verify() needs
> to be called and its return value inspected.
> 
> Make sure that `digest' is in kmalloc'd memory (in place of `output`) in
> {public,tpm}_key_verify_signature() as insisted by Herbert Xu, and will
> be changed in the following commit.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: keyrings@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>   crypto/asymmetric_keys/asym_tpm.c   | 34 ++++++++-----------------
>   crypto/asymmetric_keys/public_key.c | 34 ++++++++-----------------
>   crypto/rsa-pkcs1pad.c               | 29 +++++++++++++--------
>   crypto/testmgr.c                    | 50 ++++++++++++++++++++++---------------
>   include/crypto/akcipher.h           | 36 ++++++++++++++++----------
>   5 files changed, 92 insertions(+), 91 deletions(-)

The TPM bits, public_key and akcipher changes look good to me.  Didn't 
look into testmgr.

Feel free to add
Reviewed-by: Denis Kenzior <denkenz@gmail.com>

to this and patch 4.

Regards,
-Denis
