Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8FDC636CA
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743F0613D8
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhGQGJk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 02:09:40 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:42928 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhGQGJk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 02:09:40 -0400
Received: by mail-pj1-f42.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so8331428pju.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jul 2021 23:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iecH09b7HqGULzKRar6QvP6MSKtrjyPzZdrhashSeis=;
        b=ndoti6DiRvE+KcvcQIpqizdBVwP9SufbWmadKjOl+t84GZMQ4R1F0pEKG3OhXJi/b4
         +jZ5sSaCyFyUDmPdo6RppEE8pdNJTeOnhf52xza3ICipjT+NvTsSvpOapvVgrcLJd2oG
         Re/bJnuB4LAK9hTg+dmMXqP+1KGOEIY3Tz2JhlDCG1gljVCrWLTzGd9s9I9gBSFXAuok
         8+IQYP67H75Q1EA+PJ1mFIO5qKEvKmFWxAqFaOpd3Oi8hUigUgjL4JHaQyLL3J8eQaGy
         w3IcjAU3jATzumEpwgdv2o1ncrZpea7TGrV9t2XvMAbBHsmxZRZ+ERozUlcQcPoHHQ9Z
         jEKg==
X-Gm-Message-State: AOAM531V/3pNx46cnfxuxZsyy92n+XIJjP4tiXUcr3zcOTX+LZWfK2kO
        K/isDvQYBhqjnVYszuSCd6I7f1WLOHw=
X-Google-Smtp-Source: ABdhPJyVeqq48WLZr9OvVk5En15/bxWx6SqptqJJP7c2a8W5YwU+1ppbmHvvGq3jE5ISGqtGX7r9Ag==
X-Received: by 2002:a17:90a:6d82:: with SMTP id a2mr13433583pjk.150.1626502003218;
        Fri, 16 Jul 2021 23:06:43 -0700 (PDT)
Received: from [10.0.0.146] ([162.211.128.122])
        by smtp.gmail.com with ESMTPSA id y1sm13263460pgr.70.2021.07.16.23.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 23:06:42 -0700 (PDT)
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <64771d4b-38e6-6081-dadf-cae0de44c591@grimberg.me>
Date:   Fri, 16 Jul 2021 23:06:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Hi all,

Hey Hannes, nice progress. This is definitely
a step in the right direction.

> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit especially
> for NVMe-TCP here's an attempt to implement it.

Please call out the TP 8006 specifically so people can look
into it.

> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.

Glad to see this turned out to be very simple!

> Also note that this is just for in-band authentication. Secure concatenation
> (ie starting TLS with the negotiated parameters) is not implemented; one would
> need to update the kernel TLS implementation for this, which at this time is
> beyond scope.

TLS is an additional effort, as discussed, inband auth alone
has merits and we should not lock it down to NVMe/TCP-TLS.

> As usual, comments and reviews are welcome.

Having another look into this now...
