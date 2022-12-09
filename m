Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FE3C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Dec 2022 19:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiLITQk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Dec 2022 14:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLITQi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2022 14:16:38 -0500
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418E275F9
        for <linux-crypto@vger.kernel.org>; Fri,  9 Dec 2022 11:16:37 -0800 (PST)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9HeocT014045;
        Fri, 9 Dec 2022 19:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=ePJHCNlb6jSyCK1p3Oej0dyWB7dHEZEw4ChNc3OcuTM=;
 b=LbVUU6pb8qcHmH6+GgP7mJNobIx46juYrCY8WuTigyD7vW93EYAlQqy3+/1YvhhVyjfg
 WDZeMjx1G3rtg6LXkl46bP7Nr+90UlvVDxtK/psvsnIcYtrlbLUSRcCnDc40h9RGThKc
 xPVUJqGQ8Wqrf6AtH1FCEqaoPS+FyPKn0++Lo2zMe1Z+OxZPLrunqujZQ23kIWs17R1L
 uyRyMqaow6Jx2DPQjMAvfB9GWGM4Tkv1/ezXQvq4+go5w5YFsW5tL47gdPr/9iuTJtVN
 8JU+OoQhoTZ2qwtytEoPvk/W6QbylxVsIyjNxm5ePlJzn8FxXEmB2bPNIEQVRNnGmh8/ Ag== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3mc9mfgnt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 19:16:20 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 1137C310A0;
        Fri,  9 Dec 2022 19:16:19 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 9 Dec 2022 07:16:03 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Fri, 9 Dec 2022 07:16:03 -1200
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 9 Dec 2022 07:16:02 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enfr9ZAXy8oi83AOvQ8/tw1f/0I2jc9mJ64wsOoqBABm/pR/14Ui3+7fjH3npSNVnsuZArsD7K6Ox5wYruqizoW0vRVUjWWyrSgGdDI8D+/FuRaxX2L+D19Hf6bHmyvh85eaV7pcXwFs5oI6i4R4PfaOMiRHyTU7YuQJgMU8Dy02Rg7suw+7qBpSALmTGcRrlF82xc6+oqNAKp1Ae0CX/NC69r8h1owBnf84g100WblaqbVO7YYopasyLAXLxTDbl67XfPWc3F7MD+FHG11PFT5DBjlPS2OcNe3QiPxcz/67H5lFif/nclZt4QaWamHOi/eq7Ev+hxqzEuf/CQv0ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ePJHCNlb6jSyCK1p3Oej0dyWB7dHEZEw4ChNc3OcuTM=;
 b=V2VkT9Puuq+SG5W1pAkieU/chmVQEFiRr9cW/dxsEb70gcU76kPvotohBHZmRu2derkBT+faQ6t92DR1K6UOggHVn3CGU3pQTW4dof5QOxXvhRbmNnaL8QI/P94ZxOpOurHW5FbWcECxe5IJIBkVGuKYWKZHrFmv0DPOeeioPhrQ+DHP5yfCJCkSY1HwBwmYz83U3fOVVZh4fnVWFLoTz6RS5y2cuozm2BhuU8m3TiGyDl2EsSisJhcQodyoD7ptw3eUTAMJxA68SrT9IFaVyeHNyGEuu7oUZPJjCtWyCKWdPi14u05A58FZ93WxNSUQ0/3rfCfdqurOW3puS8L0Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1495.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 19:16:01 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816%9]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 19:16:01 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: RE: [PATCH v7 3/4] crypto: aria: implement aria-avx2
Thread-Topic: [PATCH v7 3/4] crypto: aria: implement aria-avx2
Thread-Index: AQHZCkQw/pdq4Hz77EaYUz9M1f3PSa5l72Tg
Date:   Fri, 9 Dec 2022 19:16:01 +0000
Message-ID: <MW5PR84MB1842C9F4CAC5511B977439DBAB1C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221207135855.459181-1-ap420073@gmail.com>
 <20221207135855.459181-4-ap420073@gmail.com>
In-Reply-To: <20221207135855.459181-4-ap420073@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|DM4PR84MB1495:EE_
x-ms-office365-filtering-correlation-id: 3e8cbb7e-b60b-49e3-b87d-08dada19cf2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sxwofy83KuP3+ctUT2IgliizKTqXabGG9aaU3Li3zgG3MTzVajQayF/kjmSQpr3rRVuLk2vji0r10bNw/NHWeMZQgkB0WcxWibX22mIbtCQQgal0xP5csd8+dZLs1IL5jreppzuaX3elgQnp3K6fG08914Cf5EMdyRVKSw0kfKnvp+etsqByv21IpNzmgS4NnKpTpM2GhfE/vcLWuZZlpzMQ9V93MO8Mrevsxg17EOM9ahyw7WYxwd7fFlGsrwZz7kFbfB2hXyN6LX9RGyg/6qu/mriei9EdCfkIEsMrzqAY+jIKPzMkgkabEKMZNu9s6KQBfmMcWj+KFEehsnQfxez4JkJV9sSeM2ZMxIa+Fa12Q0YBLJJvIY3b0LxvHjR3o/OvZYc0Q7nJBojCSBIxs/hZEri0JZdYF3NU81HpgYDCbj0E49LJUpW+aFB+TBhZ2TjurWWIqbjMvoARaSzAOyKNwCMOuauVAGk2eo/vt8N0S6ILEi1Cn3n2x4bD0aI30g6890966PHYWSjJ5MeaoWnXlppncO0m9zpWotcCrRw+4fr8iqtHS5zkpOiZJXYDR7AS1KvUkirbGXfb6xsnKWGjm4bgL5098Qj0Rmif7wYq8kNb4+awNEW5iTpLUy8OfdvUr/T6uDx+luBDJHnR/PlHQlxhvIivJ1a586lAKDblcc6ep7m/zFBvwZV92RhLlzECxZoN8JZOn67ESv5fYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(33656002)(2906002)(38100700002)(82960400001)(8936002)(4744005)(5660300002)(52536014)(122000001)(186003)(83380400001)(86362001)(38070700005)(54906003)(316002)(55016003)(9686003)(478600001)(26005)(41300700001)(71200400001)(66556008)(4326008)(66446008)(8676002)(110136005)(7696005)(6506007)(76116006)(66476007)(53546011)(66946007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0pVWwN6vOLKNrJupmHJrWPuY1H+UnLvemn5HGrm0RqG2ddtPE6E40BU6jNAj?=
 =?us-ascii?Q?GdIFr5slrElWzVesdzHk4EPYX8yrjM0F6i4R0Q2v/w96axIOxjC0u60nV4oV?=
 =?us-ascii?Q?b/bVSLJqSHbBW72eLx7mi46vc9CxWiynOgB4FnBQzg2hYqDcz+AT1tZLLBNZ?=
 =?us-ascii?Q?v9TDN5jt+J5gRTk7HpzGPF8BQIz3yH8eWyVbl+S5tuEha4kupCu51O0QxYZT?=
 =?us-ascii?Q?oFv0b8qdnI7MK7pLGbwgXMDDVzTem4Zxk1EwY6TuwcBx6iPTKowX6qdvrhHh?=
 =?us-ascii?Q?0sprEI8NDrtXETYkQNWbVPabqIPKtXhaZn7wCYtlu4PQcb0Ej8O2ZmV9uRDN?=
 =?us-ascii?Q?ifuvoM24i6/3ZK4oGnO3HjDYkeFy7HWKUqJnlHFj+vvPaF4amuO/tskdPSi7?=
 =?us-ascii?Q?EPcN1xjaC/jdO9rPSCSirtIYgmNxvUzqSsIQKHf1wrLTi6zzsd35cQg8zJRV?=
 =?us-ascii?Q?jSw2jiVxmQUyYnFdDFfkWW+ybGcEL6WOHeUKu9rV6k0NjCGo/mNye7WfxWgw?=
 =?us-ascii?Q?XHFLvjkaXFD0q9bAI3JOPOk4sIDlag0PRax+UbmtwfYKHJNW4KuUy4CoFOBi?=
 =?us-ascii?Q?NUPCSMLZ2GYFHTbKAci+JNvncLzRlQVObdDs2lMvMNCF9DjkBkLbeD+P7s0t?=
 =?us-ascii?Q?sctg4PHRykegS/TRHjlHvTsyvYPqqjwE2ZAWVPY71clyPJ7wuzLl59BkteC3?=
 =?us-ascii?Q?V8ycr/N0y6BrQ+iVhpVVS8aLRz//P1BUC9MZ7LWMQwfE+9c1XKWjvnHihCXx?=
 =?us-ascii?Q?oLoNOl97avh3082ZgcpMI7uHSjNxG36sA0twf0EtAE1Qc22DzrCGIy/Oszlu?=
 =?us-ascii?Q?gtpxXL6vPmcgDC5S46Xz7XNj0Z2cXKAaD0qYS6tuS11/KqZPSGLxTUY5i3sy?=
 =?us-ascii?Q?uWlI6asjpHNHutounmEfOK5FLmPyy9bj9vTqu1DC8pW/Mj74yCIG5IBwAsVH?=
 =?us-ascii?Q?gvD1glrMavc6zKbudCBcsCCtinorQDxrWIm4ZZiXtC9gzDjNqyb2dnIpgQqo?=
 =?us-ascii?Q?Fj8L9iQqImNY1YciKwIdxhvSy+yH9xHQhS+e0YIIrSs9V7MJ1ss92JsooJKN?=
 =?us-ascii?Q?1NPGAEP+B7O5S+Hobw82p1Aa+TMgxCUDbH+0moW+7zx8H2Vl6tAPpYcqmKQz?=
 =?us-ascii?Q?lqG2XF0f9HPoFdvtmzLkBDfyhG/CnatHpVZugao/P3NYtcu8dTjHp48+g+ao?=
 =?us-ascii?Q?Ehc7xrnG1QodciTYfM1Z+hZiUXMIGCEizNoSMGWT15kkcBP88bR1f+zWfN7S?=
 =?us-ascii?Q?HS2S3JJHRGClx9RLfLQCVYIYbip+aynqk9hunb1NNO1S4Td0oYzW+V8f4k6a?=
 =?us-ascii?Q?2fs2h2/hb5PDN2a+sx+gGf0VXowvVgykeRVFi0+lQJ/TXecYmcnq2O0Mxv3+?=
 =?us-ascii?Q?QMZSCooCKMmUsOeaHCoRPF336VKAy3kdGBir+iEolcM15y625D+l1VsuGCOw?=
 =?us-ascii?Q?VLg/cSSwyKmNGhH/GT4yDF1z2H+/BrrsE7dwnATqv5+IVvLOZeOegyZe7Am6?=
 =?us-ascii?Q?7ZESNQY1o1Z6Wy2N5J2g12UBxKO4WbiwgAPiIw024pGD9mQbXbwLyMeyn+ES?=
 =?us-ascii?Q?TaH1aFMcdBBIvfEkDrQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8cbb7e-b60b-49e3-b87d-08dada19cf2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 19:16:01.1107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M8jHSQLD6SK8lZzgS3AZqvwAj5dJDR6ZW60YzoJSQcYl1Ze3dqtU6+FpPonJ91fD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1495
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: Lm02onXKQK_xM7i6q5UWMaj6ZrJuu89Q
X-Proofpoint-GUID: Lm02onXKQK_xM7i6q5UWMaj6ZrJuu89Q
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 impostorscore=0 mlxlogscore=523 phishscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090156
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Taehee Yoo <ap420073@gmail.com>
> Sent: Wednesday, December 7, 2022 7:59 AM
> Subject: [PATCH v7 3/4] crypto: aria: implement aria-avx2
>=20
...
> diff --git a/arch/x86/crypto/aria-avx.h b/arch/x86/crypto/aria-avx.h
> index 01e9a01dc157..b997c4888fb7 100644
> --- a/arch/x86/crypto/aria-avx.h
> +++ b/arch/x86/crypto/aria-avx.h
> @@ -7,10 +7,48 @@
>  #define ARIA_AESNI_PARALLEL_BLOCKS 16
>  #define ARIA_AESNI_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 16)
>=20
> +#define ARIA_AESNI_AVX2_PARALLEL_BLOCKS 32
> +#define ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 32)

I think those _SIZE macros should use the _BLOCKS macros rather
than hardcode those numbers:

	#define ARIA_AESNI_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * ARIA_AESNI_PARA=
LLEL_BLOCKS)
	#define ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * ARIA_AESNI=
_AVX2_PARALLEL_BLOCKS)


