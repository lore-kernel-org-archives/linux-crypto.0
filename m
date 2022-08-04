Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D53C19F2A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Aug 2022 13:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiHDNh0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239957AbiHDNhZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Aug 2022 09:37:25 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2F8402C4
        for <linux-crypto@vger.kernel.org>; Thu,  4 Aug 2022 06:37:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p10so21099226wru.8
        for <linux-crypto@vger.kernel.org>; Thu, 04 Aug 2022 06:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2nPgxVVZYzlzlxGzjgN0ucGsztfNKr6PE84XpanT7jw=;
        b=0AZuaiC6QNsq8wMT4360bE2JmRhzkikpG7895SQVa9Yhx/6qL6rRIUv022tJB1q1ty
         66v75fMuOB+Kh2qPMUVSQ0uF52f9PefDskXv+Lmvpxy+dxDOH7/18b8n1ghNNA+Fj81z
         Y/0LCx2VtV/jfHp/aOUvCab8J6nrcoz/LoQCefghME8FsV96S25RKSuIKV0EOfL6zgs9
         +4oxgk4wPGg+oQtH77v3ekWae6dYy1YOVsADJ+CI43Jo1au59lUzeDrdItc/1BOi+LTp
         DAXAjNPPi6IwnUhr1iITFlipGDrxM7CRjQ8gX9F02/VBq9bqNk/pCrVJ3+iFaPWUT4mH
         LWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2nPgxVVZYzlzlxGzjgN0ucGsztfNKr6PE84XpanT7jw=;
        b=mx58ZWD9c5W+WZUsFoRzRomg9Iw8WDjfZ+rVcnXcQFtBVNaQzpB5u3SqSDxNnoiObp
         LZgY+4A/5DdQi5CEHhk6mDDcyLzDRJEwDJk7cjr+m+jBrb0t02fk10K0J5fvGA+oD2Kr
         oUPSZbVgBi3+fz0ys2VhUfUn5X03QaRxOfGBFU36eyEA1Rz7bLjOf+KqPS6fCJ1VfUre
         fVbF+xMFTp9WdZjmVJUnlWGSe51qLVkCcEwoPbNInVWk8ua8W7jTjIhb1eX+rivTW4wT
         zbNbHlrGw0y74pdI8rhLIav3epSJz/uCpmhEayFEj4IUVFhyAR/qZzyhIBNCjclceYzC
         fxSQ==
X-Gm-Message-State: ACgBeo2BMwa7EkzJ9DchebfylgQhPU4LxWwfuRJldrldch54n7HP0J6O
        /MDr0WjUL3TkBttD5NOI7Mj36w==
X-Google-Smtp-Source: AA6agR7Nbejc7u4lmu1GjsYHxD/9o18vaBihS8g+jhTeDBgTshi6rs5aQfONcf33MFxqqiZKFncQcQ==
X-Received: by 2002:a05:6000:789:b0:220:7480:e2c1 with SMTP id bu9-20020a056000078900b002207480e2c1mr1471387wrb.327.1659620241803;
        Thu, 04 Aug 2022 06:37:21 -0700 (PDT)
Received: from ?IPV6:2003:c1:c716:2d00:2431:52f9:7c18:3205? (p200300c1c7162d00243152f97c183205.dip0.t-ipconnect.de. [2003:c1:c716:2d00:2431:52f9:7c18:3205])
        by smtp.gmail.com with ESMTPSA id j5-20020adfa545000000b002211fc70174sm898541wrb.99.2022.08.04.06.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 06:37:21 -0700 (PDT)
Message-ID: <de02389f-249d-f565-1136-4af3655fab2a@profian.com>
Date:   Thu, 4 Aug 2022 15:37:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] crypto: ccp: Load the firmware twice when SEV API version
 < 1.43
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220804010223.3619-1-jarkko@kernel.org>
 <58e8f9dc-a8d3-a2a5-2dd7-0783355e2567@amd.com>
From:   Harald Hoyer <harald@profian.com>
In-Reply-To: <58e8f9dc-a8d3-a2a5-2dd7-0783355e2567@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 04.08.22 um 15:13 schrieb Tom Lendacky:
> On 8/3/22 20:02, Jarkko Sakkinen wrote:
>> From: Jarkko Sakkinen <jarkko@profian.com>
>>
>> SEV-SNP does not initialize to a legit state, unless the firmware is
>> loaded twice, when SEP API version < 1.43, and the firmware is updated
>> to a later version. Because of this user space needs to work around
>> this with "rmmod && modprobe" combo. Fix this by implementing the
>> workaround to the driver.
> 
> The SNP hypervisor patches are placing a minimum supported version
> requirement for the SEV firmware that exceeds the specified version
> above [1] (for the reason above, as well as some others), so this patch
> is not needed, NAK.

As described in the "Milan Release Notes.txt" of the AMD firmware update package amd_sev_fam19h_model0xh_1.33.03.zip.

"If upgrading to 1.33.01 or later from something older (picking up CSF-1201), it is required that two Download Firmware commands be run to fix the "Committed Version" across the firmware. CSF-1201 
fixed a bug where the committed version in the attestation report was incorrect. Performing a single Download Firmware will upgrade the firmware, but performing a second one will correct the committed 
version. This is a one-time upgrade issue.
"

Note that `1.33.01` is not the same version number as "1.51" in [1]. One is the firmware version, the other is the SEV-SNP API version.

I am definitely seeing a wrong TCB version, if the firmware is only updated once to `1.33.01` aka "1.51".
Reloading the `ccp` module, which triggers another firmware load, cures the problem.

The patch might be wrong, as it might not do the right thing, but the problem and the solution exist.

What is your suggestion then to fix the wrong committed TCB version?

> 
> [1] https://lore.kernel.org/lkml/87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com/
> 
> Thanks,
> Tom
> 
>>
>> Reported-by: Harald Hoyer <harald@profian.com>
>> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++++++++---
>>   1 file changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 799b476fc3e8..f2abb7439dde 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -76,6 +76,9 @@ static void *sev_es_tmr;
>>   #define NV_LENGTH (32 * 1024)
>>   static void *sev_init_ex_buffer;
>> +/*
>> + * SEV API version >= maj.min?
>> + */
>>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>> @@ -89,6 +92,14 @@ static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>>       return false;
>>   }
>> +/*
>> + * SEV API version < maj.min?
>> + */
>> +static inline bool sev_version_less(u8 maj, u8 min)
>> +{
>> +    return !sev_version_greater_or_equal(maj, min);
>> +}
>> +
>>   static void sev_irq_handler(int irq, void *data, unsigned int status)
>>   {
>>       struct sev_device *sev = data;
>> @@ -1274,6 +1285,7 @@ void sev_pci_init(void)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>>       int error, rc;
>> +    int i;
>>       if (!sev)
>>           return;
>> @@ -1283,9 +1295,13 @@ void sev_pci_init(void)
>>       if (sev_get_api_version())
>>           goto err;
>> -    if (sev_version_greater_or_equal(0, 15) &&
>> -        sev_update_firmware(sev->dev) == 0)
>> -        sev_get_api_version();
>> +    /*
>> +     * SEV-SNP does not work properly before loading the FW twice in the API
>> +     * versions older than SEV 1.43.
>> +     */
>> +    for (i = 0; i < sev_version_greater_or_equal(0, 15) + sev_version_less(1, 43); i++)
>> +        if (sev_update_firmware(sev->dev) == 0)
>> +            sev_get_api_version();
>>       /* If an init_ex_path is provided rely on INIT_EX for PSP initialization
>>        * instead of INIT.

