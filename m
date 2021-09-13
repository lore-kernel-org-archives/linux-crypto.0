Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3DFC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 133ED6103B
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 13:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhIMNRW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:17:22 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:35750 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhIMNRW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 09:17:22 -0400
Received: by mail-wr1-f51.google.com with SMTP id i23so14668967wrb.2
        for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2021 06:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=5+FmCXuXY9nhfsAoxiVtuL/qZu5C2xjLyCANKcbB+jH0FGrBUMxgs5zBJCxPxYOZIV
         dwQlgBnQJ9nWyfzdy/qYSZVLNBRZyBv9BGhdCxCUwolSF1Nf88On6N57wwVHWCAoCiZF
         +ND7a+RrUW/99SgRiSJPyz+ZkvCZv/dxmZkpitnUTdkF19Hf6zI0hiTbGbEmx2nV14DJ
         m5oqat4EAAdNTpLHhJLE4EpldGer5EAYG7ZwbUW+B+Q9uIYmn0CUA/mPSiFBo9kpX6qt
         8HqZs6Se89dhbDZ6xokjnwug1ye1cvG8MtLRawJyWgJwhE4m3vrb7lE1xNENjjLo48TG
         kl2Q==
X-Gm-Message-State: AOAM532TPRaRa4N5tWONPwKYd6j5XiSM2UqSqyOxl+xM3+JkV3fyPv+t
        LpiSjJpXB5bpjpnlolxVweEYYhuxR/M=
X-Google-Smtp-Source: ABdhPJxC2G+83Sn9m2HoK7rtfsVr7UeNIaPHspr5GhsqFvsj4Tog4ygakvq61LUuUsQ2iktHWnst1Q==
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr12479916wrs.71.1631538965422;
        Mon, 13 Sep 2021 06:16:05 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id l15sm6045604wme.42.2021.09.13.06.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:16:05 -0700 (PDT)
Subject: Re: [PATCH 02/12] crypto: add crypto_has_kpp()
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-3-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <9ce7e32a-7409-df05-ff04-10e8eaf0f22d@grimberg.me>
Date:   Mon, 13 Sep 2021 16:16:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
