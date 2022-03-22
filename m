Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0207C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 13:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbiCVN55 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 09:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiCVN5z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 09:57:55 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B7D419B1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 06:56:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0XNaRnqr/amA7vFrycQUFmmkFuLZAx97PTkB0Iw60Je8ofT+U0pYurCvubdksVrwHTioHAa+zEVuz1vAM9Ilt9/7RgL2yqRnVuOXEXW6y+AUVlCCuwD24candKxW2RBUslHO74/h1T7B8aSKnrwBsH98ISV6EzNyI9c+S4TyQl96yDCAw9VhWiJYRXD+2/c+luMuAAOeIctFEGm6p+iobgWmkA7726/Sl16o/VDqfca9gyoRWcVK+iOspDhMz73Ajr96jrdw0QUll3eCJY+Z1VLHkpq8GK+nK+T4NTt+Br8/sKVnaOV6clZo71Cspfp3O07+M/q6PeT+SwGHAi8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wP9WdKAdRaP1FkRKoAyhoARtlaAF9wWfgTSa6ab21OE=;
 b=L6o4tbCwas+AA0pDzsJQjJzHgurgD4tODM14ayjW5Sv7u4USeoMzl8S/RB/bru4UsovhGqSvPCYqCInHPxNK9dCBBYSxhegdViqyZJn/tUC8LD66DPUp6pMC1G54ORf27dhvGjaVlVHB82b2tLhWAInT09fmVUOlfmKQVViZaRe/29SyeoOmcmjKQVznCY4SVv34lnHV2rkd24a+wT1FqsYcDHPOC0is0CriUAPVqoPr+qeBtS6eFHzZsrDPZJj4UE5+R6eAoX0zTbJ6ccAoO2Y8Vey0wQOaXVXAgBBdx05k/er1MDmW7MrKxdBlv9rxBmquexbzRcJ+yL3ytVYxHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wP9WdKAdRaP1FkRKoAyhoARtlaAF9wWfgTSa6ab21OE=;
 b=eQmN48Js+Xwh1sXV1aLd8eTkxd2UOFW5PR92l90lXD+zIHc/l2nwNfP/s3PYMDHJyPIgR/WPOZdNbg8OMvurPSV1rSuBDC1wE/69hd5nRuc3jQSb9rEPqxrpT1BNKjaORMu/Gxz4bnztTgQMzPUREt1c7BWhyGFGkoPzSrMybLg=
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17)
 by AS8PR04MB8168.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.23; Tue, 22 Mar
 2022 13:56:25 +0000
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e]) by AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e%4]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 13:56:25 +0000
From:   Varun Sethi <V.Sethi@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Subject: RE: [EXT] Re: [PATCH] crypto: caam - enable prediction resistance
 conditionally
Thread-Topic: [EXT] Re: [PATCH] crypto: caam - enable prediction resistance
 conditionally
Thread-Index: AQHYFA+XRrn7r2kbs0mx6aHJDg+BV6x4DYuAgFOpUwCAAAlhEA==
Date:   Tue, 22 Mar 2022 13:56:24 +0000
Message-ID: <AM9PR04MB821114617421652847FFBBF3E8179@AM9PR04MB8211.eurprd04.prod.outlook.com>
References: <20220111124104.2379295-1-festevam@gmail.com>
 <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
 <CAOMZO5AAYHRUUy872KgO9PuYwHbnOTQ80TSCx1jvmtgH+HzDGg@mail.gmail.com>
In-Reply-To: <CAOMZO5AAYHRUUy872KgO9PuYwHbnOTQ80TSCx1jvmtgH+HzDGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 663c28d5-cbf4-493b-39ec-08da0c0bc142
x-ms-traffictypediagnostic: AS8PR04MB8168:EE_
x-microsoft-antispam-prvs: <AS8PR04MB816807FD9D38CACCDD5E57CBE8179@AS8PR04MB8168.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 602CkEF5CuHN6JddZVJQmmuEQUwkMsT+qX12iE4CJlosAUyA687v/Hxc8snJkzxJovg/rUaJ/NxW/UKQwtcHuGfVZiHhX5CdeRoJaH55z64ocPydBZ7kX8kCKGr/sgFYX7gb8TLgEWkVUZ3NQyrP4J8IdG1aKtEXcnpXo5h74hhjnDzwiKtx+xH8PlP4Dgqo+NywsJu74JGvFRubqnD5G3i6gOUWzPvOoAlZkr0SQ1yL65ucVoVyq0b5vOtva9noF9zvkGtqXby8wBzv5yE3aL7stZdg2DSEvVgHFdgVTbiI6/O0t/U8zrdK4OZM2No0uo7jlXlplzej6t25RQMiio/wu1mXnx9sbTVPFb48qHUIP62lNSFFN7eBwaRIwDWtaE2Ztak/WXMm99Gw8lXOh/i/5gE5vi5F4hWzsLJe5vPmKQ97gX6vLMYpKIycPxshh/pwvsaCispOIC9UGpSA1MbC8tpVdvuuvi8UxAEV8EsC79f7s33hPl/gUb+vIUVoviRsSQ2LlVPQsk999q7KDrPJ7EW6jpRB47tLAiU68xq1tPjxXFzol/8WiJYf+snDRfK0AaTLmPtyGkV4dV2n8G2XfHcctqKCibzam7VKFSrFRcLCiHce8bkUW47oBW/duOlYJMj6CioAlIsi9OW2DXxEOZZmy6ZZ66DMfUGvyLIr6wP6NA8eyGQ/3dOnTNyUL13qWt2WsA2tOZQzK0/t5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8211.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(508600001)(38070700005)(2906002)(38100700002)(33656002)(122000001)(316002)(6636002)(54906003)(110136005)(26005)(186003)(8676002)(4326008)(76116006)(6506007)(7696005)(66946007)(64756008)(66446008)(66476007)(66556008)(83380400001)(53546011)(5660300002)(86362001)(8936002)(52536014)(55016003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDJVYXZUVDF1Q3ZGWkVueTBoZ0Vra1FpZk1SeEZPK1NDZnJ4UlAzSnNUbmZt?=
 =?utf-8?B?Qm16RkpFRUMyWnFpZ1UyMVJyWVl1YjZvaXFGNzEwVklDMjVwUGxvZWJPTjhO?=
 =?utf-8?B?K2pGenBIUzloS1RMZFY2Q011eFMrSmJDdGQrbGwyR3dPN0VQMDZrdDVmK2pZ?=
 =?utf-8?B?K05MeHVsMHkxSGY1Nm9XUThDN01xS3lwU3JRZU45b0VhcmdDMzdNNVJxbDBm?=
 =?utf-8?B?WGlWVHFVWngzOGpIQkNIUzcrZmhpNFlNNE9LTFVZVmJXK3BRWVcwcGdQelRw?=
 =?utf-8?B?Q1BsUU5KUW53MGFHT2dnbXpBZmN3UnVjaENySkZBc0hkRUtxYTJ3cDA1Wmtv?=
 =?utf-8?B?SG9uekRFaHVKMXQvWmN2clFucklkUGYwMEs4dTQ1ck96MGFoZ1FGendiM3BX?=
 =?utf-8?B?VVA4UkNyV1pCVnFQU1Jpc01mbEFUaWhTMXMvUmdNOWxXYzlZSjkybEFSbnB6?=
 =?utf-8?B?N0NRdGtVZW5abXFDWFd1cFpvM3owdi9lK0pnWThJbW01ZFoyWkZHY0dYNDJT?=
 =?utf-8?B?REwveUlVZ0N5ZmtWeDZ5UXJpQ205UTc0R0FVZzVuQm1vN3pxcnRaRjZaVkNh?=
 =?utf-8?B?WFk1bGlYMEVMcVRQbHRtaFNTNGxVMEhyaUhwWGREWVBYRFNSbVRuaW53amo1?=
 =?utf-8?B?K3pGTmtjWlB1SnpZTHhFZi9ZQjRmMG5nU2EyR0ZucmVBTEx4eEdEV2IwS3Ft?=
 =?utf-8?B?SnZEcGxFdFNtQ2VOUThIVndrVlRxRGkrOWhBTFA5U2xIaC9BbjVsMFFwVGFu?=
 =?utf-8?B?aDBHNUcyL3VFS3dlVVlSYXZlblFhZm52aXJGWFZqMHdodDFkNHFpYm1hbTNL?=
 =?utf-8?B?VHNiMmRqK0lvc1NOeUNpRTZtUGxHL0IxbTE4N09jZHFSRG5SVWNTa1lqZnNv?=
 =?utf-8?B?OWJtaEJ0VEFYRFBHWmU5eE5pZ0Izb1dFMms0czVZbXhSZlRJQmRNYytORnpM?=
 =?utf-8?B?dURFMUk5UGUrOUd4aHRhdlNXM01lY04wVmtUb1J5T0Y0ZkFtM0l6VW84Q0dO?=
 =?utf-8?B?b2MweVF6c1FIelpYZVd5OHUxZ2JCQUZWOHhwQlU1cXZqeDh2R1l6dUs0QkV6?=
 =?utf-8?B?RnBwcWlzM0V0S2hpalVQZXBsRkhRaGxYempXWjlGSUVRUExwSmNreXp4YmVn?=
 =?utf-8?B?NzdLWEU4OTAvRFJVMlcxR01uemdCSVcvMnZ6MkwzNkEwYjlLS0h6N3JjSzdV?=
 =?utf-8?B?UUsyRUtCMlNFb0FtZm9SdDJpbFRwMFZBa0RHdzVjUHBHMFI2UWhVOVgvUHU0?=
 =?utf-8?B?bWlhdHJYVEpLSXhidm9HaFVaeVI3MlRtdVp3RkNUTzh5RmZOL3AwUUlWZ2E0?=
 =?utf-8?B?WUtWV21TTUwxNkdaTW5SUjZ3WUF0TmVBRXNXUVRWRk4zaVROeDdvVTF6WEVP?=
 =?utf-8?B?V2dScy9sQ3hiN0V3QitubFRKT2lQanZtSzRkRTNLdVYrcElzQnBOYUpXSWF3?=
 =?utf-8?B?MXcra00vVk5HTDBMZ0gxOFBDNnlLMC9QOEhvc2NSWjA2UjdxUFVOWnNLZEZY?=
 =?utf-8?B?dlg4RjJ4ZXM1Q040bk1ETGx3Tk45NGJCMDhJMGpORDhrSk5rSFprNGpTanBi?=
 =?utf-8?B?R2JsdFpac0JFWVRWWW45R2FDZGhFYlRuaEs2WkdmUFZMZ1hNWEhpM0Zxa2Nq?=
 =?utf-8?B?RlZmaFRDZXZ4aEZEdVFKSGNxWEdwTVBSUDlIK0p2NGxIS242L0hqZ0FhWmRu?=
 =?utf-8?B?bzNGYXEyaWoxNXpEZ0hicmVkUzN0STJpdGVFVUpmMm0zbU1wSFhnL0F2anBq?=
 =?utf-8?B?MEZwWmVaUDRFZit1NFIwaDJJdjhzTUVYZjB1T1BqWkxoMmNWMnR5bUZhdFEx?=
 =?utf-8?B?dlN3ZEVJQk9udEpReTdvSGNETjgyNjFzVGJFUktqTThGZkY3amJ1SG5KZWdS?=
 =?utf-8?B?VEJHT0FVQ291bXVuSDc1SGIwQzVFNjFVVWp5a29ua2FmL3p2N0FqYWFwekpZ?=
 =?utf-8?Q?WBdX0IVt1Po=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8211.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663c28d5-cbf4-493b-39ec-08da0c0bc142
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 13:56:25.1769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: caKSgqoTnhgC5lgOxPMD8UmJYu5cZGS5BtsAjEwehxtARA2ua8eWRER6MnlabNyt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8168
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgRmFiaW8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmFiaW8g
RXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAyMiwg
MjAyMiA2OjUwIFBNDQo+IFRvOiBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPjsg
VmFydW4gU2V0aGkgPFYuU2V0aGlAbnhwLmNvbT4NCj4gQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRA
Z29uZG9yLmFwYW5hLm9yZy5hdT47IEFuZHJlaSBCb3RpbGENCj4gPGFuZHJlaS5ib3RpbGFAbnhw
LmNvbT47IGFuZHJldy5zbWlybm92QGdtYWlsLmNvbTsNCj4gZnJlZHJpay55aGxlbkBlbmRpYW4u
c2U7IGhzQGRlbnguZGU7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IEZhYmlvDQo+IEVz
dGV2YW0gPGZlc3RldmFtQGRlbnguZGU+DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0hdIGNy
eXB0bzogY2FhbSAtIGVuYWJsZSBwcmVkaWN0aW9uIHJlc2lzdGFuY2UNCj4gY29uZGl0aW9uYWxs
eQ0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBIaSBIb3JpYSBhbmQgVmFydW4sDQo+
IA0KPiBPbiBGcmksIEphbiAyOCwgMjAyMiBhdCA0OjQ0IEFNIEhvcmlhIEdlYW50xIMgPGhvcmlh
LmdlYW50YUBueHAuY29tPiB3cm90ZToNCj4gDQo+ID4gV2UndmUgYmVlbiBpbiBjb250YWN0IHdp
dGggRmFiaW8gYW5kIHdlJ3JlIHdvcmtpbmcgb24gYSBzb2x1dGlvbi4NCj4gPiBOb3cgSSByZWFs
aXplIHRoZSBsaXN0IGhhc24ndCBiZWVuIENjLWVkIC0gc29ycnkgZm9yIHRoZSBjb25mdXNpb24g
YW5kDQo+ID4gZm9yIG5vdCBwcm92aWRpbmcgYW4gZXhwbGljaXQgTmFjay4NCj4gPg0KPiA+IEhl
cmJlcnQsIGNvdWxkIHlvdSBwbGVhc2UgcmV2ZXJ0IHRoaXMgcGF0Y2g/DQo+ID4NCj4gPiBJdCdz
IGRvaW5nIG1vcmUgaGFybSB0aGFuIGdvb2QsIHNpbmNlIGl0J3MgbWFraW5nIHRoZSBpbnRlcm5h
bCBDQUFNDQo+ID4gUk5HIHdvcmsgbGlrZSBhIERSQkcgLyBQUk5HIChpbnN0ZWFkIG9mIFRSTkcp
IHdoaWxlIHRoZSBkcml2ZXINCj4gPiByZWdpc3RlcnMgdG8gaHdybmcgYXMgYW4gZW50cm9weSBz
b3VyY2UuDQo+IA0KPiBBbnkgcHJvZ3Jlc3Mgb24gdGhlIHByb3BlciBmaXggZm9yIHRoaXMgaXNz
dWU/DQo+IA0KW1ZhcnVuXSBZZXMsIHdlIGhhdmUgbWFkZSBwcm9ncmVzcyBvbiB0aGUgZml4LiBD
dXJyZW50bHkgd2UgYXJlIHRlc3RpbmcgdGhlIGZpeCBhbmQgc2hvdWxkIGJlIGFibGUgdG8gcG9z
dCB0aGUgcGF0Y2ggdXBzdHJlYW0gcHJldHR5IHNvb24uDQo+IFRoYW5rcw0KDQpSZWdhcmRzDQpW
YXJ1bg0KDQo=
