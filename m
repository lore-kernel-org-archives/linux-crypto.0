Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00587C32792
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 21:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D046820867
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfJCV0Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 17:26:25 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36263 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfJCV0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 17:26:25 -0400
X-Originating-IP: 83.97.23.51
Received: from d.localdomain (unknown [83.97.23.51])
        (Authenticated sender: out@gert.gr)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id D9DCE1C0007;
        Thu,  3 Oct 2019 21:26:21 +0000 (UTC)
Subject: Re: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Jelle de Jong <jelledejong@powercraft.nl>
References: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
From:   Gert Robben <t2@gert.gr>
Message-ID: <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr>
Date:   Thu, 3 Oct 2019 23:26:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: nl-NL
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Op 03-10-2019 om 15:39 schreef Ard Biesheuvel:
> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> the generic CBC template wrapper from a blkcipher to a skcipher algo,
> to get away from the deprecated blkcipher interface. However, as a side
> effect, drivers that instantiate CBC transforms using the blkcipher as
> a fallback no longer work, since skciphers can wrap blkciphers but not
> the other way around. This broke the geode-aes driver.
> 
> So let's fix it by moving to the sync skcipher interface when allocating
> the fallback.
> 
> Cc: Gert Robben <t2@gert.gr>
> Cc: Jelle de Jong <jelledejong@powercraft.nl>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> Gert, Jelle,
> 
> If you can, please try this patch and report back to the list if it solves
> the Geode issue for you.

Thanks for the patch!
I tried it on Alix 2C2 / Geode LX800 with Linux 5.4-rc1 (also 5.1-5.3 fwiw).

At least now openssl doesn't give those errors anymore.
(openssl speed -evp aes-128-cbc -elapsed -engine afalg)
But looking at the results (<6MB/s), apparently it's not using geode-aes 
(>30MB/s?).
In dmesg can be seen:

alg: skcipher: ecb-aes-geode encryption test failed (wrong result) on 
test vector 1, cfg="out-of-place"
alg: skcipher: cbc-aes-geode encryption test failed (wrong result) on 
test vector 2, cfg="out-of-place"
Geode LX AES 0000:00:01.2: GEODE AES engine enabled.

In /proc/crypto, drivers cbc-aes-geode/ecb-aes-geode are listed with 
"selftest: unknown". Driver "geode-aes" has "selftest: passed".

I'm happy to test other patches.
Regards, Gert
