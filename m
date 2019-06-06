Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903C5C46470
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 20:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69276208E3
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 20:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="npw6XvvL";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="ZZtTROhQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfFFUJw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 16:09:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50552 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbfFFUJv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 16:09:51 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56K4Jes005445;
        Thu, 6 Jun 2019 13:09:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0hlzEy69btagHvz167Ug/ihAFb/NDX9JrZFUPX3rIG0=;
 b=npw6XvvLWPsV7xeuw8SPcRtpAMHfJ2f4q+wEr7KXDpkZPhoZuTdWb7tc9ieeRjs9LKOx
 IG4M4FS4cIWfD6xtMJQRpBnrQTMI2Y8g5vfxemqkvuJx6Xn4FNA+9nrgipoxxUjJksdF
 v8/uM5ZEo3EH7ucs9dBiTKE5dEavJoBdn/Q= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy1quhwg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 13:09:30 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 13:09:29 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 13:09:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hlzEy69btagHvz167Ug/ihAFb/NDX9JrZFUPX3rIG0=;
 b=ZZtTROhQ25v9xoqB0DfwGiAKMFGyYu+cdpHFrlbhSIraf1slTKC4U26hBkH5IxJ4HakN8vWu5wYG7jNKqeQNBA9KblxahI7vxSZDq2DDmkLjj1Jg8F0iOPRSutqQVjuN8HpLnW8X36oaXSk7rxrht4JpCflxYqLy9MZhwd6Wc1M=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2169.namprd15.prod.outlook.com (52.132.150.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 20:09:22 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::ede1:f275:2869:8156]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::ede1:f275:2869:8156%7]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 20:09:22 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Maninder Singh <maninder1.s@samsung.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.sahrawat@samsung.com" <a.sahrawat@samsung.com>,
        "pankaj.m@samsung.com" <pankaj.m@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
Subject: Re: [PATCH 2/2] zstd: use U16 data type for rankPos
Thread-Topic: [PATCH 2/2] zstd: use U16 data type for rankPos
Thread-Index: AQHVBwEYf0+ujrSaGEy2U/daRipAjqaPOXKA
Date:   Thu, 6 Jun 2019 20:09:22 +0000
Message-ID: <31A71209-48C0-464D-9578-DBEEF5D16567@fb.com>
References: <CGME20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1@epcas5p3.samsung.com>
 <1557468839-3388-1-git-send-email-maninder1.s@samsung.com>
In-Reply-To: <1557468839-3388-1-git-send-email-maninder1.s@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:d31d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f75e8b7c-6279-41a7-5ad9-08d6eabaddaa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MW2PR1501MB2169;
x-ms-traffictypediagnostic: MW2PR1501MB2169:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MW2PR1501MB2169E47086D6F74FFC4E300DAB170@MW2PR1501MB2169.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(99286004)(68736007)(6436002)(476003)(2616005)(229853002)(486006)(46003)(6306002)(6486002)(11346002)(446003)(14444005)(76176011)(6246003)(256004)(53546011)(6506007)(33656002)(7416002)(7736002)(86362001)(5660300002)(53936002)(316002)(478600001)(14454004)(6512007)(54906003)(6916009)(71190400001)(83716004)(71200400001)(966005)(82746002)(8936002)(81156014)(81166006)(66476007)(66556008)(73956011)(66446008)(76116006)(64756008)(66946007)(305945005)(36756003)(6116002)(102836004)(4326008)(8676002)(186003)(2906002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2169;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qwXE2Xt7E66ZsyPkLwqBrR5v1rG5AIDLrrOIlXU+6rqClnI734d6CkUM9/u7lsN+r6WqtcdM3XsuTzBJHS712rqi+aTq2iK33agYr+zhkJmRpF250WDwuZ/A8g04NML/z4UVh6V2AgoWn5mV7VH/g70bSVdywrzWtJOki3p3+x1JoVzQeLlaOzlhMHV98S0sW2qm6ehTNzpsFSCcTEcTzIJDSeKEKvh4cnbAQxP4pKMpBhvqWB5sKd6vbZs9CtbtUQf5qBN/kNCuMZlda+ndOgeKcLzUAMEe7aQshgUtlM78OxaPZ5QWcB1hem7FsaY+CubQFWmJ45y9DnB3QLQ9EOZfzeeObmGo6CLk+soqPzJIexyTA6Qpq9Xu60LoafgtRa+nIVhbtIVFqEU7/IvYG0z8Xzm8sLmSxfgpOASsNu0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9DD0AFACE9A89419EC2781911FC2B00@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f75e8b7c-6279-41a7-5ad9-08d6eabaddaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 20:09:22.1450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: terrelln@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2169
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060135
X-FB-Internal: deliver
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> On May 9, 2019, at 11:13 PM, Maninder Singh <maninder1.s@samsung.com> wro=
te:
>=20
> rankPos structure variables value can not be more than 512.
> So it can easily be declared as U16 rather than U32.
>=20
> It will reduce stack usage of HUF_sort from 256 bytes to 128 bytes
>=20
> original:
> e92ddbf0        push    {r4, r5, r6, r7, r8, r9, fp, ip, lr, pc}
> e24cb004        sub     fp, ip, #4
> e24ddc01        sub     sp, sp, #256    ; 0x100
>=20
> changed:
> e92ddbf0        push    {r4, r5, r6, r7, r8, r9, fp, ip, lr, pc}
> e24cb004        sub     fp, ip, #4
> e24dd080        sub     sp, sp, #128    ; 0x80
>=20
>=20
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Signed-off-by: Vaneet Narang <v.narang@samsung.com>
> ---
> lib/zstd/huf_compress.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/zstd/huf_compress.c b/lib/zstd/huf_compress.c
> index e727812..2203124 100644
> --- a/lib/zstd/huf_compress.c
> +++ b/lib/zstd/huf_compress.c
> @@ -382,8 +382,8 @@ static U32 HUF_setMaxHeight(nodeElt *huffNode, U32 la=
stNonNull, U32 maxNbBits)
> }
>=20
> typedef struct {
> -	U32 base;
> -	U32 curr;
> +	U16 base;
> +	U16 curr;
> } rankPos;

This seems fine to me. I measured zstd's performance in userspace with this=
 change,
and there is a ~1% speed regression for level 1. We wouldn't take this patc=
h there,
but in the kernel it makes sense to me.

This function is called by HUF_buildCTable_wksp() which takes a workspace p=
arameter.
We could put this table into the workspace instead to reduce the stack usag=
e by the whole
256 bytes. We'd just have to make sure that the workspace is large enough.

Eventually I will update the zstd in the kernel to the latest upstream vers=
ion. I've opened
up https://github.com/facebook/zstd/issues/1636 to make sure we get this op=
timization in
before porting.

> static void HUF_sort(nodeElt *huffNode, const U32 *count, U32 maxSymbolVa=
lue)
> --=20
> 2.7.4
>=20

