Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2634C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 13:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB4F061B2C
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 13:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhKONQI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 08:16:08 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36849 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhKONPl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 08:15:41 -0500
Received: by mail-wm1-f46.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso15749515wml.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 05:12:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lcU07j4Rod4Dd+9mHoihuNORYaJb9sSw0tUuWGbvdHc=;
        b=FcmM7oD3lOLqFlF1+5/xqQ9JqIvMj7Fg9xIRszPzJP2aTQerxiKyeuz4eAZAzcXJpU
         dDbbn0Ba6Gybe+cGl/hz5ueGswaGleya/OqyU3tcj59UpOakYPk4UzfcAqJpxAtUz6Kl
         qBOxYNq2soO4U7+FFozNA3c56KdHnjumh/mFWlhk2sSzZwbkgjCtZjP4LzGKP2dotCL4
         vp87pkBp+KLQ/kI6AzSrwYPJXcRlBXCPZx5I4j9YeyRk445cue1LumC7DdSg0DuwJkMU
         F8E47JZpxWObGFgofvHL/otJpX4n/D5O7UFDKXT1vc+XtLTDD4KYWqLYMCh4j2dYs76o
         axug==
X-Gm-Message-State: AOAM5337P42hRY3EMDY3kT49sD2M4RFBKNPJ7KFNZErAPFFJbn95dyu/
        UzFoj2uw8VDkAW69UngNdiCTI1Yj344=
X-Google-Smtp-Source: ABdhPJxWEOzowTyGDkPW/PGQrInqOFpiov6Y+oGjOhsvkOG6c5uETXzMombZJ5l5AmbsGEYn6zBWSA==
X-Received: by 2002:a1c:8015:: with SMTP id b21mr58314163wmd.161.1636981963539;
        Mon, 15 Nov 2021 05:12:43 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f7sm22811555wmg.6.2021.11.15.05.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 05:12:42 -0800 (PST)
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <e24778c6-2ff1-ab14-95b0-354368cbfb35@grimberg.me>
Date:   Mon, 15 Nov 2021 15:12:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a7363853-05af-9d7f-4d6f-b02ec756ce6b@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> BTW, I've created a pull request for nvme-cli
> (https://github.com/linux-nvme/nvme-cli/pull/1237)
> to add a new command-line option 'dump-config'; can you check if that's
> what you had in mind or whether it needs to be improved further?

The dump is nice, thanks. I gave a couple of comments on the PR.
I do suspect that people will want to populate this file outside
of dump-config, hence we need a markdown documentation for it
or in this case a json schema...
