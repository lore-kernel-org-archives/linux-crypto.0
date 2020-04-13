Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F5AC2BA19
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 13:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D26320767
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 13:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="pOPHAn+f";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="keQnmIZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgDMNVc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 09:21:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728135AbgDMNV2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 09:21:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03DDLDq5022480;
        Mon, 13 Apr 2020 06:21:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=PrGuYXlWdj6k944/YKlI3Hjv1P6fPVydpy89Ee+Bs0s=;
 b=pOPHAn+fVo6QhxcdmRm1LZv/prpBFBrLDEO0ZouFtDGPXYAQ4hV3ZHJDYhoYtBBwKGeR
 kKlXLtXpZYzWF4cdHL/loHBbfaSD2Vop7+iU1Wsh0+M2gD157doR9giE32ZpS+1G8OsG
 d+6j7pL4ifYj3yAYjixmSNPZfFJS4u/NcHA2qb97jCjYd80e2MsLpgB9nUdJWCxou4kM
 Ol0CZdMYTHkwWaAQ2BxxK3PNO3X5FfadzGrrKFOOePGEgjY4xdZpndY/UyT+DW4veqyc
 m1GUCIK7XIMogRd8DcZRHMWekXbDMlp545BISyv0Mih5AQaO337VHHXJur8moQ98lsgn cg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30bddkp54v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 06:21:13 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Apr
 2020 06:21:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Apr 2020 06:21:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itXDV83h57Fd/R6Sy20pytlmIofg1p2YGA62F/5GCm8IO7eaeJpibKp+dPSQOb5/DsZeIs6XdxXuA/f4lPHn8uuE7EIBUUJuzvmZd8hw9TjC4Pog+ty6IPNCZQiXCNJ33PW8R+zekvb5Vp+et5gNIoYqE9xtTysRudKrUsFew4Vue4qYw94hSed3d8wNaDTkWCXK4QdLH3ARrYbPBfAEC6Y/ey/Jkv4kmc9WqX7VW+fibhmkK/FVJuBLyIQ5BGe74TxbBOv2MPQQwG65LFiOOyWqlRlbC3mpN/Hm4v0S7WKOJO1rRFark4MUaZKt8Y8pFXmZ5YspQ+Ie2E5wiGhaxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrGuYXlWdj6k944/YKlI3Hjv1P6fPVydpy89Ee+Bs0s=;
 b=ZVjvKPX5ziCYmUPPY2uAOPB8NaduwOwvDhs3nUqgsVBK3ZCk4NoPmKVzutthd7LhUnC/gB/je10NwpHkSWqfPho05fOTWhvQfjN2coCJqXKT/9L1nTKg3LJj5u6N+JycvbaVcUZYK41DxLzCf7I1jrDdxJfYn3lFh6i0XVxh9oBCYZSAfDvVkQs8Ho4ZCTKJZLuusrRqvYWsE+r4jcptRll180Nozo1Znuyd5nImOzXxxedkYeS5ONszQDRdtiLIWdH/Z/9Xb0iXCEdi1NxNpEYhB+zpVRyVRUQ9MXTriMec2Mh6xrvzgglSHpfqJgVbvckkQfyJk9o4c6jmDTVZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrGuYXlWdj6k944/YKlI3Hjv1P6fPVydpy89Ee+Bs0s=;
 b=keQnmIZWMTC9p6+9jXuSQxuXm6Fg/b+NbJiA/WeJdIYwcBUzGPxbuvmCRl7jgQ+k80Er8zH+1mVk1KuFwBRkGQNwMJv/KpJX9Cgm71Pw4pDTgsFAFIvhvi0r/lIQHZKYVORPgI9j4+u1LsB5HC+0ti6y46EomMS1dP7JWGJgB5k=
Received: from DM5PR18MB2311.namprd18.prod.outlook.com (2603:10b6:4:b8::27) by
 DM5PR18MB2264.namprd18.prod.outlook.com (2603:10b6:4:b5::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.26; Mon, 13 Apr 2020 13:21:09 +0000
Received: from DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd]) by DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd%4]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 13:21:09 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
 Cryptographic
Thread-Topic: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
 Cryptographic
Thread-Index: AQHV+S05rH1l6PXlHEqfmA0xItJTK6hQ/1qAgABWxrCAAbCvAIACg6OAgCGsaPA=
Date:   Mon, 13 Apr 2020 13:21:08 +0000
Message-ID: <DM5PR18MB2311BB76C6A1F5C90B5D6A86A0DD0@DM5PR18MB2311.namprd18.prod.outlook.com>
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
 <20200320053149.GC1315@sol.localdomain>
 <DM5PR18MB231111CEBDCDF734FA8C670BA0F50@DM5PR18MB2311.namprd18.prod.outlook.com>
 <CAKv+Gu_G4=Dn+6chjk1dQFMXm1aGU8QQZMmy94L5LicmR3itKQ@mail.gmail.com>
 <DM5PR18MB23111DB74B74BED1E08E0DD3A0F00@DM5PR18MB2311.namprd18.prod.outlook.com>
In-Reply-To: <DM5PR18MB23111DB74B74BED1E08E0DD3A0F00@DM5PR18MB2311.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.70.131.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 973ea499-a468-4a1c-5ec2-08d7dfad8772
x-ms-traffictypediagnostic: DM5PR18MB2264:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2264528DE73F0F8C6DF907D0A0DD0@DM5PR18MB2264.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB2311.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39850400004)(346002)(376002)(396003)(366004)(136003)(54906003)(316002)(52536014)(26005)(7696005)(6506007)(33656002)(478600001)(8676002)(5660300002)(2906002)(81156014)(86362001)(186003)(6916009)(4326008)(66476007)(9686003)(55016002)(66446008)(66946007)(66556008)(76116006)(64756008)(71200400001)(8936002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jWcxigld5jJPFnFO/p2KQGdM5bDVn0dULGKBIouGPaRnq9K4ix+uixeDvAzBFcMZZ2lYPyuhAKlu0jvdFxb7jFHZ1gJGP3OIvdxYjSzSbcIj8rv9DVidiNI5j/gUkWSsjYQKtilmSGWOi33sRLeOvvqICTIQUScfqG0XCQc1dcrEJl1Zpjd3HnzwmBkA6I+HmM97Vakhcbg52UNGdyLAjqWRhnwAoJWOCVR6yrUMkFwPwlhZcEqcdeXMKpdyubUkH1iIw2h5QiZN4SERJeDWjUyPvm9lYcLzaGOnp0q79TFDVepIcnwsOW3XhW5Dwgoz1T2fIi7fDV6dab5SgFNU5GwC+hktFSB/80fx0adgiJxtXdKgP+1qRwdpy8VPjWJqv8eEByu7oyzLPkmZMw8gn9CNkGYLClGmU4Ph/kY8frsN2DRkFwMk9lhXwSK5h8OG
x-ms-exchange-antispam-messagedata: feWnP/RjCB4nd/V60QOhizitLC8XDOfLljPK95OPMhuX3nJf0Sg8hGTIHwo6HShBPZ2chi97+cxPBzvNSYgXndw09U1DbULu8nMDUpbiiFbQdomWiCQracBRIrdEwykuAohuWe8rBeVt9Km06t+Lew==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 973ea499-a468-4a1c-5ec2-08d7dfad8772
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 13:21:08.8221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HFDq/gVoAvN2TfU1uxn9ptDm/ItjASAZNXNlq9Yt7RdXoKDXRwNjFXaVZHNQE4U4E2JjnN0lKErfkc/iLyfHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2264
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_06:2020-04-13,2020-04-13 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBTdWJqZWN0OiBSRTogW0VYVF0gUmU6IFtQQVRDSCB2MiAwLzRdIEFkZCBTdXBwb3J0IGZvciBN
YXJ2ZWxsIE9jdGVvblRYDQo+IENyeXB0b2dyYXBoaWMNCj4gDQo+ID4gT24gRnJpLCAyMCBNYXIg
MjAyMCBhdCAwNjo0NywgU3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+IHdyb3Rl
Og0KPiA+ID4NCj4gPiA+ID4gT24gRnJpLCBNYXIgMTMsIDIwMjAgYXQgMDU6MTc6MDRQTSArMDUz
MCwgU3J1amFuYSBDaGFsbGEgd3JvdGU6DQo+ID4gPiA+ID4gVGhlIGZvbGxvd2luZyBzZXJpZXMg
YWRkcyBzdXBwb3J0IGZvciBNYXJ2ZWxsIENyeXB0b2dyYXBoaWMgQWNjZWxlcmFyaW9uDQo+ID4g
PiA+ID4gVW5pdCAoQ1BUKSBvbiBPY3Rlb25UWCBDTjgzWFggU29DLg0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gQ2hhbmdlcyBzaW5jZSB2MToNCj4gPiA+ID4gPiAqIFJlcGxhY2VkIENSWVBUT19CTEtD
SVBIRVIgd2l0aCBDUllQVE9fU0tDSVBIRVIgaW4gS2NvbmZpZy4NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IFNydWphbmEgQ2hhbGxhICg0KToNCj4gPiA+ID4gPiAgIGRyaXZlcnM6IGNyeXB0bzogY3Jl
YXRlIGNvbW1vbiBLY29uZmlnIGFuZCBNYWtlZmlsZSBmb3IgTWFydmVsbA0KPiA+ID4gPiA+ICAg
ZHJpdmVyczogY3J5cHRvOiBhZGQgc3VwcG9ydCBmb3IgT0NURU9OIFRYIENQVCBlbmdpbmUNCj4g
PiA+ID4gPiAgIGRyaXZlcnM6IGNyeXB0bzogYWRkIHRoZSBWaXJ0dWFsIEZ1bmN0aW9uIGRyaXZl
ciBmb3IgQ1BUDQo+ID4gPiA+ID4gICBjcnlwdG86IG1hcnZlbGw6IGVuYWJsZSBPY3Rlb25UWCBj
cHQgb3B0aW9ucyBmb3IgYnVpbGQNCj4gPiA+ID4NCj4gPiA+ID4gVGhlcmUncyBubyBtZW50aW9u
IG9mIHRlc3RpbmcuICBEaWQgeW91IHRyeQ0KPiA+ID4gPiBDT05GSUdfQ1JZUFRPX01BTkFHRVJf
RVhUUkFfVEVTVFM9eT8NCj4gPiA+ID4NCj4gPiA+IFllcywgdGhlIGNyeXB0byBzZWxmLXRlc3Rz
IGFyZSBwYXNzZWQuDQo+ID4NCj4gPiAqd2hpY2gqIHNlbGZ0ZXN0cyBhcmUgcGFzc2VkPyBQbGVh
c2UgY29uZmlybSB0aGF0IHRoZXkgYWxsIHBhc3NlZCB3aXRoDQo+ID4gdGhhdCBrY29uZmlnIG9w
dGlvbiBzZXQNCj4gQXBvbG9naWVzLiBJIGhhdmUgb3Zlcmxvb2tlZCB0aGUgY29uZmlnIG9wdGlv
biwgSSB0aG91Z2h0IGl0IHdhcw0KPiBDT05GSUdfQ1JZUFRPX01BTkFHRVJfRElTQUJMRV9URVNU
UywgYWxsIGNyeXB0byBzZWxmLXRlc3RzIGFyZSBwYXNzZWQNCj4gd2l0aCB0aGlzIG9wdGlvbiBk
aXNhYmxlZC4gSSBoYXZlIHN0YXJ0ZWQgdmVyaWZ5aW5nIHdpdGgNCj4gQ09ORklHX0NSWVBUT19N
QU5BR0VSX0VYVFJBX1RFU1RTPXksIEkgYW0gZ2V0dGluZyBmZXcgZXJyb3JzIGZvcg0KPiB1bnN1
cHBvcnRlZCBpbnB1dCBsZW5ndGhzLCB3aWxsIHN1Ym1pdCB0aGUgcGF0Y2ggd2l0aCBmaXhlcy4N
Cg0KV2UgY29uZmlybWVkIHRoYXQgdGhlIGZhaWx1cmVzIGFyZSB3aXRoIHVuc3VwcG9ydGVkIGxl
bmd0aHMgb24gb3VyIGhhcmR3YXJlLCBmb3Igc29tZSBsZW5ndGhzIHdlIGNhbiByZXNvbHZlIHRo
ZSBpc3N1ZSBieSBoYXZpbmcgdmFsaWRhdGlvbiBjaGVja3MgaW4gdGhlIGRyaXZlciBidXQgZm9y
IHNvbWUgdW5zdXBwb3J0ZWQgY2FzZXMgInRlc3RtZ3IuYyIgaXMgZXhjZXB0aW5nIGFsd2F5cyBz
dWNjZXNzLCBJIGFtIHN0aWxsIHVuc3VyZSBob3cgdG8gZml4L3ByZXZlbnQgdGhlc2Uga2luZCBv
ZiBmYWlsdXJlcy4gQ2FuIGFueW9uZSBwbGVhc2Uga2luZGx5IGhlbHAgbWUgb3V0IGhvdyB0byBw
cm9jZWVkIG9uIHRoaXMgaXNzdWUuDQpUaGFua3MgZm9yIHlvdXIgaGVscC4NCg==
