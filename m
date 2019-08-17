Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05F1C3A59B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 08:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49132064A
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 08:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfHQI2H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 04:28:07 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42007 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHQI2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 04:28:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id m44so7035136edd.9
        for <linux-crypto@vger.kernel.org>; Sat, 17 Aug 2019 01:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SGByj43V4T8nAqTozj7dDB6qHI2gcS79MAeL84ybVrU=;
        b=Aha4H2RNWTcuvTudJ1M329NtA5SnwMCCTzHO/Wrl+MndrcjyqMMQEL/N+E+pQdRaPf
         Q9Y72VlDNRcjU6Q+lCyNRYVsw1TfK0wNxCK/A5hg6WDHeoDpQ67F3zgkDRk8yNm4AmvU
         0ymv4jl7HEXfitDCXVKOADSvVrsNV0tcOyJ6SjO0DU4dzKCErMLBcH2JB5PnSnQkqPBp
         BhimeER/DTN0zy7vFgfW/NDDCCmXqzi3WbdxMLWPOravexylTFreDmNothqr+oxUQF5B
         VLJVwdvUZ+qnTKiSx0v4W0RHj7Km+ntJ1IedJLyg/JpZTOapMXuUEeaeqzbf3ZMmSIGQ
         HpMg==
X-Gm-Message-State: APjAAAV7OpCM0LkaL9i9ptfia5+tjs6dDN3vB82el/OLbuutQ9bBEl0W
        8VjlWp7xi3GCrnMxoUFfWQlANQ==
X-Google-Smtp-Source: APXvYqyldH64Fl/cJU0xJFoHIoSYIEu7aVtzlIYMBK8z93yWrTlW6TgFzU8e8oaQEP5O8F7Ekr0RHw==
X-Received: by 2002:a17:906:578a:: with SMTP id k10mr12623742ejq.235.1566030485927;
        Sat, 17 Aug 2019 01:28:05 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id um15sm1133948ejb.27.2019.08.17.01.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2019 01:28:05 -0700 (PDT)
Subject: Re: [PATCH 3/6] crypto: sha256 - Move lib/sha256.c to lib/crypto
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190816211611.2568-1-hdegoede@redhat.com>
 <20190816211611.2568-4-hdegoede@redhat.com>
 <20190817051942.GB8209@sol.localdomain>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <909d255d-a648-13b5-100f-fe67be547961@redhat.com>
Date:   Sat, 17 Aug 2019 10:28:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190817051942.GB8209@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 17-08-19 07:19, Eric Biggers wrote:
> On Fri, Aug 16, 2019 at 11:16:08PM +0200, Hans de Goede wrote:
>> diff --git a/include/linux/sha256.h b/include/crypto/sha256.h
>> similarity index 100%
>> rename from include/linux/sha256.h
>> rename to include/crypto/sha256.h
> 
> <crypto/sha.h> already has the declarations for both SHA-1 and SHA-2, including
> SHA-256.  So I'm not sure a separate sha256.h is appropriate.  How about putting
> these declarations in <crypto/sha.h>?

The problems with that is that the sha256_init, etc. names are quite generic
and they have not been reserved before, so a lot of the crypto hw-accel
drivers use them, for private file-local (static) code, e.g.:

[hans@shalem linux]$ ack -l sha256_init
include/crypto/sha256.h
drivers/crypto/marvell/hash.c
drivers/crypto/ccp/ccp-ops.c
drivers/crypto/nx/nx-sha256.c
drivers/crypto/ux500/hash/hash_core.c
drivers/crypto/inside-secure/safexcel_hash.c
drivers/crypto/chelsio/chcr_algo.h
drivers/crypto/stm32/stm32-hash.c
drivers/crypto/omap-sham.c
drivers/crypto/padlock-sha.c
drivers/crypto/n2_core.c
drivers/crypto/atmel-aes.c
drivers/crypto/axis/artpec6_crypto.c
drivers/crypto/mediatek/mtk-sha.c
drivers/crypto/qat/qat_common/qat_algs.c
drivers/crypto/img-hash.c
drivers/crypto/ccree/cc_hash.c
lib/crypto/sha256.c
arch/powerpc/crypto/sha256-spe-glue.c
arch/mips/cavium-octeon/crypto/octeon-sha256.c
arch/x86/purgatory/purgatory.c
arch/s390/crypto/sha256_s390.c
arch/s390/purgatory/purgatory.c

(in case you do not know ack is a smarter grep, which skips .o files, etc.)

All these do include crypto/sha.h and putting the stuff which is in what
was linux/sha256.h into crypto/sha.h leads to name collisions which causes
more churn then I would like this series to cause.

I guess we could do a cleanup afterwards, with one patch per file above
to fix the name collision issue, and then merge the 2 headers. I do not
want to do that for this series, as I want to keep this series as KISS
as possible since it is messing with somewhat sensitive stuff.

And TBH I even wonder if a follow-up series is worth the churn...

Regards,

Hans

