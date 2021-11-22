Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F42FC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 12:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhKVME5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 07:04:57 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42799 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhKVME4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 07:04:56 -0500
Received: by mail-wr1-f43.google.com with SMTP id c4so32184196wrd.9
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 04:01:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D+2L2LRmeJoeCC/zotCm3ukWlF6727VI6B6PLMUImCg=;
        b=LC9Cr3tMr3NmTeWFzxyrzcOvCO/88MPSaA2Ywf0r1Ta7AIGtpatCNFGbfYOa4COPLq
         XQkpO/iB9pDZyZylxZwS42FNzktEVzRzeUTLPZYj0ZaXwuf12cIeIY1G2kKbXbLkaVG6
         1pAUYfXviPtiRG7DTrRyYs8u2Rqw6zcNMAx9aG/QcsF4fSMQaEFXA4dwtjpayRY6MhGH
         SY87AOl58jgMuiiyif022qt1Wywdqlxbi0ohh4VesxoImJRVZQy2C9AFuh5shfmRNnMS
         ILMex02fPevWVR7CkbtJNLNdu5Tx4avwd31khjtNiit35c49UgLn2DWzJ2gLOKwtAb5Y
         KJkA==
X-Gm-Message-State: AOAM532aGNiFbUqBINZ3Q0Ekvbhl83Y6q4xGYiK0bJtcw5myOX93Imcs
        U3tJEhG0NfvuTibVWRj6V46HYN5jkVo=
X-Google-Smtp-Source: ABdhPJxUrmU5SPBTBR8HPe3Fztcuw6Gn8OBKRbJqfke5wK+C4sYYjXsTjkT13RPaQ4nVlWNHxtMItA==
X-Received: by 2002:a5d:518d:: with SMTP id k13mr37112801wrv.120.1637582509148;
        Mon, 22 Nov 2021 04:01:49 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id h204sm9424495wmh.33.2021.11.22.04.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 04:01:48 -0800 (PST)
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
 <153a78a9-8978-afc1-d321-35719feb5b7f@grimberg.me>
 <55524670-23b0-a7d9-4398-043477faa37a@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <74405bb6-909b-c71c-ebe6-678990ae4691@grimberg.me>
Date:   Mon, 22 Nov 2021 14:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <55524670-23b0-a7d9-4398-043477faa37a@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +	ret = nvme_auth_process_dhchap_success1(ctrl, chap);
> +	if (ret) {
> +		/* Controller authentication failed */
> +		goto fail2;
> +	}
> +
> 
> v5 had 'if (ret < 0) [' here.

Right, thanks.
