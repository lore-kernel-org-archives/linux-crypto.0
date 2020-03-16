Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DE2C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 17:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 787DC20409
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 17:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VJHpRtjz";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="eQRpnd4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgCPRTH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 13:19:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731507AbgCPRTG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 13:19:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GGoWnk030382;
        Mon, 16 Mar 2020 10:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=OpKyZvx2M8jJPpOgPGzw8tjlb4exocLCYQV1Gqz9YH4=;
 b=VJHpRtjzl1GaH3DqNgYJeUprABkMRTMsms4G4BkhlcTd17FVn2FNNvxJnQ3lOJ4SBJXv
 4jukz8zqvDU6Y+ksCvyVhMR//7GN/ME1rj0bQnGjbVemKeo5M91fSKq1Ir+wXnPI9GVJ
 NCy3SPCsALiInDfaHQu98QEAIHgXTDgWWlFeTomGG8IWWaavXc2bxTJMUmQJ42EliWLG
 rspzfjhPywx5JEsY7bnssryDBMqXmZlBrSFTGTNrp656Duk2KWkwEu4XZxnIH/Uvn0GV
 ZW6PD+v81MxtL64mH+wU+V0/x9ktqmXcOA3QsYdtDNc+qncWts5CKbYeSidDk9FSIeyv NA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yrxsmfpqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 10:18:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Mar
 2020 10:18:56 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Mar
 2020 10:18:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 16 Mar 2020 10:18:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEAPXAEy/jWoCFfbgMlaPj44EavqM6GM5189yNjWEdAb/lj5E3Ln1P6yJnPTJUCr+fmmjDIcISnoIZCU1UWmMqz9ZeJ5AeeAMHca+uXRa2MY4huKn91UTHxTZ6WgUy6Zkv6/6yAyDflrWfSkJSOn51Cp6yp2e3ZvGMb45xzd5PdtJSLTgOMRKZaTnxlOc4/vAaupGzyYqPvHY04FdM99n6pl87P9SMWf2XDURSNHTkXGtSf77GZ11qojFm6H+xWxHoZPT92BxPOg52M6k+P75/cq5339Y6eHRJaMhIclj8GwwYkuR5Ll08WMRy69eCi85CVbjZbeaKhyAf+vF20O7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpKyZvx2M8jJPpOgPGzw8tjlb4exocLCYQV1Gqz9YH4=;
 b=kJ/Z5aw86gVa0o2aD7X9XGz5kI3Vy5fOI/l2hD4bXNxeBJ12Q3QyagAZ9gdx3yHpYoFERPpfpoPZ/gs2nNCN9dHtd1aqvNrgICCAV/zNyb+7b0oNG69zancGrC9u9m44R+I9rYwIvONkKIh6+NXMqjXnzeDYv7WlRw02T/4OiJRFaGPtKeAnYH7s9R+TPIl/HeHkyg1PksSy3mcqWgSYxlTocJh1LGrq6iSKP5CKsUToc30iXaWL0l3zs0RoLi68WH47PKB300bKMLTK5rG8Q2wuTWz4Gvtxj7F29VHcdbNkZYI9JAH67vNzkuEkju3qN5ByXmprwYUgOzfpN5xITA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpKyZvx2M8jJPpOgPGzw8tjlb4exocLCYQV1Gqz9YH4=;
 b=eQRpnd4hvrGWgXeKlIFMYiszhc6QhJ/qdNNbgBIYKDlkN1MvKxcCfT3JuJkX7gUNd5pRRiS2qmEkcjTV7wJXbyDg0EmVt2i0h657cIrkuqE5RfIFTF1RDTJ9xbsbxmWApxlHBaOulUqozwTqDlcifXFybHVRKHPW8NKXSrBP1ck=
Received: from DM5PR18MB2311.namprd18.prod.outlook.com (2603:10b6:4:b8::27) by
 DM5PR18MB1289.namprd18.prod.outlook.com (2603:10b6:3:bf::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Mon, 16 Mar 2020 17:18:53 +0000
Received: from DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd]) by DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd%4]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 17:18:53 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>
Subject: RE: [PATCH 0/4] Add Support for Marvell OcteonTX Cryptographic
Thread-Topic: [PATCH 0/4] Add Support for Marvell OcteonTX Cryptographic
Thread-Index: AQHV8iAAsM3DyeQzg0uALun/Ik6ELahE4uwAgAalBXA=
Date:   Mon, 16 Mar 2020 17:18:53 +0000
Message-ID: <DM5PR18MB23112454E88F6C411B3543E2A0F90@DM5PR18MB2311.namprd18.prod.outlook.com>
References: <1583324716-23633-1-git-send-email-schalla@marvell.com>
 <20200312114428.GB21315@gondor.apana.org.au>
In-Reply-To: <20200312114428.GB21315@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.70.131.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb64a8e9-5573-4223-bfa0-08d7c9ce1a19
x-ms-traffictypediagnostic: DM5PR18MB1289:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB128941F77645302BDF787CB1A0F90@DM5PR18MB1289.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39850400004)(346002)(136003)(366004)(199004)(19627235002)(66446008)(9686003)(64756008)(66556008)(66476007)(66946007)(55016002)(71200400001)(26005)(186003)(4744005)(316002)(6916009)(52536014)(33656002)(54906003)(2906002)(966005)(5660300002)(76116006)(478600001)(8936002)(81156014)(107886003)(86362001)(7696005)(81166006)(6506007)(4326008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1289;H:DM5PR18MB2311.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L92wYkKPGgo4+Xkf/ZPAFEV6+O+teJZNCC5diC5ZEu/7kl5FJE8ik8tU/rnn4i803qRIBH0ycrxeaGUGxs5kK0sidNbkjRVXnjevb3mzpIqpnlo9v33AD42UfjkyhK7Y52oCZ26ilzOAZAi/Ibb4UPZSeaEUoCkT4mg4Ej9BSEqxvpSVUmX1jZ0spKHY5XbjXKaG9LNHwi+xmBdhZBckbZGbBxi/FH68iYg+XGxgXFCu1mtzWz3XNvwT3Hr1YjREIcEaog41a7MDx9HsEZt4SwjB5OqqIKo2yFZbH3ItyPUawejeoLGESXjSWsFwRcy4X7kPj8eiuec9aFUlPumX39hF00c3MLOhDYHaOxAYx1KWx53+HbytA3YrP7Sm3QTiHSR8fVhA9ReStLkVvo8Ha9L00E1++zAwJ4o2WJKjP3DMmnCycbLqU5gqlCKNuO15I8lN0aalceSRiIOtbNrb3ri1KloZ0/8tsQQchQ/IT4DU7dExojeMdak/Wscz2v6FlLT4vjvXmuJsBxWFsggG+w==
x-ms-exchange-antispam-messagedata: XGA0nTTKCi3hJycAChvW3j288oiwFnUmPBrj/pP0gsSziQUfUWhhGTZHJcz8NWoNRLKPJLMYKKk1+gs7mkFcw2TnFn7X1VC6zGLgRkgg6XeTLMnXjcVI3MJXdfD07kjG1mQd1sjwuaDFLi5jKRLFRw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb64a8e9-5573-4223-bfa0-08d7c9ce1a19
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 17:18:53.3406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guKoRd6tB5U1wBSChGu04jxuyd57DOvakZgGOPVg9tCRY3kNb116XD/cbW/JCenPszZtUnapOxCR4puwX1M+sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1289
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_07:2020-03-12,2020-03-16 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>  On Wed, Mar 04, 2020 at 05:55:12PM +0530, Srujana Challa wrote:
> > The following series adds support for Marvell Cryptographic Accelerario=
n
> > Unit (CPT) on OcteonTX CN83XX SoC.
>=20
> Does this driver pass all the crypto self-tests, including the
> fuzz tests?
>=20
Yes, the crypto self-tests are passed and the patch series was tested with =
kernel-ipsec.=20

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcKFpANhTW
> dwQzjT1Jpf7veC5263T47JVpnc&m=3D9_yjiltEDSyBDoQbemHg3p7n3NVeM8e7tzRh
> m0eO6F8&s=3DWfuMj4mtbzrUE1baI5puOt3hLjWNelbO5UjMeAoSWJ8&e=3D
> PGP Key: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_pubkey.txt&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcK
> FpANhTWdwQzjT1Jpf7veC5263T47JVpnc&m=3D9_yjiltEDSyBDoQbemHg3p7n3NVe
> M8e7tzRhm0eO6F8&s=3D5ONhtHM3k3-
> EGaVEi7lNjyYHY7xDWJXCW9uwJ0mpWqU&e=3D
