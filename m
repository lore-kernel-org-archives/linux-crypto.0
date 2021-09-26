Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEA9C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Sep 2021 14:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5625A610A8
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Sep 2021 14:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhIZOc3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Sep 2021 10:32:29 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:33414 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhIZOc3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Sep 2021 10:32:29 -0400
Received: by mail-wr1-f41.google.com with SMTP id t18so43921474wrb.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Sep 2021 07:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GFrakaChpU71NHjRcWO+0wGjtZo3JZzVivsrYIGgJx8=;
        b=2ASrAJIXhH8Ys4BHOhkta2ajqD4RVQN1erWZGevdXQ2fKBmO8NZWTtfTzwCE9PhqbJ
         PP0jqhq3JoTp4ybSXrIwjFBIbvmQCv8/TVE1j5GYrAwsTsMJjPb9dVl+/Suj9dy0/3dn
         KyDPORXMRtL8DdLjZI9SIKHgH7nr9pUCaJXSL0QyhVjJfVKWeIFfOi4Lksv/Ys3tOxTW
         FaUGxx8tDJdl9x51ATWce1cpIYtYyWX76OUas84satLrPzRJ3gfkInZSreRq883DyBzB
         9n6gEJ8C17uqX7SOaEsy0ynfHwT4Xt5Sf94uIsoQWGCrn4+09PYYaiFXvQcCSsyVvsuk
         GD2w==
X-Gm-Message-State: AOAM532aEu60zaLGcwwfk6Kk+bRkc0A6llMpoJZYJisaiSug8EXNCFKi
        otw04B2sz7UHRmyEXJV20FuhprdtQn8=
X-Google-Smtp-Source: ABdhPJxBhO75Ijrh4mMBuQACXBz+X+J6JKleAMUY6oy62LWd4XDyCDWkVHHBSc59WXsWpr1HZF7+6Q==
X-Received: by 2002:a05:600c:1d05:: with SMTP id l5mr11425937wms.119.1632666651929;
        Sun, 26 Sep 2021 07:30:51 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id m13sm1041180wms.10.2021.09.26.07.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 07:30:51 -0700 (PDT)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-11-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <618db458-108d-859c-14ef-3977a34db95a@grimberg.me>
Date:   Sun, 26 Sep 2021 17:30:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
> +{
> +	int ret = 0;
> +	struct nvmet_host_link *p;
> +	struct nvmet_host *host = NULL;
> +	const char *hash_name;
> +
> +	down_read(&nvmet_config_sem);
> +	if (ctrl->subsys->type == NVME_NQN_DISC)
> +		goto out_unlock;

+       if (ctrl->subsys->allow_any_host)
+               goto out_unlock;
