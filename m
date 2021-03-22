Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB419C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 09:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A048561982
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 09:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCVJOG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:14:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:1791 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhCVJN7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Mar 2021 05:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616404439; x=1647940439;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=svq/JQmde+JjPJzanpzNhNhudt2hB0+mftt+l+yBcs8=;
  b=QUEmxEQeBDeGLPLgwitz672iJM9gs6SbWh1TMBILdZSLr7csgHXj2aTa
   2jjCCAqg3drnMn+bpM5LqXjIjhn5YM1hVfjDTUYF4y63JcY2VycNV3u23
   o0+uMgJ8j9kAMnKwwFXJ+eMqrVJdshIml8PszVGiC0MuQmZbTrN8AZ2Xw
   VqAd28O0rbt1vDkLT5t5xzsb/vnEwwt2iGkrKLXdT5m5t5pH3sJOyJ45G
   oDUpQ8VBYRBCexlGLBFR5xNu9Za4ip1Yas0+u5lVT/xuAfAoWcwcnMkp9
   BPd3Cro7YI8+Ukj9lSTgRdA7nY8Fc6t95GLTeBYWEavSGZtC8STzxCTNB
   A==;
IronPort-SDR: vP5lQmPiPCqJM1kUrqpeJ8d100vwSKA9KZuDYCmz2RzmBPn9P4RML99EX7y4ol50BAbi73nXea
 qgjH8noJAcCkh2K5HAvCwb9VlwbIrP0k8tzuAgN2LmizCNKbKqPVxyzQgXSG3eHFss1/78ZQYj
 wq1TtUR7XccQZO5/LIi2oLduesXgI1SGgq1/2fLKcfWPcTw0Bvvj7ndyQQIQdXDOOSjMy2Zuhx
 13HEyzzg3xpDOuu/SLx3PxztNLfM4djUI/nyGHH3a3zjIJV85R/u0PJqP7ICcj8Hpzy1jzo5QP
 IHQ=
X-IronPort-AV: E=Sophos;i="5.81,268,1610434800"; 
   d="scan'208";a="110842999"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2021 02:12:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 22 Mar 2021 02:12:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Mon, 22 Mar 2021 02:12:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tq9+U2twiBmu5EOvSvrreE/ctXoqt2nDX8uHlFMgHcXpIEzkabihdQDRHy6/8tLz7MOVHGC+8o+ias+9p7faeJYVr4VXLK7nHX5WNOahjA/ihNywNOQmzlZAlvKeH0n2qBsYStGxhRlq08ddUPYWoQPaQLnoY6V/pnRMzoIEeCPK43Yi2yvxDKLTdgWxAmKpHA1HQ7zpjIfTXOPSf1z6M/F5hPQtkxAGrwqQ6sxDlFafKJL4YoM0m0oBcuJsDfQYcXp74qWfOqlX+Br6XZOioO9wlX33V9x4H2i6WESSVx8eZpfY/9Uv8W1eD0lsHMy6F/bu2B5aUWL7i0yCaaXPNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svq/JQmde+JjPJzanpzNhNhudt2hB0+mftt+l+yBcs8=;
 b=mB4P67/cKz7awvGBp+j94DCTQ4n3jWBDJbyaAalKrUndcPSrrk/0tWPW7fnIWx5R+liMETZFVcgySE0oYAdbcVYdaNP8iP4J2TN9WQLZg6tHxL5WQT6llADyN42D+NjMMyb6R9E/7WwvT/1QApGQTL0KoYIEt5z9ICgwktQAB2LsYFjazb9KknnH6Prt95GGJtf6FOaFeA9OeGBwQ4TWwtsldU3vny0A7I1wZq0ncfrMOjVpmvgKfENWD12ZRPvz1V6cME9yLG7bG4doozIW0UV9CXkUluADERJzbb052bew6an8+kJHs4SWywwMW6mKOCrFtlICOOu9AhsOjDu1jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svq/JQmde+JjPJzanpzNhNhudt2hB0+mftt+l+yBcs8=;
 b=sK3vrunzxBqW7rI8OJPK5HlA5aeSeIqK8vfglJHRZlFy+Fqr2tDyWvJvRusfXIKXQ6aWcTlopnQfIQycH7LZvP04WbIvKD5ubBuzz5nepaIxT1UjXk3QEVmDPA+DuUjgCnLbuU1GwL7NGPUoeMGTwhnNqP2dhGDzL/9/PbvcRyY=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SN6PR11MB2637.namprd11.prod.outlook.com (2603:10b6:805:54::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 09:12:25 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::49e5:8be7:95d:b6a9]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::49e5:8be7:95d:b6a9%4]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 09:12:25 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <lee.jones@linaro.org>
CC:     <linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/10] crypto: atmel-ecc: Struct headers need to start
 with keyword 'struct'
Thread-Topic: [PATCH 06/10] crypto: atmel-ecc: Struct headers need to start
 with keyword 'struct'
Thread-Index: AQHXHvt43pCrTDwniUm66yrKdR07LA==
Date:   Mon, 22 Mar 2021 09:12:24 +0000
Message-ID: <c26fa256-4c7a-2ab4-3a76-c748b7a38587@microchip.com>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
 <20210318124422.3200180-7-lee.jones@linaro.org>
In-Reply-To: <20210318124422.3200180-7-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab57c823-3072-4664-d99d-08d8ed129bbd
x-ms-traffictypediagnostic: SN6PR11MB2637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2637734565E06D9723D56AA9F0659@SN6PR11MB2637.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tlnL8CKUrBWhwqOnLvu7I1ujAtbeC+5OtZeYuERxmLpxYVO4LUARN9Lhz5AK/pdGBIxaoNkPfl+Q2xhUSSSdEOg/4ZiDSyXOfe/dBLEvt7xvYl3yD9aI78JuwfHpz3CeIXUNaE8URpcWrKdcjokIrRFF2Xv9b2K/ZiMNqDhOTClRCpiwee9YebFnSJQTb9F4vZ8sJxQ+Lo3AdV3HURgCVJW/oHFiakCX/amCBXaSu9HVm5Gumgn6kYLBeZI45gbNjFaYERQbMtl8XOwICYiBXaOAPYLmmH4RfLrUesKsj/vCWm6NryS9zc1VY7lwoWx+g/arnBDsYt6uvXCuxDZnqc7Uq5S9iQ/9wu0ACvMhRFCfyevDer6WOiv2czdmGhE03Y91VdkvlW++qK2c6bfY7/3iH2fXpwhL9hseiNi2IY1aw+sy1eb9v8q4VgKlPgYq6nS1qDiZCCaQ1OA3/eCW78k3q9pnpk8iT2CNlsE2KXXAd5TQx1N8Lkl89U6ZmggEaYH6ZFzwpPQEDR5A+jyW3+4XFZgRGTgr+Q88M+HFNGXP15oN0l0Yt1IV/PGNhKLevYngcK0mRyPRlOvc6OeT6RvL2U4x34L9YdWP+lU9pkfi3IujZlR4ybuXcCzFSwSTKlOrZPViWUmG0q8cGmkLugvGcjxscVS4HUk2JTTpGcBa+PSOqyk5faKKlbhI5MSwS6SXlpUp5ANlT2PaI+ASNyrWqGCw1gwl6riO0rRxTrA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(346002)(39860400002)(36756003)(83380400001)(316002)(54906003)(5660300002)(53546011)(38100700001)(91956017)(31686004)(64756008)(66446008)(6506007)(66946007)(71200400001)(66476007)(66556008)(76116006)(4326008)(86362001)(6486002)(478600001)(2616005)(6916009)(26005)(186003)(6512007)(31696002)(8676002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RHZvRHl2ZTBDTERrcStQZ3RTamE5TXFNNlhmb1NXRXZUSXErLzVDODF2aG5G?=
 =?utf-8?B?S2p0bk1jU0J1cDJxMk1SQ0I5UnU4UXg2YVQ5K1NVNURmcEliOGtBZDRFb2cz?=
 =?utf-8?B?RVN0b0swcGJDMngzbFFIZUtXd0hRaHBMYThlVGlIRkJxMms4SGJxZmhjOWNR?=
 =?utf-8?B?blNoU01xcUwweGw4eWFZcmdGOXMrb2phV0xuWm8xM0praklvRHoxMC9ZRWk2?=
 =?utf-8?B?QlpUbFNDZXpyU2JOSG5hYmxRTXVnYzNaUUNScHBZb0hxZ2Yra1lwUTkwNmtI?=
 =?utf-8?B?MDlocDVIWnp4T1BEellCZU16WTR6bzZHMkJadEtnd2JleU5GcEhHUkhlU3JC?=
 =?utf-8?B?WTBXMnhJNGh2TGhhVXVtcFR6SlVpNzRVWTJFV2Nrb05CdE9vSkZOWmpQMVpX?=
 =?utf-8?B?ZUxSN3NCRmIvV084YVFjdWxtcC9pS1NtblBNNER0aDZBQzl5YU5OVzVSUEFF?=
 =?utf-8?B?Y3hLYjRNOTdjTEV0S25VOFpLZVFLNm5UNnI3dEpIQnZwRXo4L0RwcXJUbGR6?=
 =?utf-8?B?VUh2cWM3Z1Q5S1RLaXY3WFVZVXdmMzVSY2VUbjluMTZFQTNDVFRRbU53dUNQ?=
 =?utf-8?B?aUNQbmNBdWJRZlM4Q2d2YmVqdGtVREF0RjNrZEsycVQxMFplQkZYbW5hYmdr?=
 =?utf-8?B?U1ZTT1czTTZ0YmxnSmt0RkRldGpYUG5BNUVxK2NhSEVvbTVjcWFtbUdMa1ZF?=
 =?utf-8?B?SnI0K09YN0hNb2ltQXNLM09oK2E3YzNoOFpBM2J1cFlESklEMXRzcE1TZTFH?=
 =?utf-8?B?L0cvTFZlTDhlZ3NFaGk1MG1wMDRnLzlZQ3E2TzFkR0ZhbWtjaEFUTVlXY3dZ?=
 =?utf-8?B?bXJtYUdiNEhpL0VXSHVjWXo2RTJNdFJpdHhpcGtQY29lOUdrV0llbGgxa3M4?=
 =?utf-8?B?YXE3dEpqeXRKQTN5TXZLZi9NQmZMaXF6WjRjVGNaUHZ1ak0yMklVUjNBZHFF?=
 =?utf-8?B?bU9qaWUyMHFTdVN4YlFBbVk1T0h0ckp4c2Yydk5rajBvQUdhaDlQeTluUE1x?=
 =?utf-8?B?SDY1K0lONEV5bWlaV01MWmtjS2YzbkRNandPZ3c4Wkt2Yi9MVU50WlAvanBH?=
 =?utf-8?B?OUNhWTVVY3pwdG9FV2tBUjB5KytOZnhaeDRIY0M3d3puUXNqOHoyU3VleTdF?=
 =?utf-8?B?dkxWNlloWUdGdFVsdWNxL1V0UG5Ca3hYODg4STA5WHJpUXBrekxsN2xyejha?=
 =?utf-8?B?MWRlSnAxSU9YK3BWdHFRMEhwK0hkSXZ6djBKbE5MRjVyWkdyQUplZWpRSnVG?=
 =?utf-8?B?L2V2WTZSNDVIZy82bE1BUUE4ZkVUbnNqVlNBYUZ5YmhVQ2VKbERxVVZlekZi?=
 =?utf-8?B?THh6SGZ5Sml5d3hzM1NEbW9nVjEwSW9CbXBqMDFabFRrTkM0RitqbHArTzJt?=
 =?utf-8?B?dEZOYlVkamZUQlhUNFlSQzg1R3MvS3hkYmlUbDN1aEJha1Z5TGYxcS9KK1hx?=
 =?utf-8?B?NDBZMVl1QWF2NE5uaHQrRmp2R0N5WDJ2VXhESTJ2MXdnYXpWT0w1Vm5VQjk0?=
 =?utf-8?B?Q0lEQ3Jvcy9NSmJtZ0tEeUZpcVJXRlA2ejVQYVpQVE9mbzlqUGljMjRmZ3Yr?=
 =?utf-8?B?OHErVFBadm11aFdtQ2xnekt3YXY1SWRrVUJEelp0MzZIc2hDd2lvb2hRaEtR?=
 =?utf-8?B?c25odmpHTXFrU2tBNmtLRVlJVDBIVmZQT0NyVE51VGU3ckNCbnZUWlA2aWhK?=
 =?utf-8?B?R2NJSWF3eDBNK21QNmt3SzhLWUhpbmplMEZ1TTcxamhtYWQyQzg1bUZUSThM?=
 =?utf-8?Q?h64vemgSQcyQ65g0G8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3239F68E0DD1241ADA9F1F02E4CAF06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab57c823-3072-4664-d99d-08d8ed129bbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 09:12:24.9526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lh3geaFv8a7EjXRQCKfxCqIa+oY5LR6z3hsLqovp6Svd6gVCfSVZ2NJEpxUW8Xnw/fc3Faremcjj6keRQvihAI6cszv5YKwcoCPlaEalayY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2637
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMy8xOC8yMSAyOjQ0IFBNLCBMZWUgSm9uZXMgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhl
IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRml4ZXMgdGhlIGZvbGxvd2luZyBXPTEga2VybmVsIGJ1
aWxkIHdhcm5pbmcocyk6DQo+IA0KPiAgZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmM6NDE6IHdh
cm5pbmc6IGNhbm5vdCB1bmRlcnN0YW5kIGZ1bmN0aW9uIHByb3RvdHlwZTogJ3N0cnVjdCBhdG1l
bF9lY2RoX2N0eCAnDQo+IA0KPiBDYzogVHVkb3IgQW1iYXJ1cyA8dHVkb3IuYW1iYXJ1c0BtaWNy
b2NoaXAuY29tPg0KPiBDYzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
Pg0KPiBDYzogIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENjOiBO
aWNvbGFzIEZlcnJlIDxuaWNvbGFzLmZlcnJlQG1pY3JvY2hpcC5jb20+DQo+IENjOiBBbGV4YW5k
cmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+DQo+IENjOiBMdWRvdmlj
IERlc3JvY2hlcyA8bHVkb3ZpYy5kZXNyb2NoZXNAbWljcm9jaGlwLmNvbT4NCj4gQ2M6IGxpbnV4
LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5m
cmFkZWFkLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBMZWUgSm9uZXMgPGxlZS5qb25lc0BsaW5hcm8u
b3JnPg0KUmV2aWV3ZWQtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbWljcm9jaGlw
LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9hdG1lbC1lY2MuYyB8IDIgKy0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWVjYy5jIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwt
ZWNjLmMNCj4gaW5kZXggNTE1OTQ2Yzk5Mzk0ZS4uMzMzZmJlZmJiY2NiZCAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vYXRt
ZWwtZWNjLmMNCj4gQEAgLTI2LDcgKzI2LDcgQEANCj4gIHN0YXRpYyBzdHJ1Y3QgYXRtZWxfZWNj
X2RyaXZlcl9kYXRhIGRyaXZlcl9kYXRhOw0KPiANCj4gIC8qKg0KPiAtICogYXRtZWxfZWNkaF9j
dHggLSB0cmFuc2Zvcm1hdGlvbiBjb250ZXh0DQo+ICsgKiBzdHJ1Y3QgYXRtZWxfZWNkaF9jdHgg
LSB0cmFuc2Zvcm1hdGlvbiBjb250ZXh0DQo+ICAgKiBAY2xpZW50ICAgICA6IHBvaW50ZXIgdG8g
aTJjIGNsaWVudCBkZXZpY2UNCj4gICAqIEBmYWxsYmFjayAgIDogdXNlZCBmb3IgdW5zdXBwb3J0
ZWQgY3VydmVzIG9yIHdoZW4gdXNlciB3YW50cyB0byB1c2UgaXRzIG93bg0KPiAgICogICAgICAg
ICAgICAgICBwcml2YXRlIGtleS4NCj4gLS0NCj4gMi4yNy4wDQo+IA0KDQo=
