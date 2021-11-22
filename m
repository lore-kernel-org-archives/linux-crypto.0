Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DEFC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhKVLsm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:48:42 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:42546 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhKVLsm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 06:48:42 -0500
Received: by mail-wm1-f54.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so13337782wmd.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 03:45:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tbbevRhH2BN+cLXilsvvF3MyQy7tzQ1/scdTY35LU8A=;
        b=pIjbAmhWFeYqSxT8Q99kc8JcRXFJm3v8bgMcKrM2CVDLXvwCSNAcculwg8wrTouni2
         UQVwR/24k7lmlCYJymdx7jupGrJ7r/gBw2+IYipVNu/rWrkhVC7iO2rRDohjhT9ynWXO
         CjRPdYeIdU08lWUVLUJ+9DOSrDtizh9csz6nFAyM9ehhxJvC+8NHt67kskYisI2DaMMh
         qVE1v0PY+T8RsVtx9nR+zYHBrPsZIBatf2uNU2crGZr2KEuKGAxv/FRzA7EiI7yFN1bZ
         /kRo3lVfpe4aq6aU8Ry8FZRQZnrHtdITB9iSNn3b/11zYJ9ehDPoWKnZMm6DEItuUMNC
         opaQ==
X-Gm-Message-State: AOAM532qxpNBPxmSigQ168AIxRbLzbDCE5jhpttMBFRavGZt4QWQGbuv
        eSgr+EMGixrrE23u/dFK5+rNNGUiors=
X-Google-Smtp-Source: ABdhPJzb3UiBq+TU9CNPSu2vLroNv/iclKwD8GQbQsBzssTyBM31OVRHTbf7kaiZuGJla24tOBZ+ww==
X-Received: by 2002:a1c:a592:: with SMTP id o140mr28775774wme.10.1637581535150;
        Mon, 22 Nov 2021 03:45:35 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id h15sm25598575wmq.32.2021.11.22.03.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 03:45:34 -0800 (PST)
Subject: Re: [PATCHv6 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <14b025bc-746f-ea73-a325-7805c4b46c28@grimberg.me>
 <8e0909ad-f431-2600-7b68-d86d014fc9ec@suse.de>
 <8ba377cc-5c33-7cba-456e-bfc890f1ad88@grimberg.me>
 <ff0acc79-40d7-8247-6f80-e1c6f635df3f@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <153a78a9-8978-afc1-d321-35719feb5b7f@grimberg.me>
Date:   Mon, 22 Nov 2021 13:45:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ff0acc79-40d7-8247-6f80-e1c6f635df3f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>>> What about the bug fix folded in?
>>>
>>> Yeah, and that, to
>>> Forgot to mention it.
>>
>> It is not the code that you shared in the other thread right?
>>
> Yes, it is.
> It has been folded into v6.

I don't see it in patch 07/12
