Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4F4C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 10:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6343321D71
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 10:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=bezdeka.de header.i=@bezdeka.de header.b="O0Db1lV+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfJDKbe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 06:31:34 -0400
Received: from srv1.bezdeka.de ([185.207.107.174]:47946 "EHLO smtp.bezdeka.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729310AbfJDKbe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 06:31:34 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2019 06:31:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bezdeka.de;
         s=mail201812; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=moVTyURx1nxoFG5ngLVQGb7DVnfYOZ+3m3pnk+CnaGg=; b=O0Db1lV+QhTYVil93zUYH/ElDu
        wN2wrgGngRn6HrWzd2VIyy28Xg3dOuzqrKZhSXuVBDPSSRQSghMhdwdlfNyHSNHRP98BNPTwsQ0h0
        5lAl9AbHgJOPkOiO5N/0SJ0lWH+hz41DPsdTLZ/SwwDPLlbOdTdo2IFfa9LMm5zTVU0VtSu/a/Jxf
        v3U150AURK9HM4j9ylJEZvNPVx+C4Xrinkc6wGBh/GRS822AypotbvzDO4kqUQr3Rf6m9J7uU6Wha
        3t8xyNJ755jcYOBcWekKz0YliQD6H7joHmJP1i2Ru26ZIToonHmRcxIJGupycpGO6jTcyTcCOiYbh
        qcOgm7ow==;
Received: from [2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e]
        by smtp.bezdeka.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <florian@bezdeka.de>)
        id 1iGKi5-0004z3-Lg; Fri, 04 Oct 2019 12:21:37 +0200
Subject: Re: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gert Robben <t2@gert.gr>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jelle de Jong <jelledejong@powercraft.nl>
References: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
 <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr>
 <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
From:   Florian Bezdeka <florian@bezdeka.de>
Message-ID: <b15ff36b-19dc-2f04-ff2d-f644e30cdfb6@bezdeka.de>
Date:   Fri, 4 Oct 2019 12:21:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-User: florian@bezdeka.de
X-Authenticator: plain
X-Exim-Version: 4.92.3 (build at 30-Sep-2019 11:50:17)
X-Date: 2019-10-04 12:21:35
X-Connected-IP: 2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e:33174
X-Message-Linecount: 89
X-Body-Linecount: 70
X-Message-Size: 3323
X-Body-Size: 2440
X-Received-Count: 1
X-Local-Recipient-Count: 5
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I'm facing the same problem on one of my VPN gateways.

I updated the affected system from Debian Stretch to Buster.
Therefore the kernel was updated from 4.9.x to 4.19.x

The supplied patch uses some symbols / functions that were introduced 
with 4.19 (like crypto_sync_skcipher_clear_flags()) so some additional work
has to be done for older LTS kernels.

Any chance to get a patch working with 4.19?
I would be happy to test it.

Best regards,
  Florian

> On Thu, 3 Oct 2019 at 23:26, Gert Robben <t2@gert.gr> wrote:
>>
>> Op 03-10-2019 om 15:39 schreef Ard Biesheuvel:
>>> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
>>> the generic CBC template wrapper from a blkcipher to a skcipher algo,
>>> to get away from the deprecated blkcipher interface. However, as a side
>>> effect, drivers that instantiate CBC transforms using the blkcipher as
>>> a fallback no longer work, since skciphers can wrap blkciphers but not
>>> the other way around. This broke the geode-aes driver.
>>>
>>> So let's fix it by moving to the sync skcipher interface when allocating
>>> the fallback.
>>>
>>> Cc: Gert Robben <t2@gert.gr>
>>> Cc: Jelle de Jong <jelledejong@powercraft.nl>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>> Gert, Jelle,
>>>
>>> If you can, please try this patch and report back to the list if it solves
>>> the Geode issue for you.
>>
>> Thanks for the patch!
>> I tried it on Alix 2C2 / Geode LX800 with Linux 5.4-rc1 (also 5.1-5.3 fwiw).
>>
>> At least now openssl doesn't give those errors anymore.
>> (openssl speed -evp aes-128-cbc -elapsed -engine afalg)
>> But looking at the results (<6MB/s), apparently it's not using geode-aes
>> (>30MB/s?).
>> In dmesg can be seen:
>>
>> alg: skcipher: ecb-aes-geode encryption test failed (wrong result) on
>> test vector 1, cfg="out-of-place"
>> alg: skcipher: cbc-aes-geode encryption test failed (wrong result) on
>> test vector 2, cfg="out-of-place"
>> Geode LX AES 0000:00:01.2: GEODE AES engine enabled.
>>
>> In /proc/crypto, drivers cbc-aes-geode/ecb-aes-geode are listed with
>> "selftest: unknown". Driver "geode-aes" has "selftest: passed".
>>
>> I'm happy to test other patches.
> 
> Oops, mistake there on my part
> 
> Can you replace the two instances of
> 
> skcipher_request_set_crypt(req, dst, src, nbytes, desc->info);
> 
> with
> 
> skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> 
> please?
> 
> 
