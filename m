Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C6CC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Sep 2021 22:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE506112E
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Sep 2021 22:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhIZWG3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Sep 2021 18:06:29 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:38501 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhIZWG1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Sep 2021 18:06:27 -0400
Received: by mail-ed1-f52.google.com with SMTP id dj4so61050473edb.5
        for <linux-crypto@vger.kernel.org>; Sun, 26 Sep 2021 15:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4DT2MyPQOfWi6Pr3NZyecuQPpN7bAekvzDKni8mdusg=;
        b=NQeJLEsJ4wz5M/7fYlPeZKvwsxOMCJUZJWN4vb33tdVMqYtzod70z6aOB7vUiTcyqI
         M7txo9bK2kJMCE/tWcRI+LRhypr08T5mr2PdIktWEc6Wbh23otDb4z8YlB6l8lMh9rVe
         owM2RsunXj+spSjcyJd6r1nofXKOEvXdqG763VMGUr5czDjVk/AKPmhrlueTLKkV2Cqt
         ARzXwu1C4iUFc9Gh23eusACypA3Cyms7CJmh/Uv22LOBYn/2qpjNxZdH3n2WeXBdMa8Q
         Y8jWeAUggGQQpaCrs4BXnomCu311k+hYhWf0UfRePvwmOaQVZK6uQ3uONhl+QrP0GNZl
         kUFw==
X-Gm-Message-State: AOAM532e800bzS/8ycPtnV6P7pwshaFRbT1QDkM7u/IHZ0CkN6qrztXp
        gGjXYLgxlgvveoO7zMKfdHlOABQiqlQ=
X-Google-Smtp-Source: ABdhPJzPVcI9teOq0vmBN156Dq0w4WWWH0Qtr1ImfXz82iN98CHC+ve5E16aQdKcoTMVYVZ/S53V1Q==
X-Received: by 2002:a17:906:25d4:: with SMTP id n20mr23935276ejb.399.1632693889401;
        Sun, 26 Sep 2021 15:04:49 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id p12sm3307422edt.92.2021.09.26.15.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 15:04:48 -0700 (PDT)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <22a5f9bf-5fbc-a0d3-b188-c67706a77600@grimberg.me>
Date:   Mon, 27 Sep 2021 01:04:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +/* Assumes that the controller is in state RESETTING */
> +static void nvme_dhchap_auth_work(struct work_struct *work)
> +{
> +	struct nvme_ctrl *ctrl =
> +		container_of(work, struct nvme_ctrl, dhchap_auth_work);
> +	int ret, q;
> +
> +	nvme_stop_queues(ctrl);

	blk_mq_quiesce_queue(ctrl->admin_q);

> +	/* Authenticate admin queue first */
> +	ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "qid 0: error %d setting up authentication\n", ret);
> +		goto out;
> +	}
> +	ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "qid 0: authentication failed\n");
> +		goto out;
> +	}
> +	dev_info(ctrl->device, "qid 0: authenticated\n");
> +
> +	for (q = 1; q < ctrl->queue_count; q++) {
> +		ret = nvme_auth_negotiate(ctrl, q);
> +		if (ret) {
> +			dev_warn(ctrl->device,
> +				 "qid %d: error %d setting up authentication\n",
> +				 q, ret);
> +			goto out;
> +		}
> +	}
> +out:
> +	/*
> +	 * Failure is a soft-state; credentials remain valid until
> +	 * the controller terminates the connection.
> +	 */
> +	if (nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
> +		nvme_start_queues(ctrl);
		blk_mq_unquiesce_queue(ctrl->admin_q);

> +}
