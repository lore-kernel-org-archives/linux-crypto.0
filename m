Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CF5C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 20:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792F46152B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 20:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345675AbhI2UDz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Sep 2021 16:03:55 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:42747 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345747AbhI2UDy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Sep 2021 16:03:54 -0400
Received: by mail-ed1-f41.google.com with SMTP id bd28so12906386edb.9
        for <linux-crypto@vger.kernel.org>; Wed, 29 Sep 2021 13:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nTIu0JjIE9yiescS44nr41e9dJfc3HwjuPicp2NLKZk=;
        b=GEDZk8BwNQtpJtFF+hn/bBckwEyAYPwRvTVfC5UGdGUKkVT+X++oKO5e4y4gO5A0dA
         UsdTqIEim15yrv1FxGLsak2kczEgh+YbCCZ19HvRtvCS1eNP2mrqw2JHu96Oft/wthho
         oEPyZTTKS2VeuK/tP2y+V98n4zXifYl/w0L8DdjxLwdxEjKlntnBiZHnUAYc951Dgz9B
         dPbAURS/+Z8W379U9uD0r8o6BTdd9iv/dH16xwvf/UbPhE6wGY+yZDMbKIW7fAyKk4gW
         4/kUmpib920d5FnInF/cEQYa9l+bU4a3IDfk5p6KlrpLMqxJ81ZeIdH3mnF5hJQEA5Zh
         l8qw==
X-Gm-Message-State: AOAM530V5T8fdPimFp72avC/irjCREdT3xr765UvejI2dJ0gMYNpakcX
        PGyUwkcYs0yo0alYN57FhJi/fekw7u4=
X-Google-Smtp-Source: ABdhPJw1PJ/QsV2JRoMrh3irx4PCe7jSiTcGUcDVgp3OIA9vaDfqJjkLbgIxP+WUzOkDOH/6cz0nrg==
X-Received: by 2002:a17:906:5cf:: with SMTP id t15mr1985852ejt.375.1632945732121;
        Wed, 29 Sep 2021 13:02:12 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id 19sm474539ejw.31.2021.09.29.13.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 13:02:11 -0700 (PDT)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210928060356.27338-1-hare@suse.de>
 <20210928060356.27338-11-hare@suse.de>
 <d8827017-f8a7-c1fc-1950-8ac6c5997103@grimberg.me>
 <d1f4cd0c-1d53-6eff-83e2-d1b4d04b7221@suse.de>
 <e876b96a-e24b-d0de-0c62-d4345c4f8714@grimberg.me>
 <c1c90d31-a4c3-ab13-2f29-55a103715ef8@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a850b479-cea5-fdf3-2ea8-00a2b3e601b5@grimberg.me>
Date:   Wed, 29 Sep 2021 23:02:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c1c90d31-a4c3-ab13-2f29-55a103715ef8@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>> On the target:
>> # grep -r ''
>> /sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress\:uuid\:b73ff014-2723-4114-aa8d-2f784ecba4f4/
>>
>> /sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_dhgroup:null
>>
>> /sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_hash:hmac(sha512)
>>
>> /sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_ctrl_key:
>>
>> /sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_key:DHHC-1:03:KUwVlIUo627Pn05W/lRL2XD57kzIs1yZzJWdd2vgZJUC74kr:
>>
>>
>> On the host:
>> # ./nvme connect-all
>> --dhchap-secret="DHHC-1:03:KUwVlIUo627Pn05W/lRL2XD57kzIs1yZzJWdd2vgZJUC74kr:"
>>
>> failed to connect controller, error 5
>>
>> On the target dmesg:
>> [ 8695.716117] nvmet: creating controller 1 for subsystem
>> nqn.2014-08.org.nvmexpress.discovery for NQN
>> nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4.
>> [ 8695.749996] nvmet: creating controller 2 for subsystem testnqn1 for
>> NQN nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4
>> with DH-HMAC-CHAP.
>> [ 8695.755361] nvmet: ctrl 2 qid 0 failure1 (1)
>> [ 8695.755449] nvmet: ctrl 2 fatal error occurred!
>>
>> On the host dmesg:
>> [ 8781.616712] nvme nvme1: new ctrl: NQN
>> "nqn.2014-08.org.nvmexpress.discovery", addr 192.168.123.1:8009
>> [ 8781.637954] nvme nvme2: qid 0: authentication failed
>> [ 8781.638084] nvme nvme2: failed to connect queue: 0 ret=401
>>
>> If I change the dhchap_hash to hmac(sha256) authentication succeeds.
>> The failure with hmac(sha512) comes from the above condition as the
>> host is sending key length 64 and nvmet is expecting 32.
> 
> A-ha. That shouldn't have happened; selecting the hash on the target was
> _supposed_ to be reflected to the host.
> 
> You did mention something about blocktests; guess I'll need to bite the
> bullet and actually implement something there.

That is why I mentioned it ;)
