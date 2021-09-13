Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EB3C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F74A63227
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243197AbhIMN76 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:59:58 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:33634 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245706AbhIMN5z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 09:57:55 -0400
Received: by mail-wr1-f50.google.com with SMTP id t18so14903930wrb.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2021 06:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=GReQ9phPUKe/hbWb24DuU9qBGFEtDm5hQ8bHMJ6XUAlW9ctSnIsjG36tdBNxBSLCme
         jo/nm38sdWQ39s/uOOYulLMuicKQ0KbZm0nAwr4gRvOXEKCIU+ymZFuIJG6i9Ss6kuOo
         tgUS9vvxgkrgqehU4lFKCmRq4YZbbM/9urg/ah1Tdyb1KZwRUw2Omu6xijKyT2BHZY4l
         WkSVHF7GuHji/qstWdMpfwfQQNBs+m+QcH2qL5rjJGeDoNO9hnkNidpl2LKkRxe1bXhd
         zhOCPR2Ri/gCSngPjq1khJKslS199hZ4NtsSeRACIPJWSTzfPUUPeFXme7hFQ0auXu9p
         LRjw==
X-Gm-Message-State: AOAM531Dp1zYvlqVSWHv3rp9xqQIJE4tRkVI6m5eU/x5yJiHW6nu2f3k
        5sSVdm2zveCiUuWvq7rlCdLNnvQDo/Y=
X-Google-Smtp-Source: ABdhPJwGAeUwYWWh8DuyIIS+KhDQ6obsRHVANfkl7HEXKftFOHbkntJbkL4c5r1WdwaH7OZ4HcxAYw==
X-Received: by 2002:adf:eb83:: with SMTP id t3mr12461437wrn.365.1631541398005;
        Mon, 13 Sep 2021 06:56:38 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id z13sm8651351wrs.90.2021.09.13.06.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:56:37 -0700 (PDT)
Subject: Re: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-10-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <af9e417f-fb76-87dd-506a-39dcf9897b3b@grimberg.me>
Date:   Mon, 13 Sep 2021 16:56:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-10-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
