Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36869C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 08:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKVIPs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 03:15:48 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:41498 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhKVIPr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 03:15:47 -0500
Received: by mail-wr1-f50.google.com with SMTP id a9so31054294wrr.8
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 00:12:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JRZOr9ReNxwdbK656KslzswFIwdKmvYGDm2UvqThBQg=;
        b=FdVu5foh5uWN8DZojWQY3B0AhAaD93iMyoTPlmEg4PvhnIBz24CdUSf3rfDb0eXn2W
         s+1dxwYZW6hmj89XjM9dbdZFJm8s2w20Bohjtq4tY4i003d33bPtX2Ug0/6hglkr28zg
         CnJv9rq6FVxaJ8bcbVdEmh/PP9wh6XP0xWjki3HWZNXyDwS/Kw0fAdtZMNHbM9V+WCRf
         3IefsQZmMr1P+2xJsJ8hGzAwePOxKciJchkwJ1ZtLUAWdqWuqMJjoZUb7SH3wcvxw/kH
         4kwsV0DE+ulRjf57pQaeeS11ldpfS2SDCSjw+Z22r/LtxNkaetNmIfLrh2k2+FfM16d1
         P71g==
X-Gm-Message-State: AOAM5309gMr0qW3YtMJKi7Hy4dVeb+DxuH6R0k0OzJdTP7AeZKqSkwtX
        h4LYIazA5zYlN0RappM75A5bwSg9mBg=
X-Google-Smtp-Source: ABdhPJyfwX7jIq5oVb8kvi33y1Hx/2Dj4OOmd2n8lkGhOSruHCErMl203NTR8e0/rFxK0E49Ikg/jA==
X-Received: by 2002:adf:eac8:: with SMTP id o8mr36537759wrn.337.1637568760405;
        Mon, 22 Nov 2021 00:12:40 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id d8sm8206214wrm.76.2021.11.22.00.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 00:12:40 -0800 (PST)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-8-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8f6c144d-0354-2753-ab58-1f5cabcafbdd@grimberg.me>
Date:   Mon, 22 Nov 2021 10:12:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122074727.25988-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +int nvme_auth_generate_key(struct nvme_ctrl *ctrl, u8 *secret, bool set_ctrl)

Maybe instead of set_ctrl introduct struct dhchap_key and pass a pointer
into that?

> +{
> +	u8 *key;
> +	size_t key_len;
> +	u8 key_hash;
> +
> +	if (!secret)
> +		return 0;
> +
> +	if (sscanf(secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
> +		return -EINVAL;
> +
> +	/* Pass in the secret without the 'DHHC-1:XX:' prefix */
> +	key = nvme_auth_extract_secret(secret + 10, key_hash,
> +				       &key_len);
> +	if (IS_ERR(key)) {
> +		dev_dbg(ctrl->device, "failed to extract key, error %ld\n",
> +			PTR_ERR(key));
> +		return PTR_ERR(key);
> +	}
> +
> +	if (set_ctrl) {
> +		ctrl->dhchap_ctrl_key = key;
> +		ctrl->dhchap_ctrl_key_len = key_len;
> +		ctrl->dhchap_ctrl_key_hash = key_hash;
> +	} else {
> +		ctrl->dhchap_key = key;
> +		ctrl->dhchap_key_len = key_len;
> +		ctrl->dhchap_key_hash = key_hash;
> +	}

Then it becomes:
	dhchap_key->key = key;
	dhchap_key->len = key_len;
	dhchap_key->hash = key_hash;
