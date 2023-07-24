Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D904C001E0
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jul 2023 02:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjGXCbL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Jul 2023 22:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjGXCbK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jul 2023 22:31:10 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F50DDD;
        Sun, 23 Jul 2023 19:30:53 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4R8NVx5r9dz1GDXd;
        Mon, 24 Jul 2023 09:54:01 +0800 (CST)
Received: from [10.67.101.184] (10.67.101.184) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 09:54:50 +0800
Subject: Re: linux-next: Fixes tag needs some work in the crypto tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>
References: <20230724083703.5d995fb4@canb.auug.org.au>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <8693972c-fa58-ba0f-9342-decb2f992215@huawei.com>
Date:   Mon, 24 Jul 2023 09:54:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20230724083703.5d995fb4@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.184]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sorry, my fault. I'll double check this in future submissions.
The correct tag is
Fixes: e3ac4d20e936 ("crypto: hisilicon/qm - enable PF and VFs communication")

@Herbert, Is there any way to modify it?

Regards,
Weili

On 2023/7/24 6:37, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   5cd4ed98cfb7 ("crypto: hisilicon/qm - flush all work before driver removed")
> 
> Fixes tag
> 
>   Fixes: ("crypto: hisilicon/qm - enable PF and VFs communication")
> 
> has these problem(s):
> 
>   - No SHA1 recognised
> 
> Maybe you meant
> 
> Fixes: e3ac4d20e936 ("crypto: hisilicon/qm - enable PF and VFs communication")
> 
