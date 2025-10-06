Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012034.outbound.protection.outlook.com [52.101.66.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ED81339A4;
	Mon,  6 Oct 2025 07:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759735107; cv=fail; b=udXZbh0eKsW4HZUxZ6rPZT83eAx/81FsxWcFczD4gkiuUBCx7/G6Ah5GPsCm9ZenfNVl6beb7LHwl7OOCoDEPLngGHRKXs7+wnervpSFuRd3BytDWplYvTv4cbakcVETdevJtTqRsNlmhRL1GoqXbsYU5o/6u32G9zLrvHq8QC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759735107; c=relaxed/simple;
	bh=0Rh+zOwGfJ8LRjOWQL8Y5eFlwCg3ejdhA1lzDG+bft4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=bKaHiXhOWSKF/lAXPYdvJ30moGRv2QDu2twIiM1u+6qoTq3YjDIjbcqu3MFbOI8/U3D0JqNaNfZPLovvQTR9O3OrcZFQ3olAkB7qF+GYI6FUqqrWbWzOtZx+kvTClhvTdAoxJrCXseQZ0pq6oA4DwzgfIAZbYuGFEYecX6L0LeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=b8XdW9hX; arc=fail smtp.client-ip=52.101.66.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="b8XdW9hX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8ZaJNQgWopvnPUFCL+qqhhZ/aPaHa/8ctOxVm8nU/722NQzNbwLfRYftqAhbxGqrqGqPsuozn01b9/t5JL6vzhP9FLuXObNVHBvag9hv8s/ZJlwf3vlsCrBaRz1rU9YpGoPaFTwj9LAvGC2BQS5cQXnGh9lk1ZCBFG2PZcjxFnM6JUcVVD6NyZx4Bi7v3DgPqvwTisDxM6Zaszstf3lSlaXtH5YLsTgng8n+/W3LE7fiAP2XIH8lngz1AcYqdXbojDFGrKWtzuBU3OXDkr5uU15i7t0udsRCT7iZjXukzAid5e6kqLtqGFTCdbqFN6rj1jTHQoMIlV14TpOPgd/Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPvvgzU7pDgmMDzHNy8CN3mQgBkzvXw9s+heLyCpNbY=;
 b=g48Jb5GB/pOaEPiBtSB4Xu7h1xXW3cCgx5ZMaBc897LRnqYjVIJRq9GlBUm2aWoYaAvVB3VKZO5OLeu3bFuZMz5E7IgG7er0WgbSPsmsosgH+r66zKKRAk/VOTXjKy2NlbS2RsCfKTLnvx3k+BPODRFr2q6iDpQlA4j7lRAYLHc+S19Hw2fd4/9CKgobS5kXTjQ/kvHPoWtd4J44wGPdNnjkZABVmsdln+ipKBTFXA8PuRdmQtwVbNf0qtDGUa+ro5d6uQi+mFyxcKqCvRzNbqWZ7hakvFZODFLVetSUxrJBL+DnaV1ZuNV+SRDieeGrxFPRuSMzVp1s4leeMscvLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPvvgzU7pDgmMDzHNy8CN3mQgBkzvXw9s+heLyCpNbY=;
 b=b8XdW9hXI9iT1PYh0+yNhUKFVSf+MNJInps8lHuVSjwXX5LySCmIQjlG9NbUjXb/AI17E13ntQnUWKuFjyjuj6n+A7iWrEwH+jxxA8ZG1Iaxo+cqzAUZxFSNk4DSX+3FD1u51kFN2gw0pG5W6flb/pwpCKCNGzs3yQdBYE8HvVQFbajbwlF0UAZPI7i25mT/uF0EdeCCUdapQDByoGg7bgsXx499d+vjzOTNgtNrvPIeyux8c+pbn7CPizi/YewTRyH1xItvO+n2QsqHUkvUBYMCNobU9/Jjv51M2fCQVQUpCBRAZLxGdHmyrzNjuWFy/E8VBCTz9n7SZ70LfQt1Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by DU4PR04MB10864.eurprd04.prod.outlook.com (2603:10a6:10:589::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 07:18:17 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 07:18:17 +0000
From: meenakshi.aggarwal@nxp.com
To: horia.geanta@nxp.com,
	V.sethi@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: [PATCH 0/3] trusted-keys: Add support for protected keys using CAAM
Date: Mon,  6 Oct 2025 09:17:50 +0200
Message-Id: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: PAXPR04MB8301:EE_|DU4PR04MB10864:EE_
X-MS-Office365-Filtering-Correlation-Id: b78be47e-9c7f-44f8-2223-08de04a88522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gwmw4k6cNEmAyBo9H18v/SHhNVSdRJhq3RKRGjFtnC5wGpWFqzeZAAiZlAkg?=
 =?us-ascii?Q?96MiNoeAYr27/WxC4gZEm9J9iyHt+tmBqBljQNIihxeafVP19H35mgIBeKUg?=
 =?us-ascii?Q?QryRSregtaltHdNzAPM7exa2UGLxzLaOinlel3oOzgBLkttQVmdscOfVJKba?=
 =?us-ascii?Q?YE57Q4lOpZc5G2Y7vOcswMiIondklQuX63ONztJJJut9EVZNMspDKV4KHxwT?=
 =?us-ascii?Q?yqBoAl+kOf+sYrQfDo+WW/gRwGknDGaXBV0rtM6+gwNy7PlKYr1gqpOTsn/B?=
 =?us-ascii?Q?DRvUKH/632PS0bEM8qtm26Tri3UfzYvoGaQUtq482KCycAjdSyrltptM6TU5?=
 =?us-ascii?Q?yMInLcGHAb/YqoZC0TmYHY37nVxUjVBx7/tT774lyzYG0cukjfQRnXCyzOZp?=
 =?us-ascii?Q?F7fOJAcTTspZy8i67BPhfoM6wrliXphC0haH/HAlNnPC1gataNnkIuGYA1x9?=
 =?us-ascii?Q?yNRHh+jutkuLuNGrmTMfMjhEdONJ6zDd23rl1mh/qeHZARnGm3hMIknbr9FR?=
 =?us-ascii?Q?sVx3ew5Wbf5G30vk38tApmvB/ICjW0Rb6U8f6afYbXXtg25Fr2D16K3nF4D1?=
 =?us-ascii?Q?H8nr3sC0DaY4uzAvbb4ltGL1GMiOpoebxdyvhSZpEnYNyxCJKD+QKpD9mlEl?=
 =?us-ascii?Q?Z7DgDkQDhJXZZ4+M0j/X01jV6W86XMG7UZopn26TpKnmIBq3jmaS8vehu/+d?=
 =?us-ascii?Q?24myq//qFjaoYQHIt34cYhMLGJYt/XAl6KBxnTteroi/oxvUYvqXj9EZI+tk?=
 =?us-ascii?Q?5ixdIkxudOXvKPkndp2JxFW0yMfZRbley3WwY+V6AhIFlt0CSNSAf9irrFAT?=
 =?us-ascii?Q?MsAsw5iNIF1JUVY+x2jVOV6eainuD1XVb7uGxMEISxj0ErUru/axRWsdBmtI?=
 =?us-ascii?Q?PiaHw/d1IObmr4nVuQ6j2djJDbDcxb8QTuBm+epJXXERVQKvv6kQDeumoOdd?=
 =?us-ascii?Q?Nlpz4NfDMSXZtjK6iAlzIsROp+tfA3oNXUWcVAPuLU4X+B9RaK7/G1z9QMP9?=
 =?us-ascii?Q?z9TSeOhuYwvRUUDi7aTgSnhgqGUe07phfyIRr+vk9eV21KNjTpM6Dfe6fmn/?=
 =?us-ascii?Q?ReRM1N4jZksT+KyYPQMMXf9EEJ8sxsfhrwJ5Yflx+6T0BaNemUb8htdQJufj?=
 =?us-ascii?Q?KgyrWfgrvjiGxN1cCQdJWTs+kXBl3uNfYkzTalXHdruopVdIEfVVkRM5y/Lv?=
 =?us-ascii?Q?YRprrKyAUv0W+TGMDDHz+tRY1Gfwzhna2n/V2Z4mFfim0G9ebDBN5XDMmGvx?=
 =?us-ascii?Q?bX1HY7z702jsU0ldqkZ97jiO0jVyhn/WkgXofA1OlPQyIMRrApOtCsly9wmh?=
 =?us-ascii?Q?tIjGv+MfDFCNVhlZETcKuDEvzyZ6KAqbgBxtYBLUxQNqZ7N57dAJymACTiQ1?=
 =?us-ascii?Q?cSHYgvGU92tg8907zyYWg365Rdy2dGwdI/ADjyi9Xv/iaN6E9dS1RERhnH+a?=
 =?us-ascii?Q?nSEtToGbb3bI8yNinRREgTykz6J2auOPhHsP5zeyRCMGPBK83drsGHSLlePg?=
 =?us-ascii?Q?742XqGQ8XTZ0qG6PnzdSoRuq+SybRo6aTJLg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dlX8tmcNmnYYXatZxd0443FnypD/mz2QYRjmw2LnbcTwm0hxYeLqndJBhuVA?=
 =?us-ascii?Q?qNNMJoSjwdpWoU73VEmwEm5CjjdOOaJZI1e1PJR2UptKUcjWAfBjoP4xgerW?=
 =?us-ascii?Q?Ed/hdfjYXK+5Qu+0dleVzdKRDTqfX3hQ//qvzCly40Pjj3g4WN9JxTuLUOCZ?=
 =?us-ascii?Q?nWIv/0yFyb4jORvvMDNyfQBIPebhED/8priKBh2e7r1TArTeFvVzq/DFUFwg?=
 =?us-ascii?Q?MlbbEIs5nuM5WG2RdGBJb3JypA+dggderb9jgJzOLZGcMEAG3m03svjxvoOZ?=
 =?us-ascii?Q?ZlFBUs1xEBpN5KqEMhg7qpXRsg09lOwwb3Sii+m2T6KvEyUCQ3vggRfOXghq?=
 =?us-ascii?Q?xPeIKl1kjtyAau1GYYw3k5FzM8ZzcFdas3IrIzHANFrRC/lY0Y5mJ1cRJMU7?=
 =?us-ascii?Q?IXRbjZA0nz7WFRSW7Isk/cLMPCvOe2x9+7uuAbHWtLjqc0KAcTVVSZ0Ww115?=
 =?us-ascii?Q?iVr0HVISGrU9pXUqSG7HJKQ5VroFin9RZ3OVZW+UNIsDFOAmj9q1qoT1Dgcx?=
 =?us-ascii?Q?R9uBpFzEkt/DkkMBE1zdzN7EE65d1u/mYRPtL+pfvRbuzS5OieMYYnSw+R17?=
 =?us-ascii?Q?JPomawl40WRCPJ3q6PdP6rLvDa5WRothc3F6yWyLJJhUpbCjgdqfpj1EgiT6?=
 =?us-ascii?Q?54yNWfoaoMAiChcGJ6geYFWkMxSlNo4bg0u3eY5BFODxpPJUvkK+AoY7wmd7?=
 =?us-ascii?Q?blvZD1ubq3VFPDdRpzTS9qcxATsf4X5Vk8jL7VA9MevgfrCysizu7znTYQG+?=
 =?us-ascii?Q?HTylyeaN4v8TVKm7NOoQ3f1HRmGb4DPKM+bXZpjAMqLfbs6FVAqtAJ2b/nxb?=
 =?us-ascii?Q?khqZC4azhlt/taVH7Zz7sqw7cM/E/QdvE65dDDLNGCZc/UqQRSZ4VLofQyOh?=
 =?us-ascii?Q?dFUS5msMH7EWGt77SP9M8uWaiRq9qJ4VOQqk8c48vdRFZpO1oC0GalKG/pf8?=
 =?us-ascii?Q?TqP1VUriIrWcaWm7UPGRtyNyZFmkML/XkxE6mxbeDXseZz71Jzlf3IGsw3Yv?=
 =?us-ascii?Q?+PAkiNoEk50r4k3NePY6iLp9JV8T2yQ4EVahAreWU7UE5RNC7swctffOQXkh?=
 =?us-ascii?Q?GGHdGtuf6fRCAqUxio+nDltzV5A/J/kO4EuuCSl//UWDNO4SBke5z2KfKhgf?=
 =?us-ascii?Q?zaQnaIvqtwK8X+pkGRrcUqPPCzd0BVWhe7QYeSHuOc3YvCo/M7ryQU3wT1pJ?=
 =?us-ascii?Q?k5K5IMB6UlD48659ZPtbcwyOuD2rWYuM6cXo/3eRFXV+PoYS0GuQjbvrQPkc?=
 =?us-ascii?Q?v+NT4eXeOtfGVKG6MR4QbFVa20gvAiOWvddiyagbGTrC+ZL/j+E2dpOhLzpY?=
 =?us-ascii?Q?yqQT6TnlE2IyvvruciFJPgZVRtbPgIN9seMn4iCXvWA/aXSJ0xQV7fPYYxOP?=
 =?us-ascii?Q?KfihtJMPRolw5Qp8lFZnBYdu7Ypd6K4A1rXwfuh0BwY3RKF31lr4IotjSPFL?=
 =?us-ascii?Q?StOnvcyRgg8VWy7QbjHSvy0rTzA0zjQpWmlY8uHlrAzSl1qVVzVkxaQP6YuL?=
 =?us-ascii?Q?ZQDPJVM8VdWM3Ix8Ui08dziBsRUlJ9dJy/uafhuMxd3K3DtQH8CibTF8e5Rl?=
 =?us-ascii?Q?mGXJR1GQawaWaNRaXP/UPuhzAV41o2mD1KL8cCwck3gNdkI0hZfbvY8CktSs?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b78be47e-9c7f-44f8-2223-08de04a88522
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 07:18:16.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAAsJ0jrT0RYhotmRnc2rT7Nv7ft7KaufDGTlNbWm6UxS+EJfxQ5ZAN+HZer7X4Mc37/wySR/RCa7IWpuZ++4toFGML4Wo3fGtulkfqA8a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10864

From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>

Overview:
This patch set adds:
- Support for creating and loading protected keys via `keyctl` interface.
- Documentation updates to describe protected key usage and options.
- CAAM-specific implementation for protected key encryption algorithms.

User can create protected/encrypted key using keyctl interface:

KEYNAME=dm_trust_key_hw
KEY="$(keyctl add trusted $KEYNAME 'new 32 pk key_enc_algo=1' @s)"
keyctl pipe $KEY >~/$KEYNAME.blob
keyctl list @s

dm-crypt can load the protected key buffer from the keyring and use it to
initialize encrypted volumes, ensuring that key material is never exposed in plaintext.

The Protected key buffer is passed to the CAAM driver via the kernel crypto API.
CAAM driver will decapsulate the protected key buffer and perform cipher operation.

Protected Keys are identified by a header structure:

struct caam_pkey_info {
	u8  is_pkey;
	u8  key_enc_algo;
	u16 plain_key_sz;
	u8 key_buf[];
};

This information is populated based on the parameters provided during key creation such as 'new 32 pk key_enc_algo=1'

Internal Workflow:
::

 +------------------------+     +-------------------------------+
 |   Seal Function        |     | paes_skcipher_setkey()        |
 | - Constructs key buffer|---->| - Parses header and key_buf[] |
 | - Adds header metadata |     | - Initializes cipher context  |
 +------------------------+     +-------------------------------+

I welcome feedback and suggestions from the community.

Thank you for your time and consideration.

Best regards,
Meenakshi Aggarwal 

Meenakshi Aggarwal (3):
  Doc: trusted-keys as protected keys
  KEYS: trusted: caam based protected key
  crypto:caam: Add support of paes algorithm

 .../security/keys/trusted-encrypted.rst       |  87 +++++++++++-
 drivers/crypto/caam/blob_gen.c                |  86 +++++++++---
 drivers/crypto/caam/caamalg.c                 | 128 ++++++++++++++++--
 drivers/crypto/caam/caamalg_desc.c            |  87 +++++++++++-
 drivers/crypto/caam/caamalg_desc.h            |  13 +-
 drivers/crypto/caam/desc.h                    |   9 +-
 drivers/crypto/caam/desc_constr.h             |   8 +-
 include/soc/fsl/caam-blob.h                   |  26 ++++
 security/keys/trusted-keys/trusted_caam.c     | 108 +++++++++++++++
 9 files changed, 518 insertions(+), 34 deletions(-)

-- 
2.25.1

