Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48D9C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 10:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFD9610A8
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 10:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhKNKnd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Nov 2021 05:43:33 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:45575 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhKNKn3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Nov 2021 05:43:29 -0500
Received: by mail-wm1-f50.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so10072140wme.4
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 02:40:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijAtENWn1ygUhu59xmA540JQUcVLLz9Nox8HONApS5w=;
        b=NtNtSkCI799bY1uQvyw8yGEzmahSfyWM8wioPwE9ZwxBmGmWnVm+szGUeVgCabsV1V
         0CEJPBBLWpN+sg7e2EAQoMNXKR/4YAUUY4ZvHs3g9DQ8EEbUu9VwElUa3s1grC9CkujQ
         FVWo7bGY9vp691gmw8eQsP+bPYbRgHVzqZ1NK5+HE8Hm67WefYxyWnlC5K/97FNb/anl
         LRHV/nqLIRCuGUGhsmdBOWGrEl/RVzZGf4Z2YwgAf+3yyqxzNDTz1gTQRrPtMfeGlBVI
         RwPJI59DgZNU0cd7JR4PpouEoYT9mHXaRB2y6DPcFfzdg/qVdJMtgMVc8vHEIsPJA+vC
         IxIA==
X-Gm-Message-State: AOAM530q72Dg3Xm2O6YyTEV86XDbhjB1ecSwSFwkjMKJwuH7mWdSbfLP
        YaHLMNMwlUs5YGFj7jb2Z7vuFhPFxeI=
X-Google-Smtp-Source: ABdhPJzbCHf7KtlEb6QB1X2JJ414kye+aE2OlXNM87ZZRWWxsIXaAq84q0yH3B1wCJ+T6cb66HzsIQ==
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr38231010wmc.187.1636886434640;
        Sun, 14 Nov 2021 02:40:34 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f18sm10729240wre.7.2021.11.14.02.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 02:40:34 -0800 (PST)
Subject: Re: [PATCHv5 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <74db7c77-7cbf-4bc9-1c80-e7c42acaea64@grimberg.me>
Date:   Sun, 14 Nov 2021 12:40:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211112125928.97318-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 2:59 PM, Hannes Reinecke wrote:
> Hi all,
> 
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit
> especially for NVMe-TCP here's an attempt to implement it.
> 
> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.
> 
> Also note that this is just for in-band authentication. Secure
> concatenation (ie starting TLS with the negotiated parameters) is not
> implemented; one would need to update the kernel TLS implementation
> for this, which at this time is beyond scope.
> 
> As usual, comments and reviews are welcome.
> 
> Changes to v4:
> - Validate against blktest suite

Nice! thanks hannes, this is going to be very useful moving
forward.

> - Fixup base64 decoding

What was fixed up there?

> - Transform secret with correct hmac algorithm

Is that what I reported last time? Can you perhaps
point me to the exact patch that fixes this?
