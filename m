Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC35C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 13:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C289361A56
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 13:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhKON4M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 08:56:12 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:41709 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhKONz6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 08:55:58 -0500
Received: by mail-wr1-f48.google.com with SMTP id a9so4670251wrr.8
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 05:53:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=fTVEPMw7T2YJapTQLeJB+XceMzCpixtSOXFS0+nGJ91g0UAWXXS7ax4iQK2Six+OS3
         pUrgtiXPQUG58N2reWVaQEmRgT+iq6pRMPIYBuHTUUSoqxX7qkMLk6VXhJBqBvy0U+CR
         eaf0fOkdc/fy2RFePzxUavvp4/v1EqrGC8b6iCcKzGVi1pCmmcrhfsomBbmyFxgxC7nq
         xAYz4ttHPrwXU9lLvJ+/kf9AQv8lQmXk15WCypQrYr7O5zLX+lIqAouNlvAIb5ZUdVmZ
         Tf0BccbvF4Drgl/jjU8rbiY2WOC0foK2E93CQle0DQBDh/NcXvtApeq4bx2JVjRRq073
         6daw==
X-Gm-Message-State: AOAM5317085mVe3I3IvV1eAO1FVJHKGjIVYRhMaROLjm4fk6sNqLbWqQ
        SVJ06WNS+bhzfAAOekpJYimpkV52AtI=
X-Google-Smtp-Source: ABdhPJzK7eMS1hwY+MoQbTGFv1Cot6XrOyknR0Pit0LgAdSGZfzMR02284vs9Zmiu3sSAU313saw7A==
X-Received: by 2002:a05:6000:1681:: with SMTP id y1mr47195169wrd.52.1636984381600;
        Mon, 15 Nov 2021 05:53:01 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p62sm12978354wmp.10.2021.11.15.05.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 05:53:01 -0800 (PST)
Subject: Re: [PATCH 03/12] crypto/ffdhe: Finite Field DH Ephemeral Parameters
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-4-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <34063c15-8f9c-b862-6a02-66cb2c904390@grimberg.me>
Date:   Mon, 15 Nov 2021 15:52:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211112125928.97318-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
