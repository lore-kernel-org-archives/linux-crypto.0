Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4533BC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 10:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D3C0218FD
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 10:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfCUKrJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:47:09 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48283 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727891AbfCUKrJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 06:47:09 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2LAfYNO029300;
        Thu, 21 Mar 2019 11:46:55 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2r8rwkctf3-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 21 Mar 2019 11:46:55 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 8B01431;
        Thu, 21 Mar 2019 10:46:54 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag7node2.st.com [10.75.127.20])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0C9AE2B38;
        Thu, 21 Mar 2019 10:46:54 +0000 (GMT)
Received: from SFHDAG7NODE2.st.com (10.75.127.20) by SFHDAG7NODE2.st.com
 (10.75.127.20) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu, 21 Mar
 2019 11:46:53 +0100
Received: from SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090]) by
 SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090%20]) with mapi id
 15.00.1347.000; Thu, 21 Mar 2019 11:46:53 +0100
From:   Lionel DEBIEVE <lionel.debieve@st.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: [Bug] STM32 crc driver failed on selftest 1
Thread-Topic: [Bug] STM32 crc driver failed on selftest 1
Thread-Index: AQHU39Nl3q5OlidWwUGbeBifBF1ZwQ==
Date:   Thu, 21 Mar 2019 10:46:53 +0000
Message-ID: <39d55020-a4db-f5f8-e9b5-777690b85ed5@st.com>
References: <20190126210530.GB709@sol.localdomain>
In-Reply-To: <20190126210530.GB709@sol.localdomain>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8631B8349D5EF74E854CECB10A994CD9@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-21_05:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQWxsLA0KDQpJJ20gbG9va2luZyBmdXJ0aGVyIHRvIGRlYnVnIGFuIGlzc3VlIHJlZ2FyZGlu
ZyBDUkMzMiBzZWxmdGVzdHMuIEknbSANCmN1cnJlbnRseSBibG9ja2VkIG9uIGFuIGlzc3VlIGFi
b3V0IHRoZSBzZWNvbmQgdGVzdCB2ZWN0b3IgaW1wbGVtZW50ZWQgDQpvbiBDUkMzMjoNCnN0YXRp
YyBjb25zdCBzdHJ1Y3QgaGFzaF90ZXN0dmVjIGNyYzMyX3R2X3RlbXBsYXRlW10gPSB7DQogwqDC
oMKgIHsNCiDCoMKgwqAgwqDCoMKgIC5wbGFpbnRleHQgPSAiYWJjZGVmZyIsDQogwqDCoMKgIMKg
wqDCoCAucHNpemUgPSA3LA0KDQogwqDCoMKgIMKgwqDCoCAuZGlnZXN0ID0gIlx4ZDhceGI1XHg0
Nlx4YWMiLA0KDQogwqDCoMKgIH0sDQoNCkknbSBjdXJyZW50bHkgdHJ5aW5nIHRvIHVuZGVyc3Rh
bmQgdGhlIGlzc3VlLCBidXQgdXNpbmcgb3RoZXJzIHRvb2xzIA0KKGNvbXB1dGVyIG9yIE9ubGlu
ZSBDUkMgY2FsY3VsYXRpb24pLCBJJ20gbm90IGFibGUgdG8gZmluZCBhbnkgd2F5IHRvIA0KZ2V0
IHRoZSBleHBlY3RlZCBvdXRwdXQ/IFRoaXMgbmV3IHZlY3RvciB3YXMgaW50cm9kdWNlZCBmb3Ig
ZmV3IHZlcnNpb24gDQpidXQgSSdtIHdvbmRlcmluZyB3aG8gd2FzIGFibGUgdG8gdmVyaWZ5IGl0
Lg0KDQpTaG91bGQgaXQgYmUgd3JpdHRlbiBieSBieXRlPyBXb3JkPyBIYWxmIHdvcmQ/DQoNClRo
YW5rcyBmb3IgaGVscC4NCg0KQlIsDQpMaW9uZWw=
