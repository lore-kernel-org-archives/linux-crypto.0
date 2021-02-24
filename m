Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8799FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 10:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146D564EC9
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 10:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhBXKRE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 05:17:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:37489 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbhBXKQ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 05:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614161819; x=1645697819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eNWiOclltiopyMuOMM+VEvjSXJRicfRreAqDXySj49w=;
  b=w41IGUbOtqse83tM2TE7XQEXyL3FE3jeq1U9tikSwiuf6a47ZNA9N6YQ
   +aOl3d7lp4C+D11olCse/TZaUnUEPyC5B16ajMrIp8m+gsA3CgWIHjqpK
   2/tA9qJtPuGsI/frp7JNQ2EJoIN0KNXPYia0+EmgIhJZc2zU0EboO8wGU
   dkDjajNWf/307Qfs1D812l101q1CRd9NxCYvty65zKNKHzFgf1JFV23OG
   vGueO8NTqtEVUi0PEKlwj7Gm7tPqO87A0ZCqwWN0Ur5xX3t1mwp5r5wGM
   IjPXCn1UiW+RJClynGYDHrEKnzgVkx9gFEd60HqC2DN/otI1eb+iFko0Q
   w==;
IronPort-SDR: wUdMh82oN+iSrkcaqtWy0Mgl1J7dmpqlyfYvu7eAT+docRq85fk+ab7/Mz0TppDSKw/i+2PDpG
 AGKxlIAoDWFuYdm8wYP2negNxv3s+vmzQpklDgixLrB+COPr4buBfvr4TBnrcNxgyiSzGKQgh5
 HlkVxgDMsvA9qDtm7khBHOUC/sTcnD8wQE//sz6tzok7rjWT1yvznHfXmKzKnbHm0zirXwP8lB
 HYEr76VcpVjwngYuMCgIiX6cZWirz6mftihr86FQLbCRrjLcW04Lu8vyRCkp/eW2G9ysM3Ktyi
 q9w=
X-IronPort-AV: E=Sophos;i="5.81,202,1610434800"; 
   d="scan'208";a="110441776"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 03:15:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 03:15:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 03:15:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxr+Z1skdKRfIrdyYDQw0ebQc2sIl4eXFZaJ1rBN4LUewFvj3glbxlYBWCeKohwLB27vT9JBplR34N6nvufcJaT55XQH1jw2FtFDqv50RpLadomYzBOppyv4bitCDf6gpkIncszi2Jc5sBmK+qNiZynoHVIulJfCD/0D4wVU6FnEZCXc3G/mlydgeGaponRurQKBd1J6TIut6m2LCkGYseHat1u7tElUaYqNV4kfmjN+2oq7laV9re/90PRwIMJ5sSHkk7FTxXnoOt+IgyPH6bsdwHbkggAYc/z5CCAcKmcqzfyu7kcCMx5PBNMWoA9j6a4t5h4CgpzY64p0IrlVjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNWiOclltiopyMuOMM+VEvjSXJRicfRreAqDXySj49w=;
 b=BUWd+zNy3GSCsnkns8uZjWum523mJClHkiNKSytP+9gPxLUlTbHhE5teZPqJPuX50Q0rMHtOY5JtYm7PXKEmUjtsltfuNjoyD7jfIFXuK66+48c+yge+uukRhlWSZ54EoIpBhTFRnC+d/9dOturXq7ifgFxBZbtAbjwkarOEdnG0E27IlEM1qwpnfLM6SAMDLYFs1QYJ4yIaBZSzD0K5KaVjvESwaWLfYyPyRhQIuuxxEWfyJs+bjpMEDhVKSXqIk7EiI6wj1gtRZqT5+z4QBqYhrDVb7El6933CbrQcqP6YKbk4PxlRt746kNzFvN70Xxk168wLhd+qRBUgS0RjOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNWiOclltiopyMuOMM+VEvjSXJRicfRreAqDXySj49w=;
 b=I3P1gGYqEqvrNkL9aZBNSXKpccdXgQY0nPzelS/nipTzfldBtKTUGzRTR+N4DK2V4Dt5OWwYIQdge2tpoKKoWSd4/7ghsLxqqQPLC8k2MmUkoDKY2LYRlPidDWIVcQnHWx6khR6ZggmgOvfP8dky9wDomkoQUUn8gItfnxfhDeg=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA2PR11MB5130.namprd11.prod.outlook.com (2603:10b6:806:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 10:15:40 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::c9e8:9bf4:b08c:c30f]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::c9e8:9bf4:b08c:c30f%7]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 10:15:40 +0000
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
Date:   Wed, 24 Feb 2021 10:15:40 +0000
Message-ID: <e3b4c883-d2f3-0bf0-ffab-42ff5ffe31b8@microchip.com>
References: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
 <1614064219-40701-4-git-send-email-yumeng18@huawei.com>
 <8b96c136-dca9-5b6a-2221-e906d265c40b@microchip.com>
 <fd3b7c0f-d7f2-3d27-cfef-98ec3614dd1a@huawei.com>
In-Reply-To: <fd3b7c0f-d7f2-3d27-cfef-98ec3614dd1a@huawei.com>
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
x-ms-office365-filtering-correlation-id: c93c97c3-fa86-4bc1-9408-08d8d8ad2353
x-ms-traffictypediagnostic: SA2PR11MB5130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB513026739F2DADB620605A06F09F9@SA2PR11MB5130.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZVOVzVhCuR+uozAtOQaxxxp5wcrjwmQOybMtd+WKjol9IhRqnhUKgfRYJTmvQbrhuaEOZrzGhLk1iGz7w4GcPdAKV57rklV/b2gQ7O4iqd46uUnYS8ycZPhP9g7T3Pzy3EZiD83SbKGDsL3jhGqRVIdTZmYWkATSWiRR48jzXQVYtmkeIDq/WmI3IPiBIdJ6x7jPiMAmDO0hTsGHBfgnZgdGvVwu9tNPKl+9ZYp8u2DsXdH2P/CfyOTeZQUV28qqeh3tdqYMYWzm2kAeYOEpeushwowvAVNO5+BvG0NmQvEtUbsMVLXpHSrgUkICVYC1hDpZG7GtrZwZs1IqVQuG56dDMqDejgq2bvTL9cq/1x+4Jrvx+GQiLh4RYhfoAnFc6GHmzMMnrNH5OVkI1knK/7DQWxTLwBOXxuw+ABKHodaCGDtu7rBiN5diEHw2tNBXfkngZlOL1tLmC/i6Kdrzrjx2cnEsx4MSS5X+rDRTxeEySH89YWtMHfqmBzwbRoBnbNtX8LydoRq+RMxqxw85CCLuAlp3cVo2nwx3PejvW+TxYFti+Di3oqJmj6RaU/w83sX+b3xNc8XYVLIRJfBd8J3TOXwNzRFdnQH6qhfVzQY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(366004)(39860400002)(5660300002)(478600001)(31696002)(107886003)(86362001)(6506007)(4326008)(31686004)(186003)(6486002)(71200400001)(53546011)(26005)(83380400001)(2906002)(66446008)(36756003)(76116006)(54906003)(66476007)(110136005)(6512007)(2616005)(91956017)(316002)(8676002)(66556008)(64756008)(8936002)(66946007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U2tITitwSktGdXNTd2pMMDZjYUtOWEwwenppdTdQQlRHU1k3QS9Da3krdEYr?=
 =?utf-8?B?NUlGZ1Z6cGswODdxSnZTQzdpWHdMVVkxODRoWDVURnRqVEpyNmdYRmZRVmFw?=
 =?utf-8?B?NkkzR2JKbzgwbmRudTZjbXhHazNCSytwK05Rb2Zjbzg1OEQyWTVVUFRMZlpO?=
 =?utf-8?B?eGxuemNmbWd3eXhoRy9PQzU0Slp2dVEwaXVSQTQvZ0VDS0pkSXRKY0s2eTZs?=
 =?utf-8?B?OGhYQ3FKREVPS2JlVXdCNEhseG9zTFpDM2hNVTY5US82R3ZYcGdVUWhkVXB4?=
 =?utf-8?B?S1ZHS0k5ZTd3NEp4QzRxYkRIR2loZFRKWlBvelVsYmJJcjlsandseTgrUHVF?=
 =?utf-8?B?Mm8zYWkzWDY2RkE1VzB1ejkwOHQyNGFjZmpOdm9VWFFFTXU1NWlIbzByMjZH?=
 =?utf-8?B?Z1hBaysreGtQbzdlaS8rTGhLMGhhcUZieGh1V0VyZmVnQ1dTUG5aV282eHV6?=
 =?utf-8?B?RWFZUFFQM3NBa29ab0JENlRzSlZCRDBXRTE1SjVEWWlPNGNVbGd6R0RCUTE5?=
 =?utf-8?B?S1A5UDhObE82NjhldktkYkphREwwdEcxNU9BMzVyclF3WVozR2doZUlPMk5Z?=
 =?utf-8?B?em5ibVAxQ2R2MGUvSHZrR041cVZIbTlKRkNDcDlMY0V4TVpCbE8wNWpqRExM?=
 =?utf-8?B?NDNXUk14L3VCOVdWd1g2SmVsSGpmellSaG5UM3ZXWk5uTTNiZnJqbnB1QjJo?=
 =?utf-8?B?VjNQd3FOZ3V1cmhsMTlMMHE1eHNnTGVMenN1TEFtbXFnQU9qWldUZDZvKzZ4?=
 =?utf-8?B?VmYzS2kwZmQvKzhRMzRWOThMMkRibW1BM0J3dE1hRERMeHF3TkVNZXBLNUlB?=
 =?utf-8?B?U2dSYjhrZUZqM0lsS1RsS210RWUrWks3OSt4QWs4S25ielVuVjBoaUtOaFRh?=
 =?utf-8?B?SldhSzU2NkVUV3JWdHNsb3FYaW4zSVBRWVJtdUgwb2tyYmt6YTU5TnN1NFFX?=
 =?utf-8?B?MitVNi81ZjBKWjV4KzBlVTU5Q0ZkTWVxMkZPZWhQRUdVWExodi9lTUp4WHNJ?=
 =?utf-8?B?WmQ1YVJLbHpJa2Z0bCtnQzNoaW10eFNla1JJMmdiMmd6UGlVMURsZkJlN0ZY?=
 =?utf-8?B?NGppTFBtUkM5NkxPSEt2YVdtZUFMbVFWUVJYMVJIb0llaklJdzNWTEI2Q2I2?=
 =?utf-8?B?YVY2T2NqN05Jenl1VmpKdGtMTkh0cEptbTZPWlNtN0JwTEpHbTZHMENOc1Jj?=
 =?utf-8?B?YStCdzhhSEt1T3RETU1JeGN5MDVTbFgwZnJGUGJHT1YzV1NaNWZ5dHJnQWdN?=
 =?utf-8?B?K1FYVTcrZWxXdlFuRVdtSTgrZEpnMEhkU2hGL0ljWDZmdlBsaVhvbGJwZ0dH?=
 =?utf-8?B?RWJNN2k2UEtXQW1YdTZOQUo3QXN1Nmp6ckswbGlzMjQ4bXlGVlUrdlF2cFpR?=
 =?utf-8?B?bDVMN2hHM3JZQkFXdnpQZ3JxWk9EREhXMEw3R0p6VnEva055YW95V1JSVFFG?=
 =?utf-8?B?OURlU2xUeGxaRTY3WlZxblZHTElaNE1ZT2RwUm0wYkJiZXlORVo4WGg5V2VZ?=
 =?utf-8?B?aXdXWUp1c2RONVVFcnZhbXFydGEwL3ZML1U3NmYvaTUxQVk5YXA5S1FxKzho?=
 =?utf-8?B?bHh0M3VKL3B1aHVpS0xUTXd4bHRHZm1IOXIyUEpCU0M2bzhEVHlteEJvOGJX?=
 =?utf-8?B?Wm8xYXpPNXl5em9TM2JvV1hqTDlzb21NWW9ranM0Y3IvZ0ZRWXJ3ZG8rbkJ2?=
 =?utf-8?B?UXNxZldVaVB3aUlzT2lOYllFK1E2NDNiWTlnZ25rcHI1WCt6OStQRmE5R2xW?=
 =?utf-8?Q?RYDi9RcT5hF80fZ3Uo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A06DD381B1361D42A760A609D988F0C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c93c97c3-fa86-4bc1-9408-08d8d8ad2353
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 10:15:40.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EEPBww2KPd/P5w8YEenNOCpHFcdOOnzDw3k0nq8JP7NNVSh9ElKfNZyqj48ZGFOhCoCo6zNa2jUpX+ItrdDHZTAvhvvOaJVZUYsPbNQ1MR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5130
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMi8yNC8yMSAzOjI5IEFNLCB5dW1lbmcgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBu
b3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZQ0KPiANCj4g5ZyoIDIwMjEvMi8yMyAxODo0NCwgVHVkb3IuQW1iYXJ1c0Bt
aWNyb2NoaXAuY29tIOWGmemBkzoNCj4+IEhpLA0KPj4NCj4+IE9uIDIvMjMvMjEgOToxMCBBTSwg
TWVuZyBZdSB3cm90ZToNCj4+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9hdG1lbC1lY2MuYw0KPj4+
ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWVjYy5jDQo+Pj4gQEAgLTEwNCw3ICsxMDQsNyBA
QCBzdGF0aWMgaW50IGF0bWVsX2VjZGhfc2V0X3NlY3JldChzdHJ1Y3QgY3J5cHRvX2twcCAqdGZt
LCBjb25zdCB2b2lkICpidWYsDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIC1FSU5WQUw7DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCB9DQo+Pj4NCj4+PiAtwqDCoMKg
wqDCoMKgIGN0eC0+bl9zeiA9IGF0bWVsX2VjZGhfc3VwcG9ydGVkX2N1cnZlKHBhcmFtcy5jdXJ2
ZV9pZCk7DQo+Pj4gK8KgwqDCoMKgwqDCoCBjdHgtPm5fc3ogPSBhdG1lbF9lY2RoX3N1cHBvcnRl
ZF9jdXJ2ZShjdHgtPmN1cnZlX2lkKTsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgIGlmICghY3R4LT5u
X3N6IHx8IHBhcmFtcy5rZXlfc2l6ZSkgew0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIC8qIGZhbGxiYWNrIHRvIGVjZGggc29mdHdhcmUgaW1wbGVtZW50YXRpb24gKi8NCj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjdHgtPmRvX2ZhbGxiYWNrID0gdHJ1
ZTsNCj4+DQo+PiBOb3cgdGhhdCB5b3UgbW92ZWQgdGhlIGN1cnZlIGlkIGluZm8gaW50byB0aGUg
YWxnIG5hbWUsIGFuZCBpdCBpcw0KPj4gbm8gbG9uZ2VyIGR5bmFtaWNhbGx5IGRpc2NvdmVyZWQg
d2hlbiBkZWNvZGluZyB0aGUga2V5LCBkb2VzIGl0DQo+PiBzdGlsbCBtYWtlIHNlbnNlIHRvIGtl
ZXAgdGhlIGN1cnZlIGlkLCB0aGUga2V5IHNpemUgY2hlY2tzLCBhbmQNCj4+IHRoZSBmYWxsYmFj
ayB0byB0aGUgc29mdHdhcmUgaW1wbGVtZW50YXRpb24/DQo+PiBJIHRoaW5rIHdlIGNhbiBrZWVw
IHRoZSBjdXJ2ZSBpZCwgdGhlIGtleSBzaXplIGNoZWNrIGlmICdhdG1lbC1lY2MnIG1heQ0KPiBz
dXBwb3J0IG90aGVyIGN1cnZlcyBpbiB0aGUgZnV0dXJlLCBhbmQgaWYgeW91J3JlIHN1cmUgUDI1
NiBpcyB0aGUgb25seQ0KPiBjdXJ2ZSAnYXRtZWwtZWNjJyB1c2VzLCBhbmQgaXQgd2lsbCBiZSBj
aGFuZ2VkLCB3ZSBjYW4gZGVsZXRlIGl0Lg0KPiANCj4gQW5kIGZhbGxiYWNrIHRvIGVjZGggc29m
dHdhcmUgaW1wbGVtZW50YXRpb24gaXMgbmVlZGVkIHdoZW4NCj4gcGFyYW1zLmtleV9zaXplIGlz
IHplcm8uDQo+IA0KDQpJJ3ZlIHJlYWQgdGhlIGNvZGUgYWdhaW4sIG5vdyBJIHJlbWVtYmVyLiBU
aGUgZmFsbGJhY2sgaXMgbmVlZGVkIGluZGVlZCwNCmJ1dCBmb3Igb3RoZXIgcmVhc29uLiBlY2Ro
LW5pc3QtcDI1NiB3aWxsIGJlIGhhbmRsZWQgaW4gdGhlIGNyeXB0byBJUA0Kb25seSB3aGVuIGl0
cyB1c2VyIHByb3ZpZGVzIGEgemVybyBsZW5ndGggcHJpdmF0ZSBrZXk6IHdlIHdpbGwgdXNlIGEN
CnByZS1wcm92aXNpb25lZCBwcml2YXRlIGtleSB0aGF0IGNhbid0IGJlIHJlYWQgb3V0c2lkZSBv
ZiB0aGUgZGV2aWNlLg0KVGhlIGZhbGxiYWNrIHdhcyBuZWVkZWQgZm9yIGVjZGgtbmlzdC1wMjU2
IHdoZW4gdGhlIHVzZXIgcHJvdmlkZXMgYQ0Kbm9uLXplcm8gcHJpdmF0ZSBrZXksIG9yIGZvciBv
dGhlciBjdXJ2ZSBJRHMuDQoNClNpbmNlIHRoZSBhdGVjYzUwOCBhbmQgYXRlY2M2MDggKGZvciB3
aGljaCB0aGVyZSBpc24ndCBzdXBwb3J0IGluIGtlcm5lbA0KYXMgb2Ygbm93KSBib3RoIHN1cHBv
cnQganVzdCBOSVNUIFN0YW5kYXJkIFAyNTYgRWxsaXB0aWMgQ3VydmUsIGFuZCB0aGUNCmN1cnZl
IGlkIGlzIG5vdyB1bmlxdWUgcGVyIGFsZywgdGhlIGN0eC0+Y3VydmVfaWQgaGFuZGxpbmcgZG9l
cyBubyBsb25nZXINCm1ha2Ugc2Vuc2UuIFNvIHBsZWFzZSByZW1vdmUgdGhlIGN0eC0+Y3VydmVf
aWQgaGFuZGxpbmcuIGN0eC0+bl9zeiBjYW4gYmUNCnJlbW92ZWQgdG9vIGFuZCB1c2UgaW5zdGVh
ZCBkaXJlY3RseSBBVE1FTF9FQ0NfTklTVF9QMjU2X05fU0laRSwgc2ltaWxhcg0KdG8gaG93IEFU
TUVMX0VDQ19QVUJLRVlfU0laRSBpcyB1c2VkLg0K
