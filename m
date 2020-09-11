Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D21AC43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 16:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3FD22208
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 16:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="fRsxBBvw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIKQYF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:24:05 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:24733 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbgIKQXK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 12:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1599841386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XytezxolcWNfAR8EPjniCf1B6P3Gb2gr01iMXIIIIc8=;
        b=fRsxBBvwtR9bnzU5ZZFvBHoP2cmXUvjnLYgE7dWvkCYliHdEEU/d5eL4UKhTSM8XDQF6yn
        2sQ6KisXzq6dFOVqOK/EQn7YKV9YxfewBy1wBWQUm3PuleWBC17cwfuAl+pocv3gvOQqP2
        6/0oHNu36VmXQlAu7xLqGbVoiOpADoE=
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-JGiGEmKXPoa4-Zd-PQ2Kdg-1; Fri, 11 Sep 2020 12:23:04 -0400
X-MC-Unique: JGiGEmKXPoa4-Zd-PQ2Kdg-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0903.namprd04.prod.outlook.com
 (2603:10b6:910:57::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 11 Sep
 2020 16:23:01 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 16:23:01 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: RE: [PATCH] crypto: mark unused ciphers as obsolete
Thread-Topic: [PATCH] crypto: mark unused ciphers as obsolete
Thread-Index: AQHWiFRjVQhCDl0wBUmciifAeSWwvaljnRFw
Date:   Fri, 11 Sep 2020 16:23:00 +0000
Message-ID: <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200911141103.14832-1-ardb@kernel.org>
In-Reply-To: <20200911141103.14832-1-ardb@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 967e0d3d-fb9a-4645-7099-08d8566ef3f4
x-ms-traffictypediagnostic: CY4PR04MB0903:
x-microsoft-antispam-prvs: <CY4PR04MB09037F77AB6E198B36D62D10C3240@CY4PR04MB0903.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: on+unWUVQl/EBssMSAcO0aIsIe2ePLLnSBFWZmtrFr9vxCNn3+F99R5ITW9lWeXpmSNb1SPB6YJ+xxYY4zDguouJk8CbIlg1MytwsjFvwr2RiLj9m7ofjaxsZyLu4FtGwd9Xn9f167zbz0LhVvxV3ask6ZdYE6eo1Ekr+2q31lihn19pGEdbcGe2X+AroMM1fkIa3+NkTt+oIAao1pNMdR3YyI/IIGoq1ZK1XkC/ljtgHA4RSAI6iaV9tFM2Q5t6cvaSrBAPTx0K96Nu+F6t2WUyXHSOTLpUtviWwpjVPenVVR5lnuZNMMdXYQGgb5iMRUGJM3h9ORNePI8596MqPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39850400004)(366004)(64756008)(55016002)(5660300002)(66946007)(76116006)(66476007)(110136005)(66556008)(66446008)(54906003)(186003)(83380400001)(316002)(9686003)(86362001)(33656002)(8936002)(52536014)(71200400001)(53546011)(7696005)(478600001)(6506007)(26005)(4326008)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: M5bSgq3ip+6Yr2BC5mzdzQBa/xx7rbI7DYSirUi/GxIFzDsUOjR0qZVmx1JSQ7u+AUGbap0Qr9S6hCEbJEDKzW8Ud0dGmojoEJgUToxfMQupa1Iy695p3DSk8dFRyqdXGy5XDhhgS+0HjjQBIwa8pkrrPPl+zeYAc3GpF8GWvjnxhFVnTY4S/G+FWrmGl0xWS8kx51lNq7H5i01VovPIJDMzmJYJIUS7CXH0269LCiUnxJrQfi3aaQsXBhd8pB30SF83HMYQf0oz681EE2DzBa/PM7UdCxm62tykWspBV2fsjgCDrvUncDyuP9QnZ6aKQ+g1MSr9zxU6uSl0Fz/BwCnGC/vLPVbE3MUc75WgEFt3ETFs36Fli6xVKKiB1YFYdsfTLFhwvr0Hw8UkVPzFNHM0bFZGFrdqmceJfi8rA6/FcOSWLkYJ9zPPR7EDOxPD5+tQKfi8QRqZIXAC1o8OTy0yaph06L0ugOmtG0alsGpIcuB2nQtlN5Gi93YAFRlZveYIMKKJ9zVyWmvlfUZaojgGh696oOUl9d0ZUPAMrMf3109NkxHF2CmmJxSaHVVRxILUcGnrXT/CfGU+yny+RjUSKDK2abZYchZxvqsKa6FpvF3lBRgGUaWADjpaob3AS1YaGh5QJP4mV1vCqbP7hg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967e0d3d-fb9a-4645-7099-08d8566ef3f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 16:23:01.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiWMUbb9aWyYI0C8qcAoEEPlVmQXvd+8PZj2NIMetNDXed7YCyw4WhAAEbtKEb4PiHO1sxXd8fkGrfelwTQRmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0903
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgQXJkIEJpZXNoZXV2ZWwNCj4gU2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgMTEsIDIw
MjAgNDoxMSBQTQ0KPiBUbzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBDYzogaGVy
YmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBlYmlnZ2Vyc0BrZXJuZWwub3JnOyBBcmQgQmllc2hl
dXZlbCA8YXJkYkBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIGNyeXB0bzogbWFyayB1
bnVzZWQgY2lwaGVycyBhcyBvYnNvbGV0ZQ0KPg0KPiA8PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+
IFdlIGhhdmUgYSBmZXcgaW50ZXJlc3RpbmcgcGllY2VzIGluIG91ciBjaXBoZXIgbXVzZXVtLCB3
aGljaCBhcmUgbmV2ZXINCj4gdXNlZCBpbnRlcm5hbGx5LCBhbmQgd2VyZSBvbmx5IGV2ZXIgcHJv
dmlkZWQgYXMgZ2VuZXJpYyBDIGltcGxlbWVudGF0aW9ucy4NCj4NCj4gVW5mb3J0dW5hdGVseSwg
d2UgY2Fubm90IHNpbXBseSByZW1vdmUgdGhpcyBjb2RlLCBhcyB3ZSBjYW5ub3QgYmUgc3VyZQ0K
PiB0aGF0IGl0IGlzIG5vdCBiZWluZyB1c2VkIHZpYSB0aGUgQUZfQUxHIHNvY2tldCBBUEksIGhv
d2V2ZXIgdW5saWtlbHkuDQo+IFNvIGxldCdzIG1hcmsgdGhlIEFudWJpcywgS2hhemFkLCBTRUVE
IGFuZCBURUEgYWxnb3JpdGhtcyBhcyBvYnNvbGV0ZSwNCj4NCldvdWxkbid0IHRoZSBJS0UgZGVh
bW9uIGJlIGFibGUgdG8gdXRpbGl6ZSB0aGVzZSBhbGdvcml0aG1zIHRocm91Z2ggdGhlIFhGUk0g
QVBJPw0KSSdtIGJ5IG5vIG1lYW5zIGFuIGV4cGVydCBvbiB0aGUgc3ViamVjdCwgYnV0IGl0IGxv
b2tzIGxpa2UgdGhlIGNpcGhlciB0ZW1wbGF0ZSBpcw0KcHJvdmlkZWQgdGhlcmUgZGlyZWN0bHkg
dmlhIFhGUk0sIHNvIGl0IGRvZXMgbm90IG5lZWQgdG8gbGl2ZSBpbiB0aGUga2VybmVsIHNvdXJj
ZS4NCkFuZCBJIGtub3cgZm9yIGEgZmFjdCB0aGF0IFNFRUQgaXMgYmVpbmcgdXNlZCBmb3IgSVBz
ZWMgKGFuZCBUTFMpIGluIEtvcmVhLg0KDQpUaGUgcG9pbnQgYmVpbmcsIHRoZXJlIGFyZSBtb3Jl
IHVzZXJzIHRvIGNvbnNpZGVyIGJleW9uZCAiaW50ZXJuYWwiIChtZWFuaW5nIGhhcmQNCmNvZGVk
IGluIHRoZSBrZXJuZWwgc291cmNlIGluIHRoaXMgY29udGV4dD8pIGFuZCBBRl9BTEcuDQoNCkkn
bSBub3QgYXdhcmUgb2YgYW55IHJlYWwgdXNlIGNhc2VzIGZvciBBbnViaXMsIEtoYXphZCBhbmQg
VEVBIHRob3VnaC4NCg0KPiB3aGljaCBtZWFucyB0aGV5IGNhbiBvbmx5IGJlIGVuYWJsZWQgaW4g
dGhlIGJ1aWxkIGlmIHRoZSBzb2NrZXQgQVBJIGlzDQo+IGVuYWJsZWQgaW4gdGhlIGZpcnN0IHBs
YWNlLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3Jn
Pg0KPiAtLS0NCj4gSG9wZWZ1bGx5LCBJIHdpbGwgYmUgYWJsZSB0byBjb252aW5jZSB0aGUgZGlz
dHJvIGtlcm5lbCBtYWludGFpbmVycyB0bw0KPiBkaXNhYmxlIENSWVBUT19VU0VSX0FQSV9FTkFC
TEVfT0JTT0xFVEUgaW4gdGhlaXIgdjUuMTArIGJ1aWxkcyBvbmNlIHRoZQ0KPiBpd2QgY2hhbmdl
cyBmb3IgYXJjNCBtYWtlIGl0IGRvd25zdHJlYW0gKERlYmlhbiBhbHJlYWR5IGhhcyBhbiB1cGRh
dGVkDQo+IHZlcnNpb24gaW4gaXRzIHVuc3RhYmxlIGRpc3RybykuIFdpdGggdGhlIGpvaW50IGNv
dmVyYWdlIG9mIHRoZWlyIFFBLA0KPiB3ZSBzaG91bGQgYmUgYWJsZSB0byBjb25maXJtIHRoYXQg
dGhlc2UgYWxnb3MgYXJlIG5ldmVyIHVzZWQsIGFuZA0KPiBhY3R1YWxseSByZW1vdmUgdGhlbSBh
bHRvZ2V0aGVyLg0KPg0KPiAgY3J5cHRvL0tjb25maWcgfCA0ICsrKysNCj4gIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAtLWdpdCBhL2NyeXB0by9LY29uZmlnIGIv
Y3J5cHRvL0tjb25maWcNCj4gaW5kZXggZTg1ZDhhMDU5NDg5Li5mYWMxMDE0M2QyM2YgMTAwNjQ0
DQo+IC0tLSBhL2NyeXB0by9LY29uZmlnDQo+ICsrKyBiL2NyeXB0by9LY29uZmlnDQo+IEBAIC0x
MTg1LDYgKzExODUsNyBAQCBjb25maWcgQ1JZUFRPX0FFU19QUENfU1BFDQo+DQo+ICBjb25maWcg
Q1JZUFRPX0FOVUJJUw0KPiAgdHJpc3RhdGUgIkFudWJpcyBjaXBoZXIgYWxnb3JpdGhtIg0KPiAr
ZGVwZW5kcyBvbiBDUllQVE9fVVNFUl9BUElfRU5BQkxFX09CU09MRVRFDQo+ICBzZWxlY3QgQ1JZ
UFRPX0FMR0FQSQ0KPiAgaGVscA0KPiAgICBBbnViaXMgY2lwaGVyIGFsZ29yaXRobS4NCj4gQEAg
LTE0MjQsNiArMTQyNSw3IEBAIGNvbmZpZyBDUllQVE9fRkNSWVBUDQo+DQo+ICBjb25maWcgQ1JZ
UFRPX0tIQVpBRA0KPiAgdHJpc3RhdGUgIktoYXphZCBjaXBoZXIgYWxnb3JpdGhtIg0KPiArZGVw
ZW5kcyBvbiBDUllQVE9fVVNFUl9BUElfRU5BQkxFX09CU09MRVRFDQo+ICBzZWxlY3QgQ1JZUFRP
X0FMR0FQSQ0KPiAgaGVscA0KPiAgICBLaGF6YWQgY2lwaGVyIGFsZ29yaXRobS4NCj4gQEAgLTE0
ODcsNiArMTQ4OSw3IEBAIGNvbmZpZyBDUllQVE9fQ0hBQ0hBX01JUFMNCj4NCj4gIGNvbmZpZyBD
UllQVE9fU0VFRA0KPiAgdHJpc3RhdGUgIlNFRUQgY2lwaGVyIGFsZ29yaXRobSINCj4gK2RlcGVu
ZHMgb24gQ1JZUFRPX1VTRVJfQVBJX0VOQUJMRV9PQlNPTEVURQ0KPiAgc2VsZWN0IENSWVBUT19B
TEdBUEkNCj4gIGhlbHANCj4gICAgU0VFRCBjaXBoZXIgYWxnb3JpdGhtIChSRkM0MjY5KS4NCj4g
QEAgLTE2MTMsNiArMTYxNiw3IEBAIGNvbmZpZyBDUllQVE9fU000DQo+DQo+ICBjb25maWcgQ1JZ
UFRPX1RFQQ0KPiAgdHJpc3RhdGUgIlRFQSwgWFRFQSBhbmQgWEVUQSBjaXBoZXIgYWxnb3JpdGht
cyINCj4gK2RlcGVuZHMgb24gQ1JZUFRPX1VTRVJfQVBJX0VOQUJMRV9PQlNPTEVURQ0KPiAgc2Vs
ZWN0IENSWVBUT19BTEdBUEkNCj4gIGhlbHANCj4gICAgVEVBIGNpcGhlciBhbGdvcml0aG0uDQo+
IC0tDQo+IDIuMTcuMQ0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQ
IEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1
cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2Vj
dXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBS
YW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBi
b29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQg
YW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNp
cGllbnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFs
IGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9m
IHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcs
IGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBh
dHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1
cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

