Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB610C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 12:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhKVMJ2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 07:09:28 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:35347 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239469AbhKVMJ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 07:09:28 -0500
Received: by mail-wm1-f41.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so16563328wme.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 04:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=1y7nX81/GqoD4dcvkbJyoyKjrWO45TWTbeMeujjasnq7VsVdqrhFZD8wkOARFRC1No
         BQGPiMUAYRaOIuv36yvZ1P8gLaWK12b+fbPDVub3dGDW+IyzvV/W3itnmdgAISKNvMKv
         ZrT1B6P1vpmaWDjJOKeBXeX51+joUaHm4ivd/Qdyf04E4tQe0GZBB7a36p7G/ykQVWNG
         deohqbvYR0BN0/+kESQhFPIliMNIpKK8p7A3/TxzqFmuEvWKOGEcvN5IMe7tIAw/dIZX
         65AfRO801ybLK9rcXGIjpiEJwTLHN4YstpQ+3qOYikd1jIgVvaERDSs4qvLA+KS3iBmJ
         xu8A==
X-Gm-Message-State: AOAM530CludCRfbc86VTu0b+g2++MbhKBxPNzzJG/gMSUNMOxHHzOIsc
        SNcozmxD3wFjW8TheoV6DEo=
X-Google-Smtp-Source: ABdhPJxL4LIU1rFckMrmqPa9CPngiVCGd1uI5OOln874UTL90pfeQ1pCpyY7Db9shRBpxMU9Qmwl6w==
X-Received: by 2002:a05:600c:ce:: with SMTP id u14mr23940394wmm.83.1637582780881;
        Mon, 22 Nov 2021 04:06:20 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id d1sm8458510wrz.92.2021.11.22.04.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 04:06:20 -0800 (PST)
Subject: Re: [PATCH 04/12] lib/base64: RFC4648-compliant base64 encoding
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-5-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <baf279df-257c-dc78-2205-ee68df8f7bcc@grimberg.me>
Date:   Mon, 22 Nov 2021 14:06:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122074727.25988-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
