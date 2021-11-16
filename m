Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B325AC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 10:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE696321A
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 10:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhKPKjI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 05:39:08 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36842 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhKPKjG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 05:39:06 -0500
Received: by mail-wr1-f50.google.com with SMTP id s13so36648584wrb.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Nov 2021 02:36:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=De6xSUE+LU+xS+pNQP/APrgEdESSAyaHS36taCZ9EPg=;
        b=IKapBg8aIFZSkP1Ipdljg0YihX7iUnKQZ99RBOrUv799FV6UziKwx7YmgHXeWmDXIC
         AtvyL8Bq26fUVtN1ll/0IyPSHGTWwM8kDDB2MQx+P5aLZrwawLHBtunDEFCyvJB3pZiq
         kyPSZ8qjTQvkyefqjkWYkRNL4lgf0ko/ckh0b+HjrsCNfiDldcZ10ddZdDywCjIGcEqb
         lObxpWzXKvyugzCBGAMJwbvRY/BMZVuioLRpazkIso/KStgbnnnWhfk7/cQ8ucB5Q9tt
         YUjh5JPWP34DdN4+i1je+ZAsTwENqcLI9nap0lJ5qjETvuKIpwqzjTZG3Om2zpQ1ZPcg
         eWJQ==
X-Gm-Message-State: AOAM532O56Q3YdSR7PS9O1YL02w2RJ10IE2Fjl2o9022NzW/uOyQG7Lh
        hC6hDRTRUVJJxeRz6H80Ro7LdFuXnEc=
X-Google-Smtp-Source: ABdhPJz+6JROlPCUQQny1UM9sV3wR7GPDdBIm5LlK1urNESPZWmjegorY0QVcsQRKYzSYwj+i39XQg==
X-Received: by 2002:adf:d1e2:: with SMTP id g2mr7869901wrd.105.1637058968343;
        Tue, 16 Nov 2021 02:36:08 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id d9sm16930432wre.52.2021.11.16.02.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:36:08 -0800 (PST)
Subject: Re: [PATCHv5 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <74db7c77-7cbf-4bc9-1c80-e7c42acaea64@grimberg.me>
 <f67ca46e-f421-33f7-da8b-ff6e47acf8c2@suse.de>
 <8553266f-005c-f947-4737-2108cb7062d1@grimberg.me>
 <a7363853-05af-9d7f-4d6f-b02ec756ce6b@suse.de>
 <50095ec8-3825-efa5-98bb-76b0f0fdc21e@grimberg.me>
 <31088486-0134-0dad-b052-32fd3ce2d1cf@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <0c894ac7-cf8e-4052-d56e-b8b08ead9092@grimberg.me>
Date:   Tue, 16 Nov 2021 12:36:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <31088486-0134-0dad-b052-32fd3ce2d1cf@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>> Hannes, was the issue on the host side or the controller side?
>>
> The issue was actually on the host side.
> 
>> I'm a little lost into what was the actual fix...
> 
> The basic fix was this:
> 
> @@ -927,13 +944,17 @@ static int nvme_auth_dhchap_host_response(struct
> nvme_ctrl
>   *ctrl,
> 
>          if (!chap->host_response) {
>                  chap->host_response =
> nvme_auth_transform_key(ctrl->dhchap_key,
> -                                       ctrl->dhchap_key_len, chap->hash_id,
> +                                       ctrl->dhchap_key_len,
> +                                       ctrl->dhchap_key_hash,
>                                          ctrl->opts->host->nqn);
>                  if (IS_ERR(chap->host_response)) {
>                          ret = PTR_ERR(chap->host_response);
>                          chap->host_response = NULL;
>                          return ret;
>                  }
> 
> 
> (minus the linebreaks, of course).
> 'chap->hash_id' is the hash selected by the initial negotiation, which
> is wrong as we should have used the hash function selected by the key
> itself.

Makes sense. thanks.
