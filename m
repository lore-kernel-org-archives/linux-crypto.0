Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D5CC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEC28610E8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhI0Hxx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:53:53 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38776 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhI0Hxv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 03:53:51 -0400
Received: by mail-ed1-f44.google.com with SMTP id dj4so65719308edb.5
        for <linux-crypto@vger.kernel.org>; Mon, 27 Sep 2021 00:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4OFhBs1l3mVS6Ir+myuYdrxMtCwqxgyKyqQ1V6PpYeU=;
        b=1Atho5FXu9fBO8IseER0+S5jFxQsWdqQwxAajJeQKSyh25e87/ny6+PNi8tpzcgqZT
         9qxrAko/jDNh7irKClSDVq95vHE5eJ92Qrktn2VAQWaRrZk5YNqP1fTuwdk3sF53cdKS
         JnJuHjBlX7DEqqE8WBRWCUigvQMAAQ68z07fSvDQ81s78jj775mFfYvwEXhqaVtPMuna
         qaXNYW8koZk7AMheN7E4D33mJRclco9pEjmGYg3XC2TsvMVVcmjqr6kxT9C99G9gHE+3
         ITlwOiSRppdxjiN2q63YLzDrZM/oqG0ErseVeLHo0/46IHQe2e7lfX7dVmENb7rdEUqq
         YOcA==
X-Gm-Message-State: AOAM5328zE8nF8w0sOBgQsK4m5zZpHc1hRHJ4HZEmI5L83QyfAqNVSfI
        ysMthQmakqIa1oU/C9FO85vfyUeNknI=
X-Google-Smtp-Source: ABdhPJyOfrmtxrcm19J/J1EYOAuyM6nZN7pRgijyXWvEKiZKK9k0wcqJUmkoYTDily41uv6ry7f/Qg==
X-Received: by 2002:a50:a2a5:: with SMTP id 34mr11426941edm.150.1632729132768;
        Mon, 27 Sep 2021 00:52:12 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id h26sm3776020edz.1.2021.09.27.00.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:52:12 -0700 (PDT)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <745c58b2-e508-25c0-f094-8d24af0631ed@grimberg.me>
 <0a7e7f2a-3f62-96c3-3b04-549afb8343ff@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <70d2b1af-fcf0-43e4-1083-1d8ba56e91be@grimberg.me>
Date:   Mon, 27 Sep 2021 10:52:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0a7e7f2a-3f62-96c3-3b04-549afb8343ff@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/27/21 8:48 AM, Hannes Reinecke wrote:
> On 9/27/21 12:53 AM, Sagi Grimberg wrote:
>>
>>> +/* Assumes that the controller is in state RESETTING */
>>> +static void nvme_dhchap_auth_work(struct work_struct *work)
>>> +{
>>> +    struct nvme_ctrl *ctrl =
>>> +        container_of(work, struct nvme_ctrl, dhchap_auth_work);
>>> +    int ret, q;
>>> +
>>
>> Here I would print a single:
>>      dev_info(ctrl->device, "re-authenticating controller");
>>
>> This is instead of all the queue re-authentication prints that
>> should be dev_dbg.
>>
>> Let's avoid doing the per-queue print...
> 
> Hmm. Actually the spec allows to use different keys per queue, even 
> though our implementation doesn't. And fmds has struggled to come up 
> with a sane usecase for that.

We don't need to support it, but regardless we should not
info print per-queue.

> But yes, okay, will be updating it.

Great...
