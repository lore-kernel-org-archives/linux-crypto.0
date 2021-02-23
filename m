Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59EFC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 10:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A108264E32
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 10:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBWKq2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 05:46:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:44712 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhBWKqO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 05:46:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614077175; x=1645613175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I9HwyLMkEWwaRi2vBqXZU2oO8w8pj6GFBlmNR7FlkZo=;
  b=OUEISNrGc/zoVDNTDgwpyAbOto6zudTWnrMloQNfapJJcjmzeAacPwOM
   vgv8hyYBuE7HUDlueEU6xpfMVJ0ncp7SNQoIGNytiYJDV0hyRKalzUP1D
   vAhd9fbQ2tmLF7tUWD3vm8njE8sZBuo+Ef+MLFt4L0lb9/Jr4gZY0suMe
   1+tNzckiPCqKC8GE/a21q9o/jMoZ8hWZ2HqCaH5BFfRYrdm70EINI7cuJ
   odXEGvBtvSIR+LwTB4Ai4xTePcZ2umlwOEnUX6kkpB97ga4yRFKKXE4nd
   117g1Y/rxxn5PSL7bWJ0429T1jw941HHaV5l0Geg/Vuwp/9wgUlmhtFok
   g==;
IronPort-SDR: joSmWKccX7Qc3l70MePCgqKBH27gsjmZf4mXvExJEOkETh8GLK5kscTZrSqXRbKC6Esoz9HugG
 8V59XxStW9CmxsKVPwh8jU1IC6qMqatVPSYDnpLe854zNv78w17WyuPWK24PLM5k5W4fhRGvD+
 LItW+LrqJYWUDSfgzvH5dNQhu/EmituHZYfl2XGPjzZSSxOgtkTp1HczFJ3PabbG599RHhQKYX
 1VRcRqE0ZymrUL096Cxc9Ry2GmuKTkA7YgPcZQ0vvB/CZ/+tcjkLXu9x1/lxxCrkUcvCAvHp1A
 3bw=
X-IronPort-AV: E=Sophos;i="5.81,199,1610434800"; 
   d="scan'208";a="110287577"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Feb 2021 03:44:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 03:44:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 23 Feb 2021 03:44:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3wWPag+KKxF6ukO9Ru3fuNpiKZIjIbbO9HqWRWiRXB3mspSgWvriZOH+OS4v7jGZ5IvunaRNaEvL/VVPIph/Bp1ya865Bojq9B9GeAXZoiuzQGxh6tGkVbVR4QoQynrLyjG9pWq12yrbAd8iFIHa+U8GS/Hhl25R8VVQs7lPwGOLfgw+YFWHjuP/3aJRCq35hinaFtchrogPkgf5aPIMucFESR19H6L49TlTDFhl7wMapiDJJBeqR8AD+CrTFWISNB/lD50g66YASmsK/y7QVJ6V6Esjcquuks03X3J8F8bxzy20P96HVg5vSrcJ4hHrDHcFrXNfOhDLjV2GCcB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9HwyLMkEWwaRi2vBqXZU2oO8w8pj6GFBlmNR7FlkZo=;
 b=Vl3SQO3lQ9xL0ITWvtqaoibB3hv0eOYJXEST9Bm9mrmFep7o7NJlrhEfnp9rxHeLcPZMgvzYjSEUFQQTs96S98QlXfhq0RXaU8BMJYJBsYIJRUeOznbVxzodtue4xqDcIKvGr9ZJdTjT0doBf4LtY2jotCMmajMuctlVABkupmgciWNtAGWWRBoWHJXQWShiuXrDGUIWRBEakR12JAzOsyJK95gPsRx5jlmI3AjmYNUmE9R54Or70AUqiqcz2YXYlUZcfce0xHnajnwwSQhw+P5dXrijeAtonZHe1yWqcDD3bsFi0Oxi2j51ohmGKAC9TU9iPLZZj+jvkkTWFUHwGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9HwyLMkEWwaRi2vBqXZU2oO8w8pj6GFBlmNR7FlkZo=;
 b=PrtlJHrE8B5NOf7wiEXA4lilhFZmL32C2yaJkMV6RO7UvZnE5US8e5IHLmydOx/nH1NSkmnEBWOB3ilnHCbaBkKwqIR2C4Ygz1+PNDtzs678kRc8YGcDl/jhhlKcaipUdn2jRLZeltls/oBynO3oI6i2PJk925tE6Oe93Qpwoeg=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA2PR11MB5097.namprd11.prod.outlook.com (2603:10b6:806:11a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 10:44:52 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::c9e8:9bf4:b08c:c30f]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::c9e8:9bf4:b08c:c30f%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 10:44:52 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <yumeng18@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <marcel@holtmann.org>,
        <johan.hedberg@gmail.com>, <luiz.dentz@gmail.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>
Subject: Re: [PATCH v9 3/7] crypto: move curve_id of ECDH from the key to
 algorithm name
Thread-Topic: [PATCH v9 3/7] crypto: move curve_id of ECDH from the key to
 algorithm name
Thread-Index: AQHXCdDqrdFLjfxmJUqW/hbDlDjsVg==
Date:   Tue, 23 Feb 2021 10:44:52 +0000
Message-ID: <8b96c136-dca9-5b6a-2221-e906d265c40b@microchip.com>
References: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
 <1614064219-40701-4-git-send-email-yumeng18@huawei.com>
In-Reply-To: <1614064219-40701-4-git-send-email-yumeng18@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acb3c32b-208c-4fa3-3a12-08d8d7e80d40
x-ms-traffictypediagnostic: SA2PR11MB5097:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5097E7F98C05B36DC389044FF0809@SA2PR11MB5097.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2WOITHK3641GQbKEw5yK3fazIfOgIZqTOR4k3Coz7ewzVvKz5yfqVLB2tOqjxyg0hTNxCXIal7QloQwGAIQ/9ojiBargAAcDPHqTUrS2X/2QSRScWsktyML6M7/xsZcoklKDEZX89l2Km5OtAEVUmCuF48sN65FG3Z+diKbJdK0AO78QmMELnckPpyA4ozfiKd0tqtKZNi/qvDz/C4SriYaxoYB6jiAT7SW7Ki/EuJ6q4TLCAvhiOTQ8hO8zeqDyhmB0AfdQUW9ThwseI5w38r4gN7hWjdQChn+aqDwM5HGo+pTZBYjrYobsavzLO78T1OUMevFHZoheFBCQo4kyeWGElm2orR9wdL6FBR9ADsRE2NjbUvJdO3MP9dZfh32flMKAx/yDxuz73WSThyQdITuCHItK1xqa8oxGFyuOatk6ZYxUnkJy9ih9qu/4a+xVFqzxHjkaTT/MDLfIrkU+6s1vChb0CAaGVD4UsL8jkFYFNnHKkfPQjLxPagnjCEtjjgZ/zYDiezr21vSzS4ke8wlWzGkrBVOX3A3NIkxyMcCRACCerzGPy5uWPbSuj10++kjfswtJG+LO2C+ZhgrthxSZGMnkLfTMx3EGsaM19TM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39860400002)(316002)(7416002)(8676002)(31686004)(2906002)(53546011)(36756003)(6506007)(4744005)(66446008)(71200400001)(478600001)(8936002)(26005)(64756008)(66556008)(4326008)(2616005)(86362001)(5660300002)(76116006)(66946007)(54906003)(6512007)(107886003)(110136005)(186003)(6486002)(66476007)(91956017)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Vk01ZFVFM3lxSUw3K0dlejZ6ZGFFQWtOZjdvVTZjcHQxUHlEUWQ5cHQ5OVA2?=
 =?utf-8?B?TVM5SmRuMVh6OHpGYUg1TzFBYXNpSjRObGx5UnpWSmtobmpoZXB2R0NENG91?=
 =?utf-8?B?a2ZYdHlZd2Rzcmh1Z1lDWlAwWWgxT2ZEMUNYT09Fa09qYjRpMzFabXNiandW?=
 =?utf-8?B?TmJRVXdiUkh5VHVoNkxiR3d3V2dvYjczUWRBUlZyTTkvc2FzNHNnQStySFJX?=
 =?utf-8?B?SlVISEpwempqWm1vaFJhMEFmSUhyM3cvd0lDMGNGbTN1TTlRRUd4UkMvNktH?=
 =?utf-8?B?dGxRc1hrUSt5SWdVdWc5eUorTWNkcHo2OExqcHd3SkhRd21pT1F5bWs5azk1?=
 =?utf-8?B?em1BRHNRNXlqTUE0R1ExZkNQMkVKM0UxYTViL2dPQ1R6WHFqdHFNMXhoRUFC?=
 =?utf-8?B?Wmt0a002K3crQXNsU2NYT1BzQjl2NDJHRkFrVjh0MWlqanFoMkVmRjVHeitu?=
 =?utf-8?B?clpXcFpsZ0Z1ZGdXQktsQlhoMzNFeDRjYjVOb3liUWpWcnJhcDNpelc0bUF5?=
 =?utf-8?B?RXo0dUIyMytwWjkxc1pmMVd3RktlNS9pVmV0QW95b3pJbXBxdmJxU2JaTFRo?=
 =?utf-8?B?UVpJblZDeUtPYXliQ2VsSFYwNDBIOWNEaUMyWi9JSUZaaFdZVCt0SkR0SFZR?=
 =?utf-8?B?a2VYUTZwdUNSVXFVWlZ6d00wNWgvTTlJMjdyaGtMQ3V3T0xFSHk3NWZzdjdL?=
 =?utf-8?B?LzRHYW5pRVE4bFhPNjhiekpHUVJuMDJCOUtlQlNRRUxPYXpnYVh3WlNsNk5t?=
 =?utf-8?B?eTM4SHZnWlp2WGN3aXBOYnl1TnhRUmhjZHNIS2FWNXMxT1Jwd1AyRzdkWHJT?=
 =?utf-8?B?d3ZXMWNYeFRKdlVKVGV0L01DTUVrSTY5VmVNSFhQN0kwUkhlWjFvSFdiZHA2?=
 =?utf-8?B?VzIvWVllUkxseGFPcnNZY3d3bVRWWkJuOWlMUy9WdEF2UGUrM2N4Z3R4NDhw?=
 =?utf-8?B?MTRBNDRPTWZzOWEvR1pUdTJEY21pTTNKWUN5M1ZNZ3VmN2hPR2NFRjJaWXN6?=
 =?utf-8?B?RUFYb3ZsY3ZaSEJJMnNMRDRJUW93ZlRQRGJoNkw3QjUrSFRFUE1OQVBBcURs?=
 =?utf-8?B?T0xFUTZ3MFdLdmZiVHFYdHRTT09HWm9qSjV3VDYzQkNkTlFJSy85eHMxKzhI?=
 =?utf-8?B?djVCWlVBOHpDT0Vzdm1JWC9GOXBvakpzdU8vMWF1UGZSVGthNXFJTytWUHlJ?=
 =?utf-8?B?Zy9JS3VyK3RLdld4NnZ1Y0c0VW14NDFJN2phZlA3TUp0TXVCM0lPdlR1cGtF?=
 =?utf-8?B?MEREdjNLUWtsUXJBSzRqQ2RiU1Qva3pWZ3d5VlZpOVZNV2o4aERtaVFuTTNR?=
 =?utf-8?B?UlJGL3htQjh0SVZOLzhFYkMxY2pqejlUNXhkdDFvaGtCays4U3drVXFMck5h?=
 =?utf-8?B?RUpGVGFMamlxYTU5Z28zdUYrcDFmRjkwbnpOMjZvdmtQKzUzZlhQYWY1SDFa?=
 =?utf-8?B?NlN4M3JJRjNOVlNlclFOR2QzOWM0UFRMY3A0UU1PSmJxekpTWjJMWlJMajYv?=
 =?utf-8?B?RHdqUTgzaVQwc3RpTmd3c3lpbUtIeFVZQjJ2Y3ZmZWt6bjBMSmk0MDcwQmJ0?=
 =?utf-8?B?SmhxUUFjWTAydjM4TkwveDk5V3VpcGpSdkVBa25YRDhoQU1OeUJmaVd0K2VR?=
 =?utf-8?B?RUQ3dWhiRGtNMzVyZDdZdHc4bHZGb2NjSit0V1ZSeUpicFVtZjNuN1VUUDA3?=
 =?utf-8?B?WWE1SkRMSjVFVFVFYU8wN2pnSkF2Y0hrbm9RV3BrVitxMjh3TG5vbzNZQWxi?=
 =?utf-8?Q?fsek2Df0F0rfVSzaj4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73B4014F4F43F54B8CAF8DEDF75F429F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb3c32b-208c-4fa3-3a12-08d8d7e80d40
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 10:44:52.6398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kr8qIaNCJUEknELjrJYE70q8A6wwyd3++t8cC3B85053F1iMsti0L0ONONnud/6d6Ieu7u4ugUj2Xwr9NxYnOFtrUun+t8Ax2JKwzhsS0Kw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5097
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGksDQoNCk9uIDIvMjMvMjEgOToxMCBBTSwgTWVuZyBZdSB3cm90ZToNCj4gLS0tIGEvZHJpdmVy
cy9jcnlwdG8vYXRtZWwtZWNjLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmMN
Cj4gQEAgLTEwNCw3ICsxMDQsNyBAQCBzdGF0aWMgaW50IGF0bWVsX2VjZGhfc2V0X3NlY3JldChz
dHJ1Y3QgY3J5cHRvX2twcCAqdGZtLCBjb25zdCB2b2lkICpidWYsDQo+ICAgICAgICAgICAgICAg
ICByZXR1cm4gLUVJTlZBTDsNCj4gICAgICAgICB9DQo+IA0KPiAtICAgICAgIGN0eC0+bl9zeiA9
IGF0bWVsX2VjZGhfc3VwcG9ydGVkX2N1cnZlKHBhcmFtcy5jdXJ2ZV9pZCk7DQo+ICsgICAgICAg
Y3R4LT5uX3N6ID0gYXRtZWxfZWNkaF9zdXBwb3J0ZWRfY3VydmUoY3R4LT5jdXJ2ZV9pZCk7DQo+
ICAgICAgICAgaWYgKCFjdHgtPm5fc3ogfHwgcGFyYW1zLmtleV9zaXplKSB7DQo+ICAgICAgICAg
ICAgICAgICAvKiBmYWxsYmFjayB0byBlY2RoIHNvZnR3YXJlIGltcGxlbWVudGF0aW9uICovDQo+
ICAgICAgICAgICAgICAgICBjdHgtPmRvX2ZhbGxiYWNrID0gdHJ1ZTsNCg0KTm93IHRoYXQgeW91
IG1vdmVkIHRoZSBjdXJ2ZSBpZCBpbmZvIGludG8gdGhlIGFsZyBuYW1lLCBhbmQgaXQgaXMNCm5v
IGxvbmdlciBkeW5hbWljYWxseSBkaXNjb3ZlcmVkIHdoZW4gZGVjb2RpbmcgdGhlIGtleSwgZG9l
cyBpdA0Kc3RpbGwgbWFrZSBzZW5zZSB0byBrZWVwIHRoZSBjdXJ2ZSBpZCwgdGhlIGtleSBzaXpl
IGNoZWNrcywgYW5kDQp0aGUgZmFsbGJhY2sgdG8gdGhlIHNvZnR3YXJlIGltcGxlbWVudGF0aW9u
Pw0KDQpJIGRvbid0IGhhdmUgYW4gYXRlY2M1MDggYXQgaGFuZCB0byB0ZXN0IHRoZSBjaGFuZ2Vz
LCBidXQgSSBleHBlY3QNCnlvdXIgY2hhbmdlcyB3b24ndCBhZmZlY3QgdGhlIGZ1bmN0aW9uYWxp
dHkuDQoNCnRhDQo=
