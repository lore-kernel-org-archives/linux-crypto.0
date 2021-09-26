Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB778C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Sep 2021 22:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B60D60F9B
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Sep 2021 22:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhIZWzZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Sep 2021 18:55:25 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:45930 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhIZWzZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Sep 2021 18:55:25 -0400
Received: by mail-ed1-f51.google.com with SMTP id dm26so27080534edb.12
        for <linux-crypto@vger.kernel.org>; Sun, 26 Sep 2021 15:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pBbbO+PVbgUmH26Rm8/4mkCm4rE5mxxrVZIdsIun8bA=;
        b=tX9hcwJqsAE5uzSZIf89qrvwfWrsVtDe8T3qRddFyWFx9+pZhkhH9wqNqrrgnYipGd
         t4mxJToGac7eILUbISnCjuHu9dAlTXNoAsuv2b2YmsUcLpyhji6DWQB7mIcojuWG55lA
         9CJrxVSwPJK7vKDzPNsX0Ds3r1nmjMA9c868O3qDeVfbqBHtco7JUNjYbFSDZjNLrFd0
         u+VbrLZonAMXHcMS6wpsbU7D2MXVt3xt6SSzw9mJT5hW4mjDfxxrQVtLH0K95/1ZI9tn
         Mup4On0dt8BqOepEla0YyeiuV6a1bPLIAtuL6Vyiws8Hw/VF/2lF3eH4myaNrHn4HToO
         b9Ow==
X-Gm-Message-State: AOAM532L5KKjPSs7hwE9Z6EgQ+GLuxNpEl3GM0BbXrjTTwf/dkwmSde3
        xG/ThHu/VGKR7fS2h6sdZi54GvqDOlU=
X-Google-Smtp-Source: ABdhPJzPRIwybTbcRRSdXa5IxMGckx6qNFyi83EHavtg1wDwLbN7olIyuva0yKX0u5XRoIDpxslBlA==
X-Received: by 2002:aa7:c2d3:: with SMTP id m19mr2270943edp.267.1632696827220;
        Sun, 26 Sep 2021 15:53:47 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id o3sm2262188eji.108.2021.09.26.15.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 15:53:46 -0700 (PDT)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <745c58b2-e508-25c0-f094-8d24af0631ed@grimberg.me>
Date:   Mon, 27 Sep 2021 01:53:45 +0300
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

Here I would print a single:
	dev_info(ctrl->device, "re-authenticating controller");

This is instead of all the queue re-authentication prints that
should be dev_dbg.

Let's avoid doing the per-queue print...
