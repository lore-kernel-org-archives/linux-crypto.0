Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17223C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF4F26103B
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhIMNRQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:17:16 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37752 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhIMNRQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 09:17:16 -0400
Received: by mail-wr1-f44.google.com with SMTP id t8so9608087wrq.4
        for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2021 06:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=6mYgJIkCxDHEHk4I6E/2Xq5j3cGcotjcac4ziYET/Z6pAzZVZ/Hhl9YnT0s6nDTtJ7
         5RQFUje1+Ksvgxb08shxvQQ5e5rz0cpGgmHjtmTYJ//6oPqH3tZcGrdOgm6fKvwGBJV7
         p32ZTyPz3zNbqw7j/iQM2pS9OAXKhYfotg+pw63IYtTEhkmP6krLkIecS6eOY1GKNDQu
         qbQCY5pts9nty3PpOuTaa+YVGGO0sAzG/MjZflcQj82nL28Zq7hOV0WooS7GFXFRseFT
         niUmZj/aBdI1G8A6ydZOvgRYzPwgoa51ImOWZbOYLCWFSZzyN1nHXSfLrs/Ko94DPU5N
         d2Ng==
X-Gm-Message-State: AOAM532139Kz1vVC0RjfJaAx7MCBK0l0JBtlwfHXFf1ZU5ikeYhp7cJ7
        95zD5wMUd3AmSb4xK95rnYTEhfIoE+8=
X-Google-Smtp-Source: ABdhPJxFgeh4+N3wpZmHrqmgbG2kFVg3bcDyohXhCvE1/hCk30HeAA5pubOAFoAdz4U2cEWP72hMzg==
X-Received: by 2002:a5d:58e9:: with SMTP id f9mr11291202wrd.325.1631538959458;
        Mon, 13 Sep 2021 06:15:59 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id b16sm7535459wrp.82.2021.09.13.06.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:15:59 -0700 (PDT)
Subject: Re: [PATCH 01/12] crypto: add crypto_has_shash()
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-2-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <fd70f87e-9890-22a8-ef80-f221eeece498@grimberg.me>
Date:   Mon, 13 Sep 2021 16:15:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
