Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C20C47084
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562E360200
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhEYIiG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 04:38:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:21509 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhEYIiG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 04:38:06 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4Fq6r34ZHLzBC1g;
        Tue, 25 May 2021 10:36:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xLOZw0K92lM2; Tue, 25 May 2021 10:36:35 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4Fq6r33gJszBC1c;
        Tue, 25 May 2021 10:36:35 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id C2C4D635; Tue, 25 May 2021 10:41:00 +0200 (CEST)
Received: from 37.173.125.11 ([37.173.125.11]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Tue, 25 May 2021 10:41:00 +0200
Date:   Tue, 25 May 2021 10:41:00 +0200
Message-ID: <20210525104100.Horde.hAT97HqOl-b_86VT9ois8Q1@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Wu Bo <wubo40@huawei.com>
Cc:     linfeilong@huawei.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/2] use DIV_ROUND_UP helper macro for calculations
In-Reply-To: <1621930520-515336-1-git-send-email-wubo40@huawei.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wu Bo <wubo40@huawei.com> a écrit :

> This patchset is replace open coded divisor calculations with the
> DIV_ROUND_UP kernel macro for better readability.

We call it a series not a patchset.

PFN_UP() from pfn.h should be used instead of DIV_ROUND_UP() I believe.

>
> Wu Bo (2):
>   crypto: af_alg - use DIV_ROUND_UP helper macro for calculations
>   fs: direct-io: use DIV_ROUND_UP helper macro for calculations
>
>  crypto/af_alg.c | 2 +-
>  fs/direct-io.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> --
> 1.8.3.1


