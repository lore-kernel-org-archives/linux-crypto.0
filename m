Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC347C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 02:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE126613B5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 02:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhKOC55 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Nov 2021 21:57:57 -0500
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:27434 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhKOC5z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Nov 2021 21:57:55 -0500
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AF2hYVE025818;
        Mon, 15 Nov 2021 02:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=KYygJIlyzdOLDDJSZJZoyAkNmO7cQjjGtkcha/Ovnc0=;
 b=FUgEsnxKUa+C0/zsK2mnoOWhVDKiFt6/BzuBbE698I39ewbWChxFiLP4Nu6YSeUfZER0
 gPcvOg9vZjOf/wZXOeoFYJXAJirwrI4xy12o1po6pO7MNge/PjITLdHERyzboQicapOx
 a8UHu/C9DIKPt36DsEMdqTiXOBgHB0a3CvLmmVnyMiSSLq1f9B1sfX6Sb3YtIDkPJxps
 bdmjkPNPLhyFvq++is1zXlBCz0kKGx1syP4OYmCidV5Eflga0GByrhIqPsE7XhgXtq+h
 +N5NrW8M1YY6bMKWCJ1vVX5ArX2B/HawTl92gu9C8YPr9JWkV9u9AM47T5ZzNMa7kmml zw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ca4b81df7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 02:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I33XgkGSF1lpObVX2Lo3AAlHQJGlLj62xq4FGgrUmh96LTUbmiu4wb/eezNRfHr2ibgoWXLLeHSpsyDIigsPuKhsbi/rKTHnTUd8nBCFmlg/fyvArdq4qzeyMDusf3jdLnwQqSNDywOL0gfiK+FOYoWdiIKiHOxMMYOBqIm85cZVKco2MmmsdgIhdH+ocAmtLm/wwZJidbdzfIvcKgppLeHm1MlXB4/DCjCDORGo81lXmcQZ261DWRXu31BSElchFBC7gHTSndeuz3peiSun+IrTaUbWor7u1Q8K3UHfto0d4QBh4e17jiX5tYzrGdspOWTxgBEcd1WbVK1FdqW0yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYygJIlyzdOLDDJSZJZoyAkNmO7cQjjGtkcha/Ovnc0=;
 b=YD0bI2WyhiJRHreCiZhtDenJ/1LcWItEFpe2yJD5E4rAyPZG+D2JpHNXu5iFsBhxcoGEQ5v70q9BWr3eq8BNqkGxaHJ0D3AohxVt746cS0CkcRhNqUt5wl+Pk7AuBlxZ8zbXvS/5Kk5ENC/XVRKm3B7rXpw7bfSXQF8bikZrH4zc1wQtZohQ/mp//Ar944f+NmDvaA7OcabnbuLLABWEf2ReZjjc3mg+JBCyapEMcXm1UxKw/ynt/SqJCtQuKR3Z9ipJREb2LQ76qpU2qlMqtf8PySDkQjLvskVbuqBtgiDNrZ85XcUmEdFegzLYXXGN0u1FwK6Joo/qx422xIKFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH7PR11MB5885.namprd11.prod.outlook.com (2603:10b6:510:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 15 Nov
 2021 02:54:37 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 02:54:37 +0000
From:   "Li, Meng" <Meng.Li@windriver.com>
To:     "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
        "pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] driver: crypto: caam: replace this_cpu_ptr with
 raw_cpu_ptr
Thread-Topic: [PATCH v2] driver: crypto: caam: replace this_cpu_ptr with
 raw_cpu_ptr
Thread-Index: AQHXzs6MNRGiDXkbWkOiBbqJdXuioKwD+oHQ
Date:   Mon, 15 Nov 2021 02:54:36 +0000
Message-ID: <PH0PR11MB5191886DE114EF98DF3694CBF1989@PH0PR11MB5191.namprd11.prod.outlook.com>
References: <20211101031353.2119-1-Meng.Li@windriver.com>
In-Reply-To: <20211101031353.2119-1-Meng.Li@windriver.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=windriver.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 499036b0-13a4-4be8-b432-08d9a7e3430b
x-ms-traffictypediagnostic: PH7PR11MB5885:
x-microsoft-antispam-prvs: <PH7PR11MB58859A763AA40948CBA4B834F1989@PH7PR11MB5885.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:486;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PsSWsFJLT7+14JIdQbXcVkJ24V7cyDjHeLvrpjGv8NXV+3pqY+GM13TtOyaNzI6XXxaQ1avKEeGEeNF/hb3OtQCzAbsNB2aQqg1jWgQqzq0LLqNZxotc0OoQ9tlIxLFVmkMtZGS43UekEK7V5aJu2QAQP3lTFOErZrcqaX1TgBqZojsvzZzAEySJdxbLH6OyKsP1CBPJvyQfnHNvNVe2/Ze/SX2CzYpha6ngCNaPQtHFCUIAoFtgiT8dvT3hY2reckW4Tfi496eVj3yTy67tBB9myNpbaLn7KZi3TIxTRfqgjTH+npLscGuCz/QgkKKcxiHgNIgo31r1Ip7GYaeQXCdvuzv4IMh2ZnwNHVhIoRZQ3LAhilHdK4PDdDC5ToKBbhcsEgNPWggEVI/4bAtFE07/tKOa5I3dXxUS0vvYOHeI7z3itu4UWnTfGGHvZry9P1aCximGc0VzTHD2zUDhcG0/b+ckOITUfIU9tFLdwfu+hRaRaqPkNhQs3DoYXnRp0CjhZuxdm1h+GT7DcDEGu99H5XCVyQBH77MJ9np6DVb7ROGvlI7oju92be8rIcimEgov9ekFAMl7HIxJYMaeHoiST5nFzvxkow/P0JrZjng4vCW348UNC6g8MDw1wJ/zNkS3ierDUDu4n4V2aM8A3/vIr/RCiQwpO6L6Za9f/mEwSE3yVLQyzl9k4aj6BOGOB6aA/9lzNji7a5Nc0ah/iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(55016002)(7696005)(316002)(110136005)(54906003)(186003)(71200400001)(66476007)(66556008)(64756008)(66946007)(4326008)(83380400001)(66446008)(86362001)(5660300002)(76116006)(9686003)(8936002)(122000001)(33656002)(2906002)(38070700005)(8676002)(52536014)(6506007)(508600001)(53546011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WC23yuu1gj1u8knSYInGj6Aa4hNinmeSxayXA3idsxOZ1Wpjbx4Y72IyD9Nn?=
 =?us-ascii?Q?XHUtB82KIKTh686OvmJtq3lAcua6L1KufDV8QoVOzB3hUcT4+0vZ5CCFj4Ne?=
 =?us-ascii?Q?4sGtf1N1cT5xga6/K9d8ghzM25Qu0dGYrfpCsmBxVgiOwCS1tF9LXu5ENtdR?=
 =?us-ascii?Q?bwDB9y3yl4oPHDT1T4nEgybYPhp8GGwvKQ5z4+c2wr1I0jUsWrTcQQfeodzt?=
 =?us-ascii?Q?KiTwhL8/YcsLTelM88BFhfRAuK9TId1d2pLr5K0+Y3DZRLn9GohymQ5GFajJ?=
 =?us-ascii?Q?oNzKT0NUJu6NIz7eIYfyqWM4GSc7gHAj8zkZYdzbJ0iBQcTZ9tvgSnENZWD6?=
 =?us-ascii?Q?pSKupv/tllEIwoPvkWmppH0zClKzhG7UpP3+Bukb0XGIme7aA1WPSTpulUhg?=
 =?us-ascii?Q?Wyv3VEAJzM6B/Rg/iCg9qxUrTJ9AbAGK2gq2Sc/4Oewy7h2USPbCE4IONwzV?=
 =?us-ascii?Q?LoU9ntzKFKy4NAIj9FIHQ5mj3EevTZdHuqBVMxL80GlIMtZmx28lG0nwR2jk?=
 =?us-ascii?Q?bqeRISjj4mFCDcsJBZW4bzfnOlSBEp4wdUyxuCdA2kk4Tn3945V25RYtpTDf?=
 =?us-ascii?Q?pUF6eQAj8GwAJtSQene1bM/NmHzuYRKiX5hMEZpnF2OqaenAHNmWalyHAr87?=
 =?us-ascii?Q?a3jEPD8ScuALZ+k6wvgCX9ZWhNuecUo6uUD9vXNceRHcFe6eSbfJMldD95yF?=
 =?us-ascii?Q?E+oSYI1eHgtDDsRjEQReErrhRy33SnVSk/cPq3HzD/Ujt45A7lfs6pJBNuAH?=
 =?us-ascii?Q?HrKjy/DPxFP1VTaynQGAcDSFYacW6ngZPZb9VXKt1Tcd/OYAsfAGXcHGjbj2?=
 =?us-ascii?Q?h6rcG0Zz3T7Wpj8mxNVoFMhCUETcMupxRaCxUgZbJ0rabsczgb4EqV+rZNqH?=
 =?us-ascii?Q?cLn+GiETRqMwmlRShmcm958e8bF9GgN/2BJh+JuuG6eMCw0hU50gyLHJnWtU?=
 =?us-ascii?Q?IMwtDk8D6yq28t4dhej8p7P4YTlrUclWA0MdFP15RcbqJO2rnwllHt1Y85Da?=
 =?us-ascii?Q?VA1DlXUsNIKAJC9kX8lMfbemNoSYvzVP2fmzNUYhCxxprpP5nnY7l+9I1PRl?=
 =?us-ascii?Q?nSBa+dPCxKUPsODkZKt5hiV6CXA3yql/N+Jz/f809FDef5aju84oibq08GPF?=
 =?us-ascii?Q?vdiLwKKuCasthTKyERKggwPwZmZBGj+rwcg9Qk5ck5alagIKN/whM9tB+5JK?=
 =?us-ascii?Q?UHnYxXmQiYaWbezQfJpSX1uTlFnVFWsbj/SF5N0go0Q8TyyuNubvT2aZUkN+?=
 =?us-ascii?Q?aUN3VCbBvPOjshiyhWHCreW9GGMrNdvBFJHHfBDBmmgq6JjZTIZVA/JTTATQ?=
 =?us-ascii?Q?E36MFaOSRW9nQNI4pUj57zRoRDup5OT4c9TE3ag5zRm3KLe/fdUVSErjdDQ/?=
 =?us-ascii?Q?4LgJmRRUADBfEMXSLqA3KljTCMffhyKXpo1gfdWvpedO1ex9gBbI/YApyEt8?=
 =?us-ascii?Q?bgwxYwlNqxVMQlO/mxhr/4zTDm+s0dv/XpGO6rjwMPpSTDzvFQwoT8idaWYc?=
 =?us-ascii?Q?XozWDtVRabc27Dc1uOf5GffFAxeCgVtLQ937sASeP1L9y8rt1nKwMinJTxm6?=
 =?us-ascii?Q?VaMIHU1vDZEBqqJvd2NIeN2vPDNYB5JfG/PWzNy6ZgbOHJ+vuu4rjFTnMWTn?=
 =?us-ascii?Q?cA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499036b0-13a4-4be8-b432-08d9a7e3430b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 02:54:36.9908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbJUj7xHsaG3sWh/pcjrR0+l/RdnjpL/wenTy2dsIpXf/KHKme/YeoX+EW9EJAxQ3U1A/PBcMkUl9jGzYtADmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5885
X-Proofpoint-GUID: Yy6DzVernAwvrx0QYBT1ztNiknIQ4gvm
X-Proofpoint-ORIG-GUID: Yy6DzVernAwvrx0QYBT1ztNiknIQ4gvm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150014
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Is there any comments about this patch?

Thanks,
Limeng

> -----Original Message-----
> From: Li, Meng <Meng.Li@windriver.com>
> Sent: Monday, November 1, 2021 11:14 AM
> To: horia.geanta@nxp.com; pankaj.gupta@nxp.com;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Meng
> <Meng.Li@windriver.com>
> Subject: [PATCH v2] driver: crypto: caam: replace this_cpu_ptr with
> raw_cpu_ptr
>=20
> When enable the kernel debug config, there is below calltrace detected:
> BUG: using smp_processor_id() in preemptible [00000000] code:
> cryptomgr_test/339 caller is debug_smp_processor_id+0x20/0x30
> CPU: 9 PID: 339 Comm: cryptomgr_test Not tainted 5.10.63-yocto-standard
> #1 Hardware name: NXP Layerscape LX2160ARDB (DT) Call trace:
>  dump_backtrace+0x0/0x1a0
>  show_stack+0x24/0x30
>  dump_stack+0xf0/0x13c
>  check_preemption_disabled+0x100/0x110
>  debug_smp_processor_id+0x20/0x30
>  dpaa2_caam_enqueue+0x10c/0x25c
>  ......
>  cryptomgr_test+0x38/0x60
>  kthread+0x158/0x164
>  ret_from_fork+0x10/0x38
> According to the comment in commit ac5d15b4519f("crypto: caam/qi2
>  - use affine DPIOs "), because preemption is no longer disabled while tr=
ying
> to enqueue an FQID, it might be possible to run the enqueue on a differen=
t
> CPU(due to migration, when in process context), however this wouldn't be =
a
> functionality issue. But there will be above calltrace when enable kernel
> debug config. So, replace this_cpu_ptr with raw_cpu_ptr to avoid above ca=
ll
> trace.
>=20
> Fixes: ac5d15b4519f ("crypto: caam/qi2 - use affine DPIOs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> ---
> v2:
>=20
> Add comment to describe why the raw_cpu_ptr is safe.
>  drivers/crypto/caam/caamalg_qi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/caam/caamalg_qi2.c
> b/drivers/crypto/caam/caamalg_qi2.c
> index 8b8ed77d8715..6753f0e6e55d 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -5470,7 +5470,7 @@ int dpaa2_caam_enqueue(struct device *dev,
> struct caam_request *req)
>  	dpaa2_fd_set_len(&fd, dpaa2_fl_get_len(&req->fd_flt[1]));
>  	dpaa2_fd_set_flc(&fd, req->flc_dma);
>=20
> -	ppriv =3D this_cpu_ptr(priv->ppriv);
> +	ppriv =3D raw_cpu_ptr(priv->ppriv);
>  	for (i =3D 0; i < (priv->dpseci_attr.num_tx_queues << 1); i++) {
>  		err =3D dpaa2_io_service_enqueue_fq(ppriv->dpio, ppriv-
> >req_fqid,
>  						  &fd);
> --
> 2.17.1

