Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCD3C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 09:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D97206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 09:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="MbtxIZRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389218AbgEYJBj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 05:01:39 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58280 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388182AbgEYJBi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 05:01:38 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04P8v3sP018220;
        Mon, 25 May 2020 11:01:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=KDyGfqOCsSIwAITLJsQ5jBrlVuKHDgmWtdIyUzqNc7s=;
 b=MbtxIZRDABNy6JGFuAeyoqQW+MSH1dNwtBsMzZMRvpUUPgxKq1A2kGlK32nmKveHpvBn
 42aShXiRL0AyczhV0A94sjoDGh1ydA8KGsqmhgSEPU2eDE30blI54VySxLDy4cNUxywq
 rRqOMZe7Zzhjn8tcpuwk/kwgdBDZQuUBJCRI4cil0Jmw8Ja0gwsfCLMIoy+8rzf8d3jd
 idXG7qpwX/t4rKC9mG83hseh5Hp+InkErAi8qCecVj1w+JNpuRpk9Gfk97GXcBFo+9iw
 WkJULKJWOYvavCPKaX/XDEQPjkZDL+CdOnACxyvJn5PPtjqS5+EHz2M285EaLUS/oCjY sw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 316tqgs2n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 11:01:08 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 08D86100034;
        Mon, 25 May 2020 11:01:07 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id B16C4207490;
        Mon, 25 May 2020 11:01:07 +0200 (CEST)
Received: from SFHDAG6NODE1.st.com (10.75.127.16) by SFHDAG3NODE3.st.com
 (10.75.127.9) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 25 May
 2020 11:01:07 +0200
Received: from SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27]) by
 SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27%20]) with mapi id
 15.00.1473.003; Mon, 25 May 2020 11:01:07 +0200
From:   Nicolas TOROMANOFF <nicolas.toromanoff@st.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre TORGUE" <alexandre.torgue@st.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
Thread-Topic: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
Thread-Index: AQHWMmiSDrJlXuJ7jUCG67XoujoCbKi4bbbg
Date:   Mon, 25 May 2020 09:01:07 +0000
Message-ID: <bd6cac3bd4c74db1a403df58082028fd@SFHDAG6NODE1.st.com>
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
 <20200512141113.18972-6-nicolas.toromanoff@st.com>
 <CAMj1kXGs6UgkKb5+tH2B-+26=tbjHq3UUY2gxfcRfMb1nGVuFA@mail.gmail.com>
 <67c25d90d9714a85b52f3d9c2070af88@SFHDAG6NODE1.st.com>
 <CAMj1kXGo+9aXeYppGSheqhC-pNeJCcEie+SAnWy_sAiooEDMsQ@mail.gmail.com>
In-Reply-To: <CAMj1kXGo+9aXeYppGSheqhC-pNeJCcEie+SAnWy_sAiooEDMsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.44]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-25_04:2020-05-22,2020-05-25 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
YkBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIE1heSAyNSwgMjAyMCA5OjQ2IEFNDQo+IFRv
OiBOaWNvbGFzIFRPUk9NQU5PRkYgPG5pY29sYXMudG9yb21hbm9mZkBzdC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggNS81XSBjcnlwdG86IHN0bTMyL2NyYzogcHJvdGVjdCBmcm9tIGNvbmN1
cnJlbnQgYWNjZXNzZXMNCj4gDQo+IE9uIE1vbiwgMjUgTWF5IDIwMjAgYXQgMDk6MjQsIE5pY29s
YXMgVE9ST01BTk9GRg0KPiA8bmljb2xhcy50b3JvbWFub2ZmQHN0LmNvbT4gd3JvdGU6DQo+ID4N
Cj4gPiBIZWxsbywNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+
IEZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+ID4gPiBTZW50OiBGcmlk
YXksIE1heSAyMiwgMjAyMCA2OjEyIFBNPg0KPiA+ID4gT24gVHVlLCAxMiBNYXkgMjAyMCBhdCAx
NjoxMywgTmljb2xhcyBUb3JvbWFub2ZmDQo+ID4gPiA8bmljb2xhcy50b3JvbWFub2ZmQHN0LmNv
bT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IFByb3RlY3QgU1RNMzIgQ1JDIGRldmljZSBmcm9t
IGNvbmN1cnJlbnQgYWNjZXNzZXMuDQo+ID4gPiA+DQo+ID4gPiA+IEFzIHdlIGNyZWF0ZSBhIHNw
aW5sb2NrZWQgc2VjdGlvbiB0aGF0IGluY3JlYXNlIHdpdGggYnVmZmVyIHNpemUsDQo+ID4gPiA+
IHdlIHByb3ZpZGUgYSBtb2R1bGUgcGFyYW1ldGVyIHRvIHJlbGVhc2UgdGhlIHByZXNzdXJlIGJ5
IHNwbGl0dGluZw0KPiA+ID4gPiBjcml0aWNhbCBzZWN0aW9uIGluIGNodW5rcy4NCj4gPiA+ID4N
Cj4gPiA+ID4gU2l6ZSBvZiBlYWNoIGNodW5rIGlzIGRlZmluZWQgaW4gYnVyc3Rfc2l6ZSBtb2R1
bGUgcGFyYW1ldGVyLg0KPiA+ID4gPiBCeSBkZWZhdWx0IGJ1cnN0X3NpemU9MCwgaS5lLiBkb24n
dCBzcGxpdCBpbmNvbWluZyBidWZmZXIuDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6
IE5pY29sYXMgVG9yb21hbm9mZiA8bmljb2xhcy50b3JvbWFub2ZmQHN0LmNvbT4NCj4gPiA+DQo+
ID4gPiBXb3VsZCB5b3UgbWluZCBleHBsYWluaW5nIHRoZSB1c2FnZSBtb2RlbCBoZXJlPyBJdCBs
b29rcyBsaWtlIHlvdQ0KPiA+ID4gYXJlIHNoYXJpbmcgYSBDUkMgaGFyZHdhcmUgYWNjZWxlcmF0
b3Igd2l0aCBhIHN5bmNocm9ub3VzIGludGVyZmFjZQ0KPiA+ID4gYmV0d2VlbiBkaWZmZXJlbnQg
dXNlcnMgYnkgdXNpbmcgc3BpbmxvY2tzPyBZb3UgYXJlIGF3YXJlIHRoYXQgdGhpcw0KPiA+ID4g
d2lsbCB0aWUgdXAgdGhlIHdhaXRpbmcgQ1BVcyBjb21wbGV0ZWx5IGR1cmluZyB0aGlzIHRpbWUs
IHJpZ2h0PyBTbw0KPiA+ID4gaXQgd291bGQgYmUgbXVjaCBiZXR0ZXIgdG8gdXNlIGEgbXV0ZXgg
aGVyZS4gT3IgcGVyaGFwcyBpdCB3b3VsZA0KPiA+ID4gbWFrZSBtb3JlIHNlbnNlIHRvIGZhbGwg
YmFjayB0byBhIHMvdyBiYXNlZCBDUkMgcm91dGluZSBpZiB0aGUgaC93IGlzIHRpZWQgdXANCj4g
d29ya2luZyBmb3IgYW5vdGhlciB0YXNrPw0KPiA+DQo+ID4gSSBrbm93IG11dGV4IGFyZSBtb3Jl
IGFjY2VwdGFibGUgaGVyZSwgYnV0IHNoYXNoIF91cGRhdGUoKSBhbmQgX2luaXQoKQ0KPiA+IG1h
eSBiZSBjYWxsIGZyb20gYW55IGNvbnRleHQsIGFuZCBzbyBJIGNhbm5vdCB0YWtlIGEgbXV0ZXgu
DQo+ID4gQW5kIHRvIHByb3RlY3QgbXkgY29uY3VycmVudCBIVyBhY2Nlc3MgSSBvbmx5IHRob3Vn
aCBhYm91dCBzcGlubG9jay4NCj4gPiBEdWUgdG8gcG9zc2libGUgY29uc3RyYWludCBvbiBDUFVz
LCBJIGFkZCBhIGJ1cnN0X3NpemUgb3B0aW9uIHRvIGZvcmNlDQo+ID4gc2xpdHRpbmcgbG9uZyBi
dWZmZXIgaW50byBzbWFsbGVyIG9uZSwgYW5kIHNvIGRlY3JlYXNlIHRpbWUgd2UgdGFrZSB0aGUg
bG9jay4NCj4gPiBCdXQgSSBkaWRuJ3QgdGhvdWdoIHRvIGZhbGxiYWNrIHRvIHNvZnR3YXJlIENS
Qy4NCj4gPg0KPiA+IEknbGwgZG8gYSBwYXRjaCBvbiB0b3AuDQo+ID4gSW4gaW4gdGhlIGJ1cnN0
X3VwZGF0ZSgpIGZ1bmN0aW9uIEknbGwgdXNlIGEgc3Bpbl90cnlsb2NrX2lycXNhdmUoKSBhbmQg
dXNlDQo+IHNvZnR3YXJlIENSQzMyIGlmIEhXIGlzIGFscmVhZHkgaW4gdXNlLg0KPiA+DQo+IA0K
PiBSaWdodC4gSSBkaWRuJ3QgZXZlbiBub3RpY2UgdGhhdCB5b3Ugd2VyZSBrZWVwaW5nIGludGVy
cnVwdHMgZGlzYWJsZWQgdGhlIHdob2xlDQo+IHRpbWUgd2hlbiB1c2luZyB0aGUgaC93IGJsb2Nr
LiBUaGF0IG1lYW5zIHRoYXQgYW55IHNlcmlvdXMgdXNlIG9mIHRoaXMgaC93DQo+IGJsb2NrIHdp
bGwgbWFrZSBJUlEgbGF0ZW5jeSBnbyB0aHJvdWdoIHRoZSByb29mLg0KPiANCj4gSSByZWNvbW1l
bmQgdGhhdCB5b3UgZ28gYmFjayB0byB0aGUgZHJhd2luZyBib2FyZCBvbiB0aGlzIGRyaXZlciwg
cmF0aGVyIHRoYW4NCj4gcGFwZXJpbmcgb3ZlciB0aGUgaXNzdWVzIHdpdGggYSBzcGluX3RyeWxv
Y2soKS4gUGVyaGFwcyBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8NCj4gbW9kZWwgaXQgYXMgYSBhaGFz
aCAoZXZlbiB0aG91Z2ggdGhlIGgvdyBibG9jayBpdHNlbGYgaXMgc3luY2hyb25vdXMpIGFuZCB1
c2UgYQ0KPiBrdGhyZWFkIHRvIGZlZWQgaW4gdGhlIGRhdGEuDQoNCkkgdGhvdWdodCB3aGVuIEkg
dXBkYXRlZCB0aGUgZHJpdmVyIHRvIG1vdmUgdG8gYSBhaGFzaCBpbnRlcmZhY2UsIGJ1dCB0aGUg
bWFpbiB1c2FnZQ0Kb2YgY3JjMzIgaXMgdGhlIGV4dDQgZnMsIHRoYXQgY2FsbHMgdGhlIHNoYXNo
IEFQSS4NCkNvbW1pdCA4NzdiNTY5MWYyN2EgKCJjcnlwdG86IHNoYXNoIC0gcmVtb3ZlIHNoYXNo
X2Rlc2M6OmZsYWdzIikgcmVtb3ZlZCBwb3NzaWJpbGl0eQ0KdG8gc2xlZXAgaW4gc2hhc2ggY2Fs
bGJhY2suIChiZWZvcmUgdGhpcyBjb21taXQgYW5kIHdpdGggTUFZX1NMRUVQIG9wdGlvbiBzZXQs
IHVzaW5nIA0KYSBtdXRleCBtYXkgaGF2ZSBiZWVuIGZpbmUpLg0KDQpCeSBub3cgdGhlIHNvbHV0
aW9uIEkgc2VlIGlzIHRvIHVzZSB0aGUgc3Bpbl90cnlsb2NrX2lycXNhdmUoKSwgZmFsbGJhY2sg
dG8gc29mdHdhcmUgY3JjICpBTkQqIGNhcHBpbmcgYnVyc3Rfc2l6ZQ0KdG8gZW5zdXJlIHRoZSBs
b2NrZWQgc2VjdGlvbiBzdGF5IHJlYXNvbmFibGUuDQoNCkRvZXMgdGhpcyBzZWVtcyBhY2NlcHRh
YmxlID8NCg0KTmljb2xhcy4NCiANCg==
