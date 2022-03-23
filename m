Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201C7C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 08:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiCWIpD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 04:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiCWIpC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 04:45:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71671289A0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 01:43:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id pv16so1448622ejb.0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 01:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pRO4rstzkYbiRB43WCgljqZ0gGunsig7pbQkCRR7eS4=;
        b=V0H6JJEsX/kP88LBQGwSzKsUzCuehVEQpcqioopP70NXELFAXalLXyT9r07twli41J
         0KuCmHcHjgoEToWBFQCIAZ4KUlrT8dEXkWbgbmyH3AnUbFkJvNylOycctCZWD4xYgFb7
         YRSGg1Nun0ULHBB0Nc7j5Q1Np7cPxSpMuHAQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pRO4rstzkYbiRB43WCgljqZ0gGunsig7pbQkCRR7eS4=;
        b=U8JnoK/O25H9NqShIL5I8f5Lcd+ZfbsoTKxzLECTQHFO9CiGrQeQIiEr+32imOgaC+
         BXJClOR5REl6F/Y3Y0CvCj+tEi9KnDJGguuukyKwZM3pT/qukmmR0wUUY5PJDWSkuj+z
         V8iLvqxaRjbfhrdBEtheRuISNSNad40lPTMnP48s3v5KeJVLzoIEIWAs8+0mN/LYQWEL
         5NehdGEYsApa+mmXjHii0jeqNCiIGUv6aKg2ru3zDgqC7HeF8xbDXsswCZf3lwuncGX8
         QYHl6GfmIgF0EmujkHPJOEL4eL/5N9NMZUAyUnmo+GughNAX/HHFrE5PD0RWdjpcyalW
         8gYg==
X-Gm-Message-State: AOAM533v3CwmY1lbE/+6UYHm3tS81INKtCSxiz+dWefK1b+KR2zmmnoq
        kCCnQxoX0JC3FfWpoypFEsWICw==
X-Google-Smtp-Source: ABdhPJwxlFaK5ERurGt1STHyjrOvX3N42n72G3mzxFQ6NKLxJ7OfFxip6rHXGoG+HmcSLtZNaVOYXg==
X-Received: by 2002:a17:906:9743:b0:6d8:632a:a42d with SMTP id o3-20020a170906974300b006d8632aa42dmr30717674ejy.157.1648025009968;
        Wed, 23 Mar 2022 01:43:29 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.64.233])
        by smtp.gmail.com with ESMTPSA id hb19-20020a170906b89300b006daa95d178esm9503171ejb.60.2022.03.23.01.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 01:43:29 -0700 (PDT)
Message-ID: <3707a8f9-93e7-ee54-42a3-ac12a279c6bc@rasmusvillemoes.dk>
Date:   Wed, 23 Mar 2022 09:43:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] random: allow writes to /dev/urandom to influence fast
 init
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>, Jann Horn <jannh@google.com>
References: <20220322191436.110963-1-Jason@zx2c4.com>
 <6716f3ffefae4ed8b5fd332bfcca8a9a@AcuMS.aculab.com>
 <YjqLAWbZ8K7eg3Fw@zx2c4.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <YjqLAWbZ8K7eg3Fw@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/03/2022 03.50, Jason A. Donenfeld wrote:

> - Since these seeding shell scripts have always been broken, because
>   this is how the rng has always been, rather than trying to bolt on a
>   very imperfect fix in the kernel for something that never worked
>   right, we could suggest shell scripts take the path that I implemented
>   for systemd:
>   https://github.com/systemd/systemd/commit/da2862ef06f22fc8d31dafced6d2d6dc14f2ee0b
>   In shell, this would look like:
> 
>     #!/bin/bash
>     cat seedfile > /dev/urandom
>     { cat seedfile; head -c 32 /dev/urandom; } | sha256sum | cut -d ' ' -f 1 > seedfile

Maybe stating the obvious, but in the interest of preventing
proliferation of more broken shell scripts: The tail of the above should
be spelled

  ...  > seedfile.tmp && mv seedfile.tmp seedfile

or seedfile would be truncated before cat had a chance to read it.

Rasmus
