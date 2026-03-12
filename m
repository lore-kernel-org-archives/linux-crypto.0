Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012040.outbound.protection.outlook.com [40.93.195.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572881F4180;
	Thu, 12 Mar 2026 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331908; cv=fail; b=hHAmzz4N6aQHwXUmFzMFG/qj353isYLO/ClQDJBERRLVsrYo8+J5O/DTEYEbUxE+31/y9a/FWDCMQLG5csSIRgbxBugECOTAap84MwOBMqmvA8ImMf/qB2M5t12Of7OMb91t2x6W0gM0QUvyhK+MBDUGLG/TsYZjMeDFjeNJ8Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331908; c=relaxed/simple;
	bh=DsiOYo5SWuJKS85jiVhlBgs2JyNjLQyUdIuG7U1mTpw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rdSZM0ieQfYbQmzHFX0RZQfb+0TYGefNLGyEiESYDa49KKNB6Jyqi52CsuaJ4orvsCv/4E6Eh1BYqzyRz3IXmE1No/q5flj0FKqZYVuS5XKPDo1BW5IKu2t1NqH6u7Bxav7JUmsf31iOVejkafFhr25/eKeoHC+B6cObw307HBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l2gYrfQM; arc=fail smtp.client-ip=40.93.195.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l2gYrfQM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uj+sq9jmmUxMUmphadSwBQ8dcQx0788oe88iNrlBTFU8CmR8FTOEAcS9m0fnQDTUnPstuAnV55c4clAZzA62yeRDZswSf3fVtNurSoO9270OXyml73YjACzwp9KiYvq+M6S+KA93OS9vV5dLItcppyELfIjghEoGJjRixk7GqcLvaSiCAPZDv/H65MhR5q+Cb4LdmrpmOnCsRPYuxizHE6QuLPnZUaRpsBxbbJWKLg9E6kkNoJHkpXq4z+hwvgESLrUiPLigQef4RIMOP5UnXrItihW1wHSTG8Q763KqdTry1QjsA+XHNhY361TOg5G1zruadWyO5FCfPUhNGJwP0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+WHgxfpdyiGZ1TiDFxSSmW2rkJXGxiAoJpRjRXPnh0=;
 b=O/JVRWhMb7KkmH9rN+vOiqFzdZPvt2LYRWTk5wMVYM/22j9Oa9kUin0ZYVtlOKYvKsnHMDjGynNv1FaU7ow2espgxdgPpc+FZEF0CB8T37oYiz2ZhZQomgOapu+rkxVlNoMzYpltwhqZrlXlGWqhlR++aHj8eKW6TVYisw1G+Gq/MRA2nGz64Z7yTXTEXyO9lUG3CyGZw5qrflOcvVJOo4ovQqr0atydv24YndX4N69RB0d27gNf32PYjs+4NY62bYxx1uIXHSzEdcd5Qscad3bpbZY9L0lypydsQx/SzljkN5lSWsHibCgAQH8uqtG7TOAcaV1OuwJOXkwV1raW2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+WHgxfpdyiGZ1TiDFxSSmW2rkJXGxiAoJpRjRXPnh0=;
 b=l2gYrfQM6Z2/gXIIxD32qM4Usxv0UNpYnpfRzfc+GXSfEbKvy8G9YIsbpQq+risq9LTxo7Ao0Gc93eWg3MUT8fLLfuqS/eZ9NXb1WPu9/wigS0CAxjs0h82MXFy0NuUECbMfpkNy9uJPlwNO+ca3ATpMphYCqX7pL0+BgX7zmHYPYQI/1S6tOHMvbfHmiNDTsMrQyNmCVkqGGxzQDE6hcFRqhScYrgKn9KcbILD+JlFY2fClhQvlCedCYH9mmghcOnQWDFVwxfsF3js6NeZk++E6y4QIBx+uwkqXuOULxLgUgjPjclu4gL3TXN7Us429dsVnkOqIeJIqAly+7IWqJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by PH7PR12MB6466.namprd12.prod.outlook.com (2603:10b6:510:1f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Thu, 12 Mar
 2026 16:11:35 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9723.000; Thu, 12 Mar 2026
 16:11:35 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Yury Norov <yury.norov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2] lib: crypto: fix comments for count_leading_zeros()
Date: Thu, 12 Mar 2026 12:11:32 -0400
Message-ID: <20260312161133.249374-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:408:141::7) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|PH7PR12MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: a64bee54-0244-495e-1d57-08de805208ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	al2XZugcU0XAwGSa4ZSJ3nTdggz7+8B5dOeAS+Cwdzq2Aec0JnnKXekskPJchSKsUXVYJr63+aMy2JRea/iMBROgHNK4LoxVw84uRybyJAxesIlAa28LpeMShOZ59dc8x32bQstOqOpzXeQRgoJ0kkP8/EFxlozCHDktS8/ccmNPc9gnltFYWi9JXAo9ubCnvLImPUIDJupo2saWM4mFjwTNNponlpfWkwCzSxUH9vuwPP4Xv7UIAvULEQZnwb2pKoAfbud9gscNDQQHEvEpAhoR99sRpmvKp1XzjB4ckqhQPJf4wFaX7ZFJnvg1F7R5FniiVHFT946Xq6958iSLk2+4uljAtyuKw4y7rVGXs2t37g89pmrU+YouR4Hw7kIm4+V3XkmXuS2OliSr+jLnbql8At6SSCxAGvj+70Xkg8bsQQSTjXTJE8leU3bg1UQNvb31UZHQMZ6XgGYPPxJNde3rgLzIIV+b2VjBfHVEg8VtRo5gT4jNxQCGOrcfu40Mxx0jEjIk1y69vfSGMsNAYPqsK8tx3EhFjS1oFLPA7Ij6WchMM+5wkqfBw2U9mhDxjo+Ywx7fDDZPTsxsAadd4/6R086wktHbrR47oi6scKsBx9I7vPxV6/+yfZq1xTs2P+VEzp3WQpOx6/ciog6GieF4/2BfmweMvE7kYwWmjgPX0AIZ4/NKWq+I5G8etZM0LF/PwEj+IrHnhY6Ys4PTNEQZpdGBgcNwyrqXar6RRtwpQxLpT/2bCjKKbOj1YEuW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LojlCyGW6dQp8P9y3ZqoKjLSKATpjmbpP3w0epUpHmkcdp9Ty3Jmi/2ud2cW?=
 =?us-ascii?Q?adXT/ILN/k1LltxpJ0d68OdTz1JzojgEerFjVeKrf/21j47vhFQiQwcrV9JR?=
 =?us-ascii?Q?r/bL+syWUSBlfwmmPWxP0kAw7lDlDrNOwx43PMLYkeuyv8wIMX5gcvGkJn9R?=
 =?us-ascii?Q?mDn9JxjlJGk48y/HLgOV5hgOgdWh8b99qR+rfZstAPchcb48cCaBSRo5QnKr?=
 =?us-ascii?Q?6R4biKn2cB8kFRm9GBpIPCF4uMusdjmUMQags97WZv9Car5I8fSUxCyG62Fn?=
 =?us-ascii?Q?EOu8VVGfKfOG/wnDK02VuoS0p1bLClxyObUN0TDbWv3+XGOH5uI+3WMN5Yht?=
 =?us-ascii?Q?r5GoZZ27pC5RvM6NEzx+NxYAuHE93AxEGbYOHa7+iIvqVIpJrIdG/3d1g176?=
 =?us-ascii?Q?2QrIxQbv0wX+ynoJaSrK4zr6booIdjCpymrCPd/EN7kHWkUQSejAkKtTAyXl?=
 =?us-ascii?Q?RIXdtDHMmq+7Ej5+OgEIhbfh4TxgWZYj4UNWMcXNIegciKiWm/qvMvlSloXA?=
 =?us-ascii?Q?oDU0HzowGfLakkBvBjZyx6w7CZNY/07dOWGfP45L1bknOvn+HfweHTTFrDT1?=
 =?us-ascii?Q?7zB/eSB6cg7xOP/rnr3IZ6Z+N2AQonpuclKQQ0GrScD92rgRZftL9RLoJPPT?=
 =?us-ascii?Q?HDSN62zw8D20FzE6MCINkBf8Z6ZkGZSwGj2beRC6+PQoxMZ/2QXDyyndu+fj?=
 =?us-ascii?Q?LL0Jo4GjaheafkEpAhkjbFnBxJ5DSRZ1nVTmxFhecjaFFiawJGB/drn2s4Qt?=
 =?us-ascii?Q?4kNpc4CgKYLcj0q6RzlxV9+EYFrEcx+fxS2F2q0d2IHVHAjKL9Bse55e1dlC?=
 =?us-ascii?Q?r7YKz52dHofDcd5z4oYn4Yi8wqUcHhRcbgfI7ZXRZnRKE4sAfa4VfyozaxyU?=
 =?us-ascii?Q?YlLD0kW1uM2v0jWYcswfPKAG9DmXpPlj+tUtJRiJxPr0L4V0cgwxEILjl7ip?=
 =?us-ascii?Q?cPmX5prmXV43UPksk8t5cxgJD82FL9iVfxrfnHlMv/T/RlluZQ3n0gnNWuN/?=
 =?us-ascii?Q?u71Uq6oILy2Yhvs8V8rn3d9T/3bX8xWHiwCqTXRD+e2Q0/QbmUNqK4W6PQjT?=
 =?us-ascii?Q?o4ZglDBJMalwjH0x77oLDZXiwxdNceIrYP25WWGys5zAqS7KBkZGaCGuVvTm?=
 =?us-ascii?Q?EvmDOrqHBHu7Sn/n4QGt2amME4ntCBFicg7TtEU0msPmvKNP8lkukNu3hWlm?=
 =?us-ascii?Q?yvoq8t8aqmpNUyfN8K//XtegzgWbmfjU8Rk6VxGaN58E/frKrqERB0yQogi1?=
 =?us-ascii?Q?aVgNxCfMEpa1g1WsqqbpVz6XwWxBZFzc2b7aMemY6ohCWctqTw41+R192dlm?=
 =?us-ascii?Q?5JOqcBK+s9bfx6gsFmjmjVkJBu7A1/Iime/U45jiV5JpvW4Njg2XU8uDu+fO?=
 =?us-ascii?Q?lMrIm4+mlJJHD9HfOfO7oInpkPMb+1Ffzpjgd4DXVhGMEDDW4HXWcLDr8RpD?=
 =?us-ascii?Q?XyxZkM6uysblSIZzflXtsHn9Rbpwid7bF7xsv6dR9LaejAcYnKJf+JlJmiJt?=
 =?us-ascii?Q?zLi+ou+0/pZT/A0D18xIjxYUeJx1GAcPIbjiOYzoytbE5887NlJV6t+3moFr?=
 =?us-ascii?Q?UZcVD9ZSoYJpnOdZ7soFczRWIg1BI0mUw9k3vNFpF0hCpwXdKDguGW6Q/q1m?=
 =?us-ascii?Q?a0xd1ljFsC0KrBgH9F/Sq0BMSG+r5/E6ekvfcSMIH5+7Mp0r28SyOKkGmess?=
 =?us-ascii?Q?OUyMwqtqM3VPg9WX9qvgkh5B/Y4/CBT7dzUN6I812NBp6sQTPcaHDC3gnrNy?=
 =?us-ascii?Q?SWJLW5BwgVaRU+exK5+RrdHv0YDk4ZejW7y9wnfl4LkVvgdHPM79?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64bee54-0244-495e-1d57-08de805208ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 16:11:35.6229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AftXAx/j5CAuj21y5vGLTSzhOzRZVBh6Xqni06zqwSfeqCIfirn+U9PdP6fAsZzrZgZaxcSgrAJlIDfpJnmcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6466

count_leading_zeros() is based on fls(), which is defined for x == 0,
contrary to ffs() family. The comment in crypto/mpi erroneously states
that the function may return undef in such case.

Fix the comment together with the outdated function signature, and now
that COUNT_LEADING_ZEROS_0 is not referenced in the codebase, get rid of
it too.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
v1: https://lore.kernel.org/all/20260310211021.95362-1-ynorov@nvidia.com/
v2: cleanup trailing whitespaces, tweak comments (Andy)

 include/linux/count_zeros.h | 4 +---
 lib/crypto/mpi/longlong.h   | 8 ++++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/count_zeros.h b/include/linux/count_zeros.h
index 5b8ff5ac660d..4e5680327ece 100644
--- a/include/linux/count_zeros.h
+++ b/include/linux/count_zeros.h
@@ -18,7 +18,7 @@
  *
  * If the MSB of @x is set, the result is 0.
  * If only the LSB of @x is set, then the result is BITS_PER_LONG-1.
- * If @x is 0 then the result is COUNT_LEADING_ZEROS_0.
+ * If @x is 0 then the result is BITS_PER_LONG.
  */
 static inline int count_leading_zeros(unsigned long x)
 {
@@ -28,8 +28,6 @@ static inline int count_leading_zeros(unsigned long x)
 		return BITS_PER_LONG - fls64(x);
 }
 
-#define COUNT_LEADING_ZEROS_0 BITS_PER_LONG
-
 /**
  * count_trailing_zeros - Count the number of zeros from the LSB forwards
  * @x: The value
diff --git a/lib/crypto/mpi/longlong.h b/lib/crypto/mpi/longlong.h
index b6fa1d08fb55..a5ef41c8f85d 100644
--- a/lib/crypto/mpi/longlong.h
+++ b/lib/crypto/mpi/longlong.h
@@ -66,12 +66,12 @@
  * denominator).  Like udiv_qrnnd but the numbers are signed.  The quotient
  * is rounded towards 0.
  *
- * 5) count_leading_zeros(count, x) counts the number of zero-bits from the
+ * 5) count_leading_zeros(x) counts the number of zero-bits from the
  * msb to the first non-zero bit in the UWtype X.  This is the number of
- * steps X needs to be shifted left to set the msb.  Undefined for X == 0,
- * unless the symbol COUNT_LEADING_ZEROS_0 is defined to some value.
+ * steps X needs to be shifted left to set the msb.
+ * count_leading_zeros(0) == BITS_PER_LONG
  *
- * 6) count_trailing_zeros(count, x) like count_leading_zeros, but counts
+ * 6) count_trailing_zeros() like count_leading_zeros(), but counts
  * from the least significant end.
  *
  * 7) add_ssaaaa(high_sum, low_sum, high_addend_1, low_addend_1,
-- 
2.43.0

