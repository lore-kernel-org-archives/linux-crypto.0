Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12973EE6457
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 11:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjIOLSy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 07:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjIOLSx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 07:18:53 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46A7101
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 04:18:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Vs7-ZUD_1694776723;
Received: from 30.240.107.178(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Vs7-ZUD_1694776723)
          by smtp.aliyun-inc.com;
          Fri, 15 Sep 2023 19:18:44 +0800
Message-ID: <6f11a61f-1575-2886-0198-1f5947f9f835@linux.alibaba.com>
Date:   Fri, 15 Sep 2023 19:18:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [bug report] lib/mpi: Extend the MPI library
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-crypto@vger.kernel.org
References: <800d9813-af24-4b4a-ba0f-45a37515902c@moroto.mountain>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <800d9813-af24-4b4a-ba0f-45a37515902c@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Dan Carpenter,

On 9/15/23 3:21 PM, Dan Carpenter wrote:
> Hello Tianjia Zhang,
> 
> The patch a8ea8bdd9df9: "lib/mpi: Extend the MPI library" from Sep
> 21, 2020 (linux-next), leads to the following Smatch static checker
> warning:
> 
> lib/crypto/mpi/mpiutil.c:202 mpi_copy() error: potential null dereference 'b'.  (mpi_alloc returns null)
> lib/crypto/mpi/mpiutil.c:224 mpi_alloc_like() error: potential null dereference 'b'.  (mpi_alloc returns null)
> lib/crypto/mpi/mpiutil.c:258 mpi_set() error: potential null dereference 'w'.  (<unknown> returns null)
> lib/crypto/mpi/mpiutil.c:277 mpi_set_ui() error: potential null dereference 'w'.  (<unknown> returns null)
> lib/crypto/mpi/mpiutil.c:289 mpi_alloc_set_ui() error: potential null dereference 'w'.  (mpi_alloc returns null)
> 
> lib/crypto/mpi/mpiutil.c
>      195 MPI mpi_copy(MPI a)
>      196 {
>      197         int i;
>      198         MPI b;
>      199
>      200         if (a) {
>      201                 b = mpi_alloc(a->nlimbs);
> 
> Allocations can fail.
> 
> --> 202                 b->nlimbs = a->nlimbs;
>      203                 b->sign = a->sign;
>      204                 b->flags = a->flags;
>      205                 b->flags &= ~(16|32); /* Reset the immutable and constant flags. */
>      206                 for (i = 0; i < b->nlimbs; i++)
>      207                         b->d[i] = a->d[i];
>      208         } else
>      209                 b = NULL;
>      210         return b;
>      211 }
> 
> regards,
> dan carpenter

Thanks for reminding me, these are some remaining issues that needs more
modifications. I will take the time to fix them.

Cheers,
Tianjia
