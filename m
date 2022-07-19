Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537A8C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 08:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiGSIHL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiGSIHK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 04:07:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCB310FCA
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 01:07:09 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LnBFV5GXZzkXcb;
        Tue, 19 Jul 2022 16:04:46 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 16:06:52 +0800
Message-ID: <0abd4d8a-86cf-3697-584e-bfd313107ef9@huawei.com>
Date:   Tue, 19 Jul 2022 16:06:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <luto@kernel.org>, <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <d49d35f5-8eaf-d5e8-7443-ac896a946db7@huawei.com>
 <YtYpQ1gf23mxIiYH@sol.localdomain>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <YtYpQ1gf23mxIiYH@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> (I don't know why O_NONBLOCK stopped being recognized *before* the entropy pool
> has been initialized; it's either an oversight, or it was decided it doesn't
> matter.  Probably the latter, since I can't think of a real use case for using
> O_NONBLOCK on /dev/random.)

Does this mean that we expect all users of /dev/random to block until it 
is initialized?

-- 
Best
GUO Zihua
