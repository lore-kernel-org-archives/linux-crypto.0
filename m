Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E6EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 13:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhKWNOc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:14:32 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:41921 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhKWNOb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 08:14:31 -0500
Received: by mail-wr1-f53.google.com with SMTP id a9so38870921wrr.8
        for <linux-crypto@vger.kernel.org>; Tue, 23 Nov 2021 05:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hIgU0bK5U3yCEuWSX482p4gO1STEH+SNL6B2DSf7JC0=;
        b=Dwi/5zrFdTCCMtSPrhcDPjHUg5+kWYFRZ+rbAfzOxPeGPBqv9N9E8ubmxNC6tp9mqe
         c895qm/mtKzjr7euZZIwiNB53LKUe2x8mDF76O6tcRkU26uO/5+/6tg725U1EIgDcIlY
         kWIW4XDWyy+gbDjfNhwYEUbvd1YiHbf1BkhfnLJZXcoas6tc1SwlAC6ru2caGkxnzCU1
         b8LAS6S/zweKjoWdGhuCAMfriXLhWnVvpURvqrmM+dAtgcMzob+AQs+Z5zyvxa9N+QzW
         H4mhFz746nm5/qZ3ngCQOzwqZZEUj8qY6OT0QkdYxwETX2YFY1uJgofA0FpUgdJ945Qh
         Q5Yw==
X-Gm-Message-State: AOAM530eiCs2GPzNvWEogHdGIJ8xidyBWDd/l0SF7lNO6Y8vponcYisj
        A84b0trbJQqfr1zHuwRnaH1Cd6aFeIc=
X-Google-Smtp-Source: ABdhPJwQnprzp4GnEWbf56/MkuGm1MYO8ARdDmyNLi9xM7IhE1p4i4FhVyEGFiyYa3ZyQym1gi5oeg==
X-Received: by 2002:adf:d1e2:: with SMTP id g2mr7044819wrd.105.1637673082021;
        Tue, 23 Nov 2021 05:11:22 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id u23sm1118492wmc.7.2021.11.23.05.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 05:11:21 -0800 (PST)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211123123801.73197-1-hare@suse.de>
 <20211123123801.73197-8-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ffd1519b-1f39-898a-be7f-5d9db7377ad1@grimberg.me>
Date:   Tue, 23 Nov 2021 15:11:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211123123801.73197-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +int nvme_auth_generate_key(struct nvme_ctrl *ctrl, u8 *secret, bool set_ctrl)

Didn't we agree to pass the key pointer? i.e.
int nvme_auth_generate_key(struct nvme_dhchap_key **key, u8 *secret)

> +{
> +	struct nvme_dhchap_key *key;
> +	u8 key_hash;
> +
> +	if (!secret)
> +		return 0;
> +
> +	if (sscanf(secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
> +		return -EINVAL;
> +
> +	/* Pass in the secret without the 'DHHC-1:XX:' prefix */
> +	key = nvme_auth_extract_key(secret + 10, key_hash);
> +	if (IS_ERR(key)) {
> +		dev_dbg(ctrl->device, "failed to extract key, error %ld\n",
> +			PTR_ERR(key));

The print here is slightly redundant - you already have prints inside
nvme_auth_extract_key already.

> +		return PTR_ERR(key);
> +	}
> +

Then we instead just do:
	*key = key;

> +	if (set_ctrl)
> +		ctrl->ctrl_key = key;
> +	else
> +		ctrl->host_key = key;
> +
> +	return 0;
> +}

...

> +EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
> diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
> new file mode 100644
> index 000000000000..16e3d893d54a
> --- /dev/null
> +++ b/drivers/nvme/host/auth.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Hannes Reinecke, SUSE Software Solutions
> + */
> +
> +#ifndef _NVME_AUTH_H
> +#define _NVME_AUTH_H
> +
> +#include <crypto/kpp.h>
> +
> +struct nvme_dhchap_key {
> +	u8 *key;
> +	size_t key_len;
> +	u8 key_hash;

Why not just name it len and hash? don't think the key_
prefix is useful...
