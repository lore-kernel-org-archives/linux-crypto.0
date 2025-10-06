Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010068.outbound.protection.outlook.com [52.101.84.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C97C1B4224;
	Mon,  6 Oct 2025 07:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759735109; cv=fail; b=uSZRnX2MV1OrUFrxgX8FMZIqzshm6lmatEa6Wp2ux5gCD+KGisd0E7lraoWo08iCESuTrlGVbDEFTXVmUGrEK1xBcMjelBYVcuOIipmN9Px4doMGE+oy+EUJeX8/ON52Xguszc0XvB3Gg7lm6iXwNACyejll7S+n9dQEC5G4Lhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759735109; c=relaxed/simple;
	bh=C/jcOZQ8yPUSbmecyI60KXdRGhmuJzBBV9Xrh4bnm6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FDIiocJ9DKfMFjNlziqJlcvXef0FFvBPdschlvKIOLhJ0fnrdiQsdwt5wzy0qRY3WkdqgN5Qd56VqmPc/Wr//YQoRvWVAJrolJZqFD2BnN0v9Ks0yp1hd3uiBtomy/db6OQZ4R5DvYQ2eXeEMabT8wLA80Uz2cLSNnvX0esArGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=ZxlQmvQU; arc=fail smtp.client-ip=52.101.84.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZxlQmvQU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JXH4gb8qIrK72kSUMd2LKPxjVrIYsVz43wfGNsWgGcishu9/fkid71AIfAPIUX6+exkTT08yu7byXfmdPfMRMeAMRKFCeAt5i0ZXzeiIgy3wdgzzTtvwP37TPi7VfbbeIGCwV/qSuHpihyorLhzPb+oKtGrbnkY9CvAaJd5RP4Tz4p5vWrh2/8II2mhJl1cNa7++x0MdAMnBNTjpGdcvUIq4gG18d3Ju4NNrInhUABLuP+rL/t8LNpKmu8Wyz2uQ/JAoFry4N1wJIbMYWKtP9Kf7ZJ6A8Ne4EpK7zjww8B2vd57AYcw3Yt40KY5it0vEJONQQyhAcopFbEMWdPU0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dORGpEx8ysRSLG9nL6rvz3jgf7Vvh3bcIOvMVMrcOf0=;
 b=RpJkyd4z3TH/8hLqx9QRHhjAlFUQ2LBtlMMrAhev+kZKIYF+0quUKzfv2jqy0SbRZ+EVxNNQasUzSVFLU5h9MoRm/86yJbjxzGgklWU5x0DCUsxsQ+tqUxZ5p7bSkBjeMMNiCFAz1QrbWgb/S1m7smg5h6uugqozR6S44/DWu+5y4SkOEmXwtUy5FNRM/KcBEK4lBLBBZQXFi7VatwUd2uGYwkzzZHgWunO11/rrgwU3yZS59e7fXiAUUuC5+yHsC2cFb3c/tJpMyvQX3ctOc0Yn/3q+YLL3QzJMMKpa44aS7mJpuu8G8q1eCS3cLAYfRgdCEa9qs11Fyovtsqnl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dORGpEx8ysRSLG9nL6rvz3jgf7Vvh3bcIOvMVMrcOf0=;
 b=ZxlQmvQUo77YZimSeP+Vv3Q+N7Y+kSuDKF2PLjrITw3p5pHnz93wb3fjANBIEY961YgYoGTHGOzZe6qRGK6I5oCgjZZMKGitN0DL3MFJTfAlwpxg2SpEqHQxrlr6T/Yn3VJVBefqCNMpvRe7PQ8nLDGk3E4sOPcE1UizDWeQOQZmjkepx1N88Gk9Egs8fekT6hCL0l6J0WAjBABJSfWYVW38MGQ2mrW4fiqLG4Pzt57xO0Rqwctbm3Drrlm4dY0lkudduVmwU/Esfoa3NPd16IRGN2X+o9DhPkHh3VL3xl1+EbOBgb9OQ6aTfkcEa6QAJLcqbWhtb+SlhpgBICW2oQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by PA4PR04MB7949.eurprd04.prod.outlook.com (2603:10a6:102:cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Mon, 6 Oct
 2025 07:18:20 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 07:18:20 +0000
From: meenakshi.aggarwal@nxp.com
To: horia.geanta@nxp.com,
	V.sethi@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: [PATCH 1/3] Doc: trusted-keys as protected keys
Date: Mon,  6 Oct 2025 09:17:51 +0200
Message-Id: <20251006071753.3073538-2-meenakshi.aggarwal@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
References: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::13) To PAXPR04MB8301.eurprd04.prod.outlook.com
 (2603:10a6:102:1c5::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8301:EE_|PA4PR04MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: d6b79e2d-2a9e-4c4d-aa3e-08de04a88765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z60BUy9sdTA5iaG6V/9d6PEyZ7Ebfo0thaJQswX1D33kbOlPV6cNpQFPbYHn?=
 =?us-ascii?Q?PwT8Mztda16nF+dupR+T4II2KfveFRLZZBuvJnw9Azyuginkt6TxO3SaXORC?=
 =?us-ascii?Q?IvJZ7dAZcdhUekKp/BUIdpWa9+IIVza5rA1Lu6sD1tDWjr+/67pnts1sbAdA?=
 =?us-ascii?Q?ZJFDOrcHqLd2KT43a1WnyXFz4upbPsyF5SuIe4dY8scWxrXN+4lKTrIieCPk?=
 =?us-ascii?Q?C+/mqaFh2piT4IuawIhiX9hVW2c0xPpZOz0lMT4qNX1pSH98ZabIAusrb8jE?=
 =?us-ascii?Q?K+ZQrLOPorHzTdM4fKBT76bMVbtG0uoZGp55bRS30gxlkx5IUHcnsX/FnjYi?=
 =?us-ascii?Q?77poAhNQGkN0YUwkqwQ8nBKBZ+q0ePPT1T+65UMbxgM4jVdxyEXArzxhSDE1?=
 =?us-ascii?Q?3ROHiw4I2SvHqM4Z5diOTheRGyoNkX1a7lmcztVn9qkC6SoZLaPbu/VnDMgQ?=
 =?us-ascii?Q?s7+Z8dpZM72WcsjmWIxZ+3rlpR6WiIIu8UZs/NXtcLUGVMtBbmnF298rFa4l?=
 =?us-ascii?Q?a+A7eGa1Agg1Q5Lbwi71WKOHIFCIA9eH3ZoE7yIv+PCoh4VfUSQ5UkjO4rCY?=
 =?us-ascii?Q?uKbdqs1RWfOQNFAV4F2A28e8a5EQKpbKlXkdNphxS72iLJrkxoeeP4dpl2bO?=
 =?us-ascii?Q?Qq9r/DYZHuKT4pK6a/cy19q+jZU5yEQkEi2Jbe+VCNChi6yu6FFVxo3ILR11?=
 =?us-ascii?Q?P2binebufT+2qzHLQmv9XpDHewwHBbFQ7EcLA++1NzGZ5vuwUvRRAEecBIty?=
 =?us-ascii?Q?PcwQlFWZKZTvVmEngdWvgXBdFQHMaXzH5Qrq5p9QEVV3qGQb6z5MiY23SpWO?=
 =?us-ascii?Q?j0n5Vrdr3a/UXpXT3scoOg+okBID2n7AEcICZVyJ6PZr1UHOZasr3x6SQFBg?=
 =?us-ascii?Q?nwgkhKzPlsKW1HYqyyZXYqobPQQSz5zLtE8uwWZTQ1yZNMUNUunSf5xEkT+b?=
 =?us-ascii?Q?47qSi96HGbrCJAZ9D2Nk/nOXSQ6lFD4XG2Q9/h3NTOAvIYSUGAc5vuUY72zD?=
 =?us-ascii?Q?nqz9uxqpfSyH5D0poxXOiKLhh5I7RRV263aqjJ/eIbQl5J421yjp5JiRId/c?=
 =?us-ascii?Q?bt1GiNueeT8v1wRtDRFMdTTUAuu/eWUjJWvEnJrPi5k2rdsECnzSWrV9uRrM?=
 =?us-ascii?Q?VCc3d6Vhl7M9H/xvBZgMJuAi2D6YrRaWGrHNsuy/tRiuL8vEtxdFp2J5rDPQ?=
 =?us-ascii?Q?AarE0NWJE2Ozu4DNMECma4kdfyJFd+20d/Cckdm6UwQR/1hRSS0PpBbqwd0R?=
 =?us-ascii?Q?zQf3Gp+mHh7Mh4mPY0NYHu/Sn8XA4SB/sL1bxzCN4ju2tq2goLPgvd7nG9yK?=
 =?us-ascii?Q?r3f9mnDuwYbW+8n/0RcbNGwWYX56XNdesvFuBI9TXUtiGUuzXANqzrncXVYi?=
 =?us-ascii?Q?DazkTzuC8O8vFIdkOh6iQy7mQCMl0EjFAGS/HIdSwo/4dC1T1bmk8RAo2nks?=
 =?us-ascii?Q?oaiwkeTNFF347JgXhdQ04sn5n3g1afHQoWc5CqyPwnrXuWUX0jxeo+JAaZfi?=
 =?us-ascii?Q?f3ViCoRJlXS7oJcqwfB15IyvkCCfhSA5snYG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g72lNrQPemB8/FFglRfKROei1LMOemeQRA6odXy5oA4+ae5XkJ0T830GEGs8?=
 =?us-ascii?Q?F2BWCixQ9kjC5XpruWSZeV8GPirdVGZhpzLhNZ9/koLnYbfNYzxGLrFiePI6?=
 =?us-ascii?Q?35QdtYYUyIPJ3MaeaZJrKPPmhLEORmjRsEs3b4MnwodDwvzfQX0+CH2CVMvC?=
 =?us-ascii?Q?amOUzIk4Kn63mupVtzM/qjgh36XpK9Dol60wEJTqnPFyckglY3i3X5pk4Vsq?=
 =?us-ascii?Q?w/EQHt8/2TGlqKUxKLVxJUKfqZSBpP1n4DbPkN3n3WaftmXwlWENc2idjA/x?=
 =?us-ascii?Q?rxDxN5p17ESycQbEjTS+4l/rQJrB8yQDjV2r1dDv7S3FQxK4aekE1tmNcSrC?=
 =?us-ascii?Q?39ONsozEcedHWOaXqf3f0QsyxMSVUJ7JJST8jyR+ZFVKQi9BqvxcAkD1gUex?=
 =?us-ascii?Q?fyBssWnNQLHn5qSeMYi/woEi2XYUqxo85NoJIXnpBQFh0PmF9BE+Xurr2wRM?=
 =?us-ascii?Q?Aj6pOzpRnpCmKtxADnI51b4j2A5ODBf6a0x+qQ6jYkAD89hFo8+49Y/aZQ8x?=
 =?us-ascii?Q?+AiIR03nIsUI/JTdelPzhfnrV2EYnyxUhLvPGjnqksEK/5xof53SUb+KeHmI?=
 =?us-ascii?Q?0xqLAjaWiz1w1S2Oi7kLdaL4aS3RgfcofEhhxU6cRSgi/calPVFhzSoPpxBT?=
 =?us-ascii?Q?KYNTg4Zen8aYwU5x11AJPihvVEwkKjWKl0JztpzOLTCMZa6cZBFJNlmMbuGg?=
 =?us-ascii?Q?gZMy9CGOJEXgQ6S8zCpBceEmL/iL/LhwO32wCwS0m+acHDkVGilXi173zJuI?=
 =?us-ascii?Q?xwycb2cNfh1SMEgdtvJ4+ElPwNA+g8HgX9OkP6ssJOxodQ3xNDbqygqWFyZU?=
 =?us-ascii?Q?3+CeiFrRg3kGP9FBiJ0biTngh8x1KFxpCMhIBsEkT8HXxveyf62NotCC9p4l?=
 =?us-ascii?Q?tW8yschoeLzeS5IeTvYvwTtI7Ls7VMzhXXfd6TNFm4WWqqN8B25Yr9Y443D/?=
 =?us-ascii?Q?AvR0gJcFjbxzbWpt6WhPppO1hGr5GI76Un0Axzl7W0dbJqBSAj2qmfjqcLdM?=
 =?us-ascii?Q?tkED09DkQ6vrOCWlR5PY+CCBd0E0JSi7C91nYzSanhsGC3y8TKUZzmLzzV2n?=
 =?us-ascii?Q?GQHuWsAUmFT0WCzR09ZZZD/Q4lOfJy3O07dhwDLygtszPyBMozr492SRJShl?=
 =?us-ascii?Q?AbXU5PPt7ryAu1qpCzfeG8racJs5dj/Cal+22whto+B6+lt9fXfTxnWr9grx?=
 =?us-ascii?Q?g0cFssQTpjvr2gTbUPnEUumzOwRMDeAoVh0RbAiAbUsZJM+F3rZ01xV6YJij?=
 =?us-ascii?Q?szMewdxStSwcS20vEbY5LaGx6Le0VeXicfxAk1/FM9aXvJK1LQt0dY0r1dJO?=
 =?us-ascii?Q?aCHO7y3Aq4SwL0RPeXLE8JuvTHiNGb2mmp6KqLO5kuMCbwYLYCS9jJrT1Q49?=
 =?us-ascii?Q?SYd2xs/XHMgW4Ygv3mqmgxpQW/h1Z+vpVea5ZtLWo+5g03pEas7eWbTcH0KK?=
 =?us-ascii?Q?0vI0xzYp+jDvou7Yut2fG6l4YdUJZV3gXdu8XadZw/EcEovqux6IIr5EhG1Q?=
 =?us-ascii?Q?FoPjyxbE1PNzrqDA2yPAqQw5Jnf8mVvsfQnw9ALplThpYRhOKl3rb27QuZGc?=
 =?us-ascii?Q?+Y8x8kEdcjsOO9fbCSHUEPe+JUVktyWXVTdnljdOlVyFLc2skG/8oOSrCVbB?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b79e2d-2a9e-4c4d-aa3e-08de04a88765
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 07:18:20.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mm26SRpvauZqnzY964HOcwtqQTvnwyMrlleWntW4MGfrfhVZ43iu9G1Ma1z3yqL4QdSsn7T6XfSiXBeD2m6OjCO2OVhU188/cs9zI2iAWgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7949

From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>

Add a section in trusted key document describing the protected-keys.
- Detailing need for protected keys.
- Detailing the usage for protected keys.

Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
---
 .../security/keys/trusted-encrypted.rst       | 87 ++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/Documentation/security/keys/trusted-encrypted.rst b/Documentation/security/keys/trusted-encrypted.rst
index f4d7e162d5e4..2bcaaa7d119b 100644
--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -10,6 +10,36 @@ of a Trust Source for greater security, while Encrypted Keys can be used on any
 system. All user level blobs, are displayed and loaded in hex ASCII for
 convenience, and are integrity verified.
 
+Trusted Keys as Protected key
+=============================
+It is the secure way of keeping the keys in the kernel key-ring as Trusted-Key,
+such that:
+- Key-blob, an encrypted key-data, created to be stored, loaded and seen by
+            userspace.
+- Key-data, the plain-key text in the system memory, to be used by
+            kernel space only.
+
+Though key-data is not accessible to the user-space in plain-text, but it is in
+plain-text in system memory, when used in kernel space. Even though kernel-space
+attracts small surface attack, but with compromised kernel or side-channel
+attack accessing the system memory can lead to a chance of the key getting
+compromised/leaked.
+
+In order to protect the key in kernel space, the concept of "protected-keys" is
+introduced which will act as an added layer of protection. The key-data of the
+protected keys is encrypted with Key-Encryption-Key(KEK), and decrypted inside
+the trust source boundary. The plain-key text never available out-side in the
+system memory. Thus, any crypto operation that is to be executed using the
+protected key, can only be done by the trust source, which generated the
+key blob.
+
+Hence, if the protected-key is leaked or compromised, it is of no use to the
+hacker.
+
+Trusted keys as protected keys, with trust source having the capability of
+generating:
+
+- Key-Blob, to be loaded, stored and seen by user-space.
 
 Trust Source
 ============
@@ -252,7 +282,7 @@ in bytes. Trusted Keys can be 32 - 128 bytes (256 - 1024 bits).
 Trusted Keys usage: CAAM
 ------------------------
 
-Usage::
+Trusted Keys Usage::
 
     keyctl add trusted name "new keylen" ring
     keyctl add trusted name "load hex_blob" ring
@@ -262,6 +292,21 @@ Usage::
 CAAM-specific format.  The key length for new keys is always in bytes.
 Trusted Keys can be 32 - 128 bytes (256 - 1024 bits).
 
+Trusted Keys as Protected Keys Usage::
+
+    keyctl add trusted name "new keylen pk [options]" ring
+    keyctl add trusted name "load hex_blob [options]" ring
+    keyctl print keyid
+
+    where, 'pk' is used to direct trust source to generate protected key.
+
+    options:
+       key_enc_algo =      For CAAM, supported enc algo are ECB(2), CCM(1).
+
+"keyctl print" returns an ASCII hex copy of the sealed key, which is in a
+CAAM-specific format.  The key length for new keys is always in bytes.
+Trusted Keys can be 32 - 128 bytes (256 - 1024 bits).
+
 Trusted Keys usage: DCP
 -----------------------
 
@@ -343,6 +388,46 @@ Load a trusted key from the saved blob::
     f1f8fff03ad0acb083725535636addb08d73dedb9832da198081e5deae84bfaf0409c22b
     e4a8aea2b607ec96931e6f4d4fe563ba
 
+Create and save a trusted key as protected key named "kmk" of length 32 bytes.
+
+::
+
+    $ keyctl add trusted kmk "new 32 pk key_enc_algo=1" @u
+    440502848
+
+    $ keyctl show
+    Session Keyring
+           -3 --alswrv    500   500  keyring: _ses
+     97833714 --alswrv    500    -1   \_ keyring: _uid.500
+    440502848 --alswrv    500   500       \_ trusted: kmk
+
+    $ keyctl print 440502848
+    0101000000000000000001005d01b7e3f4a6be5709930f3b70a743cbb42e0cc95e18e915
+    3f60da455bbf1144ad12e4f92b452f966929f6105fd29ca28e4d4d5a031d068478bacb0b
+    27351119f822911b0a11ba3d3498ba6a32e50dac7f32894dd890eb9ad578e4e292c83722
+    a52e56a097e6a68b3f56f7a52ece0cdccba1eb62cad7d817f6dc58898b3ac15f36026fec
+    d568bd4a706cb60bb37be6d8f1240661199d640b66fb0fe3b079f97f450b9ef9c22c6d5d
+    dd379f0facd1cd020281dfa3c70ba21a3fa6fc2471dc6d13ecf8298b946f65345faa5ef0
+    f1f8fff03ad0acb083725535636addb08d73dedb9832da198081e5deae84bfaf0409c22b
+    e4a8aea2b607ec96931e6f4d4fe563ba
+
+    $ keyctl pipe 440502848 > kmk.blob
+
+Load a trusted key from the saved blob::
+
+    $ keyctl add trusted kmk "load `cat kmk.blob` key_enc_algo=1" @u
+    268728824
+
+    $ keyctl print 268728824
+    0101000000000000000001005d01b7e3f4a6be5709930f3b70a743cbb42e0cc95e18e915
+    3f60da455bbf1144ad12e4f92b452f966929f6105fd29ca28e4d4d5a031d068478bacb0b
+    27351119f822911b0a11ba3d3498ba6a32e50dac7f32894dd890eb9ad578e4e292c83722
+    a52e56a097e6a68b3f56f7a52ece0cdccba1eb62cad7d817f6dc58898b3ac15f36026fec
+    d568bd4a706cb60bb37be6d8f1240661199d640b66fb0fe3b079f97f450b9ef9c22c6d5d
+    dd379f0facd1cd020281dfa3c70ba21a3fa6fc2471dc6d13ecf8298b946f65345faa5ef0
+    f1f8fff03ad0acb083725535636addb08d73dedb9832da198081e5deae84bfaf0409c22b
+    e4a8aea2b607ec96931e6f4d4fe563ba
+
 Reseal (TPM specific) a trusted key under new PCR values::
 
     $ keyctl update 268728824 "update pcrinfo=`cat pcr.blob`"
-- 
2.25.1

