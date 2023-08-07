Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB0DC0015E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Aug 2023 02:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjHGCXT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Aug 2023 22:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHGCXR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Aug 2023 22:23:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22FD95;
        Sun,  6 Aug 2023 19:23:16 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RK0S220BKzVjsm;
        Mon,  7 Aug 2023 10:21:22 +0800 (CST)
Received: from [10.67.101.184] (10.67.101.184) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 10:23:13 +0800
Subject: Re: [PATCH 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <20230729125239.25337-1-qianweili@huawei.com>
 <20230729125239.25337-2-qianweili@huawei.com>
 <ZMy2LQckr/OtS1ZG@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liulongfang@huawei.com>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <6af919d6-755e-4cc3-794d-2684e58d01fe@huawei.com>
Date:   Mon, 7 Aug 2023 10:23:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <ZMy2LQckr/OtS1ZG@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.101.184]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2023/8/4 16:26, Herbert Xu wrote:
> Your patch description makes no sense to me.  Please explain more
> clearly why you're replacing generic IO primitives with hand-rolled
> assembly.

Sorry，I will re-describe the problem that this patch fixes.

Thanks,
Weili
