Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246A4C43141
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 14:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F160220722
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 14:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EzTjMomL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfK0OXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:23:18 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:1717 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727110AbfK0OXQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 09:23:16 -0500
X-UUID: 695ff62ccf764860acc752bf81681567-20191127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=XT/G2yriU9FAqiGTOGeP2soGRJGALmOSQNcBdYat3Dk=;
        b=EzTjMomLjrDJ5/9WWmqbjZgmsu+NzkWxfFfvjs6w62V67LKwajdEgB9WkwIS5/dlc4zOCec2xbrE9DkdI+HNls0WsOFG0TsaQLpUtmyIYESRXmQZQd1b80F5bxvNRam/cPVO/Dgg/XpKIKibT3C5HSoqmxKK0jGnc/JUM2gH8K4=;
X-UUID: 695ff62ccf764860acc752bf81681567-20191127
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 555486096; Wed, 27 Nov 2019 22:23:10 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 27 Nov 2019 22:23:05 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 27 Nov 2019 22:23:03 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>
Subject: [PATCH v5 1/3] soc: mediatek: add SMC fid table for SIP interface
Date:   Wed, 27 Nov 2019 22:22:56 +0800
Message-ID: <1574864578-467-2-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

MS4gQWRkIGEgaGVhZGVyIGZpbGUgdG8gcHJvdmlkZSBTSVAgaW50ZXJmYWNlIHRvIEFURg0KMi4g
QWRkIGh3cm5nIFNNQyBmaWQNCg0KU2lnbmVkLW9mZi1ieTogTmVhbCBMaXUgPG5lYWwubGl1QG1l
ZGlhdGVrLmNvbT4NCi0tLQ0KIGluY2x1ZGUvbGludXgvc29jL21lZGlhdGVrL210a19zaXBfc3Zj
LmggfCAgIDMzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2Vk
LCAzMyBpbnNlcnRpb25zKCspDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvbGludXgvc29j
L21lZGlhdGVrL210a19zaXBfc3ZjLmgNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc29j
L21lZGlhdGVrL210a19zaXBfc3ZjLmggYi9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtf
c2lwX3N2Yy5oDQpuZXcgZmlsZSBtb2RlIDEwMDY0NA0KaW5kZXggMDAwMDAwMC4uOGNjOGI1Yw0K
LS0tIC9kZXYvbnVsbA0KKysrIGIvaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9z
dmMuaA0KQEAgLTAsMCArMSwzMyBAQA0KKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wICovDQorLyoNCisgKiBDb3B5cmlnaHQgKGMpIDIwMTkgTWVkaWFUZWsgSW5jLg0KKyAqLw0K
Kw0KKyNpZm5kZWYgX01US19TRUNVUkVfQVBJX0hfDQorI2RlZmluZSBfTVRLX1NFQ1VSRV9BUElf
SF8NCisNCisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+DQorDQorLyogRXJyb3IgQ29kZSAqLw0K
KyNkZWZpbmUgU0lQX1NWQ19FX1NVQ0NFU1MJCTANCisjZGVmaW5lIFNJUF9TVkNfRV9OT1RfU1VQ
UE9SVEVECQktMQ0KKyNkZWZpbmUgU0lQX1NWQ19FX0lOVkFMSURfUEFSQU1TCS0yDQorI2RlZmlu
ZSBTSVBfU1ZDX0VfSU5WQUxJRF9SQU5HRQkJLTMNCisjZGVmaW5lIFNJUF9TVkNfRV9QRVJNSVNT
SU9OX0RFTlkJLTQNCisNCisjaWZkZWYgQ09ORklHX0FSTTY0DQorI2RlZmluZSBNVEtfU0lQX1NN
Q19BQVJDSF9CSVQJCUJJVCgzMCkNCisjZWxzZQ0KKyNkZWZpbmUgTVRLX1NJUF9TTUNfQUFSQ0hf
QklUCQkwDQorI2VuZGlmDQorDQorLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCisgKiBEZWZpbmVz
IGZvciBNZWRpYXRlayBydW50aW1lIHNlcnZpY2VzIGZ1bmMgaWRzDQorICoqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKi8NCisNCisvKiBTZWN1cml0eSByZWxhdGVkIFNNQyBjYWxsICovDQorLyogSFdSTkcg
Ki8NCisjZGVmaW5lIE1US19TSVBfS0VSTkVMX0dFVF9STkQgXA0KKwkoMHg4MjAwMDI2QSB8IE1U
S19TSVBfU01DX0FBUkNIX0JJVCkNCisNCisjZW5kaWYgLyogX01US19TRUNVUkVfQVBJX0hfICov
DQotLSANCjEuNy45LjUNCg==

