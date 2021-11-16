Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDB2C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 10:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C7C63219
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 10:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhKPKig (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 05:38:36 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:34362 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbhKPKid (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 05:38:33 -0500
Received: by mail-wr1-f41.google.com with SMTP id d5so36603874wrc.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Nov 2021 02:35:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6TRyWlIO4zHFM6tgCDl7yl5O1itcO3INiM0UIvIWRP4=;
        b=4TViS5EAUUAe0dqMohE3EZnhq/V4eNDnv/HSsm3F7l0xlapxrirPnpG4/rMx8O7NWg
         izG+YK6IkkBp5ybJvvD368C74mvvIV8hcV6w2Ns7lpbBLlJAkkxgm+Abmwd+sBTiRIVa
         JkqGLxd9wu6Q7g/XeyGgZLDXVdcVeliRFzSyfF2Fb8+SLmPhQVPho7LXzQcgf4FHfvgt
         rRmsRNAM8lTN/z2UQ9x4BWJKwckVchw3Phk0PAXXaoORSGbEuDcmHeBOUIVDeZDACMwx
         ew3gy6ojLJvA2JiEMnJ7q1SZgP/aoPbNLc4+YkVwcRpC636cpQfkPHMShYXwDWqtoZ1b
         J8ZQ==
X-Gm-Message-State: AOAM533n5OnLAhhCZGmdfheODBFNF7n3HOmq8Jo45dSRZEsS0iJhHWmX
        xI5cTKyZVe/IZJ6tisp4mbDqiTT6+kA=
X-Google-Smtp-Source: ABdhPJw/zgBsmOUoe87mnOZyQwdyZix9mDhDZJGnsPKZkSsT9t3tWZVZuMQLDopMDBCK0zOa7z0tZA==
X-Received: by 2002:a05:6000:1868:: with SMTP id d8mr7757927wri.285.1637058935653;
        Tue, 16 Nov 2021 02:35:35 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id s24sm1928570wmj.26.2021.11.16.02.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:35:35 -0800 (PST)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-8-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ce8ad3e5-6f18-0ffa-33b4-11e52b39e1b4@grimberg.me>
Date:   Tue, 16 Nov 2021 12:35:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211112125928.97318-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)

Maybe better to call it nvme_auth_dhchap_setup_host_response()?

> +{
> +	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
> +	u8 buf[4], *challenge = chap->c1;
> +	int ret;
> +
> +	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction %d\n",
> +		__func__, chap->qid, chap->s1, chap->transaction);
> +
> +	if (!chap->host_response) {
> +		chap->host_response = nvme_auth_transform_key(ctrl->dhchap_key,
> +					ctrl->dhchap_key_len,
> +					ctrl->dhchap_key_hash,
> +					ctrl->opts->host->nqn);
> +		if (IS_ERR(chap->host_response)) {
> +			ret = PTR_ERR(chap->host_response);
> +			chap->host_response = NULL;
> +			return ret;
> +		}
> +	} else {
> +		dev_dbg(ctrl->device, "%s: qid %d re-using host response\n",
> +			__func__, chap->qid);
> +	}
> +
> +	ret = crypto_shash_setkey(chap->shash_tfm,
> +			chap->host_response, ctrl->dhchap_key_len);
> +	if (ret) {
> +		dev_warn(ctrl->device, "qid %d: failed to set key, error %d\n",
> +			 chap->qid, ret);
> +		goto out;
> +	}
> +
> +	shash->tfm = chap->shash_tfm;
> +	ret = crypto_shash_init(shash);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, challenge, chap->hash_len);
> +	if (ret)
> +		goto out;
> +	put_unaligned_le32(chap->s1, buf);
> +	ret = crypto_shash_update(shash, buf, 4);
> +	if (ret)
> +		goto out;
> +	put_unaligned_le16(chap->transaction, buf);
> +	ret = crypto_shash_update(shash, buf, 2);
> +	if (ret)
> +		goto out;
> +	memset(buf, 0, sizeof(buf));
> +	ret = crypto_shash_update(shash, buf, 1);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, "HostHost", 8);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
> +				  strlen(ctrl->opts->host->nqn));
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, buf, 1);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
> +			    strlen(ctrl->opts->subsysnqn));
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_final(shash, chap->response);
> +out:
> +	if (challenge != chap->c1)
> +		kfree(challenge);
> +	return ret;
> +}
> +
> +static int nvme_auth_dhchap_ctrl_response(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)

Maybe better to call it nvme_auth_dhchap_validate_ctrl_response()?
