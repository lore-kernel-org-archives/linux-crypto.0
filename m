Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D9CC12002
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0C36108B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhGSImp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:42:45 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:39656 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbhGSImp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 04:42:45 -0400
Received: by mail-pf1-f175.google.com with SMTP id b12so15934874pfv.6
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 02:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=puHlGDARRKbSpOH7EGqRKL60GpYMbcmkXPxSTYDDiuw=;
        b=YEatLa6HWxyXV/9Q38RMdijuM8Z7hGl3fGt6MbIFKq5yTj1Dy8A+ozdmAJPB5WFYq9
         2dc3EdTlgs73j9InnL2CqSCG1ATW+lXz1uGLTgOr0CaA4V1Ahng9LVaju6Ms+lDjjY/3
         Q0yP6vplPcbNOAV8foMhPqne5w5BDweYl5W3sAcziITbhs4b14NW0Sbh6Yp2g6q89lfk
         2tdA28ilhakRfNQ3RXs/KDGu47FW2gHT9QDTF92pN7AvIonOpMP9j2W42cuqh2Bnak5v
         TkYe+sbJoZWFlXpVVnJDuU8HD3bCVzmuAIbWJJCtHo33+iu4ZbiLvH0xSTuIqm7If286
         WpAw==
X-Gm-Message-State: AOAM533NHQ8hBg6oZ7ZLrQoY1+/O5sX7VKGsXhESJn/M68dAwIcIYdV1
        b8VFdIzI4Sj75wHVzv3LCV3GgJYYGrE=
X-Google-Smtp-Source: ABdhPJxjn+oa7V92P0qr18bpUnLbzboWRXrQE8pmhZpsJ3xLgnGfDN0qpo5rVoFrh0tQLM9mWoaWYg==
X-Received: by 2002:a05:6a00:a8a:b029:30c:a10b:3e3f with SMTP id b10-20020a056a000a8ab029030ca10b3e3fmr24830768pfl.40.1626686604790;
        Mon, 19 Jul 2021 02:23:24 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:2ce3:950:ff23:e549? ([2601:647:4802:9070:2ce3:950:ff23:e549])
        by smtp.gmail.com with ESMTPSA id l6sm19238862pff.74.2021.07.19.02.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 02:23:24 -0700 (PDT)
Subject: Re: [PATCH 11/11] nvme: add non-standard ECDH and curve25517
 algorithms
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-12-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <9ac44322-5c89-da94-b540-6086d2a32bc2@grimberg.me>
Date:   Mon, 19 Jul 2021 02:23:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-12-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> TLS 1.3 specifies ECDH and curve25517 in addition to the FFDHE
> groups, and these are already implemented in the kernel.

So?

> So add support for these non-standard groups for NVMe in-band
> authentication to validate the augmented challenge implementation.

Why? why should users come to expect controllers to support it?
