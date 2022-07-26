Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4986DC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiGZLfg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiGZLfd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:35:33 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5D71EC53
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:35:24 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-10e4449327aso288546fac.4
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JR7hze4sDCYLNq+WCqxMqOHF13T7qF4AuVi9kdIgtxc=;
        b=Ysh28wyPtiR4VaVmEZHQBJ31/Bbh6bh4Gsgtoo28dFGY/c1CALj70PgDs55KIS/nRI
         tH+ctAvoCK9CfZJYtXz6HzlaESlnqR5rxGPsVO/URfqbuoj0ex/Mtj7Fl30XBRsb+VDL
         Wb+3FvwQaZj/EhzZSIHgTQKjqN6QLk2Az/zBPnHCjp5YAep7xc3dWhYrHDkzDI0JhHio
         3ceREWZjwW95IGNGTzypWsPVsZKeqArtF+tuF/cXjtT9byJz3A/NN635V+d7P0QkHlPw
         dL8MjVimVCZQehzlqBDJY9LLc7ytZ/8aHesObDHy66fdEqDeO8qHJQvH0vFfOP4sGh1x
         a0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JR7hze4sDCYLNq+WCqxMqOHF13T7qF4AuVi9kdIgtxc=;
        b=11z8YpI9srQzQC4TphFG8SOVYEqgdg6MsugJr1hguZmS4cdjdWFB7HF3jLfGvDkk7R
         YwEK4zjln4+itz4Z/tC2hz7hWlADvq+mUv+qfOjEUtZieRYb+VYNPgaFRJ8f43bNr4lA
         kMkxWvjOBsUZb5Pqd+17Uwcy3CTh4C1WeOmDVnShBB//bRJSUToA5qhk9jI+469cZ5Z4
         1oXTevja6aRMcvElX2sR3vw9H+9IDWiWVpAA7KiQscIxuanBR/ZYLDnvwqVqXwDAjgVO
         rFyhOAahKZY+Refz98xV2YwIpwkxKl3RkediyZE4zT3SyUCFgsuZMbZFnnfv2+KdvBKK
         l90A==
X-Gm-Message-State: AJIora/l6MQycXUCyyuTa+jkLde6RGnGXBYnjOkfeB1oUp8k4Eq48wOD
        SoY80GPImd0AUXMrhRthCQ/sjw==
X-Google-Smtp-Source: AGRyM1uPotPz6VrmzVkL/ggmMf0MWeBx87+MwjXCxtmOny3D4VuqFwFlu+aUZKpwPpMlnCIl4rMr5Q==
X-Received: by 2002:a05:6870:819e:b0:10e:d42:c25 with SMTP id k30-20020a056870819e00b0010e0d420c25mr5262633oae.267.1658835324186;
        Tue, 26 Jul 2022 04:35:24 -0700 (PDT)
Received: from ?IPV6:2804:431:c7cb:8ded:8925:49f1:c550:ee7d? ([2804:431:c7cb:8ded:8925:49f1:c550:ee7d])
        by smtp.gmail.com with ESMTPSA id m22-20020a4ad516000000b0043575a93b1fsm5826676oos.30.2022.07.26.04.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 04:35:23 -0700 (PDT)
Message-ID: <0319b66f-b3b5-3357-1fa9-c9e1d2448427@linaro.org>
Date:   Tue, 26 Jul 2022 08:35:21 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.0.3
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Weimer <fweimer@redhat.com>
Cc:     libc-alpha@sourceware.org,
        =?UTF-8?Q?Cristian_Rodr=c3=adguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <87k080i4fo.fsf@oldenburg.str.redhat.com> <Yt/KOQLPSnXFPtWH@zx2c4.com>
 <877d40i0v7.fsf@oldenburg.str.redhat.com> <Yt/OAZH0iX/0lj89@zx2c4.com>
From:   Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Organization: Linaro
In-Reply-To: <Yt/OAZH0iX/0lj89@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/07/22 08:20, Jason A. Donenfeld wrote:
> Hey Florian,
> 
> On Tue, Jul 26, 2022 at 01:12:28PM +0200, Florian Weimer wrote:
>>>> What happens if /dev/random is actually /dev/urandom?  Will the poll
>>>> call fail?
>>>
>>> Yes. I'm unsure if you're asking this because it'd be a nice
>>> simplification to only have to open one fd, or because you're worried
>>> about confusion. I don't think the confusion problem is one we should
>>> take too seriously, but if you're concerned, we can always fstat and
>>> check the maj/min. Seems a bit much, though.
>>
>> Turning /dev/random into /dev/urandom (e.g. with a symbolic link) used
>> to be the only way to get some applications working because they tried
>> to read from /dev/random at a higher rate than the system was estimating
>> entropy coming in.  We may have to do something differently here if the
>> failing poll causes too much breakage.
> 
> The "backup plan" would be to sleep-loop-read /proc/sys/kernel/random/entropy_avail
> until it passes a certain threshold one time. This might also work on even older
> kernels than the poll() trick. But that's pretty darn ugly, so it's not
> obvious to me where the cut-off in frustration is, when we throw our
> hands up and decide the ugliness is worth it compared to whatever
> problems we happen to be facing at the time with the poll() technique.
> But at least there is an alternative, should we need it.

I think the poll trick is way better, although I also think it is very Linux
specific.  Should we move it to Linux sysdeps?

The /proc/sys/kernel/random/entropy_avail would require to open another file
descriptor, which I think we avoid for arc4random if possible.
