Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A52EC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532B261222
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbhIMNXS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:23:18 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:38856 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240236AbhIMNUE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:04 -0400
Received: by mail-wr1-f54.google.com with SMTP id u16so14665425wrn.5
        for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2021 06:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=J0f/TLaG+KsXA2XXATxes20qrpz4JZYRNO20TbuomWVXcJNlCE23NRMIRLtdge+EGo
         RZ6kjw1g5CbIspbKHv0LOmyW7TegyyuVub3kULNHMCtBL42rDrYwef0qc16uN+gbOEYj
         T3I2OQygrMtipMa3MqauIv/gLdpDvN39TfFKUU654tkS2IhiXGrkWwH5qtjVwYxJFLUz
         u6ueAJt0rUIh9qc9WTk3hsyZFCsP/pecTk60ES0wl992Gn5hwjYd5uwvj1j9O0SvhPrf
         qhduvuQAiwyRyAzV0jmw7k/NYXAuNsrv4qgpFwwZBXi3M1djqCU67vVPTf5U/Sgp+cFC
         9kNQ==
X-Gm-Message-State: AOAM532G71LP44TMXODHeKonSqFUMgtRX0nG1sDLQQbgIqqaEUeLx6iS
        jqo80FK/GkhCrqrFRuVMZwvKxsjJpZE=
X-Google-Smtp-Source: ABdhPJw2d5dXfozJxJm2IyGT+H5eizuZ+3PAbEMkEPVx7Q9k62RIRgZNJ2H975OkMKk9p3L2jhM79w==
X-Received: by 2002:a5d:58cf:: with SMTP id o15mr12336494wrf.312.1631539127731;
        Mon, 13 Sep 2021 06:18:47 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id u13sm7325808wrt.41.2021.09.13.06.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:18:47 -0700 (PDT)
Subject: Re: [PATCH 06/12] nvme-fabrics: decode 'authentication required'
 connect error
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-7-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8f6460f5-14a6-83b7-1b2d-8453c74b7ad4@grimberg.me>
Date:   Mon, 13 Sep 2021 16:18:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-7-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
