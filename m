Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D5EC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiKRTOe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbiKRTOd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:14:33 -0500
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7787248774
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:14:32 -0800 (PST)
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AIJ8P6T015245;
        Fri, 18 Nov 2022 19:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=D65H0M9F2p+xCvCNk+CYa0gaECUo61PgLQFaw/a5JnM=;
 b=JMjdIMg4uCKGi4Bb7W6Uk9nYFUr8WDxgZS9u6r4aeFENowBlam74jCCv/DPh7dQ5niHH
 QvBs/3SVsyZOALYo4sjW7CaY+fZBOPJgRrROsTQ+AeLbcKgPMRu0CZPMT0UvLu0Qz/Pj
 SJuYUHUtdimMHTu2goGIhFLvfg8846yr7PFw1CLtd7mG0ZLIoaLEK/TIOBU3DSQ3OOE2
 kBSmwKkNfVnbUO9z1MqElQaVFb4rN0MYELfnXNSaLFAJsVHaVG9LZL3VwZNcS/hx0Dq7
 Obhq40yStr/zJL9g/tyJcHkVCg9P8zGpoHKmPSsGUsNswkgLJ7hnAz+DypR3x8GhWDoh rQ== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kxfmxr82e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 19:14:23 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id B79072FCC1;
        Fri, 18 Nov 2022 19:14:22 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Nov 2022 07:14:16 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Fri, 18 Nov 2022 07:14:16 -1200
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Nov 2022 19:14:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR3VPzPAh52mfloVSWlWeY8Vt4MdcO5ZYEYHUXRY+BjsAhQTWuWhG1yXeAwQ9p79UEzrxVE/Zh6Miy1LiIA1083j2+M2c0Gaoe7ZUoWZdDthGubJdkC6IfTlfTP7wM9yG97BXKzdETEgNP9eWJJ5u0dozRK9kMc6r8JZcGQtLXDvoJVJSmlfhSinUgPZ8LPZc1nteidA1ObqenXBRLV9GTx9obZzFqZIVCA4Fxq8uGW/TDMMNzAriqE2sAiVODpnQWhPxDiEJB46QiktE9qDepzx11VxrtXzglDHBxBtFAyl7xNz+TGdfmBXCFo8ZMwBwUPxrvLJzcWt1laRAa5eYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D65H0M9F2p+xCvCNk+CYa0gaECUo61PgLQFaw/a5JnM=;
 b=Esreru5fPR0KVdgECVMxrdVbsLF2zakioqRpSjiRuVONSMLaQq8nb/WBambE8ZGr+M/bglZ6hwvZX2mvKMXApNaXDY1UaOL0oqaBuA/+es2dKfjdcPZuC7SAVF0zAJLsp9rzF1sRanZj1tnf7MH6shzfwQcxP/UZzjmugz7On8hFmrfqfmlV0ZHy/kkXwhsmEoqtHURqNKLXweYW757c1/v+AmncXWj64s56m1J4/P6pu5GfqTDCgtBibD4hQYaFN0tDAs9Hrgl/p9ElBpRwCiHhR+NvLRK0z4rfKJgthrPz2N/X37Sts5+zuIZJykWtUKINhLsqbtEZIb9CLW0UaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1791.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 19:14:13 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816%9]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 19:14:13 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: RE: [PATCH 0/11] crypto: CFI fixes
Thread-Topic: [PATCH 0/11] crypto: CFI fixes
Thread-Index: AQHY+yzRYe3fakVHM0eSxOcY4VJpEq5Ey7FAgAA68wCAAAVO4A==
Date:   Fri, 18 Nov 2022 19:14:13 +0000
Message-ID: <MW5PR84MB1842FB8323FED755045A48F4AB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221118090220.398819-1-ebiggers@kernel.org>
 <MW5PR84MB18424C160896BF9081E8CFCAAB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <Y3fTvOKW1txyDOJE@sol.localdomain>
In-Reply-To: <Y3fTvOKW1txyDOJE@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH7PR84MB1791:EE_
x-ms-office365-filtering-correlation-id: d1249160-4e50-453d-cce8-08dac9991431
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kh9s1tVvpMJ/+kwY95pitW3j6y0yvCLp3VTC6z1hd+nFYu5L0GHKBfg+BZ1InQEIItzf+vmQlmLSkIreV1LpBM4lEpiSwk8MUcqhOT9PQPTdRNTBGdqjXAI+niQqqImfOrakrDEt0kRTBQ9v5dZVykpPcSbHOZ1ECkfuOPrKCZz7xlZMG/kceDIpbxNf8PxhxZbbHZCMRFuAQyDTnkbRlNMwvO8P8eYPXodcANTEDlb+bRbWuYWNe2B7YnxXUw92s5t2GCcsS3xQJSXXcxExjdQX/9zsfy//2OTRrW6r4f0hfGLuedd7iDqQx6VYh1ULijyuNlNDYSqpd82ul8Squxr0mv/Zd9OZv0ZaMytrAFd9BqpoIEoNkd/e5kuHHDGNS5BqDuRRl2YYW2cTPvhI6ZcT/NSLxspbacM9NFsjkHPu6N6w4pXeLh92LBTbO7fn53w5Yu/QrD/FKt/fL4bcYrmHjhrkenmUgJ9SjbGc1lmqj7nEAZ8SxY66lmv/0Le8PrSmLGSkyXxCN1ujC/srhYqVUS6cwvXVLqkV76n2W9aqYkO0/ITMcEl5ofxRFsOH4UPOFtOJ4CB6jTHqLk/2H2cWNTcIRM/MmSzhHXR/S6GKl8/zNdaTCwZ+1C2DwLcAMIWqmLJ20HjLWqgNQ0fi3MdEgbQRvwdC/nsHY7FhCyoRoPD6SIWoKehYURt7hK8AMJ6+KdcBmQrIuUe7mjrFtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(2906002)(122000001)(38100700002)(41300700001)(186003)(478600001)(8676002)(76116006)(6506007)(4744005)(9686003)(7696005)(66556008)(5660300002)(66446008)(52536014)(66946007)(4326008)(64756008)(66476007)(8936002)(26005)(55016003)(71200400001)(54906003)(82960400001)(38070700005)(86362001)(6916009)(316002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hw8uhzojUFxNLu9++B4HdQ+cRbQj6YDTFnW9vSbxPG4DDAMwn+2jmr8rO3NF?=
 =?us-ascii?Q?zf9OBGIfXEeM2g5CG4hGoh4xcIiByQAI3WKYWnEol1WWlttUDL3rZbpBH214?=
 =?us-ascii?Q?MSxaq4T4Ue9opbnWW/5++E8nZkZf9vttg5/7+f5hY6CUgYDpqMhYbUMPvZC4?=
 =?us-ascii?Q?yOKyezNnDbaujo9TxMgUi2Yb9/Qr4UEI8Iv+ow7ded4EkPdd493Opi0Uhff8?=
 =?us-ascii?Q?vHnzmqfyEU/lavoSw8BmV15OdE6aqSB0XxOgaArZRU5Sb1u1ri58Jq7skHfw?=
 =?us-ascii?Q?koq3EwotkfyzkjrrMh9T3VzIKGQ7lNS4/UmsJrMgpzHyQREOVM1JGxj20YBi?=
 =?us-ascii?Q?4yGkHEE0AEVGRMVLFNuOBEj0kba/cJNf2ErnrHi42irNhSo0di4x/3SiWC5D?=
 =?us-ascii?Q?YGCKHWL7BcZBlcnucLFIBKLxpreC+ZWZZz0PC4+q5/az9V+jXVAsPv/LhCRD?=
 =?us-ascii?Q?e0DtvLhOROkIB9OgjPlVO5jrgQId4gayPnvMNeBS6j5NitMELotHe/4vb78J?=
 =?us-ascii?Q?PwhPx3GufeuU63aBCw7HwICenyLnJ0RQeKdAX5tIUOpQaH8+tiUeobHGHBB7?=
 =?us-ascii?Q?lBibsPOrDklwBtNEl5wTcilnglinl/ZBox4dtw63Efi62Nf3HTXo1Kp8ME1G?=
 =?us-ascii?Q?5vamQZ6FgRvY57WdFb94NxMh1EPA3waCCtEGnG/dejXdRR1AhAEwy4179DpP?=
 =?us-ascii?Q?+nd+4seyS/szsXcSasp3AOxonx1tBOqSgU6JL/QvPoQ3bUhwG6Tdq4lvBgiI?=
 =?us-ascii?Q?HgtBxdralgDUb8drxP4SgZzdydlFQgzbngqxIgUWYX2iZASHh7+dIPcSp645?=
 =?us-ascii?Q?6n+OSQJDK5S1znpx/93J2rqcmA12l5SOkPWauD0eH8H4gKxgVRgzxVV9dyja?=
 =?us-ascii?Q?+RRJll0uDW08lTSb/zLADEBQs9D4/Pw3Usx293e0wDAuHDcGkq6opE7gpvbO?=
 =?us-ascii?Q?UIcayVwz5c6M8vKPbY3QDUKPvFF3UQ9KpZRt89wGv1h09kWxStw1Q4CBAQ8j?=
 =?us-ascii?Q?JsUtOUwQ2E/LeSQs5Zk21pTSpO3pfTifE2UW9VHhoCmDOrm7L5I/qXsiKZoc?=
 =?us-ascii?Q?SKd7S6Iq3l193uvs5BAZDCWalrrHK++IoE5n9Lv+MdudIUircTqp3uH/cnck?=
 =?us-ascii?Q?GPejNAPC3nk+NbV78Y6tVW7A/6GxEsRDj9WigKUWIaZ38ITd0uqN3VQLyFCQ?=
 =?us-ascii?Q?/k3dcuScWckETK2HMk+vZlz5gshjXTySgTqWG2fHLLVksjq3RnxqOqPB1d5l?=
 =?us-ascii?Q?RJDORfR9Pe7O8DkdtFcbuQHWLVvdwFFFdqFsYYUceRBZBX89D5lEBf4A9tUo?=
 =?us-ascii?Q?bE28J0Qg6z0VGAvkjnOYmS8JotEnXicP1u4hFk9GGtVpkMfdZgczJjEuLwjF?=
 =?us-ascii?Q?/x1ALipct+zMf7LYpKwcxgGD1ALdQ5tmQeYCQ4QPGkic7wXnAxrzez4uLmf1?=
 =?us-ascii?Q?cbD3AUmV1xTGxjs1Wfi6YklrvuWgwpd4eNf+E+ahbyEs3wnsNphjfMgKPsJo?=
 =?us-ascii?Q?REPKzYRPasbCBgmGlUP94ScXQgvV7SqBq13YmaoTkmjYsk6s/o3sGIp4YMsM?=
 =?us-ascii?Q?W+5DalrzD/4IL8ArQeY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d1249160-4e50-453d-cce8-08dac9991431
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 19:14:13.2021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o4HmvYSZyC32uDDi25b175wOO4Ek7YY4YX75NBY+tjSead+mgREwBgYlZ1xzNRsg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1791
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 6RgyX0ZZU8Um-7IB8JZsRFsOJE5Tr0Tg
X-Proofpoint-ORIG-GUID: 6RgyX0ZZU8Um-7IB8JZsRFsOJE5Tr0Tg
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_06,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=721 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211180115
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> arch/x86/crypto/twofish_glue_3way.c:EXPORT_SYMBOL_GPL(__twofish_enc_blk_3=
w
> ay);
>=20
> No, that doesn't matter at all.  Whether a symbol is exported or not just
> has to do with how the code is divided into modules.  It doesn't have
> anything to do with indirect calls.
=20
I thought that makes them available to external modules, and there is no
control over how they use them.

