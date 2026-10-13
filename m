Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023103.outbound.protection.outlook.com [40.93.196.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8694652BE3F;
	Tue, 13 Oct 2026 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913782; cv=fail; b=f0EFdLBFPEKdgwhi4C39UXpPeyPeC5vidQTUjTla6H9kleJbI4NHX4Dpa2HRWpXvArh5Lyx8b1hfXee4SjPHsjKnSy6h0aKdPu+McSrwAWMl4aOjndyML6Vg9ksxa2bBBsBx2wHRZog4MTOB48mQElZWR4IcVB23P5tHZW1rTlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913782; c=relaxed/simple;
	bh=dIGifGZSdnsmzDMSoqvoGdj4NFx2T8YjxAkh7Yj1MkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayAve0drClzf1RjmpElS1smdrhf+t788sR6zD9Bb8twtTlt9AdpkC2O9XU3IwBz0Er6HygW5RWjD4jawfAvccsZNI4Vm0R9eLTWNB/JmL02L7ofJHfgT1GM1hLG+wzWWULCNSvdgGM0FJoN2JHb/8xf3dn0B7ayOqf9FJzIMons=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=wpX2RsUv; arc=fail smtp.client-ip=40.93.196.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="wpX2RsUv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t5CU5ikk+xAUzIcY4hp/pSMGZXGlshl1TVjnTSkUsQj+FsYbfTh9nKKZGz53FEyNJAQXcqOVv08Up3IoyqbT8Zycruv5jPnkhcNCtJAzuMQZHbMMlxEy23uURgp+WXZrmcOaULLsOKN8z4cKQ80xbfcZIn/pnsREA1DM+4D/YqTo5k/NIuQLZtHekB5ugHJu8zcJJw3IonP7jPyTWSX9dNci98CqdS0UR+dnst2pQzfc2oSshE67Zni19G5gFS/37A33wqyxbaRJotms33kV9eaXwvBqbdZofOpbddiP57cj5dsAK5JtTtfNFSlL9oKmMYeq74OQBMKtjTIel7H3UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWyYUNbxbBarp1rmKTOfT5UGJpJ1iKTZ6rxD4JQ3+5w=;
 b=b0WN0LOHC8PJos0k8tY7IskuAdyi6fG7SsjLigGGqJt6JXHECnfF2EvGMdo2AbUJRo7Wz1j6T4jPY8xcrIYRjzc1FE0RQ2La1jJT2cznMO6UEa6CdfbNgfFXCYFy/cQBqH/CCpLlTJAlvKgmPzhkm4lVBTBobNPR8JmagJeZ0zvYIEwQqFdurfQcqNndSxcUi8ZGdglD1HCa062xf6y+dnCLN7zV5xGOCCEQseKOLiP6nyznA9WLnL3SIiT0Nc46CiLP/CqdS9eLXpzq+K/wGj2pTqIBEOfMtczUUeSPX8tEc1MObZJc/n90rmsb2mgJg1cFdIxP606J0zJjXjji7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWyYUNbxbBarp1rmKTOfT5UGJpJ1iKTZ6rxD4JQ3+5w=;
 b=wpX2RsUv/UNpbn62TvE234eX3O3sctNaC8CCqreBJGH2tWTlzxr4CotfoSTVjcgIStjJ6BkbW2M5S/zAELaA8HREJ0VB4/JbF5F/N+/QRpzXtwoFc0Bx05FX3PqlFQQU2H5y0PyG41YSQ80mvZkIlmqcpYMqi6sxtIucZ5mOaobdH9+X0BdBJYRLbxC13/Aw+YW3FMXF72YMYLc6yOYRA3uKUy+s0wy0xSufNvZ/KfR1UukkixeX4KhN20IFBpqNLHwV3ZaQKac+7MBFTUMYOczKeDG5ERzuINfuoesp0DZcxpsYrpg6rZVYPfnJp5QZO95+bMwY/8jOR5SPIH7QdQ==
Received: from YT4P288CA0006.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01:d4::12)
 by DM8PR04MB7893.namprd04.prod.outlook.com (2603:10b6:8:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 17:49:15 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:b01:d4:cafe::af) by YT4P288CA0006.outlook.office365.com
 (2603:10b6:b01:d4::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue,
 13 Oct 2026 17:49:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 192.86.86.210) smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 17:49:15 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 9C197180175F;
	Tue, 13 Oct 2026 17:49:14 +0000 (UTC)
From: Alex Ousherovitch <aousherovitch@rambus.com>
To: Alex Ousherovitch <aousherovitch@rambus.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: [PATCH 5/5] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
Date: Tue, 13 Oct 2026 10:48:47 -0700
Message-ID: <20261013174847.2192609-6-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013174847.2192609-1-aousherovitch@rambus.com>
References: <20261013174847.2192609-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|DM8PR04MB7893:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 09121fae-7111-4936-01bc-08df29524c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|7416014|10067099003|22082099003|261009223027099003|11063799006|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	tCJ8hWAbl9ZxfCwKJudCkihDnOfG9sH46FKHAsPLcXdXw1pzFe4zWLvpY5Vla5/eiS0KRn/ljBWGFuX5/WISrCxRwYPafttuau7w9cmlHbQKl8VjvEK6/kPewrnhS0wpMo1xOnbvJQ0s5UtKcym7g8BLEC0tr6+xegzhFb+H7Zm9/O2cBlNJaGmvPyrsVYEiPyoYK0OnY30elm1MVG7IAdrYFf7LDptesdHX+xTB56DUJXUhgQUgmL0Lv14OdVVi8TaktuldhOcPtXuEgkD24//e60ZehBkTKRNqSv5tsYpaxFOCG/E9vklE4bJPGVNcOnEfcK2kHHi00vaRwAgr24hQo3Uh9ZuFBWS9FXzn0CMGU+zLf7oRa2iM3bJDUgMqiTMHaLwL8W9EzGq/uqj3kOiXNbIXUoLOtd3uFi63c5IiuNw3N5v1b2DWhVM+Wc42wE8h9IqPK7fzZsRHiZmXJi76ziTpWldaRWAfijjgbFS4hwhVAc+cL/604l1lkcVwbw7DyEbhBYZfwgE7EhSNB0q3LNU5zOeTXQYwauD2komHeCnBuE6fWUd7ZVrZNR0/vGgKG8Jb1M5WYTkk/xiIgEoRv1vM9DoRavPI3xSYuIsSNBH4XmWYMzgG65f5ZNhnlsI72PXExrBozr9w3SlM2wHIniwhq5kkLws121+MBQ3jFbmmDfoxljm4XM6J+QJAvht1LNu+bN/39bg8e5/zXQ==
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(7416014)(10067099003)(22082099003)(261009223027099003)(11063799006)(18002099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	R7dXEtCKcqXaJa+tI/vrntJd3/W6zJYW41XNoxHH+QgH0UyMfZp6LRUyqfU7KzbSUM2RnONniiEY05fjXGMntU7ATnxA1TdUZZo7p5c53+w4S+k8o8IxbhktcF1N0y3qCzYvd67UeDkktlbzLPai6OYxIp7y0UzdfClF/72YCkk16Z05AaKRAr/LyvbIc02Y9qps/H0RiWb1D6yrDehDi9DiEff2e9COuY6z2/368m6mU4dy/7pS3RBaEMn5xcT8TwJfujKq+fy0Q7FS3t3yQT3WyXZmgD7m5KW9sN65yhZJDd2dhpfCLGKtno2YOG5Bww3ecX9dFQkeYNxwhjmc4dRwR1EAzhzoJgXuwS46omBMCzzzT154whTdaDJ+a+vAx1CF5HC54vzZIahUiDZULq9WKIa2wsxk6mi/CxAKMToghFvIOjqMV7Nh+HyyArUC
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 17:49:15.2059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09121fae-7111-4936-01bc-08df29524c48
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7893

Add MAINTAINERS entry for the Rambus CryptoManager Hub (CMH) hardware
crypto accelerator driver under drivers/crypto/cmh/.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3bcdcaa9b92..a803cd2a3c9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22760,6 +22760,19 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/ralink/
 
+RAMBUS CRYPTOMANAGER HUB (CMH) HARDWARE CRYPTO ACCELERATOR
+M:	Alex Ousherovitch <aousherovitch@rambus.com>
+M:	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
+R:	Joel Wittenauer <Joel.Wittenauer@cryptography.com>
+R:	Thi Nguyen <thin@rambus.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/debugfs-driver-cmh
+F:	Documentation/ABI/testing/sysfs-driver-cmh
+F:	Documentation/crypto/device_drivers/cmh.rst
+F:	Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
+F:	drivers/crypto/cmh/
+
 RAMDISK RAM BLOCK DEVICE DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 S:	Maintained
-- 
2.43.7

