Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF244C28CC6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F02A27DF5
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oZefJvOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfFCJHB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:07:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45270 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfFCJHB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 05:07:01 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190603090658epoutp025b42b9494ddb70c38fb85b0aa8da0aff~kpQaA3ns52419024190epoutp02F
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 09:06:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190603090658epoutp025b42b9494ddb70c38fb85b0aa8da0aff~kpQaA3ns52419024190epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559552818;
        bh=x9TvWZRKI+58saE3CQvcUnn9RCw3ppnUZs9YYIiiZ/I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=oZefJvOlU8qpcdJ8UNkf5ziPhZ7lXJWL+BQWD1roKRC3tBS4FZbD82qhBAjYCjt+Y
         E04ke0Bhc669EG7WVABM/qp6lTp6btu1E1n8juZGBlEKmcLc//B10w/Z1BA+1rd6nC
         XHMDoYRV+Cuw7BCpeeN9l/+WPXiDOI/WB++sQ/8I=
Received: from epsmges5p3new.samsung.com (unknown [182.195.40.195]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190603090656epcas5p2aed2847ba654ce4870bdaecf271597b6~kpQX3QFs-1305313053epcas5p2L;
        Mon,  3 Jun 2019 09:06:56 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.D9.04067.F23E4FC5; Mon,  3 Jun 2019 18:06:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e~kpMePusAL2178021780epcas5p3h;
        Mon,  3 Jun 2019 09:02:27 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190603090227epsmtrp1e61081ec8c23756baee30b24a93169f1~kpMeO4VwJ1674016740epsmtrp1f;
        Mon,  3 Jun 2019 09:02:27 +0000 (GMT)
X-AuditID: b6c32a4b-7a3ff70000000fe3-ae-5cf4e32fb70b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.FB.03662.322E4FC5; Mon,  3 Jun 2019 18:02:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190603090225epsmtip20d2b100d394310406c978ae5d0230e39~kpMcNWAC11650516505epsmtip2l;
        Mon,  3 Jun 2019 09:02:25 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keescook@chromium.org, gustavo@embeddedor.com
Cc:     joe@perches.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        pankaj.m@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 0/4] zstd: reduce stack usage
Date:   Mon,  3 Jun 2019 14:32:02 +0530
Message-Id: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0gUURj17oyzY7QyrVY3S9kmljBfu9ra9DB7mAwotNWfCMNGvai0Ozvt
        7FYGgYUZaWmGYrmWQhQpPU1Dd83HWqRRhpWaFWpaUT4oUyMrqt0do/6d77vn3HPudz8SU+YQ
        AWQmb0FmnjPQxBz8TltwcFjE8FSSxvZyLdPlQEz5jasEU/4kB2fqGtVM/sgSxjYwjDOP8o3M
        QP+MjHlmLyeYtopcnOkfq5Mxzo7zYMNc1pbdhbO1VX0y9nqrmr3Tombbz/7A2anqHowtqK0G
        7GRNkJ7cZViXgbg0ZFYhPtWUlsmnx9AJO5I3J+uiNdow7WpmFa3iOSOKoeMS9WHxmQZXUFq1
        nzNYXS09J4p0xPp1ZpPVglQZJtESQyMhzSBoI4VwkTOKVj49PNVkXKPVaCJ1LuYeQ0b/p3xC
        aKAOlvy2ZIPLvnnAh4TUSlg1UEzkgTmkknIA+L35KS4VXwC85Wgh3Cwl9RXAnJqQPEB6FO3d
        yyTOXQDflI3LJc40gDOlWW5MUOGw2t7oucifygawv7sIuAuMagXwXe5F4Gb5UWHQ8euxxwGn
        1HDg0XMPVlDxsKD1m0zKFwT7Ok9gbjGk6gn4frzSWzqIg52FTwkJ+8GRB7VyCQfAj4W5cklw
        HMDecz24VBQDeOJT1SwrFg6+uC93PwijguENe4TUDoQlD697nDHKF5768XY2hQLWX/iL1TCn
        7+ZsiMVwcmIClzAL39ZVAWkWu+H0tyb5aRBY9s+hEoBqsAgJojEdiTohikcH/v+pGuDZwBUJ
        9aCmM9EJKBLQcxWffaaSlN7cfjHL6ASQxGh/BffK1VKkcVmHkNmUbLYakOgEOtcIi7CA+akm
        1z7zlmStLjI6WrNao4tiorX0QsUZ7+4kJZXOWdBehARk/quTkT4B2UDdc6Tj6OGdssCha1+P
        lZAlY/cKKr1WrRXmLbaNb0+JTelaUBi79KD697EK9pC9seGnve3Uljgv4+vBx8WlzKURfnmF
        32j5TosoECGO09w+bAb3bQ5vHZ5xtnXE682yHq/eK7dDHbm3R0O2hQ7F0k+86rJatm86uTHG
        1tS+NVT1gcbFDE67AjOL3B8Q6yQ0lwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSvK7yoy8xBjOvmltc3J1qMWf9GjaL
        OedbWCy27lG16H4lYzH7/mMWizPduRb37/1ksri8aw6bxeH5bSwW995sZbI4dHIuowOPx+yG
        iyweW1beZPJYd1DVY9sBVY8TM36zeHxZdY3Zo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDLu
        ve9mK9gpUDH1f0kD4zK+LkYODgkBE4kTV5W7GLk4hAR2M0pseHSMvYuREyguLfHz33sWCFtY
        YuW/5+wQRZ8ZJfZO6WYCSbAJ6Ems2rWHBSQhItDGKNG/8T8riMMscJJR4m7nB2aQKmEBXYnd
        /86ygdgsAqoS989cAbN5Bdwk+g7+YIJYISdx81wn8wRGngWMDKsYJVMLinPTc4sNC4zyUsv1
        ihNzi0vz0vWS83M3MYJDUUtrB+OJE/GHGAU4GJV4eGewf4kRYk0sK67MPcQowcGsJMKbeBso
        xJuSWFmVWpQfX1Sak1p8iFGag0VJnFc+/1ikkEB6YklqdmpqQWoRTJaJg1OqgZGv5ETIW9Ea
        Lc29fssX33/lyhw80Xz2pwRO01qp0JmOOwPWiC7/wul5wMA2cW3obwfnf2mt8WZlfIWnOq+k
        qkVqMgcKnbVJbG58cPXpPa3Cq6YqbJKNvx9prDnVonWmfnrcUyaHw/bft/C8Wsir7p96gpd/
        Bc/jeSb8B25y3hDcdcjt2h9FByWW4oxEQy3mouJEAGzeAMBBAgAA
X-CMS-MailID: 20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e
References: <CGME20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e@epcas5p3.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set reduces stack usage for zstd code, because target like ARM has
limited 8KB kernel stack, which is getting overflowed due to hight stack usage
of zstd code with call flow like:

....
....
(FSE_compress_usingCTable) from (HUF_compressWeights_wksp+0x140/0x200)
(HUF_compressWeights_wksp) from (HUF_writeCTable_wksp+0xdc/0x1c8)
(HUF_writeCTable_wksp) from (HUF_compress4X_repeat+0x214/0x450)
(HUF_compress4X_repeat) from  (ZSTD_compressBlock_internal+0x228/0x135c)
(ZSTD_compressBlock_internal) from  (ZSTD_compressContinue_internal+0x1f8/0x3c8)
(ZSTD_compressContinue_internal) from  (ZSTD_compressCCtx+0xc0/0x1cc)
(ZSTD_compressCCtx) from  (zstd_compress+0x90/0xa8)
(zstd_compress) from  (crypto_compress+0x2c/0x34) 
(crypto_compress) from  (zcomp_compress+0x3c/0x44)
(zcomp_compress) from  (zram_bvec_rw+0x2f8/0xa7c)
(zram_bvec_rw) from [<c03e1e58>] (zram_rw_page+0x104/0x170)
(zram_rw_page) from [<c01d3f94>] (bdev_write_page+0x80/0xb4)
(bdev_write_page) from [<c017dc9c>] (__swap_writepage+0x160/0x29c)
(__swap_writepage) from [<c017de14>] (swap_writepage+0x3c/0x58)
(swap_writepage) from [<c014f88c>] (shrink_page_list+0x788/0xae0)
(shrink_page_list) from [<c01502e0>] (shrink_inactive_list+0x210/0x4a8)
(shrink_inactive_list) from [<c0150dd4>] (shrink_zone+0x53c/0x7c0)
(shrink_zone) from [<c0151354>] (try_to_free_pages+0x2fc/0x7cc)
(try_to_free_pages) from [<c0144c60>] (__alloc_pages_nodemask+0x534/0x91c)
(__alloc_pages_nodemask) from [<c01393ac>] (pagecache_get_page+0xe0/0x1d8)
....
....

Maninder Singh, Vaneet Narang (4):
  zstd: pass pointer rathen than structure to functions
  zstd: use U16 data type for rankPos
  zstd: move params structure to global variable to reduce stack
    usage
  zstd: change structure variable from int to char

 crypto/zstd.c           | 11 ++++---
 include/linux/zstd.h    | 16 +++++-----
 lib/zstd/compress.c     | 85 +++++++++++++++++++++++++------------------------
 lib/zstd/decompress.c   |  2 +-
 lib/zstd/huf_compress.c |  4 +--
 5 files changed, 62 insertions(+), 56 deletions(-)

-- 
2.7.4

