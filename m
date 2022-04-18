Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C26AC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 14:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbiDROyF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 10:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241826AbiDROxw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 10:53:52 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20072.outbound.protection.outlook.com [40.107.2.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41932CE0F
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 06:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIItNwIPaeH0tj+GsrUaXLV+OcVlqwcJY9wvCn8FYTayAr9CpfI3jqUmutGfmyfdr0Cc8w9A224htaT5Dp1zIbmv5UdJmIiBacOCdI87J7Mx0uxQsL5LcHSjswnDIBRC6/b6SfnoHz1yPzmGtMdQc2+JexHKuZZiJ5/pCbMv+Fvu98/Tsxjf/6iWnfG3XLLdCkckTszcbeMW0IoYxcosP1/SAConJOWMM/R9xHN4ZztLzOc4oG15ghGAfNTuxCEKFrvFJnh9+8Uv9OwBds1mWquYn9QGDJgg2GP+1k8ebZMJH20ECYdUIElMtoVCNwDXmOs3vwP4BAURnfn4vM/pLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yObB1/xT7lPwVDQe3osXH0MEFPR6AC+cdg915f1KQA=;
 b=RSTfSrFG3d0LUxCmLDsBdei3/pDfQ0HIvqDNmWPVen9Wl0Lh6frwpbZHDZQmJQNLp6judRpOVpsCiN/4acwD07TX9FrbUKaxv7xpAxykYFcajH0zQvrd1SN313fAg7AvOO8+NsIW6jQ0aiiAKSWyrTR++57OapBJh8rV1c+phMOSQ4wP/YeDHDVwJR9aMT7ZAW5YejMqpbZiASJL+qZSkbSG+z/9VykpMwcDpbhajiX1LDeYU/lZml7/MxNl8vtV3Qys1CKtYMnZXTcx0zHys2lH5pd+gLU+yXRHH4l/DI5joe9GHytKIraV7AmO4jgFxTSiz9ZsFhW9WYvQbp+oEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yObB1/xT7lPwVDQe3osXH0MEFPR6AC+cdg915f1KQA=;
 b=KiRMijhDiGQnrXNKf5xxist4fMFyNh6ZcOBF1GDX9Ww2ggcgtsAgDSvNrB4z0eZH/ps+iaSm1jUHgxvj8BEHELDvhuvpTNhAGJ6+3exrrijwrUX41nzSJgmtWiBIoS2ZPzUNvbKECXY2OJieFrKFtorhl7qyW2GYuILxY3MKWUA=
Received: from AS8PR04MB8948.eurprd04.prod.outlook.com (2603:10a6:20b:42f::17)
 by VI1PR0401MB2621.eurprd04.prod.outlook.com (2603:10a6:800:57::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 13:40:38 +0000
Received: from AS8PR04MB8948.eurprd04.prod.outlook.com
 ([fe80::5023:4927:e3ef:3c44]) by AS8PR04MB8948.eurprd04.prod.outlook.com
 ([fe80::5023:4927:e3ef:3c44%2]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 13:40:38 +0000
From:   Vabhav Sharma <vabhav.sharma@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>, Varun Sethi <V.Sethi@nxp.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Subject: RE: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Thread-Topic: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Thread-Index: AQHYUZmQg66H5GpCqEmaCXX+FqD/z6zy0zoggAAVCICAAsf3AA==
Date:   Mon, 18 Apr 2022 13:40:38 +0000
Message-ID: <AS8PR04MB89485964ED3248A45D7ADB27F3F39@AS8PR04MB8948.eurprd04.prod.outlook.com>
References: <20220416135412.4109213-1-festevam@gmail.com>
 <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com>
In-Reply-To: <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5719c010-a324-444a-3242-08da21410613
x-ms-traffictypediagnostic: VI1PR0401MB2621:EE_
x-microsoft-antispam-prvs: <VI1PR0401MB262132E680B57182726794B6F3F39@VI1PR0401MB2621.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fp+O1YFSw/f+ia4JU+DhD7iW8b7pM7wEXOTTOkBf6sk4j0C86kzBp3ENUdzPEW85rUAJtYM2ytEqiOQpwBobB/D3jQnERThj/vlA1IUaxqxDRC/a4DFix49crM/tn5VIfJUl38XskiczWWSDb2JeYq26dbvEC7jjcDCtYaY414CZ65XJYD6UNfwPhQ9tmw5Y2Lezh338Kazg5SRU19JLRSLaCbNYU00u5iTGoZQRvrjXUbNXY1qQwrwQTV1T35byWD7O02begsN/TVAE9YqUlTTZ67cOtF8UUqsH+na7zWlfPBGT2aQ6imQ5ZWmCelovz8NnAMA3w5AKwos9YEYLu5Pf7FhHjdqMOYXd2F16O1FUWt0TU4fS3BLXrvnzkY5y1w598YG9aEVBztJyCYLLTVp797t84K/XvUs/lM5eoMIwSYcupPqH3Qyv/OAGFkYZ+7CiIuKi3uvVbvMJ4m08oRfKZ5fTmN8oJIFIJAcvPHRkaPL4uqX2vTBB73RkxYP0EyjEvpNpH5Pe3B5/Npzimy9qm+nHxoj7c/FOinu+erX9BC9wH2WG3zqQLU9zX2W9DWL3AeKqCngQ8cfq9wLRgg00/BAxlsMbI+x2/cDPV5YR0ddLssYqw71Cuj++kGZXKxG6fxNNwZiN8CM5mjQB/3pGDa+1sTZzXShP4EtminEczufmIMZS66DIAk9JzkX57cv13TatpP1cqqX6/3lhew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8948.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(55016003)(508600001)(66946007)(66556008)(64756008)(66446008)(66476007)(71200400001)(86362001)(8676002)(44832011)(52536014)(8936002)(76116006)(110136005)(316002)(6636002)(54906003)(4326008)(5660300002)(2906002)(53546011)(55236004)(83380400001)(186003)(122000001)(7696005)(26005)(6506007)(9686003)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjA1cXJRV2dQT1FrY3doOEo2em1CQTB4cDNrWWY4QlY2S0N3WGhoWXZyaEJo?=
 =?utf-8?B?REtqaG42bDY1Y2ZJT1VTRndKZlNRWHZwZUN3Vm9xZE53Umx5UEhoZzcxMTZQ?=
 =?utf-8?B?cUFDNFZwM3RzRnp3LzdXam5hTTVudnVJNGRDY2tkSlZWSGpBbk5xc29xbnFo?=
 =?utf-8?B?YytDSWYzRWFMOUttUzJrWmR4cjQ2RnZLVXRtWkw5NVpVd2cyTlFMclM0Ny92?=
 =?utf-8?B?eC8ybytHVExyMS9aUTRDOUxyNFJUdFlibXk2WjdGK3B2clpjeHdDQkFva1Fw?=
 =?utf-8?B?OE9tMnJseGtVV3MwWHBqNmJHMWViVXk0SHh3ZTJ0M2xuQm0rTXRuOGszbDBK?=
 =?utf-8?B?N1U5RWZUSW9MdDRHYkZXVDNiMkNIUTNMejJCWjA3UjJFdmg5eVBFRlVRdFpL?=
 =?utf-8?B?OHdnbW90WE45akxUZzRNekVZY1hlNmRYMVIrbXZuVzg4ZkZsZHFYS3MvMlNJ?=
 =?utf-8?B?VUhNQWFEck9sbUhXL1NJU1FIYU1SNWVzNEs1Q0lvb3pUbTZIWkg1SVFuZlFm?=
 =?utf-8?B?ZFJSYk1KVUx5MitVT2laZE96OGRUSEhEdWQ3N3pvTkJOTmcwekdSTWMvRkdX?=
 =?utf-8?B?RzJjTVNHNUg0YUd1Wlppd0szV3diVzBlb1B0aHprbXhmSmVxSkZpRGZ0NndD?=
 =?utf-8?B?aTdJL05jajllOU5EWXhIVW5zaWxDTk8vTTY3am9tNjN5bzVMS1lpU0J3QktH?=
 =?utf-8?B?VXAzSWIrRS9WeWxBRy9sSkFpODFIcG5tbTNSNkpOQXpIL0xnNkJiOG5kOWdM?=
 =?utf-8?B?c0Z0NUtLbWJJT1JiM0RBNmhaSDNsbDhjVGM4NEZacmdVVjRzWE80Ryt4cWF3?=
 =?utf-8?B?VlRvSkN6YkEyTXFSMkgyM1hQL2VTb09FUkFNaHM1TkdINW0vS3h6QkVueXdp?=
 =?utf-8?B?UmlpRHJWYmt4SnppR2UvdEhvNUoxUGJ3QUFsY2x4V21vQUQ5bmNkcStFRjkw?=
 =?utf-8?B?TFNRSEZHcEYraGVUeHZVVkRhYXdlam0yc2RtZ1k5SXFTZ28wMStUR09kT2Vr?=
 =?utf-8?B?ditLT3d2OHEvRSthQU1GbFYrT1RzMzN2bVYwVDhCS0xCc3dXdEtBaDBjTlE4?=
 =?utf-8?B?amtlRldHSHE5eW45Z3hmL1ZzWFNyaUMrY1pKcXRUb2Y5ZzVxNnFadmlEZlRB?=
 =?utf-8?B?SzJNZjR6MitxdnkzVXdQUFR5Mm02d3ZzRHNwdm1yTXRHUGJkcW52U2JHSVZI?=
 =?utf-8?B?RVRpN0lBWVkwY1hYa285QTdLZndvT1VaVXk5MkFQeS8yVjRWMnI4RGlYTzRY?=
 =?utf-8?B?eUE1UVJZcVJZbXJjeDdzelRhQXM1K2s4REJtSWtaVURMT21mZ096Z3hBWHll?=
 =?utf-8?B?cURwRXQ2NDdlNGgxbHRFZWpnKzA4aXBJc1NlVERBZFBoZSt5UFNLMzhFTXlV?=
 =?utf-8?B?STJBZWgxZjkvY1ArU0p0dGVIem1SZXk5YU1VSTJUYmFYaUdyOFg0RmJrQnh6?=
 =?utf-8?B?V0ZNREdmV3NGdUw0cnRrbTdRVHVjV0RkT2lwdU1zWXhFSTRweW50d1p4dWZM?=
 =?utf-8?B?QUM1SzdPc201N3JOOW1YelY4NDJjRm1mUjY5QWVZVG5qSEpRenRpVmMweUNO?=
 =?utf-8?B?SXZHOGR1MjhkTDl6a3ZIUTExODlRV3czQmo3QVM4ZFJ0V1ZvcXpoSzlRZVhj?=
 =?utf-8?B?cDQ2ZGdya2h0a2NxNWFydWdNdncrNzg3dnZpd0tLWjVsY010OU56WTEwZ2Vy?=
 =?utf-8?B?cEhOVmV4OEdtUWhkNEZvRXNCUllsUXpwaGVRSS9yN3B3a3FKdTNKNVBmRXZP?=
 =?utf-8?B?cVBlbXFVSDd2S3U5L053dnZERmdFNk12YUxrRGpMNGExa2UwQ0M4aHBmekpH?=
 =?utf-8?B?UStYdXFzZytnWHVmQURYUWxDYzdic1FoTHcycVZnaWRLcExTWTQ3K3BxTnNK?=
 =?utf-8?B?bS9IVGZJd3hzLzZ6NHRZZVdZVTExZnEyb21qZ2x0bDZmUUZma1E5ZUNUeExx?=
 =?utf-8?B?WGs4NTFNVjVsdjhJa0luZ3RLc0tLOXNrdWdYSnM0NERwcDRmd1FaaWlHTUZt?=
 =?utf-8?B?N04wUjZtZVF2THJCZ0dyZGFpM0ozcHhXaEIzdmI5dE9VK1A3TTMybkFHRlVQ?=
 =?utf-8?B?a0lXQkhaV0h6MXI3QVBWYTRjcmc3UU1JSWp5b0tydjR6MzR2a3RXMWNxdEE1?=
 =?utf-8?B?NmVSZUtKcHZULzVVOWR3aEtyTCs2dlNGUU5MNk5hNCtKWXViYmNzNDlCZU41?=
 =?utf-8?B?U1JkN3JzNFRIVksrYllRekJSMzA4MWJycXhkditWUk1FemoyRWI0OVVVOXl6?=
 =?utf-8?B?bmtFbmN6YUJ0eXJReVI5S0hoVk11SCtrOVRXQUVERHpKM3EzekthaTF4T0Vo?=
 =?utf-8?B?aXNXTUhNdWprQlFBS055bCs5VFkycVh2aVIwN0l0bkZ2dkdJQk54QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8948.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5719c010-a324-444a-3242-08da21410613
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 13:40:38.3765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZTR+lCU1FU72aQiTIpWhSExBtm1G2Y0zKu3dcxW/S1t5IOf544OG1NWCr9f8iBIlaVDxA9i6faMJs7uhzEYdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2621
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmFiaW8gRXN0ZXZhbSA8
ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiBTdW5kYXksIEFwcmlsIDE3LCAyMDIyIDEyOjQx
IEFNDQo+IFRvOiBWYXJ1biBTZXRoaSA8Vi5TZXRoaUBueHAuY29tPg0KPiBDYzogaGVyYmVydEBn
b25kb3IuYXBhbmEub3JnLmF1OyBWYWJoYXYgU2hhcm1hDQo+IDx2YWJoYXYuc2hhcm1hQG54cC5j
b20+OyBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPjsNCj4gR2F1cmF2IEphaW4g
PGdhdXJhdi5qYWluQG54cC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBGYWJp
bw0KPiBFc3RldmFtIDxmZXN0ZXZhbUBkZW54LmRlPg0KPiBTdWJqZWN0OiBSZTogW0VYVF0gW1BB
VENIIHYyXSBjcnlwdG86IGNhYW0gLSBmaXggaS5NWDZTWCBlbnRyb3B5IGRlbGF5IHZhbHVlDQo+
IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IEhpIFZhcnVuLA0KPiANCj4gT24gU2F0LCBB
cHIgMTYsIDIwMjIgYXQgMzowMCBQTSBWYXJ1biBTZXRoaSA8Vi5TZXRoaUBueHAuY29tPiB3cm90
ZToNCj4gPg0KPiA+IEhpIEZhYmlvLA0KPiA+IFZhYmhhdiBpcyB3b3JraW5nIG9uIGEgZml4IGZv
ciB0aGUgTGludXggZHJpdmVyLiBIZSB3b3VsZCBiZSBpbnRyb2R1Y2luZyBhDQo+IG5ldyBwcm9w
ZXJ0eSBpbiB0aGUgQ0FBTSBkZXZpY2UgdHJlZSBub2RlLCB3aGljaCB3b3VsZCBiZSB1c2VkIGZv
cg0KPiBzcGVjaWZ5aW5nIHRoZSBlbnRyb3B5IGRlbGF5IHZhbHVlLiBUaGlzIHdvdWxkIG1ha2Ug
dGhlIHNvbHV0aW9uIGdlbmVyaWMuDQo+IFRoaXMgcHJvcGVydHkgaXMgb3B0aW9uYWwuDQo+IA0K
PiBVbmZvcnR1bmF0ZWx5LCBhIGRldmljZXRyZWUgcHJvcGVydHkgc29sdXRpb24gdmlhIG9wdGlv
bmFsIHByb3BlcnR5IHdvdWxkDQo+IG5vdCB3b3JrLg0KPiANCj4gU3VjaCBhIHNvbHV0aW9uIHdv
dWxkIG5vdCBiZSBiYWNrcG9ydGVkIHRvIHN0YWJsZSBrZXJuZWxzIGFuZCBwZW9wbGUNCj4gcnVu
bmluZyBvbGQgZGV2aWNldHJlZSB3aXRoIG5ldyBrZXJuZWxzIHdvdWxkIHN0aWxsIGZhY2UgdGhl
IHByb2JsZW0uDQpQbGVhc2UgZWxhYm9yYXRlIGFuZCBzcGVjaWZ5IHRoZSB2ZXJzaW9uIGZvciBr
ZXJuZWwsIGRldmljZXRyZWUNCj4gDQo+IFRoaXMgcHJvYmxlbSBpcyBzZWVuIHNpbmNlIGtlcm5l
bCA1LjEwLCBzbyB3ZSBuZWVkIGEga2VybmVsLW9ubHkgZml4Lg0KS2VybmVsIDUuMTAgc3VwcG9y
dCBkZXZpY2V0cmVlLCBEbyB5b3UgbWVhbiBjdXN0b21lciB1c2luZyBrZXJuZWwgd2l0aG91dCBk
ZXZpY2UgdHJlZT8NCj4gDQo+IFRoYW5rcw0K
