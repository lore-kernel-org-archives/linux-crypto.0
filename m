Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD81BC4167D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C966661407
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhIMNbf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:31:35 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33661 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbhIMNTl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 09:19:41 -0400
Received: by mail-wr1-f47.google.com with SMTP id t18so14705921wrb.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2021 06:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=5AQ3GHXZnJH7A2xYeUPp9GxyabloHrWmshYsyf+QZkqp3Jw1jetuzT2kkreldl6xkf
         znnAvgPulfVrONhHHDCcQGaZhYYyttAf/P0xkjyWwEF7lD+Hu+WyhayHqtOgcKNeTTfk
         lgvgedGqPdwd10FPCHDeyrLQLJBmvFsuT27TZMr++4v5NnRA/vu8nYqvbOPNvrF7ajMZ
         v5wdgEKKs/0EaRVvpUknMLrl3AfJI4QnDVWXJhJdOYbFdt6/m6BKE65QCuS4hrrQqBdt
         dU1dBn1xiG+87ZY1N6fSztfVGB9TLm7kn4V2Jaf3cE5gfm9T5C6W/H48vUMP9uFanTdU
         //7A==
X-Gm-Message-State: AOAM531vlmnOxqK8exAyLPmVWGq7aJsqYIKOoypmO/crBB9xIBK09dMM
        qyIPtCQzK58pAqTG6JU02WFoOTelOUQ=
X-Google-Smtp-Source: ABdhPJyvq1YZ29jyMPrAeiPwieH1Ppp25tRgb4kqv/5IbJ8qem/xvNBF88vHAv20dclORuRv9/sC4A==
X-Received: by 2002:a5d:668c:: with SMTP id l12mr12263202wru.436.1631539104292;
        Mon, 13 Sep 2021 06:18:24 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id r2sm7873142wrg.31.2021.09.13.06.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:18:23 -0700 (PDT)
Subject: Re: [PATCH 05/12] nvme: add definitions for NVMe In-Band
 authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-6-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f3747df8-e695-3363-30c9-da12074707de@grimberg.me>
Date:   Mon, 13 Sep 2021 16:18:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
