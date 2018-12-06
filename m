Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACBDC04EB9
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Dec 2018 07:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECD520989
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Dec 2018 07:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="iFEzHZxA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AECD520989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbeLFH2O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Dec 2018 02:28:14 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:56055 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbeLFH2N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 02:28:13 -0500
Received: by mail-it1-f193.google.com with SMTP id o19so25730989itg.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2018 23:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8V0tnkBtqyOvzmKosnzukpM7iHmyMq9jSWER0m6N1I=;
        b=iFEzHZxAKxF0PMQda7o2LN0eCZLSTI6G3zdqr8+XZ79iafOkPBAiDv0Re6RATLH2sY
         UxZ7kOWzkV3zMI6uVjzpNklBTs9h1EgGyDM/aJ+191W7/UHX3qo7VwCNZg7obJ1YBs44
         6SWNTj2CaZPeb13VOjal7QT2hgXRhyb33yOFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8V0tnkBtqyOvzmKosnzukpM7iHmyMq9jSWER0m6N1I=;
        b=aLjR6H0Vwd7RPsmrdtyFO8fdwg/mG8/DtUt/fVX4Br1RaZWyPWPph8QPdx/9HoKUD2
         FX1NsebgST3Tbrnwy9PwJB3VCd+9Ibm7ZbYXet7N1bntbp36eeg0nhgNdvu51QWieEUH
         YrkGs+4aEkU6BwxYqz1N9hurGqv0dLYGwA71OEdSktDuZGYW39MrukKTBj9gTm+AAjEj
         aAWdWTExKvjZhzOIMIztwTrxaMSxky2prjfC59YdpVX4yxhtJrmf/BEK/AEUVfvL5kLR
         UIonwVTreJCAd0ZCSIbA/uVHWx9625PQjtmNlQSdqQB6oGZ5iFehb5fybFU71SuQAr/6
         4/Mg==
X-Gm-Message-State: AA+aEWasjFbEaNyUkW4sdD5MTx2HoXksozxmii4ie81ifdiy60nncX8q
        bst1NVWtO+E61vMHldxQVDnnxYrnLAyu6SfHxHjZYQ==
X-Google-Smtp-Source: AFSGD/X2aaDIrAX34dBZLxjZiZWc1UDl3sOMDI1FaNy/HX4cScbhfrGXTldzloTjUybNQmAdsrAxYxqavzBs0mTkDAY=
X-Received: by 2002:a05:660c:4b:: with SMTP id p11mr18659992itk.71.1544081292291;
 Wed, 05 Dec 2018 23:28:12 -0800 (PST)
MIME-Version: 1.0
References: <20181206045300.32387-1-ebiggers@kernel.org>
In-Reply-To: <20181206045300.32387-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Dec 2018 08:28:01 +0100
Message-ID:
 <CAKv+Gu_ZMUXaj45wQT_+m7VHNLhpdAaDnxEVduHJjGcCB05zMA@mail.gmail.com>
Subject: Re: [PATCH] dm crypt: log the encryption algorithm implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     device-mapper development <dm-devel@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181206072801.M8bu_xganjFMXqZvs9xP9Xvs1C6Ryk-o98bBVku_AGw@z>

On Thu, 6 Dec 2018 at 05:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Log the encryption algorithm's driver name when a dm-crypt target is
> created.  This will help people determine whether the expected
> implementation is being used.  In some cases we've seen people do
> benchmarks and reject using encryption for performance reasons, when in
> fact they used a much slower implementation than was possible on the
> hardware.  It can make an enormous difference; e.g., AES-XTS on ARM can
> be over 10x faster with the crypto extensions than without.  It can also
> be useful to know if an implementation using an external crypto
> accelerator is being used instead of a software implementation.
>
> Example message:
>
> [   29.307629] device-mapper: crypt: xts(aes) using implementation "xts-aes-ce"
>
> We've already found the similar message in fs/crypto/keyinfo.c to be
> very useful.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/md/dm-crypt.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index b8eec515a003..7646135487be 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1885,6 +1885,13 @@ static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
>                 }
>         }
>
> +       /*
> +        * dm-crypt performance can vary greatly depending on which crypto
> +        * algorithm implementation is used.  Help people debug performance
> +        * problems by logging the ->cra_driver_name.
> +        */
> +       DMINFO("%s using implementation \"%s\"", ciphermode,
> +              crypto_skcipher_alg(any_tfm(cc))->base.cra_driver_name);
>         return 0;
>  }
>
> @@ -1903,6 +1910,8 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
>                 return err;
>         }
>
> +       DMINFO("%s using implementation \"%s\"", ciphermode,
> +              crypto_aead_alg(any_tfm_aead(cc))->base.cra_driver_name);
>         return 0;
>  }
>
> --
> 2.19.2
>
