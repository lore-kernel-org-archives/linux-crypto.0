Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="nX9PQGOi"
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB8D4E
	for <linux-crypto@vger.kernel.org>; Wed,  6 Dec 2023 12:36:56 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B6ArlGn015002;
	Wed, 6 Dec 2023 12:36:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=PPS06212021; bh=aCbCqMHB0Djpw/R3uU
	coxeKwzJ2x4KVdP1shDOYZa9k=; b=nX9PQGOiaGjJ4Xqs5obARNsvYJhjPrL2sm
	+CvfeLFG9jzwKB/N3uCAXRLQ6BSDrXD2Nrm5/kU2CC2Rr5w3B6LaKWge4WaRggQS
	2+vC4jPraPXcRsaragTd48TSH1PqquT2ccnEJR5mKNVqMsEBp/gz2XqSCfphqHIR
	zd4+qsHgGoUTjgyGJZsKyE0f5I7UJWul9R4Igqkn5qtkuMTghSdsn3gGpf5fChbc
	82prE13IfRHjsoO/9OztnM9+2g+wv5FYtrCVffB5wWxKRagIn9u8oEiRYQ8cGLBn
	8LcjSbdf8GFX8oRwFeUj8LXchVlMCiCbxEekyCzis5yRwJ3umzww==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3utd2r0yup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 12:36:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSNLIUtenTjj8soxzGWnq08VOLr6H+/XXTtkf+6D+CVh+Ja6cS5LqSBnt1pxtClq8exfArOje+J385s83CjGlQVyAVdqh9EsygU7sUuTzGGyzTnP3lPFkRJLdLzc4jth7EcQkY4kJXJYgbHHK/XsLECcCZBYaze1OMlN9dVrjsVK4DItYuE7mD+tJASsRQ41sedhpUkzezjgHFj9762UxMg20JqbpLsjCby9BS5Yof33fX7OFIDf1FK5JCFYh4GBOiGk7Bs45V/2U+8hbIRTk7gcPEGKdPI5WT9G0rl21M35/F2DBdJjm1BAx+2i1SLM+Vu8IB28VfqzAho/nYO0kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCbCqMHB0Djpw/R3uUcoxeKwzJ2x4KVdP1shDOYZa9k=;
 b=QhNbtaJTaugDJwMaCncgRFJwKrqVuo0mVBbQhhWDNARv2k1VI9M3f1qCZmQbVpoorIp/5r3jNd9jXe6iMYk8dC0i1eCqwecMGx4hs8O7ZScBYNTC3pccyjtURpE1SSHbm3fSiL3eitOzpJnczBVro7BTonvb4ud/lzGd566G7+Wa2GSzKWX5XbxWC2LWRBdWE1hEE8H54MUsNarKyULDQKrcHA1xZm9Sm/PGJbhyW0eaWdu6i/aebBkWjODCrJW70J2IHro9B47HyKgxhsnjz0Y07qJsawaMEMJotcYsHswZ77rs1D3Bv2oRTwJ6bUjBDCBIGxUOE/P9iKW3VG/u3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB7159.namprd11.prod.outlook.com (2603:10b6:806:24b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.36; Wed, 6 Dec
 2023 20:36:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 20:36:48 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org
Subject: [PATCH] crypto: algboss - avoid creating duplicated cipher instances
Date: Wed,  6 Dec 2023 22:37:43 +0200
Message-Id: <20231206203743.2029620-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0039.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::16) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: cef35c7b-70b0-42dc-e8bb-08dbf69b11a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	tLPSj5fJd7TOsDuNyiba65t2IuxVEretVQi1aNhFeJevj4QFvnO5xXZ5a8oaE6rDhM27d0tCWtz+Frsow1ZQ5+DkYwbY0nGXTuFK8wCAeWanj67KuK4G+pVAkIxnju/y1WNlV/la0xeRwfNICbiaS46w20up4GHcWe7wO5vpB5cBcAId2iAhXmicdF/sW2KdK6yCjgxcrGNe1Ca2yYfmdyYFXIOnheiMDNV1HPerYbGhcFuopcbIgQKprxrlmxHZRzHUsa60UKaEn5Bh9PMz2QUuQMuoXOzvVzienh+tDPVDgqOPF19vykgmbG8bElw+Sx5G+RXDoLr1GKYX1eSONPjkW+U0DXoIkx2WcOaGNQZNx5ishJedXbVlM4ce7OE3Dz9HvpY1wdylrzM5fioR7TMF5zTLf7KghwoqQbAnLOpipeORGSPUYHig/5f1gbVuSnnnmVSIiUT/TLjSJx2Jj7EPdZpAtjC0NR97A3y3A+BRuDjyv4exlMW+pae0JvA42uZkFotFBGuqSPkATBjgES7QDNDJPg30q/YtOvoSP0bBU+uOjvDz1jLCw9oCGnHb7rUXV19JVHtXl4esnZE/bVNEZhHUJMchJ7dOAIweE3nhLe/gbZkTfh2pAATyxGca
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(136003)(376002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(36756003)(38350700005)(41300700001)(5660300002)(86362001)(2906002)(83380400001)(6666004)(6486002)(478600001)(52116002)(6506007)(9686003)(6512007)(26005)(1076003)(2616005)(8936002)(8676002)(38100700002)(4326008)(6916009)(316002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GSM51tGk6BPAwxA2c290da/PUywk/vPNnnCbfttLYUmA3mAunVk49KbSfBbY?=
 =?us-ascii?Q?JxqeeqrF8BlmJ4+WOCLsTqs3e5pcDk751m8j0uYzqBlyl+/WaaEzJ/z/7vKx?=
 =?us-ascii?Q?cz6xWNqZZ9sg3yEXZmYFsIaSC3EOr3/3wIJPacnpUIbxuDaURnFPn5V/FCAY?=
 =?us-ascii?Q?5ysq28dvJ+3MUnwkr/Vq7S0NkxlfOSivN9baWZgoIQ1XdPii1QAWWPVBPELS?=
 =?us-ascii?Q?UsVofh/H105XXEFn9sqD1VdIlKfQ4vqr5eugPo08HRf6s1KD3o/r5DFRt7rV?=
 =?us-ascii?Q?RpEjtM89WWOQf293Xtb7lAnlfi6B7tgWEUvSqRyzc6K1TxDjuJLjL1/DiBLI?=
 =?us-ascii?Q?PDLMSJFvhkC5kcMn+NcGDzNiFcqFokqMFHWCegRwoKYZXoZTrtNIIYNxMD45?=
 =?us-ascii?Q?x6x9R+BZkhFYBydHpCv15dBQ9T/2nA0uNmP4nd4kMKYWW/uZyoEnRR+7hMkO?=
 =?us-ascii?Q?O8VGAHCI+YYne/M2Q27ovkP+k6xVBH9boAjNRZjF0IBMey6dISEDeG53RlLP?=
 =?us-ascii?Q?qCl6EhTu8pucMh8/YlZM0U+2DGbLSb8czzdub10EzRKrs6i3swRCwNvcrSt6?=
 =?us-ascii?Q?/Vwts5msd86JE1lBXADgWiS/6e4nt8I7LBQVOruXxOTh6yqOAxsvTa6dmZnQ?=
 =?us-ascii?Q?kIvwVb/wtcfMP02yv0OzHSCbpWnP46wHmLKvwYdStcTfl8cWrYt4dsiybJvD?=
 =?us-ascii?Q?MMU5N/86gq6jOeDDBAQJtegpwOgkzTVwv+76K3mkieeu/+mBlVHgz3UJ4Djs?=
 =?us-ascii?Q?IR99UQVO/bi0XLaHZO9uWDmeimwK0llyChWpTGF/Yyo0+bkLxcqVpCp60DI6?=
 =?us-ascii?Q?XFE4y3lbC9cLNd1ddiRqtaD26TcX/R3kgCrVYd1tl/t9bjqzM3+54bUKxG8a?=
 =?us-ascii?Q?E9WzJ5ym05Vq12kbsVfG+E7dY8No3YEQ3xM9k07wuOG3IfNEFgg8IJVlIWZ+?=
 =?us-ascii?Q?erdQ/mCrs+uydlOt4ZU3QdWekAOY542DCNNcbZ1xjki/i8K5zV90WkCeD4td?=
 =?us-ascii?Q?/8pYEaUdD9qVZfWvp7ohg1tdolRZ2jW0irrrx2i5RUoZIe3aKteYlqair64W?=
 =?us-ascii?Q?gTSAcIkSM6/MWzjHE3jIH7DXy/+1MVLlNqeiL6dqvL2FuvTM2n0tvMYXSbiK?=
 =?us-ascii?Q?XtCjOH56jXlyz6GFVfOlxJCPy6ZfDSz9yvT3hWixa0Ye0ZYB1+MEigBUo//l?=
 =?us-ascii?Q?Jf1EDO3pxxOfESlem/I87zKN1EvoaofibUY1ydfAjy5D09MTWXFQS/riOm+/?=
 =?us-ascii?Q?VWmzsfbXr3a9RXy45l1weQrrjMI01vBDmVoX67yvg8V6uM8cNwA7U4/cWEbE?=
 =?us-ascii?Q?QVxgDrXkQJ/oaA0EdyUvA7y+EulF3UkJ11U+I8GepG0ssfVpGXFqVDws8HzU?=
 =?us-ascii?Q?eS5S6iiI6h9Q/mb3qJVJUcuSyJ1B+jIJUeDOrqoQX/rfFVKxIsRLLGEkFq8/?=
 =?us-ascii?Q?upNqX/RGhA2n3t3n01/OAmEn6KpjwfYvlAl+DSnw1urqRish3mzE+PGRWrrJ?=
 =?us-ascii?Q?f9I41oO5C24Z1AOYvKZezhCW7KNB6OETjF2Up0GlOKJrgTrljsh4zI7Me6Lb?=
 =?us-ascii?Q?zYuuH2IABLwxUwUVR0/z0PD4Jy0h+5fgJ4Inilub9v8EPXKeDP7Bc8u/C6XN?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef35c7b-70b0-42dc-e8bb-08dbf69b11a6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 20:36:48.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4P/W1RNURa2tvDfwNgBiJBo0da0PaRNI+QYEBtWeTFwbExXNUnzzhAo5YAdYk8xxKMroY6F8p7JUkvavM/TCpGio80sKIlX6T729ocu9BEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7159
X-Proofpoint-ORIG-GUID: yuVhI8r6V-Dmfgo41fn8J5dvTT2LSnZ0
X-Proofpoint-GUID: yuVhI8r6V-Dmfgo41fn8J5dvTT2LSnZ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=991
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312060141

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Currently, it is possible to create duplicated /proc/crypto entries for the
same algorithm with the following test program:
"""
  #include <sys/socket.h>
  #include <linux/if_alg.h>

  int main(void)
  {
          struct sockaddr_alg sa = {
                  .salg_family = AF_ALG,
                  .salg_type = "skcipher",
                  .salg_name = "xts(ecb(aes-generic))extra-bytes",
          };
          int tfmfd;

          tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
          bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));
  }
"""

When the alg name contains extra bogus characters after a valid template,
the bind() call fails, but a duplicated entry is still registered (in this
case xts(ecb(aes-generic))).

To fix this, add a check in cryptomgr_schedule_probe() for trailing
characters after a valid template.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 crypto/algboss.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 0de1e6697949..8e8039b845a3 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -131,8 +131,12 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 		if (i >= CRYPTO_MAX_ATTRS)
 			goto err_free_param;
 
-		if (*p == ')')
+		if (*p == ')') {
+			if (*++p)
+				goto err_free_param;
+
 			break;
+		}
 
 		if (*p != ',')
 			goto err_free_param;
-- 
2.34.1

