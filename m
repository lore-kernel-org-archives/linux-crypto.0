Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34086C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Oct 2022 14:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJLOuB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Oct 2022 10:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJLOuA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Oct 2022 10:50:00 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7301ADB2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Oct 2022 07:49:58 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id c187-20020a4a4fc4000000b004808e2f7affso1885087oob.13
        for <linux-crypto@vger.kernel.org>; Wed, 12 Oct 2022 07:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UplEK3mqcrCacidHdATkuawjVeYJHMCCCUOFPWg9KqI=;
        b=xxa3t8CNGe00EQznVWzeR4p9qdPhSp15k51tQXdr2nv2XNggjAfIopyLbnwFzcLn77
         JONZsylSPTvToCleo2vBdV6jFtbzb+zWhvQ1yKTFTg2gTgKxiqg5DQNIFP9ft+MQ5NSR
         3pJ5GyWlGcBg2zzHRMlxqIk4kXf1ULdK1QT0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UplEK3mqcrCacidHdATkuawjVeYJHMCCCUOFPWg9KqI=;
        b=4GvOxH3ua1clruCxd9giiVxo39gQOrTFY62SkHIv+nT7Ht9n7VQII9btHyRzTJDy6S
         qeNoZCLM1JdkTfjPWhOdHqyi1UGcnkaOfaDXvZuls5q7JjJQzi750oay/tZw15tp6QzP
         7+S6X6blxJmmfDbb+EvVcHgIR4rGEEQqMxytwEOgtKt159QWHTFY2PSub/21ndhpjdSZ
         Kqy5EOnFrEUn4MlWmgmPzUeJAm4CwgXvyAU5PygFls9lL/x8aRNwAI1JPJcjWD9JRZcU
         cLs6aCDiSyxS9biFVhXM9IEfAsnUA1LXimBrPW8aWeb5vvl6d9XyuzCOK69YlByWUFXw
         EZtA==
X-Gm-Message-State: ACrzQf3Qwujo92/h6VXs70m57/hbkgxSmwuXpAygDj81KAPfsSs6eX2v
        tOnKtMOMeDpp5nM0M8x9paeHVQ==
X-Google-Smtp-Source: AMsMyM7MEoBnOEtucWMs4RmpJji3LR4RnzFNkuhTrYE9+kcQbEU8ejIMYbfxQ7HOuznctRkHlaV3Bg==
X-Received: by 2002:a05:6830:2682:b0:659:e2dc:f033 with SMTP id l2-20020a056830268200b00659e2dcf033mr12910298otu.196.1665586197525;
        Wed, 12 Oct 2022 07:49:57 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id k14-20020a056870818e00b0010d5d5c3fc3sm1329477oae.8.2022.10.12.07.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 07:49:57 -0700 (PDT)
Message-ID: <cc5c3efe-7dc3-65d6-d7d9-761bfc2c9711@cloudflare.com>
Date:   Wed, 12 Oct 2022 09:49:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH 1/1] crypto: af_alg - Support symmetric encryption via
 keyring keys
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, hch@lst.de,
        smueller@chronox.de, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-team@cloudflare.com,
        Ondrej Mosnacek <omosnace@redhat.com>
References: <20221004212927.1539105-1-fred@cloudflare.com>
 <Y0X3L/jhinCqJXxj@sol.localdomain>
Content-Language: en-US
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <Y0X3L/jhinCqJXxj@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 10/11/22 6:07 PM, Eric Biggers wrote:
> Hi Frederick,
> 
> On Tue, Oct 04, 2022 at 04:29:27PM -0500, Frederick Lawler wrote:
>> We want to leverage keyring to store sensitive keys, and then use those
>> keys for symmetric encryption via the crypto API. Among the key types we
>> wish to support are: user, logon, encrypted, and trusted.
>>
>> User key types are already able to have their data copied to user space,
>> but logon does not support this. Further, trusted and encrypted keys will
>> return their encrypted data back to user space on read, which make them not
>> ideal for symmetric encryption.
>>
>> To support symmetric encryption for these key types, add a new
>> ALG_SET_KEY_BY_KEY_SERIAL setsockopt() option to the crypto API. This
>> allows users to pass a key_serial_t to the crypto API to perform
>> symmetric encryption. The behavior is the same as ALG_SET_KEY, but
>> the crypto key data is copied in kernel space from a keyring key,
>> which allows for the support of logon, encrypted, and trusted key types.
>>
>> Keyring keys must have the KEY_(POS|USR|GRP|OTH)_SEARCH permission set
>> to leverage this feature. This follows the asymmetric_key type where key
>> lookup calls eventually lead to keyring_search_rcu() without the
>> KEYRING_SEARCH_NO_CHECK_PERM flag set.
>>
>> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> 
> There was a similar patch several years ago by Ondrej Mosnacek:
> https://lore.kernel.org/linux-crypto/20190521100034.9651-1-omosnace@redhat.com/T/#u
> 
> Have you addressed all the feedback that was raised on that one?

Thanks for sharing that.

I believe I've addressed most of the feedback. Starting with we agree 
preferring key_serial_t. I changed to to use IS_REACHABLE(), and set 
ALG_SET_KEY_BY_KEY_SERIAL to 10 leaving a comment about libkcapi 
reserving values 7-9.

I've made other additional changes since the RFC, so we should consider 
this code outdated. I'll submit a v1 that is a bit cleaner after the 
merge window.

Your comment about broken crypto algorithms exposing sensitive data is 
interesting. We've had similar thoughts about adding additional 
permission, but ultimately decided to stick to the pattern asymmetric 
key types use.

lookup_user_key() ultimately makes a call into a security hook 
security_key_permission() given a key_ref_t, so users can further 
restrict access based on keys that way if enabled. We've also had 
similar discussions regarding X.509 certificates, and I'm not opposed to 
Ondrej's suggestion of disabling this feature by default with Kconfig. 
I'll look into this a bit more, and we're open to suggestions here.

> 
> Two random nits below:
> 
>> +	*dest_len = key->datalen;
>> +	*dest = kmalloc(*dest_len, GFP_KERNEL);
>> +	if (!*dest)
>> +		return -ENOMEM;
>> +
>> +	memcpy(*dest, ukp->data, *dest_len);
> 
> This should use kmemdup(). >
>> +	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
>> +			   !strcmp(key->type->name, "encrypted")) {
>> +		read_key = &read_key_type_encrypted;
>> +	} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
>> +			   !strcmp(key->type->name, "trusted")) {
>> +		read_key = &read_key_type_trusted;
> 
> These need to use IS_REACHABLE(), not IS_ENABLED().
> 
> - Eric

