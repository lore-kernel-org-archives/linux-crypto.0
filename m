Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402FBC636D4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 19:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjBJTIn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 14:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBJTIm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 14:08:42 -0500
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8BE2136
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 11:08:41 -0800 (PST)
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHVCih007640;
        Fri, 10 Feb 2023 19:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=YtBV2FqXK8m/6ckzy5Z55oVryAD5okIyyHcbh91G9Vg=;
 b=hTx9BCJwZP7V7WVU6uV7YxRVGEuacyhwqAfYH3u4kW5/xOmBnHx7Vdh46quuQr9ptJq3
 L0aPHBBjfOaL5DRzElEMkkrTurbVwwVnkRL2gel6QNVxz0f7AHtpkEBWRavAT3vZMTkB
 43PDSCjdSJgq0tbwvhESkWhNAU0GqddQwHQwJZlH2n2lvmma6a6rd+ESh9mujvAAs1Il
 nEL7MeXUAnifpwenZ7e4EwflZbgwXHkjEV4kJfN6aWtorT5hyzXGvEsOEYFnmWbgJI9s
 Q+4J1f/Scb1lovptO2bcAaHRNFwDHOVoVaDZoVa3fF+MVIHo57l4aJ+voNncbRM8uJOU ag== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3nntd0rmsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 19:08:19 +0000
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 25EF8805E77;
        Fri, 10 Feb 2023 19:08:18 +0000 (UTC)
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 10 Feb 2023 07:08:07 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36
 via Frontend Transport; Fri, 10 Feb 2023 07:08:07 -1200
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 10 Feb 2023 07:08:07 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bcovm8AeC3loRxPkbzhpZo3CDYaSRKHaBprSsIZgNixhzTW+lq9dwVcRrv/somJ7hcyp2aSiyqtrgog3LFKVLYxcKXD6/mCEbZte3GRgr8yujqP7SEvY+45pMP73hdvXmpArBMVu3WP13GxXrn8enMFtYe6DWpbp6AxuxusHYkIC0dtit+GaZHLPWplI0LV7bIKIYpkoJNCADMqafH5An6D5MY8DngUk04BqYwpVNksppBIYFYWCxyrIWn2DxoPcGuqqQ8gqixhBKfl851XUvyCf+tuxD+rxLIjUF3mN4YRUoSxK1XtWld69v0Xh5fQhhaOAgkKjK04ybYQaoUj9Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtBV2FqXK8m/6ckzy5Z55oVryAD5okIyyHcbh91G9Vg=;
 b=GFQfipNwpltMzYY8C104yqBh2lzKiPofBBRxOruFk92vXNYsVqJUI18yZFvWQYr+zodCkEnoq8uQe/mnLmu9q2PJacXU90BKXlxdPmZv2XjFqFb2vTw3OnxupyZdIz+IarlWOoZekJ7e3BIDGgObRIQh52P4icTWfckhlNe+x3l3Nn7wmQoK0YoF/HSbU1pcBzt8OyYpegDkfQUWYsk3z4owoHI/H/GNKoCplT5e7cF1G/zGytHz0eiLfuDKSSmvjxA55Ep741Fe7Qqsd3Bugz1oa0Tx+561ElwAtIUXrRLPRc5bhF4nr3+nuWg2P0sqEMOyiOU0TE3wQRn9OrQZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1365.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:15e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 19:08:06 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 19:08:05 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "erhard_f@mailbox.org" <erhard_f@mailbox.org>
Subject: RE: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Thread-Topic: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Thread-Index: AQHZPXvDIQ/PQFES9E+OhtltHgnKqK7IiMZQ
Date:   Fri, 10 Feb 2023 19:08:05 +0000
Message-ID: <MW5PR84MB18427D089F66544E76648A70ABDE9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20230210181541.2895144-1-ap420073@gmail.com>
In-Reply-To: <20230210181541.2895144-1-ap420073@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH7PR84MB1365:EE_
x-ms-office365-filtering-correlation-id: 191b5f63-d380-4750-c9ea-08db0b9a23ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kmHl1zggppvvBhLpEPo/EpJ9kPDRqI6Jx1DYDK+3Pr+1QtZDIN1UxwLixSdcqNzEy1P5JmLaCpcGylGbvFkqSQkE+toQ7cacf5muO8fCqjn2+7NS2P8i+kT1QsWcRwB5wPIj2xPS7aOuEXYifF3YDxipOmjlIdl9GapSQV9p5+Vf4YbW5gDYjqF0MeTXujitpZ39a99LiZCoDN60BAdEDGlA2XlSed1IhryKMM5hGqluDbaAN7hOrMMuxsBWSRRl/Pmn2iyJWk32ssz9aKDa8kbGfwwpxAKd2IM9+wFbJ43T21LEl2cy9u9IHjblNhNQwcAC9L3BOYgixmLpFRHTWwn96MlQ40VkTKIHPslOFqes4+FdNXwyo1PMCibyQnet+x1MG5b1AfHuQRstw6kteIyeYbqi76aPRb7CIQMEaD1YHCWLXaQz7c3NE74r2RVR02nhaL+ioCyuJ//Rr8BUjFnPJj72nuwjj+k19lsN79vNvU53Ku5+wpbvVfVDbM+2hewjcsGGmZVL44i/OvCXjI5r7BHEJ9U0mBzjIRHQAqT6IpoW/Lfgmg8KFUHSpau45z7OIDUYOlfKCEbaF/3d3m7cCFUb+JnYbaHfzqfMB6+wDbaIUgOHscc8R4sgoAnqcYQwfi7r8uq1iq1obNtNpeneqii//6vaeOr08u8u1ampj1FY/ni8Kz8pcO/p9PooVrvYrjiWD5DG1G6tCMIBHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199018)(8936002)(8676002)(41300700001)(9686003)(186003)(26005)(122000001)(38100700002)(82960400001)(2906002)(64756008)(66946007)(76116006)(66556008)(558084003)(66446008)(66476007)(4326008)(110136005)(316002)(33656002)(5660300002)(52536014)(86362001)(478600001)(7696005)(55016003)(71200400001)(6506007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M4OMEV+Sv0all7ameLOKAXpum9NsyQr2mW/GNHOoDgJfbnA60Srig32NSXeW?=
 =?us-ascii?Q?4Oe3mtnPiEusgYS0SSA1jzDGWf96wDJ1K1bUYsklbxCfj6dLuci28jezoikB?=
 =?us-ascii?Q?30CO42tqMdJbFuTb2RyP9n+3m6lcRLv7Q0ebB3TE7MR7l5ahT0qty42m620g?=
 =?us-ascii?Q?zBSi/KkBoTPD7+MloptVYAsvP8dWBL8Y8uqeKwOPuM+BEVa/X1p5l3u7XNi1?=
 =?us-ascii?Q?c5DBRA16qIQh2HVQ4Wmugqad9CXTO5WXobmIQ85VHZun1ruN36stBOsUujjD?=
 =?us-ascii?Q?VKs1G6XY72gXamJ7Z34VB1u8TpK92KETzFAVRACypzkAcMM/e9uW4gRz3/WL?=
 =?us-ascii?Q?goYl3yJ0J4MhhrtZmYyb+FG/agExhu/YdFPURfRLw58XnqDzmZ9RWu/cMICf?=
 =?us-ascii?Q?Fqah4F7oTBS/J3jki7h9pGte092LYQIGOCMovFTrV6H2Vfkd96KNBIuzMbH7?=
 =?us-ascii?Q?tuDTIhlmFynXTkfrX5ybEvvMs50Yl1Vlc2LV+AmZoOpJgpRSHZNnshAKizKP?=
 =?us-ascii?Q?UpTwxtuUanK+pzJbSdlPiMW06M4pZfiWAnzahzwQhPOmyGWX25hrUKvpGpmT?=
 =?us-ascii?Q?13Dung2HE4xw1lqz/Up+Xnj5LKXQdZNl1TbPHNop03/nIMH5aR7/ot6jfW9a?=
 =?us-ascii?Q?LGBtNk26BBTvSkLn7ucW8At1VNDJG26VSYcwseg4UjwTwEGdeK9MVqZMrGev?=
 =?us-ascii?Q?x+Qmriogy8Fka7slg7NGijF+Hf3yTO79I51YQmQSiPyveGL60yktvcy+inTi?=
 =?us-ascii?Q?Le4pp0xArMmaDi6JIoEyPTH3NTiAS7wGObzjlqGZBMg+U/9WZIRWiQPWQ7oq?=
 =?us-ascii?Q?xumw9ohckOwjMM21MkZBoRaujW/EHa+HMNTuQHv6MdpWyAmKacsyjdFzXGDl?=
 =?us-ascii?Q?u2+9xWk3ws3VMb36kpIbOv/SLGmS1O7qMiUOFkq7/HY/vjNrLd5+AAMAh+BQ?=
 =?us-ascii?Q?NdNV3JgS/JtgSvLXR1DJ66VdZR23B6sB6/21T+RDHgmg6s5QV/JVHzNYjF13?=
 =?us-ascii?Q?nrUNeE7z9ncC6xG6EziJY639L2H1MyeqKmnDyqZHzMSUGHU7pQWXIXZ21qQM?=
 =?us-ascii?Q?HUq/gJgEKUDbAmAZ6P0i18W/kAoeFhdadO6x40WuY5l6W1scGNrIlrUqSmwZ?=
 =?us-ascii?Q?NCWogiYCoKuF5vUKuGBwRfbwIhHnb3O7eQw3N28DRwcHHMDijxVjl0TUKvka?=
 =?us-ascii?Q?Gu1pmpR/Hii/1USz+4xFjsPSiV1Ue+ySa7SK1JjZa5HdbF6+MX/0I+Ekh9TB?=
 =?us-ascii?Q?Rq2Xz1iMlP6zOFNCvSFBb9KxcRXsjF9rTvjL996GOUf0mAktQ9slvbfk/cWN?=
 =?us-ascii?Q?pfPjcPIuddQ+7VNWs7YVH36uIkAI2jeWYdphepuejUzhFJmZjhw5zU7ohn/O?=
 =?us-ascii?Q?avr+rzrnyu+iTcVMLhDDOl25tUuyA6NGBHQOyQUbrhoBZn3ZXkMuwMLZrn8x?=
 =?us-ascii?Q?nMtru0s3K8/RlpZXv35FjIMh/61oLJt3GGzFA04434UHCgaApxXxIlxsWoit?=
 =?us-ascii?Q?AXd9a3iGDs1W8mC5NDbve14ic98CpmFwBAUHXUTc8qdKWVOGt4pvNswPR5v5?=
 =?us-ascii?Q?fm7n26NjHMZfy3tJpy8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 191b5f63-d380-4750-c9ea-08db0b9a23ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 19:08:05.8178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9zsNdr2pW0Qq2IgSxtQEYo33LHRpgQH59rVPZ4VZhd4/0rdYs3ydaTpn94obUKd6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1365
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: nzgK9fVLqveebeqZJXb-dR1rJv41mZ1p
X-Proofpoint-ORIG-GUID: nzgK9fVLqveebeqZJXb-dR1rJv41mZ1p
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 mlxlogscore=677 priorityscore=1501 spamscore=0 clxscore=1011 phishscore=0
 impostorscore=0 adultscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100160
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Unfortunately, this change reduces performance by about 5%.

The driver could continue to use functions with AVX2 instructions
if AVX2 is supported, and fallback to functions using only
AVX instructions if not (assuming AVX is supported).

