Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB6CC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 19:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFD1E61207
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 19:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhKMTPo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Nov 2021 14:15:44 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49896 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233692AbhKMTPo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Nov 2021 14:15:44 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ADEKRQR014541;
        Sat, 13 Nov 2021 19:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MA+Hsm9C+VQlIgKYo6GarmVQQvjVVRF3ePDDGSWj4JU=;
 b=pvc+Sa6gf8UyLU5NROhwXZJHHz93jZdW5fxFI04XNAm5Rs8cX8abpcYZmJGeMtBn3tAX
 e6RuzEsMm+sgBXouQCpuM73KuKRHDNYk79SaLovunBS7hW6QZwHh/zj7pXNpjB5l6Mlr
 EBTPPPbR6+CJqFReGc13zLJ3fziBUTkoBxKq3xnNOCnx20olFL/0cGv3eSRzrh4GHmfL
 sZFQh1gAAHa4dXbGrNN1ZEgtapO23rg87DsPG1/E4vqut5w3lMmGUjuhFYlRltPbvn68
 2dfKQEc2YaR8aR48NHcHaFA5rijnOOjW8mEZXdJ1pSXCWkecmU5CxlVyzvXFrd/D4qFX 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ca452sm86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Nov 2021 19:12:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ADJ6ruo079729;
        Sat, 13 Nov 2021 19:12:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3ca4pkanyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Nov 2021 19:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUB16i2x3LNrQPRrlvEykqzLXNJx3ShI47nsywD6ZmaO9mMumnrLASdP+7ZQjghJEC9Gsi4HT/OGyOxvEmJO7l3Jjld3l5UfEBxHOQs1PyDUXSoHYXpMV0dSUv6NDsAplXObPpW+9opvmV8r7PS5KsxkW1KdfjdpdsD2dfcyNpocXvAM2w4AAfWfVdtHH+iKKvTqhsZtlkx6XIQuF82/bQvZ18YUg/16LvwIaPQlzv1Bms3jP1SMX56aXeH60JQ2Z94DJsjZH/9YfhBh3JSsrHQCgFHsRwgSV1xdDvmOBT/6+v3pKqSWwm/OukV5EWN9FQXAxwYE8bwpJVLesln16Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MA+Hsm9C+VQlIgKYo6GarmVQQvjVVRF3ePDDGSWj4JU=;
 b=k3pQW5D/4mV6VGh645ib2cIA82qU2igAa8VX08yWzo8YOhM81/9wEV/6rGDvTvelEdFd6uSP7VasEXN0gSE5EtQLRigT2Oc4CKahnW3rCbCNedNInnY9nFCffKMKt6wp7gdVw8JpyAKqTrtmuQa8Z1KsPS1BXQ2lU1T6IUTuhApDM/8B8fg0ZkG3udciGc+a+3iIPcd0r+mNXs7vGTUxIE8gRPn9ffH28pNSMqoVtLVo4+yuCzp5ZZIE9psweu5r9Dn9wv427Cqsuu3bbRJB6yA+vIkALKdLV10HKsSAURI6Nq/iyzJ882rObMQ9Z5Apq28M1IwueF9IDTfB9jW7YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA+Hsm9C+VQlIgKYo6GarmVQQvjVVRF3ePDDGSWj4JU=;
 b=fr0bD4f8Uz6wUGaR98l26rYBoLAePr9PuE/zrMT26sBpxvhh5OlIs4FhAum8gj14uycNz9Ugqddm5yI9HYCfzH0PpcIuAQWFTHoGK8+mp2giFGgp8Fx7EHwSt28921R7XMtPXVHmeXudpvHKBSx1LuV1iU0ljjwdtMEAx05XUJA=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3415.namprd10.prod.outlook.com (2603:10b6:a03:15a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Sat, 13 Nov
 2021 19:12:44 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2ded:9640:8225:8200]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2ded:9640:8225:8200%6]) with mapi id 15.20.4690.019; Sat, 13 Nov 2021
 19:12:44 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     David Howells <dhowells@redhat.com>,
        Alexander Krizhanovsky <ak@tempesta-tech.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Thread-Topic: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Thread-Index: AQHX1/X58mV+Icz79EaIVabYCdvL7KwB1PMA
Date:   Sat, 13 Nov 2021 19:12:44 +0000
Message-ID: <46C06033-B65B-473A-91F1-584878354C72@oracle.com>
References: <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
 <YY63HENw3fjowWH0@gmail.com>
In-Reply-To: <YY63HENw3fjowWH0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77c5479a-cbf5-4611-68c5-08d9a6d99294
x-ms-traffictypediagnostic: BYAPR10MB3415:
x-microsoft-antispam-prvs: <BYAPR10MB3415C0961616EA08EE8F2F5393969@BYAPR10MB3415.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N/VDvBkzs7O7idqIHofV08oShiQDOcoB2Z2Gg3K46UeWHB4v1/hEU6HhvLKax3ZNuAitC7mlhhhK65L96toBg/meMyR3HdchL6zvY6NAs3cJ8l9Ej4Gx5S81LqqTCgkheAgzBOaxsKrJmrmcJOaLCdmPkq2Mmj8DA4CtysuZdWU5Bka4Z++xHyMWDQv09ydOQ7atly3jheNxLdQh0wp54wNHAeljZQXB7knUk/J/X16NINWPla1Lbok2KfLJVlJQT7YlwUoerj33cxD8d0e/hJTx0szxdep5OGI6EINggyQv5Y/F0728gQwKTCQY4nvUN8nf+KzmvURNkp3UwdJYriH6mZgVGGLUPMxJV98MbSnSoXctDHHDy1xdJoQUALnidlRSiZpXJS0r+Qhk0C3tG+Cq7vLRAMyYqHglJrziHVakMdko1sbgKo39b7QH5QgBEQ2S7luzmhVlQs05iD2MEVj2mirb2Qehj9dPuYaJuYM23zNAJA5J8Kg0SDL8M9fhsKQ4rx3qpBEN38xmo/knQNtBDwZGgGCuwz42VqrXAZ+1zf4FlzVbyvEj69F7H6DMez9VgXXS7gcB3KfzS0alslZ3ZrO/0MPLstRsMgr1lljMbSHVgWYHx+lv0M3rnVj15P/gW4QFWJ7IFPr3CFcrzvMYSmqd76u+oJ29uLkIvD0tJACdWGmftP/9HFNXjWMwLNlcokrF2+hvkQAUr9Ycd8mmBcNFpTZzGJkCWuVk1TwWDXSORJpM+9nJyr0NEhR2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(8936002)(66946007)(53546011)(66446008)(91956017)(33656002)(64756008)(66556008)(2906002)(6486002)(54906003)(86362001)(316002)(6916009)(66476007)(76116006)(186003)(2616005)(38100700002)(122000001)(6512007)(8676002)(71200400001)(508600001)(38070700005)(26005)(36756003)(5660300002)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?olaOmm90EhspaVVtAX2r4Fn8OGhzj8BdN6CSPpY7+G0p1MQZmHlkTJre38KI?=
 =?us-ascii?Q?bZjTOixwOC0gppuGdl2wLmQxVLHN/ca4er+yThKJpYIQFfNHcKz3yWblLx7h?=
 =?us-ascii?Q?C82hp128uC9Zp8FYvWiNdey24zz/5VpcTWfzgYIwTD3oQfcQUPUwY8rwR0mu?=
 =?us-ascii?Q?IanuyYb3EaLzJLJeRg2fcyYGmd+I8igJaCcCyYpxtoboe7s03vwaLMLEn0JQ?=
 =?us-ascii?Q?Z9qkr/vzqMk/JivjPtQR7wUHG9Sg8iYbTpNDOqpOe5pwO0NhcnDrnOG+0CaE?=
 =?us-ascii?Q?ctP8YePtRHW6t6hNb96wqIF0/7aFlpTxdtxtW3GGt7OeLduW2EkgNat4s4uz?=
 =?us-ascii?Q?Ma+vlHrz54WaTHJK8z6Dz+nIXcOEiKFzSJd5aRkjPlNfmQS7/fr3DA7V4aS5?=
 =?us-ascii?Q?F9/TTkUkaJDEBe++0wz145wXDfcGuZA8rk5XIUAv82Y+T1ZqA+3d9s8pv5IQ?=
 =?us-ascii?Q?uQwJL/IunYos17eQFS5qE52BGcZ2B4GBOpHfE9jvIfGFr4p39CnyOpNRUUty?=
 =?us-ascii?Q?dZbVmZei/hF6g9d0/KVfwHmxGyu/0027NWCoY9d/LOaCzuQovW7Pd5Q9YWFL?=
 =?us-ascii?Q?uq6I5SXViBjpKWNVk3BR+N7+P5cwmKiFAPWGoNXSkT3yWebOHJ1p6P0S677r?=
 =?us-ascii?Q?30AlGIF5PsKu+0ODIWHT5oNMmBjd7RbyGzHZvUseOYmLh4OZhYBOVaKpq01W?=
 =?us-ascii?Q?nlDlap6GWhlrzbnM4mflgmTWtUqC5E5IQ5EyQOVcpHmEtg12+217RYZRvyKt?=
 =?us-ascii?Q?H6gUg0CBSS83w5fIppd21XG1VCYftwqk4I1MYcLHPkUUBi5i8e7oZI7Q8Fth?=
 =?us-ascii?Q?btBd3vJcPj4gPk7WW0VyWOLh39qwkZMhaK2YZVHTtADEkvOxNxBrzOzyA2+f?=
 =?us-ascii?Q?5AVFkg6elUSZtf/w/kj1cRperWJTOycgm6pPY5LW0oZ7auLhvOhGrhrFTr/A?=
 =?us-ascii?Q?aDXIJuTaepBFaDaWBAO3zCWAEzRmHzXhU5b8Se5z1kYcc6dcgShwlla4De+g?=
 =?us-ascii?Q?DPuyUCM0gwL7QizAnIQegSl1BJS2QF6cx2cks8Opb0YL8VdtrC+2euYCif27?=
 =?us-ascii?Q?eHRo0KzO8kfKkOwwTmREXJpBFottl/6Dy5SxsissvtD0nvzFwHO4DBKqMXWM?=
 =?us-ascii?Q?zrLHwzPmB4m5qE1O35docmkRkGnEeuTm4QKbzX0Jw7lqL+F/slz+YwJtho49?=
 =?us-ascii?Q?EFtY+8H5UxXAHvMKAo65zqbmnvVcHO0CfYPSUQ/hsx7JIOwS5TxftzxR5xnu?=
 =?us-ascii?Q?X0U+TyQtINR/UzF6Q89rbkN2rB8W7DND6L04OL+4JqGp7bCVxVmM1PUrRn2P?=
 =?us-ascii?Q?i3p6xC8GcgO6bLjkWyAS3cbBkPmu47QkF5UEA5HCETU94tuSogy0QJ2skw8j?=
 =?us-ascii?Q?9PXvbz4LbzX5ZIM8q5tf/iaMcStO53adx82CP2i/MXxwe5cvQQSbeCxggdD1?=
 =?us-ascii?Q?7/GZbTOpRwMWfHEWdjAFUyy8J6FQV1ogz1XAgA1F8W7lzR3lJ5Y/OuYQRXle?=
 =?us-ascii?Q?F/sFKa5hQ0yz+6fV40dtLNgRfVihEPvb4SKa40LZ5udqQty5vyT9JQ2BUd4b?=
 =?us-ascii?Q?GhpGbTF7I296KBU/iHF0rfuGyLkHf24oX8icsbTn889lsBcX5MIbylb073TZ?=
 =?us-ascii?Q?TSIRYukkfDFpmnNTEqMRYeY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F62D2538E581A943B66C08BDCF1B3A68@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c5479a-cbf5-4611-68c5-08d9a6d99294
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2021 19:12:44.6690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDzCwTqTuA9hEDu5ppvuke3hnKmCsh6ew4oNbhIyF1EQdlZg8t43TNxegnS04YU9DVFkhbjyskYRX2K7pqVDGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3415
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10167 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111130114
X-Proofpoint-GUID: r0A_G-ws9Hl7jvGALqblN3Ta5MWOWTo6
X-Proofpoint-ORIG-GUID: r0A_G-ws9Hl7jvGALqblN3Ta5MWOWTo6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric-

> On Nov 12, 2021, at 1:49 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Fri, Nov 12, 2021 at 12:39:52PM -0500, Chuck Lever wrote:
>> This enables "# cat cert.pem | keyctl padd asymmetric <keyring>"
>>=20
>> Since prep->data is a "const void *" I didn't feel comfortable with
>> pem_decode() simply overwriting either the pointer or the contents
>> of the provided buffer. A secondary buffer is therefore allocated,
>> and then later freed by .free_preparse.
>>=20
>> This compiles, but is otherwise untested. I'm interested in opinions
>> about this approach.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>=20
> Why?  You can easily convert PEM to DER in userspace, for example with a =
command
> like 'openssl x509 -in cert.pem -out cert.der -outform der'.  There's no =
need
> for the kernel to do it.

Correct, it's not a hard requirement. However, this change does
broaden the add_key(2) API to enable it to accept a PEM-encoded
certificate directly instead of needing to run the blob through an
intermediate step, simplifying applications that might use it for
adding X.509 keys to kernel keyrings.

Certainly, the kernel could include a single set of base64 encoders
and decoders that can be used by all in-kernel consumers. See for
example net/ceph/armor.c and fs/crypto/fname.c .

Because PEM decoding does not require any policy decisions, and
because the kernel already has at least two existing partial
base64 implementations, I'm not aware of a technical reason a
system call like add_key(2) should not to accept PEM-encoded
asymmetric key material.


--
Chuck Lever



