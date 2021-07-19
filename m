Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631FDC636C9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470B26115B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhGSIku (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:40:50 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:33397 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbhGSIkt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 04:40:49 -0400
Received: by mail-pj1-f44.google.com with SMTP id v18-20020a17090ac912b0290173b9578f1cso11107188pjt.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 02:21:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=eTqiBY1MaK4mNFF85OSUTXnYBMPiNTVDEjbv2PoI2huMP8Gl5eXOHy5JIOQzJiaLeh
         6FnFhq6AukwSFlJIpZfZnc0zBSLrDVz0GzQAKN0xNc2aYCyvRjmVCZim1RBBm3EOJprn
         8Z2c6lYS02wiC3CwKS6kmjLUyGh0rjxGQ9hv5Jm3Ii0cckRcwC52hDjOPpJf227+UxIB
         9MtvYnFA4VlmmlKq/qU3cnBe1Ox3x9eK7mYapTWlUDtdDPIGMylZ0xZWmvzaLUrI2x8P
         xPkSWhfYFGCU4Zt50rlHGeDGBWInppoWR2SpwQMqifkGOJylbpY/qOTBtYJUDS/Tzq1b
         /7JQ==
X-Gm-Message-State: AOAM530RrtC86N4Pd1tJRsB22P4GDiP9FNYOOtbG9P8gEdIRqvCjedwD
        qRY5EX41rBzbBSIiayD3jXsgIPYIM3o=
X-Google-Smtp-Source: ABdhPJzRipXFPTOD0+JVvSxPxrq+277fDIiQ0W18t5/nck3nY+AO6FxOTKOj9WuRvL/yJlhkx21wRA==
X-Received: by 2002:a17:90a:6686:: with SMTP id m6mr23476110pjj.109.1626686488611;
        Mon, 19 Jul 2021 02:21:28 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:2ce3:950:ff23:e549? ([2601:647:4802:9070:2ce3:950:ff23:e549])
        by smtp.gmail.com with ESMTPSA id i8sm4195038pgj.78.2021.07.19.02.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 02:21:28 -0700 (PDT)
Subject: Re: [PATCH 08/11] nvmet: Parse fabrics commands on all queues
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-9-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <e70e6c61-05b9-5918-b8d9-09169253968b@grimberg.me>
Date:   Mon, 19 Jul 2021 02:21:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-9-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
