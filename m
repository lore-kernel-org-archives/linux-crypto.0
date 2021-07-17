Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C7AC636C9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E386115A
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhGQGTg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 02:19:36 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:45722 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhGQGTf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 02:19:35 -0400
Received: by mail-pg1-f180.google.com with SMTP id y17so12123311pgf.12
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jul 2021 23:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLOwrRZ8XdTMGJ02GNn5GwoySVd4zqzZ4mVDU+aI7bo=;
        b=SA8Q0ZnwP/JuTY1usbZxGymm4sB4bZuTsF8ztlELpkG4EJT3/x3M8nkFpqLCwaEt5D
         rFoaPxl+TZxRh5GjwDeOOELSns8yfzPCVD9F8X6NU2cm11IEC2QIdhaEIE7rT8rwAfkA
         k55+YQvXiwNLozJ3uyIibfvLFZufgYlujyUFGHMKx6Klby/W/JET1K9bEP6Uija8CNdx
         D1ZNsBVzkJCFmJa6S2V4mmdA1gYU2A7VCo3weOrar+0laGJ/sSk/wWl/PF23SSyb8Br8
         5k24c+K+zJs6tfJLxtcYGZtVtN+tfBH7aiNps60xRm0Iw7dln316d/1ywc+M+QfvfT/z
         uv/g==
X-Gm-Message-State: AOAM5310v7RPFpB12Ae57KgOC64eQe9enKJCjLrc3KB6ooaCzITkOIro
        OcepnIZNeBQVF/05NjSVxIfvrdo85do=
X-Google-Smtp-Source: ABdhPJxaaJ0iaFKX76PA2pZ0+oq7YpgNagS7e+Rvp9/z8CXjlQsr+GsT5mWo0Wt2PcEf2iKZRJlGpA==
X-Received: by 2002:a62:cd47:0:b029:329:714e:cce2 with SMTP id o68-20020a62cd470000b0290329714ecce2mr14151344pfg.22.1626502599424;
        Fri, 16 Jul 2021 23:16:39 -0700 (PDT)
Received: from [10.0.0.146] ([162.211.128.122])
        by smtp.gmail.com with ESMTPSA id e16sm13978579pgl.54.2021.07.16.23.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 23:16:38 -0700 (PDT)
Subject: Re: [PATCH 04/11] lib/base64: RFC4648-compliant base64 encoding
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-5-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a6708951-76f6-21bb-f7fe-e4bb32cd0448@grimberg.me>
Date:   Fri, 16 Jul 2021 23:16:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Add RFC4648-compliant base64 encoding and decoding routines.

Looks good to me (although didn't look in the logic itself).
Can you maybe mention where was this taken from?
