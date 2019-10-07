Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9945BC47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 09:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 780102084D
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 09:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfJGJGJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 05:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbfJGJGJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 05:06:09 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A097B3D3C
        for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2019 09:06:08 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id c188so3045105wmd.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 02:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fBRIbgMq9EJ++XGIGImx8CYxss1cJwECLlupsXLpmYY=;
        b=Gffh7+Hgp0lqx7Ir6hMSGWYYz4z/sJz34+serHUBqRMs+dLAeL8al+BROFqH7vrQOj
         tyrThXVNOzmYIk9qb3f/5tThK99joTIQdVsyLmpNPkofA57thUFMP+oeUQaY6/OP7eiN
         +ytiPgwnaZMzqVhmcEaGSRsHdR/6E5MjyIMItR5XL5HMnKrNcwrRVOP2wik1e0PTToCZ
         0vJ0emA3UfAzcsvdD7VMkqtMC9+kgHcI5IMGBKEI7dVZX/L7/zU7D/ns09ox3Bj1QKA+
         JBTBzq/5Ar79QnmTIcRR+oVR8rMJ3WAWQcVW+goek8WIy8+yfp395DktUmI8IeSb7vCr
         4aqQ==
X-Gm-Message-State: APjAAAXET7vd0v3+EHA9Y4Tckl1APwkceitdJKJr6euSny9mATalP/bR
        5lsJzuD/c15yO2u52lUlobm5yjm70VoP2k3myICYi2+NEbNS9Oasd8rCb/uWgkCD5YymjMEcacw
        t4yAZR5VZaNH98HMPQd0stzxk
X-Received: by 2002:a1c:9e46:: with SMTP id h67mr19896526wme.48.1570439166325;
        Mon, 07 Oct 2019 02:06:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIB/mpa2f+0YDVQB+ZQ2wugqID9zQ0k8tNxBi2ZQC4pNdIS/WqtuyQ7J2IzdZR/nu3g5Y8dg==
X-Received: by 2002:a1c:9e46:: with SMTP id h67mr19896501wme.48.1570439166078;
        Mon, 07 Oct 2019 02:06:06 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id z5sm26075756wrs.54.2019.10.07.02.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 02:06:05 -0700 (PDT)
Subject: Re: [PATCH 5.4 regression fix] x86/boot: Provide memzero_explicit
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
References: <20191007085501.23202-1-hdegoede@redhat.com>
 <65461301.CAtk0GNLiE@tauon.chronox.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <284b70dd-5575-fee4-109f-aa99fb73a434@redhat.com>
Date:   Mon, 7 Oct 2019 11:06:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <65461301.CAtk0GNLiE@tauon.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On 07-10-2019 10:59, Stephan Mueller wrote:
> Am Montag, 7. Oktober 2019, 10:55:01 CEST schrieb Hans de Goede:
> 
> Hi Hans,
> 
>> The purgatory code now uses the shared lib/crypto/sha256.c sha256
>> implementation. This needs memzero_explicit, implement this.
>>
>> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
>> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get
>> input, memzero_explicit") Signed-off-by: Hans de Goede
>> <hdegoede@redhat.com>
>> ---
>>   arch/x86/boot/compressed/string.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/boot/compressed/string.c
>> b/arch/x86/boot/compressed/string.c index 81fc1eaa3229..511332e279fe 100644
>> --- a/arch/x86/boot/compressed/string.c
>> +++ b/arch/x86/boot/compressed/string.c
>> @@ -50,6 +50,11 @@ void *memset(void *s, int c, size_t n)
>>   	return s;
>>   }
>>
>> +void memzero_explicit(void *s, size_t count)
>> +{
>> +	memset(s, 0, count);
> 
> May I ask how it is guaranteed that this memset is not optimized out by the
> compiler, e.g. for stack variables?

The function and the caller live in different compile units, so unless
LTO is used this cannot happen.

Also note that the previous purgatory private (vs shared) sha256 implementation had:

         /* Zeroize sensitive information. */
         memset(sctx, 0, sizeof(*sctx));

In the place where the new shared 256 code uses memzero_explicit() and the
new shared sha256 code is the only user of the arch/x86/boot/compressed/string.c
memzero_explicit() implementation.

With that all said I'm open to suggestions for improving this.

Regards,

Hans
