Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B92C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jan 2022 10:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiAQKdd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jan 2022 05:33:33 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:31227
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229573AbiAQKdd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jan 2022 05:33:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbZX9wvTl1zdHMLM/Daor7gjZV9OC2/sEx9QqUeZ1wrBO90Y7WaCIgI9MZwbZaA5MS4Ubhh1kYf/W2e0y34vEmZXoLyNz/o+gJF0WIM3waWx3QRDDJUJeB7rNPB2AH7243R1NTtwLn0h2yuepl3lWzzPqhZl41DOIIZrr1jAJvhgeyHphsBZxTQbq6b9VwC0+PrSMmdt+bVg/f/ixUHKecr1vG1OuBoX71gRtnP9dQ+0WfeNDv4vYLMoPVxayiPRk6StoRsuKtDMOJqbDiTqY6g/SOWaYgBpc718W3CVMw0t+wbyu+iHeRYJhznHRTeudGm+Y3zO2kMRFHoV8/mxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VHOkmbPqIZQUntoKCNBdABGBvv/WJMkiFs72IxBwO4=;
 b=XAILAfpnkorsdsnubTwnC10dtQ2adfh+vZBXEB6VXyovk+QkImgMhZwAeGTUCjkuL7GDy4CSePYLNyXdDzhAwSuS76WCaIatDv/q3X7JAF6gXbJrzS8PS7N5NsTLW7//3ST61lDYAQyW0DUVK1wbFwc0ieNo0OSTRUOD+7kmi9wyyOayUztv8kUjF/sV5nTGZotTwUWWqUI0U2NcXUv2Gph277nBuL7amCg1twmy6R+ePw1SHZ5TGNN2Dk8XU2vGa0+PrCgA9jxedFiTc5q/yqSEcbWZlUng+uUAJkQaHk6M0CcCRTvR1Y9IVKPI4VZXf0a0pPvbJlWS7GcZ/iHq7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VHOkmbPqIZQUntoKCNBdABGBvv/WJMkiFs72IxBwO4=;
 b=G/d42yq8lXNg/ovUJEDaEPdDVowb9D6EIfsKj3vKzPNIh3LuNUEe0DGOGvgD9sRAZWhdh4U0uNNAvF5LH90cPiXddbxm7vW6oAqbYXDNsF5WdDVrSNMlqV3FkG4zYScfbihdeOXNvPSX4Kme3SKwTIaXZjvtzjr7tAjmAm7cq1w=
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17)
 by AM0PR04MB5489.eurprd04.prod.outlook.com (2603:10a6:208:10f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Mon, 17 Jan
 2022 10:33:30 +0000
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::59d:b332:4268:acac]) by AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::59d:b332:4268:acac%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 10:33:30 +0000
From:   Varun Sethi <V.Sethi@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: Re:[PATCH] crypto: caam - enable prediction resistance conditionally
Thread-Topic: Re:[PATCH] crypto: caam - enable prediction resistance
 conditionally
Thread-Index: AdgLjapomTnZlGSBTLCL8Yk4JTAUhQ==
Date:   Mon, 17 Jan 2022 10:33:29 +0000
Message-ID: <AM9PR04MB821189789830A0A1B825887AE8579@AM9PR04MB8211.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 777524e5-95a1-4a61-cf09-08d9d9a4cdce
x-ms-traffictypediagnostic: AM0PR04MB5489:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5489F8B203006858ADA945ACE8579@AM0PR04MB5489.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WYkMLZbUO8juQICB3lmhXEOHt28GpiYLrw/I708yPgdcCET2XaWRS0JNxQTKFYaPCcKnyLKEsvpBBwHP0UqDz5HNisTBIzXLlyxL7x52Ik8XZcab2ADAh5gUva2rfot0DVsWj7rR5JjJ6Cupwv4y/fO/O6distCopXChRGh8Nd0MDxgdxYUQ1i95HE0uwh0A7BwbBnfCzGodkOHb6v+gLekl+NMa/jEnF7xvKOhmXdTlGztI/xHIa0S+Zi7JGcH9H4KLvOFw6+xWurJLgw1LEMZetFF7BpHVeRCmnOFx5CVlkK0eyOpvMWPhtke+HZXiEMcfERGnalk5Po9s2ieSOAG9Epxe6qTSiKVacAqZ6gfh0OC//01JCJGUCs3y8VtK7/VKyvb9eJp/TbLBslZ1iJ2KNMG4S4yF7hLMDu1F9iN5jyALhhUhXzK+vRVh2fxj6MqCxOc0FwuUj5mQ76OFwAEDbjDkmpzuR7WtUyALROtAzw+xo7ITybWbjIk7ugcosEX/9NoIL44zma7KiB67kaJNPKfY2dKaQ+dhPTNB+cH9VAF2YIM6OxnZ2hsQP4BEgVBl6Gustvc+v60BR1xhXfpywBx9DP1eU9nk7BOrH7sRnlJJEjrKXXkcgA55n/dwBi+vu+MPJ8IKORjuZPml9RsegA97s1agicYmqjtf7jDS25DrRqhk0JBJwmxSECT5ZC4LlX+xTMU84wZM+3FESQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8211.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(186003)(76116006)(66946007)(86362001)(9686003)(66446008)(66476007)(64756008)(66556008)(83380400001)(122000001)(55016003)(7696005)(2906002)(6506007)(8936002)(53546011)(38100700002)(508600001)(6916009)(33656002)(55236004)(5660300002)(38070700005)(8676002)(4744005)(54906003)(4326008)(52536014)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1BDb0MyWDUxVVRocGJyd0JQWEhpWmJtRmIrZ3Z4eVNkek5mdjJ1djhqQ3FE?=
 =?utf-8?B?U0tqMENOa29JUmxMZjhNZVpOUG9wVW1qTXBpZ04xQVJVZDBIZGprbUkvV2Vj?=
 =?utf-8?B?OVNmRG8yRTg1TlRLVUlBbDM5TUZFdWNTa294NjBUQnZNNVYrYkRaTmVtSy81?=
 =?utf-8?B?dTZPNjh5MUdPY3RoaVUvS2NrTmV2Q1hHdXY0YnNMWm03WDlSaXdaL0pwdU9V?=
 =?utf-8?B?Sml6MWpwS1UrVlJzL2hjUC9qNGJwVThLT09aamphWVlZM3JzSHVwVkZKYWRq?=
 =?utf-8?B?UEMrTUkyNzF2RkppNlhyeFZCUDZwdHEvRGw0NEEzZXRtUkk4dHpTQUdmc29R?=
 =?utf-8?B?cUliQ2Mya1lTbDhYaVVjbUJxYjFFUUhpTVRSOU15Y1FUTmo1eDdWQzh6a0pt?=
 =?utf-8?B?d0N6azYyS1Q4dmRrajhNbEdlU2c5ZGppRHZnVTU2dkxvRThIdDNod3FOdHVH?=
 =?utf-8?B?KzBkYlhoY3IwVUtlTStrSHMwSmNFNzBnZmQ4dTZDSG9OcUtCVUEyczZFckpU?=
 =?utf-8?B?Ym8xcXNLMy8vdkp3UkVwSjZhREZ0YVRpL3NnNmdqUm5SQTJSZUMxTW5SdzlE?=
 =?utf-8?B?QXpIUldVZ0JOU2RZZ1NRZkVHTm1oMjVad0t3SXhpUUpCNUloS08wRlVTZnp1?=
 =?utf-8?B?aDExTzNJd3VDUkdXN3EzYjhzY0p1R294c25PZHZLbW0zc3hkcE53Y0hxTm1H?=
 =?utf-8?B?NHJoRVM4R2wyRUJMdGs0MWc2NHI5enZ0OFpOdFB5Snk2M1k0bGZhb055WFh2?=
 =?utf-8?B?amhjRmdnWEhtV3F6ampHbEhrcFJZRnF4L0kvTmRUTWlyOFQxOHF1Z1Jpeldv?=
 =?utf-8?B?cmxqMiswYk1mamxKbEtOMXh5dHpXTnh5R1lNa0VML0VBTFhYSmJiSnZFNFNa?=
 =?utf-8?B?cUtMdHRvSkRMcE91QXhER0gvU1hhWFUrYkpkMWFOSWZ2dTlHU3FoUFNQdEgr?=
 =?utf-8?B?WGNDTVNkZUZIb0V1UEcyRUhkYXRRL1VlRVh0eFdEd0M3d1ZSYUJodFU1QmJU?=
 =?utf-8?B?aWM2RzZKYU9rOFhjUnFKV2U1UVg3SkVBRXcvcnd4SktWWHVoazV5cm1ob2Fu?=
 =?utf-8?B?U1pENUZKNWNkZnA5QktnRDNkaGZJaGJEUXpkZFVLSHUzVnVzRmlTZ0hQc200?=
 =?utf-8?B?SXpPMkFjQ0FjZC85Ky8vM1BUU2ZrSzlLOEhLa284SlJzVlpBUi9kWTZqcTRl?=
 =?utf-8?B?cFRnak00V2Z0YXlZWnhTOVZkdHFBVGFNM3VZMEg3a1hRY3dhSk52dVlQRW5l?=
 =?utf-8?B?bFBWZHVlYUpjQnV0Q2RYK2tyWXBqQis0dG9sK0I2TDA5Wm56eUtpVjZ3M09y?=
 =?utf-8?B?RjY4czAxMnBydDJMWmoxUG1HeDVZbVRoeitDZEltdUxycEY0RkR6QUNHTDNh?=
 =?utf-8?B?aE5Ed2JXanpkUkxYRU1lSHk1UEFyTDU2TE94UGpXS0dhazI4MDNkT0piSlhW?=
 =?utf-8?B?ZEE1ajY4d29uRHRMN0duK1RJT0VpbkpodFNSU2JxWHdwS0N1aGF3bG1ibEZ2?=
 =?utf-8?B?RkVKYTdyeFBIZ3RzME1YaTkra1ptMTNqbE4vTDFHTU9aMEYrOXZhYkF2ek04?=
 =?utf-8?B?KzhmR3JxRkJUN1h1S0Vab0phbnRVYzNWRGlRUXBNNlFuNW5DR0c1cUVndklV?=
 =?utf-8?B?bWtrR1ZLMXYwZHJ5Y1JSWGwzVFZmd0YzZmV2NkE1R3QvMVBVNU9Tb3NaZFpx?=
 =?utf-8?B?N2pURXM2MmR5dm5ES0lraW9scDNoSEhBaXh4bFc3UVlQNndGbXJwekwzWmRP?=
 =?utf-8?B?M2EvekZWZnRod1NjR2Z6Ty9PUmhvdmk3OWpSd2VFQ3hDc1JZa0ZFTjBBZHgw?=
 =?utf-8?B?YVB6MDIrS21NV3A4U2FXZDFUVmt3VHdoR1hKY0NzQUhOemh1QWNhT0k3dm1I?=
 =?utf-8?B?UUhCbTdRUFBhNmxCZ09Nd3lHUk5NVXl3SlkrQW81WVFmMVFXb3dpa0xDRE5I?=
 =?utf-8?B?Yk16b1FBZk0rSzFsR1pBNCtieitRRDFWL1JFajZjOXk3ZnVxdHBIRk5yVW13?=
 =?utf-8?B?cThyVVJyN0lWUkJoOWFvekpkWG5XNWhOK05LVVhwMXY2ank1R3dKZnlsM1Y4?=
 =?utf-8?B?c3RJZVJodEI3N0lNN1UvRUdNRHFsbkpHVloyV0VjcmRNcWRBZzZxNFRWd0dG?=
 =?utf-8?Q?dIxQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8211.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 777524e5-95a1-4a61-cf09-08d9d9a4cdce
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 10:33:29.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PL70hUABK9HNPy8/hWaOLQssWUrzAPaGHdDdGqQLZVWFu9uXCsQyOYS9cDyg9UP/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5489
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgRmFiaW8sDQpTdXJlLCB3ZSB3aWxsIGNvcHkgeW91IG9uY2UgdGhlIGZpeCBpcyBzdWJtaXR0
ZWQuDQoNCg0KUmVnYXJkcw0KVmFydW4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZy
b206IEZhYmlvIEVzdGV2YW0gPGZlc3RldmFtQGdtYWlsLmNvbT4gDQpTZW50OiBGcmlkYXksIEph
bnVhcnkgMTQsIDIwMjIgMTA6NDcgUE0NClRvOiBWYXJ1biBTZXRoaSA8Vi5TZXRoaUBueHAuY29t
Pg0KQ2M6IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGFuZHJldy5zbWlybm92QGdtYWls
LmNvbTsgSG9yaWEgR2VhbnRhIDxob3JpYS5nZWFudGFAbnhwLmNvbT47IEdhdXJhdiBKYWluIDxn
YXVyYXYuamFpbkBueHAuY29tPjsgUGFua2FqIEd1cHRhIDxwYW5rYWouZ3VwdGFAbnhwLmNvbT4N
ClN1YmplY3Q6IFtFWFRdIFJlOg0KDQpDYXV0aW9uOiBFWFQgRW1haWwNCg0KSGkgVmFydW4sDQoN
Ck9uIFRodSwgSmFuIDEzLCAyMDIyIGF0IDI6NTMgUE0gVmFydW4gU2V0aGkgPFYuU2V0aGlAbnhw
LmNvbT4gd3JvdGU6DQo+DQo+IEhpIEZhYmlvLCBBbmRyZXksDQo+IFNvIGZhciB3ZSBoYXZlIG9i
c2VydmVkIHRoaXMgaXNzdWUgb24gaS5NWDYgb25seS4gRGlzYWJsaW5nIHByZWRpY3Rpb24gcmVz
aXN0YW5jZSBpc24ndCB0aGUgc29sdXRpb24gZm9yIHRoZSBwcm9ibGVtLiBXZSBhcmUgd29ya2lu
ZyBvbiBpZGVudGlmeWluZyB0aGUgcHJvcGVyIGZpeCBmb3IgdGhpcyBpc3N1ZSBhbmQgd291bGQg
cG9zdCB0aGUgcGF0Y2ggZm9yIHRoZSBzYW1lLg0KDQpQbGVhc2UgY29weSBtZSB3aGVuIHlvdSBz
dWJtaXQgYSBmaXggZm9yIHRoaXMgaXNzdWUuDQoNClRoYW5rcyENCg0KRmFiaW8gRXN0ZXZhbQ0K
