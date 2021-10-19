Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08305C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 00:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E196C60EFF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 00:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJTAaQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 20:30:16 -0400
Received: from mx08-001d1705.pphosted.com ([185.183.30.70]:55612 "EHLO
        mx08-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhJTAaP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 20:30:15 -0400
X-Greylist: delayed 5326 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 20:30:15 EDT
Received: from pps.filterd (m0209322.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IItBMf028886;
        Tue, 19 Oct 2021 22:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=Kd9xClHh13aKpa4NoWFRdF7iA39wd2lz+Sbakwiumb8=;
 b=Sd+6oa3x9hX62KbO8vE07hhtNuGRADbXPV1Fw3SGRA+fcnMZBIBUmktryqy4fnGtYNUB
 U7mpeIuZktJGT+rUwlNXeU1JAGNtu5ATwvVChp4OERNk/YKipVlL7jk9AVx0N/o932Ne
 5/+jLx5K4fvrtcHEwcqWtLu6HAedjnBUgH/eIr2syHgAXgLNEm6ROzKDaCaVyq6ZDMpL
 2tJnqgUWlydFipdE2YGAlrWbcOVES9X0sWMJQmE0rcqA3FUiVWFjiJfpKDL2DahBstHt
 iZXFsd/eFFFYndg6KqZX6gPDZj30qAk2k5HRbMgPBK37xVTc3Vv6iJ8tB2aRdjW4PZKx 2w== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx08-001d1705.pphosted.com with ESMTP id 3bsem59v8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 22:54:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQk1dNAIETF2NdqN3UwiLSUCzTW0tnBd30XLkf6cdarlrsxl/rCq/obq0gXLpo8bdQWuxRHB7YJamDKHmt0cHMk0SgY5YImyfffatxr0VpSvwb3nmBs7jbph38HPYLGS7c7jlp4Cc4Ysii6CskHjKDc7jpNZg8/fIXmcSL8WiFmuyUG5pAGTdK4fDhS4YdQvDPKOB/pepxhaFLcAYxN97Y5Xd0sNkbGFTW17NnZVk/xIIvXLVCpQIl9TMubnZc4KeYUUDTOTYgjE+mwAE3QzWziDUVq5Cz6QNinem4cOTby0DZKTHNx1b+EloD71VuAKNsuDa1OXC9gB8qEEAa8Kig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kd9xClHh13aKpa4NoWFRdF7iA39wd2lz+Sbakwiumb8=;
 b=i4ZTVYENU/e5rkzJq7VFkrQRPELLkuV6imbHTfleNkeRR4xjDfLpwidmkTE+YGDj2a4rbC01d24rjdzucwqOK40DaHOlmsrFjUCVJiCHWOIP02eN4FhVbQgYHOf/q0oNWKHn1FO8XbcwmQNjv//vkaP3UBsihX4F0SZnrEN0lextOafUqq+757pvGi1sBfbG3ppgVMPW1BH1r40mZyUQm7y0cusJ9xQUcBk1+wSQYqXE+sVzGW7bjwDL5GY/al+ZE0yGcz7dsGiORPj3bTYMVC8CerqE/AWPNUXpJNGVKY235wMQitZnacGAR9JPIq6xIHwr8r+TLOND6iAWTirfFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BYAPR13MB2503.namprd13.prod.outlook.com (2603:10b6:a02:cd::33)
 by BY5PR13MB3892.namprd13.prod.outlook.com (2603:10b6:a03:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.9; Tue, 19 Oct
 2021 22:54:01 +0000
Received: from BYAPR13MB2503.namprd13.prod.outlook.com
 ([fe80::f544:a41:f814:7be9]) by BYAPR13MB2503.namprd13.prod.outlook.com
 ([fe80::f544:a41:f814:7be9%6]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 22:54:01 +0000
From:   <Tim.Bird@sony.com>
To:     <khilman@baylibre.com>, <geert@linux-m68k.org>,
        <laurent.pinchart@ideasonboard.com>
CC:     <dwmw2@infradead.org>, <tbird20d@gmail.com>,
        <u.kleine-koenig@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <paul.gortmaker@windriver.com>, <linux-embedded@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <kernel@pengutronix.de>, <mporter@konsulko.com>,
        <tglx@linutronix.de>, <thomas.petazzoni@bootlin.com>
Subject: RE: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
Thread-Topic: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
Thread-Index: AQHXxGWUs+erNOaWfEyZnGCDp7FTs6vZ49uAgAAsAgCAAAPiAIAAAp4AgADQ6ACAAAIHEA==
Date:   Tue, 19 Oct 2021 22:54:01 +0000
Message-ID: <BYAPR13MB250310153BF63EF3ED50F294FDBD9@BYAPR13MB2503.namprd13.prod.outlook.com>
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
 <YW5r61ZQx+E9xfuH@pendragon.ideasonboard.com>
 <57122a67509bebdf0d1b9f5bc15db116e0124e5d.camel@infradead.org>
 <YW6UGP10hfGJ2kYy@pendragon.ideasonboard.com>
 <CAMuHMdVCrC5_AjNDJN+nwrnn=EVTfD-8ddG=FaFBBh_0UY5acQ@mail.gmail.com>
 <7hlf2oejqv.fsf@baylibre.com>
In-Reply-To: <7hlf2oejqv.fsf@baylibre.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: baylibre.com; dkim=none (message not signed)
 header.d=none;baylibre.com; dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9ac43e3-76b5-4f98-dfe6-08d9935357df
x-ms-traffictypediagnostic: BY5PR13MB3892:
x-microsoft-antispam-prvs: <BY5PR13MB389212454509A7F33271B47AFDBD9@BY5PR13MB3892.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MSTrZkdZWSRGJqqt8yFBHmzCM29QFe3ia4iG9LFDHXHzPfE5cz7gbPQW5YkUUYWtn6QWBPs1O8c30MB2XpF+ge5R8pqJZG3r3ik6Dy0PQqUwxMXa5NReps01IpuDhcYdD/Qg05WqBSTXSnzWCPOyJryijgC3yvBo/LwVBtOjHagoROR3xKQyFFUUSeleuELzPzsBQS8ZOcI789t5vLsNRcbfhhqZ6fcHouiUDwLTFEV2siL8cY1lKIpzsTUEFaltBS+ybf1Hq43uWVdZTb7/R3Xw+QhjtTO5A9UlTRWZyGE5iLQ2tOksPbyQ02ojWfImYKFK3AIsTHClxktU9VXsTqhvaqtRL2W4ugtUBA7eMwLWzoAb8FTSZQUE3Rm6qNf3KePGvr8bgmhz5itqKkQ1J390qX8hbkEmy3CS4If7B4960Om6mI6jjH1xvPA5o6ibH/ihDWn6EztoGXmcUBXj/v8Sg/IhDZDD2BX99C/zbM5LdWrgVw100zXXO1r6QxBmhYRUeTiaYXn9sTOETdyD7WRl5/JhkrKZmbdRTk/jMNcBzhw7UK/z/xywJ8Y/rh7c0qIFquftizSL3LVWsJn3cKubYiP+eHk746tfXTNZTggaOtxF2g3onPmfW9ZdKyywRYPPPx6TYpwYQcUIX+XlH90kSFYs0mNuULFiz4DBJW+T0GYz5p+gK0Sx+Y05EiPnVmpMrSnyfQCksXw39ILo3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR13MB2503.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(110136005)(38070700005)(54906003)(4001150100001)(8936002)(9686003)(86362001)(508600001)(71200400001)(8676002)(55016002)(33656002)(4326008)(5660300002)(26005)(52536014)(7416002)(186003)(6506007)(66946007)(7696005)(76116006)(66476007)(83380400001)(66446008)(64756008)(66556008)(2906002)(53546011)(82960400001)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnpBcWFVL1BWTlJ2UjR1blFmdGI1aWZDRnd4WUsyMEV1QjZWNGovVWNxeDJ6?=
 =?utf-8?B?V3JHQ09vVHFqNVVVeXhzV1gxVzllOUlOdEhxdW1UeVQrVmxlR3lKQ212S3Ni?=
 =?utf-8?B?UW9aNVhBNVZIYXA4dmMxYlMwcmRMSnBnbVlWemRlSWp5Q255dFJsOUQ2S3N5?=
 =?utf-8?B?bVN2Wm1nL2pUS0J5cVNOb3I1TzM1ZnhEdHhYNFkxbE9CZTFHS1dyQU0yNFp4?=
 =?utf-8?B?Rm9sMVJGbjdHOFc5T2FPdlFsK283WGYrT1Y2YUZ6L2xSWE9nd0xjMDNQOWdz?=
 =?utf-8?B?SC8rRHU0eDBNcEVSQ1RmaTBYUzhrK2IzZDlzVU9SaVZSdUFyWXI3T0JMbjJt?=
 =?utf-8?B?M0xUZmFHcTROejBsaytEWHArQ2kwUVlJamtIN1pRSkVFa00yRWhuUU1UcDVU?=
 =?utf-8?B?M1F6ZFFPVEorcUZGdmhLNWs2Y3FIZi9sNHFrcnNJakkwR2NiTHdWRzVhLzIv?=
 =?utf-8?B?eFdhNmlHaTJPcitoWWt1U1FSMWFFblIvUFRwRXhnWUp4eDVFcFFPbG41RUYz?=
 =?utf-8?B?NjZSWTI2NXNTSkJxK1NGMzR0d0F1K1AzbEhscXJJZ2dVZ2NYcjZScjZnQ0N5?=
 =?utf-8?B?ODU5NkdzQWdVYjhMWVBtL3ZPa3Y2TFRZMjFJaC82MGI2TjRxdE9Jb2R1K0p6?=
 =?utf-8?B?MW9iT0h5dzl0RGxLSUh0R3hsTndCOThkYmIvVWp6WmpkRHNjSG1NY1dBQnpE?=
 =?utf-8?B?STJadlI2YldjUzZ0YVA1a0ZQYUFzK2dHVEYxWmhmL3FaYzAwK2dHMSsvZDhC?=
 =?utf-8?B?Z2JJcDdaWDVxN3J5bU1QL2t0V3RaQU5zaGh1bGVuWkJqR1gvbmZuRmJMNyta?=
 =?utf-8?B?SzZZSUJacUxiUEI2U05RNGE5Um00d2RvdXUwRUhmUmNtVzVHS0pRS1NhOWNE?=
 =?utf-8?B?MjVIdWErQk03bDlsbmFKRkRRN3ZsTHgxTjZ2SUxNQ1RkZ2wxeG1tMmpxZGJV?=
 =?utf-8?B?aWlRTEpjTzE3WTNoQ2xSUGljSi9Xc3N1MDhaM3p3TDJ6OHVpSXZUYnh6Uk0y?=
 =?utf-8?B?UWJkbEEvSGZpMUptSk42OWJKRXk4UFdPOGZJWkw2Z01kS1p0b2daVTdBUXBD?=
 =?utf-8?B?dkJQRkhKVWNhVDVueVZFYnhhMkV2TEs5Y1hjVHVNQ21QekovTWtYb3p2QTMv?=
 =?utf-8?B?aG9vdkNqYnZkaGpPMTI2MXZXclFDVFBQa2xVWS9ibVVOL2hLZHY3eHJhdThV?=
 =?utf-8?B?ckdiSnlrcVdwU1NoVlRkaE9jdkJKZTE3Skl2STRFZ3hBRFdlQ1JpVVBiVXVS?=
 =?utf-8?B?ZCtWdW5XbmRZNm5DU1dpdTNxWVlOYkhaNHQySXJiaVRTUnV3ZUg4WFE3emJR?=
 =?utf-8?B?anZ3czZGVjhoa0RSODlKMHB3VWFHNWpRdXhWN2lDN09XTUdRV0NpaXBFMmhU?=
 =?utf-8?B?bFhCRHRTMkM5L20vWTJmdG5QaEhlWmZuWGFDcE5pSzErWVUyZlkwbTgwUDRH?=
 =?utf-8?B?SlhLcFUzcFBMc3pvN2lBSUUxdHZSYnV6SDMwT1dNYjdTTktINCtqemFOTWxN?=
 =?utf-8?B?eEVtM0pyUG4rRzBDd25jeXQ3dTRFWWtGeXhiRllXbHNnYnlIVzlNdXRLYjJ4?=
 =?utf-8?B?TzdMbys3OTVhdXNoOXZvN09ESjRVdlpLU2lsVm5xcUZ4WmZRUVAzMUwwVDRG?=
 =?utf-8?B?a0x1QkcwbVdqUk1JMEhlY3Aza2wwaVNmUHM2aExUbGt4VzB1RmxlVEQzTVp5?=
 =?utf-8?B?Wm84dUV1eitXK0VGU0MwWWkrQWl3TmVpWTNTRXYyeTd2cVdVQUJORFZrV0JI?=
 =?utf-8?B?a2p5RXEzQmUyWVVNUTQrK0xzTVR0NS8zZzZQUk9OUkNHYWRTYXJlVWJrbk12?=
 =?utf-8?B?QnBSVW42T3dMcEpHcG5BWWRsRm0yTkk4b2t2RHFQSWZySnJGanV1c2orOThC?=
 =?utf-8?B?ZHE5cDJTNHNiRGNmL3ZuM2dWR1BxQWszeGJBaGF5cGV1YXJvOTNOdmZaUEha?=
 =?utf-8?B?TUxrU0RHNVJGeHFEQ1d1eE1NOXh2Tkw0dnZoV1Y4dFBCR21RS3pHM2JKUUxO?=
 =?utf-8?B?NGFKbW9MWEJzamxIZ2ZOaG5Sa2dQTG0wTlhTRWtNdEVqdTFSakFVZnhMVmR3?=
 =?utf-8?B?d2pmeW1aeE15SWxoQmpsYnFQNndoYituZjdPUW5oRVNMMEl2dTRvSWxKQ3Zi?=
 =?utf-8?B?aTF0OVZmNzhhbTZPV2RYSFlZVmljNzhPY1EwZzhFMllqclZOaUI2S3VLMFpu?=
 =?utf-8?Q?u4gXW8aLAuKGg6lLy/itEu8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR13MB2503.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ac43e3-76b5-4f98-dfe6-08d9935357df
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 22:54:01.4514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y8hGCJIg/1RimghQTgwvCqkQQceWnKAL0ZdD6SESs3zExbSjfMnm44LuBnewsZCN51QVWnkLskZxx335BUTsRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3892
X-Proofpoint-GUID: Nz8b2ILGA-NWdobFj4PoCSHDalMSQjLs
X-Proofpoint-ORIG-GUID: Nz8b2ILGA-NWdobFj4PoCSHDalMSQjLs
X-Sony-Outbound-GUID: Nz8b2ILGA-NWdobFj4PoCSHDalMSQjLs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190131
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLZXZpbiBIaWxtYW4gPGtoaWxt
YW5AYmF5bGlicmUuY29tPg0KPiANCj4gR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1t
NjhrLm9yZz4gd3JpdGVzOg0KPiANCj4gPiBPbiBUdWUsIE9jdCAxOSwgMjAyMSBhdCAxMTo0OCBB
TSBMYXVyZW50IFBpbmNoYXJ0DQo+ID4gPGxhdXJlbnQucGluY2hhcnRAaWRlYXNvbmJvYXJkLmNv
bT4gd3JvdGU6DQo+ID4+IE9uIFR1ZSwgT2N0IDE5LCAyMDIxIGF0IDEwOjMzOjEwQU0gKzAxMDAs
IERhdmlkIFdvb2Rob3VzZSB3cm90ZToNCj4gPj4gPiBPbiBUdWUsIDIwMjEtMTAtMTkgYXQgMDk6
NTUgKzAzMDAsIExhdXJlbnQgUGluY2hhcnQgd3JvdGU6DQo+ID4+ID4gPiBPbiBNb24sIE9jdCAx
OCwgMjAyMSBhdCAwMzoxNzoyMlBNIC0wNjAwLCBUaW0gQmlyZCB3cm90ZToNCj4gPj4gPiA+ID4g
SSB0aGluayBhbiBvdmVyaGF1bCBvZiB0aGUgIkVNQkVEREVEIExJTlVYIiBNQUlOVEFJTkVSUyBl
bnRyeQ0KPiA+PiA+ID4gPiBpcyBsb25nLW92ZXJkdWUuDQo+ID4+ID4gPiA+DQo+ID4+ID4gPiA+
IE5vIG9mZmVuc2UgdG8gYW55IG9mIHRoZSAzIHBlcnNvbnMgbGlzdGVkLCBidXQgSSB0aGluayB0
aGUga2VybmVsIGRldmVsb3Blcg0KPiA+PiA+ID4gPiBjb21tdW5pdHkgd291bGQgYmUgYmV0dGVy
IHNlcnZlZCBieSBhIGdyb3VwIG9mIGluZGl2aWR1YWxzIHdpdGggYSBtb3JlDQo+ID4+ID4gPiA+
IGN1cnJlbnQgYWN0aXZlIHJvbGUgaW4gZW1iZWRkZWQgbGludXguICBJIGhhdmUgYSBmZXcgbmFt
ZXMgSSdsbA0KPiA+PiA+ID4gPiB0b3NzIG91dCBmb3INCj4gPj4gPiA+ID4gY2FuZGlkYXRlczog
TWF0dCBQb3J0ZXIsIEtldmluIEhpbG1hbiwgVGhvbWFzIEdsZWl4bmVyLCAgVGhvbWFzDQo+ID4+
ID4gPiA+IFBldGF6b25uaSwgTGF1cmVudCBQaW5jaGFydCwgYW5kIFV3ZSBLbGVpbmUtS8O2bmln
IChhbmQgbWF5YmUgZXZlbg0KPiA+PiA+ID4gPiBteXNlbGYpLg0KPiA+PiA+ID4gPg0KPiA+PiA+
ID4gPiBUaGlzIGVudHJ5IGluIHRoZSBNQUlOVEFJTkVSUyBmaWxlIGlzIHNvbWV3aGF0IHNwZWNp
YWwsIGluIHRoYXQgaXQNCj4gPj4gPiA+ID4gY292ZXJzIGEgImZpZWxkIG9mIGVuZGVhdm9yIiBy
YXRoZXIgdGhhbiBhIHNwZWNpZmljIHNldCBvZiBmaWxlcyBvcg0KPiA+PiA+ID4gPiBkaXJlY3Rv
cmllcy4NCj4gPj4gPiA+ID4NCj4gPj4gPiA+ID4gVGhvdWdodHM/DQo+ID4+ID4gPg0KPiA+PiA+
ID4gVGhhbmsgeW91IGZvciB2b2x1bnRlZXJpbmcgbWUgOi0pDQo+ID4+ID4gPg0KPiA+PiA+ID4g
SSB3YXMgaW5kZWVkIHdvbmRlcmluZyBhYm91dCB0aGlzIHBhcnRpY3VsYXIgTUFJTlRBSU5FUlMg
ZW50cnkuIEFzIGl0DQo+ID4+ID4gPiBkb2Vzbid0IGNvdmVyIGFueSBwYXJ0aWN1bGFyIHNldCBv
ZiBmaWxlcywgZGlyZWN0b3JpZXMsIGRyaXZlcnMsDQo+ID4+ID4gPiBzdWJzeXN0ZW1zIG9yIGFy
Y2hpdGVjdHVyZXMsIHdoYXQgZG9lcyBiZWluZyBsaXN0ZWQgaGVyZSBlbmRlYXZvdXIgPw0KPiA+
PiA+DQo+ID4+ID4gQmFzaWNhbGx5IG5vdGhpbmc7IEkgd2FzIGdvaW5nIHRvIHN1Z2dlc3QgcmVt
b3ZpbmcgaXQgZW50aXJlbHkuIFRoZXJlJ3MNCj4gPj4gPiBjZXJ0YWlubHkgbm8gcG9pbnQgbGlz
dGluZyBtZSB0aGVyZSBhbnkgbW9yZS4NCj4gPj4gPg0KPiA+PiA+IE9uY2UgdXBvbiBhIHRpbWUg
aXQgaW52b2x2ZWQgYSBjZXJ0YWluIGFtb3VudCBvZiBoZWNrbGluZyBhYm91dCBtZW1vcnkNCj4g
Pj4gPiB1c2FnZSBhbmQgInlvdXIgaGFzaCB0YWJsZSBkb2Vzbid0IG5lZWQgdG8gYmUgdGhhdCBs
YXJnZSIgYnV0IHRoYXQgc2hpcA0KPiA+PiA+IHNhaWxlZCBhIGxvbmcgdGltZSBhZ28gOikNCj4g
Pj4NCj4gPj4gSGVja2xpbmcgaXMgc3RpbGwgYW4gb3B0aW9uIHdpdGhvdXQgYSBNQUlOVEFJTkVS
UyBlbnRyeSBJIHN1cHBvc2UgOi0pDQo+ID4NCj4gPiBEb24ndCB3b3JyeSwgSSBrZWVwIG9uIHNh
aWxpbmcgOy0pDQo+ID4NCj4gPj4gSSB3b3VsZG4ndCBvYmplY3QgaWYgd2Ugd2VyZSB0byByZW1v
dmUgaXQuDQo+ID4NCj4gPiArMQ0KPiA+DQo+IA0KPiBBZ3JlZWQuICBMZXQncyBqdXN0IGRyb3Ag
dGhpcyBlbnRyeS4NCg0KV2VsbC4uLiBMZXQgbWUgZ2l2ZSBzb21lIGhpc3RvcnksIGFuZCB0aGVu
IHBvbnRpZmljYXRlIGEgbGl0dGxlIG9uIHRoZSBlbnRyeS4NCg0KT3JpZ2luYWxseSwgdGhpcyBl
bnRyeSB3YXMgY3JlYXRlZCBhZnRlciBBbmRyZXcgTW9ydG9uIGdhdmUgYSB0YWxrIGF0DQphbiBl
YXJseSBFbWJlZGRlZCBMaW51eCBDb25mZXJlbmNlLCBzYXlpbmcgdGhhdCB0aGVyZSBzaG91bGQg
YmUgc29tZQ0KIm9tYnVkc21hbiIgZm9yIGVtYmVkZGVkIGlzc3VlcyBpbiB0aGUga2VybmVsLiAg
VGhpcyB3YXMgaW4gMjAwOC4NCg0KVGhlIGxpbnV4LWVtYmVkZGVkIG1haWxpbmcgbGlzdCB3YXMg
Y3JlYXRlZCBhYm91dCB0aGUgc2FtZSB0aW1lLg0KVGhlIHRoaW5raW5nIHdhcyB0aGF0IHRoZXJl
IGFyZSBpc3N1ZXMgdGhhdCB0cmFuc2NlbmQgYW55IHBhcnRpY3VsYXINCnN1Yi1zeXN0ZW0sIGRp
cmVjdG9yeSwgb3IgZmlsZSwgc3VjaCBhcyBib290IHRpbWUgb3Igc3lzdGVtIHNpemUgb3INCnJl
YWwtdGltZS4gQ2hhbmdlcyB0byBrZWVwIHRoZXNlIHN5c3RlbS13aWRlIG1ldHJpY3MgaW4gY2hl
Y2sgbWlnaHQNCm5lZWQgdGhlIGFzc2lzdGFuY2Ugb2YgYSByZXNwZWN0ZWQgdXBzdHJlYW0gbWFp
bnRhaW5lciwgd2hvIGNvdWxkDQpndWlkZSBkZXZlbG9wZXJzIHdvcmtpbmcgaW4gdGhlc2UgYXJl
YXMsIG9yIHdobyBjb3VsZCBoZWxwIGtlZXANCm90aGVyIGtlcm5lbCBtYWludGFpbmVycyBhcHBy
aXNlZCBvZiByZXF1aXJlbWVudHMgaW4gdGhlc2UgYXJlYXMNCmZvciBlbWJlZGRlZCBwcm9kdWN0
cy4NCg0KSSB3b3VsZCBzYXkgdGhhdCByZWFsdGltZSBoYXMgYmVlbiBzaGVwaGVyZGVkIHByZXR0
eSB3ZWxsIGJ5IFRob21hcw0KR2xlaXhuZXIgKGFuZCBpdCdzIGFsbW9zdCBhbGwgdXBzdHJlYW0h
KSwgaW5kZXBlbmRlbnQgb2YgdGhpcyBlbnRyeS4NClRoZSBvdGhlciBzeXN0ZW0td2lkZSBpc3N1
ZXMgKGJvb3QgdGltZSBhbmQgc3lzdGVtIHNpemUpLCBwZW9wbGUNCmhhdmUgcHJldHR5IG11Y2gg
Z2l2ZW4gdXAgb24sIGFsdGhvdWdoIHRoZXJlIGlzIHRoZSBvY2Nhc2lvbmFsDQpwYXRjaCB0byBh
ZGRyZXNzIGEgbWljcm8tc3ltcHRvbSBvZiB0aGUgcHJvYmxlbS4gIEJ1dCBubyBvbmUNCmlzIHJp
ZGluZyBoZXJkIG92ZXIgdGhlIGVudGlyZSBrZXJuZWwgdG8gbWFrZSBzdXJlIHRoYXQgaXQgZG9l
c24ndA0KZ2V0IHRvbyBiaWcsIG9yIGJvb3QgdG9vIHNsb3cgKG9yIHVzZSB0b28gbXVjaCBwb3dl
cikuDQoNClRoaXMgZW50cnksIGFuZCB0aGUgbGludXgtZW1iZWRkZWQgbWFpbGluZyBsaXN0IGl0
c2VsZiwgaGF2ZSBub3QNCmZ1bmN0aW9uZWQgYXMgb3JpZ2luYWxseSBpbnRlbmRlZCBpbiB5ZWFy
cywgYW5kIEkgZG91YnQgYW55b25lDQp1c2VzIHRoaXMgaW5mb3JtYXRpb24uICBUaGUgdG9vbHMg
ZG9uJ3QgdXNlIGl0DQooZS5nLiBnZXRfbWFpbnRhaW5lcnMucGwgaXMgbmV2ZXIgZ29pbmcgdG8g
dXNlIHRoaXMgZW50cnkgdG8NCnJlY29tbWVuZCBzb21lb25lIGJlIENDJ2VkIG9uIGFuICJlbWJl
ZGRlZCIgcGF0Y2gpLg0KDQpTbywgSSBndWVzcyBJJ2Qgdm90ZSB0byBnZXQgcmlkIG9mIGl0IGFz
IHdlbGwuDQoNCkJ1dCwgSSdtIGEgbGl0dGxlIHNhZCB0byBzZWUgaXQgZ28uLi4gOi0oDQpJJ2xs
IHByb2JhYmx5IG5ldmVyIHNlZSBMaW51eCBvbiBhIGNlcmVhbCBib3guDQogLS0gVGltDQoNCg==
