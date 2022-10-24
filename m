Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A0EC67871
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Oct 2022 21:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiJXVgH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Oct 2022 17:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiJXVfx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2022 17:35:53 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C4A2DD8FE
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2022 12:42:47 -0700 (PDT)
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OFW07q018190;
        Mon, 24 Oct 2022 16:22:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=cbCsv0QFzBtyEZ1cCYV1EooLu5KDgYj8My7PprHvDaI=;
 b=Ds800kAdPkyuRFGwFHnkz3q+24eqM+1mALy4PBBasSgynwdVS6JKU8sKk5n3AKDuuOIz
 cFsQ/J/vu7KIMN/jJ+gHf/9C8Ed+JD/1bk5s+fnfQulu0Ckf+reUtl7qMWBi0OeYv5i5
 xbL0tIrpI8skMRZ83TUhvW236b1fR4mm4Ds48DZqlMTOWGhEAAQA3fBTmQn7UfFZeCJg
 F65Ns+3XxBv/J0ejEOteYPKppYCGBMyPF3Q1YqpIfR9j92bMGduubjvY8MqTpCLoVNNG
 8O8ttQAyEB3+KmebJRKJLK+zRTJSKlfs3v/OeXjQfEZqZtfh6wIWQ4nPrN+LYWaueLEf bA== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kdvpwh978-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 16:22:08 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 0C251804717;
        Mon, 24 Oct 2022 16:22:06 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Mon, 24 Oct 2022 04:22:06 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Mon, 24 Oct 2022 04:22:06 -1200
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Mon, 24 Oct 2022 04:21:53 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLSMAi02YkHsGFh6lgYXsHdskhyljGSwJnhzH/Kbt6F4Lh4rR+eCZfptwvql9rEQfvjqlHUWiCd6rK66Zm411oVxHnLNDUW6gSaLi5lzRdpgxTMKEcMv47CRHB6piS4KhKUf4wEIx0fvr5xmx738C69iEe1B02uqfPwoYfSBiOJGf1UZfApNVPaMs/r0x3KPH7vyPSwjvVwe/7W1uLBQilCgfPBDEIwECpatzBt1/tF0oEzSk/xKiHbrx2sJJNkrbbLm7lWitsvGpGIOAkEHwd1ki05L87vp/nkg7T3D34mxzlakvmnS/VDGoYz46ECECA2xhuehXJlcgfvQDH+BRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbCsv0QFzBtyEZ1cCYV1EooLu5KDgYj8My7PprHvDaI=;
 b=TawaPGDsi0CEz61Ydr1MjsDV0R/os5PbJLM15sE6MaYJzDhb5+a3tdI+OeD+L5dU2x1TfB0X+XvN4d9nQjkhZr2lcoHx6bW9amCLW5ew37kt68AItvK+ibaoK5F6mcSLFfJrjMLKdXq6hGeIkcS+U6oRFlAqQu/06BqK5WLMvn5q3MPIYZGtMjmXZM03KDd/T/RxBMGbf5pcLNHBAEDb6QoD+wDREpoVEY8AsPRwY9GtvNn/j41aGTceOAOHf/hb5r5GJOXgjeoNQaBV+7wbMQGA7EgA7V6848xq+5iGSwQtuoOwyaGwkYDlp/jB/VW/Vphi59v5QBuLVfGw59EP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1704.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:153::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 16:21:52 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%6]) with mapi id 15.20.5746.021; Mon, 24 Oct 2022
 16:21:52 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jason@zx2c4.com" <jason@zx2c4.com>,
        "nikunj@amd.com" <nikunj@amd.com>
Subject: RE: [PATCH v4 3/3] crypto: aesgcm - Provide minimal library
 implementation
Thread-Topic: [PATCH v4 3/3] crypto: aesgcm - Provide minimal library
 implementation
Thread-Index: AQHY53JRmROP5LQjMk6M+X0YaXvnqK4dtRDQ
Date:   Mon, 24 Oct 2022 16:21:52 +0000
Message-ID: <MW5PR84MB1842E8E6C99E4C9F25A1E95EAB2E9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221024063052.109148-1-ardb@kernel.org>
 <20221024063052.109148-4-ardb@kernel.org>
In-Reply-To: <20221024063052.109148-4-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH7PR84MB1704:EE_
x-ms-office365-filtering-correlation-id: cec10f3b-e38c-4e83-46e4-08dab5dbdc68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTvKXUf4o40XZzOXVEr0LDUYJ4WB5ZLnp/moQLtJvxe9dNKt4qZ616w76GiVGiy70JCQnmmDlezjgwTi+OrQuONUO7TwYn6Zj4bMYC4+x2bfodbLlY/ar/pR5G5CQpA7e1HXlUQFwPPuHP91oN/yz7D5uT8yC0qtNVfgxR1YMRD6jT8QouyDc65uku5gJtTWj0tLh5xeU3QoQsZs2gWusj5wQcaaqFT5m4wx7WdrWA3wFKjCG8K0FlqnmdjXjtBGe9UAgircbmypru/mm4fJN2kTTy61b60sw4FnEvvZoqtB6TUbiWgwVJvTSMu/+kRTxM+yZ2LkqhQD8Ud4SeT7UvMwDuCJ1Q1siNzQ93XB5sdoCi6s6aobhy5wgbUdubqPYjDfBe1PlLC9CjhE2ggV9TguSKabTKZK+MivSc3e9da28ukHe0ZhiOnc0GYazb8MDbiQwcR8dh1/6p2kMNccf95hXbNtOUYNVhTp81DWSBoEXezQq4pdULMQyPoudfd7NWjRGlD0JOQXtzkeZfDI/99j1H9gcX0nSV/tivsigjZxm8Qxk9KufLTemGinxJd0NWcQkw8Pq2PJPHUqbMefSlePET3FbC2vHMIATuKjc9VSsP4aLuhxPxTE3kP0ahlLFOAJmECWJRqYTjVD1sN/26weozxNnlDzNUIV2IfmCUAaP/rufwh7R2fNPnLZLt6q2NHSZebF3eZeZwNXfnxdJ8InmEF4SqVEOtNv5ftDQJQCYRM2Z/FkfBonSd4FgSHUIrkfM7lTCxvXLSXm56/skg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199015)(2906002)(122000001)(9686003)(33656002)(8936002)(82960400001)(52536014)(5660300002)(4744005)(41300700001)(110136005)(54906003)(26005)(316002)(55016003)(186003)(86362001)(38070700005)(83380400001)(71200400001)(66446008)(6506007)(7696005)(66946007)(66556008)(66476007)(478600001)(76116006)(8676002)(4326008)(38100700002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U4YWTgTiOsJY5eZJFVfgJHv/QBGcGKxfuVr8ZvSRMlp2m5XKDJxX10AAlIte?=
 =?us-ascii?Q?mzeaRnMsaERORPz2nFH24gs4pci0kAIeILlUxSHh2gT61R2cbY3zMUYTcj+n?=
 =?us-ascii?Q?IieWOQETyjOMk9uQnKmCo2xuol0iUIpHlxt9C/ftCBXOl6sD+3JiTwiGjH/n?=
 =?us-ascii?Q?k7dOUPhzXMCj0aAiXYrA7gEBATGIe4fk6Ovoe5WzRkhGxnk0nIpa/1MjIKB6?=
 =?us-ascii?Q?unFthnBSkYmpd+Qky/m/KKAm5iMmOpcnSQ54VnIKhek0tk2ZIjt7N3KVX8h8?=
 =?us-ascii?Q?mv2VPq9VnuiFB9ysz+xlSOyc1+H34sFQZwO35s9L1xNgvpN0OPxlOPrCgKrY?=
 =?us-ascii?Q?cxDqDu/eHg5iALmTlRQYOLVSUGsNo+TueMYA3VaVC8DJBd+RTco7GE6mfGJB?=
 =?us-ascii?Q?SBFVz146IcOhPodjk2QS0nG57mOffnnxDyWD25mtkCE8b95lFQCI4GDseSjE?=
 =?us-ascii?Q?/iQtDI7hXvPQPTyJxvRfZhKXw34jEook3cb6GcDE0HYDE6cNO/0cDT3i8LGn?=
 =?us-ascii?Q?8qDKeQj3yJICIIl0kyCvd7XYZzdLe7zG+ThSPLlVOmhXqMox2AgzhL7VtD48?=
 =?us-ascii?Q?loa2l7SajEKfdXIsugHiMvW0bOXWaLUq8ibEzB4waA+MgXeUkNa0x0f+e2Gs?=
 =?us-ascii?Q?FyDa5C86P01asSdqnyDJqfRn70MPkTfjpsSlZ2uch7IuWvaGH6+C740he7c/?=
 =?us-ascii?Q?ptxZN1CPTDiYLFArsZ/UO3QovKwoJ8LzhOAtXTaX8Al2SSQFoJEqOaRkaTFK?=
 =?us-ascii?Q?krN7tBqD8hQAddZ4ii7SEfsJN2aCHsIzvSNVrHTfLswL10bb/CbchPfBBp/G?=
 =?us-ascii?Q?bsZB2ABqsMmwgS7A+kfSkMxbYzr/YsG6SFKY18E0PG+AfdHa2EHCmXR8CyjV?=
 =?us-ascii?Q?jecw46d9/bmgQfayAEEWz5r9gTU/6OthHTOjgFFww0oPajXyz6Hjy/zv01h3?=
 =?us-ascii?Q?iwYah+dALtO77l3q4CztgI9D1Ff8K+cDYBNB27hjSYCCCWnN/FsSad9OtmlU?=
 =?us-ascii?Q?BX251T8q2Bsco6fAogRe3zGM8FughVkj+poCTp19qPdCoYmqj4i4B+Hgb5zF?=
 =?us-ascii?Q?8JOUNAnJ37s2WUkH4TgdGzRkGIQcZXfX0WbXy4E8uRK9c3ry63RDcdaMpDiW?=
 =?us-ascii?Q?w8/UElR4D5bYVEL9MSliKbzwKuZk6lgKey60ymAM3jA/LwKEfB8W2HBKppr9?=
 =?us-ascii?Q?g1xW9TFjWcC02OJwuBQA6VdCTHvVqpUm4IqBoGxWLFTkIAcxcICgC1naah5J?=
 =?us-ascii?Q?7ztTu+GvhzhM2rk/YuQkVo7H6k1WuWFNSGoAxHM8o3k5Lcpq43RInawd4TnB?=
 =?us-ascii?Q?teuTmVWG9CSxtP+DTwBId7mRGbXybRPBTdTkpsMHZoSCsu+Pp9acl61FY7Pp?=
 =?us-ascii?Q?gQAEB7VzKvhifRV420XahcfQKhmgsvE+bvyYxV2fVOEmEyAJFltUIzfgOiGe?=
 =?us-ascii?Q?mbQ1X8GQCkgMEM4dhOpBkHyzfSu74Asns3T2sD26cnTARqR4iO7uSyjkYmXk?=
 =?us-ascii?Q?jN9P2S6ufR+S8R5T28HQxx0hP4l1s8Xh/vIVk82PZzZdq3fvwMf9k3vzi/Yv?=
 =?us-ascii?Q?UfBKrgQFMgkLbENzJDw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cec10f3b-e38c-4e83-46e4-08dab5dbdc68
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 16:21:52.6320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbGHfJ8K/cOv1Bgo0wso20xf7oTod28e7HSozB2sGM/EE8I3fWGzFCoqmYvRWcor
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1704
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: F68xgm4xrCxm0reyx2mYl_Eytd3OGor7
X-Proofpoint-GUID: F68xgm4xrCxm0reyx2mYl_Eytd3OGor7
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_05,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 clxscore=1011 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240100
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
> +static int __init libaesgcm_init(void)
...
> +		if (aesgcm_expandkey(&ctx, aesgcm_tv[i].key, aesgcm_tv[i].klen,
> +				     aesgcm_tv[i].clen - plen)) {
> +			WARN(1, "aesgcm_expandkey() failed on vector %d\n", i);
> +			return -EINVAL;
> +		}

Other self-test errors in lib/crypto (blake2s, chacha20poly1305,
and curve25519) are reported with pr_err. Could you add that in
addition to the WARNs?

Also, they return -ENODEV rather than -EINVAL on self-test failures,
like this:

static int __init blake2s_mod_init(void)
{
        if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
            WARN_ON(!blake2s_selftest()))
                return -ENODEV;
        return 0;
}


