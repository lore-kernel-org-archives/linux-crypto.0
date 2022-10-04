Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54890C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 15:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJDPRo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 11:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiJDPRl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 11:17:41 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84945F110
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 08:17:40 -0700 (PDT)
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294F6Ps1030237;
        Tue, 4 Oct 2022 15:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=SoqBtUG7iNkriRcUFBaGGTFo5HTT4Yf5WqUS5sCGx6k=;
 b=cB/49Yr5EsBtLvX8/9fBxLjz/wo+hM1YOaPGnXemcm0utFP2Js2SoRo4VMANxs57SF51
 MQXzZ2la6UUKj0sGWnGSSrZjRYpLpr0V+anmpzuiCa3WHIqy0qaDTZ2HpVBI1hsAd0ec
 g+apuV6mhSA8Hu/Q6O+v+I7PdeATqrMrNVQHn+vrou52wi1ESwOg2mElV67F/L7uUOIL
 CyCVbomjtW/+G/I7+QKtR0YJoHdvGnCuXfeAukA+gd+oN+geWtBblB748njagW65TB9x
 XZ6nBZGCil+J/qOx/YgseHeBWZfdAJ+BrY7SrD3L818AzpEkxHHtKf1Ip3imO85ahEa4 Tw== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3k0ne416xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 15:16:55 +0000
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 32B1DBD;
        Tue,  4 Oct 2022 15:16:54 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 4 Oct 2022 03:16:44 -1200
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 4 Oct 2022 03:16:44 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Tue, 4 Oct 2022 03:16:44 -1200
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 4 Oct 2022 15:16:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foZ4OVIrtkHK5wo7ltcWwpIHi7FiIrqvLNnBIVbwgQDQgxsV1hzIvtu006jVNTNGydeP1dmAJvsslu93VcWUFjklRe8bZV6ZVqBKHzXokWsdHNROps1tPDj8DwcC3gn2YctZbOIVijnqvOADNITcRfM0RBceKncempPzC9ev4Gb7yRLFQIaEVyQrrb72B2nScmXXkxeKzFdWEY4veHmP5m3ckqnunSAvSI0ZtqAS/AxGbMjSiK9Aq/BLUesZxjKI4T0YPblX236ubfEztb/Epj8ftwBX1kM01vK6aHVBke8SsWi1pR6lfiYyYxvJqqTPAYCExWUGc/6MHmVyTGUBQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SoqBtUG7iNkriRcUFBaGGTFo5HTT4Yf5WqUS5sCGx6k=;
 b=FhcE7J+0OyH+KgnbaxHWLo8aMXNzJkjGya9zq4xrRrxEjy8U+iHvyKAPY/LVuY/c1XVMRvzH1onbmsZQp17GEUHm/xF11R+edq8sSuVRTs7oxzxiSWTYsyE3bgpkL/u1wZy7VCbC4MnZYiPcFJw68JTFUWn6bh7UGgae8SUb0cCyHiqIh/+fMdZm6IAaQWEl+9IjR7sRSOrWrOgOjDJsIYNMEk3sdAqKwbP9bvflUMMOQVzRino0ihhxzI81aI6lVjjB4JT+DrcVksZMP77guk3JyPZIFdPnqXNS3uhy73N0xxSWXkKMQ6pTP2AeG5cF9cS5c66l8ut6QediergN7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by MW4PR84MB1442.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 15:16:37 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5676.030; Tue, 4 Oct 2022
 15:16:37 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: RE: [PATCH] crypto: x86: Do not acquire fpu context for too long
Thread-Topic: [PATCH] crypto: x86: Do not acquire fpu context for too long
Thread-Index: AQHY16zBFmM7SwmJd0SQI42PUTup5q39qv2AgAATNYCAAJL7sA==
Date:   Tue, 4 Oct 2022 15:16:37 +0000
Message-ID: <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221004044912.24770-1-ap420073@gmail.com>
 <Yzu8Kd2botr3eegj@gondor.apana.org.au>
 <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
In-Reply-To: <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|MW4PR84MB1442:EE_
x-ms-office365-filtering-correlation-id: 0766da86-ea89-4d26-2467-08daa61b6e9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gDj93ow2ikVWxOD0Q0kOyRBhIqlBNuIyJC0btjfFHmQgeYC3+4m7RFUzUiRdCZsBC48wJ4/rTyoikK4wMX8W3DaxxX/bl/RYjgQXXl2zZxnxAO5FEHkaxgfkTyPDqGnvsxZOPImhvuHW9qNRIOxiN4OHY6IP2QYpWQYS5XsVVJXQm9MGgLW5SRQ6fdqxMRAmcAvxn6vuKpXj0FqK93aNlrbuBDzBJ5lRri9ujmb6IbEqtuLtwewXB0LdLfr/+FOxJyBYmzrHodAksrk9Rh6dDRTpFuuecuWXTfYFZHHUv2P+nJJZ5bXsIbcf7JQhSHW+yAqW110YGAsPF+EaHn78yxXurvOx5Y6lfp1Vx1uN9diZiJ1gE2hGCNN7GDKo+9lGdhWDyC/ueryqKg9KzPmR238s1ITxoJVxw6LJJqDc8FKYokl/aq8NgD6XqVmaqSAlOVFmyavlALzhT4r0ElFUnFUvrYFjgdPfKDQ57IS0do0bwVeTauQ8cSqsfnI8kWqghaVQsGEWVaXXm50JwIqFVxjdJli4IBGDdLzmN8JpI5uLm78SpukHc/9zoJDOYS2zKNQ8zzb+n6aPRt7STRt5GwQ5SFceDK+0zfbdBAwN0607AuFGuqOoT+6mHqdmiOn1N6o42+7kuuIA5avRvBqeL0qW4Zj7gO+cecFaSVi+fgDyTIeb8HofoVz5p2NoquEswifge1M0rWiHHZhOkG+Ki64tIuDWQq3dUMxVwAtKeW7+vex47Wl9u+dXW1MB1wHRzbkL4kIvZBnnXdejLynyYunULXc1XwlaD/AXkPzsViA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(52536014)(55016003)(33656002)(45080400002)(86362001)(9686003)(26005)(53546011)(7696005)(6506007)(82960400001)(186003)(110136005)(966005)(41300700001)(2906002)(83380400001)(54906003)(478600001)(38070700005)(316002)(5660300002)(71200400001)(8936002)(38100700002)(66946007)(66446008)(122000001)(64756008)(7416002)(76116006)(8676002)(66476007)(4326008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUdjNE1MSzFNM1d6VDAxMUJRdkpMUkp3WkVIcG96RVp5R3V3LzM3REtUeUw3?=
 =?utf-8?B?MzVuYVMyTkJpVWprZjJjV3NkSEVFcnZpeUlycFRhMmR3ayswKyttM0Fsb0Ex?=
 =?utf-8?B?NTV0WHVwYk5UVnpaTWVuVXBtcW42ZXdvOVBmWjdJVS93TTJuMDR1Y1R3WHhq?=
 =?utf-8?B?RmJxWmlJdTVBdHFUeGh2UXVnRGxLRW9NYldTR0VUcW1FTzBvV281cTlYMXlC?=
 =?utf-8?B?R2lVV2VHaUc2NEtHeWZNWXhzblZ1Yk5kKzhNNGNCdkFKR2M0NXZiditHR2xJ?=
 =?utf-8?B?SE9NVUdYRUlER1VaNnQ2YTJvV3Y3ZGcxN2tXL0tJbnlML1NINmIzK3o0L0Nl?=
 =?utf-8?B?T0xXYlJXQnVSZ2x0VWpjeXN5MnhsQVVONnhLWTF5YjJIcHRwTEV5TVBRUzJ1?=
 =?utf-8?B?WmRpTWxOWm85SElaNEZyTHB3dlg0dkdZRU9SQmI3RUsza2RSaDEzcXVtYnBy?=
 =?utf-8?B?OG8vdDFWa0JTbmJpNlFoZVA2WWpQd1owS0JQdkpEczVYV2MrV3pvdk1LdldT?=
 =?utf-8?B?eERybFFXT3RoQ0NUQ242VmQ5TFNjTCtoeWlQRy92Q20yUVZBa3lDbVVWenVY?=
 =?utf-8?B?enMvT2t1V1V3eCtrLzQxWFlyV1JhOExBczFDN3N4d3V2RU1XNzJJUmF2SDE1?=
 =?utf-8?B?M2p0VSsxWkJkaWRoa1NGcXFxYmlPbFhDdG5GVkRQRzQxRzlrdUhZL0dmMXNW?=
 =?utf-8?B?SmNuU0hDNkhLTlg3RDdXTzN2OXYzdDBkNUp4MGxPY3AvVEthRHRjNE9sWjFS?=
 =?utf-8?B?T2J3Q3ZCcVVDVWl6Y2pTYnYzMFVWak5OZCs5RHJFeG1tdmpHMGFTeTd3QWpW?=
 =?utf-8?B?enJaeHNUQVdQUkZlY1Zza0Z4M3QyTjg2SkoxNVVKWHhuK1Bzc0FFRG8rQ0NX?=
 =?utf-8?B?RVBXL3FZM08reHJYUHJCRFh0WjRSdWZIT1lEUVhWNG50Ylc4eE95TUh1VVkz?=
 =?utf-8?B?eVZtTzlPOGtyZ1NSb3JKOFA1Sjk1MFBGblNBaEpVWFBEakRTZWlaVGJLbXJ5?=
 =?utf-8?B?aDlQb2RCU2FzdVJiMDBIYjB0ZW1mQkM4TXA5eGlZbTE2aUVJNVlaeVN2Y2RG?=
 =?utf-8?B?VjRkWGNRT3lKeXFvNUVJYVBhbHFzRVpWd1VZNjlxSm5ZRWdhMWZMTUxSR3di?=
 =?utf-8?B?K3RLa2NhWUdSTUlROGdRUDN3NWJMTFlNR0p5Zmpqb2hPdVRGV0c4ejVzdEty?=
 =?utf-8?B?eTlaMm93OEpwNzI2anNmVDFyOGUxYlZJdUFtVHpEa09Kc0FHTlBzaFBhazRs?=
 =?utf-8?B?Q0gvQldZaWpVTDk5YjlWaEozQmdnbzFZaXdNNjR1eks3cXpBUXJ5NkZadVAv?=
 =?utf-8?B?bVNyZFNrVjU4R3pkUUNJdXQyMmVnRG9vYWFBL3h2dDlXNUlTU1h1cE5DU1c0?=
 =?utf-8?B?c09IeURVRkVqSUtoMDBLVldKbStDMGkyQnlzODlEYW1TQTZubGNhZDVxM2VW?=
 =?utf-8?B?T0pzY29kUTFqRE1qUE85VmRqeTM4ekx2TEtUa1lMcngzNk13TXh6UllwZUVs?=
 =?utf-8?B?UlZEdjJURFl1U2t5UmZsekd1TmZzZTQxS0trQi91S3QzU1QvamMyaHZraGFx?=
 =?utf-8?B?ZTB5ZGVHSS9heGQ1SWgzdThta2lpUWk3M3BZMDhYQlVHL1M2dDB3ZWl5alVW?=
 =?utf-8?B?UHNSdVFEZStVQnBZMWxBalEva29kNHdta05adUtqaktHczFab2J6bWtJOHFD?=
 =?utf-8?B?dk8xbTVkL2tScFJOaEZoUUdQWFNDRHlIbnduNlpXVVpRbXgzYUtsaTlwVWMw?=
 =?utf-8?B?TWtybWFCRDhIWWtGdnlSVVg5UkhuWEJCTWo4UmZlQWxjSVNqZkh5ZkxYVlRW?=
 =?utf-8?B?SS9XaG9zN2pzS1BWa2ZSaGRibGQ1ekNCVytGUWV4elJkNjVtR3lPMlhCWXh4?=
 =?utf-8?B?b0M4UXVid3I2dDN2aHJiUjdoTkxjTVU2MjRjUDRyTk5CMWpGbXBEZFRTRHM5?=
 =?utf-8?B?bHVQWnRHa2M2TUVJTXpzYmxVd2hGd1hBNFBSdHp2eFlWOGh1eTBxdUN5K2FC?=
 =?utf-8?B?VitXWkt0Tk9uZWo3WGtTbUNxTGxPM2xHdytFUERyeGx6UTFlcnNibWIwRk9u?=
 =?utf-8?B?UkRmczVORUFrcWE4aGFRejVtUkorTkJjT25haytZbmFpSTRvbXMxWlBWRzNm?=
 =?utf-8?Q?2GLk=3D?=
Content-Type: text/plain; charset="utf-8"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0766da86-ea89-4d26-2467-08daa61b6e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 15:16:37.5855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mfq/dle+90SBrQhmYc4jqYnwU3hp60IjChVauq1PIaRcCJXO3HENwW8sIdQ0xr7r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB1442
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: teScf7Q2WY3v-rlzJ4cs-Jr831NfO8W5
X-Proofpoint-ORIG-GUID: teScf7Q2WY3v-rlzJ4cs-Jr831NfO8W5
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040099
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGFlaGVlIFlvbyA8YXA0
MjAwNzNAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDQsIDIwMjIgMTowMiBB
TQ0KPiBUbzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDYzog
bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgdGdseEBs
aW51dHJvbml4LmRlOw0KPiBtaW5nb0ByZWRoYXQuY29tOyBicEBhbGllbjguZGU7IGRhdmUuaGFu
c2VuQGxpbnV4LmludGVsLmNvbTsgeDg2QGtlcm5lbC5vcmc7DQo+IGhwYUB6eXRvci5jb207IGFy
ZGJAa2VybmVsLm9yZzsgZWJpZ2dlcnNAZ29vZ2xlLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENI
XSBjcnlwdG86IHg4NjogRG8gbm90IGFjcXVpcmUgZnB1IGNvbnRleHQgZm9yIHRvbyBsb25nDQo+
IA0KPiBIaSBIZXJiZXJ0LA0KPiBUaGFua3MgYSBsb3QgZm9yIHlvdXIgcmV2aWV3IQ0KPiANCj4g
T24gMTAvNC8yMiAxMzo1MiwgSGVyYmVydCBYdSB3cm90ZToNCj4gID4gT24gVHVlLCBPY3QgMDQs
IDIwMjIgYXQgMDQ6NDk6MTJBTSArMDAwMCwgVGFlaGVlIFlvbyB3cm90ZToNCj4gID4+DQo+ICA+
PiAgICNkZWZpbmUgRUNCX1dBTEtfU1RBUlQocmVxLCBic2l6ZSwgZnB1X2Jsb2NrcykgZG8gewkJ
CVwNCj4gID4+ICAgCXZvaWQgKmN0eCA9IGNyeXB0b19za2NpcGhlcl9jdHgoY3J5cHRvX3NrY2lw
aGVyX3JlcXRmbShyZXEpKTsJXA0KPiAgPj4gKwl1bnNpZ25lZCBpbnQgd2Fsa2VkX2J5dGVzID0g
MDsJCQkJCVwNCj4gID4+ICAgCWNvbnN0IGludCBfX2JzaXplID0gKGJzaXplKTsJCQkJCVwNCj4g
ID4+ICAgCXN0cnVjdCBza2NpcGhlcl93YWxrIHdhbGs7CQkJCQlcDQo+ICA+PiAtCWludCBlcnIg
PSBza2NpcGhlcl93YWxrX3ZpcnQoJndhbGssIChyZXEpLCBmYWxzZSk7CQlcDQo+ICA+PiArCWlu
dCBlcnI7CQkJCQkJCVwNCj4gID4+ICsJCQkJCQkJCQlcDQo+ICA+PiArCWVyciA9IHNrY2lwaGVy
X3dhbGtfdmlydCgmd2FsaywgKHJlcSksIGZhbHNlKTsJCQlcDQo+ICA+PiAgIAl3aGlsZSAod2Fs
ay5uYnl0ZXMgPiAwKSB7CQkJCQlcDQo+ICA+PiAtCQl1bnNpZ25lZCBpbnQgbmJ5dGVzID0gd2Fs
ay5uYnl0ZXM7CQkJXA0KPiAgPj4gLQkJYm9vbCBkb19mcHUgPSAoZnB1X2Jsb2NrcykgIT0gLTEg
JiYJCQlcDQo+ICA+PiAtCQkJICAgICAgbmJ5dGVzID49IChmcHVfYmxvY2tzKSAqIF9fYnNpemU7
CQlcDQo+ICA+PiAgIAkJY29uc3QgdTggKnNyYyA9IHdhbGsuc3JjLnZpcnQuYWRkcjsJCQlcDQo+
ICA+PiAtCQl1OCAqZHN0ID0gd2Fsay5kc3QudmlydC5hZGRyOwkJCQlcDQo+ICA+PiAgIAkJdTgg
X19tYXliZV91bnVzZWQgYnVmWyhic2l6ZSldOwkJCQlcDQo+ICA+PiAtCQlpZiAoZG9fZnB1KSBr
ZXJuZWxfZnB1X2JlZ2luKCkNCj4gID4+ICsJCXU4ICpkc3QgPSB3YWxrLmRzdC52aXJ0LmFkZHI7
CQkJCVwNCj4gID4+ICsJCXVuc2lnbmVkIGludCBuYnl0ZXM7CQkJCQlcDQo+ICA+PiArCQlib29s
IGRvX2ZwdTsJCQkJCQlcDQo+ICA+PiArCQkJCQkJCQkJXA0KPiAgPj4gKwkJaWYgKHdhbGsubmJ5
dGVzIC0gd2Fsa2VkX2J5dGVzID4gRUNCX0NCQ19XQUxLX01BWCkgewlcDQo+ICA+PiArCQkJbmJ5
dGVzID0gRUNCX0NCQ19XQUxLX01BWDsJCQlcDQo+ICA+PiArCQkJd2Fsa2VkX2J5dGVzICs9IEVD
Ql9DQkNfV0FMS19NQVg7CQlcDQo+ICA+PiArCQl9IGVsc2UgewkJCQkJCVwNCj4gID4+ICsJCQlu
Ynl0ZXMgPSB3YWxrLm5ieXRlcyAtIHdhbGtlZF9ieXRlczsJCVwNCj4gID4+ICsJCQl3YWxrZWRf
Ynl0ZXMgPSB3YWxrLm5ieXRlczsJCQlcDQo+ICA+PiArCQl9CQkJCQkJCVwNCj4gID4+ICsJCQkJ
CQkJCQlcDQo+ICA+PiArCQlkb19mcHUgPSAoZnB1X2Jsb2NrcykgIT0gLTEgJiYJCQkJXA0KPiAg
Pj4gKwkJCSBuYnl0ZXMgPj0gKGZwdV9ibG9ja3MpICogX19ic2l6ZTsJCVwNCj4gID4+ICsJCWlm
IChkb19mcHUpCQkJCQkJXA0KPiAgPj4gKwkJCWtlcm5lbF9mcHVfYmVnaW4oKQ0KPiAgPj4NCj4g
ID4+ICAgI2RlZmluZSBDQkNfV0FMS19TVEFSVChyZXEsIGJzaXplLCBmcHVfYmxvY2tzKQkJCQlc
DQo+ICA+PiAgIAlFQ0JfV0FMS19TVEFSVChyZXEsIGJzaXplLCBmcHVfYmxvY2tzKQ0KPiAgPj4g
QEAgLTY1LDggKzgxLDEyIEBADQo+ICA+PiAgIH0gd2hpbGUgKDApDQo+ICA+Pg0KPiAgPj4gICAj
ZGVmaW5lIEVDQl9XQUxLX0VORCgpCQkJCQkJCVwNCj4gID4+IC0JCWlmIChkb19mcHUpIGtlcm5l
bF9mcHVfZW5kKCk7CQkJCVwNCj4gID4+ICsJCWlmIChkb19mcHUpCQkJCQkJXA0KPiAgPj4gKwkJ
CWtlcm5lbF9mcHVfZW5kKCk7CQkJCVwNCj4gID4+ICsJCWlmICh3YWxrZWRfYnl0ZXMgPCB3YWxr
Lm5ieXRlcykJCQkJXA0KPiAgPj4gKwkJCWNvbnRpbnVlOwkJCQkJXA0KPiAgPj4gICAJCWVyciA9
IHNrY2lwaGVyX3dhbGtfZG9uZSgmd2FsaywgbmJ5dGVzKTsJCVwNCj4gID4+ICsJCXdhbGtlZF9i
eXRlcyA9IDA7CQkJCQlcDQo+ICA+PiAgIAl9CQkJCQkJCQlcDQo+ICA+PiAgIAlyZXR1cm4gZXJy
OwkJCQkJCQlcDQo+ICA+PiAgIH0gd2hpbGUgKDApDQo+ICA+DQo+ICA+IHNrY2lwaGVyX3dhbGtf
KiBpcyBzdXBwb3NlZCB0byByZXR1cm4gYXQgbW9zdCBhIHBhZ2UuICBXaHkgaXMgdGhpcw0KPiAg
PiBuZWNlc3Nhcnk/DQo+ICA+DQo+ICA+IENoZWVycywNCj4gDQo+IEkgcmVmZXJyZWQgdG8gYmVs
b3cgbGluay4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL01XNVBSODRNQjE4NDI2RUJC
QTMzMDM3NzBBOEJDMEJERkFCNzU5QE1XNVBSODRNQjE4DQo+IDQyLk5BTVBSRDg0LlBST0QuT1VU
TE9PSy5DT00vDQo+IA0KPiBTb3JyeSBmb3IgdGhhdCBJIGRpZG4ndCBjaGVjayB0aGF0IHNrY2lw
aGVyX3dhbGtfKiByZXR1cm5zIG9ubHkgdW5kZXIgNEsNCj4gc2l6ZXMuDQo+IFNvLCBJIHRob3Vn
aHQgZnB1IGNvbnRleHQgd291bGQgYmUgdG9vIGxvbmcuDQo+IEJ1dCwgSSBqdXN0IGNoZWNrZWQg
dGhlIHNrY2lwaGVyX3dhbGtfKiwgYW5kIGl0J3MgcmlnaHQsIGl0IHJldHVybnMNCj4gdW5kZXIg
NEsgc2l6ZXMuDQo+IFNvLCB0aGVyZSBhcmUgbm8gcHJvYmxlbXMgYXMgeW91IG1lbnRpb25lZC4N
Cj4gDQo+IFRoYW5rIHlvdSBzbyBtdWNoIQ0KPiBUYWVoZWUgWW9vDQoNCkkgdGhpbmsgZnVuY3Rp
b25zIHVzaW5nIHRoZSBFQ0IgYW5kIENCQyBtYWNyb3MgKGFuZA0KdGhvc2UgaGVscGVyIGZ1bmN0
aW9ucykgYXJlIHNhZmUgIC0gbm90aWNlIHRoZSB0aGlyZA0KYXJndW1lbnQgaXMgY2FsbGVkIGZw
dV9ibG9ja3MuIFNvLCBBcmlhJ3MgRUNCIG1vZGUgaXMNCnByb2JhYmx5IHNhZmUuIFRoZXJlIGFy
ZSBubyBDVFIgbWFjcm9zLCBzbyB0aGF0IG5lZWRzDQp0byBiZSBjaGVja2VkIG1vcmUgY2FyZWZ1
bGx5Lg0KDQpXZSBuZWVkIHRvIGNoZWNrIGFsbCB0aGUgZnVuY3Rpb25zIHRoYXQgZG9uJ3QgdXNl
IHRoZQ0KbWFjcm9zIGFuZCBmdW5jdGlvbnMuIFRoZSBTSEEgZnVuY3Rpb25zIChJJ3ZlIHN0YXJ0
ZWQNCndvcmtpbmcgb24gYSBwYXRjaCBmb3IgdGhvc2UpLg0KDQpSdW5uaW5nIG1vZHByb2JlIHRj
cnlwdCBtb2RlPTAsIEkgZW5jb3VudGVyZWQgUkNVIHN0YWxscyANCm9uIHRoZXNlOg0KCXRjcnlw
dDogdGVzdGluZyBlbmNyeXB0aW9uIHNwZWVkIG9mIHN5bmMgc2tjaXBoZXIgY3RzKGNiYyhhZXMp
KSB1c2luZyBjdHMoY2JjKGFlcy1hZXNuaSkpDQoJdGNyeXB0OiB0ZXN0aW5nIGVuY3J5cHRpb24g
c3BlZWQgb2Ygc3luYyBza2NpcGhlciBjZmIoYWVzKSB1c2luZyBjZmIoYWVzLWFlc25pKQ0KDQph
ZXNuaS1pbnRlbF9nbHVlLmMgcmVnaXN0ZXJzICJfX2N0cyhjYnMoYWVzKSkiLCBub3QgImN0cyhj
YmMoYWVzLWFlc25pKSIsDQphbmQgZG9lc24ndCByZWdpc3RlciBhbnkgY2ZiIGFsZ29yaXRobXMs
IHNvIHRob3NlIHRlc3RzIGFyZSB1c2luZyB0aGUNCmdlbmVyaWMgdGVtcGxhdGVzLCB3aGljaCBt
dXN0IG5vdCBiZSBicmVha2luZyB1cCB0aGUgbG9vcHMgYXMgbmVlZGVkLg0KDQoNCg==
