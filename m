Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8915FC433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Mar 2022 21:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiCMVep (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Mar 2022 17:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiCMVeo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Mar 2022 17:34:44 -0400
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BCC5A152
        for <linux-crypto@vger.kernel.org>; Sun, 13 Mar 2022 14:33:35 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id j25so3940923edj.11
        for <linux-crypto@vger.kernel.org>; Sun, 13 Mar 2022 14:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=tJHa6JKFDscsSEurCzG9MK0b3hvjTr26NmT70tZt0vA=;
        b=WTPCg9XAfVejQc6YmHtkqFWgmLpf+9Vc97eW9ZDtf8zTwFP4JwysAGlUbHKLL7zNcB
         SJetXnq1gzJfuAEI7eIjWzZVcMl+ZLLQacbrf1yxyAh4PnLNp/JoQat75LU1/SBoYd3Q
         F/1a+4Uhc+9GBZwsPRfBU/vFsur9bibGjkqCqOe6Xl3NkFP9pmdpWN4+dAvlP851bGco
         Suop348bFAwJEGl6TnuA+LzVxPwKpNN7tOW27fwTZHSPEILSxDo5LteHM8BwJ02wdxZB
         QWe8nCAj0u+lidZrjVO9Yr3ILrnlQOeVrgsWRsIy5wfS4dLqvFa4pfvx6ho8L9peuKfX
         LZdg==
X-Gm-Message-State: AOAM532ZS12605qHwE0Yr1xF572a2An9eVwDKy/n42KvnPad17BOYp3w
        KbHuCN5yQj2IK+mQLeqFILE=
X-Google-Smtp-Source: ABdhPJxMPpuV6DrC7UOpam7Ndh4Xdvp+5rh3TQtxDvesTMhlmQkgGKNWietGITnJSUX5jXoaY8USUw==
X-Received: by 2002:a50:cd8c:0:b0:418:65c2:8b77 with SMTP id p12-20020a50cd8c000000b0041865c28b77mr6914446edi.170.1647207213608;
        Sun, 13 Mar 2022 14:33:33 -0700 (PDT)
Received: from [10.100.102.14] (46-117-116-119.bb.netvision.net.il. [46.117.116.119])
        by smtp.gmail.com with ESMTPSA id z23-20020a170906435700b006b0e62bee84sm5891207ejm.115.2022.03.13.14.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 14:33:33 -0700 (PDT)
Message-ID: <ac3056fe-e5bb-92cb-2d4f-a86c04117e5d@grimberg.me>
Date:   Sun, 13 Mar 2022 23:33:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
Content-Language: en-US
From:   Sagi Grimberg <sagi@grimberg.me>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Niolai Stange <nstange@suse.com>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
 <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
 <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me>
 <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de>
 <483836f5-f850-6eac-8c38-3f03db3189ab@grimberg.me>
 <0c4613ff-ba30-c812-a6e9-1954d77b1d1b@suse.de>
 <ad9af172-4b7b-4206-feab-8ab54ba7cfe5@grimberg.me>
 <e2ccd5bf-c13f-8660-c4c0-31a1053846ed@suse.de>
 <1d1522c6-7f6b-7023-9e66-a05ac5a5a0be@grimberg.me>
In-Reply-To: <1d1522c6-7f6b-7023-9e66-a05ac5a5a0be@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Hannes and co,
> 
> Do you know what is the state of this dependency? Or when should
> we expect to revisit this patch set?

Ping?
