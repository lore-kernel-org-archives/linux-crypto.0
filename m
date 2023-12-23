Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0359315EB0
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="pjSJjYju"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI1QFq023723;
	Sat, 23 Dec 2023 18:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=6hgaBw09txHZH0YxfSZGMqUzwtuDDReyweHC1Bg2UKA=; b=
	pjSJjYjuBHsDty3JNAGBBSd6bQ77NV+Yl0HiRV/3ALskBxonxIuYNR11xvb1DiGq
	J0MnkGwc/zUYIUXWS8O9Fjlmn05DgXlsQxtyJEI/9iXvVgVn7i3mX0aQ8upY3uL3
	E1pCl6Dc1m6ahnBQ1f90y8e4q9Uusz995lQN9M153hCUfab4F5e+Ribq+wKPDrEf
	q4Au2ACFRzCOcK+3Kj5zMWydxWamKZJHjCXa0x6CMOHpZjhWQZQPHrtTW8dUH01n
	KNBoS4MnsKhUPgRr0MlozcJpRfxmuoqW6KZsXx0T940gqpjelABKF+8DFIJLVEvh
	lOT3a5/4yX8XcUPrxHCdGg==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrfj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPcB/t7joGasEnGlb9tJDhQFtEDNAoj/hlZ/CMUH1Rqc7N1zIjmq+xZC2fES184Z918mftm4upxmlwAVc7s28xFSs+bqUpD7WZJq6VR7fCdLl2HULRvMnIEiIfLbx0XSZ3I9vUrWeGVJDqXPsu1PUPKRNKoKTOZ8t8bOTcUVcF+zU78+B/u85VbDRY7LEC4wNNsRM+K2m5Iv7nL5eeMIbTP9NW8frwFhs+Ezrov0W4SpW+C8eup2pZXgtrz5fkIDNAJYuHLkehme1Pmv5APnGRHxcaj4W5QuxAxmUk7AjQBr6gCEvPXyIWhHlIMBAtikaU6Z7JrVlUIpXbwYvku+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hgaBw09txHZH0YxfSZGMqUzwtuDDReyweHC1Bg2UKA=;
 b=a+d9IU//UDGREFzyrbyzaKVw/i++9K0/9rXsxdB8yq5wm3U7VEHngdgCYu9DBsOcfrk6oJieKQtsRonL8LB0QtPoiJaZK068EXd4AcE0MY1pcURb18mQXBtdKVA07FO5/hoz06mUSCAL7bfCMrZhHznyGFGZgX69bxh8yQIYZ8pYYHFU0ePfhc1JdXa30p3EVaEdP1fdykIwGKtcsQtqSqv31WqScAVjTGc53sS/Qbqu3lsQxx6t7NOcXpuNVi8q6JLPlKtWkjXcY45FVEESyM877OXR+4GqdHEE/5Lrx+plqLUqhUhI3CmRI+p3wUYLQs4ytmuL/z+yWX6uGsuhfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:52 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:52 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 13/14] crypto: sahara - remove error message for bad aes request size
Date: Sat, 23 Dec 2023 20:11:07 +0200
Message-Id: <20231223181108.3819741-13-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
References: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: 07bd41e8-6922-4c64-72e4-08dc03e28003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IvOvfc94kHxaxC9lpoSS+3LPdPS8GiLYiCDD+6zrnNomJaK69M3YJNHFkFINTQFqtkCgEKLCrcIFiga+ZFXbLZ7coxV9LInBH/U59FJFqtfPqoyDrVupNfxA2vKBD/qc4R+6EW8gc03dHLyLEo4IYpiQNtmdcCOgG1J4r7rv4UryMBTqX9YFXvf9lhHJRGG8c9b5uV8MTA+GTNNiYy+5NHW9mEmT5lwcKXdbQSQxky3JSSQoLhWrITGqAWoiF3uNB8buwvulW1L9ZyLDJLwXk/3L7xjOirSKTqHp8+YPcb8V3lmCuvHams6ssji1PlMEIzG5X1QGPVl9JvlNvWjWDgwHM1ta7GAJ2D+hiWdMvlc1MRn7rr454Ofn5jQSb2duVraK17cIPzRsrahO/PtKoAQWSwIYVKSg4ox3bd3pKNKtlOra/kz5fXJvz5xhKLSGmrdT1jOr6DGXbeII4zZFxmtGRbGh0yqH56vXhrAbFfE2gIOH+pH9wY461FMQQKOxLVCb1EkPnQDzSJba1HN1TiTwYRTh/Bu8/1Vz4f6q5n6ZqFl+DJweORv3FpUN4OwsmvFQYnllGt71KBzo7/AU7iWkO1pDHnjwsm+wawdb4WIC3rOVd2gizy8yqOv+GgKB
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(4744005)(2906002)(4326008)(8936002)(8676002)(5660300002)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uzzjHPQl/TtHkonb2nhOdWpE9fz6GbnEHcgjQRfceeo384+eBbmoikACpSYa?=
 =?us-ascii?Q?peU8sMVb4mFxbgJx5+iE0rPelBJM7dqhqi2gF9Du6MVk3M0qa63OiZQOACVz?=
 =?us-ascii?Q?DaRpZ9yad0Yo/yWpfj+2TnCkRzaFbJha7D88ys7jCddMa4dQVaQmNmExWqMT?=
 =?us-ascii?Q?ZUgf+NcooZlWx4T/oLx/xT6rpukzRSNbxLrSyPloLakGAs2A6h7o5RAMuITp?=
 =?us-ascii?Q?Eym2k4Q629oP3bmujpZEduewTMQZBD29LoM96tmtxfo9ndChzVYbxoZ0j0y6?=
 =?us-ascii?Q?xrQz0IHSB/taudvJWkDeLDG87pvOwMCn47RgmUpEutL+CKl1/b3SwogaK4Vx?=
 =?us-ascii?Q?1ajDIn74Ovm/TpSEqREDbH7uyfPutSLHrYxHxciAx5bVF0piHE7pzYhu+JVq?=
 =?us-ascii?Q?HzSAOdiGu8L8K+hNlNC401UFLjPRaXg2j5hyoac4ulaRY9QVwVe43T3GX6Dk?=
 =?us-ascii?Q?lH8mYn/NvZBY2fDR5QbbhgodVmiOmsyA7o+QvFtoPV5s/EvtEJcUPbiHKAv8?=
 =?us-ascii?Q?BMCbrQeWhHeBkL9kubwn3p3VA7zVU/tXFhPxKvi/WRThSP1nZnz69DnTYV5V?=
 =?us-ascii?Q?KMiMfggRWRo8MsYY6onXGH1Uq9ChkSw/87sLZLYqpBZg5lrQ0ARgiD6ghPZE?=
 =?us-ascii?Q?+5GFdfwyhEcXEg7e6iml8snjbS2NKJLaiNDaMKMCLaexCGyVwMkJzKQDfsUY?=
 =?us-ascii?Q?Vo5ITTuWg3MHiPrgqI6x4X+5Y8cJ5qwtYV00qvH21vg2+nWr2jmzsqsChQco?=
 =?us-ascii?Q?zL2Uq0FJe9jvYXdUs3DPUcsrQdECRPOEcGidhF0VQJMZOZq/ihIHnjQKas6O?=
 =?us-ascii?Q?tqhZ48HNjAHOUG1q5MneBwL1AapqgV/tUhNaZBkzr3KXoFcJ1zO0sKyfjVy+?=
 =?us-ascii?Q?fWVH5NfX0zFsH95Sd4d3NkoSD3EAWOxrgTGu2YL77icj1bGlhHPk6BuoCHpG?=
 =?us-ascii?Q?Yt4ZQ5LQnec2Mf5kk5q+yP6pUxxKkS6PoKAIQ3PN81yKyjkvsYJHLaWez87F?=
 =?us-ascii?Q?ODFcvdh8AFX6o9b/HVeZ5D/gCAqbD43Z2o1V2qGb4SZTgUQiKMzbv/7ewlLb?=
 =?us-ascii?Q?ZsGDbUEErpIAZxUSmlRQT12fO831JssmFB6RfjwhltecnEsy3o1WgXNBmhJJ?=
 =?us-ascii?Q?OC8CkdZ/TmKZ4S09LS5XMUnA0FHWtD3W/j+GmnZwV0ujpNFezB8pvXbu5Fz3?=
 =?us-ascii?Q?jA92hqAE8GKL747GvHIoaeSQqa6Lxg5QRtl/ojHOlP0Am9jcdsADwVbwTbk9?=
 =?us-ascii?Q?3fpXe9RWA3PDoxZHPGLtSa3GDaMVgMpTSH07KduZa5tmiUyhozS4yxngolAx?=
 =?us-ascii?Q?OQ4m/5AZNX84unvxY6q392uvwKp2oIWZTlwzgb+ilI8bHSavUdFCWAcT9NaK?=
 =?us-ascii?Q?kQ9RuarQvIp07WWqiXRr7odg/BTqbFV7wVGdNktniN6f9PpZOWqL0e3zPPaa?=
 =?us-ascii?Q?i4bw/tSRjkhYTq3VnBfkXrSwVZ2BLbC+LjZ7zglEt35/24rm3NSBYmXXaeHV?=
 =?us-ascii?Q?3R6KXW36rjQtkzsnZd3/VwkpW0ruIW/ZjEjOZWfJwFFHuArjQTUDvjwqKSD9?=
 =?us-ascii?Q?YmHVv/lYmnP9ZsOxI86bjmSmRs/liCtqvniyx6FKyeVa/mqDsVnLrMy2xdZF?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bd41e8-6922-4c64-72e4-08dc03e28003
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:52.7556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +l+fLrJ+nggaXRs9Evy7bwDvPDqDtH1en1Z8gPN5ZWZ0jirbAr4cl4Rn9zxbFayT/pmjlV2ly0lfEaoQIdcCMEhVW4FVdSdRkB+jXw04Dhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: 9XMCUbtTX-zAlSnEAboLTv-35iW1f35y
X-Proofpoint-GUID: 9XMCUbtTX-zAlSnEAboLTv-35iW1f35y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=889
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Do not spam the kernel log with unnecessary error messages when processing
requests that aren't a multiple of AES block size.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index fdae8c7e7c78..886395603a3a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -682,11 +682,8 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	dev_dbg(dev->device, "nbytes: %d, enc: %d, cbc: %d\n",
 		req->cryptlen, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
 
-	if (!IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) {
-		dev_err(dev->device,
-			"request size is not exact amount of AES blocks\n");
+	if (!IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE))
 		return -EINVAL;
-	}
 
 	rctx->mode = mode;
 
-- 
2.34.1

