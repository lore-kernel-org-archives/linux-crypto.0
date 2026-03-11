Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA9F1D5ADE;
	Wed, 11 Mar 2026 05:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773207204; cv=fail; b=RT075UVNwToutjPhfccQ3M71drWnjDc+mhpsEEPP94lBkSkhwr0B0s4OGyzshT8zrvrBiNw+ANhj/GA0u9DfzJ3YO5D6Iq3SC3bhl2cF+QXUijAXCEBDA5fdmzwFcNKfxAweWkXbTWD2yCv3kVhpnThYJLLtg7/KJMoASI3ODMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773207204; c=relaxed/simple;
	bh=6zdjqS7dwWc1wI7+KIfu+0KWdR1TL/gmukDsIhiMSbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kuOOuwZc/9u8gfEBMj+15rxdshQk/czkJWvUoNbLW6QBLq4hLwoH3Y3WHZky/7bIwN2Tldj4i/7CVOPWB9mi09UbEzXg7LMlAOc+Dq0IZJPD1ko7qHrpj2fHQCNveID14eMphx0GCW3fVBemZ4wxWXSqKuqZT/WlSTU6/un8COI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=VSEAmqnk; arc=fail smtp.client-ip=52.101.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="VSEAmqnk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bwCX7PWtHxhOiWGzw7qs/6/PjOYUqnosskqBstjeDRb5OBDozndHPfhBjOO9J6I3lTyNmFBrHQtXBB1CvVK2m4jE7W4yXP8Zgi3LZf5owD8y4Fbhio3HdLttku+OHD97ShVn96MF9ErbAvSOcWPrviB06PVMiX3oB77pF1eNGovXYEbGK2tIT3C6PBVjuTLTD74STI8ZaejY6xFptVgCCkQn0Heq/jLOJHv0nz+DvJAcq2dzPQBJwr2n00C4YGhhtex8j7fesTN/qYs2W/+6aQibUjwBlpJgZ895GUDcnB3eduw0p2p0PMawswbBSmzn8iz+qc8k6Jo5G0QUhuhnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXQ7roPbdAQBYXQOoqv7xPbBiEKlTDB1OJ7MSfqTufQ=;
 b=DGArPdaKPbRZcp/SumN0LdIgylkmtelEWv1TO5HhXLGflNfVkVXPtWkOvFc+XZuJ53V6kOEiEdlfG1A0Ga8Lp8feguEaK80mbHhc2JV9bEtHMDLQw/P0rZ2gtP4i9WUhGwzXRUcBG2LS9xoPrjOG2i6dgshF6fk0gfSFfBhHpK8odLl8GC9ad0EnGjzYMNjs0t86D9X2fTi+7vkXAQqcVuP0o/XzLLadXl2xrQllsZg9LjhPba7TvlsWPTCtRmIB7l6A1FAPrza8LVMbzPgByCeZp8hRsb3EdGz58b4ejJ5Rt1bAMEWprsi2LtSucTu2lvbsFyBqh/R1281f9bkFdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXQ7roPbdAQBYXQOoqv7xPbBiEKlTDB1OJ7MSfqTufQ=;
 b=VSEAmqnkQT0VshDNKTZwia3hTBGTQNOw8NPy1KOlMeYkvkAeU5bDLSFK+4h/MxS05e/6MaS+poK7cIv4l9Lb+HBf0JcOko+c/X3L5CK6M+88ARgzqBSomSSV64jqACv4vhLe71oTvv3Iz2uBq4S3UJL0Onxoi0TP1ZwdbC/v7kc=
Received: from DS7PR03CA0136.namprd03.prod.outlook.com (2603:10b6:5:3b4::21)
 by SJ5PPFD6523AA75.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Wed, 11 Mar
 2026 05:33:21 +0000
Received: from DS2PEPF000061C4.namprd02.prod.outlook.com
 (2603:10b6:5:3b4:cafe::af) by DS7PR03CA0136.outlook.office365.com
 (2603:10b6:5:3b4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.27 via Frontend Transport; Wed,
 11 Mar 2026 05:33:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 DS2PEPF000061C4.mail.protection.outlook.com (10.167.23.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Wed, 11 Mar 2026 05:33:19 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 11 Mar
 2026 00:32:49 -0500
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 11 Mar
 2026 00:32:49 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 11 Mar 2026 00:32:49 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 62B5WkO8256351;
	Wed, 11 Mar 2026 00:32:46 -0500
Message-ID: <5807d226-a5fb-4d36-987f-aa22f06f4788@ti.com>
Date: Wed, 11 Mar 2026 11:02:45 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/3] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260226125441.3559664-1-t-pratham@ti.com>
 <20260226125441.3559664-3-t-pratham@ti.com>
 <aau2bg4gdM0VPcEo@gondor.apana.org.au>
 <26303ab7-cd14-4560-8872-021229faa137@ti.com>
 <abDsufbNKkUa1msb@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <abDsufbNKkUa1msb@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C4:EE_|SJ5PPFD6523AA75:EE_
X-MS-Office365-Filtering-Correlation-Id: 144b253c-a2d3-4917-b079-08de7f2fb417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RRXWtENcyjmjC8nk/C9ygz0MES5sM5REECAheWMwB0vk3Cv3EdBiVnuuiX/mJBlj29iLNb8p2I/GVkslNF9zM5kIbDhSqqU/MErYsgmgyabn7gdKg79Q62RPSJdV4p9Fo6cn/TtDIsbTTpBD5dP05GJ33OGsfoBa95hzig+rz1ClrinCc7Pgv64eJlEoqaOVgww4cR9loCmormTDJAr93vmmizAl/dxQg5ssLe3ALEArwEDzr+hny8F35OgdKcvGcMUkHA3V2HEDezd5RTQ6f8EE6yc5pQX78hH5hBDubt/dxWJvTJ88PuonFzxQnATke7uucELTMRpmTG2WdsDg3Gu2arAUOl7IATwW441mqBJYs5MntvDSeXSp2TR1Ij8BLPm/qAez1GG1a4O8rHr7+cBLWUw/b6ohFu8FjQ+8rCEFcks7gBS/0mxbagHSDxfWErS8rv5GDccnnuPSp4Ll/famSrkpGicZWEynJ/3iA3u6jsSPny8Fhdv0pElZqkrXrWtSKaofcxy8n7FBXdZMUXRf5F6CL7LaUACThKL8T/YR/5ohVdsOa0gMH5s5s+WhQpAiiZz5aOMVomkqtK9IsAD57TAVElvtE58WwSByfCsR158Ox4QpjSyAzj4gCp2XMGiOJZ65FzM9+XJe/pb5MdyRT0cOqS5n1zo6dbxacMohbUwKpjtlHAPbr5gvfbgl3qmMgGPRoEzdAz943uwZwaTGNxU6gvTizIIVUtWdtan9yRDv7Dbq/LakA0dqS2LcVna2VOtT/tHc/PwhxeSxyg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H9iX4AsdrzM1yvjGDS+GGG71AB25bhls4knRNrvpRQN4udIhWR4Q3F9vUkLasYC0XnJ9WLk3/QZ9vxl1mFoUx+z79OjB+sT1Ni5BKBCpufE4jzssOPospSXMHICcHcp7BmETwG4JE4hfn1DbuWX76HMIY3fGX2uav0a+jfA4i1SKxne+R81cZOoaEHValtULHxrD+76ZXsp5ij2/OsKSE8UIpNK+j69oaZKo+/9OopC+tRpo4Vn3OMqYrUtNVjIJGi2mNuJQsFyhKbxxchm3zIps6OQz9T6Rlu2FNFG2ldIWODm3VerJJbcGzPPOc/GiAngm3AlF2IgapzkQCMvx13iJpVUWDE9T8uThLlNoLQepnePkFIoZBuvqMhCX+OSQULtgzRvZJZVcXwNBEYqfcO5BYTc4xvguwgRV2gYcWU7kMXkfibSd6lzMSdCMSt7F
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 05:33:19.3803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 144b253c-a2d3-4917-b079-08de7f2fb417
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD6523AA75

On 11/03/26 09:46, Herbert Xu wrote:
> On Tue, Mar 10, 2026 at 10:35:15PM +0530, T Pratham wrote:
>>
>> What potential issue do you see? Both `dthe_aead_prep_src` and
>> `dthe_prep_aead_dst` functions use `sg_split`, which anyway allocates a
>> new scatterlist. Even if req->src == req->dst, the src and dst from here
>> on will be different.
> 
> The copied SG list will still point to the original memroy, right?
> In that case you will end up DMA mapping the same region twice, once
> as input and once as output.  I don't think that's guaranteed to
> work, as you're supposed to map it once as BIDIRECTIONAL.
> 
> Cheers,

Oh, my bad. I though mapping only looked at the sg list for direction.
Will update accordingly.

-- 
Regards
T Pratham <t-pratham@ti.com>
