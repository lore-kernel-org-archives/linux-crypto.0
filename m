Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79E49C4CF;
	Tue, 15 Sep 2026 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466221; cv=fail; b=ena84Sm/TCezpK8ztCUQzSj1Zsgwn7Pqzogcehl+0z9lYQ7zG2HCxpafE0NmRUbkG7FR2Jziqcn06ol7B3kmNYG0cu5T+LW4zzIfe9DC9QnqjrgA1NYAiQTi9WHLgQBumGWs71+Xg+R9JD1xciM9NnK5eWlPgSH2rcO2pZ4cqYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466221; c=relaxed/simple;
	bh=ApNPlj/D2OLJpS6qqeB46sofqIuOmu6hWxom1CIotxQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=mKc6aJcUU/vnmkc38hl5EKKKOwBQ7aQmPsQRarKnFGxhX8P7rnCaEFbO5GlYRnWNfo7xfdW9WpZ6L+fFtvAdJn3VNpHv2PCfvbsLK/CldmR/vfBLwZXPLtTnQqkUz6N5SUO5UNLLVXiogMv+n6cgezR/YWXAXXR+UDgb6PZlyYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=kbi7Xojv; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Diwq2Hi8; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="kbi7Xojv";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Diwq2Hi8"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fLlK4098113;
	Tue, 15 Sep 2026 04:56:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=issG/CnsMWnjoEfnrIxZ9pnEnbbkg41rbgZNslhU1
	DI=; b=kbi7Xojv1ojoiDo1YZKuccWuGqBvgcW/cLTGhAtjKdExRV/on2cXOT3Pd
	oh7sh2NVQE5TAdtMu/EzYpiGWZw3UIeIuODJL0a6OZvjB0OX16jXNnlq92RBdxJn
	sfASvA1mLH3GF05KEuxQvNlqsResP2lYbtoeWlxuVJDd6hpOaLjYwOfjH5csqwX6
	RxhR08aOdO2qjm2jd8KwYt8Z50r0hwZZ6SD0u/Xe8kQJEhvnF6e9OkUjtpwGSGjg
	fQ9dBlXHM1sb7Txz5ZV4cRySN4vjFSp4KdAFAg2iAlW21aaO5m2iM7pnV18S4sH9
	JZBpqY1taKh54J/ilK9pGx+GMH5kg==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakkf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:52 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bz0TO83IrUoG5x6Wk+CDi9gr562EPNXDN0xasz8Rq++sFHJEGN853eXGm9vDIRDFo3R/B7zyuoOiB7y+ikawAG1C2muQFQjlhORC3RcvdN2NLG+5KT2zserHLCGBzDSjl//HWHZzliasMEATebUajcUw25kuxV1W70F4bF9ooBU/NDU8A+Ng3EW8H+2tcg9QQ/6jYk8cy7wY0Z+hM27goA3LYmiVgwp8pMYYo8rXwGK49xt0N7/IsXh77+Y/+xdFRFr9g3NZIb2Zc0/+6w8HYTzM6uguSOews3Ouq++3X+cyVcYKP4u0px6Y1K927nbjck37JeuZT/D3mL5wZiuHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=issG/CnsMWnjoEfnrIxZ9pnEnbbkg41rbgZNslhU1DI=;
 b=GYdsXTOfSeZ5TxXfBgH9MEX09KKHrZunWhfSkQ0zGnWRjdxWDROJNNbnjpqya5DkhmoK5VLf2v/tYmCr1v1ow52ilgkZUEonKp5k98y+YjxdqVZvB2kqgrP6VlUGUoatclOmh8ZkxzagacATLolDF695NfAJbZ4KmmQ6u7pJNZJkqZbKTOa2XyRX9BX1WZITKUOHzAk+x2mhx9Y+WKT5hCLtkcEb5iWR7T0Y0jurL8u/WHB9m9MjP7T7LvjVM4bHt7DEkyIocbFAW65DnKavJuKc1d8S/rbJTWMoa+J+8yk3NZG9ktg/bsuU+2f93RvKnUAKKaYq9pEuChRACQsMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=issG/CnsMWnjoEfnrIxZ9pnEnbbkg41rbgZNslhU1DI=;
 b=Diwq2Hi8bbr87QPZDnIUKt9sGhWH3FSVA9VHr4WWLk6bm14p3AkQ1P5yYaQARM7YqKyvo/dO0/tswpKoi+00jfmi9jjTm/1JhJRk2+TP7RnNPJZGq+JvrD62gowHxQK5eFPqxiYL/fFbWNxJplVUeL/3Y1Z9daPHbHrQrALv8rc=
Received: from BN0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:408:e6::10)
 by BL3PR10MB6164.namprd10.prod.outlook.com (2603:10b6:208:3bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Tue, 15 Sep
 2026 09:56:47 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::1e) by BN0PR03CA0005.outlook.office365.com
 (2603:10b6:408:e6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:47 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:30 -0500
Received: from DLEE203.ent.ti.com (157.170.170.78) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:30 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:30 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8D3000901;
	Tue, 15 Sep 2026 04:56:27 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:29 +0530
Subject: [PATCH 23/30] crypto: sa2ul - fix stack overflow in
 sa_prepare_iopads
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-23-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=6340;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=ApNPlj/D2OLJpS6qqeB46sofqIuOmu6hWxom1CIotxQ=;
 b=1kw++g4eJzluIi61RDEdlRJ6/uzb6/lIdEaGk1wANinTsi8Qo0eJShrE5ECEfZiVG+NhuAiPf
 sMMLCA/ipg9Dstma2qQiuFpOXp+8RM686SgONH1Ag5bpy3R+75NNh0o
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|BL3PR10MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b343bc-0419-4d37-db32-08df130fa833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|56012099006|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	DVisMkuBLKnCtPW0RRPPsOX3jyXjWYSGe3k2C3XPtx0SUa2wcB0/fAIGEwpRRhi/vUUJRGXaBfBC+BJBwZil4k5zbIfd0cP/zjD5tAQ2Q0HpXsqFMUvw69dFdahVyOe1D40GNQyfQ6OrYGI3eZMkAlaf4ofCLoBVZJiaY1F43ia252ijys8F8x9qa4SQr6VhaEeC+uryjjAIleZ8ibfZo7WyELfibxOuZYx37kd79sf40wdIhibHWCYXavY+++zft1/P36AuVGehzRbowcV1oX04WcboyAo3Ryxdej5ZqleLfz8R5Sh5NySeOrWLVIHy2WICX2AbDeMcDl5sAijhtzIgwT5gkSeq742+6fObPC+SdBpJlFjGrLrKQfc34t0Qvc2/ahq5B3VMBGQZ8MHixk7SvLIU/Fse4XWD/LvAHk7PjjwKBmDYEK24+KTuFqu5iTalzZpN04/X2oKpwC++1ZB7J2cUTC1veGacrUzXC2ywfj/h9/IEpUt/OhT18sC3Z+56YmHYJBktk5i1X1mCCfxyRXn2asdpIIMRBSBptLgX3Wi0opc9drE19NDu2qhLq8SWNhvpUMJZFXUElMoDfAP+MXkP7A9ZDvBSfGpwMkV7FX7smpgoE9CzYblR8lbl3mh7hN68I+inJ3+Vfqv7ihoprHEA6qATLWnt3EWvwBdSSM4+IePYMd7R/jwr89i5zfAmimeRuGDCW8or8Fv0VQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gbmYmEwop6fi9tbuFMy8effkTIME/68pghGreJ1Nco9MzoYibZLLOVhfzZKiWcyTFaPk/9qom1OIY3E0kjfdvkKZQNb8O54Qh4c3x/PKcdUMT0PLblLhV8+iISX7f/7v+LE4H12UeFLy20DUAhcIbMs6Edg+eg7qXjxfUTFyZiMREWQLVzuPRg9Lv6Vf630zstZ3K4ozJb7ntoQiMH3AuItB9MJGNtu1LN8mysbkKaIO+0tzTFRW86g4JhmA8PRajTt3pAE+wtzgeN2MQvbFEDILpL9Ttt6Chnf44w8Os/Vey+1BncDUrbrERBDGed1u+4wcAEChZuSi83HqfzS+UMAoSAip52/DdkhetXtlmnGPKuCAC8krqUnZ7Ed2IJCvqB8LdtHAB8rwtlemArrQI6B4lalK+ZboMVtu00UG/Ez6sOLt4fhv5i6YJB9dLE3r
X-Exchange-RoutingPolicyChecked:
	a5lhKJLdGr75Qx5FfPEv0v828di4M1UT4o14E2h72k6BkaFb3wqON41U1x/zDuEaPshvGnUsn726/DeKSgHockJXotpqlOa9dZ1WNeujkTZVSP7eom0qoUqHsgfOAKDCzUlLQDhvCAHsxI2rhfupNTePDuPne9BGlA0FSEjvfsuK7UOdbdPWNQ2Ozd5gFNt80OH1HrAmQjDIO0uPSRtUC9kSQe2RXb38balqoGyLORD7OoiinO5yY29MvqN9tREP03uB+Ka8bshVujV3LcLiAJdWBSs+M0kbg0xnCvuryT7dfhXDnA8+ChDJTI9lWDKf0VwrBOetYYwpZI2kBkA+GQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:47.6088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b343bc-0419-4d37-db32-08df130fa833
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6164
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX9Q5ffvgCGv0A
 36NfMbJ5MUZNyAV5XSroKFNrTsk8HOGDtY+VB6Wvnr00+2HTgKjaX9DI8xv/J+2dnS7rC6LkYjX
 McYlHyOCaYnSrXStJJSYA+Vm2ik71a8=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91664 cx=c_pps
 a=wVrytDogCwW2gNy9sPioUw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=AYz72fFD7cF7Bsoe0ywA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tjIiyHi20taEoAlUQJVl6z_POV7YVOYk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXyoZN27IYeMFa
 3kkDvhPJeoJoZkcEowfkvC8tmShEv8T2twWuNGAE3GuG0WrGIv/17/Ltfp8RZybuLjbAvgoNZRl
 tCviu+Z1OEzawTGDJaX/BWdTsGNWt5WpLdRV+5aNwv9Mtk/IhGzqR2wXfwdS0++n9mGnpJLIf41
 znRVMZGyOtiEMLC86s6YhpiP2cg/1AGZAKd8YvqqGokUcFm7jelPdsMRzsFGmjnTlAURRKXfvoq
 pWJq8q8VZPQYvL1b+hn71Sf28ufF5go07oDp4Bs9E8kTAeW+f5D+A9ZjMgMlekYd3kDcENOWRoR
 X07g23MweJCJl0gnVUD6Kjax1EEzBw+I17YSZADK1rzhUauxn1d4xUeS3yPIjM3EOj/+TdCuwOm
 URYgI6/w68Te5rkOYCr3SbxKxg9EyX9japy8gjhEgkpEB41jEySSyLOASfpf3QFy8YlxsvpEfKW
 TtyzH2vPqibs6ZYO5Fw==
X-Proofpoint-GUID: tjIiyHi20taEoAlUQJVl6z_POV7YVOYk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The sa_export_shash() function uses a fixed-size stack union to hold
the hash state during export. This union was sized at 104 bytes,
covering sha1_state and sha256_state but no longer including
sha512_state as it did when the AEAD support was first added, leaving
zero margin once crypto_shash_export() needs to write more than 104
bytes:

  BUG: KASAN: stack-out-of-bounds in __crypto_sha256_export.isra.0+0xf4/0x138
  Write of size 1 at addr ffff800084c46d78 by task cryptomgr_test/219
  Hardware name: Texas Instruments J721S2 EVM (DT)
  Call trace:
   show_stack+0x18/0x24 (C)
   dump_stack_lvl+0x68/0x94
   print_report+0x118/0x200
   kasan_report+0xa8/0xe4
   __asan_store1
   __crypto_sha256_export.isra.0
   crypto_sha256_export
   __crypto_shash_export
   crypto_shash_export
   sa_export_shash+0xa4/0x198
   sa_prepare_iopads+0x234/0x460
   sa_init_sc+0x268/0x730
   sa_aead_setkey+0x20c/0x390
   sa_aead_cbc_sha256_setkey+0xa4/0xe4
   crypto_aead_setkey
   test_aead_vec_cfg
   test_aead_vec
   alg_test_aead
  The buggy address belongs to stack of task cryptomgr_test/219,
  offset 152 in frame: sa_export_shash+0x0/0x198
  This frame has 1 object: [48, 152) 'sha'

This reproduced on every board tested (311 occurrences on a single
J721S2 EVM boot log alone), always via the authenc(hmac(sha256),
cbc(aes))-sa2ul AEAD self-test. It surfaced after upstream sha256
changes (e.g. commit 3bf533787910 ("crypto: sha256 - Use the partial
block API")) altered which sha256 shash implementation gets selected
for hmac(sha256), but the underlying union has been undersized ever
since it was shrunk to drop sha512_state.

Fix this by replacing the fixed-size stack union with a dynamically
allocated buffer sized via crypto_shash_statesize(). This ensures the
buffer is always large enough for the current hash algorithm's state,
regardless of future changes to the state structures. The buffer is
allocated with kmalloc(GFP_KERNEL) and freed with kfree_sensitive() on
all exit paths to prevent information leakage.

Fixes: ad0bb4e4d226 ("crypto: sa2ul - Reduce stack usage")
Assisted-by: Sisyphus:claude-sonnet-5
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 52 +++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 36c8403b5713..265d1afaad81 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -18,6 +18,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
@@ -392,39 +393,51 @@ static void prepare_kopad(u8 *k_opad, const u8 *key, u16 key_sz)
 		k_opad[i] = 0x5c;
 }
 
-static int sa_export_shash(void *state, struct shash_desc *hash,
-			   int digest_size, __be32 *out)
+static int sa_export_shash(struct shash_desc *hash, int digest_size,
+			   __be32 *out)
 {
-	struct sha1_state *sha1;
-	struct sha256_state *sha256;
 	u32 *result;
 	int ret = 0;
+	int state_size;
+	u8 *sha;
+
+	state_size = crypto_shash_statesize(hash->tfm);
+	if (state_size <= 0) {
+		dev_err(sa_k3_dev, "%s: invalid state_size=%d\n", __func__,
+			state_size);
+		return -EINVAL;
+	}
+
+	sha = kmalloc(state_size, GFP_KERNEL);
+	if (!sha)
+		return -ENOMEM;
 
 	/* Export the intermediate digest to program into SA2UL */
-	ret = crypto_shash_export(hash, state);
+	ret = crypto_shash_export(hash, sha);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: crypto_shash_export failed\n",
 			__func__);
+		kfree_sensitive(sha);
 		return ret;
 	}
 
 	switch (digest_size) {
 	case SHA1_DIGEST_SIZE:
-		sha1 = state;
-		result = sha1->state;
+		result = (u32 *)sha;
 		break;
 	case SHA256_DIGEST_SIZE:
-		sha256 = state;
-		result = sha256->state;
+		result = (u32 *)sha;
 		break;
 	default:
 		dev_err(sa_k3_dev, "%s: bad digest_size=%d\n", __func__,
 			digest_size);
+		kfree_sensitive(sha);
 		return -EINVAL;
 	}
 
 	cpu_to_be32_array(out, result, digest_size / 4);
 
+	kfree_sensitive(sha);
 	return ret;
 }
 
@@ -435,16 +448,11 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 	int block_size = crypto_shash_blocksize(data->ctx->shash);
 	int digest_size = crypto_shash_digestsize(data->ctx->shash);
 	int ret = 0;
-
-	union {
-		struct sha1_state sha1;
-		struct sha256_state sha256;
-		u8 k_pad[SHA1_BLOCK_SIZE];
-	} sha;
+	u8 k_pad[SHA1_BLOCK_SIZE];
 
 	shash->tfm = data->ctx->shash;
 
-	prepare_kipad(sha.k_pad, key, key_sz);
+	prepare_kipad(k_pad, key, key_sz);
 
 	ret = crypto_shash_init(shash);
 	if (ret) {
@@ -452,20 +460,20 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 			__func__, __LINE__, ret);
 		return ret;
 	}
-	ret = crypto_shash_update(shash, sha.k_pad, block_size);
+	ret = crypto_shash_update(shash, k_pad, block_size);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: crypto_shash_update for ipad failed, ret=%d\n",
 			__func__, __LINE__, ret);
 		return ret;
 	}
-	ret = sa_export_shash(&sha, shash, digest_size, ipad);
+	ret = sa_export_shash(shash, digest_size, ipad);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: sa_export_shash for ipad failed, ret=%d\n",
 			__func__, __LINE__, ret);
 		return ret;
 	}
 
-	prepare_kopad(sha.k_pad, key, key_sz);
+	prepare_kopad(k_pad, key, key_sz);
 
 	ret = crypto_shash_init(shash);
 	if (ret) {
@@ -473,20 +481,20 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 			__func__, __LINE__, ret);
 		return ret;
 	}
-	ret = crypto_shash_update(shash, sha.k_pad, block_size);
+	ret = crypto_shash_update(shash, k_pad, block_size);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: crypto_shash_update for opad failed, ret=%d\n",
 			__func__, __LINE__, ret);
 		return ret;
 	}
-	ret = sa_export_shash(&sha, shash, digest_size, opad);
+	ret = sa_export_shash(shash, digest_size, opad);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: sa_export_shash for opad failed, ret=%d\n",
 			__func__, __LINE__, ret);
 		return ret;
 	}
 
-	memzero_explicit(&sha, sizeof(sha));
+	memzero_explicit(k_pad, SHA1_BLOCK_SIZE);
 
 	return ret;
 }

-- 
2.43.0

