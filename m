Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDA6C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jul 2022 07:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiGNHec (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jul 2022 03:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiGNHeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jul 2022 03:34:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86076BE0F
        for <linux-crypto@vger.kernel.org>; Thu, 14 Jul 2022 00:34:29 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lk5mG0R5yzkWvp;
        Thu, 14 Jul 2022 15:32:14 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 15:33:58 +0800
Message-ID: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
Date:   Thu, 14 Jul 2022 15:33:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     <linux-crypto@vger.kernel.org>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
Subject: Inquiry about the removal of flag O_NONBLOCK on /dev/random
CC:     <luto@kernel.org>, <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Community,

Recently we noticed the removal of flag O_NONBLOCK on /dev/random by 
commit 30c08efec888 ("random: make /dev/random be almost like 
/dev/urandom"), it seems that some of the open_source packages e.g. 
random_get_fd() of util-linux and __getrandom() of glibc. The man page 
for random() is not updated either.

Would anyone please kindly provide some background knowledge of this 
flag and it's removal? Thanks!

-- 
Best
GUO Zihua
