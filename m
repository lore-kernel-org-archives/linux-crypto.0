Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5D415D0
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HeGlrgi4"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8L2fN015315;
	Sun, 24 Dec 2023 08:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=WHTWWF6fs3oGlO2xpIVhZtmOOTc6efUyQ676WhtCIo8=; b=
	HeGlrgi4JMDjxW3kHv2/iytjFiO3+g8iPCErpnvSAoZYsmgAt+cfO7yD9cUGIy2n
	MvcMhAdZPsc6X5ZSs6r6iqOtRI25LsOwHlr1+Yn2guAGWUZlYbXi1miCi0pb+bqg
	l2IzyYvFCkA3uy9hD8ufsmcF0uLDxukc3hvMOuFVG1wolt8NwhJ8a8MTSPuymr32
	nW5E/Xlms0WpSEf3eKxK4xvVFAXkErEfPynaErj4//rny1szbHtjvjv/5+A//pnw
	CslkZd9EkyWk1esesfLuR62gvCrwva/mKeP0uV8BXUtn/kVzTm3CPyfnZyLnozZ2
	eUx8gOa3/I6BYLToZLsqxA==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60rs6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QotxFuBwe+ZiiN3qlBYP6PjN3Umk1jbEf/jeNpdRWpgUVGN7+zDPR7XCHvK45TzYd76UXUhSosrQX9vUbBEt9vhgeCNsx57CTsSNLcOaKZ2q4ZVahqp8g4aQwEs3mwOvHygocDgaKQ2roPXBZOTWWbKaNUmUq6xmcTbZP98+KioG5nMS3uZQdQei9vGz35FluolJIqKl7vQQvR6GS+cJlWIB3BoY0F2fCtQ+h/4Fg38wu3ni7AAg2by9S5E2eT8ylP1YLDcCVFVtBP6aV3xEkAV+au3StI76EplSJMsSOwr+wCFuCAvcoLTQPgzdF2+Bi4QVMqFlDWzeiS541n1b0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHTWWF6fs3oGlO2xpIVhZtmOOTc6efUyQ676WhtCIo8=;
 b=YPuZ9Gbagys9lk1dmCM1bJG4PpDfR2oBTQZfONSHj2uJ9r9vir5ItcvzS+JAHbdHiDbw8uUxB1jjicnQqIAlc7OsTxj7dNHKC+mgPcXnOB8+9GMk+h/Q2qfrTsjfBBQeNspvFyxFzswAznMZft/X5lvv0ZLDqKD18c7AErEd08SZR68u2yku1u9+JZa0RcvcjewTDxWFboYpP/9YGVJl4s8Q8vQADZmy1QpJsbG95g8zT8MY0sukggjD/Q+8K9f1eWK3PhJzFS8/htUOSMBEb95owPkFLxijVl+p8lE/C7XlY85M5WQ9UxL+COezE++NZdyGs8fvy0E6nulw4l2Fuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:01 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:01 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 01/14] crypto: sahara - handle zero-length aes requests
Date: Sun, 24 Dec 2023 10:21:31 +0200
Message-Id: <20231224082144.3894863-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
References: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0094.eurprd09.prod.outlook.com
 (2603:10a6:803:78::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e18ae4-c5f6-46f6-22a5-08dc04594337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nMfhcQjS0CG/rT9d3fQM357GWA30r7e0s8frRZySbvhenlyfpbYSQ3EGmeiivdoRTn9l8KXT/uA9YYElJ6XhAeV8R6GcMbrcWXd//y8/pGfdlhq8mSeHNP2lEuLZf6btXuFCiucrcXO4GhEAx6y8lteWaqCD5AbzI3weqFl0sSvN3+ecJ3ERrjUic7CXFcMcStVx687o6AYy/sVx5Y7UyTbBK/F1baih/O86iB+9SnEkI5idLACCL1Ww2t3Iqv0tjGi6Q+8PXTZPrCGt1CpavD3qXWcSjxI7n2ITXbHy0eDhAOAIdD3XWlLC9s+7qPlab0PqvkI/8vJXjGyZGMh8WvjOUGyl9ShCjZnQT9+/dQXcNGLT9N0R8Z1YA5e957fTrATwsvdMg7TC18it/f5HgwDgnWBU8q+IkGodZkmKqXPh9YoMJMbvnIYv1xfdlh8EX2/j9kAWdoABmnNbS95nR+njC8Nd1p3qXW7XcLeaJIwAn1ZIh3jmZFT+rds0bJVjPNGXqRDAHXW9Fd+hxO2hW1djdki+88HJXV1uBR5UGbr1Kq/MiQFzYoHNOazldD7rnw7QxDQEwPSF6rjSo6EWhxy0ZK1je3P6Bil0nUv0lR3Y+8Qgb5giBVWDen1cQoxL
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39840400004)(346002)(376002)(396003)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(1076003)(26005)(2616005)(52116002)(6512007)(9686003)(6506007)(83380400001)(6916009)(86362001)(8936002)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(6486002)(478600001)(38100700002)(38350700005)(4744005)(2906002)(41300700001)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BUhInwOPYlJEGNiPFujUrXaB9gWxmHEoNwGq5IWGiQYu+c5Aj32e/6PcA61+?=
 =?us-ascii?Q?JEOuBPH1MtwQwsktNEZg9/ZYMtL0GhZLw/7hDcUV23bmF7+GXtFim1tCv746?=
 =?us-ascii?Q?HJvspVBuInHPn7Qqz7gipJIbMJfeDY+yMFE4o00zhPN8D9aamnWy0nuS7T26?=
 =?us-ascii?Q?OkfYZPdlSwV9SomLu1OYwJSjrbKL7X1m4ihxU3scbf28ocZxFKG7WHsi/1Si?=
 =?us-ascii?Q?CpB8JX3RCkuogCSVRvtkAyNlX4hHajYRS7m+p0WC7BRJMwGuUSyBd289s3Pi?=
 =?us-ascii?Q?dKAJivgUaBLO0ACcQFGwroJDCgSzu3Eb8lWsTYrQZbpxQySs1uYMZNewDVfT?=
 =?us-ascii?Q?Cj7VYVJWsbUd+EFePPOUv6CeiozgiDcy/+JxYAsvAKSt9YMS2Gvcu155aA0O?=
 =?us-ascii?Q?uhJbCYzGwCCh8/lwxP6c1ffuJn3UrffYw+Mp7IJ6OOeb1Kmyxk5Evd4OSAwK?=
 =?us-ascii?Q?V1eZHF3kiG82VFmRvj90wNb3A3ZhAWdPhOgN/0zCvCYM5rT8F2lc1WVKyp0A?=
 =?us-ascii?Q?5F/2AYuLm96n1Q87eTpMPqnvUknOtCNLboB9Kxl+peULEDPalD3oKbswENPB?=
 =?us-ascii?Q?00Ba58DlQKAOeXDFRfpTAHAClUero29arPZbbkFo77TMpnDPsMmf9fRjpOqt?=
 =?us-ascii?Q?zO9oWTU4SDczCAe7thLdzIQzLc66mZTR5dDL10u2Cq6u09CpvErgmSOV4pgj?=
 =?us-ascii?Q?zQyxt4QCZ8z0j99ZukM48RAWnVdbitWBXTmQPvNtQPMwg5KgXlJ0SEGlTKie?=
 =?us-ascii?Q?aF5+pRq35wM1wogcYmfS977bFoORmwDFkscnTIgj4c6qajyK+OepPFzp1/cR?=
 =?us-ascii?Q?wriJGuggcKHu6CaMhbBAwEJHYM6UZFxv+CKc3zPVO4f+TH/WUXCXjzcB79lO?=
 =?us-ascii?Q?dWKqbLtmO43bN2pboRLKV8evPpR//VgtI8V9EjfzyaIm6gDCLS4EU99ke+kX?=
 =?us-ascii?Q?OPVd5Ly+oRfvM2KCPuQeWroy36dyWrRlqvDLbAfTKKLO/Opz4gOPGEJVjfBm?=
 =?us-ascii?Q?wIFgL3rBuKvbcfOyhKou+Wt3DQJY+GxlkK4RF1aTvEe2KglhDj7ewMdJsHlc?=
 =?us-ascii?Q?YmYbROM1a1pQdN/GyZTWkOu/OhsVtMlF68QjZ6DszDAszioPJ7knhChza10z?=
 =?us-ascii?Q?bpjcglqGJvTyLOFwNEjNNSBpBOqlf2vCUICGtf+iU0YtJ0uIaaRRU6fxvFni?=
 =?us-ascii?Q?rqxKcMudK7T2klBn/T7lXtwhMb/O/nOoBnLr+5wyTKWoDEr9YeOzUdGpAmzk?=
 =?us-ascii?Q?sky9ennYPI+kEs0RbiGqEemv4RN/YZGztMqmAcVry1XCaVkvrcdAO+pEiWSY?=
 =?us-ascii?Q?6dbzNrqKQ4a8Z/nS42cRcSS6oQR/qdkTMwFO7eEo20o/tUKRu+X8euJRRMGB?=
 =?us-ascii?Q?lc7k0Se7M0ND4PvsWI6NUbziY6eeABj7YSnXPFJHUd8J/2FM3NPFNN3w+To9?=
 =?us-ascii?Q?pGU7ajRCGelo7MBCmtUw+EcoX9OZ0R777ALWnMpc1v0tlHf5/vQauzpJKYwt?=
 =?us-ascii?Q?EyP5wiD2M4obLCVkD0f4qML62WlJ02FQ8W5+B5FWPgOrD89oBGv2fj7cnQx/?=
 =?us-ascii?Q?kxcuz/w49UuhkWuSHZVpeDXdGvWK1IgoxTZlKkU/0X0iqlsSGePGOfwqHhyl?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e18ae4-c5f6-46f6-22a5-08dc04594337
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:01.2522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIGVwNLwst525ta9HVB9q0x8JwTnIkPrwNMoydZ4hBu8YLbjrvgdLo+RZwarnr6UpC2qu+8bstTOFwOFmKdpZEY80+3yg+OjQKfnc+0Ic2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-Proofpoint-ORIG-GUID: CjJB1gtSxwI6p5_3BMx2Az14z-t32dyK
X-Proofpoint-GUID: CjJB1gtSxwI6p5_3BMx2Az14z-t32dyK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=691 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

In case of a zero-length input, exit gracefully from sahara_aes_crypt().

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 27ed66cb761f..1f78dfe84c51 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -674,6 +674,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.34.1

