Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB00C43218
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 07:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2660206E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 07:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aWvlcQo+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfDZH2N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:28:13 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:46469
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfDZH2M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Apr 2019 03:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKJVEEDbR4e/FGCfg8CzQx1MIuRxGNdDdBsNR6hIA+A=;
 b=aWvlcQo++HcwyVOnmDs9UeBfvE9Z+xVJ7q1alUdAKAm5ZfPM1AM4Pk+AjjVmEEYOzcdg4dTxUaYXmJ8QK04WjRfTY/QpH25bBMwZc8tmQS65KCoKomRpT9mldSY8a0W6SdWjWbvldy6oy7UXQJTJ+e23ROjdmf+C6yvum/wC/Es=
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (20.178.92.212) by
 AM6PR04MB5157.eurprd04.prod.outlook.com (20.177.34.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Fri, 26 Apr 2019 07:28:06 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::6148:3c62:75fb:20d2]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::6148:3c62:75fb:20d2%3]) with mapi id 15.20.1835.010; Fri, 26 Apr 2019
 07:28:06 +0000
From:   Franck Lenormand <franck.lenormand@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Topic: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Index: AQHU+4N3ngwG8n6Pp0eas/G/MVCpg6ZOCq6Q
Date:   Fri, 26 Apr 2019 07:28:05 +0000
Message-ID: <AM6PR04MB54473208BC59642200F4591A923E0@AM6PR04MB5447.eurprd04.prod.outlook.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
In-Reply-To: <20190425162501.4565-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=franck.lenormand@nxp.com; 
x-originating-ip: [81.1.10.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b7903ef-ea3a-42dd-d4e5-08d6ca18b990
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR04MB5157;
x-ms-traffictypediagnostic: AM6PR04MB5157:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR04MB5157766D9950DD2466740BC9923E0@AM6PR04MB5157.eurprd04.prod.outlook.com>
x-forefront-prvs: 001968DD50
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(13464003)(71190400001)(256004)(6306002)(55016002)(68736007)(71200400001)(102836004)(6506007)(53546011)(7736002)(305945005)(110136005)(14444005)(97736004)(52536014)(76176011)(54906003)(2906002)(6436002)(81166006)(316002)(81156014)(8676002)(8936002)(4326008)(25786009)(73956011)(33656002)(3846002)(76116006)(66476007)(6116002)(6246003)(966005)(66946007)(44832011)(11346002)(7696005)(66066001)(64756008)(74316002)(66556008)(5660300002)(66446008)(486006)(476003)(45080400002)(229853002)(86362001)(53936002)(186003)(9686003)(26005)(99286004)(478600001)(446003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5157;H:AM6PR04MB5447.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M3yqKabnVb6ndCa6jBSKgfqYQFIpPHUJ58AuNuXt6YaQGtzRt3eMrQEcPaAIqlUz8s9tC7BsO+namu2sVqkDOXmKNveyU07dUdQ3Dp9V0nbfdOcbWcd/qiC1lZ5XtFwBGSoi8dNb8YfNKpGkR+egtD/2cS5OpROCdJ/bmDemjSceuQrhiWxZxMn0d0ZX2SyWiEpTKKMIxKxbR58eEneZXhr/AFe7mQciLBOw0L3KjN1YJxHjhzJ3eWnz77kksz9YtT8x7Bq0izF/WbDSfrvCChCP3+FDb+sCPBETxuZtAvd3MX80geQ0Om57CuoPS08N9rEiM1QYGri4p5tXnctrIYnX/RZ8HkfCJL3WeQBcAm8dlfCeUruLgvest7BywPrtIQY/IVfnxQCURGh2hFCa91WW/xCMo9BgDnbrXYAyeNo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7903ef-ea3a-42dd-d4e5-08d6ca18b990
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2019 07:28:05.9665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5157
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8sDQoNCldoZW4geW91IHNwZWFrIG9mICJjcnlwdG8gZW5naW5lIiwgeW91IG1lYW4gdGhl
IGNhYW0gZW5naW5lPyBJbiBlZmZlY3QgdGhlICJjcnlwdG8gZW5naW5lIiBjb21wb25lbnQgYWxy
ZWFkeSBleGlzdHMuDQoNCkFib3V0IHRoZSB0ZXN0cywgd2hhdCBhYm91dCBpTVg/DQoNClJlZ2Fy
ZHMsDQoNCkZyYW5jayBMRU5PUk1BTkQNClNURUMgZW5naW5lZXIsIE5YUCwgU29waGlhIEFudGlw
b2xpcywgRnJhbmNlDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSG9y
aWEgR2VhbnTEgyA8aG9yaWEuZ2VhbnRhQG54cC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJp
bCAyNSwgMjAxOSA2OjI1IFBNDQo+IFRvOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFu
YS5vcmcuYXU+DQo+IENjOiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBB
eW1lbiBTZ2hhaWVyDQo+IDxheW1lbi5zZ2hhaWVyQG54cC5jb20+OyBMYXVyZW50aXUgVHVkb3Ig
PGxhdXJlbnRpdS50dWRvckBueHAuY29tPjsNCj4gVmFrdWwgR2FyZyA8dmFrdWwuZ2FyZ0BueHAu
Y29tPjsgRnJhbmNrIExlbm9ybWFuZA0KPiA8ZnJhbmNrLmxlbm9ybWFuZEBueHAuY29tPjsgSXVs
aWFuYSBQcm9kYW4gPGl1bGlhbmEucHJvZGFuQG54cC5jb20+Ow0KPiBNYXJjaW4gTmllc3Ryb2og
PG0ubmllc3Ryb2pAZ3Jpbm4tZ2xvYmFsLmNvbT47IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJu
ZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFU
Q0ggMC83XSBjcnlwdG86IGNhYW0gLSBJT01NVSBzdXBwb3J0DQo+IA0KPiBUaGlzIHBhdGNoIHNl
dCBhZGRzIHN1cHBvcnQgaW4gY2FhbSBkcml2ZXJzIChjYWFtL2pyLCBjYWFtL3FpLCBjYWFtL3Fp
MikgZm9yDQo+IHRoZSBjcnlwdG8gZW5naW5lIHRvIHdvcmsgYmVoaW5kIGFuIElPTU1VLg0KPiAN
Cj4gVGhlIGNoYW5nZXMgY29uc2lzdCBpbjoNCj4gDQo+IDEuIERlZmVycmVkIHByb2Jpbmcgc3Vw
cG9ydA0KPiAtY2FhbS9qciAtIHRvcCBsZXZlbCBkcml2ZXJzIGFyZSBjb252ZXJ0ZWQgdG8gImxp
YnJhcmllcyI7IHRoaXMgYWxzbyBmaXhlcyB0aGUNCj4gaXNzdWUgcmVwb3J0ZWQgcHJldmlvdXNs
eSBieSBNYXJjaW46DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9v
ay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnBhdGNoDQo+IHdvcmsua2VybmVsLm9yZyUyRmNvdmVy
JTJGMTA1NTg0MDklMkYmYW1wO2RhdGE9MDIlN0MwMSU3Q2ZyYW5jay5sDQo+IGVub3JtYW5kJTQw
bnhwLmNvbSU3QzgyODdhNmE5ZjY4YjQ1NGMwYzgyMDhkNmM5OWE5OWQxJTdDNjg2ZWExDQo+IGQz
YmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzY5MTgwNjMxNjk0ODE5MzkmYW1w
O3NkDQo+IGF0YT1IMFBWMyUyQnl3cm9PZWNvWHVOUDR0TDNURG9aJTJCWmFzSjB4WnlvJTJGakJD
TmxZJTNEJmFtcDtyDQo+IGVzZXJ2ZWQ9MA0KPiAtY2FhbS9xaSAtIHVzZSB0aGUgbmV3bHkgYWRk
ZWQgUUJNYW4gZnVuY3Rpb25zICgqKSB0byBkZWNpZGUgd2hldGhlciB0bw0KPiBkZWZlciBjYWFt
IGNvbnRyb2xsZXIgcHJvYmluZyBvciBub3QNCj4gDQo+IDIuIEZpeGluZyBzcHVyaW9zIG1lbW9y
eSBhY2Nlc3NlcywgdGhhdCBsZWFkIHRvIElPTU1VIGFjY2VzcyBmYXVsdHMgLWNyeXB0bw0KPiBl
bmdpbmUgcHJlZmV0Y2hlcyBTL0cgdGFibGUgZW50cmllcyBpbiBjaHVua3Mgb2YgNCAoNjQgYnl0
ZXMpLCBhbmQgZHJpdmVyIGhhcw0KPiB0byBtYWtlIHN1cmUgbWVtb3J5IGlzIGFsbG9jYXRlZCBh
bmQgbWFwcGVkIC1jcnlwdG8gZW5naW5lIHRyaWVzIHRvDQo+IHByZWZldGNoIFMvRyB0YWJsZSBl
bnRyaWVzIHdoZW4gaW5wdXQgLyBvdXRwdXQgaXMgbWFya2VkIGFzIHNjYXR0ZXJlZCwgZXZlbg0K
PiB0aG91Z2ggbGVuZ3RoIGlzIHplcm8NCj4gDQo+IDMuIEdldHRpbmcgcmlkIG9mIHBsYXRmb3Jt
IGRldmljZSBjcmVhdGVkIGJ5IGNhYW0vcWkgVGhlcmUgYXJlIGluaGVyZW50DQo+IHByb2JsZW1z
IHdpdGggcGxhdGZvcm0gZGV2aWNlIGJlaW5nIGNyZWF0ZWQgZHluYW1pY2FsbHkgKGFuZCBub3Qg
cmVseWluZyBvbg0KPiB0aGUgZXhpc3RlbmNlIG9mIGEgRFQgbm9kZSkuDQo+IA0KPiA0LiBVcGRh
dGUgcGh5cyAtPiB2aXJ0IGFkZHJlc3MgdHJhbnNsYXRpb24gaW4gY2FzZSBJT01NVSBpcyBwcmVz
ZW50IGlvdmEgLT4NCj4gcGh5cyAtPiB2aXJ0DQo+IA0KPiA1LiBGaXggdGhlIGRldmljZSB1c2Vk
IGZvciBrZXkgYnVmZmVycyBETUEgbWFwcGluZyBLZXkgYnVmZmVycyBhcmUNCj4gaW5jb3JyZWN0
bHkgRE1BIG1hcHBlZCB1c2luZyBhIGpvYiByaW5nIGRldmljZSwgc2luY2UgdGhleSBhcmUgYWNj
ZXNzZWQNCj4gZXZlbnR1YWxseSBieSB0aGUgUUkgLSB0aGlzIGNyZWF0aW5nIGFuIElDSUQgLyBz
dHJlYW0gSUQgbWlzbWF0Y2ggYXQgSU9NTVUNCj4gbGV2ZWwuDQo+IA0KPiBUZXN0cyB3ZXJlIHBl
cmZvcm1lZCBvbjoNCj4gLUxTMTA0NkEgLSBjYWFtL2pyIGFuZCBjYWFtL3FpIC0gam9iIHJpbmcg
YW5kIHF1ZXVlIGludGVyZmFjZSAtTFMxMDg4QSAtDQo+IGNhYW0vanIgYW5kIGNhYW0vcWkyIC0g
am9iIHJpbmcgYW5kIGRwc2VjIGludGVyZmFjZQ0KPiANCj4gVGhlcmUgYXJlIHNvbWUgZGVwZW5k
ZW5jaWVzIChzZWUgYmVsb3cpLg0KPiBXaGlsZSBub3QgZXZlcnl0aGluZyBpcyBpbiBwbGFjZSwg
SSB3b3VsZCBsaWtlIGF0IGxlYXN0IHRvIHBhdGNoZXMgMS04LzkgYmVpbmcNCj4gcmV2aWV3ZWQg
JiBtZXJnZWQuDQo+IA0KPiBpLiBQYXRjaCA5LzkgKGNyeXB0bzogY2FhbSAtIGRlZmVyIHByb2Jp
bmcgdW50aWwgUU1hbiBpcyBhdmFpbGFibGUpIHNob3VsZA0KPiBOT1QgYmUgbWVyZ2VkLCBzaW5j
ZSB0aGVyZSBhcmUgY29tcGlsYXRpb24gZGVwZW5kZW5jaWVzIG9uIHRoZSBwYXRjaA0KPiBzZXJp
ZXM6DQo+ICgqKSBQcmVyZXF1aXNpdGVzIGZvciBOWFAgTFMxMDR4QSBTTU1VIGVuYWJsZW1lbnQN
Cj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0
dHBzJTNBJTJGJTJGcGF0Y2gNCj4gd29yay5rZXJuZWwub3JnJTJGcHJvamVjdCUyRmxpbnV4LWFy
bS0NCj4ga2VybmVsJTJGbGlzdCUyRiUzRnNlcmllcyUzRDk4NjI1JmFtcDtkYXRhPTAyJTdDMDEl
N0NmcmFuY2subGVub3INCj4gbWFuZCU0MG54cC5jb20lN0M4Mjg3YTZhOWY2OGI0NTRjMGM4MjA4
ZDZjOTlhOTlkMSU3QzY4NmVhMWQzYmMNCj4gMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0Mw
JTdDNjM2OTE4MDYzMTY5NDgxOTM5JmFtcDtzZGF0YT1yDQo+IDc4SGE1SUU5REZsTGJxSWJZWURo
VXFGeVkyJTJGVUo5cGR4SjNwNDdKeW1nJTNEJmFtcDtyZXNlcnZlZD0wDQo+IA0KPiBpaS4gVS1i
b290IHVwZGF0ZXMgZm9yIExTMTA4OEEgKG5lZWRlZCBmb3IgY2FhbS9qciBJQ0lEIHByb2dyYW1t
aW5nKSBbVS0NCj4gQm9vdCwxLzJdIGFybXY4OiBmc2wtbGF5ZXJzY2FwZTogYWRkIG1pc3Npbmcg
c2VjIGpyIGJhc2UgYWRkcmVzcyBkZWZpbmVzDQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnBy
b3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnBhdGNoDQo+IHdvcmsub3ps
YWJzLm9yZyUyRnBhdGNoJTJGMTA1OTI1NiUyRiZhbXA7ZGF0YT0wMiU3QzAxJTdDZnJhbmNrLmxl
DQo+IG5vcm1hbmQlNDBueHAuY29tJTdDODI4N2E2YTlmNjhiNDU0YzBjODIwOGQ2Yzk5YTk5ZDEl
N0M2ODZlYTFkDQo+IDNiYzJiNGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3QzYzNjkxODA2
MzE2OTQ4MTkzOSZhbXA7c2RhdA0KPiBhPVl5M2tQWTQxaVRYJTJGSkhDMWZKNTFQclhDTEhLYXEl
MkJYbTBUeXhPeGNRMVp3JTNEJmFtcDtyZXNlcg0KPiB2ZWQ9MA0KPiBbVS1Cb290LDIvMl0gYXJt
djg6IGxzMTA4OGE6IGFkZCBpY2lkIHNldHVwIGZvciBwbGF0Zm9ybSBkZXZpY2VzDQo+IGh0dHBz
Oi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUy
RiUyRnBhdGNoDQo+IHdvcmsub3psYWJzLm9yZyUyRnBhdGNoJTJGMTA1OTI1OSUyRiZhbXA7ZGF0
YT0wMiU3QzAxJTdDZnJhbmNrLmxlDQo+IG5vcm1hbmQlNDBueHAuY29tJTdDODI4N2E2YTlmNjhi
NDU0YzBjODIwOGQ2Yzk5YTk5ZDElN0M2ODZlYTFkDQo+IDNiYzJiNGM2ZmE5MmNkOTljNWMzMDE2
MzUlN0MwJTdDMCU3QzYzNjkxODA2MzE2OTQ5MTk0OCZhbXA7c2RhdA0KPiBhPWFqWUQ1TTFtaEF1
cjNGMHZZTE9IaTJDR3dDMUl0Y01Vc1dTV0Q1WnJRR1UlM0QmYW1wO3Jlc2Vydg0KPiBlZD0wDQo+
IA0KPiBIb3JpYSBHZWFudMSDICg3KToNCj4gICBjcnlwdG86IGNhYW0gLSBhdm9pZCBTL0cgdGFi
bGUgZmV0Y2hpbmcgZm9yIEFFQUQgemVyby1sZW5ndGggb3V0cHV0DQo+ICAgY3J5cHRvOiBjYWFt
IC0gZml4IFMvRyB0YWJsZSBwYXNzaW5nIHBhZ2UgYm91bmRhcnkNCj4gICBjcnlwdG86IGNhYW0g
LSBjb252ZXJ0IHRvcCBsZXZlbCBkcml2ZXJzIHRvIGxpYnJhcmllcw0KPiAgIGNyeXB0bzogY2Fh
bS9xaSAtIGRvbid0IGFsbG9jYXRlIGFuIGV4dHJhIHBsYXRmb3JtIGRldmljZQ0KPiAgIGNyeXB0
bzogY2FhbS9xaSAtIGZpeCBhZGRyZXNzIHRyYW5zbGF0aW9ucyB3aXRoIElPTU1VIGVuYWJsZWQN
Cj4gICBjcnlwdG86IGNhYW0vcWkgLSBETUEgbWFwIGtleXMgdXNpbmcgcHJvcGVyIGRldmljZQ0K
PiAgIGNyeXB0bzogY2FhbSAtIGRlZmVyIHByb2JpbmcgdW50aWwgUU1hbiBpcyBhdmFpbGFibGUN
Cj4gDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL0tjb25maWcgICAgICAgfCAgNDYgKysrKy0tLS0t
LS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vTWFrZWZpbGUgICAgICB8ICAxOCArKy0tLQ0KPiAg
ZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtYWxnLmMgICAgIHwgIDcyICsrKysrKysrLS0tLS0tLS0t
DQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1hbGdfcWkuYyAgfCAxMjQgKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tDQo+IGRyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZ19xaTIuYyB8
ICA3MiArKysrKysrKysrKysrLS0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtaGFzaC5j
ICAgIHwgIDgxICsrKysrKy0tLS0tLS0tLS0tLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vY2Fh
bXBrYy5jICAgICB8ICA1NyArKystLS0tLS0tLS0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9j
YWFtcm5nLmMgICAgIHwgIDU0ICsrLS0tLS0tLS0tLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0v
Y3RybC5jICAgICAgICB8IDEyNCArKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0NCj4gIGRy
aXZlcnMvY3J5cHRvL2NhYW0vZGVzY19jb25zdHIuaCB8ICAxMSArKysNCj4gIGRyaXZlcnMvY3J5
cHRvL2NhYW0vaW50ZXJuLmggICAgICB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrLS0NCj4g
IGRyaXZlcnMvY3J5cHRvL2NhYW0vanIuYyAgICAgICAgICB8ICA0MyArKysrKysrKysrKw0KPiAg
ZHJpdmVycy9jcnlwdG8vY2FhbS9xaS5jICAgICAgICAgIHwgIDUyICsrKysrKy0tLS0tLS0NCj4g
IDEzIGZpbGVzIGNoYW5nZWQsIDQ2NSBpbnNlcnRpb25zKCspLCAzOTEgZGVsZXRpb25zKC0pDQo+
IA0KPiAtLQ0KPiAyLjE3LjENCg0K
