Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56025C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 09:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403FC60F8F
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 09:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbhIMJRV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:17:21 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:34708 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbhIMJRU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 05:17:20 -0400
Received: by mail-wm1-f43.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so4811469wmh.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2021 02:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UlWb7GG9KmgW1uBK20hHYqN4Cy+L80BmV4mPEcAhQv8=;
        b=6ppoNNIgtivWTlmaJKIDpPsw+K1HQTVAP3klfSnzu5+jwKAnxY/iNtT/jiydIqMIvN
         Obu+HFqT0GwKwQqibuCc+/sObMpnNWTaSKULAEkepINdbBBO/b51Dj84ocuuVif+smrl
         VH0kcgyVw/5ByoecK7O3VrexNvBk8QplaF37cvT50VkEbp+upMZFDdic/XCzFsSEkUkf
         B6nM2D5KCBFxDFiT1iaiK1SYrnmNoCa0wDnUsniqokx80lAPPO/p4+QbyQ01+jnINxH1
         PMpFt354lf/dTBLKU21PSVPs7t9Ntht977o5Hh1iVQV7RprT1aagLvIIx0IxhJ6Fw99b
         AghQ==
X-Gm-Message-State: AOAM531rJnqjJj0+m6dENdeo+TiZ1DLV/z8rth4yl5AiieENyYoyktwb
        6GtH9R37SZ6o2J1QsnFizuZ7w3p3A3I=
X-Google-Smtp-Source: ABdhPJz2+/ks0/io8Q8QcVIq/Dm/v+sGRIKkMWLyJ6HGuPjRmIX+l3rZvmMIfXN2VK0XvqkJS0hs5Q==
X-Received: by 2002:a7b:c0c7:: with SMTP id s7mr10129533wmh.66.1631524564128;
        Mon, 13 Sep 2021 02:16:04 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id u13sm5830705wmq.33.2021.09.13.02.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 02:16:03 -0700 (PDT)
Subject: Re: [PATCHv3 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <47a839c3-1c8d-9ccf-3b3d-387862227c4f@grimberg.me>
Date:   Mon, 13 Sep 2021 12:16:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910064322.67705-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Hi all,
> 
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit
> especially for NVMe-TCP here's an attempt to implement it.
> 
> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.
> 
> Also note that this is just for in-band authentication. Secure
> concatenation (ie starting TLS with the negotiated parameters) is not
> implemented; one would need to update the kernel TLS implementation
> for this, which at this time is beyond scope.
> 
> As usual, comments and reviews are welcome.

Still no nvme-cli nor nvmetcli :(
