Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E17C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 15:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345742AbiDRPyY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 11:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346544AbiDRPxR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 11:53:17 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70087.outbound.protection.outlook.com [40.107.7.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F51AD89
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 08:36:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/CXZ3QkyiYGeJxGp5cI3K/bLOvG9Ir/fZEw/+Wg0K12Lxw5DB6XSM09a4eeM3wD8RrB1JgeU8PI69TPUYDcYZ4C8iEtBkKsx2p+pBQBfogK1K6RJOTFj86xRle71pUetkVdVqAWikQXjWfIdfqe/u4HT3Sq7sA9UG/3+F/y1GxZWflbY8yFBuAJO9t80PbJItNFivyk+DKaEPUZKhzAk3u5UPF+zZRiJUc1z0KHvWfNhCjEBbrwoy7Ah7Bd6wMRm3TlP4xVdBI8ZrpW5XLUtnzY1oangA+mA5C9A7OiCeWmi6yOw/ANIqD0eVawoL+KQBBA/TkbAurwZU3U5xP3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wV1jjfeCV/NnwMgEKHz9g3d7AOYiaqVroPBWzloq7i0=;
 b=B0ygB5g1ppoiPYjR0YDWSOz3xoeHQAdqCS+IuQ53mQxfdjLEjhn8NP6tNJYsIgweLLzxj18h4SyfQWECZpe34QBU8pqCei4vTnyt7sJNb/tUXzWP5iKU2slgNwxEAi5BWRGUk7d0makVCvq8sN7D9C9AZapkQzsgYrXl7E1fuQsZERIt4NejVuDcijbnnW/Wqn89c1+ncI7V0v9pAeoYXRG2rTbTkGKHK4pHmDcP4rqW4vEZonWcK+5swpRZmlxTDIzUDwY0LB3fqYyGCGksrNh48Y3TnOOUiTWFA5kxdcA8RBRxdVyL0ImVy44nQa810huwuf37kAo3RnNnNk/gHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV1jjfeCV/NnwMgEKHz9g3d7AOYiaqVroPBWzloq7i0=;
 b=MWgw1hi+ChdNV/rTl8bJFNqCB7WodGFvgx+qMzF2ORfgA+KovbZK5z8hrDBB/Xo5nTDDyWM6XGegYgpMLBTZO8WPpCEIAuhzq+xO1UnyA4CHpHSOmwR8OAByW659HI6xjUX1Xg7FMJajvNqhgmFvqQU60V3faa7qHKMgnBlHVIw=
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17)
 by DBBPR04MB7738.eurprd04.prod.outlook.com (2603:10a6:10:1ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 15:36:56 +0000
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e]) by AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 15:36:56 +0000
From:   Varun Sethi <V.Sethi@nxp.com>
To:     Vabhav Sharma <vabhav.sharma@nxp.com>,
        Fabio Estevam <festevam@gmail.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Subject: RE: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Thread-Topic: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Thread-Index: AQHYUZmQg66H5GpCqEmaCXX+FqD/z6zy0zoggAAVCICAAsf3AIAAH5Pw
Date:   Mon, 18 Apr 2022 15:36:55 +0000
Message-ID: <AM9PR04MB82116FD8C00D305A4955E105E8F39@AM9PR04MB8211.eurprd04.prod.outlook.com>
References: <20220416135412.4109213-1-festevam@gmail.com>
 <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com>
 <AS8PR04MB89485964ED3248A45D7ADB27F3F39@AS8PR04MB8948.eurprd04.prod.outlook.com>
In-Reply-To: <AS8PR04MB89485964ED3248A45D7ADB27F3F39@AS8PR04MB8948.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28e8328b-9015-4ec8-2c8e-08da2151451c
x-ms-traffictypediagnostic: DBBPR04MB7738:EE_
x-microsoft-antispam-prvs: <DBBPR04MB7738B4F77E8CB435BA745C70E8F39@DBBPR04MB7738.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0a/y75dt9UyXj5z27nBSZwMcld9XvY2e+tmFQ58KcjfpgGnqtjpVVKErgjmUJA2nOupmGGvL4kuasyfSqBS6HNVKddBP7ryPcR2KS4mw6H6ibkns1jr36iYN7dbXIrvrRwQ6Ji2uiwgoIwCE/RuJn4RX4JbOA2WO5AU6Tu8Emb74Mdwrbxk8768MB+vAHyPq3396OCz18Im88hOuMsRQc7uS+8KxLcq9j7yGxOckypOmbV78cWFTsWDQAf2mQi1Lf5TkJCgGQ8UKLAq/mYSPTMWq4xM6kdoRAVg3XNq3R75rjHCJq8RcNJe3wgL1Y8sVTLABcM4w7ECPM6r5kwJL8nC1tn8nFT2DyXkl/B0uEazS1tObpqMLIxQNOJ70B7oWIqLL1j3uJzMNaMGzlTOHTiWw5+n73Gt4mOu2uKbFjZBDU55OBQO7b+9DuaNFRbm17JXGo9bh+IYe3VKeUboHfCzJXLxz3eGgSHRSZokQnmKcz5vAjlHDtOUstiOvxmKQ6uX8bAxNCL6gvhhb/cx+ydI6rJbDzBy+46a5HMPmicUeWn1iJj+2pzY3e7Z3NZvi/UJZQQ+nOJwpUs1q7rqNJO0ao2M0wvIhq9VkOylPVbAHXeUReJt/f0ywZtH2o7bK/s2e6qm/MF5uHWgO8XHS2nxcI6VAyoI480NzZH9AxXniFxgD+GddMWQVlCS251rYBO8joHVNwdwRpRUrvHvJFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8211.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(4326008)(64756008)(66556008)(66476007)(66446008)(66946007)(8936002)(508600001)(5660300002)(33656002)(186003)(52536014)(71200400001)(86362001)(76116006)(2906002)(8676002)(122000001)(55236004)(110136005)(54906003)(316002)(55016003)(38100700002)(26005)(7696005)(83380400001)(6506007)(9686003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTVBeE1PWjVBU0Ywa3dpaVRFMXVqcW4yTllaRnZ4REthY2Fld3JmNjJjSlNX?=
 =?utf-8?B?S2dUU1l4MVNtbEVWellaZmhUQUhQcHcrbWNkTHlPM2d4RldkcnlxWXNuNUZS?=
 =?utf-8?B?cHdPRmFnelJhYk8wME1zbUFHdkg5bHhHZEhVYzRURFF3dHowbGtWODlhV2pW?=
 =?utf-8?B?OUE0eGI0MjBFTjNUTFJBVU82MVRXMlpRMlo1RWI4eTUvN2FsVEUwcVA5ZUFD?=
 =?utf-8?B?VFBUL1dQSzFJUmlPK1B3RHlLRGs4Zko1QllXcE9GOXRUYTVkckxPdW9KeW5G?=
 =?utf-8?B?c2s0bjlhY09iMGNmaVZ0cmpzOHFrZ2R0cjYzWFlOZFBkSzBJUC9xOWVPcGlR?=
 =?utf-8?B?bVZoTk0yT2dyREZpQlFtVDAxRWp3d3V3amFEYzIramhOYXB4Q2xDQTlXeHR6?=
 =?utf-8?B?M3hyR3B5aFRrQzFldkZTTEUzczU0RG1ua0NWSzdQRmxhN3BUeEF1NHp5TDg5?=
 =?utf-8?B?RDZkVnJZK1psV09TUklGTXVoS3gyVkJrNW5aMzFoZzVzVDQ5VndrTXhJS2E3?=
 =?utf-8?B?ZHl5YTN0Tjd4cnFFTG9pRHpLNGVMU3AzOVRJNHFzdjlvc0ZuR1VTZGxsTm90?=
 =?utf-8?B?Nm9JellIUmtmVzFtZXNuZllpTlVDK2E3OENLaDhTTVZrYllwaWhSR1YvZHF1?=
 =?utf-8?B?U3ZLL1BUZFpqWEs0ZTFsTFE3TERTUDM2b0QrNDFINDRPZk42dFhnSDR4N2Jr?=
 =?utf-8?B?Y3JmamMzbEZEaVgwZ3lmREN4ZnBPbm84UUVuZEF3S2QxUGxUZzZwdTlXOHZG?=
 =?utf-8?B?ejd1YnROdzk4U3UrTnNzcFRkb0JQek9ESnhzWk1CMXUzMTlIeWI3RXl2Q0FN?=
 =?utf-8?B?Q1o1UnhTRDRtaWRISkJsejM5Vk1lbHJlaWJmRGZObEhwaW5MWlpORS9xd0E5?=
 =?utf-8?B?bzJPRTVWVEJkTWlpaWFqYW5mS2ZKVmNMK1p3WUtqUFFEcEt5S3VsYjZ1RmxX?=
 =?utf-8?B?R2poa3YrRUpPb25sM2FjRU82VnFiaStxVkE3Q2VtVGlnS2d5TGk2djNYTGlB?=
 =?utf-8?B?NW9wTndFcU80T3FJU3Z3bXJob3VDMVFrZHR6UTFweXVPQURwZ1Z0eGZzOTE5?=
 =?utf-8?B?ajBmZFRlYjF2d3VyZ0Fxd2lVNGdmdDlFMmw2QUkzMXlkYThCaFB2a0V1bzBw?=
 =?utf-8?B?KzBkbDBaMHZQMXpQU1B3cC8rZkRYaEtYRisrYWI0dmJjM1NhY1RZa1FIZyty?=
 =?utf-8?B?eXNITHMyamp5SmQvTmRXeFpRNUtnRzFBZmxoMng3bkRlQVd2R3lkVDdWMkFj?=
 =?utf-8?B?aC95L0g1VEQ2MnV5a2FLV2Y3aUI1SC9rSDBhZFRTamxCR0JXUjVJS2Z1eDAw?=
 =?utf-8?B?WEI5eVZzcWNhRG91LzNXcEE2czBDWENPR3BVSGxVUVpWNGxVSzhGT24yZ1Vj?=
 =?utf-8?B?dDl3V0h4cGIyenlrK2tad09lK3RXNFJjUm9yQW8rRGI2ektzL2JWNWU1Q1VM?=
 =?utf-8?B?WU5NMHNSY3VORlBnYi9qYW9UTnJTZ1g1TktUK1dzMGo4NUF1Rk5BVnlDVXZv?=
 =?utf-8?B?MmlGVStNNGQ1OUtCVjVHWDBzNkdaZFIzelhiamlFUzRlOVZHbFZBOUg2M1A5?=
 =?utf-8?B?T1hXaTAyWTZkNm9wRzJQU2JwTGl5anFGWlZuLzZ6dHJTQXcvdG55N2lOQVZZ?=
 =?utf-8?B?c0FGckE4MStMTFd6a0NOU3hlc3pMRExKVmc0NDErTTdOWDJjSGduZ0M0UlNN?=
 =?utf-8?B?eEIzK1llM3ZNaW1JQmwySXozZkdESm96amtYalg0MnpDVG5xeVJ0aWtVYTlX?=
 =?utf-8?B?MHVERmp5UTJwbHVhRms3Z3hrSjR2KytZUlVVY00wL25HYnd2UjF1RnM2SDZS?=
 =?utf-8?B?QWdBbUgvQnlnSWF5WlRGRkNjZmV2RExUUXEvQ3VBN1JyY2wxcUluNGdWME1S?=
 =?utf-8?B?d2dPa0FOT29pSVZqUU0xaUtWWE1lUlZSR253Mm0yYitoMUdrTkNSS3BKNWVC?=
 =?utf-8?B?WnZ0SGE4c1dCcUNUR2l4NDExeitnTlowbGZ6ZmZhQVNZL3FmOWN3ejREUGpa?=
 =?utf-8?B?aHp3Vm1ycDlXazNQYXNHZmRMV29qcXFtb3dUMmI4b3J2S3gvRWFjVEhuVkRD?=
 =?utf-8?B?QzBIMGhqcFBtL3g1UUNtVU1xL2F6U256VU1iZ0tTdVRVc2VKR0JwZzhWSW56?=
 =?utf-8?B?WlBHQ1hiYWtBWHkxbXJhcERlNEMzUExZMVQrYUNoYWJPU0FTQmgyY3JxSFFR?=
 =?utf-8?B?L0NVK1l6Rzg4QjNBNFVmalRQVnpNYnFOeGo1R211R2NwTjMrMVVVTEJQMmNY?=
 =?utf-8?B?N2xoR0ZUUUFOYWN0YWY1Q0lZZmtxSHdnenRyaTM1ZllETUtiY09TeEJ3M3Jl?=
 =?utf-8?Q?ap4rN1+pXKz2WdZplW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8211.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e8328b-9015-4ec8-2c8e-08da2151451c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 15:36:56.0950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FQKSVLAkpo97JM3XchmIFmzIXj05fz2O6Pau5UAIz2TYyQfzSgUPKyl+XEGYA5Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7738
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgVmFiaGF2LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFZhYmhh
diBTaGFybWEgPHZhYmhhdi5zaGFybWFAbnhwLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBcHJpbCAx
OCwgMjAyMiA3OjExIFBNDQo+IFRvOiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+
OyBWYXJ1biBTZXRoaSA8Vi5TZXRoaUBueHAuY29tPg0KPiBDYzogaGVyYmVydEBnb25kb3IuYXBh
bmEub3JnLmF1OyBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPjsNCj4gR2F1cmF2
IEphaW4gPGdhdXJhdi5qYWluQG54cC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3Jn
OyBGYWJpbw0KPiBFc3RldmFtIDxmZXN0ZXZhbUBkZW54LmRlPg0KPiBTdWJqZWN0OiBSRTogW0VY
VF0gW1BBVENIIHYyXSBjcnlwdG86IGNhYW0gLSBmaXggaS5NWDZTWCBlbnRyb3B5IGRlbGF5IHZh
bHVlDQo+IA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9t
OiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo+ID4gU2VudDogU3VuZGF5LCBB
cHJpbCAxNywgMjAyMiAxMjo0MSBBTQ0KPiA+IFRvOiBWYXJ1biBTZXRoaSA8Vi5TZXRoaUBueHAu
Y29tPg0KPiA+IENjOiBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7IFZhYmhhdiBTaGFybWEN
Cj4gPiA8dmFiaGF2LnNoYXJtYUBueHAuY29tPjsgSG9yaWEgR2VhbnRhIDxob3JpYS5nZWFudGFA
bnhwLmNvbT47IEdhdXJhdg0KPiA+IEphaW4gPGdhdXJhdi5qYWluQG54cC5jb20+OyBsaW51eC1j
cnlwdG9Admdlci5rZXJuZWwub3JnOyBGYWJpbw0KPiA+IEVzdGV2YW0gPGZlc3RldmFtQGRlbngu
ZGU+DQo+ID4gU3ViamVjdDogUmU6IFtFWFRdIFtQQVRDSCB2Ml0gY3J5cHRvOiBjYWFtIC0gZml4
IGkuTVg2U1ggZW50cm9weSBkZWxheQ0KPiA+IHZhbHVlDQo+ID4NCj4gPiBDYXV0aW9uOiBFWFQg
RW1haWwNCj4gPg0KPiA+IEhpIFZhcnVuLA0KPiA+DQo+ID4gT24gU2F0LCBBcHIgMTYsIDIwMjIg
YXQgMzowMCBQTSBWYXJ1biBTZXRoaSA8Vi5TZXRoaUBueHAuY29tPiB3cm90ZToNCj4gPiA+DQo+
ID4gPiBIaSBGYWJpbywNCj4gPiA+IFZhYmhhdiBpcyB3b3JraW5nIG9uIGEgZml4IGZvciB0aGUg
TGludXggZHJpdmVyLiBIZSB3b3VsZCBiZQ0KPiA+ID4gaW50cm9kdWNpbmcgYQ0KPiA+IG5ldyBw
cm9wZXJ0eSBpbiB0aGUgQ0FBTSBkZXZpY2UgdHJlZSBub2RlLCB3aGljaCB3b3VsZCBiZSB1c2Vk
IGZvcg0KPiA+IHNwZWNpZnlpbmcgdGhlIGVudHJvcHkgZGVsYXkgdmFsdWUuIFRoaXMgd291bGQg
bWFrZSB0aGUgc29sdXRpb24gZ2VuZXJpYy4NCj4gPiBUaGlzIHByb3BlcnR5IGlzIG9wdGlvbmFs
Lg0KPiA+DQo+ID4gVW5mb3J0dW5hdGVseSwgYSBkZXZpY2V0cmVlIHByb3BlcnR5IHNvbHV0aW9u
IHZpYSBvcHRpb25hbCBwcm9wZXJ0eQ0KPiA+IHdvdWxkIG5vdCB3b3JrLg0KPiA+DQo+ID4gU3Vj
aCBhIHNvbHV0aW9uIHdvdWxkIG5vdCBiZSBiYWNrcG9ydGVkIHRvIHN0YWJsZSBrZXJuZWxzIGFu
ZCBwZW9wbGUNCj4gPiBydW5uaW5nIG9sZCBkZXZpY2V0cmVlIHdpdGggbmV3IGtlcm5lbHMgd291
bGQgc3RpbGwgZmFjZSB0aGUgcHJvYmxlbS4NCj4gUGxlYXNlIGVsYWJvcmF0ZSBhbmQgc3BlY2lm
eSB0aGUgdmVyc2lvbiBmb3Iga2VybmVsLCBkZXZpY2V0cmVlDQo+ID4NCj4gPiBUaGlzIHByb2Js
ZW0gaXMgc2VlbiBzaW5jZSBrZXJuZWwgNS4xMCwgc28gd2UgbmVlZCBhIGtlcm5lbC1vbmx5IGZp
eC4NCj4gS2VybmVsIDUuMTAgc3VwcG9ydCBkZXZpY2V0cmVlLCBEbyB5b3UgbWVhbiBjdXN0b21l
ciB1c2luZyBrZXJuZWwgd2l0aG91dA0KPiBkZXZpY2UgdHJlZT8NCkZhYmlvJ3MgY29uY2VybiBp
cyBhYm91dCB1c2luZyBuZXcga2VybmVsIGltYWdlIHdpdGggYW4gb2xkIGRldmljZSB0cmVlLiAN
Cg0KRmFiaW8sDQpXZSBmZWVsIHRoYXQgaXQgd291bGQgYmUgYmV0dGVyIHRvIGhhdmUgYSBwcm92
aXNpb24gdG8gcHJvdmlkZSBlbnRyb3B5IGRlbGF5IHBhcmFtZXRlciB2aWEgZGV2aWNlIHRyZWUu
IFRoaXMgb2ZmZXJzIG1vcmUgZmxleGliaWxpdHkuDQogRm9yIGkuTTZTWCB3ZSBjYW4gZm9sbG93
IHRoZSBhcHByb2FjaCBwcm9wb3NlZCBieSB5b3UgYnV0IGF0IHRoZSBzYW1lIHRpbWUgd2UgY2Fu
IHN0aWxsIGhhdmUgdGhlIGRldmljZSB0cmVlIHByb3Zpc2lvbi4NCg0KUmVnYXJkcw0KVmFydW4N
Cg==
