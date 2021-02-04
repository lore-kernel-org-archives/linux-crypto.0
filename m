Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7CFC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 15:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DECEC64DD4
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 15:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbhBDPvV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 10:51:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36690 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbhBDPub (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 10:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612453829; x=1643989829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=43M1r1wC4GUToSxHMBXaCe3GrFmvqwD58uVQJtyE+1k=;
  b=s+/4gyuK0HR+QK2kQJwgIepj+DtVIExMSZepP2x/bFMQ2etFzNWGmfKy
   VkrytsdDrDQ+IbyviLoIDMWAaJSWyuLUEREuPYMVBeSogSsfE+N+tR6zM
   6WlFLmKgkS4cB+yB5uySbQkXGtJqEIbeNQdE2ckIlrXSRZQVsoI0x6zLE
   B5Au0tgwP84feorjlPY4qQJtYOJKiG8IE/mrwCzRitKONGEl80mmkc+4F
   GPtukJ4svCRyZOL6f+4QtCIcT0uBlDZg80mLdgUX6E/PUPANQBiM76NhE
   0r01ehkY/c/E2UfVEcwaDg9ySA3or44PnkjpelLdcfNUCB1XAJWKuFmHW
   w==;
IronPort-SDR: xdPsgWdcYiAPTIBsM0PTnmbypCmmUl6qJbnc4VGy/84b+jL2Jdbyrtdz3ZnodxL44Pg3vIkQ9L
 T0BxjE/fXHCAd5CamDr6fmeuUxxIr0uGvFfJ7H/pH4KyxXepvur36OIce58krv5Csivmeub856
 g8IK9Z6aRNlNV8vCuAwRts72LW2e9H3OJYoaa64URjcKUeYzWzalAuTa1jzODnYeEO7tRZRNEB
 Aqt6aMN9ZCJOoPLYmYoNLx/oB52ZCs1h7iYhiERsZhutDtvBpSOpn29CB69jpvz4VwWg/6qo2t
 Yiw=
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="108033846"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2021 08:49:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 08:49:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 4 Feb 2021 08:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fktfh+9I/6bwY+lju/QEiwAAr+/EZki60MivsYGMLOoZuUrMy0111d5AtEsgPTyNxMCX9DoJ+62iMxpw+klvokNmzFDJi8O+/Ibx14XkOxLXz9ZP/GG9egR+8FumxC2xTYLTot3F5QIxElBwk0hZEBgxTDP20vQziodzGyrAS5nruQywQYXAp4kpeOT/ixIpqZHq51DsUROzkaAt8inKJ83xIImKqxfLHpfJX+32M0uvbeJcBqA3uRITHpXwqHplIo87R6nuW+eincJ+dZp8nngqD4eIBpztUfgPX1Y64iFdmHemS5lfFPJ3Z4xzzbd95pMEN5Ykb8Vow1JUIgSxnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43M1r1wC4GUToSxHMBXaCe3GrFmvqwD58uVQJtyE+1k=;
 b=DJ8bud9AhXuNs5F9K2eTeFO9NvfWr2JXKmlEjOqT0J9FowIKbbxtBkvpdBhXoJVE40dujYJUKxieb7t/ySMWNdmkLfo7GHgbXyOKey7y1DXpj91v1uv92X6LpQhptir1Tkm8A25zAtRpemh00xANqpPaPcNUwQVwv0QF9HUEIlER7Wz7f3znn+3C8FEXDnBbMeFBV7OIGMcjKcw2yqlDJgP01hDUrkLyV+ybZ1UPxy6upl/xH23U+2p/BYtlAoXBZsMKae0Bu8Rya+1LuI+fUpPzzrc6nBuzSaHOr9DUEB8WAzzN0rwJccpzWEdhUrjYiPtHjBbEkUpdAECO9H3omg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43M1r1wC4GUToSxHMBXaCe3GrFmvqwD58uVQJtyE+1k=;
 b=FXBthuMX0SvXpvnv5XRf8mewLx7ICq+f71GfyIowycm9loEla4vUlG9Yds+MKRzao1SGNryj78KD3vBWsYRhEdGeOkMh0j79n1sDC129UuMK8kcop9LjnDLhwGeF1f6za5OOLJcirIHIm6HOmAsfdnFfO1U58Vj+3RiOpy33pWE=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA2PR11MB5130.namprd11.prod.outlook.com (2603:10b6:806:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Thu, 4 Feb
 2021 15:49:09 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::f4e3:108c:4222:7dab]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::f4e3:108c:4222:7dab%3]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 15:49:09 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <lee.jones@linaro.org>
CC:     <linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 12/20] crypto: atmel-ecc: Struct headers need to start
 with keyword 'struct'
Thread-Topic: [PATCH 12/20] crypto: atmel-ecc: Struct headers need to start
 with keyword 'struct'
Thread-Index: AQHW+w1GQgJHtgOEOE2sSR73UQZ7aQ==
Date:   Thu, 4 Feb 2021 15:49:09 +0000
Message-ID: <3e2c22e4-875c-660e-9ba1-57558a558ce5@microchip.com>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
 <20210204111000.2800436-13-lee.jones@linaro.org>
In-Reply-To: <20210204111000.2800436-13-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e4129d6-1659-489d-576f-08d8c9246933
x-ms-traffictypediagnostic: SA2PR11MB5130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5130A3F361301263A78800D9F0B39@SA2PR11MB5130.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3XYvDzoDsTZkMDw7UsYDmorCNkFdn2KytQbssJ/nOHVnBSbuHSpzzunL0wCwPk15wiNyZb18MXdUYE9L7vWviZ/wJ2C0w8U/yD3eJ2bmmEy0R8eBliEs0kfzAV5ogwW40Zfpnp1lriJiCiHMO0tjbTlBeLpkEHt0qYZ+kLVX4gY7cP59bCO0lOjldmlRQ9ulfXe+xT0BTOXp3yr8ejiIj7QiDYksDfY7m/9KpO9b4QB2aqIAZyQrqapyPyoakf5qHPA+mxEPD69+yLTIFC5So0dCkShHSjykvNZIS2rQBQtIuuNuEk43UnnUtkII9MolBZ/Yp1Wu/qbj2JdlMQSOkFPWmO3P0PxU9+6gZ3UHAaePKoOb8K2fEOC8eoNrlSlzX7q7HAjNVV3HHccPaFGNx1QxaIw7OJ1/3cJBMUak15YUwd3CxIF/fW17KJ4EDAKPiYkojG4Hv7EB1CNbE7IM1ayzB2MXa9Qltw+xc0RwX9f9GTxJ6J35+tzrcW1Lsv5AKwa40hg4GjNlKWwFAWwsLyQRc4eBQTn8CkIuykKaNs/OESNG5LvBq+6aWnMFgSVRw1RSD6e7RdRpxSXEhAmqy41aH+lli8u38x+1kM+gKSU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(136003)(376002)(396003)(5660300002)(6916009)(8936002)(86362001)(91956017)(66476007)(76116006)(66946007)(4326008)(2906002)(8676002)(31686004)(316002)(31696002)(6486002)(2616005)(54906003)(186003)(6506007)(478600001)(26005)(53546011)(71200400001)(66446008)(66556008)(64756008)(36756003)(6512007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RERoOVpLdU1jam4rKzZsNFA2TXR4dmdGNWFIOWQ0QzNPbnRLTzMrWlRZdlY3?=
 =?utf-8?B?ZmlNRzVoSjM2SmNtWnkzRDM2NE9wOS9kNWRLUm0rcGhkZGpRWGlMYmV0VGU2?=
 =?utf-8?B?SnN6NEV5OWRzTlhwdnRuN3haUElwUFAreUFJY3FCcUgrM0pUZ0RFZDJXdElH?=
 =?utf-8?B?L0dKR3VRQU5CWWU0bEJSRU9VV1JmSHVqREhXSTVGTWliWmNaSUNVZzNpVm51?=
 =?utf-8?B?blFPUk4xeXdGY1kraHpMd0JvcjZVYWlHQy94WlBNUjd6blBIaURHMVZ2NFpu?=
 =?utf-8?B?dnd4MVloUGh6WVNWTUxBQ053SUI5UnhXRDdESDlMckVpZkxwaXZhMjloeFVx?=
 =?utf-8?B?WFA3NTRHT3JlaTZlbG1NeG01czN2WHh6dnNuQU9vVFg0Y0FpODFHMHFuUlY5?=
 =?utf-8?B?Zzk5SlZsZkFqVnRlUG1LeGhpRjcrQ253emlJYkdsaWU0Z1RWbkdYUzlTYnhs?=
 =?utf-8?B?bTdqa1VuYkh2ZFgvL3dra25YR1k4WVRnZHY3SFdZMVJBVlRpRlBsMEMzZko0?=
 =?utf-8?B?TFhJZDBESnFFTkhROEhlS0FBUHJZb1Jib2UyOVhIRFVRSzZSemhGMjlOM1F1?=
 =?utf-8?B?QWJOd0JITGRwTTQvZmgyQzAyeGZib1Rmc3hVd2dzWXF6dUkreW05MFlUWmpI?=
 =?utf-8?B?cE9FZmNXVFhRYld0djU5Q1lHVEliL2tPaWV6SHhIMTd2K3hFYnpkNFJRSFdX?=
 =?utf-8?B?d2N6S2ZLV1h1ZjE1RXF5MWJVeFNyb050SnRQZzczVmhyVm5mY01nbXZHN3Bi?=
 =?utf-8?B?WE5NbFlPbFlFRkVTZlVDQjVTRXFpbnVjZGo2OGFDZ1EvUG1jMDlJZlNvUTNl?=
 =?utf-8?B?VmI5NWR1aWNwYUpNbFRqdXRKZnp3VFZqUUlTWUU3RXhveS84TWNWbzZZOGYx?=
 =?utf-8?B?RWN6Mjd0UUFRMlVwWUY5dmF0bHVwQU9pUEZ6V2dBdVNFb2lITVBQcmFoL09C?=
 =?utf-8?B?UUFRbFBKVWw1ZnFxRVJySC8vR0dMT3gwWHA3dy8yMmdMK2xreUxrZC9lWVJL?=
 =?utf-8?B?N3RkQzRBdXo0TlZEeXYvbXdpMkpsM3F0QmJ1KzlDdHdBRE1rdzV0VFBHem5u?=
 =?utf-8?B?YW1FckZGMy90S2RXeU95eGdVeHJHdHErbFlIaFdXSUlIU3FMVEVkaWQ4Sk1X?=
 =?utf-8?B?dTl3blJLNTRGR1JsSm5CdTBVV2JJNGhFUkdZWWZQYklIL1pYRDVLNTY3S0hU?=
 =?utf-8?B?bUhJSXRraVhTbUdtbzF1OGxJLzc0YUpKNGdCN09ZWWFaMDFGd1BGV3BDWHBP?=
 =?utf-8?B?aXNxZHJkRVRDOGFjQTdEZEVmMnpaMkJVWXpIZDdjV2FNSDBzMDU5SzBNbUNO?=
 =?utf-8?B?bFRiSkdVZGNBcXhUUlJlWWJrYW52ZitMczVLOEJ2Y00xSTdJN1JOeTYxbDVQ?=
 =?utf-8?B?dWdoakVuMTNoS2JURktNelNjNVNCVmVheG9jMjlReWtFRE4zYmJlSHY3VUlW?=
 =?utf-8?B?QjJmcjR5VFAxOEl5Ynlud3diSFZvMmNEalpZUlZGQXFwMW13UWNvT3JvY1ZX?=
 =?utf-8?B?c0tiQ295V0h3a2hQUjNqdTU1SGp5K1FSTFkxekhaT1ErNkNpUEYzaSs5V24w?=
 =?utf-8?B?OCt1czN3ZkVjMXFySDIxQmJCSTlFYW1iejgybFZMR0p2bkU5SUNPNUF4S3px?=
 =?utf-8?B?Y1AvVzBTUEQ2U2ZUQjNwK3JVVkR4UHVWUi9TQkNXNWJpMHl6TjNtTmV1MzJl?=
 =?utf-8?B?S0xnR1NpSGxZeXFkY2lKbUdCUk9zTWt4OWNxSjhzYWRiL2ZhNWRWUWRadUUv?=
 =?utf-8?Q?pVJFjgfft93/zymGKY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1F366C657869E44A4351824BD8DF6DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4129d6-1659-489d-576f-08d8c9246933
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 15:49:09.2439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M0Xn5L1VDz9sYPonDuOb1fOyrZDaSDIJeOcZGBQgJzQ+ADDOSfB5nEqX7SYmReXtHYxIRzZPLe9T2vC1/F0HdbbqB11WAJNC548Xj5oPwec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5130
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMi80LzIxIDE6MDkgUE0sIExlZSBKb25lcyB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUg
Y29udGVudCBpcyBzYWZlDQo+IA0KPiBGaXhlcyB0aGUgZm9sbG93aW5nIFc9MSBrZXJuZWwgYnVp
bGQgd2FybmluZyhzKToNCj4gDQo+ICBkcml2ZXJzL2NyeXB0by9hdG1lbC1lY2MuYzo0MTogd2Fy
bmluZzogY2Fubm90IHVuZGVyc3RhbmQgZnVuY3Rpb24gcHJvdG90eXBlOiAnc3RydWN0IGF0bWVs
X2VjZGhfY3R4ICcNCj4gDQo+IENjOiBUdWRvciBBbWJhcnVzIDx0dWRvci5hbWJhcnVzQG1pY3Jv
Y2hpcC5jb20+DQo+IENjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+
DQo+IENjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gQ2M6IE5p
Y29sYXMgRmVycmUgPG5pY29sYXMuZmVycmVAbWljcm9jaGlwLmNvbT4NCj4gQ2M6IEFsZXhhbmRy
ZSBCZWxsb25pIDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbT4NCj4gQ2M6IEx1ZG92aWMg
RGVzcm9jaGVzIDxsdWRvdmljLmRlc3JvY2hlc0BtaWNyb2NoaXAuY29tPg0KPiBDYzogbGludXgt
Y3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZy
YWRlYWQub3JnDQo+IFNpZ25lZC1vZmYtYnk6IExlZSBKb25lcyA8bGVlLmpvbmVzQGxpbmFyby5v
cmc+DQoNClJldmlld2VkLWJ5OiBUdWRvciBBbWJhcnVzIDx0dWRvci5hbWJhcnVzQG1pY3JvY2hp
cC5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9hdG1lbC1lY2MuYyB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWVjYy5jIGIvZHJpdmVycy9jcnlwdG8vYXRt
ZWwtZWNjLmMNCj4gaW5kZXggOWJkOGU1MTY3YmUzNC4uNjZhMzFlNTczOWY0YyAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8v
YXRtZWwtZWNjLmMNCj4gQEAgLTI2LDcgKzI2LDcgQEANCj4gIHN0YXRpYyBzdHJ1Y3QgYXRtZWxf
ZWNjX2RyaXZlcl9kYXRhIGRyaXZlcl9kYXRhOw0KPiANCj4gIC8qKg0KPiAtICogYXRtZWxfZWNk
aF9jdHggLSB0cmFuc2Zvcm1hdGlvbiBjb250ZXh0DQo+ICsgKiBzdHJ1Y3QgYXRtZWxfZWNkaF9j
dHggLSB0cmFuc2Zvcm1hdGlvbiBjb250ZXh0DQo+ICAgKiBAY2xpZW50ICAgICA6IHBvaW50ZXIg
dG8gaTJjIGNsaWVudCBkZXZpY2UNCj4gICAqIEBmYWxsYmFjayAgIDogdXNlZCBmb3IgdW5zdXBw
b3J0ZWQgY3VydmVzIG9yIHdoZW4gdXNlciB3YW50cyB0byB1c2UgaXRzIG93bg0KPiAgICogICAg
ICAgICAgICAgICBwcml2YXRlIGtleS4NCj4gLS0NCj4gMi4yNS4xDQo+IA0KDQo=
