Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EC7C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 12:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A42E2075E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 12:42:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="c75pLe+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfE0MmB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 08:42:01 -0400
Received: from mail-eopbgr10090.outbound.protection.outlook.com ([40.107.1.90]:43187
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbfE0MmB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 08:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5MmlFXPHdOO1gGHZlD2mzJkCm+kzzwQqpK7nL3u5zY=;
 b=c75pLe+7BzW7iXoDLxpGmhi8OZW6sv7cPVHA6hozpCdPtgQU/XuL+jsOuqcO61eLzEJnRl5UU0sibC8rkjOUZRPBQn7wCzNQQaR/xlUMyn1YMsLY8jHxfsqcEMi45CMLPQxO/dRWPC0REN8XZsxCKbxXRA7nUdUD/gzhpisVr7c=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3169.eurprd09.prod.outlook.com (10.255.99.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Mon, 27 May 2019 12:41:57 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 12:41:57 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAS0FFCAAAQtAIAAAZkAgAAJO4CAAADysIAABwUAgAAHPfCAABPWkA==
Date:   Mon, 27 May 2019 12:41:57 +0000
Message-ID: <AM6PR09MB35236E55357F5FA41AF47146D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
 <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com>
 <AM6PR09MB352398BD645902A305C680C9D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8ScTXM2qxrG__RW6SLKZYrevjfCi_HxpSOJRH5+9Knzg@mail.gmail.com>
 <AM6PR09MB3523090454E4FB6825797A0FD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu85qp44C9Leydz=ES+ByWYoYSWMC-Kiv2Gw403sYBGkcw@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 719b291b-4bf6-4dda-bf9e-08d6e2a0b4fe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3169;
x-ms-traffictypediagnostic: AM6PR09MB3169:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB31694F1E9110FF76DF27AD48D21D0@AM6PR09MB3169.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39850400004)(396003)(376002)(136003)(189003)(199004)(9686003)(53936002)(81156014)(8936002)(68736007)(6246003)(33656002)(4326008)(8676002)(66066001)(2906002)(81166006)(6916009)(3846002)(6116002)(25786009)(478600001)(256004)(15974865002)(14454004)(316002)(71190400001)(71200400001)(76176011)(446003)(6436002)(3480700005)(486006)(305945005)(476003)(64756008)(66476007)(66556008)(66946007)(66446008)(73956011)(229853002)(54906003)(76116006)(99286004)(7696005)(4744005)(86362001)(26005)(7116003)(55016002)(74316002)(102836004)(6506007)(7736002)(5660300002)(52536014)(186003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3169;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WEM5LPavYBn9dWUgF8hFTo9+d1YPEU9QNUzrqY3cmG4jz/4aCrW1CuskohZnvfh3AGRMjoUowppSd1aDSSVLwxXUhDDtCYF9ZNrGxgXb5e/wgTB5xPd4jBT/J/JjZ0C93Wyaw+USKhhA3TGypwlbOrdZn9UKxXDxOfMek4KrpRvIjfEI2yjxUWNxy4XTtqehBk6yhn05LMNQbTa54cNqNdSyLYCN3l7uo60BwXT5pnumefEkLeMMSOKWcD4aHgk55rDJUdcbEdK2znBjU03QWgH9BYsvHczL7kXX7IdpfqGZfwnBT/MCuANW5LW0EtzDPVqDA6iovhacHGBpQTZRXNFDE7Yakihfjcofocxo8T0EVnhWXFeKnVvKLHH3C9yA0qKEXdn8vDQ/RBBKWA1ojAWoR95UkTtuUV+qG4Wd1nU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719b291b-4bf6-4dda-bf9e-08d6e2a0b4fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 12:41:57.8063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3169
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBBbmQgaWYgeW91IGdvIHRoYXQgbmFpdmUgcm91dGUsIGp1c3QgZml4IGV2ZXJ5dGhpbmcgaW4g
dGhlIGRyaXZlciwgdGhlbg0KPiB5b3Ugc2ltcGx5IGVuZCB1cCB3aXRoIHNvbWV0aGluZyB0ZXJy
aWJseSBpbmVmZmljaWVudCBiZWNhdXNlIGFsbCB0aG9zZQ0KPiBjb3JuZXIgY2FzZSBjaGVja3Mg
ZW5kIHVwIGluIHRoZSBmYXN0IHBhdGggYW5kIGVhdGluZyB1cCBjb2RlIHNwYWNlLg0KPg0KT25l
IHRoaW5nIEkgZm9yZ290IHRvIG1lbnRpb24gaGVyZSB0aGF0IHNob3VsZCBlc3BlY2lhbGx5IGlu
dGVyZXN0IHlvdToNCnlvdSBhZGQgYSBsb3Qgb2YgY29tcGxleGl0eSB0byB0aGUgKmRyaXZlciog
dGhhdCBuZWVkcyB0byB2ZXJpZmllZCBhbmQNCm1haW50YWluZWQgKGJ5IHRoZSBrZXJuZWwgY29t
bXVuaXR5PyEpLiBTb21lIG9mIHRoZXNlIHdvcmthcm91bmRzIEkgaGFkIHRvDQppbXBsZW1lbnQg
YXJlIHJlYWxseSBxdWl0ZSBhIGNvbnZvbHV0ZWQgbWVzcyBhbmQgaXQncyBzdGFydGluZyB0byB0
YWtlIHVwDQphIHNpZ25pZmljYW50IHBvcnRpb24gb2YgdGhlIGRyaXZlcidzIGNvZGUgYmFzZSBh
cyB3ZWxsIC4uLiBqdXN0IHRvIHN1cHBvcnQNCnNvbWUgZnJpbmdlIGNhc2VzIHRoYXQgYXJlIG5v
dCBldmVuIHJlbGV2YW50IHRvIHRoZSBoYXJkd2FyZSdzIG1haW4gdXNlDQpjYXNlcyAoYXMgIndl
IiBhcyB0aGUgImhhcmR3YXJlIHZlbmRvciIgc2VlIGl0KSBhdCBhbGwuDQoNCk5vdGUgdGhhdCBJ
IGFjdHVhbGx5ICpoYXZlKiBpbXBsZW1lbnRlZCBhbGwgdGhlc2Ugd29ya2Fyb3VuZHMgYW5kIG15
DQpkcml2ZXIgaXMgZnVsbHkgcGFzc2luZyBhbGwgZnV6emluZyB0ZXN0cyBldGMuIEknbSBqdXN0
IG5vdCBoYXBweSB3aXRoIGl0Lg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxp
Y29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIEluc2lkZSBTZWN1cmUN
Cnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
