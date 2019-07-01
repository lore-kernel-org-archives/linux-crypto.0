Return-Path: <SRS0=UDVD=U6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB8BC0650E
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 08:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A228120B7C
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 08:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rkLqD8ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfGAI6v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jul 2019 04:58:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44807 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbfGAI6v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jul 2019 04:58:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id e3so3312670wrs.11;
        Mon, 01 Jul 2019 01:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZB9muExd+RSQxfZ5iBdaCUVYKgpUh2nYBHfJCMQqlwM=;
        b=rkLqD8nsIxsU17ZfdAuRJ8warBj1jj6tvGOHtaWAD7/OAT76DX7iTHY8IoqV1e5gB/
         UOPE9oddHIHUMl1CAJn4qVd4xfTIe8k/rcoax8J3iSqW7ST0LLeTXaE2rkYkOIce2X3/
         jWYP28rh+z73YhLyIUrN1dyswvORGgg3rb+iJIAMSAOEiLR36WT/xUVRxHK6dp4z7nSD
         2sgcqO704bmvqPL+ovYer2voC96etiAlfhEKngI2Po1t14CZyzG3jqMgN6vFMxqc4FbV
         JfgfUc7FF7uWd0R6abg+0gPboyLZ99igkME3x3cgp2RqtjCAUkum1eZhiibbNu2nbc5N
         BHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZB9muExd+RSQxfZ5iBdaCUVYKgpUh2nYBHfJCMQqlwM=;
        b=PHgtLpw1a9DNnMTq3WtpvtU9iwNf4FGyd/wHrvuD7F8GKu2Hk/hlsfwCncjaPTIAgp
         ifCPourZEYkcgZgjl6ZcQ8IeLgR54R88v0k6cWpdNGey0vPvGN4PKRJ20i5hJ+TGCXZ2
         GyE36pC9j91pmCE5irIDCcnnFDTnDZoALAnTqUQOwddT9MdRU3tH1LSuEOkLU91gfwnX
         j7XXoSs3ydFY/xhyK1gEzN3+Lr5r1DzXgfZBOFMRlWN1BPfqCmb/xKYvNjpeJgFsG0od
         Rq97bOijvcH0tdLVAMUPg4lZUShdy7hMEqJg/AC6s3XQt04C5O3yq4S7d33FnWEExxmb
         7jQQ==
X-Gm-Message-State: APjAAAVMufyGWFFNGOTkw0IyPK5i/X8iCj88eRXufYViHWu2ng91WzuB
        Ihf1z7GDEV25yvFEEtLuRPU=
X-Google-Smtp-Source: APXvYqyTj05KTHOmaeXlXryvdapZhOUS73dINv2tfGU/2VcdFq7oHkdIhByIbaxcYLlieMQ2PeiSSA==
X-Received: by 2002:a5d:4484:: with SMTP id j4mr8979377wrq.143.1561971529451;
        Mon, 01 Jul 2019 01:58:49 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id x16sm9323427wmj.4.2019.07.01.01.58.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 01:58:49 -0700 (PDT)
Subject: Re: [PATCH v6 3/7] md: dm-crypt: infer ESSIV block cipher from cipher
 string directly
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
 <20190628152112.914-4-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <767ec609-d805-9bc2-1a73-d5000ce7f109@gmail.com>
Date:   Mon, 1 Jul 2019 10:58:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628152112.914-4-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/06/2019 17:21, Ard Biesheuvel wrote:
> Instead of allocating a crypto skcipher tfm 'foo' and attempting to
> infer the encapsulated block cipher from the driver's 'name' field,
> directly parse the string that we used to allocated the tfm. These
> are always identical (unless the allocation failed, in which case
> we bail anyway), but using the string allows us to use it in the
> allocation, which is something we will need when switching to the
> 'essiv' crypto API template.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

>  drivers/md/dm-crypt.c | 35 +++++++++-----------

> @@ -2445,21 +2451,10 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
>  
>  	/* Alloc AEAD, can be used only in new format. */

^^ This comment is now obsolete, please move it with the code or remove it.

>  	if (crypt_integrity_aead(cc)) {
> -		ret = crypt_ctr_auth_cipher(cc, cipher_api);
> -		if (ret < 0) {
> -			ti->error = "Invalid AEAD cipher spec";
> -			return -ENOMEM;
> -		}
>  		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
>  	} else
>  		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));

Otherwise

Reviewed-by: Milan Broz <gmazyland@gmail.com>

Thanks,
Milan

