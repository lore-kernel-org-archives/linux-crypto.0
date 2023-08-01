Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635F8EB64DD
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Aug 2023 05:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjHAFBG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Aug 2023 01:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjHAFBF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2023 01:01:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2040.outbound.protection.outlook.com [40.107.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEE31FC0
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2023 22:01:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4NJWZ8jww6K3yu1xzQYwH8NLxvGf2FVOVIcsEOASh3HOfjbj78PFW9Ihz/ZrwTw0GawWOTwKCddRUMmGy2CYFmARC++xHGrqLu8b20zAAXi4MQKlI2n1hyO9Al9bvyFm2507QLwrpC+nyNrE+FXgGxMto0snTOg/Z3JFfQXXO8sJcrNdjYTiWdEigEzzJECRNAgNcEDqSa6JbLdQxd6Gt3jjumZAAOA5iUhExqB4ojR25P1laqRErqpHDSUt1hDzBc7J/1V2N9Brfq7USd8DO0zZUpkP4T0XzTk+IdGaiRGDQk9o5F4IEVQ6lZneIjPmes77btub7kTiykUpPOmuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4pks9PErO1THSJif9EaepEoew+7+0yDgH4GwPGfY6E=;
 b=n0NXSzE51UOfAWJN/s1aOLeTsXnMvFRmXhxbIORXD0ntOzT7/9jDqT+/ApnpkpKWl8GmTNh9hLK8gG7nhiq1GexNf0mJ0czhmE29QDtyrClAgVwODiOrj2z0aoAJVSTISaCT9pq2awl0wgLbLBtn+afPAknt6gZqdA6ayWr81udzO0LArOc5w/fzk83ceNnOMqqzQ++OkqT9nvy1PaYU62q2+3e525XexvlNdd3WMVX73gHqvoirDgCsIhnRfqn8qh5NMNzJz2IByWRPz51izRmc0vIirq7kthlLgC/gCqEehjmiyYno/JXe1RrR+4oHgELto9EZeYxdL7H70sct6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4pks9PErO1THSJif9EaepEoew+7+0yDgH4GwPGfY6E=;
 b=jVp6l6xVzvPN6zePbo52PBUBLTbkEo5fhQywmRcYwKo4bk0cN2jgpcyRIvPUjVKSHqb874586qJwIYPW4SZ6UAIh6RwOEQAZ06k6B50FS2EqMzTkj+RBYtzday8BF6qP82G1Jl5MZhYQw+3iWebE8fSwQRKhrbyWyWxd0FIG7Bs=
Received: from VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15)
 by PAXPR04MB9106.eurprd04.prod.outlook.com (2603:10a6:102:227::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Tue, 1 Aug
 2023 05:01:01 +0000
Received: from VI1PR04MB6013.eurprd04.prod.outlook.com
 ([fe80::4cb3:bbe0:20f9:3bc9]) by VI1PR04MB6013.eurprd04.prod.outlook.com
 ([fe80::4cb3:bbe0:20f9:3bc9%4]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 05:01:01 +0000
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
Thread-Index: AQHZv5ckURa4X/GUU0ad7ZXQL63KoK/U6quQ
Date:   Tue, 1 Aug 2023 05:01:01 +0000
Message-ID: <VI1PR04MB601384609ABB421E1BAB915BE70AA@VI1PR04MB6013.eurprd04.prod.outlook.com>
References: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB6013:EE_|PAXPR04MB9106:EE_
x-ms-office365-filtering-correlation-id: a74e6728-8367-47d6-8464-08db924c4d41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xwfhA2IgY4kvD2cyxzpQIXwstUaguQT7Npt9hRgSNbiuJxHk8uqHuvaJYECswQcMfBMU4WMvG/kNmemVKuV6jdXH58v3j1S5sLp0kK3fZX4dXQ/HIIY6wpp6/UYd3gppYOxKYSnwE0ZLCkJFAKKwhMNqZaw5doBLhcHw1lkpfE2KrBK+y/qbnDrNoAXkqIckAgpY2AZRhe4Fw/hygweaOyRETdi15sNIsIwPBGHi9rMUT/PNLKTttWPlhUMJQfka0kaLQLVSkJFQRSLVT8MQYW95bPuGOTaKjC7DQAO0XfnEXgJWPke2pfwLDwE9NX5LL6jYTYIPuJfo3CRRvbQ7cbA+KC0Y9YfhSJTAXvXVHLerWNJUbk3+miUnVPetBJCGbtkwDwFuVUAtjS6OKSi0NrMJf9E3QxfpY93xPSFfFpA6PuvAPbq7QzyfxFTnV/kr8WmS9myQgYADhcrNdV5/+4UQTXFKyWw12j5J3m0mKf1oW/D5Qc8gzkGoVp8cV9DLAvtUXTesKdt+x7AqybVdH2YF5Jcz+u22AKQM9l9ApeMW2qImDact9TSnkItR2cZVD42aVsPLTM17ObzmIaBzoPBqOdHzboaMR4mik0jOzSw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6013.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199021)(966005)(9686003)(71200400001)(5660300002)(55016003)(52536014)(186003)(44832011)(33656002)(66946007)(76116006)(66446008)(66476007)(66556008)(4326008)(64756008)(478600001)(54906003)(110136005)(7696005)(316002)(38070700005)(41300700001)(8936002)(8676002)(122000001)(26005)(38100700002)(86362001)(53546011)(66574015)(2906002)(83380400001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0RjQ29hazFCYXp3RVlkblhwNkxjVWxyOVg0dDBRTlNhc2xQYWhObHZ6Zk5E?=
 =?utf-8?B?Unh5eFZmM09oQSsvSUxKQzBrc2kraUM0RTA5WWxOU3JFMlc1Tk5VbzNQT0dY?=
 =?utf-8?B?NDlpRnFUMmJkL2dsQjNXVmNHZFVIRjg5alQvSWtBV2lXQ3dkU0VhZ1JzMkRT?=
 =?utf-8?B?NlVKRnNQbU4wMitMdDYwc3lLbnpUWExMKzk4aDNaMW1mcjljTTZjUmhhNDV1?=
 =?utf-8?B?UW1YTFJTQzVCN1A3L0ZZQjh4blVpRkhwc1dWRGphcUI4OE8xN09Rd3o1Z0ow?=
 =?utf-8?B?OGs2Wlkyc0FHZktweTdDVXZxOTBSVEJicFBTaHgrQ3lnREpSbms5SGNmWjVq?=
 =?utf-8?B?cVpnZDZSZTN3Qjh3YXlzc1lZaDRyWktTcDBJUWdWUzRPYitoRmlVTFpMWk1a?=
 =?utf-8?B?UndMN3JYK1d0WDdNN1VpT0s1NzJoajY1NXlqSFdvL3JORld1SW91YmFLRStr?=
 =?utf-8?B?cE9oNjc1NU1MMHlJRkZLdzVOTWtWVjlJV0JvTU9jZkw1OGpGZlMvNFhXa25R?=
 =?utf-8?B?NmtmM3Vob3VRWDFHM0NCRjU2eGFZSy9xOEhKcy8rTmIyVUN6WU11c2RHOXBB?=
 =?utf-8?B?M3A2TzlYN2k3MC94WU05TG9IMm1uZEQrUmZuNm9pVk91bjcyZXVqY2pZa2ZO?=
 =?utf-8?B?bUJSTkd4ZzdCUWpPR1JzYWJINWgwSnJ4R1psS1QzcFFpTVpRK095dXhmS0hm?=
 =?utf-8?B?M29ZK1FVVTNoaW5EYTRVQ0UzZnBXQUZyWDZVa1R0eCsxb291QlZJRXc1M1JO?=
 =?utf-8?B?cENPUUFsaThuQVRDMEJwY1FmSHJla3JFN0JRN2pQRnI0SHdZUFNVNXFKck00?=
 =?utf-8?B?eU1Gb0hlYlRNSExnZ0RTS3Q0RHlxWDNZamt4NlJqbXBlaVoyTHlTNUNITDJH?=
 =?utf-8?B?Z1J3WDZjMFhHOHR5U0Q3MTF0MHNsNWFReDVMbUdHdDJUSEd3eHduQ0NlMGJa?=
 =?utf-8?B?eTUwMUZwdm5VREIxd2t1dGR6azJ6NTNZTmw4OTdZUFVidDl3elhmUld0ejBz?=
 =?utf-8?B?T2FmVmNLc0hsRTRkVFZTdEs2T2s3aldmcDdCRXZtR1VpUzVKQ1FvNmFxVmdZ?=
 =?utf-8?B?dllIcGhXZXlaWDRaUUJ1aWpJdDBnTG92aXBMWG5BcWVrbnN1OCtDZUtOS1lX?=
 =?utf-8?B?dHB0RU41ZTlNT2pqWFVQdUpnaHo4eEtWREw4QU11UkxMUzdYRW1pZ1dPc0hP?=
 =?utf-8?B?VThBQko4b1pPeUpsTUE3UWZ1MXRXeHk3b3M0Q1gwUnVlQnM3eWcvY2MwMEtQ?=
 =?utf-8?B?Rk5hNm9DUW1uT3NzYUk2OGEvNy9kdXo5Ym5iVTVzUVhjdGZJYTFVazl4NHNU?=
 =?utf-8?B?MnFrZEpTdTZySUphRG0yQjYvMXM4U1JmZ3ZRYjQzSExlOUFGVUhUd1BCRUJu?=
 =?utf-8?B?bFg3K21iRUd6THJDUitGWTF2VnlEaHBuaWFEd3ByVzNyc1N5bEtQOXUvNFo1?=
 =?utf-8?B?cU1Ba0VBbS9aQTMxMnVURk8wSmF0cjZsOUJsY2orNXkyU0lyalY3czhOY1VP?=
 =?utf-8?B?UWdzdFpsdjVqQ1Evb1V0Y01wZnRrQmN1OExadXJDVXN4bndiLzBkSHFNWU00?=
 =?utf-8?B?K2RqdXMyMEk2MzVvQUV4dWVoQ1BhZnNnejREcmloeW9TV2xabnd4TUlIN2s5?=
 =?utf-8?B?SnZrc3NXWTdVeTN2MG1WZTVHeHg4WnFMMWhoVDBac0ErTXhkQkJ2d3o1SU1w?=
 =?utf-8?B?QW9kZmN1akRKeUdOZ3JpTlFNdG00M0xEdFJyeVB5Nzl1eG5uMldpeExyNzNm?=
 =?utf-8?B?cDZadUM3UmJ2MlBBcjNWajFIcS8reGoyOXprYWJLeDUwWWtXOW9tQ1crQk1P?=
 =?utf-8?B?YU95ZkRka0hyWEVHUjMyY3ZrL1NVdzFiK0xKOUIyUTI5czNnM1N1MDVha2tw?=
 =?utf-8?B?eEcxK3NYUG1ZNXpoNDVEVnpZRHZvOFZIY3YzSGl1TTUzdCtqaTM2MjJ4V1N4?=
 =?utf-8?B?VEo4VkxGLzdsbWNBKzlYWXNZeVBOSTczWExjT2ZmL296WUFNTUlMLzNrSWZ6?=
 =?utf-8?B?ZmRTcjF4Z2pIM0RQMWlHTGZSOTIwWHc1eUpERnByT3QyZDNETFozU09nSWcr?=
 =?utf-8?B?bllqK0lMYmpyeHpzT0ZjdzNrMmV3NTkvVjd0UnF3ZVl3M3RHbjg5VU16ajQz?=
 =?utf-8?Q?FtQk37fzPVW3J6Y/pP3uaWqen?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6013.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a74e6728-8367-47d6-8464-08db924c4d41
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 05:01:01.3908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mCur2LThnrpuvr73g7ciEUccjYSiKMSCYVgvrlKgIHx8sDavoL+6Cb8Pd7mOuTZLXqjydvgNLQA0rkKl6erNgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9106
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
bWU/DQpUaGlzIGlzIGludHJvZHVjZWQgZm9yIGtleGVjIGJvb3QuDQpTZWUgdGhpcyBodHRwczov
L3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtY3J5cHRvL3BhdGNoLzIwMjMwMzE2
MDYwNzM0LjgxODU0OS0xLW1lZW5ha3NoaS5hZ2dhcndhbEBueHAuY29tLw0KDQpSZWdhcmRzDQpH
YXVyYXYgSmFpbg0KPiANCj4gQmVzdCByZWdhcmRzDQo+IFV3ZQ0KPiANCj4gIGRyaXZlcnMvY3J5
cHRvL2NhYW0vanIuYyB8IDIyICsrKysrKysrKy0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvY3J5cHRvL2NhYW0vanIuYyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vanIuYyBpbmRl
eA0KPiA5NmRlYTUzMDRkMjIuLjY2YjFlYjNlYjRhNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9j
cnlwdG8vY2FhbS9qci5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vanIuYw0KPiBAQCAt
MTYyLDcgKzE2Miw3IEBAIHN0YXRpYyBpbnQgY2FhbV9qcl9zaHV0ZG93bihzdHJ1Y3QgZGV2aWNl
ICpkZXYpDQo+ICAgICAgICAgcmV0dXJuIHJldDsNCj4gIH0NCj4gDQo+IC1zdGF0aWMgaW50IGNh
YW1fanJfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICtzdGF0aWMgdm9p
ZCBjYWFtX2pyX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgew0KPiAg
ICAgICAgIGludCByZXQ7DQo+ICAgICAgICAgc3RydWN0IGRldmljZSAqanJkZXY7DQo+IEBAIC0x
NzUsMTEgKzE3NSwxNCBAQCBzdGF0aWMgaW50IGNhYW1fanJfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UNCj4gKnBkZXYpDQo+ICAgICAgICAgICAgICAgICBjYWFtX3JuZ19leGl0KGpyZGV2
LT5wYXJlbnQpOw0KPiANCj4gICAgICAgICAvKg0KPiAtICAgICAgICAqIFJldHVybiBFQlVTWSBp
ZiBqb2IgcmluZyBhbHJlYWR5IGFsbG9jYXRlZC4NCj4gKyAgICAgICAgKiBJZiBhIGpvYiByaW5n
IGlzIHN0aWxsIGFsbG9jYXRlZCB0aGVyZSBpcyB0cm91YmxlIGFoZWFkLiBPbmNlDQo+ICsgICAg
ICAgICogY2FhbV9qcl9yZW1vdmUoKSByZXR1cm5lZCwganJwcml2IHdpbGwgYmUgZnJlZWQgYW5k
IHRoZSByZWdpc3RlcnMNCj4gKyAgICAgICAgKiB3aWxsIGdldCB1bm1hcHBlZC4gU28gYW55IHVz
ZXIgb2Ygc3VjaCBhIGpvYiByaW5nIHdpbGwgcHJvYmFibHkNCj4gKyAgICAgICAgKiBjcmFzaC4N
Cj4gICAgICAgICAgKi8NCj4gICAgICAgICBpZiAoYXRvbWljX3JlYWQoJmpycHJpdi0+dGZtX2Nv
dW50KSkgew0KPiAtICAgICAgICAgICAgICAgZGV2X2VycihqcmRldiwgIkRldmljZSBpcyBidXN5
XG4iKTsNCj4gLSAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ICsgICAgICAgICAgICAg
ICBkZXZfd2FybihqcmRldiwgIkRldmljZSBpcyBidXN5LCBmYXN0ZW4geW91ciBzZWF0IGJlbHRz
LCBhIGNyYXNoIGlzDQo+IGFoZWFkLlxuIik7DQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+
ICAgICAgICAgfQ0KPiANCj4gICAgICAgICAvKiBVbnJlZ2lzdGVyIEpSLWJhc2VkIFJORyAmIGNy
eXB0byBhbGdvcml0aG1zICovIEBAIC0xOTQsMTMgKzE5Nyw2DQo+IEBAIHN0YXRpYyBpbnQgY2Fh
bV9qcl9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICAgICAgICByZXQg
PSBjYWFtX2pyX3NodXRkb3duKGpyZGV2KTsNCj4gICAgICAgICBpZiAocmV0KQ0KPiAgICAgICAg
ICAgICAgICAgZGV2X2VycihqcmRldiwgIkZhaWxlZCB0byBzaHV0IGRvd24gam9iIHJpbmdcbiIp
Ow0KPiAtDQo+IC0gICAgICAgcmV0dXJuIHJldDsNCj4gLX0NCj4gLQ0KPiAtc3RhdGljIHZvaWQg
Y2FhbV9qcl9wbGF0Zm9ybV9zaHV0ZG93bihzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KSAt
ew0KPiAtICAgICAgIGNhYW1fanJfcmVtb3ZlKHBkZXYpOw0KPiAgfQ0KPiANCj4gIC8qIE1haW4g
cGVyLXJpbmcgaW50ZXJydXB0IGhhbmRsZXIgKi8NCj4gQEAgLTY1Nyw4ICs2NTMsOCBAQCBzdGF0
aWMgc3RydWN0IHBsYXRmb3JtX2RyaXZlciBjYWFtX2pyX2RyaXZlciA9IHsNCj4gICAgICAgICAg
ICAgICAgIC5vZl9tYXRjaF90YWJsZSA9IGNhYW1fanJfbWF0Y2gsDQo+ICAgICAgICAgfSwNCj4g
ICAgICAgICAucHJvYmUgICAgICAgPSBjYWFtX2pyX3Byb2JlLA0KPiAtICAgICAgIC5yZW1vdmUg
ICAgICA9IGNhYW1fanJfcmVtb3ZlLA0KPiAtICAgICAgIC5zaHV0ZG93biAgICA9IGNhYW1fanJf
cGxhdGZvcm1fc2h1dGRvd24sDQo+ICsgICAgICAgLnJlbW92ZV9uZXcgID0gY2FhbV9qcl9yZW1v
dmUsDQo+ICsgICAgICAgLnNodXRkb3duICAgID0gY2FhbV9qcl9yZW1vdmUsDQo+ICB9Ow0KPiAN
Cj4gIHN0YXRpYyBpbnQgX19pbml0IGpyX2RyaXZlcl9pbml0KHZvaWQpDQo+IA0KPiBiYXNlLWNv
bW1pdDogZGQxMDU0NjFhZDE1ZWE5MzBkODhhZWMxZTRmY2ZjMWYzMTg2ZGE0Mw0KPiAtLQ0KPiAy
LjM5LjINCg0K
