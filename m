Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568E6C4332D
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 10:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE9220739
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 10:47:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Tg0Zasie";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="RldMp4au"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgCTKrl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 06:47:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726955AbgCTKrl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 06:47:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KAjI30005967;
        Fri, 20 Mar 2020 03:47:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=nMpRES4s50dvP6/jgAHTQielGcQhDzOiEOfiMXLTR4A=;
 b=Tg0ZasieB4z5LggaF6rQmSi+nOPIZnE7ISZAeoKzm/79lJcHYqj1DVd6TSXtGVbAi/sx
 1zOxKvaqIbNNrPGJQiPQ8ngji9xATH+1Z9EPO3ZtDq2bLL0S+Qk2QvcALXt2Z3iaany6
 U46or1XUltz13TisNih9w43xZ0fa/pqFNRM17Kiu72ywAI5ZTcw6RyreONKK5wcHqS8L
 e9+bZsM1vvbiTctlseTksBrqbgMW7wmiedk2AcDX+isqjhrwG2Mjx+zhDk/O6ihxKuj/
 C2VS0ZOH6u8B5Ye5qtgrQ2CSapIpvjLVkjrUNhcsggPxtVa84/vn8cQTALuUloJ9IED/ 3w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yu8pqvvcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 20 Mar 2020 03:47:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Mar
 2020 03:47:27 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Mar
 2020 03:47:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 20 Mar 2020 03:47:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBRKmbLK3mq4A4+lWcejdxbuUrElolIQGmidRz04Y6pe7VKCQAQYUWzUTYdxh6d1+trKi25h2oeqUTMMxrSYIGLdsmRhltaYRqzlgyZttmZkIUrpILu08GvuLaFfEounQkohZ3D/Wbx2Sw2DTPjklXWgHbQAOB21BBZFRLfAvQ7kj07bL1mgCW17blxtVCZVGs/bfaTAjsxTsdn6yXyuKY5mnUvglart1cXwNCzXzHYFK0+cw3leCGidcPwtFZ2rD1fgtES4ccuE5q+k7lWAvXQWcNm58EB21iMBrH3qLFsAmpc4w1EyfJJa2ar8LFfXqaG+DnURXAZmigc2+Hv9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMpRES4s50dvP6/jgAHTQielGcQhDzOiEOfiMXLTR4A=;
 b=Strn5pbodLGwPMHo3xucoEvzUzcsN+ruYpX8kUe2iT7O7nDndjPFrJDlsslIW397xtePDLV92Pj07oIs+QAA9iKlGUeHBHNJaUfN4w7B3sWefVj0CoFsAL6fxjOHLpzYxAlZQC53ynjLHcUCQC4EGgwurjOd2W33pHOpIZr7UO+FAyglLlKIgSYav16Q0+aPVmt7c7sua6BLI/sbq02uSdIozgDIFstWvRj5tsh8HyACV5Pl1T1QQyZefz8mcdsCN6fhqLvzjC+/TM5WHilllN4gSTvAIGew/exRbVjS1+sYPBuTHBZd/uZFQ9Vg41TxEoGXYwolEEdtRegcke7KxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMpRES4s50dvP6/jgAHTQielGcQhDzOiEOfiMXLTR4A=;
 b=RldMp4auPdlv++sKyhGbXrlwt0Id+xc7+Sj7uuxaVmT9Gz4OzZoubh74PjBPGV1ENptIRshRNM9VsNurQIK2A31zCX/b2ktZQ3XZKPjPiZDZ92tguF7MbrCADZlmIqBx9tdof9v0cEzCMKiVpepXpL3qHLCT9Nw9Sz1U/sONfhE=
Received: from DM5PR18MB2311.namprd18.prod.outlook.com (2603:10b6:4:b8::27) by
 DM5PR18MB1482.namprd18.prod.outlook.com (2603:10b6:3:bc::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Fri, 20 Mar 2020 10:47:25 +0000
Received: from DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd]) by DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd%4]) with mapi id 15.20.2814.025; Fri, 20 Mar 2020
 10:47:25 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
 Cryptographic
Thread-Topic: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
 Cryptographic
Thread-Index: AQHV+S05rH1l6PXlHEqfmA0xItJTK6hQ/1qAgABWxrA=
Date:   Fri, 20 Mar 2020 10:47:25 +0000
Message-ID: <DM5PR18MB231111CEBDCDF734FA8C670BA0F50@DM5PR18MB2311.namprd18.prod.outlook.com>
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
 <20200320053149.GC1315@sol.localdomain>
In-Reply-To: <20200320053149.GC1315@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.213.202.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d65fe8d-a1eb-40f9-3a6c-08d7ccbc13bf
x-ms-traffictypediagnostic: DM5PR18MB1482:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB14825AD5FBFCF0B7C09F8279A0F50@DM5PR18MB1482.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(7696005)(55016002)(86362001)(33656002)(498600001)(66556008)(66446008)(64756008)(5660300002)(6916009)(186003)(9686003)(66476007)(2906002)(6506007)(52536014)(54906003)(8936002)(26005)(4744005)(8676002)(4326008)(76116006)(81166006)(66946007)(71200400001)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1482;H:DM5PR18MB2311.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PE7lN9L8LshVrfZ0CJDw5N67lL1djziXrsiDtuM2WLbdoovezpddGYXIuocUVEzcen1uGYeKixxyDiejVwgTHJbnMF8u4vkPzsEmcJu/pttJx/68wLW8IRbxJzhdgh80iT54ZeSPvDOoO6NY2UconYZKJ+2tMSfKpO7e8T5tXceMM2h4tJWPpH4AoS+QRsgipSd6iwk08ijSPQY8zuUKn02aOviE0b8XKtITh0f39OpfpoJqjI+FC0p9h9DKhrqZN6x93fbX+z+G9cwgSDDLCC8X54SMKDXEl7tOilEUE12KfEfPBeGRdV8GSCAaOTTVebIqH/26k9azF9WNz3k705BjXiekdHIR63fe+13VDxGl91BIVZhwrBqZagYh0YF1yuwcdPRFq/irOVmtuMSHGQuyYbJF4pvEEr3fG7LJu3me1WO1/aiw4X3hxO2TPD21
x-ms-exchange-antispam-messagedata: KcKS8s67nTAKfkV3UlxR01MoHt4InakDYroRmPVdSeEOIRgYqevQkg4vt0MK9J9tF5YT37H2UtFerWTsOKSBexy1wZ8HwGnZKC1kI337hP8wHhLzuAJZmx7xQqyumUjaWSTgT7EinMxTeJr/rijsRA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d65fe8d-a1eb-40f9-3a6c-08d7ccbc13bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2020 10:47:25.0923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z7v86AgYkP5zvC1T4VFVJN5Q6Mkn5uLoc6u2KolUiRUZdMRQeWpZdqtNTnpfAFP8ri/a9fEJpdnQGgtkn7P8/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1482
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_02:2020-03-20,2020-03-20 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> On Fri, Mar 13, 2020 at 05:17:04PM +0530, Srujana Challa wrote:
> > The following series adds support for Marvell Cryptographic Accelerario=
n
> > Unit (CPT) on OcteonTX CN83XX SoC.
> >
> > Changes since v1:
> > * Replaced CRYPTO_BLKCIPHER with CRYPTO_SKCIPHER in Kconfig.
> >
> > Srujana Challa (4):
> >   drivers: crypto: create common Kconfig and Makefile for Marvell
> >   drivers: crypto: add support for OCTEON TX CPT engine
> >   drivers: crypto: add the Virtual Function driver for CPT
> >   crypto: marvell: enable OcteonTX cpt options for build
>=20
> There's no mention of testing.  Did you try
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy?
>=20
Yes, the crypto self-tests are passed.
> - Eric
