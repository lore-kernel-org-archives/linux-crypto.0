Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7ABC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Feb 2022 11:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbiBRLCf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 06:02:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiBRLC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 06:02:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A243243120
        for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2022 03:01:59 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IArLRG025648;
        Fri, 18 Feb 2022 03:01:46 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e9kktwjje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 03:01:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5GliwoUcpEdZ8JPjtTsgp2enFJ5FU0fL697ZV/mQjN3/1VUSWH5ZqehxgVwWPsa/RsfoPnXvcCBQdYQwKaUqRui77VTbAgAh5nZOkTd6cF70aik0OOb7Suaa+uFYHvNyA/r7ll4IYVv8fsuaxFhjplF/SBrYkTKC0Wuq12Bg/94wt+6mqLMogyd3aiPs6FT5H+dyWfJZWr23H908qrGDK9qr9sRa2vGqrZztN3rJ3XwO0EYpO7VYSRZrrgKAWXUIB9PKOfJseHuqd0XH4FzIrCw4eg3LxMcQm3WVOFV342QePzuADVjNEn2ouYKrDPsBFJfUDShZ2jZTvIXt2hErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTj/XpohBbCEuaPfWmnp79ZWHrgph/1hdQuXgjFVJxc=;
 b=eG/Zl4pYhnlR7dSH+kZAPw5hvajRb2ZsV7RwPK4Ya6YRCYSLtwOgIERKbaHo7DBeaoGlpvrf8hCvbyNk6sW04OHQqRLybcYrPyJ1zTmJc0xAqnGoAl9gfdaOgAiMLykbLEmjHmmbpIOUOCbSqVov6pYGmJFwV3ERWLJRz7hMKvwFvWCS3J/JUXExfC/4o5N3JoQgeK3s/FgUn5Bl6AsAp/9Yk4ybz1EbyIw2MCCSYozyILF6yodYgxMAbfMKYondFsTVS6oRL42rJVqUvajvuj8lGSV8W8AqTTN1xFMI7Crc/KhW5ktlNk6s9+3BELs1HQSq87f8a7BIdnZMVhGvJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTj/XpohBbCEuaPfWmnp79ZWHrgph/1hdQuXgjFVJxc=;
 b=LBUUnTZysL6iF2efJ91qmPBMQn20N5NKgX7KIwxmIVn4OxWisq+sdG9fVwb4SSKPBkQTR/fqPNMMvjzTouB2aXpSQAlC5EGVfOthp+yhwDeeVB1kHu+UovnF4B8zhSZDONa1FYrMcMHvRYMkEQPfopiGkie+RgKBfKPo+K7SGec=
Received: from BN9PR18MB4204.namprd18.prod.outlook.com (2603:10b6:408:119::18)
 by MW3PR18MB3594.namprd18.prod.outlook.com (2603:10b6:303:5f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Fri, 18 Feb
 2022 11:01:43 +0000
Received: from BN9PR18MB4204.namprd18.prod.outlook.com
 ([fe80::6d2a:bb34:c87c:3516]) by BN9PR18MB4204.namprd18.prod.outlook.com
 ([fe80::6d2a:bb34:c87c:3516%5]) with mapi id 15.20.4995.017; Fri, 18 Feb 2022
 11:01:43 +0000
From:   Harman Kalra <hkalra@marvell.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Arnaud Ebalard <arno@natisbad.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [EXT] Re: [PATCH] crypto: octeontx2 - add synchronization between
 mailbox accesses
Thread-Topic: [EXT] Re: [PATCH] crypto: octeontx2 - add synchronization
 between mailbox accesses
Thread-Index: AQHYGcU0g5aCzPrOA0q6AvS+X1eACqyOHTgAgAsVj2A=
Date:   Fri, 18 Feb 2022 11:01:43 +0000
Message-ID: <BN9PR18MB4204CD02272F9961E7C534F1C5379@BN9PR18MB4204.namprd18.prod.outlook.com>
References: <20220204124601.3617217-1-hkalra@marvell.com>
 <YgYp+mHwwEiLHhCk@gondor.apana.org.au>
In-Reply-To: <YgYp+mHwwEiLHhCk@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 900d7911-b1d1-4c3e-2a57-08d9f2ce0c50
x-ms-traffictypediagnostic: MW3PR18MB3594:EE_
x-microsoft-antispam-prvs: <MW3PR18MB35946F89D95A2390444CB4EFC5379@MW3PR18MB3594.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FzWt6MDUl1+V3p3DwAlp2GimUHLQEo62lXW3RYh3XrfQv/TIGoyLZDmObHq/NXyuZzrdXdNno3jMpaa4V6u1t2yWklRIqVeZ53jLhW3/lQMv8hALPXWRoqKQl45Ob5HWvTb4NYVvwAlaWgJ6pI11uYaxgmb0qLn1cDJ5PAzmaetFY+Zk3ghbBWdoH8/w2YpLf8ehsEHcsok+LE3UrxTdYHkTIcI5LJCxNBMGI7kwNFw2oAR+ZCxMhwjTqTNBBQ3ShXkUROCSDyYWIkIXYXSxnKoM1zTXqIJmCgSassPs4hQRbDP0MUKuL/07iGR7EIfuPzYflZLthWjf4eYUZaDcZDzlzvE0bkoBmMa3nH6Uu2wDET16BTRkNi6byfbfdYaJL9eznS/O4ycEyrAd9PjybVhuJtx/39n7sVChh9+xDMkdxDxjLPu1v2a+NQLNqrCrBOzbVzOul9P7c8UqVASgi1BcjBf9OEAekOUAdGkVIWIa8y1uqlNxg0DutKaI3OxVCplmhNpSAmEKYa8I5TIHdXwNZuKbl21w9VDsR0OGuzGaLwBvVGwDMAcHB9zbwxRTu64an5QQsfiSiskl/ri5AsWQ+S7Qr5PcRoLMWlbESF1++bMuqIAn6Q0RsC1XcUI7truHJFiE2NkDnU80evjzpkTEqJZOpSf20MdxL5y7gAoPK7pWVBSuHpCeHiPNYLm5EyadA0fp5NOXhWxZsI6/DAkeLWwtCBah03uvRXLW/hGF4K2D/AQos/wOTmev4fIUIMcrqT4bdrAK6QFZ4Q3VpQuIhlklZRxCRUmynLS6hMEMoLhqku+OlMCXnxbY7pJAZO8dqWXlKnU9HudPgglZmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR18MB4204.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(15650500001)(52536014)(55236004)(53546011)(5660300002)(2906002)(66556008)(66476007)(66446008)(7696005)(6506007)(64756008)(66946007)(107886003)(8936002)(4326008)(33656002)(86362001)(76116006)(55016003)(26005)(9686003)(316002)(38070700005)(966005)(19627235002)(122000001)(38100700002)(508600001)(71200400001)(83380400001)(186003)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J1YVSBCVwSWFYPor101RybpcXlsIT5uGE+Sag/Japxy29vPdWsNOz+kNyTig?=
 =?us-ascii?Q?1nP4oiBB1USaq+uK3BISkjOD37Rp0vQelOK+jnA06xe1MM3jao1HrlwwegCJ?=
 =?us-ascii?Q?FwBSpnLFmQuTtRLz+6kZylKnIzcIrS49Pq/0Vt6k169gcUJfp/c/+H0sI0Vk?=
 =?us-ascii?Q?5kAqW197hq+sXZE/T5B9wjxvMIaPLiNJ/JYi5nP+Athr/Gc2qN+bmjQI8eFn?=
 =?us-ascii?Q?+eIeHNUyQ/qMF0k65LuVtlU2BjrmkthCOxg8HYwMamQs+pOJSY+/p5XKrOj5?=
 =?us-ascii?Q?i7k7t8Ci53qqSLskryr0czbnemK8sffC6qfX/xOYIsxWVI5nBdR+DZaai3px?=
 =?us-ascii?Q?7tPrBJ/hZ981y9SHfAUe+7QTZLC7AuYgvQKYDsLa16VeZ9dNkYNYMbLzg/Bq?=
 =?us-ascii?Q?6ybs/mTbk219xcjyr9ptIushQs2yV0MYm3ffiG0Kxfj0d6YocW7LGWFDYaqT?=
 =?us-ascii?Q?+j/lOEzaoAGUf33VtbY+GBpfecTXknv+ZCyQEIJnXx1McykiCHJMJ0byfcR2?=
 =?us-ascii?Q?aI5uJzKi/voe1dsZiWEJXerpxNiGbWFTMc8XSdiJWkpREuiQU59dEjaEBEyt?=
 =?us-ascii?Q?w+U5xnkIFz+8QuzxKk6hSdOP8fNI5KDMBfG+FNcDDB4Ys0h6DlwX/QF+jiJM?=
 =?us-ascii?Q?Bhg+GriDUUGWYgc8xb90IkV4iQAzjcB5nd93tbbCwTDHxS+MiL+of7bXKoKU?=
 =?us-ascii?Q?3ABF9bug2SOthncjko67v+wJQvRm6/QzT3L7m/yJK6b+l6ANZGNAL6e5cOIk?=
 =?us-ascii?Q?yBRXivfFJbJmNe///UTMg2HKQj+nh6dV9vlfs0b2K2u/GBdlYpEZO7Y41MEM?=
 =?us-ascii?Q?16QgaF9SQRYvr7yvhPGdJqDsdRKggxp2TUWuvNZ5lThJ7bL4ewjga10hhnxU?=
 =?us-ascii?Q?XLFY8Tpj/ok2tJc2rAiWRIj8omsEdgEbxVyO6Y4VTHD+6Ckdh1t+FCWaUEcW?=
 =?us-ascii?Q?gFpvScqnCLT4dvNRpLWy/TqcvaFROOr0C95sEKNPFcqI2/Rg72wdxOD+SAzm?=
 =?us-ascii?Q?aiTO6iFXry9KjLTsoOPGHzx5pCHsmaqexVd0f4H3MdW6jecXVzHphIqkyETB?=
 =?us-ascii?Q?UWK8uPN8ZhnlOKptpsDW65WHirEJvP19hdD4kqZhhOjshNEdl5wlRCsY0VBp?=
 =?us-ascii?Q?6JKLUDCeTgZFi5Xa6ebdWsfYQPE6aVrwjAIqt5QF4IronRNwX0QM1iYE0dDJ?=
 =?us-ascii?Q?ffweehl71d2aTuplPEkBpobcsmmdQnFXKP7xGy7MQ1Pci+bxJ4hi/F3+4sS+?=
 =?us-ascii?Q?SojoL8rjk02jOyczQabNGPOAsh4juYC0vjEUndFmUG/yZ1Tlp0JoX5OQfl5Z?=
 =?us-ascii?Q?6IyyLtTB2AAmS2j/cgY99jAzMBUBnliRB+zkpRUMFh4zsdQxP3/C7AxwvUyq?=
 =?us-ascii?Q?fy2vUyYWlcBvXiDCQe7UsU+d6bfHTXRgeS6MqO5J0U2ZEza/+vDUt3iXp3zC?=
 =?us-ascii?Q?iN9ousFPIry5auI7q+aw2CY3kfCNFRUorU5l7N+q/4FTEy4B1R4LdctdC0Fh?=
 =?us-ascii?Q?7meMqU/fyJd/hmgJ1fKKYAND/VduLRn8p4ArJpRs3iBs90dTngxUwLH8mxwJ?=
 =?us-ascii?Q?Jwkq+UNM6uJ/VZDWGaq6bPM92iP56OFniHjGv+Z/VXR93yc9Jex0ozeQk08l?=
 =?us-ascii?Q?QE/XYLCHxmg8ZZDx2qqpeGs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR18MB4204.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900d7911-b1d1-4c3e-2a57-08d9f2ce0c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 11:01:43.2463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LzMDJKqvhJwqjx6NwY6uW6rLHC0QnSgB/YyoYGXRaQ2xTb9WtX+3W2jS6uE0ryQvAlI/GN/S8WxAfo57yuP6Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3594
X-Proofpoint-ORIG-GUID: NVmj9VWK1L-DBN9l9Fku2_b2_SqOgGfr
X-Proofpoint-GUID: NVmj9VWK1L-DBN9l9Fku2_b2_SqOgGfr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_04,2022-02-18_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert

Please see inline.

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, February 11, 2022 2:49 PM
> To: Harman Kalra <hkalra@marvell.com>
> Cc: Arnaud Ebalard <arno@natisbad.org>; Boris Brezillon
> <bbrezillon@kernel.org>; Srujana Challa <schalla@marvell.com>; linux-
> crypto@vger.kernel.org; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Subject: [EXT] Re: [PATCH] crypto: octeontx2 - add synchronization betwee=
n
> mailbox accesses
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Fri, Feb 04, 2022 at 06:16:01PM +0530, Harman Kalra wrote:
> >
> >  		offset =3D msg->next_msgoff;
> > +		/* Write barrier required for VF responses which are handled
> by
> > +		 * PF driver and not forwarded to AF.
> > +		 */
> > +		smp_wmb();
>=20
> Who is the reader in this case? Is it also part of the kernel?

This shared region is accessed by VF driver which is a DPDK driver.

> Because if a device is involved then smp_wmb is not appropriate.

This is the same driver which is handling multiple platforms. In older plat=
forms this
region was normal DRAM region and was mapped in DPDK driver but in recent
platforms it is device memory.

Thanks
Harman



>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D5ESHPj7V-
> 7JdkxT_Z_SU6RrS37ys4UXudBQ_rrS5LRo&m=3Dho3Yrv-lqiH2g1-
> aPC__mENJQ5Sl-8ZiYhq1B9w7q4JIznCaE51-
> HsGGwyoybXo1&s=3Dl3Jk2Ay8mVeXEZN8mEYcUduOUgAnBZkLP2bpGEKtwL4&
> e=3D
> PGP Key: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_pubkey.txt&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D5ESHPj
> 7V-7JdkxT_Z_SU6RrS37ys4UXudBQ_rrS5LRo&m=3Dho3Yrv-lqiH2g1-
> aPC__mENJQ5Sl-8ZiYhq1B9w7q4JIznCaE51-HsGGwyoybXo1&s=3D-
> jOywGz3R15pI-vdtiom908wdVHFZVmBn7ktoqtVkYE&e=3D
