Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51BBC43334
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jul 2022 08:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiGDI1b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jul 2022 04:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiGDI1a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jul 2022 04:27:30 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C5D9585
        for <linux-crypto@vger.kernel.org>; Mon,  4 Jul 2022 01:27:29 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 263N18Pi005807;
        Mon, 4 Jul 2022 01:27:15 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h2nhnmsq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 01:27:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4LAQYVGqRFq3WiJ6h3FKHErARyU63ipSjGHTgUFbdLztNHCwZD7qmQzB6G1dF2pAHDwE2NQ/euS7Kk4qKHDel/Mql36osuT53ANx8m8T96BvV9+haGj3GLYk90G2TD+dVCvyTQqC6xU8Fvcal7K/BW1CtVf3jBEyNZa7NghUhtuj045tR/8hybb79PrDQJVdpexLkSwDL6YmbqzjFEM8sBCe/EmlLFnTCi0D6wAVCfqvcAMNCyJ1RwEeP+1QLrvclzl1oqyCK3oDYswVERTrspji2gltURVEEOC5ZMptVqzklCFWTlMlu57700J1hyFvkLCbeRYEnETGAdU9ONhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t64lxPPoQg9MJKNE+NVEu6ZEIz3uSsJEliNSLZhXSdE=;
 b=kPu2M64tVp05P2FNBnmK2IwAbGJSo/F1HgjkOwCbLoeWePDOAYfElCopO+AvtOn4LZDzLa4Tg1QrcYlUrLIGlTabXCG/+xY17YSpMQVaweNlhharhnNikw4fFlPM1P7KTOnP1A+ny9O5aWMssMAfdoYkoFXhT+msUHGuYR/4oujgu+4G9aOmWGitJ58a8TD/d1Dp7/q1uzAWzjsLznSs7h8TThf0uoroIgcqy4I+KoUxInaVP7wDdGwzmGTRhIKN5ueyLz+psOZoFMUWSaqDhXaKpru7fGG8ihFePwkQu99jLwt77ByGzRwimdvRVMeXsnOQRkOJDx82MQXMZirsQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t64lxPPoQg9MJKNE+NVEu6ZEIz3uSsJEliNSLZhXSdE=;
 b=r07nlK5S1HgRyjFo8Nw+9f3JQmNRcYeJXv+Tum6FxeL10DiCw+TjkCBO5NTemIJqwaU3M5ht2ndsqad3nc+COT8tM2wXmSYGeVc/rf8bvQ3aRRwTNh+ljRpMDyrFFC8vILLtakLzqCjforA/7cnQZsCYQLX0g+6K04E4+OBBRjk=
Received: from BY3PR18MB4723.namprd18.prod.outlook.com (2603:10b6:a03:3ca::15)
 by BL0PR18MB2322.namprd18.prod.outlook.com (2603:10b6:207:4b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 08:27:13 +0000
Received: from BY3PR18MB4723.namprd18.prod.outlook.com
 ([fe80::7dcc:20a2:fc5:e0ac]) by BY3PR18MB4723.namprd18.prod.outlook.com
 ([fe80::7dcc:20a2:fc5:e0ac%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 08:27:13 +0000
From:   Ofer Heifetz <oferh@marvell.com>
To:     Antoine Tenart <atenart@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] crypto: inside-secure: fix packed bit-field
 result descriptor
Thread-Topic: [EXT] Re: [PATCH] crypto: inside-secure: fix packed bit-field
 result descriptor
Thread-Index: AQHYj3dlwRDefFGyD0KZEw3H6HwC9q1t0s6g
Date:   Mon, 4 Jul 2022 08:27:13 +0000
Message-ID: <BY3PR18MB4723EE02C3ACD6986188023DAEBE9@BY3PR18MB4723.namprd18.prod.outlook.com>
References: <20220702071426.1915429-1-oferh@marvell.com>
 <165691958960.3764.6967842126015044710@kwain>
In-Reply-To: <165691958960.3764.6967842126015044710@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddd0c19e-be58-4842-264b-08da5d96ff1b
x-ms-traffictypediagnostic: BL0PR18MB2322:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ykSKKeDI4HJStcqSqtG66mpIBGaZ9KLMcDw/Plz/rrjvwM38HS/Lo1oxYJ76sR/tnA0iCf/st7FI4Ar0cLrKCawp33wfgpgi0RsfqMcuydCrlHWUoFDCQRoAzqnqoS8kpLZuArNfW7reM6Y/aDQXXtijLLRMFMtog7kFHMyK1inPXVBeBOXB0g8xI5oMorPDzKe0wj7rfSyuzmgMPO/mdLTp/0cSh7TqJ3WulOMop/rMQOjZ0Gp4FqofJWH0j72zIVlpTo5J63kJ0WmUecMO1iEUzkn0r7xRTrvzfvS6dFnIxsFB+P5KDfoDTM1UeXK7QQ/6+o0JLwFsc0SOINChz5Ld+OeqP0ORV655IloUCeVjeU1N/vaYyjk8RGYUcaWtLb3BVtqjN+FwgWXzcq7Fwb9J+i5yn9GkXIkktlfH9yw34y8qGNu8ZM8NnrJqpXOcWe+47GvhvxnbhR3v+I5OwbQ+59yv+v7qqiwX7GOADUzC3ewq9KoOHpTArzZMzrLEdd713cKeUZkbTas9kD4V96cw1DzkdIXaNEolob2gffM+Dw/NRQTmXEOknw8NHrQkpWz2ZjToQOATtAjEpmqYM0qb0bx/MrhKnLsHcsql/LZEeRF9CmulQWDozgluFxvTArb9MYpLyNho88UCeDttXOvJYql/TLfML/2ctqhsk4LNz4v1/8N+mNKFeCupxT0Yn4O/y0LPds8LNW4dF3YF6dgbNKIYBN31bgRXx62/hs1BeLT4lVJnRNgjvVZX/z05uREHBpfpkVE3a3RNt3pXKeQxLg/iWDE21HKM9wfO9NW7KF1VJRIj9knDdmDJM43P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4723.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(8676002)(316002)(76116006)(66946007)(66556008)(6506007)(110136005)(478600001)(41300700001)(66476007)(66446008)(64756008)(71200400001)(7696005)(55016003)(8936002)(5660300002)(2906002)(38070700005)(52536014)(38100700002)(33656002)(86362001)(122000001)(186003)(26005)(9686003)(53546011)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkpRaWQzTXBBZGg3T0dQdkRZVFJWK0daSkpCc2pzTGIwVVRaclF3cmI3dS9s?=
 =?utf-8?B?VzFRdVJnLzFIYXBDN2xqNFIrYmpwb3JDM0g5K1NqSFhaZzcvdWNoVmpXendr?=
 =?utf-8?B?eGlnMXJYSmN3NS9QM3c4dGQyWlppclI1T1ZEVmY5blVHVncrNVFCakI2dUVH?=
 =?utf-8?B?TS9weTY4enYxYUFVUWxsaDdTa1JFV1Z2b0lSdFJObFA4SmMrTld3eENndXRT?=
 =?utf-8?B?Q1F4Zm0xQzZpbkx2Y0NBVURtWlczdmlGWjdoMGx3amp0RGpxY2NsL1o5Y1VH?=
 =?utf-8?B?Z3RQN3JZRnRLcVZUMjg5VENGUHpocVFJY01YVjN5QWxpSnZBKzZuR0JBaERm?=
 =?utf-8?B?aU9vUEZYdVlxdTgrSmY1SWgwcFZOZGJpOWRDZlNJRGFFaHlIY29OWmZGWjZ3?=
 =?utf-8?B?YnVxT2tCa1dldFBwVzNzVnpYVWl1a0pyZzdWY01GdncxenhLc2VQV09OVWJm?=
 =?utf-8?B?RHFJaTJBU3FwSWtBODdJaTNsOUp4UTBJRlNvT25YNUMvZ1p0YjBDQVR6T09R?=
 =?utf-8?B?U082ajVuMGJqY0lCck9OMDBHdXo0S2pGSWtaWG43WmNDSExCNFBFRlBvVDll?=
 =?utf-8?B?RmNmTXRSTEFIdmVtb2l0S3FRb3hjMlBGVGFqeno5VWgzVUFldVZoTW1tNU9n?=
 =?utf-8?B?Sjd3dkdQYXA0RHkrdEZ2RDRCUW5rdFdXanVZWWFveWsrS0RyWWsvMDVBY0dP?=
 =?utf-8?B?elZIUldsRjh2WENWMU50RlU0aVdQWFgwcStrS1o0TFlSMUhTSWJkd2FKYjg5?=
 =?utf-8?B?TlhQbHV0Z3duK2w4YjRjNU1DZFlsZWVIQmVmb2M0UEVtbS9NS0VKNTU3ZWdl?=
 =?utf-8?B?bzNicXJXVCtlSXNNVFZRWkpsaFVVWGZQL0dHdllLT20wVlVFcW5LMXFKOThD?=
 =?utf-8?B?Q0IxLzhSV0NVZnE2NUR6SkxkNmYvbFlrS1lzVjgwNXRnVEFHWFo4UVZFOFhL?=
 =?utf-8?B?eG5VOERRalpleStRWGhma2ppNlJ6aUZaTmkxdFNhS3pDYjlKYnVIb2dEZjgz?=
 =?utf-8?B?bmYxUklBdEJ3bktwdHFiTWJzcnBWQnFGUEQ2ZGk2S2JPYU4vQnZxVmxodG1U?=
 =?utf-8?B?ajFHYmhSMmh1SDdkeEtXMFZvanhnZDdmcTMxV0RsRU5QSzh5YTg5ZGJocGd4?=
 =?utf-8?B?RytMQWRXNFJCelhCU2tuY2oxZGxjcFBzRFVXc1ZqY2xnOU9mdVo3eDIyMDMx?=
 =?utf-8?B?c0hLdUZEQzBVSlgvN2NPVTZqM3RHa0ptZ3dVMTdFWTZPdVdGQ3dJUVlxd0s3?=
 =?utf-8?B?T3IvTzdyaWE0TWgvYkhSTFZsQWI4Wlo2MmtrQndrSUhZWG9yZUVxL1Y1S3FT?=
 =?utf-8?B?Y01iZnltTUtOVm5wRTVuTWxqdmRaTVNEVTRTU3VpN283UE5ZUWROOWpzejlj?=
 =?utf-8?B?RC9zNjdib1pYUElsQUQvMHRIV3NCSVpNd2doL0E4U1IxSE9hZzFEQnFlVStR?=
 =?utf-8?B?R0I3dXB1RmF5ZFQ4aGxNNFY4OU5xQ090dFFobzNHdFhIdHRSMjZteUJDOCt6?=
 =?utf-8?B?enM5cjFFTkxjSytCSmJSUlJURTMxZStES0JGd0U3M1RSc2g2dkw2WldKSFA0?=
 =?utf-8?B?Y1B4VTdRcHl3blJselB1WFJGeEgvMGNlRktpU0hoSUpuRVpJZzYwOGluL1dL?=
 =?utf-8?B?STRZTGtXTkdacTdjQW9sR1p2eWM5bCtJaytJNlJYbVdBd0hEaFFPMmlRSVhX?=
 =?utf-8?B?eG1xZE5WMi9nSWdueDRMZjB3YXBZaWRkcFVZK041TnF1SVdkemJaUkJYR0VM?=
 =?utf-8?B?REwya2pDVXNkaXJYQ1lMbGVKR0NINmV0b3I2M3R3dGpFMFRPdDdtUTlKMkxC?=
 =?utf-8?B?VXJ4ZUs4YTVERHAxZ21JaTJWb2FZMGgyYzNIREFjNU9yNlZLMnp0NWdOYkJa?=
 =?utf-8?B?a25RK0JDQ0F2WTB0a0pMa00rKzZPcElucXAvVnc4S24xSVl2aWVkTkhMcC90?=
 =?utf-8?B?emtYaklBMy8zL3NtSVFZeXJ4WVlSSURQTG45K3RJM3RReU5FZjFNc2ZDM2Mr?=
 =?utf-8?B?TGJqRHpDK3ZUTk9zZHl0ekJZd1kwK1Q4UFppeDRUSWtVYzVqMktlS1ZsQkJD?=
 =?utf-8?B?b1VxNGdaZ2tKa25mOVRYOWx2SDVXM2JaWmxCLzQwenJ1ME5WU1l4ZXZMYjhs?=
 =?utf-8?Q?3SHE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4723.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd0c19e-be58-4842-264b-08da5d96ff1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 08:27:13.2168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 693+GCReym3QmBzK/P627us9dcVl+C4M6pH8IOLvETtXrvQuZKvRG540mMHGonGExL3bQGKby5lVouqEWiq4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2322
X-Proofpoint-ORIG-GUID: Y5lm17PNUYtnnb-l_n7yh8Srlqr6nYFP
X-Proofpoint-GUID: Y5lm17PNUYtnnb-l_n7yh8Srlqr6nYFP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_07,2022-06-28_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQW50b2luZSwNCg0KVGhlIEhXIHVzZXMgdGhlIHNpemUgdGhhdCBpcyBhbGxvY2F0ZWQgdG8g
aXQsIGluIG91ciBjYXNlIHdlIGhhdmUgYW4gYWRkaXRpb25hbCBieXRlIGJ1dCBzaW5jZSB0aGUg
ZGVzY3JpcHRvciBzaXplIGlzIGluIHdvcmRzICg0IGJ5dGVzKSwgdGhlIGRpdmlzaW9uIGJ5IDQg
bGV0cyB0aGUgSFcgdXNlIHRoZSBjb3JyZWN0IHdvcmQgY291bnQgKHJlbWFpbmRlciBieXRlIGlz
IGRyb3BwZWQpLCB0aGUgb25seSBzZXR0aW5nIG9mIHRoZSByZXN1bHRfZGF0YV9kZXNjIChMS3Y1
LjE5KSBhcmUgZmllbGRzIGJlZm9yZSB0aGUgbm9uZSBiaXQtZmllbGQgcnN2ZDAsIHNvIGl0IHNo
b3VsZCBiZSBmaW5lLCBidXQgaW4gb2xkZXIga2VybmVscyBsaWtlIExLdjUuNCB3ZSBkaWQgbWVt
c2V0KDApIHRoaXMgc3RydWN0dXJlLg0KDQpJIHRlc3RlZCB0aGlzIGNoYW5nZSBvbiBBcm1hZGEg
N0suDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBBbnRvaW5lIFRlbmFydCA8
YXRlbmFydEBrZXJuZWwub3JnPiANClNlbnQ6IE1vbmRheSwgSnVseSA0LCAyMDIyIDEwOjI2IEFN
DQpUbzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBs
aW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBPZmVyIEhlaWZldHogPG9mZXJoQG1hcnZlbGwu
Y29tPg0KU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSF0gY3J5cHRvOiBpbnNpZGUtc2VjdXJlOiBm
aXggcGFja2VkIGJpdC1maWVsZCByZXN1bHQgZGVzY3JpcHRvcg0KDQpFeHRlcm5hbCBFbWFpbA0K
DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQpIaSBPZmVyLA0KDQpRdW90aW5nIG9mZXJoQG1hcnZlbGwuY29tICgy
MDIyLTA3LTAyIDA5OjE0OjI2KQ0KPiBGcm9tOiBPZmVyIEhlaWZldHogPG9mZXJoQG1hcnZlbGwu
Y29tPg0KPiANCj4gV2hlbiBtaXhpbmcgYml0LWZpZWxkIGFuZCBub25lIGJpdC1maWxlZCBpbiBw
YWNrZWQgc3RydWN0IHRoZSBub25lIA0KPiBiaXQtZmllbGQgc3RhcnRzIGF0IGEgZGlzdGluY3Qg
bWVtb3J5IGxvY2F0aW9uLCB0aHVzIGFkZGluZyBhbiANCj4gYWRkaXRpb25hbCBieXRlIHRvIHRo
ZSBvdmVyYWxsIHN0cnVjdHVyZSB3aGljaCBpcyB1c2VkIGluIG1lbW9yeSANCj4gemVyby1pbmcg
YW5kIG90aGVyIGNvbmZpZ3VyYXRpb24gY2FsY3VsYXRpb25zLg0KPiANCj4gRml4IHRoaXMgYnkg
cmVtb3ZpbmcgdGhlIG5vbmUgYml0LWZpZWxkIHRoYXQgaGFzIGEgZm9sbG93aW5nIA0KPiBiaXQt
ZmllbGQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPZmVyIEhlaWZldHogPG9mZXJoQG1hcnZlbGwu
Y29tPg0KDQpOaWNlIGNhdGNoIQ0KDQpOb3RlOiBzaW5jZSB0aG9zZSBmaWVsZHMgd2VyZSBub3Qg
dXNlZCBiZWZvcmUgYW5kIElJUkMgdGhlIGJlbG93IHJlc3VsdCBzdHJ1Y3Qgc2l6ZSBpcyBzZXQg
ZHluYW1pY2FsbHkgKHRoZSBoL3cgZG9lc24ndCBleHBlY3QgYSBmaXhlZCBzaXplKSB0aGlzIGRv
ZXNuJ3QgbmVlZCB0byBiZSBiYWNrcG9ydGVkIHRvIHN0YWJsZSB0cmVlcy4gQ2FuJ3QgdGVzdCBp
dCBvbiByZWFsIGgvdyB0aG91Z2guDQoNCkFja2VkLWJ5OiBBbnRvaW5lIFRlbmFydCA8YXRlbmFy
dEBrZXJuZWwub3JnPg0KDQpUaGFua3MhDQoNCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9pbnNp
ZGUtc2VjdXJlL3NhZmV4Y2VsLmggfCAxOCArKysrKysrKystLS0tLS0tLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9zYWZleGNlbC5oIA0KPiBiL2RyaXZlcnMv
Y3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWwuaA0KPiBpbmRleCBjZTFlNjExYTE2M2UuLjc5
N2ZmOTE1MTJlMCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9z
YWZleGNlbC5oDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWwu
aA0KPiBAQCAtNDk3LDE1ICs0OTcsMTUgQEAgc3RydWN0IHJlc3VsdF9kYXRhX2Rlc2Mgew0KPiAg
ICAgICAgIHUzMiBwYWNrZXRfbGVuZ3RoOjE3Ow0KPiAgICAgICAgIHUzMiBlcnJvcl9jb2RlOjE1
Ow0KPiAgDQo+IC0gICAgICAgdTggYnlwYXNzX2xlbmd0aDo0Ow0KPiAtICAgICAgIHU4IGUxNTox
Ow0KPiAtICAgICAgIHUxNiByc3ZkMDsNCj4gLSAgICAgICB1OCBoYXNoX2J5dGVzOjE7DQo+IC0g
ICAgICAgdTggaGFzaF9sZW5ndGg6NjsNCj4gLSAgICAgICB1OCBnZW5lcmljX2J5dGVzOjE7DQo+
IC0gICAgICAgdTggY2hlY2tzdW06MTsNCj4gLSAgICAgICB1OCBuZXh0X2hlYWRlcjoxOw0KPiAt
ICAgICAgIHU4IGxlbmd0aDoxOw0KPiArICAgICAgIHUzMiBieXBhc3NfbGVuZ3RoOjQ7DQo+ICsg
ICAgICAgdTMyIGUxNToxOw0KPiArICAgICAgIHUzMiByc3ZkMDoxNjsNCj4gKyAgICAgICB1MzIg
aGFzaF9ieXRlczoxOw0KPiArICAgICAgIHUzMiBoYXNoX2xlbmd0aDo2Ow0KPiArICAgICAgIHUz
MiBnZW5lcmljX2J5dGVzOjE7DQo+ICsgICAgICAgdTMyIGNoZWNrc3VtOjE7DQo+ICsgICAgICAg
dTMyIG5leHRfaGVhZGVyOjE7DQo+ICsgICAgICAgdTMyIGxlbmd0aDoxOw0KPiAgDQo+ICAgICAg
ICAgdTE2IGFwcGxpY2F0aW9uX2lkOw0KPiAgICAgICAgIHUxNiByc3ZkMTsNCj4gLS0NCj4gMi4y
NS4xDQo+IA0K
