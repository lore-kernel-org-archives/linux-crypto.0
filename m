Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227CBC00144
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 20:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbiGZU42 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 16:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiGZU41 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 16:56:27 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C28437FBE
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 13:56:26 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so20101247fac.13
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 13:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=Lu19QanZmMmFbeJDfXhCYRPTw4ZQh3LrAl/eaR1hZNU=;
        b=UxncJtFCG/lVGHVoBUSLaMr6K0GhluD7rjVk3MrUipdt6R9d/RXB1aIM/CGVj/Ecmy
         VyWO57rdM7Xyvp6rrUGIP8OeflT9vp/YSnRqLuSozrMYJK+YROD7iwg6zUNfzLYoDbZT
         Ve/BJtRfmNC7dqtxAPKRqjTDO0uudD0vlCfbsVemgbIkph8vmVA7R7Lb12Rx/EbEtNX6
         1b3I7kCLl1mHlc7WjHu9SpiP7yc2rPza+fne8U2rfpsJEODxnVsbvLddSSXgRQYfKEe2
         baoXN2bdmD2/jrAlyRDwFToSs9V66IEi5AiCZ5FBdUokP6xUWSCqZ55SmFra0SWGZLXL
         0dUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=Lu19QanZmMmFbeJDfXhCYRPTw4ZQh3LrAl/eaR1hZNU=;
        b=EPEfKUNZLDs5TLMH1MgItzvrAfdRHJ6nWn8CtvGMi1CrtM1tw94GM2I3mI70HHrTWT
         5LjI1nA08mi73VU19j0YVcNjMFlCKGowzuhEpVJkyVozVzefeIme9stcHE5JN6qtx8l8
         N2NuRyFc3FcIW3zucWI6nBMYv+KHZK3RPteM5KUGiEsv/RNz35oeIyLi3mCztGXvA+1Y
         K6HVX0Tw3gj6LquKjUtLsmihcVzQG66uI/kJZwngp5b8ul6qCtpcRtF4/MMIdC1P7ChT
         0MTqoJpJ3VI2mAuwetIJR0wAhU722bhxpZfi58B1OsTC7w6M2fWsTSc5bVCR+VjIju7R
         9voQ==
X-Gm-Message-State: AJIora/7XD3In6vkToBcNRBjX+ao8+ZGwCIRFBdyQe7r/s3kWIcv7q3l
        +1tthm02SscGjVqCE7LAPNr2CQ59aGDglw==
X-Google-Smtp-Source: AGRyM1u4acPkgeL8YgfuE1QdRat/EQf1eEcOxzG5hnnGgiWAw8wmAmEAd56jBNwLmzHGD8gfB5iTSw==
X-Received: by 2002:a05:6870:d204:b0:10e:1cbc:477e with SMTP id g4-20020a056870d20400b0010e1cbc477emr570418oac.298.1658868985328;
        Tue, 26 Jul 2022 13:56:25 -0700 (PDT)
Received: from ?IPV6:2804:431:c7cb:8ded:8925:49f1:c550:ee7d? ([2804:431:c7cb:8ded:8925:49f1:c550:ee7d])
        by smtp.gmail.com with ESMTPSA id x1-20020a544001000000b0033a422b39b4sm6421692oie.49.2022.07.26.13.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 13:56:24 -0700 (PDT)
Message-ID: <9101f76a-c5d4-4101-0583-d942fb247b72@linaro.org>
Date:   Tue, 26 Jul 2022 17:56:21 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.0.3
Subject: Re: [PATCH v6] arc4random: simplify design for better safety
Content-Language: en-US
From:   Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org
Cc:     Florian Weimer <fweimer@redhat.com>,
        =?UTF-8?Q?Cristian_Rodr=c3=adguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Mark Harris <mark.hsj@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
References: <20220726190830.1189339-1-Jason@zx2c4.com>
 <20220726195822.1223048-1-Jason@zx2c4.com>
 <bb9b0cad-5b7a-e215-a9d2-ca8bcf664318@linaro.org>
Organization: Linaro
In-Reply-To: <bb9b0cad-5b7a-e215-a9d2-ca8bcf664318@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/07/22 17:17, Adhemerval Zanella Netto wrote:
> 
> 
> On 26/07/22 16:58, Jason A. Donenfeld wrote:
>> Rather than buffering 16 MiB of entropy in userspace (by way of
>> chacha20), simply call getrandom() every time.
>>
>> This approach is doubtlessly slower, for now, but trying to prematurely
>> optimize arc4random appears to be leading toward all sorts of nasty
>> properties and gotchas. Instead, this patch takes a much more
>> conservative approach. The interface is added as a basic loop wrapper
>> around getrandom(), and then later, the kernel and libc together can
>> work together on optimizing that.
>>
>> This prevents numerous issues in which userspace is unaware of when it
>> really must throw away its buffer, since we avoid buffering all
>> together. Future improvements may include userspace learning more from
>> the kernel about when to do that, which might make these sorts of
>> chacha20-based optimizations more possible. The current heuristic of 16
>> MiB is meaningless garbage that doesn't correspond to anything the
>> kernel might know about. So for now, let's just do something
>> conservative that we know is correct and won't lead to cryptographic
>> issues for users of this function.
>>
>> This patch might be considered along the lines of, "optimization is the
>> root of all evil," in that the much more complex implementation it
>> replaces moves too fast without considering security implications,
>> whereas the incremental approach done here is a much safer way of going
>> about things. Once this lands, we can take our time in optimizing this
>> properly using new interplay between the kernel and userspace.
>>
>> getrandom(0) is used, since that's the one that ensures the bytes
>> returned are cryptographically secure. But on systems without it, we
>> fallback to using /dev/urandom. This is unfortunate because it means
>> opening a file descriptor, but there's not much of a choice. Secondly,
>> as part of the fallback, in order to get more or less the same
>> properties of getrandom(0), we poll on /dev/random, and if the poll
>> succeeds at least once, then we assume the RNG is initialized. This is a
>> rough approximation, as the ancient "non-blocking pool" initialized
>> after the "blocking pool", not before, and it may not port back to all
>> ancient kernels, though it does to all kernels supported by glibc
>> (≥3.2), so generally it's the best approximation we can do.
>>
>> The motivation for including arc4random, in the first place, is to have
>> source-level compatibility with existing code. That means this patch
>> doesn't attempt to litigate the interface itself. It does, however,
>> choose a conservative approach for implementing it.
> 
> LGTM, I agree this is safe solution for 2.36, we can optimize it later
> if is were the case.
> 
> I will run some tests and push it upstream.
> 
> Reviewed-by: Adhemerval Zanella  <adhemerval.zanella@linaro.org>

And I think we will need to tune down stdlib/tst-arc4random-thread internal
parameters because it now takes about 1 minute on my testing machine (which
is somewhat recent processor).  I will send a patch to adjust the maximum
number of threads depending of the configured system CPU (to avoid syscall
contention).
