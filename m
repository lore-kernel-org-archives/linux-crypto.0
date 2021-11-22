Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0C6C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 12:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhKVMGX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 07:06:23 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:35485 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhKVMGX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 07:06:23 -0500
Received: by mail-wm1-f44.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so16553854wme.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 04:03:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=ixcu/N513e0T3fiYCCnPycAQQSMcq1r6lnnKEuiS8lHnpMsxfF+wqTNaGFesWPIFDP
         g4ZqiwP0pQM46YeAh1NupteE5Lxak7EKPBpgsnvKHzx6omIFRxKovl9YDAizeh6PKB7A
         7glLIXkDPKuIEfLcf2vkhg0z2MmI+IUtVzGecBzJJ+pHxkzdtIUHOeTObHkNEyQV0xJh
         UbxSDiRbqvah+bGCSWfJobOCQvBK5lncAupMXO8ssCP7JbmRSeqiui5yFMKKuCr7xVwW
         D6Nz0e6CvK1IDCQs8FF1uCEmxHPewnhfp15xJ3etda8MFvW0CqQc0ouT8PlluZTcirIx
         vk3g==
X-Gm-Message-State: AOAM532fBaLQ6jyuaT7QfR8h/T778fNlyqYcbUmY4hQIDi6dh8+mgz2o
        mf9zMj14i82lc2uP8ay7pFb5nTl6Kzk=
X-Google-Smtp-Source: ABdhPJyupoS1CSiNI91xI7f0MPG7MWRhNtDsiQ+SQY6mxluY+ZtdMXsQ0JryEkb1nVuj3h3rYpF7hQ==
X-Received: by 2002:a05:600c:21c3:: with SMTP id x3mr28175396wmj.13.1637582596198;
        Mon, 22 Nov 2021 04:03:16 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id y6sm9123974wrh.18.2021.11.22.04.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 04:03:15 -0800 (PST)
Subject: Re: [PATCH 12/12] nvmet-auth: expire authentication sessions
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-13-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <c7a597fa-67c2-ba9f-8a2e-12120ed80f1a@grimberg.me>
Date:   Mon, 22 Nov 2021 14:03:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122074727.25988-13-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
