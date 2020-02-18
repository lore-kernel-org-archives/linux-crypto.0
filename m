Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB2FC3402F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 02:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7EFB21D56
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 02:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgBRCnQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 21:43:16 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:40439 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbgBRCnQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 21:43:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TqCIusF_1581993788;
Received: from 30.27.234.229(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TqCIusF_1581993788)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 18 Feb 2020 10:43:11 +0800
Subject: Re: [PATCH v2 1/2] crypto: fix mismatched hash algorithm name sm3-256
 to sm3
To:     Mimi Zohar <zohar@linux.ibm.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, jarkko.sakkinen@linux.intel.com,
        ebiggers@kernel.org, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200217093649.97938-1-tianjia.zhang@linux.alibaba.com>
 <20200217093649.97938-2-tianjia.zhang@linux.alibaba.com>
 <1581989598.8515.233.camel@linux.ibm.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <f99d89d5-fbe0-49b9-a24d-b282ceb33e95@linux.alibaba.com>
Date:   Tue, 18 Feb 2020 10:43:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <1581989598.8515.233.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/2/18 9:33, Mimi Zohar wrote:
> On Mon, 2020-02-17 at 17:36 +0800, Tianjia Zhang wrote:
>> The name sm3-256 is defined in hash_algo_name in hash_info, but the
>> algorithm name implemented in sm3_generic.c is sm3, which will cause
>> the sm3-256 algorithm to be not found in some application scenarios of
>> the hash algorithm, and an ENOENT error will occur. For example,
>> IMA, keys, and other subsystems that reference hash_algo_name all use
>> the hash algorithm of sm3.
>>
>> According to https://tools.ietf.org/id/draft-oscca-cfrg-sm3-01.html,
>> SM3 always produces a 256-bit hash value and there are no plans for
>> other length development, so there is no ambiguity in the name of sm3.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> The previous version of this patch set is queued in the next-
> integrity-testing branch.  That version of this patch didn't
> change TPM_ALG_SM3_256.  Unless the TPM standard was modified, the TPM
> spec refers to it as TPM_ALG_SM3_256.  Has that changed?
> 
> Mimi
> 

The definition in the TPM specification is still TPM_ALG_SM3_256, please
ignore the modification to the TPM definition in this patch.

Thanks,
Tianjia
