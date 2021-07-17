Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEEEC636CA
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 13:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5CC6115A
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 13:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhGQOAb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 10:00:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33606 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbhGQOAa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 10:00:30 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 89C451FF13;
        Sat, 17 Jul 2021 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626530252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZAkIiHuPNFlhlE4mZwFNIvahXEAwXghF4bVnXz4XOk=;
        b=TG55fNTfaWsOtV0Du4Ksq67Y+o1x4Cli8KBeqLbPS1c+SFRN4Kdc8EGsou14rvLd5dXv2/
        x9qBzAnbgQomSinZx1c8tDPJJyQdYKNGcHDM7J6tvRcnSDXgjeNLozJYxyetz4fG4SKTIQ
        3cL9BAKqh6TykATGpccXgPJDfWr2Dak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626530252;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZAkIiHuPNFlhlE4mZwFNIvahXEAwXghF4bVnXz4XOk=;
        b=pDjPlGS3dPUnuskvls5KIzkTBxivFm+5qxMjPhWVuNvuMT51HZUd37GBOEFjt2L+LgP5l9
        U6RqudYeVeqbtFCQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 631E513A57;
        Sat, 17 Jul 2021 13:57:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 4mKBFszh8mAnXAAAGKfGzw
        (envelope-from <hare@suse.de>); Sat, 17 Jul 2021 13:57:32 +0000
Subject: Re: [PATCH 03/11] crypto/ffdhe: Finite Field DH Ephemeral Parameters
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-4-hare@suse.de>
 <3f9473c3-12c6-71c0-0744-34ea2a8a8c99@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <73e065db-7200-1409-2bd1-5a06df4404a0@suse.de>
Date:   Sat, 17 Jul 2021 15:57:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3f9473c3-12c6-71c0-0744-34ea2a8a8c99@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 8:14 AM, Sagi Grimberg wrote:
>> Add helper functions to generaten Finite Field DH Ephemeral Parameters as
>> specified in RFC 7919.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   crypto/Kconfig         |   8 +
>>   crypto/Makefile        |   1 +
>>   crypto/ffdhe_helper.c  | 877 +++++++++++++++++++++++++++++++++++++++++
>>   include/crypto/ffdhe.h |  24 ++
>>   4 files changed, 910 insertions(+)
>>   create mode 100644 crypto/ffdhe_helper.c
>>   create mode 100644 include/crypto/ffdhe.h
>>
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index ca3b02dcbbfa..1bea506ba56f 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -231,6 +231,14 @@ config CRYPTO_DH
>>       help
>>         Generic implementation of the Diffie-Hellman algorithm.
>> +config CRYPTO_FFDHE
>> +    tristate "Finite Field DH (RFC 7919) ephemeral parameters"
> 
> I'd stick with "Diffie-Hellman" in the tristate.
> 

Ok.

>> +    select CRYPTO_DH
>> +    select CRYPTO_KPP
>> +    select CRYPTO_RNG_DEFAULT
>> +    help
>> +      Generic implementation of the Finite Field DH algorithm
> 
> Diffie-Hellman algorithm
> And not sure I'd call it algorithm implementation, but rather a
> helper but maybe something like:
> Finite Field Diffie-Hellman ephemeral parameters helper implementation
> 

Wasn't sure how to call it myself; as stated I'm not a security expert.

>> +
>>   config CRYPTO_ECC
>>       tristate
>> diff --git a/crypto/Makefile b/crypto/Makefile
>> index 10526d4559b8..d3bc79fba23f 100644
>> --- a/crypto/Makefile
>> +++ b/crypto/Makefile
>> @@ -177,6 +177,7 @@ obj-$(CONFIG_CRYPTO_OFB) += ofb.o
>>   obj-$(CONFIG_CRYPTO_ECC) += ecc.o
>>   obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
>>   obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
>> +obj-$(CONFIG_CRYPTO_FFDHE) += ffdhe_helper.o
>>   ecdh_generic-y += ecdh.o
>>   ecdh_generic-y += ecdh_helper.o
>> diff --git a/crypto/ffdhe_helper.c b/crypto/ffdhe_helper.c
>> new file mode 100644
>> index 000000000000..dc023e30c4e5
>> --- /dev/null
>> +++ b/crypto/ffdhe_helper.c
>> @@ -0,0 +1,877 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * Finite Field DH Ephemeral Parameters (RFC 7919)
>> + *
>> + * Copyright (c) 2021, Hannes Reinecke, SUSE Software Products
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <crypto/internal/kpp.h>
>> +#include <crypto/kpp.h>
>> +#include <crypto/dh.h>
>> +#include <linux/mpi.h>
>> +
>> +/*
>> + * ffdhe2048 generator (g), modulus (p) and group size (q)
> 
> Maybe worth to refer exactly the source of these parameters
> in the comment body (rfc section/appendix).
> 

Sure. These actually are copies from RFC 7919, so will be adding a 
reference to it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
