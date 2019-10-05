Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50D1C47404
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 16:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B582C222CA
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 16:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfJEQPW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 12:15:22 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33223 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfJEQPW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 12:15:22 -0400
X-Originating-IP: 134.19.189.134
Received: from d.localdomain (unknown [134.19.189.134])
        (Authenticated sender: out@gert.gr)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id CEC5EE0005;
        Sat,  5 Oct 2019 16:15:17 +0000 (UTC)
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     jelledejong@powercraft.nl, ebiggers@kernel.org, florian@bezdeka.de,
        herbert@gondor.apana.org.au
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
From:   Gert Robben <t2@gert.gr>
Message-ID: <b18ff289-ceca-d934-6583-caf8d2916bcb@gert.gr>
Date:   Sat, 5 Oct 2019 18:15:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: nl-NL
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Op 05-10-2019 om 11:11 schreef Ard Biesheuvel:
> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> the generic CBC template wrapper from a blkcipher to a skcipher algo,
> to get away from the deprecated blkcipher interface. However, as a side
> effect, drivers that instantiate CBC transforms using the blkcipher as
> a fallback no longer work, since skciphers can wrap blkciphers but not
> the other way around. This broke the geode-aes driver.
> 
> So let's fix it by moving to the sync skcipher interface when allocating
> the fallback. At the same time, align with the generic API for ECB and
> CBC by rejecting inputs that are not a multiple of the AES block size.
> 
> Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
> Cc: <stable@vger.kernel.org> # v4.20+ ONLY
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> v2: pass dst and src scatterlist in the right order
>      reject inputs that are not a multiple of the block size

Yes, with this patch, the CRYPTO_MANAGER_EXTRA_TESTS output nothing 
(apart from "extra crypto tests enabled").
All items in /proc/crypto have "selftest: passed" mentioned.
"openssl speed -evp aes-128-cbc -elapsed -engine afalg" reaches the 
proper speed.
And nginx (correctly) transfers files about 40% faster than without 
geode-aes.

I didn't think about testing ecb before, because I don't use it.
Now that I did, I tried the same openssl benchmark for ecb.
But that only reaches software AES speed, and "time" also shows the work 
is being done in "user" instead of "sys" (see below).
Yet I see no errors.
(Maybe this is normal/expected, so I didn't look much further into it).

Thank you,
Gert

# time openssl speed -evp aes-128-cbc -elapsed -engine afalg
- - - 8< - - -
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
bytes  16384 bytes
aes-128-cbc        135.82k      539.29k     2087.90k     7491.16k 
29221.69k    34943.67k

real	0m18.081s
user	0m0.516s
sys	0m17.541s

# time openssl speed -evp aes-128-ecb -elapsed -engine afalg
- - - 8< - - -
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
bytes  16384 bytes
aes-128-ecb       4480.65k     5137.66k     5336.94k     5410.19k 
5409.91k     5409.91k

real	0m18.084s
user	0m18.046s
sys	0m0.012s

