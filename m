Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349C3C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 09:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1E561981
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 09:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCVJM2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:12:28 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44073 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCVJMA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Mar 2021 05:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616404319; x=1647940319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RSzfMQd7vjQIO9mP8UD5tSLHWfsckK1hjXvxzIMkOs8=;
  b=XKBQWXbjXyQ8udwNjPjPjeF7OHiz89s79WCi07PC0kzhmUdMNSE2emp+
   6wN1x21tEy3svMTfOZQgtUGr9CdKjJIgYm3MO6lgZF2q9icLoTu2RH9Sr
   dUbQvE8YxG4GjMfQIUQJ4SKwEMrZk+EcbgCoVBGv14stHnhx140yySAGL
   e4HDkmHRJSfOTPPpdHzaTzYe1BsYvIkJSDJlt7DF4Z0aMmRVG1JxRCOgS
   HpC4nda0ZUaXfuFK6m3PAmfEnrzDh92B3Jb8kvi3z+7nTL6RpvRNMi5wO
   RW7DFns2+AQ2dwxPZi7CAnRDARu0XkCkEwZYCh73IPyo2aL2rswvk4BET
   A==;
IronPort-SDR: esqUL9T2j2iqotJXqYiOqIUl+zT84499zjdBKNqNEc/+kqJOm4WGF7GhpgXMV2kxHSsltRrYqQ
 5OnVwLSNCFk3dNlOnVVZdiXotAEFrY6kLbx2f6QEac3jAXCPM52261oC5VjjRxCDLZtVbnwxuf
 lKPXYKNODYSHSXZgCJiYWTlO7fu10CykiiEnWwMBpOKUl7gb56gKSNU0dYcfXotg4L3X5Foea0
 0pb8H6yev6mE47nmbThGfhyX4KUsx4dzGpzhI+RkzvlnivFed579JOWK/vn4HKvuoRDHrFheZr
 UOA=
X-IronPort-AV: E=Sophos;i="5.81,268,1610434800"; 
   d="scan'208";a="108038546"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2021 02:11:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 22 Mar 2021 02:11:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Mon, 22 Mar 2021 02:11:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXrTvcRbHzUhWJJTjsFjSleMf+45TcJlKHnMQDJaezoT9kJCQMQis364oyK2abK/O4beKofvE8KNv9YQ0Xz9zL/ww9iPGqf0sWl4YuX+A7WgF4kVyHF4j7ZTgvHyDwYMXEohHEt7orArebRpztWwydhTDwgP0viMGZX1ypiDarJvme67ANcMAWCdk/B7l6EBhi8G0fzw7eimew95Eo510/hPeKvJnzebVWJPRwfPETTMfg4Z3iGDE/1RDEWn2hEut5UH9jYtBxDSqRnF1DLatNbYb/9UnW2ZwChsQHf1vxneo0Yd6dSa+Q3p8iy5uxTdOSKIrGKSMuIfFUcE9VyWKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSzfMQd7vjQIO9mP8UD5tSLHWfsckK1hjXvxzIMkOs8=;
 b=TI3BQKvJXrf+//H3WK2dIExde+1tekb0J2kIgMR0mVc74Sg10NLEDwfoAPpOoVyCedmFjh2qRM3leptFTEz3wn8tUvvX0PI9sqkdUWRhU3TKriLXhKNWccCGPVWi7DHNh79gsQrDnEWlfbHqlqG+HGUkHPlxac7kYjsWOH1kmq/PI5AtXvhdIbx5RkcT2GBDuAw5RP/Up8HyRTO/b1LS32Gy/gRGK8/p6FF/OFXEk0fAxUnpEWS5jOkxwcfBZQPbM5S2aQiyF4XaXzfIsjnYA7VbzolmVf4IhZFe78nPgXcjqlBR9GrrJex+dpRm33Xz+5IvaQtN86OpHJd5uiTSGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSzfMQd7vjQIO9mP8UD5tSLHWfsckK1hjXvxzIMkOs8=;
 b=QAemIOfntGoPr37naLGUxSW+OgOZEVfhLx7f0ZvNFzrmtzrm+Iqf9t1fDktTW2pzabmaJjACKHZLvaXi3fgNDcS1hdTYsqML6xorMuJCXTfLpRasLA5n60abyYbnizeCju4+AGKROuF3eHDL1GBCYARlCn7oc53ZJ0wt05Oi3EQ=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SN6PR11MB2637.namprd11.prod.outlook.com (2603:10b6:805:54::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 09:11:55 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::49e5:8be7:95d:b6a9]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::49e5:8be7:95d:b6a9%4]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 09:11:55 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <yumeng18@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: atmel-ecc - fix W=1 "cannot understand" warning
Thread-Topic: [PATCH] crypto: atmel-ecc - fix W=1 "cannot understand" warning
Thread-Index: AQHXHvtnZpbi86bjd0mR1WPkoZCuVA==
Date:   Mon, 22 Mar 2021 09:11:55 +0000
Message-ID: <fc9ca7d7-a3eb-a756-0d8d-5fd06de24fe7@microchip.com>
References: <1616228113-15169-1-git-send-email-yumeng18@huawei.com>
In-Reply-To: <1616228113-15169-1-git-send-email-yumeng18@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5979322-5a09-4460-4c64-08d8ed128a3d
x-ms-traffictypediagnostic: SN6PR11MB2637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB263728D77B22A452DD2AE8D7F0659@SN6PR11MB2637.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dhPIOtIvqUpDFf48Hcv74GjkvEb3LXhFK7PxwCmyiTc00NkU2gaQi8g4c/4oHHfbWsajIx1udN5tRgqIIjGsLgST0lhSGfIdUyM6rBNkB+j1z1gr2saGn4BItKOP27L0pGm7TJ2qAngywHsNldgQhaunmmOUsAiUz88cyGXIH4qo1ls9+yw4CNEm6DVEv/ZQVL9HnlIY5eb+zyLxNp8nj1DvUr1/svkB6HVwtE3j53O89M8HgEys/0Kfspi4i1bPxEMmnwBOX/DRUOtRtSNDVlS5Ufzu2XuPU4C0UHBshj9eyU1Z5xVJLLO5jTId51H+IZNH5y6dwWbMGIY3qGtzgnZ0ouJwDgLnk36dXqDMo06ETM8PcAVPXCOMyizd1vz0UVH3MbZ62BY3q3hQnMVqqpMsaZR2RIFYRXnoII5Tvma6YeEtJTQJx84Ed+5swWOkoFqhYBTCrSWJLjPnPu4gKIrlsikzPb30KpXV3zifJVH0WtlEK+ATv5AubwZjVTeYHbCLRajcMQRNG5/TgJc0w1qzKfAmt65af/veVGLq2MraaUcVbJQWH6Y1fpFO14bl2mLXbFW0ibieZfBFsUb/bTiDXNB/8ngy+nC+7Qw8Ux0AWi/Hf44b7rLDTy0DhYVBdG07KfzgwWJVF0Samlcs9ZqR7OnBoOqTIRxNWlc7y2W0Ucrdcx/3Z10iudHAxryxG21BnTfZTn6eJkn0iveGYzgpK6QQ3Ted/fMd60K3YtO5XDiZ5AmP2nIZdH/orPQ1hL6mtoHhOM8nUzxwSuWJQZdtQoAZUqGPms6DG8HQerM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(346002)(39860400002)(36756003)(83380400001)(110136005)(316002)(54906003)(5660300002)(53546011)(38100700001)(91956017)(31686004)(64756008)(66446008)(6506007)(66946007)(71200400001)(66476007)(66556008)(76116006)(4326008)(966005)(86362001)(6486002)(478600001)(2616005)(26005)(186003)(6512007)(31696002)(8676002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WSsvMjdIdE9uTm1lVmRIWXBNQkUvUWJCZ0pYd0U1aEhNVDRqak9kVjM2b1dn?=
 =?utf-8?B?TVRxR2dWZXdyZGlxeU9WVGF6Z08wY3JCNlE2dktVc0xQaE01WUYvdS9GTkM5?=
 =?utf-8?B?V0o0aElOcENNeDkrSUhXay9Vcnk4ZVRqc0FVem8zSHpYbm5MOFJwWDd6S2lM?=
 =?utf-8?B?S1M2SlVhRitIalpqbHd1RnM5ZFNxcEhaZisxTXdjMjdSWWlRQTViaGk3ZzZQ?=
 =?utf-8?B?NVlRRmZWalNmRTFER3ZSZ3VORndkT0x5dC82N3A3Qy91SGRMZlErY3JoVnRv?=
 =?utf-8?B?UWpNRmJlU2Q4aHNkN21TMjhwZ3g0M1ZsUWR1d2dUZFYxWE9KUklGL2RwRDNF?=
 =?utf-8?B?UlJDR3lBUHh6QVhuWFlqVSthRFYyd0pBOW9YVlhkQ1FjbzIvUDRiWUJWcEFo?=
 =?utf-8?B?VjV5U3FrVHJNK3A4Tks3Z2hVWExUU0VxZ3hGdUVINndOaGZTM1JEVjFSUm1B?=
 =?utf-8?B?VmRYcUpVQnlNb3pLZVFpNEYveXRCcXdSSzBJU0RMd2Y3NEk0cDM2NkhoZXZE?=
 =?utf-8?B?d2Z3VXlhQzEyN3FYcTZLV2Z2aER3cm9xbGh1dk4vM09oL1o2RGw0emljbVZV?=
 =?utf-8?B?cWJvcTZvaWVxL0dNc1lmdWt6QVZyMjZnZkJEaHY5NFQwQ005elV5ZzVtZHhS?=
 =?utf-8?B?WlJaRy8yNVJrVCtpTHZNWXF6TkVQOVFrQ1dMZ2xOSW1LUFkvd2pMNE5wU1ZH?=
 =?utf-8?B?V3lWa3NtQzFSNDhWNzBCNWFlRG4yYWlKSVlxWDU4Mm56eGFLYkJtVThoWnhv?=
 =?utf-8?B?WENOR0ZoYmhUb0syQkx3a1FzRGhWT3JDeXRUSmxuSlJNNHQ3NXM3V3JyTlRF?=
 =?utf-8?B?R0lYb0FoeUNza2k0dkRiSzVPcjZrQmVvSm1MT0tIalNBL0M2cWRNR1NPS1JH?=
 =?utf-8?B?aWhHZGVTVW12dlgwRGl0ek5Wa3BCdnVhbWQ0S1JQL0xlS2l5Z3E2d1RrYXUr?=
 =?utf-8?B?b1dKbHJLNTVjQlhwRlJGY1BBUExxVmlmQ09ITTh1WVo4MGxQb05Kb2VCZDdD?=
 =?utf-8?B?UHRXWk5lbG9CeHZkbmNoSnlBNllOTGdGcWRnellIN0hYNWpjQnBFbE54NlNn?=
 =?utf-8?B?dmJiek5EaDJuK0k1dUwvcVE5Vk9BajF4Z3NFSkVvMm1FNHIvNWd6Z1k2cFpE?=
 =?utf-8?B?UlZTU0hzalpMNGdGd1c5UTlHUXQvM1c2RGhMUTI4M2s5eEFrV2Fwd2dGNUVz?=
 =?utf-8?B?b2NVYndmWmpIeStRUEo0WlhGYjloK1M5TEd3dGJGaXBTeERFMU14Y2RucTR3?=
 =?utf-8?B?WHp4SFA0VGg3blZiaDdlY2hzNzJZb1J5ME5walRuL3FMbVdaSzAyOUgrVkFt?=
 =?utf-8?B?NW5Pb0g5TXQ0bVUwcTgxVkZRdHZUYlhvWTlhbU81Mm5kYzZJZkFFYjBrMjdj?=
 =?utf-8?B?eGVKZXdOajFxU0NsTHh6SGZEYmFqQkxmREZSRWZmMHA4STFGaEpURzZuRjZo?=
 =?utf-8?B?bmNmWmQzTVdtWGJxS2RvaTEvSlVZbU5BVUtJcTl2MHpMSExyeGF3S2huVlQ0?=
 =?utf-8?B?S21HOEVwTUNKeDBGVVl6ZW90VytocXM5djEvMmVobU9GdldHRXM4Zy9BcWh0?=
 =?utf-8?B?d0lGaFR6NW1RTXRIaERMY21FbSttdGFtSDNwOFQrYWRCZDNNd3QxNmtia2Fk?=
 =?utf-8?B?YS9uY3RiSUh0M3k1MUExNlI0dkVZTGRMSGxCSE5IU0I2T3U4TWVUWGpOVVVH?=
 =?utf-8?B?eTVYZkk0VWNham9EUTcrdGp2enlDOGgrNjZsazVoWEx2TkdUYVZUZWVTVGV5?=
 =?utf-8?Q?Na+fRvWERwCgrZbIRI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5E9D1D0D95FD64A9D1620DDAD32B249@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5979322-5a09-4460-4c64-08d8ed128a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 09:11:55.6376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kzpH5dl9yap76ftTd/XgB++yp+vBmkDpTiEmHLj3kniyeZbE5KBnJas5hpfW7wa9m0z9xyHexcX/4LlrnVGZr97mqEsP6CRt0q/2PRrKOsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2637
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMy8yMC8yMSAxMDoxNSBBTSwgTWVuZyBZdSB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUg
Y29udGVudCBpcyBzYWZlDQo+IA0KPiBGaXgga2VybmVsLWRvYyB3YXJuaW5ncyBkdWUgdG8gbWlz
c2luZyAic3RydWN0IiBrZXl3b3JkLg0KPiANCj4gVGhlIHdhcm5pbmcgbGlrZXM6DQo+IGRyaXZl
cnMvY3J5cHRvL2F0bWVsLWVjYy5jOjQwOiB3YXJuaW5nOiBjYW5ub3QgdW5kZXJzdGFuZCBmdW5j
dGlvbiBwcm90b3R5cGU6ICdzdHJ1Y3QgYXRtZWxfZWNkaF9jdHggJw0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogTWVuZyBZdSA8eXVtZW5nMThAaHVhd2VpLmNvbT4NCg0KVGhhbmtzLiBUaGVyZSBpcyBh
IHBhdGNoIHNpbWlsYXIgdG8geW91cnMgdGhhdCB3YXMgc2VudCBpbiBhZHZhbmNlOg0KaHR0cHM6
Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LWNyeXB0by9wYXRjaC8yMDIxMDMx
ODEyNDQyMi4zMjAwMTgwLTctbGVlLmpvbmVzQGxpbmFyby5vcmcvDQoNCj4gLS0tDQo+ICBkcml2
ZXJzL2NyeXB0by9hdG1lbC1lY2MuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRv
L2F0bWVsLWVjYy5jIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmMNCj4gaW5kZXggNTE1OTQ2
Yy4uMzMzZmJlZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmMNCj4g
KysrIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtZWNjLmMNCj4gQEAgLTI2LDcgKzI2LDcgQEANCj4g
IHN0YXRpYyBzdHJ1Y3QgYXRtZWxfZWNjX2RyaXZlcl9kYXRhIGRyaXZlcl9kYXRhOw0KPiANCj4g
IC8qKg0KPiAtICogYXRtZWxfZWNkaF9jdHggLSB0cmFuc2Zvcm1hdGlvbiBjb250ZXh0DQo+ICsg
KiBzdHJ1Y3QgYXRtZWxfZWNkaF9jdHggLSB0cmFuc2Zvcm1hdGlvbiBjb250ZXh0DQo+ICAgKiBA
Y2xpZW50ICAgICA6IHBvaW50ZXIgdG8gaTJjIGNsaWVudCBkZXZpY2UNCj4gICAqIEBmYWxsYmFj
ayAgIDogdXNlZCBmb3IgdW5zdXBwb3J0ZWQgY3VydmVzIG9yIHdoZW4gdXNlciB3YW50cyB0byB1
c2UgaXRzIG93bg0KPiAgICogICAgICAgICAgICAgICBwcml2YXRlIGtleS4NCj4gLS0NCj4gMi44
LjENCj4gDQoNCg==
