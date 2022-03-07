Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669F9C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Mar 2022 09:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiCGJLp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 04:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiCGJLo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 04:11:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FF165160
        for <linux-crypto@vger.kernel.org>; Mon,  7 Mar 2022 01:10:48 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id a5so1602828pfv.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Mar 2022 01:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BGwyYo7g1htnNGKOyrQxUnucb3lG+yHE/6CNQIclhU4=;
        b=M/TRFnQNOVHFac3+Y4t+KdG579bu88UML933YrFzRxZ3JT52mO0DSGwu0RCo7Kf7kK
         kpUp/r/MuLMQSvDq4Q5/B0kw+9krsbLcXCirGybrySkWNrYiPXeCJYl/h2k/1hBcnojl
         aA5P9ul8FTU66oeZRwhflmHzc8yyH+f0wlETkYQg2x+3BLyDiVYu7zFCdhMK67J4dZ9V
         JGvlUmkg+Y1UMQjhmHiftQHYn6mNnfQG38IyfeKa8Qc3/onLq4zTROHO40m/XrOyzryF
         9opcdaewEXlnUGjCKPNtZygo9AbhcZm8gButQvKwuSVsqe4d8mh5AUFz20/Y8thEwB7I
         AmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGwyYo7g1htnNGKOyrQxUnucb3lG+yHE/6CNQIclhU4=;
        b=RanrMtt2ch5/pxjFFmbCfQwXct1TXB8tVVyc86IlC4TjT0Ba+XAooLOEfAwPWU9zJ7
         BL6as2Y7MsL67E62OjaHSVDlPhPtc+8ODngWtX6ekNEFcRCbs9iebCJawM4/NcKnPOIx
         qQcQd5A7XQ/zQYu2A2OWUQxrZVz1V+AdKyNW/VpInr5/NAWakOwBD+TDO1O8QoJjtg6N
         3roG/auZZAotr8a39LqmRQpwtgQRwbwI7E23skXhD7+u5pV3Wy/QtEBmkR1iKtqXjk07
         QNdy30EPfZZaPzkx7Obbdir8AI+NQhNLp1Dzb2Khu4H0VnPL93KtrXggFLhVY6ZareL/
         tNVA==
X-Gm-Message-State: AOAM533+cy9kANlE5qpW5Iq/lUWpS+A8Bo2cB2hmx9SdVnaP09jbrqqb
        +ISKjF25Y+owf+4vMsg6jKTOUQ==
X-Google-Smtp-Source: ABdhPJw5FNg9UcOK8tkQrJCwqMGFgXjBCkXtPMQZwPCYqKm/YKFsvsHoDlTsgVbHJMN1tHThFbp4ew==
X-Received: by 2002:a05:6a00:244f:b0:4cc:a2ba:4cd8 with SMTP id d15-20020a056a00244f00b004cca2ba4cd8mr11758227pfj.74.1646644247704;
        Mon, 07 Mar 2022 01:10:47 -0800 (PST)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id o19-20020a056a0015d300b004f6e4dc74b5sm6346050pfu.92.2022.03.07.01.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 01:10:47 -0800 (PST)
Subject: Re: Re: [PATCH v3 0/4] Introduce akcipher service for virtio-crypto
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, helei.sig11@bytedance.com,
        cohuck@redhat.com
References: <20220302033917.1295334-1-pizhenwei@bytedance.com>
 <a9d1dfc1-080e-fba2-8fbb-28718b067e0d@bytedance.com>
 <20220307040431-mutt-send-email-mst@kernel.org>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <a950f727-cda8-3259-b35e-e1306035dbde@bytedance.com>
Date:   Mon, 7 Mar 2022 17:07:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220307040431-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/7/22 5:05 PM, Michael S. Tsirkin wrote:
> On Mon, Mar 07, 2022 at 10:42:30AM +0800, zhenwei pi wrote:
>> Hi, Michael & Lei
>>
>> The full patchset has been reviewed by Gonglei, thanks to Gonglei.
>> Should I modify the virtio crypto specification(use "__le32 akcipher_algo;"
>> instead of "__le32 reserve;" only, see v1->v2 change), and start a new issue
>> for a revoting procedure?
> 
> You can but not it probably will be deferred to 1.3. OK with you?
> 

OK!

-- 
zhenwei pi
