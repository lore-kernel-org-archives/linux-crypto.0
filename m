Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3E5C352A5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5749F20873
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBJMHD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 07:07:03 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:47839 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgBJMHD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 07:07:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04452;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DW;RN=12;SR=0;TI=W4_5790132_DEFAULT_0AC264CC_1581336418827_o7001c68b;
Received: from WS-web (tianjia.zhang@linux.alibaba.com[W4_5790132_DEFAULT_0AC264CC_1581336418827_o7001c68b]) by e01e07467.eu6 at Mon, 10 Feb 2020 20:06:58 +0800
Date:   Mon, 10 Feb 2020 20:06:58 +0800
From:   "Tianjia Zhang" <tianjia.zhang@linux.alibaba.com>
To:     "linux-crypto-owner" <linux-crypto-owner@vger.kernel.org>,
        "ebiggers" <ebiggers@kernel.org>
Cc:     "herbert" <herbert@gondor.apana.org.au>,
        "davem" <davem@davemloft.net>, "zohar" <zohar@linux.ibm.com>,
        "dmitry.kasatkin" <dmitry.kasatkin@gmail.com>,
        "jmorris" <jmorris@namei.org>, "serge" <serge@hallyn.com>,
        "linux-crypto" <linux-crypto@vger.kernel.org>,
        "linux-integrity" <linux-integrity@vger.kernel.org>,
        "linux-security-module" <linux-security-module@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: "Tianjia Zhang" <tianjia.zhang@linux.alibaba.com>
Message-ID: <44ccb074-e2f4-4b6d-b33c-a91ca7393ebe.tianjia.zhang@linux.alibaba.com>
Subject: =?UTF-8?B?5Zue5aSN77yaW1BBVENIIDEvMl0gY3J5cHRvOiBzbTMgLSBhZGQgYSBuZXcgYWxpYXMgbmFt?=
  =?UTF-8?B?ZSBzbTMtMjU2?=
X-Mailer: [Alimail-Mailagent revision 3][W4_5790132][DEFAULT][Chrome]
MIME-Version: 1.0
References: <20200207092219.115056-1-tianjia.zhang@linux.alibaba.com> <20200207092219.115056-2-tianjia.zhang@linux.alibaba.com>,<20200210031717.GA5198@sol.localdomain>,<b7ce247b-ede1-4b01-bb11-894c042679e1.tianjia.zhang@linux.alibaba.com>
x-aliyun-mail-creator: W4_5790132_DEFAULT_MzYTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgNi4xOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvNzkuMC4zOTQ1LjExNyBTYWZhcmkvNTM3LjM2zc
In-Reply-To: <b7ce247b-ede1-4b01-bb11-894c042679e1.tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SXQgaXMgYWxzbyBhIGdvb2QgaWRlYSB0byBjaGFuZ2UgInNtMy0yNTYiIHRvICJzbTMiIGluIGhh
c2hfaW5mbywgSSB3aWxsIHN1Ym1pdCBhIG5ldyBwYXRjaCB0byBmaXggdGhpcyBwcm9ibGVtLg==
