Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D3DC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 08:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhKVIQW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 03:16:22 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:35451 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhKVIQW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 03:16:22 -0500
Received: by mail-wr1-f48.google.com with SMTP id i5so31122091wrb.2
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 00:13:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nbvOvnFnDV4WF1ejf2PQnGG6K+OhC43w0EqaZiX2IM0=;
        b=QBJ9wKbCZm1Y3ry7/XGWk33ioSwGvib+K5CfL6mhqDjQjgXmGfmUeGWF8V9PWbr2rn
         ksKyEAJU0Wwi785L2MeIRJ1vRD9SqhODhvYSBtfxYmHs2tsanS9ZqDuCH4XVsZ/nhOKS
         XMBFCPzIjClB8dh8VCNsA6D9TVkTltiHJbsrEPvAeQ6N3/VhBbnhUKzOaglRIb8IXhMa
         dDKRyhF1eKiolbfkML9K31liRlTLbHBeOCOKMIOMjljJ695GHWMBxEHooxfxEhruVZA6
         p5f29GK1o04v8RmQ1kJ8ifKdFEkuRnyBjwoGvAeyHeQYCxvpWRTwv1yz981m76bQjDni
         jCQw==
X-Gm-Message-State: AOAM532qp/nak+zf/J60bOkITeuokqo6wF3wO7o6YKhF2/eqmnKIW6sE
        6+qVa4bP/QQ+iXsNvVzvlTEYdSwdaFo=
X-Google-Smtp-Source: ABdhPJyr2rExqqT2Q0nefuJdurYFQc3A+0MO3/25NtEKDqhABcpH82RTboem7iGolwHuUZMLqjgtzA==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr36795793wri.69.1637568795064;
        Mon, 22 Nov 2021 00:13:15 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id j17sm11078397wmq.41.2021.11.22.00.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 00:13:14 -0800 (PST)
Subject: Re: [PATCHv6 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <14b025bc-746f-ea73-a325-7805c4b46c28@grimberg.me>
Date:   Mon, 22 Nov 2021 10:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122074727.25988-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/22/21 9:47 AM, Hannes Reinecke wrote:
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
> 
> Changes to v5:
> - Unify nvme_auth_generate_key()
> - Unify nvme_auth_extract_key()

You mean nvme_auth_extract_secret() ?

> - Include reviews from Sagi

What about the bug fix folded in?
