Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D64E4C54;
	Wed, 30 Sep 2026 12:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773204; cv=fail; b=Xz916idU+WWMP+uWie0t3jh/d6QWGslLJLpYz9MDRMj9Ee1cjBLj0WEv48V34AV/nWE0o9NTmQhyfIN8KqUVNhtRgsGWPUTf8jhcnDRDX5y47zadQNLXfb/RQDX9q9bhMW5o0lduCLH4kU98pJ8bwYO47ldSyIe+J94x9VFGChg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773204; c=relaxed/simple;
	bh=UWNnQQFOWMldlulocf6By0PgAP5rrXm3/StInUh/bDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwOPgHNa8GjwqaLfn9w8Q7CPuMFtCTIz3+XZTPjTnam26fdMnzw2kGwhwgr+Guik9ZwsvTEU3gN+zmiv8v2x25uh0Czm/+s/1UOUsUwHL/bo9ivWKgMUXnXSvLRrtKz98qHrE4afcN1pgKoipTNZtNaT2gsX5xa6QOv/z7AJIps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Z2f8y0Av; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=d9dm23Mh; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Z2f8y0Av";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="d9dm23Mh"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB5w5c3214062;
	Wed, 30 Sep 2026 07:59:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7
	GE=; b=Z2f8y0AvHl1WWALOhoHrNlJ6iuM5UZ7mZ7RDTxBGNHPuYCti4j+yBLive
	XdaKfUcaLhvFghan3Sj3UgzfuMIDfx98VGOH9RdK6N0v2Cz/AEHkGwfWojMsN9+I
	PYbste/oXHPzS3Cfk114VXCVjhWZkQ8K47t2wNwXBvDDrXlWAqGF/x6FcTtRjEdq
	syIDAZxgVeTCuaILuGllE4TmNKSdvTD5WZ7OyX1/vr/lUgUREm4IoXFEFe8PsI5Y
	lQefrmF936d3IPX/af3uCIlqQ+Ans9Y1qXvNRYO3nbfEB8nGecwe7DM5JfxW+JvT
	HiCdaC52zvO+9P1R6hbZ0qkCEBMXw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv95qq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:59:42 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MEBOsr+sE8UyDqCz/EPO2zn9UvNL3s7WsGzFkEwNIXnuybPXTmER+F/V/8VdoGTR7tr59ma6S02oz7fiYGw6wyqwUQS6Ed1+PjFRvaD5ErzulSWbc3Uysg1yzcW48yEkiwmibtnZiL+A4zIdT5KpwAoMOwSwHqnaVz1NYeOEBbqCYiDfD1QYTPGfKVSmgKOJOVmbwW0kTd1jRZWCA26QU4G+mPU796MYz6Mr+qKtCPhlKzoooh61Jdo2BiPnplySIm5xX4/H/uusRxyzImM41EyUQnkshXEbnEimFkfbyHl2oYc0aom49oQpvFrLLgFSZXKeHew1qt+AVFwDDZcRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=UdQQegFIIqoYyqK4RmMue/e8Ul/f8f/H29jqUYQ0YUn6+glz4fdlzNqCG0I7aSi244yR+RUeT4i6tGz8+IRRE1TBHkpDxitjvs5Zg3GCawq8Esn5ua1GKWf1gb0FO0xMEy1S/+qyd6vEfYZcaKkI+JdkR/YXH0kg6r1Z920yA67HL52mySZJfE8/Vy4wD4FtGc38e5EV28kefzwJU82li/SH586e7oYIiv3d/OA6oQYZCYZ2p+xN2ONVeN/N6fxS4P1p686b4P5qPPf2kBD91exQbpC/qeG7sAcwnmNK7HnjEbVGhugjXe63EL28Rx3SIWGHJTwNurq421y9KgNtpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=d9dm23MhivnqNRm3O0uRZ1aUvfv/AuYOF3W+JTlon7mRn+l4ciWLHJd+bn5X0yLj69cx5etKDvd0JMOl61k0R0GFsOTggFAeEMSs44fmJS2NgzKfRwZCMimxznupWyAqdXL2uGfAIrqsnDgh+kVleDbp8m227Bjth+UFy1TVG8E=
Received: from MN2PR15CA0063.namprd15.prod.outlook.com (2603:10b6:208:237::32)
 by PH0PR10MB997782.namprd10.prod.outlook.com (2603:10b6:510:3b1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 12:59:40 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:208:237:cafe::28) by MN2PR15CA0063.outlook.office365.com
 (2603:10b6:208:237::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:59:38 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:10 -0500
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:09 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:09 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCx8px4097984;
	Wed, 30 Sep 2026 07:59:09 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Wed, 30 Sep 2026 18:28:45 +0530
Message-ID: <20260930125859.1749849-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|PH0PR10MB997782:EE_
X-MS-Office365-Filtering-Correlation-Id: 422f5b4f-839b-4b14-3556-08df1ef2afa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|23010399003|1800799024|13003099007|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	J88V1FkJeL2JRS78+tCsQoa7f3UqIyyX3MrvgxUXzvMEJVrf22w1JrX9PtI11yTRx9PwzzfNI0CISsLU7xwylrKpWq5y1Fs83SgRf6xkneVC5neEoIfmQOyGnX/MBpS7rNWWAhHgecPw+i3TfQhhz5HQ/4jYAwR6vcr2tK2nBvcjUI4tXWF7JZZ/tdzLm911VIE39HDZ5jv/gjXBRHdIbM0pldtAjfADic0os4OTXN/OJhG4j3GLQfbhMfIPOY96hUnkb3dILRGMppVJPgAK9e3SDFitGBtxBsHtLg0btB6+9b+kppzhnLdnH7IA26p/mU/G7hrY2XGf7p9ATBtvipWIDdPIxF9mmSVoLmXxPcFHGMXw6vm+h5YdNTqsVu/2PutIsU1SjVbkA2MPnctpl7BXQeSlVLwOs6iuJIDFARBPxbOo34ndxTdAQ6X6jFpzHIBRgB2EIWEYcRaTRp7kBTCZosrowuSki3l3TT/3mYyPNaGxhA8hF/NoHiVLJz4uT64yNsKH+du5H3cVNNMO9P43SCeVX+BDCKTBf0SXO1/eWASK141hCNYM+Z8TDTTBH7znmQ/krss/0bw0stPKcjKtYTxsx/n4aj5wx8NPb3rukltRGvEgAJkTsZg8JksQ+GyX3eHoigylGrVGKY1XOw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(13003099007)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2lpbnCFEzFtp9k4HcOumuBtmufSdfl2y5my8XKeyttf24fJ7ckMjQ8SWHw0KxRfACSU2odOpnSuTFLTfd1m9IQFAgoHJ53Nmv3YXTZs9W98sG2Fqyaf9Ln0AN5+QvDi3EyLI7fwgvlBIpJeuMxfc0bvXvFDcuxREwPgZOnoCX1KrHP5J8hbHzZu8QdbvnyrpuapOWVdOph0aXd9N8I7rBucXOtpDcFxX/1+UYCBjUmpaneFOHaiD+nxo05ssdQCI3f0wrYeem33YTbR4FDtkbiy8TZJ5GjwTeY4MfZbc/1Dgb6uMKKA8rq6ZsF54OSsZbdGUogAdC5IiKg8cpIQQWKTu3FWuukevLJnsCUjEFHhUjr227H8cwjYo+lhT5UN9eHCIQbfcwtiqRLIZZn2fzWmPfUqkY8v92+yF93kNFTShq9jY0lLOnUg3cDveS8v8
X-Exchange-RoutingPolicyChecked:
	HCecIwjt3GPAOAopaseJJvp8qx+c4okNg1KPUEbkqGzfbO4cCJgpvaIxUIVgwH3AV6vWbcIYTalQ5sqi2Hg2t9Wa39TBK9C6ZEQYRxVlZrhJkeQVOjO3w6ghMlN6ut1bQ75vfjcLs+pwUHB4ZUG/33fyuGcFq61VhKTZ2lMeXCqVs9FLwUTLsT88XQ7uhI4XftFNeJ6arflddqExXf7crg+tGwk3s7Pr+2iku7cw6o/gCRjSsxECqmQZccegHClWJeXxYR3PZKebvsKwPZQ/sSpAwc0ceylqLpV1UaY5QxG8a8UFs+af03aZjMsbvF7FvdeyiINYkudgD96EIEmKoA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:38.6321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422f5b4f-839b-4b14-3556-08df1ef2afa3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997782
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX59XcyFQTQ5Eg
 UzSW3hBW33ZFOPcOXvvkVaFrHbwHDdOSydhqgIJu9j4KhJNQKKfsF8J32HLbm/qbK7dXUkJSmuM
 KV+5s/mLzHNPEKa5lyHaUO1WqGkeI6U=
X-Proofpoint-GUID: LEh_5cQlWPbmx-vcBD3MkqFSXxpYZvZ4
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abd07be cx=c_pps
 a=xjw7YmzweVlW3QpdpNkTiQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=sozttTNsAAAA:8 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-ORIG-GUID: LEh_5cQlWPbmx-vcBD3MkqFSXxpYZvZ4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX1rT+VZWU+dy/
 dcRMXU2BG7/JPt7DCEqSxEV6m9deB4FoIbv9c/25CJ4GOVxMl8pH4+Gl+wc7tMsPcjEfeGqwKpX
 wTtWVMG9FTMfBYPZrn9a4mk9U9D9hgHuttH4akKagd2dvcUd81sMDVYB4JrBtR9xiNmoQUIo3Fr
 6aSDqMUi+tY0w96cdkr7vzN9lk1kJyc3dfCySXCNaItvjIHVdjumtBCa4V2QlPP52/1QCDwV+Yb
 ndMK09tanQRddzXqDbzAtB173cQUjbMnMwi1jg4QEqNb6rEoYj+A0x/Nvu0fyCpW3KY5e0DY6VW
 snYS31tTra+neSktJQodfvueYFd9i3sP950x2Vm5yWYuKfKmI0ge0bBP/jpESkT4LTfVFLqYYaI
 C8qkQw/CX1cZLbpGX4uGjUdGtaVzZV1/WRDCma05pOzCdxL80sH2NPb8Lgy/ZP02KQ1gj3HSh4o
 9zWaHR6D9sT5uXgLODg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..4fdd24ee91637 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d3611..cb4b8b38a5ec8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

