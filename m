Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B50A0C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D3A27DFC
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lGn1PjZY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfFCJHR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:07:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45436 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfFCJHR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 05:07:17 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190603090715epoutp0291f0281ca9c883ae799672f51dd6d19e~kpQqGBNBK2326923269epoutp02H
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 09:07:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190603090715epoutp0291f0281ca9c883ae799672f51dd6d19e~kpQqGBNBK2326923269epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559552835;
        bh=0GHg7hg1JH/Hx2kxrbu6qAah08w35aybr4V9aViVsPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGn1PjZYLnokgyXaEvwvtM4F63sHOvSvvFJLJqKf4HbPC2/7OD1bQzAm5MNe6BsWL
         SgP2UIvqV3FdlJ3j0hjsodd5uuwzrejCxz6SwG+uW3ulhS6HiZLfpjeGYhJd9oNxdI
         IoOmy5/puV1dyvBtkQxgwaGpKvjgFMSaPW7jmP3o=
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.192]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20190603090712epcas5p1623502192e828555f940641b348af16a~kpQngs8y73073330733epcas5p1W;
        Mon,  3 Jun 2019 09:07:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.73.04071.043E4FC5; Mon,  3 Jun 2019 18:07:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20190603090236epcas5p1bf0733024f7fb52f8129157b11c8f882~kpMlyvevu3216432164epcas5p1b;
        Mon,  3 Jun 2019 09:02:36 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190603090236epsmtrp26a9c8d81f8a8876b2141a4b84defcf78~kpMlxyRk32094820948epsmtrp2M;
        Mon,  3 Jun 2019 09:02:36 +0000 (GMT)
X-AuditID: b6c32a49-5b7ff70000000fe7-5a-5cf4e3406010
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.FB.03662.B22E4FC5; Mon,  3 Jun 2019 18:02:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190603090233epsmtip2905b22e825a6e9007111de59c0c0ff5b~kpMjufs1l1650516505epsmtip2m;
        Mon,  3 Jun 2019 09:02:33 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keescook@chromium.org, gustavo@embeddedor.com
Cc:     joe@perches.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        pankaj.m@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 2/4] zstd: use U16 data type for rankPos
Date:   Mon,  3 Jun 2019 14:32:04 +0530
Message-Id: <1559552526-4317-3-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA01SW0wTQRTNdLdli1Q3ReOISppNqpEEbNHWxYjiI7iCiUS/NGjdwIQ2ttu1
        W1D8qgYfrVFRUQHrW1SKgEFAUyBY6gOfxAcoMSIR9UMNVKkgosaWLdG/c86cM2dy5xKYskQW
        R5g4O7JxrJmSReON/jmzE9P6gtmay26SftqEaHftVRnt7ijC6YZmNb3/0wz65Ns+nH6030K/
        7RmR0M+9bhntP7MHp3u+NEjotvunQFoMc9LxFGfqK7slTI1PzTTeUjPtpaM4E/R0YczBeg9g
        Buvis4gN5kVGxOYimwpxOdZcE5eXSmWuMyw36PQabaI2hV5AqTjWglKpFauzEtNN5tBDKVUB
        a84PSVmsIFBzFy+yWfPtSGW0CvZUCvG5Zl6bzCcJrEXI5/KScqyWhVqNJlkXcm42G7vOVUl5
        l3z7j2EH7gD9MheQE5CcD/tLy4ALRBNKsgnAnSNXokTyDcAOrx8TyRCAx6teYOORGz9/RVwt
        AFbuPSoRyXcAXX+ugbBLRiZBj7cZDx9MJh0A9nQeHmvBSB+AH/ZcGHPFkjQs7Xk9hnFSDbve
        vJOGsYJMh0crnEDsi4fdT5yhboKQkyvhw9aV4Xsg+VwGLwb9Ec8KeLfqllTEsfDTvfooEcfB
        wf4WmRjYC+DLsi5cJCUAOgcqI64lsPfVnahwA0bOgbXeuaI8Ex57UCMJY4ycCA+MvpeIugLe
        PD2O1bCo+1qkeDoc/PoVFzEDy+rqI9MrB7Cowy0tBvHl/yrOAuAB0xAvWPKQoOO1HNr2/8/V
        gbGNTFh1E5Q/Wd0GSAJQMYqAPJitlLIFQqGlDUACoyYr2NchSZHLFu5ANqvBlm9GQhvQhcZ5
        GIubkmMN7TdnN2h1yXq9JkWjm0frtdRUxRFpZ7aSzGPtaAtCPLKN5ySEPM4BXLucs7BLS2u3
        JaeWFVVfvzOtsv3Cdr/3/Gd8TcEjDxGYHdAP/35sii6WG1UlaxsmTL08cEmZoe8s4BOjN1U4
        a7f6DK3V6w9VLzcFMgv5eUP3EtJi2keGB3wjsb7bxSUba9IzT+zbndL5LHPS5wPvH3dkBO29
        y940ZFQ4hBmBxo8chQtGVpuA2QT2Lz2j2q6nAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvK72oy8xBnduWFtc3J1qMWf9GjaL
        OedbWCy27lG16H4lYzH7/mMWizPduRb37/1ksri8aw6bxeH5bSwW995sZbI4dHIuowOPx+yG
        iyweW1beZPJYd1DVY9sBVY8TM36zeHxZdY3Zo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDKu
        LVzNWtDFWfHjewNLA+M7ti5GTg4JAROJ7b/+sHcxcnEICexmlDg76QU7REJa4ue/9ywQtrDE
        yn/PoYo+M0q8XzKPESTBJqAnsWrXHhaQhIhAG6NE/8b/rCAOs8BJRom7nR+YQaqEBSwkZty7
        DdbBIqAqce3uI1YQm1fATWLy0k5GiBVyEjfPdQLVc3BwCrhLnN7vDhIWAirZ9baJdQIj3wJG
        hlWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHBq6W1g/HEifhDjAIcjEo8vDPYv8QI
        sSaWFVfmHmKU4GBWEuFNvA0U4k1JrKxKLcqPLyrNSS0+xCjNwaIkziuffyxSSCA9sSQ1OzW1
        ILUIJsvEwSnVwOhSfbdV3XmFnq3qk4TNjNcf+qwTPGp90ivvufbvrR23EjedWrBq3jbhlMCQ
        fUnV55/oS7PyCDy7I6PGq+R39d+uBbwKAZM3KTjLH2gW3KpQLryBd3tM2C7hbX0sHEpLq6wn
        dwXo55ent3e+nrWq6eLO+blZOw2cw5+qyAtxCYgYTfgiFt8cpMRSnJFoqMVcVJwIAAf5WOpa
        AgAA
X-CMS-MailID: 20190603090236epcas5p1bf0733024f7fb52f8129157b11c8f882
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090236epcas5p1bf0733024f7fb52f8129157b11c8f882
References: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090236epcas5p1bf0733024f7fb52f8129157b11c8f882@epcas5p1.samsung.com>
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

