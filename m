Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FC1C32771
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 03:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1209F2083E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 03:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA0DPb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Jan 2020 22:15:31 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:39504 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbgA0DPb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Jan 2020 22:15:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DW;RN=5;SR=0;TI=W4_5657687_DEFAULT_0AC264CE_1580094929130_o7001c26212;
Received: from WS-web (tianjia.zhang@linux.alibaba.com[W4_5657687_DEFAULT_0AC264CE_1580094929130_o7001c26212]) by e01e04407.eu6 at Mon, 27 Jan 2020 11:15:29 +0800
Date:   Mon, 27 Jan 2020 11:15:29 +0800
From:   "Tianjia Zhang" <tianjia.zhang@linux.alibaba.com>
To:     "smueller" <smueller@chronox.de>
Cc:     "herbert" <herbert@gondor.apana.org.au>,
        "davem" <davem@davemloft.net>,
        "linux-crypto" <linux-crypto@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: "Tianjia Zhang" <tianjia.zhang@linux.alibaba.com>
Message-ID: <b71ed6fc-0c71-4eef-9023-064538e4011b.tianjia.zhang@linux.alibaba.com>
Subject: =?UTF-8?B?5Zue5aSN77yaW1BBVENIIDIvNl0gbGliL21waTogSW50cm9kdWNlIGVjIGltcGxlbWVudGF0?=
  =?UTF-8?B?aW9uIHRvIE1QSSBsaWJyYXJ5?=
X-Mailer: [Alimail-Mailagent revision 3][W4_5657687][DEFAULT][Chrome]
MIME-Version: 1.0
References: <20200121095718.52404-1-tianjia.zhang@linux.alibaba.com> <20200121095718.52404-3-tianjia.zhang@linux.alibaba.com>,<2593018.bJxuzB16oj@tauon.chronox.de>,<4de1c585-c4b1-4847-8327-55bb7fec1f3b.tianjia.zhang@linux.alibaba.com>,<f4b4442e-e2fd-44e6-9e0a-59187780b4d0.tianjia.zhang@linux.alibaba.com>,<3092f996-ce62-42e6-ab42-a56254f567b3.tianjia.zhang@linux.alibaba.com>,<4c8c9974-b777-48ba-ace3-d052932dbaa1.tianjia.zhang@linux.alibaba.com>,<b3ed010c-f3d9-46d2-97bb-c80f012f687f.tianjia.zhang@linux.alibaba.com>,<659d400e-d107-4050-84fc-bd8d39409aa3.tianjia.zhang@linux.alibaba.com>
x-aliyun-mail-creator: W4_5657687_DEFAULT_MzYTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgNi4xOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvNzkuMC4zOTQ1LjExNyBTYWZhcmkvNTM3LjM2zc
In-Reply-To: <659d400e-d107-4050-84fc-bd8d39409aa3.tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8gU3RlcGhhbiwKCj4gV2h5IGRvIHdlIG5lZWQgYSBzZWNvbmQgaW1wbGVtZW50YXRpb24g
b2YgRUNDPyBXaHkgY2FuJ3Qgd2UgcmV1c2UgdGhlIGV4aXN0aW5nIAo+IEVDQyBpbXBsZW1lbnRh
dGlvbiBpbiBjcnlwdG8vZWNjLmM/IE9yIGFyZSB0aGVyZSBsaW1pdGF0aW9ucyBpbiB0aGUgZXhp
c3RpbmcgCj4gRUNDIGltcGxlbWVudGF0aW9uIHRoYXQgY2Fubm90IGJlIGZpeGVkPwoKCgpUaGUg
aW1wbGVtZW50YXRpb24gb2YgY3J5cHRvL2VjYy5jIGlzIHN0aWxsIHJlbGF0aXZlbHkgY3J1ZGUg
YXQgcHJlc2VudCwgYW5kIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiBhIGNvbXBsZXRlIGVsbGlwdGlj
IGN1cnZlIGlzIHN0aWxsIGluY29tcGxldGUuCgoKSW4gdGhlIGJlZ2lubmluZyBJIGRpZCBkZXZl
bG9wIGJhc2VkIG9uIGNyeXB0by9lY2MuYywgYnV0IHRoZW4gSSBjb3VsZG4ndCBnbyBvbi4KCgpt
cGkvZWMuYyBpcyBiYXNlZCBvbiB0aGUgbW9yZSBtYXR1cmUgbXBpIGxpYnJhcnksIGFuZCBtcGkg
aGFzIGJlZW4gd2VsbCBpbXBsZW1lbnRlZCBpbiB0aGUga2VybmVsLiBUaGUgaW50ZXJmYWNlIGRl
ZmluaXRpb24gYW5kIG9wZXJhdGlvbnMgaGF2ZSBhIG1vcmUgbWF0dXJlIGludGVyZmFjZSwgYW5k
IHRoaXMgaW50ZXJmYWNlIGlzIGNvbXBhdGlibGUgd2l0aCB0aGUga2VybmVsLiBJdCdzIGFsc28g
dmVyeSBnb29kLCBvcGVuc3NsIGFsc28gaGFzIGEgY29ycmVzcG9uZGluZyBCSUdOVU0gc3RydWN0
dXJlLCBhIGNvbXBsZXRlIGVsbGlwdGljIGN1cnZlIHN1Y2ggYXMgc20yLCBib3RoIGVuY3J5cHRp
b24gYW5kIGRlY3J5cHRpb24gYW5kIHNpZ25hdHVyZSBhbGdvcml0aG1zLCBhbmQgdGhlcmUgYXJl
IG1hbnkgaW5jb252ZW5pZW5jZXMgYmFzZWQgb24gY3J5cHRvL2VjYy5jIGRldmVsb3BtZW50LiBB
IG1vcmUgcG93ZXJmdWwgVGhlIHVuZGVybHlpbmcgYWxnb3JpdGhtIGxpYnJhcnkgdG8gc3VwcG9y
dCwgbXBpIGZyb20gbGliZ2NyeXB0IGlzIGEgZ29vZCBjaG9pY2UuCgpJIHRoaW5rIHRoYXQgaWYg
cG9zc2libGUsIHlvdSBjYW4gYWxzbyBjb25zaWRlciBtaWdyYXRpbmcgY3J5cHRvL2VjYy5jIGJh
c2VkIGFsZ29yaXRobXMgdG8gbXBpL2VjLmMgaW4gdGhlIGZ1dHVyZSwgc28gdGhhdCBtcGkvZWMu
YyBiZWNvbWVzIGEgYmFzaWMgZWxsaXB0aWMgY3VydmUgYWxnb3JpdGhtLgoKSGVyZSBhcmUgc29t
ZSBvZiBteSBwZXJzb25hbCB2aWV3cywgd2VsY29tZSBldmVyeW9uZSB0byBkaXNjdXNzLCBhbmQg
aG9wZSB0aGF0IHRoZSBtYWludGFpbmVycyBjYW4gdGhpbmsgYWJvdXQgaXQuCgpUaGFua3MuClRp
YW5qaWE=
