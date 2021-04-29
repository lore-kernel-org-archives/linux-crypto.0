Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300F7C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC90D61447
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbhD2PXn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:23:43 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:46214
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232989AbhD2PXm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 11:23:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ixzwn6v7aKt1xxcQOQfa/eBnKngBC3+v4CgDT2gM4RKilo74pSO/MiggkiACSe+KnQRgZGFXtwH7TzoBXZI3U7gha2NorC5ZJGKYw1AFsrxNnUM6V3ZQ6ATFYsksUD1cZ6KxlNQI8QZNIKDqr1bmOWg8emjf2GvSRXHCJbIy52tG17O3P7c6armdP9JQpTwn6HzAQVeoNknMen0Q8PcY+6f+8zN86USXGbz10YNrIKDSA0uEX2+BGqZeQ5fIcrwRtW5AB4glSHmgF3Ke/ZBKiqozKRfRVd4FzVcdvgb7jG46Z3+I4knjHvTfwe9GYZhN9MUQMEqNnfZO7cCDi8Zh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1cCO2A+lX6ecM+zjv1WfM3Fr3iIhR6Gw3YRNEPUrZk=;
 b=R2JW3Jo9qb8+gLn1zY8gCSH0GAHv58K7An6qDfoHXyw8K6ryBfP/VuaRnHuy4Qcw4m96Z42oiYoB2QsEtBVFhyqa0duDqexKf3PVeoF8NWXkvINd6CxbLGuqpuBHNPsO3zJh8BX0L63ftUaoRZmX5EzvD2ChpFUaTgohU1DvytUgJMWBM4bdNrcrwjBPTNdgyd5I74dNk2k8bAuctaU5qFFdqOLZ2VMYeDGbuMDBx6V8fcWNjl7Gzt0Cuje/tZGo47Ly+Xf+7PYx5tyLeQtjMhAohKZ+031lBOyq4D0sX70vYas5iH3TR3nMRYTYsRDHBEwwPtM7aaaxrCAh1+Fk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1cCO2A+lX6ecM+zjv1WfM3Fr3iIhR6Gw3YRNEPUrZk=;
 b=U8Ky0R9c0K3A0e2PyN9wqSl/hSRvizf31n/+lHdk815tAFGPAVZizhMHUWWnao3uslEnDod6ufK2c8Fdh+jXWbjfqwbZ+qZrKrGlq2/CK7Bnyxw9ZE7JsgvfbzBO+VXjMwFABylZKE2S76bTTqiynprSMZX6ka0oTmAXBM/Ecr0=
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB4199.eurprd04.prod.outlook.com (2603:10a6:209:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 15:22:51 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 15:22:51 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
CC:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "dominique.martinet@atmark-techno.com" 
        <dominique.martinet@atmark-techno.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v1 2/2] caam: imx8m: change to use of_match_node in
 run_descriptor_deco0
Thread-Topic: [PATCH v1 2/2] caam: imx8m: change to use of_match_node in
 run_descriptor_deco0
Thread-Index: AQHXPQBPQp7syc9+7kmnegummfCQsqrLh0YAgAASmjA=
Date:   Thu, 29 Apr 2021 15:22:51 +0000
Message-ID: <AM6PR04MB60536DF97D12915D5E5A8663E25F9@AM6PR04MB6053.eurprd04.prod.outlook.com>
References: <20210429140250.2321-1-alice.guo@oss.nxp.com>
 <20210429140250.2321-2-alice.guo@oss.nxp.com>
 <CAOMZO5Cbfh3Aj5-i2y+GDZ=-SZw-wLMbPMew=YTcf9Yr6ohVCw@mail.gmail.com>
In-Reply-To: <CAOMZO5Cbfh3Aj5-i2y+GDZ=-SZw-wLMbPMew=YTcf9Yr6ohVCw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b6a604c-4962-47f5-51c9-08d90b22a785
x-ms-traffictypediagnostic: AM6PR04MB4199:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4199889ED6E864A48523D56FA35F9@AM6PR04MB4199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y9BU/wExQeUU6b/V+L+i8uNv0j9sRZrZhwoND7ujb4l73VyxW+ndBhuh5EdiG7hTdyVLV9z0MPwJnhxU5SO+zZOp95lPnbfWTOlccISVr4AayEUT+bqoBjTLrAETxSdZ8EoyESzfj0tWDT1+nRgbmEpUi+t7kk+s5XBdZJx7mV3tILDxXK19XX6owO7a/p2G6stL97MF4dtQPxLSAsKgZabF3mP4X6S2Ny2vQPO/FqNCcHHwS734ZOGkcaeGYDGNSwrUqVHuuR0LDb68nLY6mMFedZI/UoWH5vkBSG42mpkA6++J+r8hp52+QkJ+jmNfSOiqbRZQy9b+MmpGUHow45URLltZnBUupB0hk8zxVB+ycwqQ5K4jFYoe+fqyavlsZoZm8RP1/iazFSh4n4WrpQAoYzLciJAmWM+lt2+iszJsfX6uKfjIaxI1ZeULbojwZ79VaaOCzyuVVcKdZcx6VnkBBVakxjKivpjP1cFlsAv0kogz+lZlp5o6IOCzimf82E/dDiBtC+fr0o64LcEhbmBpVrwDbS4BObZ9PaJg/oyJrccfCjiXTydQk6zG58xfH5xwXtUFnztpQOvN0e/mUeKlFVQfPcsWTF6SrritzvB29prhuwfuMFCwPWehojjzKlTeRsle7vxIujbtJznQVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(54906003)(8936002)(76116006)(2906002)(110136005)(186003)(122000001)(52536014)(66446008)(66476007)(26005)(66946007)(66556008)(64756008)(7416002)(55016002)(5660300002)(53546011)(4744005)(7696005)(33656002)(6506007)(8676002)(86362001)(71200400001)(9686003)(83380400001)(4326008)(38100700002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y3JPNkhxS2VGY3V0STNyY0gzRm02c3VocWxpV3RHNmxhM0tKYWo0TkVKamJ3?=
 =?utf-8?B?VTlaQmo4T0swRjFVTjBoZWRNK1h2U1pucjlGT2k0UHc1dHJUSU9idW54d3B6?=
 =?utf-8?B?VDMxTERxYlpRWmE4YlY0OW9zMlFYNWsxdlY3ZUxHa0tBSVc1bWRwdTNSdzJ1?=
 =?utf-8?B?aFBCWE9IVzZoMU9paFNualdJNDlrSVlMRjF6K1NhMnh3R0wxd0NSNEsxWEZ5?=
 =?utf-8?B?TFlPZEsvQzdFb1RxQlVGeXByQXFzTTYvaHNSeTZxcDE5MHpuZEtNd2gwcEYv?=
 =?utf-8?B?N3NNVVhPL3JpZGJDeGRHdjkrenNLU0JOWmlYVGJCTU9qM2d6OVY3QTdBRjRa?=
 =?utf-8?B?S1FLWkVEaFdPUzNIZXExZHVCaXJSa2Q4bTBSS1pTS0x1WWFRdU1UNU1PWXlP?=
 =?utf-8?B?VkpSamlOb0ZjcXdhaWFjSU1lTTVURFR4VURHUVFaTVJ0S0NiWllNKzArT2gy?=
 =?utf-8?B?bHVpdUFDd3FVU1hMWHNlN01NYnhDdkZOWHdUQ2NCWWN6TkVRaUN2QXhNRTBC?=
 =?utf-8?B?T1dnY2JOSGFzMjU1eEVnM3hZQ05hWVRXdW0rYU5ZbTFibG5aM1Mrb0FZUWVQ?=
 =?utf-8?B?d3RTTzZtdlAya25lSSs1cnlCR1Y5WVFkN2xGZlVJbFlHS1o3bTMxbkltM2F2?=
 =?utf-8?B?YnFhYmQzd1BNTFhsdTRFd090Q2Q5SVl5N0EwRDNkcllkUFBuSnZEcVFRWWRt?=
 =?utf-8?B?SDV6a1p6R0t4WXRxY2FHTnBOaGZiekNodkpKSnFhOWtPTFZwSkZ6OG1ld3k2?=
 =?utf-8?B?MWFSSi9PZ1JnREpwbVhGeEN2Z2lSK0RIZlZEL1dVQmZzOVhNQThNVWxpbmZZ?=
 =?utf-8?B?blVWL1dxSFRjNllzcEdablhSK1ZDOUNHM3NQR2hSOVlBM3kxeWZ2bXNodzRV?=
 =?utf-8?B?cDBQY0ozemRvdnNrN0Z1ZWd3VHBQVlI0U1pvQ24ycHAwc1BRR1J6OUpLL1dR?=
 =?utf-8?B?VVp0eEhnb0Nza2FWQ0NHbVoyNFo2WUhVMTlXVy9SNENaTi9pd0h0VVNhTzRO?=
 =?utf-8?B?U3dEREJDdUNteW5iWVQ1SEFDdjQ1c1JIVC9QMCtTTUpPRlh5a1BaYWxJdEdY?=
 =?utf-8?B?VElwUXZENHlVSUVLQUJZQU1IVUZubHNTbXlwNTUwYW9GQmZmSDNOYmxnRVRa?=
 =?utf-8?B?QjVlcE1mcExrcjg5UmdXSStIM2xoQ29abDJpeU5NMXp2MnFpWnVvZGVEL1NW?=
 =?utf-8?B?VWFwSC9LaFJQVENOLzlISDFZT1k3b0FFL1pocjduUTFYOFN6cWwvbXJkWlZy?=
 =?utf-8?B?eGJYYlAwTXFoY1VyRkcrS3g5a0hlSnBIeTB5MXVXQnZUdks5bzcxNVN6eUhK?=
 =?utf-8?B?ektwdGxGSktoWmhUL1Vya2dVNVpQS3JEVzYxNmZTb3FFdHUyRTZ4QW5nTjFK?=
 =?utf-8?B?c0xNNThlV3hiVWVBclpDWnlPUzdrYnpDMGZyWUdqeGlySzdDQkI2ZzF1UjIv?=
 =?utf-8?B?eVoxbjdsUm1EQVF0Uml2dFJQaUpoVHRyY28wK3JRWFJDUmxZV3V1UWhGZUtD?=
 =?utf-8?B?QUVMTlNOSHhtMi80SGhOSW1aSitFWFFvakRIa0MwZ2J3eEJTa01YMGFzM1k1?=
 =?utf-8?B?cXBYelI1MlVQSGZBT2ovVWVlaEFmRUJrVkIwV3JLaUpBMUVJa2MxcFZLdDIv?=
 =?utf-8?B?UzBHcFRVZC8xWVduZDRWWm5VdEUzNWpDQ1FzTG9qNS9OcEhjOVhMUEs4anpN?=
 =?utf-8?B?NkFPbkRETWJoQzkyNldPd3V6Wi94Uk1xdUJxYmp3TnRMMUdTU3Jjc2RkRkFH?=
 =?utf-8?Q?ZEieNMW5GmVtx3JN8t+6GxCFjy+mBai9SlNuczK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6a604c-4962-47f5-51c9-08d90b22a785
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 15:22:51.5632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dtfpC3vqvCUJ0GAgvU7Artvfy6iElzQaKKtW2/z2H/F3Res9RbCwzy+DrjF3e/FBtqc+vjMO/ECI7am1E8Nzhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4199
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmFiaW8gRXN0ZXZhbSA8
ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0NOaciDI55pelIDIyOjA1DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMi8yXSBjYWFtOiBpbXg4bTogY2hhbmdlIHRvIHVzZSBvZl9t
YXRjaF9ub2RlIGluDQo+IHJ1bl9kZXNjcmlwdG9yX2RlY28wDQo+IA0KPiBIaSBBbGljZQ0KPiAN
Cj4gT24gVGh1LCBBcHIgMjksIDIwMjEgYXQgMTE6MDIgQU0gQWxpY2UgR3VvIChPU1MpIDxhbGlj
ZS5ndW9Ab3NzLm54cC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogQWxpY2UgR3VvIDxh
bGljZS5ndW9AbnhwLmNvbT4NCj4gPg0KPiA+IFBhdGNoICJmaXggdGhlIGJ1aWx0LWluIGNhYW0g
ZHJpdmVyIGNhbm5vdCBtYXRjaCBzb2NfaWQiIHByb3ZpZGVzDQo+ID4gaW14OG1fbWFjaGluZV9t
YXRjaCB0byBtYXRjaCBpLk1YOE17USxNLE4sUH0sIHNvIGNoYW5nZSB0byB1c2UgdG8NCj4gPiBv
Zl9tYXRjaF9ub2RlIHdoaWNoIGNhbiBzaW1wbGlmeSB0aGUgY29kZS4NCj4gDQo+IFNob3VsZG4n
dCB0aGVzZSBwYXRjaGVzIGJlIHNxdWFzaGVkPw0KDQpUaGVzZSBwYXRjaGVzIHNob3VsZCBub3Qg
YmUgc3F1YXNoZWQgYmVjYXVzZSAiZml4IHRoZSBidWlsdC1pbiBjYWFtIGRyaXZlciBjYW5ub3Qg
bWF0Y2ggc29jX2lkIg0KaXMgbWFpbmx5IHVzZWQgdG8gcHJvdmlkZSBkZWZlciBwcm9iZSB3aGVu
IHNvYyBkZXZpY2UgaGFzIG5vdCBiZWVuIHByb2JlZCB5ZXQsIGFuZCBpcyBvbmx5IGZvcg0KaS5N
WDhNLiAiY2hhbmdlIHRvIHVzZSBvZl9tYXRjaF9ub2RlIGluIHJ1bl9kZXNjcmlwdG9yX2RlY28w
IiBpcyBqdXN0IHRvIHNpbXBsaWZ5IGNvZGUuDQoNCkJlc3QgUmVnYXJkcywNCkFsaWNlIEd1bw0K
DQogDQoNCg==
