Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BD8C433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Oct 2022 20:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJIUAB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Oct 2022 16:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiJIUAA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2022 16:00:00 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC6817E2D
        for <linux-crypto@vger.kernel.org>; Sun,  9 Oct 2022 12:59:58 -0700 (PDT)
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 299J0Nih031247;
        Sun, 9 Oct 2022 19:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=xDBzX0Txeat/8C587rJVuK8uOSPLfkJDKCSWwHtNEl4=;
 b=ThccO966NFqJuJhVpziYmNUjCWNUm8sJohTv5GPVxckAzXZDJ/pI+Dsh53X/mo4z6wK5
 PqLg8qcUsTdpJa4nXHrIMBM4WlElyYITiwTVZT9xACzhYm3I/W0ddFc34mKBFTEx7uYK
 XutvuS9IENkfbKC92WXNhS4E97K8ICwUvAV6jSpJPvdmX6enulkGVGJNGmICHqESC6dN
 DYu/1HSPZdG9lHvWLC9vZ37iUtqIZgR2EXgNd3gLURZiRDRXjxicNTx1vQzHg0iVSeJQ
 n/DXJ145OKnsKdPgXDsaTwS3yGDcUkmG0Fc31+a2TB/v1bbmmouxBiz344s/WyupbsB0 kQ== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3k32gpywfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 19:59:08 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id DCAC9806B02;
        Sun,  9 Oct 2022 19:59:06 +0000 (UTC)
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Sun, 9 Oct 2022 07:58:59 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Sun, 9 Oct 2022 07:58:59 -1200
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Sun, 9 Oct 2022 07:58:59 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLlYOXTSFdaUcc3JZjOWy/DTlXGFMwtkinEOI0FEcpLy0fCA4L4elz6nFVvpMu2NRj4r+O3ZBJ6nSprZ6e1QZJe7Xsfv4AlVhhiDnjGI4d7w3MM2/eM5rM+Fvp5mqck5lhrm7pX86J1SuLdIAdJDzZl65xjreZBgDC9yj5Pmk7f/BAnbE6+B4fUyxO5/ZSWfHuPq86VB97k01hS/0GfFMLiVo3QgPsMOX1J0efozEQ5dA1ra4PGK/TBV8639S3td7PMi9vZiXSlUYDU82LDx2de+rYECvuN2rAdYU/KF6VymdyfDcgOg9SloJl2v5pPmsWIThljotVKpytPkQxNlxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDBzX0Txeat/8C587rJVuK8uOSPLfkJDKCSWwHtNEl4=;
 b=gIWHUx8W5UITySPAvbEOoB8gWkJMRLs+hRR1zGgDwzNZvLS5PXFJqid5kN39snBJGRXe55GrjjoWnN0ISCaXxKGx8mxPrzktfoQoDouxa56iCjKybtNKFq14kSaIiP1mAFL3WFg0VcWFO1hbnBmCYv1i4MJez7wS7FU08iL4M5S1HKpJbQeYggsJczz0NfOhNnxC2viEjPlXiDzx4GkN7H7mc9qFUDLbivLhXJigINCpQat4stRhG6f3GiWDOmBUUdPQNkS3DySp4Ky7YYpfxbQp95FebOIJGndy5lMnChBAEWPleC6bHs0XVqavYbmPsg/08Smu6Y3xIuSHC2LG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by MW4PR84MB1684.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Sun, 9 Oct
 2022 19:58:58 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5676.032; Sun, 9 Oct 2022
 19:58:58 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Ard Biesheuvel <ardb@kernel.org>, Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: RE: [PATCH] crypto: x86: Do not acquire fpu context for too long
Thread-Topic: [PATCH] crypto: x86: Do not acquire fpu context for too long
Thread-Index: AQHY16zBFmM7SwmJd0SQI42PUTup5q39qv2AgAATNYCAAJL7sIAFLlCAgAFSKxCAAM1MgIAA4Kgw
Date:   Sun, 9 Oct 2022 19:58:58 +0000
Message-ID: <MW5PR84MB1842FD77B90B1553367235CEAB219@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221004044912.24770-1-ap420073@gmail.com>
 <Yzu8Kd2botr3eegj@gondor.apana.org.au>
 <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
 <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <CAMj1kXGmKunh-OCvGFf8T6KJJXSHRYzacjSojBD3__u0o-3D1w@mail.gmail.com>
 <MW5PR84MB1842762F8B2ABC27A1A13614AB5E9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <Y0JoDWx0Q5BmO/wR@gondor.apana.org.au>
In-Reply-To: <Y0JoDWx0Q5BmO/wR@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|MW4PR84MB1684:EE_
x-ms-office365-filtering-correlation-id: a0976e09-f7a4-47be-748f-08daaa30b43a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n/v9eAO9rpQeISVfLun+RrROqSpmgONDBLYxMv66Iw6m4JNhYK9ZkM3UpTBhPYpOTtlUc4ZYEn9DKJO8pxxma8GFGOdphX78xYKtOVohCmnkE4mihk7SgqcCX9/Z7NsoNM4wemC+weysfr0oJV3nEbGqltOnOuOZbb7y8EJigA4p5I8gmPeaMurh1kaf08bQIdV1qfFGnMUg1LkRdtwsboZudAarfB5vvJgOl00z1TlWy2c4LATA1ttHaOsHiQY54gTHO4ytNO1SJLJZvxzIK4QFTKlRzb4t70JxSNHyHvZJdeDwBElDdGN07LwzbBVzqfcoQoCZKFPXvMVg86zbt9ryN2/iQ0RaxvoieUAHQCIytmHlbG/aI5flC5CygA7OExE69PrrXpqfITOniMTIUJV4uON3YT/AnRT9T2ti3alZfn67XNwPZ68vp/YcLnwRcVDbrFLiQ2dmphgUtQSLrPWxB+yaBqr/sCNhxeP+QR6/iSzy9qSp3gHvyrn3AwRrpL7JI3vBOJiPwNRze7BQONw3RBM4kXXz2fLhTqZ7tT35Uwp/ESEgeLbTfJ75X/Ijn6t0YUWkOEnm8ODQlGCtTnXJXaBWwc/ofmALLV9Lfd5KOQ70hDEmSaLzxbtluWDu2ud1vO8cj+ezJp45Vb0dNcUbEC/Vst8dw837ncMDYRiCBrAesGFt5VOgwLQoJ2rwq6LqrSbzoLzxAASo2oXwuuP3KTUis9fKMWaIWSHmxZBrBsBFga/YijVZfDK87tljkRqkRLdMZHDO8itDmiQzGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199015)(7416002)(52536014)(8936002)(5660300002)(2906002)(41300700001)(55016003)(478600001)(66556008)(66946007)(66446008)(64756008)(66476007)(53546011)(38070700005)(6506007)(26005)(33656002)(4326008)(38100700002)(7696005)(8676002)(82960400001)(9686003)(6916009)(316002)(186003)(76116006)(122000001)(83380400001)(54906003)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MoRnVpBVAGbf5gsGX06OEhOjwNX86cbQjQQeYRQflLbqJiGH+tIPU0l70PGs?=
 =?us-ascii?Q?kRPp6JHl/1VMmff3gZGGPVA0tnYLUBmRxKoXV1OnCX1MbWQdzSWJy/HVtdI9?=
 =?us-ascii?Q?XwI0qOWRCy6f3Zy/sGnT/FS2A1HD9gPCvn8nR25v0JwjSBRC8pp3fgFjd/Pa?=
 =?us-ascii?Q?VxZ8uVwb7QnjS/ofin8H3/egTRwFm0ILTs6ysEYWHI5oI3KK8HVyyKViTPGf?=
 =?us-ascii?Q?rGPVmBBYbj4/0ntrIRoCqJ0guFJp+GLdfmiTAjczQ0y7Ok+sK1Mcvj3vdJFf?=
 =?us-ascii?Q?A/trU6I3PC4sEWJhJgVngTt2EipqbP2sl2EfcRsJRN2CynSIjZ7pPDXZpM4E?=
 =?us-ascii?Q?3ipUBy9xERERXp/B4j5ZsQiGaU8aqevtrl/hJXwr20DJ5dSUyLO1efeVjRUW?=
 =?us-ascii?Q?xy16TdwbZbrmnrCBU3heRD0+EY5lvauMog/4IFOI8S/Gpg1REvXepVT7YeI5?=
 =?us-ascii?Q?LEZ2KunzGmbJyBUuodwyOweD6IbLWwLvFHe4V1sZmsX/f55t1jc1a97CNihJ?=
 =?us-ascii?Q?P9leEafljVDIkaMqdDq/q2MGDacP08grFcRCQAzLQBVJ8GJoeITrfIpVPVjD?=
 =?us-ascii?Q?/n8AIRocxwpHQm6Ju1zQtAW0WJE7stm6DqoqdPcFmCfePnMj4QBA/mA7yNZF?=
 =?us-ascii?Q?G2pu774EVFHhRLUx7f6Rps/qzIpdECnxNHfasHC8GSbgyyc9lgXojroISeDq?=
 =?us-ascii?Q?fj5X2QHpOCSPOv7dnfFVVFPkY7A/KZoOTBFe3yMivHwsxJ+6f882HNXGLXTc?=
 =?us-ascii?Q?WdfQ+LMTZdW6IfDFIvmGtVjW7jVmPVbHkYuEQKm/Q4A50CUe1oc8h8/7Z6pr?=
 =?us-ascii?Q?0xEfH0uszMMoCSmXUgiNqIJjKedOML8V5Qx9Pc4zTIAbfRiPF34YeMFOBlY9?=
 =?us-ascii?Q?UnQGNa3klBGOYtC3tpXAOxiSGGtEO6WiR+6VQh606ICUofvhP7Fy1VYow5Gx?=
 =?us-ascii?Q?jH1cUajM1MHDh6sK4IkV0e0KcHdMqjuO5u661P7wmxkTenC+dEyNNw955pmc?=
 =?us-ascii?Q?MVoiXjmb6R5wLGpZWFbdwDDjqRZuDI7Lf1hG2xwnbWDA8zT/NdptN9MdcDgC?=
 =?us-ascii?Q?/93YaGom3z7jfIZH7QrxxSB7jZfGgYkHAlnwCXGfYeuzgSy0nROsjox4LTS/?=
 =?us-ascii?Q?WoblB0iopGgXhweou4OL36dFO+YTKtuQylWW0q9KZYE9f6dloZJImLRnc4Rm?=
 =?us-ascii?Q?IIgTVDd0LxtdCcrJ2sciEBHvUYHQnk71a61aT9BIF/XQOtFlB//ODCgiTgXV?=
 =?us-ascii?Q?KgufqaBgNfoRD3HaL/Y5qMCjO1Of/cbAHzlsFiE3nEQjzUxbSdNDWQWLl5/r?=
 =?us-ascii?Q?vOxCfs6AgXdFDEZqeYrXk+rZVabQUYJcWCaw8rQu6XMrHrm+4y2oLKZ0MUAX?=
 =?us-ascii?Q?jVSZ5ahmlgWidvOSwgs4TODwSXacbExWD9P7arrHXGyr7Qg8Uj89kCoMy5ZN?=
 =?us-ascii?Q?zfMOZYExaAAEkoNy/Aonhxw+yz+iC65KLBwaAzUfR9LuYPFoCsEI6ytcBvLZ?=
 =?us-ascii?Q?vd8FyF72qKVg8/8jts3HwqNT/RejR8sLrg00nCNoSabcKkMWCWf2ThsGX3t1?=
 =?us-ascii?Q?R5AwTNko8xQz2BCFEvM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a0976e09-f7a4-47be-748f-08daaa30b43a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2022 19:58:58.4603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: phv5m1oXqZDoc2/Vqs9uk8bt+STOGXnqUJcnoJMK0oUG89+tISks0Eghyva/u6NC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB1684
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: R4eMZUB2GjoRVIHsTKktyqGZqFDkrhmx
X-Proofpoint-ORIG-GUID: R4eMZUB2GjoRVIHsTKktyqGZqFDkrhmx
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=916 malwarescore=0 adultscore=0
 clxscore=1015 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210090129
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, October 9, 2022 1:20 AM
> To: Elliott, Robert (Servers) <elliott@hpe.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>; Taehee Yoo <ap420073@gmail.com>; li=
nux-
> crypto@vger.kernel.org; davem@davemloft.net; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com; x86@kernel.o=
rg;
> hpa@zytor.com; ebiggers@google.com
> Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too long
>=20
> On Sat, Oct 08, 2022 at 07:48:07PM +0000, Elliott, Robert (Servers) wrote=
:
> >
> > Perhaps the cycles mode needs to call cond_resched() too?
>=20
> Yes, just make the cond_resched unconditional.  Having a few too many
> rescheds shouldn't be an issue.

This looks promising. I was able to trigger a lot of rcu stalls by setting:
  echo 2 > /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
  echo 200 > /sys/module/rcupdate/parameters/rcu_exp_cpu_stall_timeout

and running these concurrently:
  watch -n 0 modprobe tcrypt=3D200
  watch -n 0 module tcrypt=3D0 through 999

After changing tcrypt to call cond_resched in both cases, I don't see any
more rcu stalls.

I am getting miscompares from the extended self-test for crc32 and
crct10dif, and will investigate those further.

BTW, the way tcrypt always refuses to load leads to an ever-growing list in
the Call Traces:

kernel: Unloaded tainted modules: tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()=
:1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt=
():1 tcrypt():1 t
crypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1=
 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()=
:1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():=
1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1
 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()=
:1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt=
():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():
1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcryp=
t():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()
:1 tcrypt():1 tcrypt():1 tcrypt():1



