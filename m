Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C10C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 22:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC346120D
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 22:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243090AbhI1Wib (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 18:38:31 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:39761 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243059AbhI1Wia (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 18:38:30 -0400
Received: by mail-ed1-f47.google.com with SMTP id x7so984854edd.6
        for <linux-crypto@vger.kernel.org>; Tue, 28 Sep 2021 15:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S1uMPmMDCuhl7hGahrzQNiphiHqo3gb8qEbVNkjuXtg=;
        b=Gq9mIBKrWXESnMLrzFyF1kPvmRlKabcsTiA3EnG1DJtxwC4r9oG7LuBn99oLABFlLG
         P6Ju5U8CVJJIpZv4L27tXVm7NhMx7C82+/DniOJrmtkRqew7DHY+jQMplvpNMds0/TmC
         nLsfzYeFLJ1zYyoOiqxk0maD0uzRgNdYZopWDe7wSprYNuFOwPjur4cEESRgCcpVwcQW
         yaUhbbFwedV2BcwXXEwksH8EUEivx/7YlRr9B3TDX8golq7OuHnQREI4WaoAo5qoAR6d
         ZOOE8gi/WG7pYJeVvZ9thcaXorZLyjHPi/6Rl/JGjoP4MJUg38ki40HZ6Sobwozsmpp0
         +BiA==
X-Gm-Message-State: AOAM532ilSfFX2aUbQ0gL24IF74Uo+dQIMb7c8aiT0C6fnUK8MU7g2on
        o93+djrZkCOMfdhdKo1St0tydgr6+l4=
X-Google-Smtp-Source: ABdhPJxR9giMtZqLl4BWZfAwyz74U2L8eyMtV4yDnOMe7oeocnJlrlxOCRf8G/qY9JnpOssU8JU7xg==
X-Received: by 2002:a17:906:86c4:: with SMTP id j4mr9446475ejy.355.1632868609382;
        Tue, 28 Sep 2021 15:36:49 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id e22sm254319edu.35.2021.09.28.15.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 15:36:49 -0700 (PDT)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-11-hare@suse.de>
 <79742bd7-a41c-0abc-e7de-8d222b146d02@grimberg.me>
 <c7739610-6d0b-7740-c339-b35ca5ae34e2@suse.de>
 <a2596777-25b2-f633-4b00-18b1a319c5c2@suse.de>
 <32d8f860-9fdb-606c-62b7-ad89837d8e71@grimberg.me>
 <2ccfb62a-d782-7bb2-4d41-6d1152851a4a@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <24d3ee65-83e7-c958-cd17-eb4351a8349c@grimberg.me>
Date:   Wed, 29 Sep 2021 01:36:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2ccfb62a-d782-7bb2-4d41-6d1152851a4a@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>> Actually, having re-read the spec I'm not sure if the second path is
>>> correct.
>>> As per spec only the _host_ can trigger re-authentication. There is no
>>> provision for the controller to trigger re-authentication, and given
>>> that re-auth is a soft-state anyway (ie the current authentication
>>> stays valid until re-auth enters a final state) I _think_ we should be
>>> good with the current implementation, where we can change the
>>> controller keys
>>> via configfs, but they will only become active once the host triggers
>>> re-authentication.
>>
>> Agree, so the proposed addition is good with you?
>>
> Why would we need it?
> I do agree there's a bit missing for removing the old shash_tfm if there
> is a hash-id mismatch, but why would we need to reset the entire
> authentication?

Just need to update the new host dhchap_key from the host at this point
as the host is doing a re-authentication. I agree we don't need a big
hammer but we do need the re-authentication to not access old host
dhchap_key.
