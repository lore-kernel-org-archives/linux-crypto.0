Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C11DC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Dec 2021 09:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhLMJbf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Dec 2021 04:31:35 -0500
Received: from mail-ed1-f54.google.com ([209.85.208.54]:33483 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhLMJbf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Dec 2021 04:31:35 -0500
Received: by mail-ed1-f54.google.com with SMTP id t5so49577695edd.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Dec 2021 01:31:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aW/p/gDFPpURkrS2LMNqwBCA5bDLb6i2HHaFzhXO5l4=;
        b=Lys9yKfNEQUv8pomiGFZGEtnZ7q3Abyvfo53k28HnarsL/w0dYhzhSsvz+TEjo7er0
         fgW9zOhW3lL6d4pOr2bDlsw/V9IdokxiYDtgI0V2ePWtTIOjSPy8OTxTRKkDUyORafNz
         2eFXuKvvFaSbtmQg8mgkJtVI/TYWziXIcatH7nIctuykFemt3FaCtmj+gv2j+6DEpxL7
         htn6YImK0nkHxpWIVKG/fp3YX4rb97ZO0KSPm9YA1nxf8UX28A4knh9t6/n4SEU3ZN2+
         0jjC1PXoIi5U1M7+xEBp6fZGOO7FF70am6AFofT+2Qt5q8eH6BmnxJzLio1MLPrB9kYO
         5LZQ==
X-Gm-Message-State: AOAM533T6c/e11seNG3hMdcoXWXkWykKtvp2qiYUj5dyCOotruDsxIFz
        +xZPVhTDWfNIedssBCMXt2tGaUGmOKk=
X-Google-Smtp-Source: ABdhPJz1k2cOyY/Xc1RNwZ3z0Z7xKi4ESdWgN8mng3uSUXWKEEgb7a0afr8+9egYrqQbSamfg9j2Kw==
X-Received: by 2002:a05:6402:3550:: with SMTP id f16mr60728870edd.377.1639387894089;
        Mon, 13 Dec 2021 01:31:34 -0800 (PST)
Received: from [10.100.102.14] (85-250-228-224.bb.netvision.net.il. [85.250.228.224])
        by smtp.gmail.com with ESMTPSA id d19sm6016366edt.34.2021.12.13.01.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 01:31:33 -0800 (PST)
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
 <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me>
Date:   Mon, 13 Dec 2021 11:31:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>> So if we want to make progress on this we need the first 3 patches
>> rewviewed by the crypto maintainers.  In fact I'd prefer to get them
>> merged through the crypto tree as well, and would make sure we have
>> a branch that pulls them in for the nvme changes.  I'll try to find
>> some time to review the nvme bits as well.
>>
> That is _actually_ being addressed already.
> Nicolai Stange send a patchset for ephemeral keys, FFDHE support, and 
> FIPS-related thingies for the in-kernel DH crypto implementation 
> (https://lore.kernel.org/linux-crypto/20211209090358.28231-1-nstange@suse.de/). 
> 
> This obsoletes my preliminary patches, and I have ported my patchset to 
> run on top of those.
> 
> Question is how to continue from here; I can easily rebase my patchset 
> and send it relative to Nicolais patches. But then we'll be bound to the 
> acceptance of those patches, so I'm not quite sure if that's the best 
> way to proceed.

Don't know if we have a choice here... What is the alternative you are
proposing?
