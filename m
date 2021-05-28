Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92EFC4708D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 06:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B756135C
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 06:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhE1G3U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 02:29:20 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:38192 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhE1G3T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 02:29:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UaLIcr6_1622183262;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UaLIcr6_1622183262)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 May 2021 14:27:42 +0800
Subject: Re: [PATCH v2 1/7] crypto: fix a memory leak in sm2
To:     Hongbo Li <herbert.tencent@gmail.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, dhowells@redhat.com, jarkko@kernel.org,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org
References: <1622123615-15517-1-git-send-email-herbert.tencent@gmail.com>
 <1622123615-15517-2-git-send-email-herbert.tencent@gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <47cf4353-b4bb-3907-6017-60bf87805d0c@linux.alibaba.com>
Date:   Fri, 28 May 2021 14:27:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1622123615-15517-2-git-send-email-herbert.tencent@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert, Hongbo,

On 5/27/21 9:53 PM, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
> test_akcipher_one(), it will set public key for every test vector,
> and don't free ec->Q. This will cause a memory leak.
> 
> This patch alloc ec->Q in sm2_ec_ctx_init().
> 
> Fixes: ea7ecb66440b ("crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm")
> Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>   crypto/sm2.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)
> 

Patch 1/7 is an independent bugfix patch. If possible, consider applying 
it first.

The commit message header should start with: crypto: sm2 -

Also added:

Cc: stable@vger.kernel.org # v5.10+

Best regards,
Tianjia
