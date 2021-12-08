Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC727C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Dec 2021 12:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhLHMvA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Dec 2021 07:51:00 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:42799 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhLHMu7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Dec 2021 07:50:59 -0500
Received: by mail-wm1-f42.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so1719703wmd.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Dec 2021 04:47:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=7UZ3PObd9XM9920qAFhusZ6Y6lLkTlnyN+qYLNiW40bwJq9YoReE44ES/R494wF4am
         zVrQDkJBCkYRlGYvs5wYzrnjLtup7BoBGvz+FosfozQNhAFarPqRj9yOn2CPmvTozGLv
         kSPAKFwIXeEbo3SBqMitOLZsA6gvFXJseL8o5NGY0kZEgrXX7dYtto1pG7VOOZSmSfIW
         i6dkcIUezKtKT/TDVgcAO54FJpPmIekn9QQN2bchp9VLZ16g9GoXYEVCgVSwLF0Ehuor
         bOFDwe9YVVmqXJOQd2x2CkfqmyLJzX1imlUznHlZxKsN7NznG41iYhc4RyJ9NnTI6MyD
         aElg==
X-Gm-Message-State: AOAM532ZkT8JAn/godCaOdlFbyDiBIpQTAwZjDmBfgFGCcbCTDluE2IX
        twqVjRDHuixEQE9hPmukZozqrDvdU4I=
X-Google-Smtp-Source: ABdhPJwfww/q8VLl+i1g3RiXHzyWhPEY6AxeCyNivu8cc3kwiMTrbgdOyHsTXzeY4+qSw2EfNENq9w==
X-Received: by 2002:a05:600c:4108:: with SMTP id j8mr15680464wmi.139.1638967647167;
        Wed, 08 Dec 2021 04:47:27 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id r8sm3316380wrz.43.2021.12.08.04.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 04:47:26 -0800 (PST)
Subject: Re: [PATCH 09/12] nvmet: parse fabrics commands on io queues
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211202152358.60116-10-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <42582bda-2438-309f-ce71-2cddc831deef@grimberg.me>
Date:   Wed, 8 Dec 2021 14:47:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211202152358.60116-10-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
