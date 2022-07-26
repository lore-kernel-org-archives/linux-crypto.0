Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA44DC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 13:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiGZNLc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 09:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiGZNLb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 09:11:31 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C991B275CD
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 06:11:27 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-10d6ddda695so18580475fac.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 06:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=SRvL7rF/Rfmc6R9yZEJosuOv8b4u5XP2R5pW1VlL/lw=;
        b=PyNUDJ1b1q1/exHgptczU43Ez9Dv1tZXmavWMtesOfzh9Ro6+RERg9YNhDzdcXESva
         C7MMGmL63brG0mfYqXlLjqvgOjd60UQ2qbLYu/cmc0yRFvaOYZRPmXU619gmWi4/DeUZ
         9RvYqQpLvHCucgmTfNfZSsr6V9jnqb2W1E35LHWdxNRHtsEzdEkg3nzH9OKna1EnEn53
         yJ3ixBW9JhZKrxREnIDFobtDt7tZldMxvW7RPOe7fbwLYydYKt8BY/GvtCubZGBOYH/5
         2mCEF683Jhuw+6qz07EtLgdEH/hUJl0YBgK5ziSaijCVSZIni8y/oMYJkUg9sMdgif8A
         yung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=SRvL7rF/Rfmc6R9yZEJosuOv8b4u5XP2R5pW1VlL/lw=;
        b=O5KM2pmAaZ6AwvB04EEsAcCOOMPTa586I1jZ1xRKj0nxKb8J8RahI4sMMgqaGppHf/
         p6agICqx3bsMWlbR90HuGuOLS1YCywgJrCOV2P5MzmpTW7jM4PitjX728Roh+VoC6Mc2
         0Mgg7U7jNW+PXn42ZzZrp8LP4UQB4gSexAkdkEwg8Iv+bPRomP98X3k1D7xnyibnYzJ5
         7JRrePab6UdnrLZttxe8BXd/w5aAhX8QVVL+tudjS7Wime1dDmm4kMHAR/Jr2bbjH2YY
         4ZPVAs88Fhdu36hcujrH0UcSFC0/3/B3WjM4l5CZTymqi8D8wNWFQSSZVmrGb/oR4CvN
         6iIg==
X-Gm-Message-State: AJIora9DnXsna9I1SikuVzOhOtfq+56QVPhvym1ii5BYTQFnxEOVEv27
        w/deZI+7oHn7COzBOdsvTGN7nNVJXe1GTw==
X-Google-Smtp-Source: AGRyM1tCXeE9ig+X/o6CDiR+0zNa0A0GILbp9r7GJi8/x5GD85V8/xbyBvGLl2vrgc+48IKcLQNUGQ==
X-Received: by 2002:a05:6870:899e:b0:101:be11:a071 with SMTP id f30-20020a056870899e00b00101be11a071mr8567918oaq.168.1658841087058;
        Tue, 26 Jul 2022 06:11:27 -0700 (PDT)
Received: from ?IPV6:2804:431:c7cb:8ded:8925:49f1:c550:ee7d? ([2804:431:c7cb:8ded:8925:49f1:c550:ee7d])
        by smtp.gmail.com with ESMTPSA id g5-20020a9d6c45000000b0061c862ac067sm6116518otq.62.2022.07.26.06.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 06:11:26 -0700 (PDT)
Message-ID: <78977ba5-3814-1b5d-c58f-eec58ace3c44@linaro.org>
Date:   Tue, 26 Jul 2022 10:11:24 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.0.3
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        =?UTF-8?Q?Cristian_Rodr=c3=adguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
 <Yt/V78eyHIG/kms3@zx2c4.com>
 <e173ceb3-9005-fc36-8a21-f6f64f038ab6@linaro.org>
 <Yt/ic6Nmn/loPe4w@zx2c4.com>
From:   Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Organization: Linaro
In-Reply-To: <Yt/ic6Nmn/loPe4w@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/07/22 09:47, Jason A. Donenfeld wrote:
> Hi Adhemerval,
> 
> On Tue, Jul 26, 2022 at 09:34:57AM -0300, Adhemerval Zanella Netto wrote:
>> kernel newer than 3.17) it means some syscall filtering, and I am not sure
>> we should need to actually handle it.
> 
> One thing to keep in mind is that people who use CUSE-based /dev/urandom
> implementations might not like this, as it means they'd also have to
> intercept getrandom() rather than just ENOSYS'ing it. But maybe that's
> fine. I don't know of anyone actually doing this in the real world at
> the moment.
> 

I think it is a fair assumption that if you trying to implement your own
character device in userland, we should know the implications for the
environment.  From glibc standpoint, and I would for this whole thread,
we should assume that getrandom is de-facto API for entropy.
