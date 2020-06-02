Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE71C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 08:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA141207D0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 08:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ayp5EPbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgFBIPD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 04:15:03 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:32303 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725969AbgFBIPD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 04:15:03 -0400
X-UUID: ff0a8006aa3c4cccaa61a2de3c5c5dcf-20200602
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=MbF+LRzExa+XY/pBtDs6ophTBP7J5P1UhRlTOBIVSUM=;
        b=Ayp5EPbzHxXWe0W59NethZ6tLIRxQN/3dsP7Nb2bZAh2nImDno9/5J5HztFRF+h0TExeyoUYposQKC2BSFJwk4ysdKl6XOnN7HrB42bLkDYjRzwsikDDq9Ip4OJhaARjUpSslGVFK/QE2XYnenLDO8sKGRhUmQHCfMydCxGV99o=;
X-UUID: ff0a8006aa3c4cccaa61a2de3c5c5dcf-20200602
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 587594661; Tue, 02 Jun 2020 16:15:00 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 2 Jun 2020 16:14:59 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Jun 2020 16:14:58 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Neal Liu <neal.liu@mediatek.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>
Subject: [PATCH v6 1/2] dt-bindings: rng: add bindings for sec-rng
Date:   Tue, 2 Jun 2020 16:14:37 +0800
Message-ID: <1591085678-22764-2-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QWRkIGJpbmRpbmdzIGZvciBBUk0gVHJ1c3Rab25lIGJhc2VkIFNlY3VyaXR5IFJhbmRvbQ0KTnVt
YmVyIEdlbmVyYXRvci4NCg0KU2lnbmVkLW9mZi1ieTogTmVhbCBMaXUgPG5lYWwubGl1QG1lZGlh
dGVrLmNvbT4NCi0tLQ0KIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvc2Vj
LXJuZy55YW1sIHwgICA1MyArKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA1
MyBpbnNlcnRpb25zKCspDQogY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9ybmcvc2VjLXJuZy55YW1sDQoNCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL3NlYy1ybmcueWFtbCBiL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvc2VjLXJuZy55YW1sDQpuZXcgZmlsZSBtb2RlIDEwMDY0
NA0KaW5kZXggMDAwMDAwMC4uN2Y0YWU1MA0KLS0tIC9kZXYvbnVsbA0KKysrIGIvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9zZWMtcm5nLnlhbWwNCkBAIC0wLDAgKzEsNTMg
QEANCisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiAoR1BMLTIuMCBPUiBCU0QtMi1DbGF1c2Up
DQorIyAjIENvcHlyaWdodCAyMDIwIE1lZGlhVGVrIEluYy4NCislWUFNTCAxLjINCistLS0NCisk
aWQ6ICJodHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy9ybmcvc2VjLXJuZy55YW1sIyINCisk
c2NoZW1hOiAiaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwjIg0K
Kw0KK3RpdGxlOiBTZWN1cml0eSBSYW5kb20gTnVtYmVyIEdlbmVyYXRvcg0KKw0KK2Rlc2NyaXB0
aW9uOiB8DQorICBzZWMtcm5nIGlzIGEgc2VjdXJpdHkgcmFuZG9tIG51bWJlciBnZW5lcmF0b3Ig
d2hpY2ggcHJvdmlkZXMgYSBnZW5lcmljDQorICBpbnRlcmZhY2UgdG8gZ2V0IGhhcmR3YXJlIHJu
ZCBmcm9tIFNlY3VyZSBzdGF0ZS4gVGhlIFNlY3VyZSBzdGF0ZSBjYW4gYmUNCisgIEFybSBUcnVz
dGVkIEZpcm13YXJlKEFURiksIFRydXN0ZWQgRXhlY3V0aW9uIEVudmlyb25tZW50KFRFRSksIG9y
IGV2ZW4NCisgIEVMMiBoeXBlcnZpc29yLg0KKw0KK21haW50YWluZXI6DQorICAtIE5lYWwgTGl1
IDxuZWFsLmxpdUBtZWRpYXRlay5jb20+DQorDQorcHJvcGVydGllczoNCisgIGNvbXBhdGlibGU6
DQorICAgIGVudW06DQorICAgICAgLSBhcm0sc2VjLXJuZw0KKw0KKyAgbWV0aG9kOg0KKyAgICBk
ZXNjcmlwdGlvbjogVGhlIG1ldGhvZCBvZiBjYWxsaW5nIHRvIFNlY3VyZSBzdGF0ZQ0KKyAgICBl
bnVtOg0KKyAgICAgIC0gc21jDQorICAgICAgLSBodmMNCisNCisgIG1ldGhvZC1maWQ6DQorICAg
IGRlc2NyaXB0aW9uOiBUaGUgZnVuY3Rpb24gbnVtYmVyIHdpdGhpbiB0aGUgU01DIGFuZCBIVkMg
ZnVuY3Rpb24gaWRlbnRpZmllcg0KKyAgICBtYXhJdGVtczogMQ0KKw0KKyAgcXVhbGl0eToNCisg
ICAgZGVzY3JpcHRpb246IEVzdGltYXRpb24gb2YgdHJ1ZSBlbnRyb3B5IGluIFJORydzIGJpdHN0
cmVhbSBwZXIgMTAyNCBiaXRzDQorICAgIG1heEl0ZW1zOiAxDQorDQorcmVxdWlyZWQ6DQorICAt
IGNvbXBhdGlibGUNCisgIC0gbWV0aG9kcw0KKyAgLSBtZXRob2QtZmlkDQorICAtIHF1YWxpdHkN
CisNCithZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UNCisNCitleGFtcGxlczoNCisgIC0gfA0K
KyAgICBod3JuZzogaHdybmcgew0KKyAgICAgICAgICAgIGNvbXBhdGlibGUgPSAiYXJtLHNlYy1y
bmciOw0KKyAgICAgICAgICAgIG1ldGhvZCA9ICJzbWMiOw0KKyAgICAgICAgICAgIG1ldGhvZC1m
aWQgPSAvYml0cy8gMTYgPDB4MjZhPjsNCisgICAgICAgICAgICBxdWFsaXR5ID0gL2JpdHMvIDE2
IDw5MDA+Ow0KKyAgICB9Ow0KLS0gDQoxLjcuOS41DQo=

