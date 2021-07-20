Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A90C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8437B60FF3
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbhGTUI6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 16:08:58 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:38999 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbhGTTrn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 15:47:43 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1MderZ-1lWbRq3WwD-00ZgwV; Tue, 20 Jul 2021 22:27:15 +0200
Subject: Re: [PATCH 05/11] nvme: add definitions for NVMe In-Band
 authentication
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-6-hare@suse.de>
 <affd7d4a-6eb5-20b4-fcb3-7e8a0767d7a2@grimberg.me>
 <2eebe51b-7ca0-c2cf-0949-18fb88a0395b@suse.de>
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <2bc945e4-c1a7-f537-aa74-a4fdc81f9d12@vlnb.net>
Date:   Tue, 20 Jul 2021 23:26:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <2eebe51b-7ca0-c2cf-0949-18fb88a0395b@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:iWPJ2DwRbNoWBzOqSvRw156UUCsO5gFEUpS7ar/9SVweYVuST7p
 Am2uZD6MyxopWUHQNral4DOMBbCSZSvKuub6fifMSq7F43g44IvOTv2HMYCuAt612PZ890T
 1S8ydKiuB2J2KVfhDRfmRTKRZmxr3SMCANYcUnOQuALB++dh6dqxbgDUH4D/eMaKc77uxac
 1CqEnTbsvTMsH0MnGKPnw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:O2VJ8bYgfpw=:UHN7I/4vSf4bZQjLCP3E3H
 6qDLCbTVCXUbxueU9MyrBcATZJNJ9OYAsd8qp+Ui4tG2wWlY0/vc38M3jSYAjI7Mk0OPd0s8G
 qPCaPTKzzzU45QFGSH8HWrWQPJOk+Q5AlaeMFw2hnCrz8Rpa4164yYWnXK7h02cId7oK31H/N
 cy++ac+4506ssAYzmyo4M6Pzztpb6rA8vPrVb9N+SF9oLEqBm/nhKs6On5lo+DFFiOmxufJxv
 Fscof6WBPu//MlHuTUTgJqB9SXOfUHPG4sGWIjcdNdyU+1YITD04dXj71q6HgYUZLelMlrwdR
 OCZciTJSFVdQG6K/4/nYbseTM/gX9kZBKewSxRvO5jwO9fxefJ9GeNWO1zVqJ7Bx9bPr9VbIl
 1EgCrkNu9UZMMjUbmV9DeJ1uT20v2pEdDRHEBXAxt0OBCbfh3Yr+NCT3OcfKi2tsOxRpCfujK
 bKiryFWXH9hCv3wVk8sHZZlIgmh2KQBayDjLy5Ns9H4QEANjr/9qziaDY/zSfFhN6KJMVMiew
 bJzf6fJaQf+Mzrzo7Q+vjcEffyOXflpPuYUyZToxX4L8XuNDaS0T6E/bbdWDdc5r3MI5w+raM
 WY5UQEb561M8WazvW2gz9Bg1o645RUgJd+JpmMXOU1ArHTxUAtL8Jea0shHQuGGEF3ji83r/O
 P9BTY1ACrpaKISgYKk865c7ZCo0Pjz0u7ENd9C49YhBqeNYhML7QI/w3a1pRyiWkLZ55e97Xt
 k2Ewf3cBkRGP7mgdRIJDJMEuwKeifd7F9ymOzAuoznXIegjqo23hf61OmybLJ35RdARJyFP2w
 9mt+0dTUbbeg90psEgnLcSdlPFT4CpP/dhnGqEU2iqZ4ddf7g2P5xMQm+JCXiXDIhaWWOUE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/17/21 5:04 PM, Hannes Reinecke wrote:
> On 7/17/21 8:30 AM, Sagi Grimberg wrote:

[...]

>>> +
>>> +enum {
>>> +    NVME_AUTH_DHCHAP_HASH_SHA256    = 0x01,
>>
>> Maybe s/HASH/HF/ (stands for hash function, which is
>> a better description).
> 
> Or HMAC, as this is what it's used for...

I would better do just NVME_AUTH_DHCHAP_SHA256. "HASH" is redundant
here. Better to keep it shorter.

Vlad
