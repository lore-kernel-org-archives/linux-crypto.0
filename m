Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02871C001DC
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 09:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjGaJ5D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jul 2023 05:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjGaJ4n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2023 05:56:43 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2041.outbound.protection.outlook.com [40.107.13.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528B31B5
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2023 02:56:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8PfrdCPRzUhaO7occtYaLRIV7F/iv7c+3CvDEVKTI5Vb1EfZhGO69wiFSXhaQrjlFU00QNLprUa+b8QYlRmQsytz0wYaQAHZ3RhQs3WaFSHzDl45/hhzEetSkWwOjuwzxqGdJnwHcaCO9fgM4XqsHFlR5FYdqBEmbV9gBhZI6AYxfVQlV/bHuxe5enoaSHpOYMUSx9wQ3AIgaqnFzdiT1N3FdE6mYItJ6ivv7KRqf3LeI6bMiVBzy2SMNcuRJNS0ddh3i7m4GARW2yIH1T4woArmd+U8WPCjxpuVaONLrAFjQkVhzEmiCFr4fRAikHX1/jDcSJbXYNLCweUTKDYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nC71a5hQqztHJExw/N6/iJ89Quqk9Fb1fM1j2WkDm+w=;
 b=ktelkvds75ba/ix7esESYZPunNUGN/p4s2uY6JEAvmPZ18+9C33lWB/77dSKGQQs8e/bPNSTS7NgPJFaYmRWUjJ91Ph8UxrVcvONacVxYKdmAtmjNskY08zHi1DZfJGr8TI5DQnDo5I9htvZOVCFCImgHCJysaxkisVwOK6dIsvwZH67OM6OeNYE6aHWxRvd9uXwx49iW/Ma+NxWuDXNdV7r03rOqha1fAUnnCK28WMBt1+Dh0FDSW8xnuSBpB3PPYyeF++N9embRWausxe/Nc+VYNgAtnh7m7xWNfbvz0yQtZq0y8BYmPKVVBHrMUCeK6lgxMCV4IlBG6sbseo65w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nC71a5hQqztHJExw/N6/iJ89Quqk9Fb1fM1j2WkDm+w=;
 b=Y3jtXd7RX/ZAhiPfUyTqS4L0Cg4oKBxjeLn3MHEApiw7l1/b6qwJJEctXVlYKpT5yYcn7bep5mPgqmXZrXcNMsiSIsa3mYB4UeZvyiiq8Ou+niueaNbAEdlO+caiUMuyUQUcTmZ3oL714izcE/t4aDHJ4mxv3nZ/nLhFK2HEU58=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by PA4PR04MB9390.eurprd04.prod.outlook.com (2603:10a6:102:2a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 09:56:22 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::1f66:d471:b7c7:d5fa]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::1f66:d471:b7c7:d5fa%4]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 09:56:22 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
 callback returning void
Thread-Topic: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
 callback returning void
Thread-Index: AQHZv5ckURa4X/GUU0ad7ZXQL63KoK/TqmOQ
Date:   Mon, 31 Jul 2023 09:56:22 +0000
Message-ID: <AM0PR04MB6004495B1BC8F72A1EC6EED0E705A@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|PA4PR04MB9390:EE_
x-ms-office365-filtering-correlation-id: f8b20953-869d-490f-d809-08db91ac653c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QDiFVryA4thvCYkEYcW2oCKsvJ55EpmwnA8OYCDeUZUN1qPjK6d4V9zdAj4U2A21j56KMk9s7gpxVIJgqw6G68QoG0nP8Rivx8QeDCrZB1lVMYeRW2A5ovjfFNf8hk7TAzyhFGkRkmiS0Mnm/nDjWTO8X3ye7dnyJT7M1jz8VZ5floQN/Uenu9yjfIz1OkKSke+b69+794E1IxOAZjIGGuJbIVdl1ae4D4QbtHynQ1kJpxvLrxHNDPCanKk5genQTZxMcuIKcsL11YiMKysNnFLmhkpRVghoTfLI45YVbnMyhNZK/ewz6dImUn9yCPBriqS+ZDQFHsk4W6Nf5hufhxrWVWBhbi9s1k9EI6heubYuANkAAy6skp5N9F9mC2ToJD/U+uIBi4xK9z2oBpU/R03GoVvDXsWLxldjM+uNvzWFVXBBMNEYaM1WTVTnAqhBtg9qQCfDRZ33ks7qCyoQDuIpSVk4yaQjmIk+qXsx8Ct9UXZn8sAMxhA9FqIoDqP2+o4cgoKwgQ/tda7aUa5l6NPg1rBrEUn4si891HzH1UlQ81mQt9NIy9m4Chuy+8Xtzfljz/hLHKGrRXkc8kT6Fe9W32bhPISQIyK9tRQICc79aWMeH5CFBb7s9iBSPnLH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(38100700002)(122000001)(55016003)(86362001)(38070700005)(33656002)(9686003)(478600001)(71200400001)(7696005)(53546011)(55236004)(186003)(26005)(8676002)(8936002)(6506007)(44832011)(52536014)(5660300002)(76116006)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(2906002)(54906003)(110136005)(41300700001)(316002)(66574015)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHFSSG5GamRuUlphYU4vN3ovOTJQUm9ad0ZGTk92KzBhYzZPR21GbHJwOXMx?=
 =?utf-8?B?SjRuNXpoMGVnSWFVbGM0K2ZoOURxVnFoaGlJZEZtWEp4K1lOQlFiWGEzMGJh?=
 =?utf-8?B?aVEvVWo4TUpGZ1VBQjB3UjZuZFFlUGRqYXg3Wk00MDVFcExPNmZHSGgwNytS?=
 =?utf-8?B?NFk1eEpINmUrYWw0enJJZHNWcGhwbDBnUVZTbWVzT1VYUFpieDhRWWE3WC9v?=
 =?utf-8?B?U2JBbWtsYXdzRVRONVpINUdnZU0yMStnalgvTXYzVFdhbllmcTQvM2dTNzBT?=
 =?utf-8?B?L3MzUTdqSzhuTjNqMUFXMGMvUmRpdVI5SGpBMlNQNUd3elZZYlMrSk8yQW1p?=
 =?utf-8?B?SnBGUmMremdSWC9YOTBUNStEUUt2NXBRelBHb1YvMVNob0syQmtUTjB5TXps?=
 =?utf-8?B?UWZQSWNJb1NxNXZFWUFPOFZrMmJNMzgyV1FUZGVVODloWFBuby9JT3RSYTFZ?=
 =?utf-8?B?ZndMaHlOUDU0QUZ1WDhreTg5NnZaNmFYUm5NMitBMnd5dTJPc1hlTVhycDEx?=
 =?utf-8?B?bktneko2dHhCbVJ3Zm9nOTQ3a0RmMXlrUjlhMHV5aWo5L2VNTDZWakEwdTJp?=
 =?utf-8?B?SDFlTzVwa244NnVQRStPOERMVk1TLzVpK2xHL0h2dzg5aUh3U0xDRnZlendy?=
 =?utf-8?B?KzhSNXB6dU5FeXBTVFBwaFRmWmtqWFloZTRLK1RQT1h0OHBNd2dlbXV5c0Jj?=
 =?utf-8?B?MWlRTHBKUDFOYkdhNUtmSWYva1U1UTVRM3E2THBEd2FSYW9qZXExSUN2ekxQ?=
 =?utf-8?B?eUJ6NTdMV212elVlSGtjaDJydkY5MEk0bG8zWVh6MXQ0TlZKeEMxbCtDVk1R?=
 =?utf-8?B?Zk9TV1VsM1JwMm03ZmNmcW1pNTBNUUoyaXJENTlwTGdVQkxOWEFNVTQwcTFo?=
 =?utf-8?B?Z05lSVNiSXR4cnlEN3MwS0kxRzQ2UTFjcmJFYWpNUG13dTQ0NTQxUmthWGxo?=
 =?utf-8?B?WnVkRDJSMlgydGkyV1pnUzJHTjB4RnRMa3NnWk9kanRZVmlLYzAwdlMwQjEz?=
 =?utf-8?B?RDBobkRIRGRpZjRoWEZ6cUVqMmtHQVJ6aTJnRGJDbEZCQTY1ZnZ3bGVleEtZ?=
 =?utf-8?B?bzZmUG11VkhMVm9SYkJhTWV6WDVmQ1hEUlAxTk5ndEtGOFFydE5GVXhKVjhm?=
 =?utf-8?B?OWxlWlRqb3ZIaUk1ZE5vbnJ4bGNBT3Z2dXFnMkF5OG5uVVBtby9OVlEvSzdz?=
 =?utf-8?B?ekJENVphNUM0ekhVR0loY1VoMFJEZXJRS2NuU3NjTUNOa1duVUVRRHBwS0Jx?=
 =?utf-8?B?bnNKWXh5SEtObUorZ2ZaRGpCYzg0ZWVNdU1iS0ZtcXNXY0RmOTdIZjNxVFVD?=
 =?utf-8?B?SVE2S1c0MHUzZUdMb1o4dUE5K0pUSEMyNmRkMSt0U2U5ZEdCcm5BMEFnUi81?=
 =?utf-8?B?RE5GZTF2bjRYckpLWVRGZnhlY2RYVVozMWJ2ditraG9xNVZDRFpUbitkZWVE?=
 =?utf-8?B?TEV1QzdjWGp5cHdMelo0bG9waU41UncvQndzWlBSZHY4OS9NWlAxZHdrcFJr?=
 =?utf-8?B?bXVTSEZLR01uSHJjVGNlQ2dEb3MxMk9xalZrTzlIazB6NTJOZUNJendlWDVy?=
 =?utf-8?B?Mlk3NFI3ak5TVEpHK2dlUEZiOFU0MGpkV1VCSlprQmJOeGZCZXBxQndvUFhP?=
 =?utf-8?B?ZDdxWjlkNTk3eXJsRmpIckFlcGp1L0Zmc0tpMldFdXo5b2wvNFlGc2pDVURM?=
 =?utf-8?B?dWZscDIzNEFUTDI1S1pxZDJEWkRBN1I2TDh1SmRWaUFYQisva0wvcnBhanQ3?=
 =?utf-8?B?UGlWTUVVMzVlcXgxZnlvQ1E2Z25YcHhqVXg5SUl4cll0TGVMTmhybDhIaFpp?=
 =?utf-8?B?a2NudnNsNGtBcHpCbVh0VzRoMnFSUTNOZS9QcnBFdm5hZW5kQTlKT0NKY0lw?=
 =?utf-8?B?RzJUTjc3Q3habmpVMnA4WlZ3eS9vL25KanVYdkMzRnR6UEpqZ244bUhNMUR3?=
 =?utf-8?B?Ti8zTS9hcUlTekU1c2xBSWlpQkZZbWU3TWM1bWJudnBlek1hWm5KNjlZVURy?=
 =?utf-8?B?bXREd2sxcEZ5R2MvRnZ1L3Rmd2FFRkp6OU5GS01zczc5ZFNCZnZaNlFucEVw?=
 =?utf-8?B?VGZZc3VQT0RIcW40Q3NaTUFKTEMvbCtEalZpcjVNQUZZYU1SemhLb0lXZFNw?=
 =?utf-8?Q?VJxarNLE/Sz954xtHM2rsSaul?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b20953-869d-490f-d809-08db91ac653c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 09:56:22.1901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CXMKoyKqIDPvn86WGYFg86PitI9MQtieZECIY348aLalMVxkU6/5AcSa7kgbcfAXJM3zhG9sKxVV5OZnqn3fMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9390
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBVd2UgS2xlaW5lLUvD
tm5pZyA8dS5rbGVpbmUta29lbmlnQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiBXZWRuZXNkYXks
IEp1bHkgMjYsIDIwMjMgMTozMCBQTQ0KPiBUbzogSG9yaWEgR2VhbnRhIDxob3JpYS5nZWFudGFA
bnhwLmNvbT47IFBhbmthaiBHdXB0YQ0KPiA8cGFua2FqLmd1cHRhQG54cC5jb20+OyBHYXVyYXYg
SmFpbiA8Z2F1cmF2LmphaW5AbnhwLmNvbT47IEhlcmJlcnQgWHUNCj4gPGhlcmJlcnRAZ29uZG9y
LmFwYW5hLm9yZy5hdT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4g
Q2M6IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGtlcm5lbEBwZW5ndXRyb25peC5kZQ0K
PiBTdWJqZWN0OiBbRVhUXSBbUEFUQ0hdIGNyeXB0bzogY2FhbS9qciAtIENvbnZlcnQgdG8gcGxh
dGZvcm0gcmVtb3ZlIGNhbGxiYWNrDQo+IHJldHVybmluZyB2b2lkDQo+IA0KPiBDYXV0aW9uOiBU
aGlzIGlzIGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdoZW4gY2xpY2tpbmcg
bGlua3Mgb3INCj4gb3BlbmluZyBhdHRhY2htZW50cy4gV2hlbiBpbiBkb3VidCwgcmVwb3J0IHRo
ZSBtZXNzYWdlIHVzaW5nIHRoZSAnUmVwb3J0IHRoaXMNCj4gZW1haWwnIGJ1dHRvbg0KPiANCj4g
DQo+IFRoZSAucmVtb3ZlKCkgY2FsbGJhY2sgZm9yIGEgcGxhdGZvcm0gZHJpdmVyIHJldHVybnMg
YW4gaW50IHdoaWNoIG1ha2VzIG1hbnkNCj4gZHJpdmVyIGF1dGhvcnMgd3JvbmdseSBhc3N1bWUg
aXQncyBwb3NzaWJsZSB0byBkbyBlcnJvciBoYW5kbGluZyBieSByZXR1cm5pbmcgYW4NCj4gZXJy
b3IgY29kZS4gSG93ZXZlciB0aGUgdmFsdWUgcmV0dXJuZWQgaXMgKG1vc3RseSkgaWdub3JlZCBh
bmQgdGhpcyB0eXBpY2FsbHkNCj4gcmVzdWx0cyBpbiByZXNvdXJjZSBsZWFrcy4gVG8gaW1wcm92
ZSBoZXJlIHRoZXJlIGlzIGEgcXVlc3QgdG8gbWFrZSB0aGUgcmVtb3ZlDQo+IGNhbGxiYWNrIHJl
dHVybiB2b2lkLiBJbiB0aGUgZmlyc3Qgc3RlcCBvZiB0aGlzIHF1ZXN0IGFsbCBkcml2ZXJzIGFy
ZSBjb252ZXJ0ZWQNCj4gdG8gLnJlbW92ZV9uZXcoKSB3aGljaCBhbHJlYWR5IHJldHVybnMgdm9p
ZC4NCj4gDQo+IFRoZSBkcml2ZXIgYWRhcHRlZCBoZXJlIHN1ZmZlcnMgZnJvbSB0aGlzIHdyb25n
IGFzc3VtcHRpb24uIFJldHVybmluZyAtRUJVU1kNCj4gaWYgdGhlcmUgYXJlIHN0aWxsIHVzZXJz
IHJlc3VsdHMgaW4gcmVzb3VyY2UgbGVha3MgYW5kIHByb2JhYmx5IGEgY3Jhc2guIEFsc28gZnVy
dGhlcg0KPiBkb3duIHBhc3NpbmcgdGhlIGVycm9yIGNvZGUgb2YgY2FhbV9qcl9zaHV0ZG93bigp
IHRvIHRoZSBjYWxsZXIgb25seSByZXN1bHRzIGluDQo+IGFub3RoZXIgZXJyb3IgbWVzc2FnZSBh
bmQgaGFzIG5vIGZ1cnRoZXIgY29uc2VxdWVuY2VzIGNvbXBhcmVkIHRvIHJldHVybmluZw0KPiB6
ZXJvLg0KPiANCj4gU3RpbGwgY29udmVydCB0aGUgZHJpdmVyIHRvIHJldHVybiBubyB2YWx1ZSBp
biB0aGUgcmVtb3ZlIGNhbGxiYWNrLiBUaGlzIGFsc28gYWxsb3dzDQo+IHRvIGRyb3AgY2FhbV9q
cl9wbGF0Zm9ybV9zaHV0ZG93bigpIGFzIHRoZSBvbmx5IGZ1bmN0aW9uIGNhbGxlZCBieSBpdCBu
b3cgaGFzDQo+IHRoZSBzYW1lIHByb3RvdHlwZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFV3ZSBL
bGVpbmUtS8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+DQo+IC0tLQ0KPiBI
ZWxsbywNCj4gDQo+IG5vdGUgdGhhdCB0aGUgcHJvYmxlbXMgZGVzY3JpYmVkIGFib3ZlIGFuZCBp
biB0aGUgZXh0ZW5kZWQgY29tbWVudCBpc24ndA0KPiBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2gu
IEl0J3MgYXMgb2xkIGFzDQo+IDMxM2VhMjkzZTljNGQxZWFiY2FkZGQyYzA4MDBmMDgzYjAzYzJh
MmUgYXQgbGVhc3QuDQo+IA0KPiBBbHNvIG9ydGhvZ29uYWwgdG8gdGhpcyBwYXRjaCBJIHdvbmRl
ciBhYm91dCB0aGUgdXNlIG9mIGEgc2h1dGRvd24gY2FsbGJhY2suDQo+IFdoYXQgbWFrZXMgdGhp
cyBkcml2ZXIgc3BlY2lhbCB0byByZXF1aXJlIGV4dHJhIGhhbmRsaW5nIGF0IHNodXRkb3duIHRp
bWU/DQo+IA0KPiBCZXN0IHJlZ2FyZHMNCj4gVXdlDQo+IA0KPiAgZHJpdmVycy9jcnlwdG8vY2Fh
bS9qci5jIHwgMjIgKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDkg
aW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vY2FhbS9qci5jIGIvZHJpdmVycy9jcnlwdG8vY2FhbS9qci5jIGluZGV4DQo+IDk2
ZGVhNTMwNGQyMi4uNjZiMWViM2ViNGE0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9j
YWFtL2pyLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2FhbS9qci5jDQo+IEBAIC0xNjIsNyAr
MTYyLDcgQEAgc3RhdGljIGludCBjYWFtX2pyX3NodXRkb3duKHN0cnVjdCBkZXZpY2UgKmRldikN
Cj4gICAgICAgICByZXR1cm4gcmV0Ow0KPiAgfQ0KPiANCj4gLXN0YXRpYyBpbnQgY2FhbV9qcl9y
ZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gK3N0YXRpYyB2b2lkIGNhYW1f
anJfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICB7DQo+ICAgICAgICAg
aW50IHJldDsNCj4gICAgICAgICBzdHJ1Y3QgZGV2aWNlICpqcmRldjsNCj4gQEAgLTE3NSwxMSAr
MTc1LDE0IEBAIHN0YXRpYyBpbnQgY2FhbV9qcl9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZQ0KPiAqcGRldikNCj4gICAgICAgICAgICAgICAgIGNhYW1fcm5nX2V4aXQoanJkZXYtPnBhcmVu
dCk7DQo+IA0KPiAgICAgICAgIC8qDQo+IC0gICAgICAgICogUmV0dXJuIEVCVVNZIGlmIGpvYiBy
aW5nIGFscmVhZHkgYWxsb2NhdGVkLg0KPiArICAgICAgICAqIElmIGEgam9iIHJpbmcgaXMgc3Rp
bGwgYWxsb2NhdGVkIHRoZXJlIGlzIHRyb3VibGUgYWhlYWQuIE9uY2UNCj4gKyAgICAgICAgKiBj
YWFtX2pyX3JlbW92ZSgpIHJldHVybmVkLCBqcnByaXYgd2lsbCBiZSBmcmVlZCBhbmQgdGhlIHJl
Z2lzdGVycw0KPiArICAgICAgICAqIHdpbGwgZ2V0IHVubWFwcGVkLiBTbyBhbnkgdXNlciBvZiBz
dWNoIGEgam9iIHJpbmcgd2lsbCBwcm9iYWJseQ0KPiArICAgICAgICAqIGNyYXNoLg0KPiAgICAg
ICAgICAqLw0KPiAgICAgICAgIGlmIChhdG9taWNfcmVhZCgmanJwcml2LT50Zm1fY291bnQpKSB7
DQo+IC0gICAgICAgICAgICAgICBkZXZfZXJyKGpyZGV2LCAiRGV2aWNlIGlzIGJ1c3lcbiIpOw0K
PiAtICAgICAgICAgICAgICAgcmV0dXJuIC1FQlVTWTsNCj4gKyAgICAgICAgICAgICAgIGRldl93
YXJuKGpyZGV2LCAiRGV2aWNlIGlzIGJ1c3ksIGZhc3RlbiB5b3VyIHNlYXQgYmVsdHMsIGEgY3Jh
c2ggaXMNCj4gYWhlYWQuXG4iKTsNCkNoYW5nZXMgYXJlIG9rLiBDYW4geW91IGltcHJvdmUgdGhl
IGVycm9yIG1lc3NhZ2Ugb3Iga2VlcCBpdCBzYW1lLg0KDQpSZWdhcmRzDQpHYXVyYXYNCj4gKyAg
ICAgICAgICAgICAgIHJldHVybjsNCj4gICAgICAgICB9DQo+IA0KPiAgICAgICAgIC8qIFVucmVn
aXN0ZXIgSlItYmFzZWQgUk5HICYgY3J5cHRvIGFsZ29yaXRobXMgKi8gQEAgLTE5NCwxMyArMTk3
LDYNCj4gQEAgc3RhdGljIGludCBjYWFtX2pyX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpwZGV2KQ0KPiAgICAgICAgIHJldCA9IGNhYW1fanJfc2h1dGRvd24oanJkZXYpOw0KPiAgICAg
ICAgIGlmIChyZXQpDQo+ICAgICAgICAgICAgICAgICBkZXZfZXJyKGpyZGV2LCAiRmFpbGVkIHRv
IHNodXQgZG93biBqb2IgcmluZ1xuIik7DQo+IC0NCj4gLSAgICAgICByZXR1cm4gcmV0Ow0KPiAt
fQ0KPiAtDQo+IC1zdGF0aWMgdm9pZCBjYWFtX2pyX3BsYXRmb3JtX3NodXRkb3duKHN0cnVjdCBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpIC17DQo+IC0gICAgICAgY2FhbV9qcl9yZW1vdmUocGRldik7
DQo+ICB9DQo+IA0KPiAgLyogTWFpbiBwZXItcmluZyBpbnRlcnJ1cHQgaGFuZGxlciAqLw0KPiBA
QCAtNjU3LDggKzY1Myw4IEBAIHN0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIGNhYW1fanJf
ZHJpdmVyID0gew0KPiAgICAgICAgICAgICAgICAgLm9mX21hdGNoX3RhYmxlID0gY2FhbV9qcl9t
YXRjaCwNCj4gICAgICAgICB9LA0KPiAgICAgICAgIC5wcm9iZSAgICAgICA9IGNhYW1fanJfcHJv
YmUsDQo+IC0gICAgICAgLnJlbW92ZSAgICAgID0gY2FhbV9qcl9yZW1vdmUsDQo+IC0gICAgICAg
LnNodXRkb3duICAgID0gY2FhbV9qcl9wbGF0Zm9ybV9zaHV0ZG93biwNCj4gKyAgICAgICAucmVt
b3ZlX25ldyAgPSBjYWFtX2pyX3JlbW92ZSwNCj4gKyAgICAgICAuc2h1dGRvd24gICAgPSBjYWFt
X2pyX3JlbW92ZSwNCj4gIH07DQo+IA0KPiAgc3RhdGljIGludCBfX2luaXQganJfZHJpdmVyX2lu
aXQodm9pZCkNCj4gDQo+IGJhc2UtY29tbWl0OiBkZDEwNTQ2MWFkMTVlYTkzMGQ4OGFlYzFlNGZj
ZmMxZjMxODZkYTQzDQo+IC0tDQo+IDIuMzkuMg0KDQo=
