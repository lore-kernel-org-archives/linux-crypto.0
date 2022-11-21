Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB4BC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 11:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiKULZg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKULZD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2022 06:25:03 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C020BF593
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 03:20:31 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z26so11053404pff.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 03:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4HmxkPUGNQgSxOWkEQacWGxG2mYXkxvZLDBu2UFXUhY=;
        b=RSqjV08Q9nyZVPlRoG2CcVVFf8AL3EV5NnwcbEoI7GyOBuIMZZoQALG3HeQ44on4CM
         EEj0LbfPcGDUdrH0XJx2ftr88ahINXMmSSqe2W9IWbIDNfhfBF1IuccSvHkgZ4U8kTwT
         dQlvqvk/GDkDk+AQIJmUvFLIgje+ysp5KOKfY2fa8Ij7A5P/HLEkHzxZSqhc8p8vQ/Up
         sA9zjwg340ixr1z64kPfe2vcmpWL6oxYCaZVZxzp0TCF/Y2H79f7d8wyTCYmqbb90mfV
         KAMdRCAl/rgTUUd6Vd00EzwcE7Nfnni/7ePKN2BhWvf1PaCvRyisNh+DLpeyz9Swv6hs
         RcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4HmxkPUGNQgSxOWkEQacWGxG2mYXkxvZLDBu2UFXUhY=;
        b=gdfQBcw7Z+EkGn2/S7YGq95IPYEmk0I7qEH2hL6IvzAsYIec1WB1ZPmaAv05tYwwvw
         Om3BaoIA/05IU7qYSclBIS1q/WTRpWyYenNUn63GIrL3JvdixAwfGbNGXG6X4Pdt8S/v
         oRWmzgy8jiW25DZt3xa7hyrSWi1B+PpTEx/JjgBfPCgDUzPN7SHOku1hbule/3qQdRIZ
         BNOD17F2UwmIVl4fjxBrngT455haHLFDaWkvVFXWTr4RrMdypokczjl2Y+dSKZ5Rz5vr
         FVSXruj6WBFoCufuXm6AJyGxNbOBulAwksVB2lNjlKnf8cCHBqcHqe+u9ioIv+PWvDWa
         nZhg==
X-Gm-Message-State: ANoB5pmDD7wdPbnwEB4ercti9AqfqjJqLmL15Qjd24OK0uljE0mXiAmg
        ZQaQOkjbjz2JZHAKESTKMu8=
X-Google-Smtp-Source: AA0mqf6XpTp0KLn0UUwz1G4GkXEbioMZUOef+kJ9h0IDJ25SvmDmV/XJ4gsBq/ZNCeVMerdemUTN6g==
X-Received: by 2002:a62:e412:0:b0:566:8395:6dfa with SMTP id r18-20020a62e412000000b0056683956dfamr2073851pfh.20.1669029630984;
        Mon, 21 Nov 2022 03:20:30 -0800 (PST)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id y24-20020aa78f38000000b0056ddd2ac8f1sm8437629pfr.211.2022.11.21.03.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 03:20:30 -0800 (PST)
Message-ID: <788e7255-ef05-f1bf-608e-df8085304344@gmail.com>
Date:   Mon, 21 Nov 2022 20:20:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 0/4] crypto: aria: implement aria-avx2 and aria-avx512
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        ebiggers@kernel.org
References: <20221121003955.2214462-1-ap420073@gmail.com>
 <Y3tJLp3UlXGmK7HB@zn.tnic>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y3tJLp3UlXGmK7HB@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Borislav,
Thank you so much for your comment!

On 11/21/22 18:47, Borislav Petkov wrote:
 > On Mon, Nov 21, 2022 at 12:39:51AM +0000, Taehee Yoo wrote:
 >> This patchset is to implement aria-avx2 and aria-avx512.
 >> There are some differences between aria-avx, aria-avx2, and aria-avx512,
 >> but they are not core logic(s-box, diffusion layer).
 >
 > From: Documentation/process/submitting-patches.rst
 >
 > "Don't get discouraged - or impatient
 > ------------------------------------
 >
 > After you have submitted your change, be patient and wait.  Reviewers are
 > busy people and may not get to your patch right away.
 >
 > Once upon a time, patches used to disappear into the void without 
comment,
 > but the development process works more smoothly than that now.  You 
should
 > receive comments within a week or so; if that does not happen, make sure
 > that you have sent your patches to the right place.  Wait for a 
minimum of
 > 						     ^^^^^^^^^^^^^^^^^^^^^
 > one week before resubmitting or pinging reviewers - possibly longer 
during
 > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 >
 > busy times like merge windows."
 >
 > IOW, pls stop spamming with your patchset.
 >
 > Thx.
 >

Sorry for that.
After now, I will wait at least one week for review.

Thanks a lot!
Taehee Yoo
