Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFD6C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 14:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9914C206F0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 14:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BAVmAcet"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfK0OXV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:23:21 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:15498 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727118AbfK0OXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 09:23:19 -0500
X-UUID: f8ae20a4f1ad42c1ba79108682bc28a7-20191127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=WFphvlMRaDKdtjVxAem+AWZT/bf0cnW1dQzo9Dpt9Co=;
        b=BAVmAcettnKIN1LE0bkG5QTvcqrXyT6Lq4JIDlH38hYhfJ8FTOlxN3QoH1xjhx1wWhwxunCIiuk/H10ksaFLNX9EmECaOLGB0dOp2Gq5OUwYBI76/NEVoOh6EpOkq9vVtUI/U3c8mH5lnHnhQTvLPen0WfOhLgbefYONPOT/2Dw=;
X-UUID: f8ae20a4f1ad42c1ba79108682bc28a7-20191127
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 433868931; Wed, 27 Nov 2019 22:23:10 +0800
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
Subject: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
Date:   Wed, 27 Nov 2019 22:22:58 +0800
Message-ID: <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
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

Rm9yIE1lZGlhVGVrIFNvQ3Mgb24gQVJNdjggd2l0aCBUcnVzdFpvbmUgZW5hYmxlZCwgcGVyaXBo
ZXJhbHMgbGlrZQ0KZW50cm9weSBzb3VyY2VzIGlzIG5vdCBhY2Nlc3NpYmxlIGZyb20gbm9ybWFs
IHdvcmxkIChsaW51eCkgYW5kDQpyYXRoZXIgYWNjZXNzaWJsZSBmcm9tIHNlY3VyZSB3b3JsZCAo
QVRGL1RFRSkgb25seS4gVGhpcyBkcml2ZXIgYWltcw0KdG8gcHJvdmlkZSBhIGdlbmVyaWMgaW50
ZXJmYWNlIHRvIEFURiBybmcgc2VydmljZS4NCg0KU2lnbmVkLW9mZi1ieTogTmVhbCBMaXUgPG5l
YWwubGl1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZp
ZyAgICAgICB8ICAgMTYgKysrKysrDQogZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9NYWtlZmlsZSAg
ICAgIHwgICAgMSArDQogZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9tdGstc2VjLXJuZy5jIHwgIDEw
MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogMyBmaWxlcyBjaGFuZ2VkLCAx
MjAgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL2NoYXIvaHdfcmFu
ZG9tL210ay1zZWMtcm5nLmMNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9od19yYW5kb20v
S2NvbmZpZyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZw0KaW5kZXggMjVhN2Q4Zi4u
ZjA4Yzg1MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZw0KKysr
IGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnDQpAQCAtMzk4LDYgKzM5OCwyMiBAQCBj
b25maWcgSFdfUkFORE9NX01USw0KIA0KIAkgIElmIHVuc3VyZSwgc2F5IFkuDQogDQorY29uZmln
IEhXX1JBTkRPTV9NVEtfU0VDDQorCXRyaXN0YXRlICJNZWRpYVRlayBTZWN1cml0eSBSYW5kb20g
TnVtYmVyIEdlbmVyYXRvciBzdXBwb3J0Ig0KKwlkZXBlbmRzIG9uIEhXX1JBTkRPTQ0KKwlkZXBl
bmRzIG9uIEFSQ0hfTUVESUFURUsgfHwgQ09NUElMRV9URVNUDQorCWRlZmF1bHQgSFdfUkFORE9N
DQorCSAgaGVscA0KKwkgIFRoaXMgZHJpdmVyIHByb3ZpZGVzIGtlcm5lbC1zaWRlIHN1cHBvcnQg
Zm9yIHRoZSBSYW5kb20gTnVtYmVyDQorCSAgR2VuZXJhdG9yIGhhcmR3YXJlIGZvdW5kIG9uIE1l
ZGlhVGVrIFNvQ3MuIFRoZSBkaWZmZXJlbmNlIHdpdGgNCisJICBtdGstcm5nIGlzIHRoZSBSYW5k
b20gTnVtYmVyIEdlbmVyYXRvciBoYXJkd2FyZSBpcyBzZWN1cmUNCisJICBhY2Nlc3Mgb25seS4N
CisNCisJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBoZXJl
LiB0aGUNCisJICBtb2R1bGUgd2lsbCBiZSBjYWxsZWQgbXRrLXNlYy1ybmcuDQorDQorCSAgSWYg
dW5zdXJlLCBzYXkgWS4NCisNCiBjb25maWcgSFdfUkFORE9NX1MzOTANCiAJdHJpc3RhdGUgIlMz
OTAgVHJ1ZSBSYW5kb20gTnVtYmVyIEdlbmVyYXRvciBzdXBwb3J0Ig0KIAlkZXBlbmRzIG9uIFMz
OTANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL01ha2VmaWxlIGIvZHJpdmVy
cy9jaGFyL2h3X3JhbmRvbS9NYWtlZmlsZQ0KaW5kZXggN2M5ZWY0YS4uYmVlNTQxMiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvY2hhci9od19yYW5kb20vTWFrZWZpbGUNCisrKyBiL2RyaXZlcnMvY2hh
ci9od19yYW5kb20vTWFrZWZpbGUNCkBAIC0zNiw2ICszNiw3IEBAIG9iai0kKENPTkZJR19IV19S
QU5ET01fUElDMzIpICs9IHBpYzMyLXJuZy5vDQogb2JqLSQoQ09ORklHX0hXX1JBTkRPTV9NRVNP
TikgKz0gbWVzb24tcm5nLm8NCiBvYmotJChDT05GSUdfSFdfUkFORE9NX0NBVklVTSkgKz0gY2F2
aXVtLXJuZy5vIGNhdml1bS1ybmctdmYubw0KIG9iai0kKENPTkZJR19IV19SQU5ET01fTVRLKQkr
PSBtdGstcm5nLm8NCitvYmotJChDT05GSUdfSFdfUkFORE9NX01US19TRUMpCSs9IG10ay1zZWMt
cm5nLm8NCiBvYmotJChDT05GSUdfSFdfUkFORE9NX1MzOTApICs9IHMzOTAtdHJuZy5vDQogb2Jq
LSQoQ09ORklHX0hXX1JBTkRPTV9LRVlTVE9ORSkgKz0ga3Mtc2Etcm5nLm8NCiBvYmotJChDT05G
SUdfSFdfUkFORE9NX09QVEVFKSArPSBvcHRlZS1ybmcubw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y2hhci9od19yYW5kb20vbXRrLXNlYy1ybmcuYyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20vbXRr
LXNlYy1ybmcuYw0KbmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAuLjY5ZGRlY2EN
Ci0tLSAvZGV2L251bGwNCisrKyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20vbXRrLXNlYy1ybmcu
Yw0KQEAgLTAsMCArMSwxMDMgQEANCisvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MA0KKy8qDQorICogQ29weXJpZ2h0IChDKSAyMDE5IE1lZGlhVGVrIEluYy4NCisgKi8NCisNCisj
aW5jbHVkZSA8bGludXgvYXJtLXNtY2NjLmg+DQorI2luY2x1ZGUgPGxpbnV4L2h3X3JhbmRvbS5o
Pg0KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCisjaW5jbHVkZSA8bGludXgvb2YuaD4NCisj
aW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+DQorI2luY2x1ZGUgPGxpbnV4L3NvYy9t
ZWRpYXRlay9tdGtfc2lwX3N2Yy5oPg0KKw0KKyNkZWZpbmUgTVRLX1NFQ19STkdfTUFHSUMJMHg3
NDcyNmU2Nw0KKyNkZWZpbmUgU01DX1JFVF9OVU0JCTQNCisjZGVmaW5lIE1US19TRUNfUk5EX1NJ
WkUJKHNpemVvZih1MzIpICogU01DX1JFVF9OVU0pDQorDQorc3RhdGljIHZvaWQgbXRrX3NlY19n
ZXRfcm5kKHVpbnQzMl90ICp2YWwpDQorew0KKwlzdHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQor
DQorCWFybV9zbWNjY19zbWMoTVRLX1NJUF9LRVJORUxfR0VUX1JORCwNCisJCSAgICAgIE1US19T
RUNfUk5HX01BR0lDLCAwLCAwLCAwLCAwLCAwLCAwLCAmcmVzKTsNCisNCisJdmFsWzBdID0gcmVz
LmEwOw0KKwl2YWxbMV0gPSByZXMuYTE7DQorCXZhbFsyXSA9IHJlcy5hMjsNCisJdmFsWzNdID0g
cmVzLmEzOw0KK30NCisNCitzdGF0aWMgaW50IG10a19zZWNfcm5nX3JlYWQoc3RydWN0IGh3cm5n
ICpybmcsIHZvaWQgKmJ1Ziwgc2l6ZV90IG1heCwgYm9vbCB3YWl0KQ0KK3sNCisJdTMyIHZhbFs0
XSA9IHswfTsNCisJaW50IHJldHZhbCA9IDA7DQorCWludCBpOw0KKw0KKwl3aGlsZSAobWF4ID49
IE1US19TRUNfUk5EX1NJWkUpIHsNCisJCW10a19zZWNfZ2V0X3JuZCh2YWwpOw0KKw0KKwkJZm9y
IChpID0gMDsgaSA8IFNNQ19SRVRfTlVNOyBpKyspIHsNCisJCQkqKHUzMiAqKWJ1ZiA9IHZhbFtp
XTsNCisJCQlidWYgKz0gc2l6ZW9mKHUzMik7DQorCQl9DQorDQorCQlyZXR2YWwgKz0gTVRLX1NF
Q19STkRfU0laRTsNCisJCW1heCAtPSBNVEtfU0VDX1JORF9TSVpFOw0KKwl9DQorDQorCXJldHVy
biByZXR2YWw7DQorfQ0KKw0KK3N0YXRpYyBzdHJ1Y3QgaHdybmcgbXRrX3NlY19ybmcgPSB7DQor
CS5uYW1lID0gIm10a19zZWNfcm5nIiwNCisJLnJlYWQgPSBtdGtfc2VjX3JuZ19yZWFkLA0KKwku
cXVhbGl0eSA9IDkwMCwNCit9Ow0KKw0KK3N0YXRpYyBpbnQgbXRrX3NlY19ybmdfcHJvYmUodm9p
ZCkNCit7DQorCWludCByZXQ7DQorDQorCXJldCA9IGh3cm5nX3JlZ2lzdGVyKCZtdGtfc2VjX3Ju
Zyk7DQorCWlmIChyZXQpIHsNCisJCXByX2VycigiRmFpbGVkIHRvIHJlZ2lzdGVyIHJuZyBkZXZp
Y2U6ICVkXG4iLCByZXQpOw0KKwkJcmV0dXJuIHJldDsNCisJfQ0KKw0KKwlyZXR1cm4gMDsNCit9
DQorDQorc3RhdGljIGludCBfX2luaXQgbXRrX3NlY19ybmdfZHJpdmVyX2luaXQodm9pZCkNCit7
DQorCXN0cnVjdCBkZXZpY2Vfbm9kZSAqZndfbnA7DQorCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbnA7
DQorCWNvbnN0IGNoYXIgKm1ldGhvZDsNCisNCisJZndfbnAgPSBvZl9maW5kX25vZGVfYnlfbmFt
ZShOVUxMLCAiZmlybXdhcmUiKTsNCisJaWYgKCFmd19ucCkNCisJCXJldHVybiAtRU5PREVWOw0K
Kw0KKwlucCA9IG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlKGZ3X25wLCBOVUxMLCAibWVkaWF0ZWss
bXRrLXNlYy1ybmciKTsNCisJaWYgKCFucCkNCisJCXJldHVybiAtRU5PREVWOw0KKw0KKwlpZiAo
b2ZfcHJvcGVydHlfcmVhZF9zdHJpbmcobnAsICJtZXRob2QiLCAmbWV0aG9kKSkNCisJCXJldHVy
biAtRU5YSU87DQorDQorCWlmIChzdHJuY21wKCJzbWMiLCBtZXRob2QsIHN0cmxlbigic21jIikp
KQ0KKwkJcmV0dXJuIC1FSU5WQUw7DQorDQorCXJldHVybiBtdGtfc2VjX3JuZ19wcm9iZSgpOw0K
K30NCisNCitzdGF0aWMgdm9pZCBfX2V4aXQgbXRrX3NlY19ybmdfZHJpdmVyX2V4aXQodm9pZCkN
Cit7DQorCWh3cm5nX3VucmVnaXN0ZXIoJm10a19zZWNfcm5nKTsNCit9DQorDQorbW9kdWxlX2lu
aXQobXRrX3NlY19ybmdfZHJpdmVyX2luaXQpOw0KK21vZHVsZV9leGl0KG10a19zZWNfcm5nX2Ry
aXZlcl9leGl0KTsNCisNCitNT0RVTEVfREVTQ1JJUFRJT04oIk1lZGlhVGVrIFNlY3VyaXR5IFJh
bmRvbSBOdW1iZXIgR2VuZXJhdG9yIERyaXZlciIpOw0KK01PRFVMRV9BVVRIT1IoIk5lYWwgTGl1
IDxuZWFsLmxpdUBtZWRpYXRlay5jb20+Iik7DQorTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KLS0g
DQoxLjcuOS41DQo=

