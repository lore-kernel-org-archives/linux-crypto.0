Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A722C04AB3
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 07:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C96A217D6
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 07:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bYXJGAYT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfEJHV6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 03:21:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35977 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbfEJHV6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 03:21:58 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190510072155epoutp044be737075f960ed599e077941d73dcbe~dQV1-FGhy1831418314epoutp04d
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2019 07:21:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190510072155epoutp044be737075f960ed599e077941d73dcbe~dQV1-FGhy1831418314epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557472916;
        bh=0GHg7hg1JH/Hx2kxrbu6qAah08w35aybr4V9aViVsPs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=bYXJGAYT85TwR7MMryABJh+YY5gqdJBzz2lYzSlZpIgAWShlcbDxKpbQQW7CSCG4z
         08r2MaKwxExPvVXl9YcWVukd7YvVR973XhAuz/BKlrO46kl/FTRQVKT9Qx8rpSDTG/
         3iyiWVcVZBGz8uRCsZMHeWxAIBDTE7K5lUZJdrP4=
Received: from epsmges5p3new.samsung.com (unknown [182.195.40.193]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20190510072154epcas5p109db6ea89ab70e5b214436f6dff7fca6~dQV0USwuU3047530475epcas5p1E;
        Fri, 10 May 2019 07:21:54 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.BB.04067.29625DC5; Fri, 10 May 2019 16:21:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1~dPazciaV32280722807epcas5p3V;
        Fri, 10 May 2019 06:14:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190510061418epsmtrp14aaaf105d4d2f8ab03548bbbe07e9a1d~dPazbvThh0714207142epsmtrp1J;
        Fri, 10 May 2019 06:14:18 +0000 (GMT)
X-AuditID: b6c32a4b-78bff70000000fe3-59-5cd526922ef3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.36.03692.AB615DC5; Fri, 10 May 2019 15:14:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190510061416epsmtip290cabd8939c2be6a25e4ab8ae7a48a7f~dPaxVZ6e51223912239epsmtip2h;
        Fri, 10 May 2019 06:14:16 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     terrelln@fb.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        keescook@chromium.org, gustavo@embeddedor.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, pankaj.m@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
Subject: [PATCH 2/2] zstd: use U16 data type for rankPos
Date:   Fri, 10 May 2019 11:43:59 +0530
Message-Id: <1557468839-3388-1-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUhUURTHufPeLC5Tj2k7WcrwcII0bcaa6VYuUSED+kEIKmLKXnoZpdl4
        b8a2D01llkpZttBimlSUFi2mZprlVtFie5YNWpAVmU2omIUUzfMl9e13/ud/7v9y71FRmmF5
        mCrb4Sa8g7OximC6tnVmVEzxjJcWve+BEj9tILjkcS6Na27ocGHvdPyw0I7fdv+U4ef1JQrc
        WpZH4+6+Ghnu/d2hwC33TqBFIebj3qe0ubqiU2a+2Kwz79/hV5prm3TmvdWVyDxYFZGmXGWL
        zyJcJuG1xJHhzMx2WBPYlGXpS9KNJr0hxjAfz2O1Ds5OEtilqWkxydm2wPVYbQ5n8wSkNE4Q
        2NmJ8bzT4ybaLKfgTmCJK9PmMsS5YgXOLngc1tgMp32BQa+PMwaca21ZHeXn5a6CoI0/hr20
        F/kVBUilAmYu1DQuLEBBKg3TgMBbCBIPIPB/tBSg4AB/R+ArG0Jj/r6etZLeGPCUtiulYgjB
        heP5CnFawcRCZf0NWuSJTA6cvH5TLpoopgnBkP8KJTYmMBi2595RikwzOhh4tkcpJqiZZGiv
        2CLKwERA56N8SpwF5oICzua3UVJjKXTknZZJPAF671YrJQ6Dz0V5SmlgF4JXRztoqTiIIP9b
        xV9XErx7fXs0jWJmwqX62ZIcDofuXxw9lGLGwZ6Rnr8BaqgrHWMd5HZelks8DQb7+2mJzTDQ
        OCITj9Qwq6G1K2kfCj/2L+AkQpVoKnEJdisRjK45DrLh/2+qQqNLF5VSh6oepbYgRoXYUDUe
        /8KikXM5wiZ7CwIVxU5U87MCkjqT27SZ8M503mMjQgsyBh5wPxU2KcMZWGGHO91gjDOZ9PP1
        xjnYZGCnqIvlLy0axsq5yXpCXIQfm5OpgsK8aEX8lp3njnxIjWhLrQtvuNZsfTeyMzF6utWZ
        VF882B69JrF86wY33Ipe/mvz7+5Pa6Kujkw2FfUslr1fpz0aen0bHl45tw+fjuwKfdMVsrI2
        5olr997Sj4bmrudffXRw05lTh48cKOtnfMgyrTw55M6P5i9FjfN4/+uUyEhfKfG8aWNpIYsz
        RFG8wP0BRZI6t4oDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSvO4usasxBhuea1hc3J1qMed8C4vF
        1j2qFt2vZCzOdOda3L/3k8ni8q45bBaH57exWNx7s5XJ4tW/a2wWh07OZXTg9pjdcJHFY8vK
        m0we6w6qekxsfsfuse2AqkffllWMHp83yQWwR3HZpKTmZJalFunbJXBlXFu4mrWgi7Pix/cG
        lgbGd2xdjBwcEgImEm+eJHQxcnEICexmlFi7/ghrFyMnUFxa4ue/9ywQtrDEyn/P2SGKPjNK
        HNqwlxkkwSagJ7Fq1x6wIhGBGom2f0fZQIqYBY4xSmxYcJ0RJCEsYCHR1HKMHcRmEVCV+HSp
        lx1kM6+Am8TZldUQC+Qkbp7rZJ7AyLOAkWEVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7u
        JkZw0Glp7mC8vCT+EKMAB6MSD68F/5UYIdbEsuLK3EOMEhzMSiK8RTpAId6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rxP845FCgmkJ5akZqemFqQWwWSZODilGhgFUxbP0zjBdlo3bWvDiZJ3f47J
        di1ZXv5MedejS8H7ZB1Wyi6NCD5W7tuW9HHV9MLwI0t+HRaol5u/UmxLkWeZxBvLuYpVe9VX
        W1WWXbRfy9vgdK9hprjCyV/erzW+Nik/qlBYxDmHZ2fUssfvvvf/SlPqf9K8mUNwaufsWy8X
        XRQ88Lc717NTiaU4I9FQi7moOBEA0G2ajDYCAAA=
X-CMS-MailID: 20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1
References: <CGME20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1@epcas5p3.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rankPos structure variables value can not be more than 512.
So it can easily be declared as U16 rather than U32.

It will reduce stack usage of HUF_sort from 256 bytes to 128 bytes

original:
e92ddbf0        push    {r4, r5, r6, r7, r8, r9, fp, ip, lr, pc}
e24cb004        sub     fp, ip, #4
e24ddc01        sub     sp, sp, #256    ; 0x100

changed:
e92ddbf0        push    {r4, r5, r6, r7, r8, r9, fp, ip, lr, pc}
e24cb004        sub     fp, ip, #4
e24dd080        sub     sp, sp, #128    ; 0x80


Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
---
 lib/zstd/huf_compress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/zstd/huf_compress.c b/lib/zstd/huf_compress.c
index e727812..2203124 100644
--- a/lib/zstd/huf_compress.c
+++ b/lib/zstd/huf_compress.c
@@ -382,8 +382,8 @@ static U32 HUF_setMaxHeight(nodeElt *huffNode, U32 lastNonNull, U32 maxNbBits)
 }
 
 typedef struct {
-	U32 base;
-	U32 curr;
+	U16 base;
+	U16 curr;
 } rankPos;
 
 static void HUF_sort(nodeElt *huffNode, const U32 *count, U32 maxSymbolValue)
-- 
2.7.4

