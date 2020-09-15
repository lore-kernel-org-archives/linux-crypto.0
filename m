Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908B6C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 22:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FBF20795
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 22:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="yXJ1OBpP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgIOWnk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:43:40 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:9240 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727440AbgIOPzp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 11:55:45 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FFhaGC017288;
        Tue, 15 Sep 2020 17:54:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=xiFhVzR1YyqGzg2OheLi0xZmDY1r+Df1efVdmesMDrs=;
 b=yXJ1OBpPKdC02sxYdOGPBGVcEih1BjLc1inPNM7UXQ9ma1jBybK/Ur4xgJPHBq6vouiw
 24iBFiloH/Kxkr8PR+3STffYTp0lz5qP2qi+ZI6PoUI8JMHbkzFeX+hgu/eePGH8DXDj
 VbPxpqw3GdBEWb9s1TEJneaRuJ3HRlGrcteJy2YSYnlzwPCcK9gFs2Ybjab4s0w3hgYV
 YZ5TpypfeI4uXgAmOyptsdQRQIZ26/9Y9cfNIZ/rGwzgziUvIcmQyJP9IXLaVn9TjYNY
 J7wx6YllWxMX+RilZYB5iGWM+kV92VYLUePQ63MI7mikXiVBR6tnT4EquZ+zDY1waQZG Wg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 33gkt0gpac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 17:54:44 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0E08D10002A;
        Tue, 15 Sep 2020 17:54:41 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 995D02BA2DB;
        Tue, 15 Sep 2020 17:54:41 +0200 (CEST)
Received: from SFHDAG6NODE1.st.com (10.75.127.16) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 17:54:41 +0200
Received: from SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27]) by
 SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27%20]) with mapi id
 15.00.1473.003; Tue, 15 Sep 2020 17:54:41 +0200
From:   Nicolas TOROMANOFF <nicolas.toromanoff@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: stm32/crc32 - Avoid lock if hardware is already
 used
Thread-Topic: [PATCH] crypto: stm32/crc32 - Avoid lock if hardware is already
 used
Thread-Index: AQHWgq4lZ9k8lMJnVkmAkne1J9B/yKliwQwAgAcJHIA=
Date:   Tue, 15 Sep 2020 15:54:41 +0000
Message-ID: <28561e25-1140-9a08-1546-4422150b65f7@st.com>
References: <20200904112527.15677-1-nicolas.toromanoff@st.com>
 <20200911042816.GA5531@gondor.apana.org.au>
In-Reply-To: <20200911042816.GA5531@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.49]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BA07147189E834E80D683C23146B657@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_11:2020-09-15,2020-09-15 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8gSGVyYmVydCwNCg0KT24gOS8xMS8yMCA2OjI4IEFNLCBIZXJiZXJ0IFh1IHdyb3RlOg0K
PiBPbiBGcmksIFNlcCAwNCwgMjAyMCBhdCAwMToyNToyN1BNICswMjAwLCBOaWNvbGFzIFRvcm9t
YW5vZmYgd3JvdGU6DQo+PiBJZiBTVE0zMiBDUkMgZGV2aWNlIGlzIGFscmVhZHkgaW4gdXNlLCBj
YWxjdWxhdGUgQ1JDIGJ5IHNvZnR3YXJlLg0KPj4NCj4+IFRoaXMgd2lsbCByZWxlYXNlIENQVSBj
b25zdHJhaW50IGZvciBhIGNvbmN1cnJlbnQgYWNjZXNzIHRvIHRoZQ0KPj4gaGFyZHdhcmUsIGFu
ZCBhdm9pZCBtYXNraW5nIGlycXMgZHVyaW5nIHRoZSB3aG9sZSBibG9jayBwcm9jZXNzaW5nLg0K
Pj4NCj4+IEZpeGVzOiA3Nzk1YzBiYWY1YWMgKCJjcnlwdG86IHN0bTMyL2NyYzMyIC0gcHJvdGVj
dCBmcm9tIGNvbmN1cnJlbnQgYWNjZXNzZXMiKQ0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IE5pY29s
YXMgVG9yb21hbm9mZiA8bmljb2xhcy50b3JvbWFub2ZmQHN0LmNvbT4NCj4+IC0tLQ0KPj4gICBk
cml2ZXJzL2NyeXB0by9zdG0zMi9LY29uZmlnICAgICAgIHwgIDIgKysNCj4+ICAgZHJpdmVycy9j
cnlwdG8vc3RtMzIvc3RtMzItY3JjMzIuYyB8IDE1ICsrKysrKysrKysrKy0tLQ0KPj4gICAyIGZp
bGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL3N0bTMyL0tjb25maWcgYi9kcml2ZXJzL2NyeXB0by9z
dG0zMi9LY29uZmlnDQo+PiBpbmRleCA0ZWYzZWIxMTM2MWMuLjhkNjA1YjA3NTcxZiAxMDA2NDQN
Cj4+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL3N0bTMyL0tjb25maWcNCj4+ICsrKyBiL2RyaXZlcnMv
Y3J5cHRvL3N0bTMyL0tjb25maWcNCj4+IEBAIC0zLDYgKzMsOCBAQCBjb25maWcgQ1JZUFRPX0RF
Vl9TVE0zMl9DUkMNCj4+ICAgCXRyaXN0YXRlICJTdXBwb3J0IGZvciBTVE0zMiBjcmMgYWNjZWxl
cmF0b3JzIg0KPj4gICAJZGVwZW5kcyBvbiBBUkNIX1NUTTMyDQo+PiAgIAlzZWxlY3QgQ1JZUFRP
X0hBU0gNCj4+ICsJc2VsZWN0IENSWVBUT19DUkMzMg0KPj4gKwlzZWxlY3QgQ1JZUFRPX0NSQzMy
Qw0KPiANCj4gU2hvdWxkbid0IHRoaXMgYmUgInNlbGVjdCBDUkMzMiI/DQoNCkNvcnJlY3QgInNl
bGVjdCBDUkMzMiIgaXMgZW5vdWdoLg0KSSdsbCBzZW5kIGEgdmVyc2lvbiAyIHdpdGggb25seSAi
c2VsZWN0IENSQzMyIi4NCg0KDQpOaWNvbGFzLg==
