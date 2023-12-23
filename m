Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BC612E69
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="RhrpFPBa"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI17ZY026044;
	Sat, 23 Dec 2023 10:10:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=S4AvnDJsA5WSbsqWXra5BK77ut4coblAyvpUguwHv7Y=; b=
	RhrpFPBayR9G230gna2VsGn2Q2rgSRmUnny25hcluyxvkIw3x7NpRVI7u79PqcmY
	Pw/imGUXaFNK1xi5vdIVM5Dxz8FwY4ot6BqvFUOI7Pv4lx4yPUu5Y1THlBFXiPIH
	nrDC7vPjgCaXxv9aaCPPP7qSnAw71oZEeErv84SCsijWN8nn8ZIXUWflpZt8q67c
	zlrQH6k7OLqMG6nHkOmK/L17Ey2b41KMUufv4tqSEWhmiRSUIOcu0c7NbDdHIwQC
	CAfzoYJANl7XYXXcSLT5BGEfzyRdt9gqY/4HUaDQCkxeZ8x4aUeKJC4sjhmjQcb1
	Mz3DU1KCQVq6k6S+6q3/0Q==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5uq4g8ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+/5FIDSt7GzE2s9E0XvBFdN0VN4/CS4oSPrv57p1OBjCLqfXcRXPINyZYBNg36zW/DsRVWy2YriLFpnWt1HnQIryxTFc8/KAkTL8TORnAToWNoF49ImS/jLc4BRrB6dBov/CnQpF+chKvKj0NM0UYd/4AGyLX/4zyDYoCK+zEDGK7Q2TXLIqAMuqk6wG0A4BUab0orObNyBOs+aTigbMMLMGABW94T6McgafNmkdoldU9Yfqk/NDN9VO7aDX5cPc6bOevyp0cieRdY6wBG/BMSs4eHQhtYf/o7wFj1gQAPFKN0T9MzsskzDdsc4eVFo7EvwZxqC7QOxvwk5rHoyJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4AvnDJsA5WSbsqWXra5BK77ut4coblAyvpUguwHv7Y=;
 b=WL8Dg/zQQOOv1kB5Cm794aPUxQ9N96sve3PdyG4karkh8ibU29Yr5XBZQScLzXvtZe6HCU0FzCMYtiHrbAPekBonKeZIykRnX8ekLugwuIqNk31MZxFcMG6MixtPpj+E3JXH7p2n8bSMQszUyusg7aP+qXW3uMctGtVYuFCqjt3Oql5cOWsN7Ri/RgeP2iNr1WlQBgHeF8mPewwYj2VgzqSEu4gztUrrqi+LKl9vUHy5FX7jRMCZo/mDKJKkjpwTkUOZCTOC7PWWPaZAzzUbnMCoyXwqr7Lu0W0oOejsBLYBh9pNEBwQNO1cVgNk7nTvhUZD4QsyBu6csH0REkx6og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:49 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:49 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 11/14] crypto: sahara - remove 'active' flag from sahara_aes_reqctx struct
Date: Sat, 23 Dec 2023 20:11:05 +0200
Message-Id: <20231223181108.3819741-11-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 85afcd8a-6951-4a16-9978-08dc03e27e45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	I7hDWVUk2eaiMr2U1NgPqzR9pjIaW4/QO/j5BKZmGypMnGF60+a1uCDhq8JCP18VPmQMIGIiuCwXcee9AdLy9rIkyOmCDrrfvFaYPsAiI18w7vOD5Eq0gVZ7Ccy0DIIC/b3L3/HMBl6ALCPSzRgTUdCOAEZ7wSi3424rDuqrOjvXkBrj/V64SUgFOFVTmx5StVpsqch41ddVO+VX0yNGtW5PmeVeM2wj8b4loQFWS8o0dDnX9GDsIuTM7DVy0tUhZPokWL75qukACCK/1BKBz79FSyvXal4CYSZqOOj0OazjF78b1cHwCoRXf4ifl5uUNni3VlXZukpeCLzVLybdEuaw6Oyf22RSbBDxKmB/NiSb0XPFClvXkErowS1rlX57KR8c0wnJR8MfY0et7f29y/8gGuNMiifwfCxcVGd2oGuJ8BbEAhfu+vbSJz5MLH2DVnuq8f4ElhoXdDlKt4UAs2Z51AaFKiFS1oaam2QeCmBm9xx5S0kGVfGjOLZM0dYe3eD7tg9QZQEy7TxqrasxE5r4XTZvxyycuS8kJTy+J4IQrEPxvfSzdQ6AhiotuvR2CR9XOjK+PkpxjO7UxVFTRvS4Y6TFS2fPjOoT0Wv4tF3kZKm/Awo/AHUmPGhroW4T
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?KAGB0AWf/pobdQWb/VFbO6XeXgtjDh7GCoCtnBdO9GjS6huT0oZP9el9bZN9?=
 =?us-ascii?Q?aRFLBLk8ZfhR/07Zv/W/6vNOMhB2ejd6l8bwogX+jAgC71ATytdCIyuV85Jw?=
 =?us-ascii?Q?5jujnR0tBRLjKJ0502boFNmvv2ia3nhQI/+HgDgBBxR5j4okXtAI3fWgaXwb?=
 =?us-ascii?Q?jQPmTdGrz+bm9wu/sYJiLSwlCy9AqwS2tqKYJyKcJrxSfob54ntbq0LPLiAX?=
 =?us-ascii?Q?8csIGZ73ls9yCz/r1MWkoIPACLkg0g3zArRjIGkyhtz+QwL588RYnIhpcskQ?=
 =?us-ascii?Q?jpnrA9hvb6vK+GQBuuBe/tm67Uw/BHhF6WAXhmwiNdEHUBu2vR4uFbiQu6Mq?=
 =?us-ascii?Q?0wz5unqWjEQ2C6R/B0qK38hXN10kEYxFaYSEfTukggfPid5aBNTgZK0T0Wm1?=
 =?us-ascii?Q?FrIf0Xu80NBRb4Ml2YwJGjvOQjPM0wlCW9Grgv/mEIOcjKce40OLBVnJFNaQ?=
 =?us-ascii?Q?7G0fU5uUuOn9QIR3BX0k6YzU3wVrt2QFDA/lR5Mdv5yY8vHI4kwpG1Y9wxDF?=
 =?us-ascii?Q?0KVFYW3GVTjzJAmHr56QhGUO8THL1R4OAcjx2F4vOk/ELto/3PmpXAAzGJGS?=
 =?us-ascii?Q?LWosErCOrq1oc59uIOueNN+hPwvztS821Ysht63qyLshthDZVH+eOr92fNHC?=
 =?us-ascii?Q?+e4PLCfBGWYIvGdWYFLl6cXQGqmq+MR6aeIkWibQBfKgyaXkvM0+Yv8CSyjL?=
 =?us-ascii?Q?xQQhADPnE67MZKfUm3IAF4vTkx1LrhuT96v1o+j5CkxBOinlzwOQh8PjzZEe?=
 =?us-ascii?Q?EuXcJqIxqlB+DZfqYgfJvmBsJg4gWq5qu/bHzJp6SVnhZS/ripoKYSsGA61H?=
 =?us-ascii?Q?PlktZPSTe26xcvKVq7K5oPxoYfVZ+rQ9ytaDWRAvnmpxAQcrJOEI1WjIaFvH?=
 =?us-ascii?Q?EUE5H+uMGrOGUv9vHVNdBD6fddnlWYaZznUr1drF9jIPL1RKJ6s9mjKwo/a1?=
 =?us-ascii?Q?ysxxM+zhzgQGVQkQ3zftf4hZzswMFN46szzybRoRjqvUjLZ6ivdmWMe+fG55?=
 =?us-ascii?Q?z+uOpM7bFB5eq5+2+m7oIziwkceysjIae6AwuzGgvNZCUpSH3Te9oeXGDEdS?=
 =?us-ascii?Q?7CymlxqEw8dMG2B3HzY5JYII4Wdg8z9zR2eRo2ZGjx0TuSQ4XDHy0MkbtlEg?=
 =?us-ascii?Q?Y1qNYjq8scFkQXvCHO9dOsMgmAKpBP8VBm8x9igeij9m5i3DEN1OhedkGqBJ?=
 =?us-ascii?Q?MILqnaaa7rmc9spBAc1JV7+IamUr4GFFs4s78OoyujuzfcVXWdP1CsvlMScr?=
 =?us-ascii?Q?+xXg3bJdCRytC0bonKJbIFOGqeuvi8IQzT0IA20wsPGajezEG64wWuc7d0+4?=
 =?us-ascii?Q?mNEUSTdZxwfu0CIzQMYy7WEd/9l7xFvjcFvPz03uqYqp79bws/bpg9Z1ZGlU?=
 =?us-ascii?Q?JfuQ4LAH6NimxmxYvGwTfZhkpUtZAb2yUc895A+nb3w41GcuDcVmBFyDlo9L?=
 =?us-ascii?Q?xnQpoBzVMSuiPkA1pR8RBeQDWgyczK81tEQX8bHuAe2wj79XKlmYrvnNK9oq?=
 =?us-ascii?Q?lyrz7KpkYKKeIzhb/lP9YuNpWmAFOwrZqQCE4vu99Fqig51HPWD8sqM9gzSD?=
 =?us-ascii?Q?1xGR6OKIUV6KzLJNWr8bfs21qSF181OFOfomdejdhofeauY1HRTQFsjt+KIr?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85afcd8a-6951-4a16-9978-08dc03e27e45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:49.7008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auE8AX8o+CC9HfOKE7lGRDZCQjTdLaJtuVlNiWhUfnoT6KCXOnkeaMcLzNaVWFA2ESsNFNwcg9T+H+dChtDkqmWE5uB7fUe8xzQd6Nc4lWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: jswU42rOSvflUP6wc7XG6VJPY0-Nmeh_
X-Proofpoint-ORIG-GUID: jswU42rOSvflUP6wc7XG6VJPY0-Nmeh_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

The 'active' flag is only used to indirectly set the 'first' flag.
Drop the 'active' flag and set 'first' directly in sahara_sha_init().

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 253a3dafdff1..cd14514a43bb 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -168,7 +168,6 @@ struct sahara_aes_reqctx {
  * @total: total number of bytes for transfer
  * @last: is this the last block
  * @first: is this the first block
- * @active: inside a transfer
  */
 struct sahara_sha_reqctx {
 	u8			buf[SAHARA_MAX_SHA_BLOCK_SIZE];
@@ -184,7 +183,6 @@ struct sahara_sha_reqctx {
 	size_t			total;
 	unsigned int		last;
 	unsigned int		first;
-	unsigned int		active;
 };
 
 struct sahara_dev {
@@ -1053,11 +1051,6 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 
 	rctx->last = last;
 
-	if (!rctx->active) {
-		rctx->active = 1;
-		rctx->first = 1;
-	}
-
 	spin_lock_bh(&dev->queue_spinlock);
 	ret = crypto_enqueue_request(&dev->queue, &req->base);
 	spin_unlock_bh(&dev->queue_spinlock);
@@ -1088,7 +1081,7 @@ static int sahara_sha_init(struct ahash_request *req)
 	}
 
 	rctx->context_size = rctx->digest_size + 4;
-	rctx->active = 0;
+	rctx->first = 1;
 
 	return 0;
 }
-- 
2.34.1

