Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B565C4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 06:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC9D9208C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 06:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dKfpp3HQ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="OxVaNqVW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437490AbfITGfd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 02:35:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51022 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389232AbfITGfc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 02:35:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K6ZNiP007318;
        Thu, 19 Sep 2019 23:35:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=rngoyzlBH6vGkSpJkkBhNPybkkyQx4aKB0mxu7s9HiM=;
 b=dKfpp3HQ/SagFCVlCkEHFUCX0ailmIJDDmVk1lWHASGxXy+b+Ec2OVhLWtMgs3YzSVEj
 M4FNJNgRty0CbHJxbGP3LX12wRZfCFrnMq1MYFMca7IA4fYn0HSAl14l/wLrEgTUOzMT
 4IS6jYD8+cICjYwQgLEiDY4GAlV5bcn0b6L5I2uvMmzyDTqWcKuLQ6Se+gjDN794Ej/Q
 3c3VNwAFP8/I++FOCsHoTt7XJPuuZ6MEE5PQ9cBGh5FOWa2Je+Z9uj+P2ZgkyrpR8Ksh
 lkhRf1eiMDTAGqqnR79fTQM2r+aAsLg0aS88dWHoT2mLvqUzM3FhyeBq4Cj+8UDUduem xQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v3vcfpxdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Sep 2019 23:35:23 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 19 Sep
 2019 23:35:20 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 19 Sep 2019 23:35:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3uDg/VuzdLpABsqupSXtgYNL3iY3pL66Fivb98O6uWOfQDX+eepehhETc4mgMIHO2eLJvUXjxLDxBOn9r2unr7+s6wEIYJv+mmBO412Ui4t/8hxQAwiRaT1BxVoGu0DHmjesJGxYKMAxsXnHFRO6WXr0iVuzgMVWsOszXWqCmFKNFAzgj54eGQM4JEx0vp5JuZ3S5Uz+Pf7a5si0RN7x3+d2TNc+O0XNA44OREBR9+XArGTvsTiV8HnVwbdou7J/hw0oulqQv0sfxJ3imziqumsNHD3AiOKLmH3nqCLLvCuXq8KOTZAilVJg0WoaiGIVpXR+bAg2cwTCu15W1FxIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rngoyzlBH6vGkSpJkkBhNPybkkyQx4aKB0mxu7s9HiM=;
 b=HL/Ed47Md+v6aFm7Z5RPt1HVOtcxNK/0rwWioFnbBfEyctP8t+Fg9tezWKLU2SsbydMbvoBNaDptj+Oe6QuyZKqq6Te8pJdZI8h0smAutmfhpHA+o7qWZYCmAY53R2q/oIVvQ3yc3BPtJQHLTKYp34KEn2Xl1Ime2uRFAJiKu3xDhdxkQWDb/Eo5ogxzxR7zEPD/q5KG0aSvGgp56eU66khoHiqt6+hqATTy7rWPGX7TE5LQdP3Ys4/MDVIP2YKJXggSfvE+JaoYB5wVxX2WZWeMpoMRj3zCo/qhJ43dfdWvIREr5WcUQMYzdWWIbvN681C60zA/x3SLG/epzgan9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rngoyzlBH6vGkSpJkkBhNPybkkyQx4aKB0mxu7s9HiM=;
 b=OxVaNqVWAB8hv0Fzhq8oQ5OhmzKtFPqBkC5gFvWFgvgtB3Ha7GvhBQHew0BGHZTvLNfNz243L9VfGJDIBEbWL6GzcXt/rZvHRVKcKFERvyqpV3MuWzMZdaJdqzZv/fZ1e5liE21z/+bwgyUmQ6NNzdAzHibpD9mhvOmZbOqQQP8=
Received: from MN2PR18MB2605.namprd18.prod.outlook.com (20.179.83.161) by
 MN2PR18MB2735.namprd18.prod.outlook.com (20.179.23.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.19; Fri, 20 Sep 2019 06:35:19 +0000
Received: from MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::2809:977c:6a8c:7d79]) by MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::2809:977c:6a8c:7d79%4]) with mapi id 15.20.2263.028; Fri, 20 Sep 2019
 06:35:19 +0000
From:   Phani Kiran Hemadri <phemadri@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Phani Kiran Hemadri" <phemadri@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - fix firmware assignment to AE cores
Thread-Topic: [PATCH] crypto: cavium/nitrox - fix firmware assignment to AE
 cores
Thread-Index: AQHVb32S74CgRaLSIEO7NCZ9zEpA8A==
Date:   Fri, 20 Sep 2019 06:35:19 +0000
Message-ID: <20190920063439.26486-1-phemadri@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:d::14) To MN2PR18MB2605.namprd18.prod.outlook.com
 (2603:10b6:208:106::33)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.2
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f5654b7-e0e9-49d2-6514-08d73d94b497
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2735;
x-ms-traffictypediagnostic: MN2PR18MB2735:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB27356B05439054C6E2BB4B84D6880@MN2PR18MB2735.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(199004)(189003)(81166006)(256004)(1730700003)(386003)(86362001)(55236004)(52116002)(71200400001)(5660300002)(6486002)(2906002)(71190400001)(6512007)(5640700003)(66066001)(99286004)(6436002)(2351001)(186003)(81156014)(36756003)(2616005)(26005)(1076003)(6506007)(54906003)(8676002)(7736002)(14454004)(476003)(66946007)(64756008)(66556008)(6116002)(66446008)(25786009)(3846002)(107886003)(478600001)(2501003)(6916009)(305945005)(4326008)(50226002)(8936002)(66476007)(316002)(102836004)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2735;H:MN2PR18MB2605.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bmF6fsmjKnwgkZC4A4yXrSycXehY7t83duSENtakNcWGD5sEqcXgR9yEPKeGnL3EBUPk0DvNHYUw1JvRdJmIs+FhNWILVkMNIRKWtqDEIDHTVkzUWPeyjX+RWETvGBWFrtjH7Jpvck8CgKkbhqdo+zCaofQhS+QTbXWyEeW+sTN28GA1tmsrAfSSMpAwg/efaYCAs9ehib/EbaQd7XtFJKMrJI+rIRh3tV7C9+LrihZQ5wv/44PrGSab/cP7ogrE51pGjpvSPjUqexzcNRZvMxzk9YcX4VLYrdhmSsYMR2qfyVxi3TDk8UlFrYztQO+LL7KqRoL54ltIWNX71c1X9lFL6sWp5tCsPOph3mVzIc11G0kkymZWdUjKHGSYxky2YjjR5LC01lyxlXmi5T0BuRy7i7Iz7CaW5QaAkDPnoeo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5654b7-e0e9-49d2-6514-08d73d94b497
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 06:35:19.2897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDEyZmCJV42n7K5d2Kr/PQuVrdjVKL/ySFOaazBlJGAC7Em9NMWG3U84HxQM1B13VSgjAHFdroVkIgZgPVH1MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2735
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes assigning UCD block number of Asymmetric crypto
firmware to AE cores of CNN55XX device.

Fixes: a7268c4d4205 ("crypto: cavium/nitrox - Add support for loading asymm=
etric crypto firmware")
Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>

---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/ca=
vium/nitrox/nitrox_main.c
index bc924980e10c..c4632d84c9a1 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -103,8 +103,7 @@ static void write_to_ucd_unit(struct nitrox_device *nde=
v, u32 ucode_size,
 	offset =3D UCD_UCODE_LOAD_BLOCK_NUM;
 	nitrox_write_csr(ndev, offset, block_num);
=20
-	code_size =3D ucode_size;
-	code_size =3D roundup(code_size, 8);
+	code_size =3D roundup(ucode_size, 16);
 	while (code_size) {
 		data =3D ucode_data[i];
 		/* write 8 bytes at a time */
@@ -220,11 +219,11 @@ static int nitrox_load_fw(struct nitrox_device *ndev)
=20
 	/* write block number and firmware length
 	 * bit:<2:0> block number
-	 * bit:3 is set SE uses 32KB microcode
-	 * bit:3 is clear SE uses 64KB microcode
+	 * bit:3 is set AE uses 32KB microcode
+	 * bit:3 is clear AE uses 64KB microcode
 	 */
 	core_2_eid_val.value =3D 0ULL;
-	core_2_eid_val.ucode_blk =3D 0;
+	core_2_eid_val.ucode_blk =3D 2;
 	if (ucode_size <=3D CNN55XX_UCD_BLOCK_SIZE)
 		core_2_eid_val.ucode_len =3D 1;
 	else
--=20
2.17.2

