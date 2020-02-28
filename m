Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804CAC3F2D0
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 07:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CAA246AE
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 07:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="ZBsglQbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgB1HMF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 02:12:05 -0500
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:6124
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726614AbgB1HMF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 02:12:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvOI3WQ4XVO2P2IXn47vINz1F4LW4nvJpOoFOzqS4tBn/4PxHIpV8TuwH8gCApd7RFmVHZ1wTRHfxMfJXNZMVNvp2ztpSHQt+jjPhzp5JzAYfYaB5mR3Y9jfMmlENqjEFnFcgkQ46D9yFE20K7Aom7h+qg0Ik0tFwZ6JGoiFkHurF/VTUXG5iLQ/IVBXsZ/zQ7lBaA45E0l15rO1Cw/I72AnI7KfMnN9Bd+WVySI2ooBvP3C5cQfm0cVZSLjyiuw7GLyTqQKl5K2ZFCzTU5L1TMc1O/1ZK8OW9CXWqiHzykOi5hgMNBF3k92OrhOa/UaWODBKiSMREqh60vKpkShew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdob88cW2KoamVlEcLa8zv49tR4BlUnJXjYgmJuWd0Y=;
 b=MnC5NvfNk6DvXjVWxk3MphI9TuzZE3ztIF2yA+Qlkz/JTLotBBz5u9dJp4VEu/xnoyO13gCmrjir1qARxMhqG60FPdXh4+rvu6WJ4Q9GAVsuzoFMxjabXOvX8Ochqnw0C/FZe+ROckCAVsL7EzCPBA2kPQjyGP2tUAMIDQf50bP3zWNiSY5E/pXIYfSa/b2nsVUQLmw1XgIPcn6OKEbRNoF8G3hvSMXZticIqZSNARdcbUV3hfVyhMJBoBDDXzjNhvglt9HpyPJozl/C8quvZRx8AgJ1w2/lxIr6BdQMvNdtmn60SjkBRKt8GtQkzd73sezbZ1s9BSTTKnf5jfErHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=xilinx.com; dmarc=bestguesspass action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdob88cW2KoamVlEcLa8zv49tR4BlUnJXjYgmJuWd0Y=;
 b=ZBsglQbSW5dcROZklVUt5mT5EJ/LUOmtu2/H5rRT7+3XbCJyNrxOczln0ghlMTW4qRyXVP9aIR83LKfE9ob+4c5GRC80dLv114iUpKCQSJ87kuOsw051Hh25ajirsyzYTxCcpDQgtKzzi5lW7Q8gLXsIc7OezjYlQYovjlrFkso=
Received: from SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) by DM6PR02MB5979.namprd02.prod.outlook.com
 (2603:10b6:5:153::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Fri, 28 Feb
 2020 07:12:02 +0000
Received: from SN1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:2f:cafe::62) by SN4PR0601CA0006.outlook.office365.com
 (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend
 Transport; Fri, 28 Feb 2020 07:12:02 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT046.mail.protection.outlook.com (10.152.72.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2772.15
 via Frontend Transport; Fri, 28 Feb 2020 07:12:01 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1j7ZoX-0006cm-6c; Thu, 27 Feb 2020 23:12:01 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1j7ZoS-00023M-3K; Thu, 27 Feb 2020 23:11:56 -0800
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 01S7BmYJ021595;
        Thu, 27 Feb 2020 23:11:48 -0800
Received: from [172.30.17.108]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1j7ZoK-000225-3Q; Thu, 27 Feb 2020 23:11:48 -0800
Subject: Re: [PATCH V7 4/4] arm64: zynqmp: Add Xilinx AES node.
To:     Kalyani Akula <kalyani.akula@xilinx.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev@xilinx.com,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michals@xilinx.com>
References: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
 <1581935204-25673-5-git-send-email-kalyani.akula@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <6014bc90-6135-78d2-2bb5-88430c1c7405@xilinx.com>
Date:   Fri, 28 Feb 2020 08:11:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1581935204-25673-5-git-send-email-kalyani.akula@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(70206006)(356004)(2616005)(70586007)(4326008)(54906003)(9786002)(31696002)(316002)(44832011)(107886003)(31686004)(426003)(186003)(6666004)(4744005)(8936002)(36756003)(8676002)(26005)(2906002)(5660300002)(81156014)(336012)(81166006)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB5979;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd54b85a-df86-4455-ed42-08d7bc1d81f7
X-MS-TrafficTypeDiagnostic: DM6PR02MB5979:
X-Microsoft-Antispam-PRVS: <DM6PR02MB5979B294F7C0AA6EED645873C6E80@DM6PR02MB5979.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0327618309
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MqnEggZsw8q2YQaZrSc8D9AOe0ZuxDR5ZZj+A/prCFZr+tzTyqt4PlvUMLCp+i0kZfvaQX+ljJI+HHJH5qNV8LTpJJA2hEMaLcAC5dZ08gF5V1tyk7aHlhTkypB2/MJt5SyjqhwNH83+R3nhCnpld9SnO0G2r0PaBONvvx2dvKIfo0R1NJpOnjWq2oYaGcqqd56x8y1DSWw1+BpTgkiemEDWdEzLnCInLtdtZD+BX3XA5vF6Gdf7Y0s/XsV37ilPFqxyuwlcWScVhn9yWH4ujqZF29X15nxUsfZc77DvP5lygTVWypqitBluoWYDq4zNHbdSjfGD32GBYNyCwNowRIOmStvNGVYEg4iRrsOGYjB/BaUCAw2qcNafslo39oaX49ET4XsuuHL+PxMnCN4f/4GeOtWX/IuGeEAzJRS1oO5r+hzLFCm+kHOCMaYZPq21
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 07:12:01.5676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd54b85a-df86-4455-ed42-08d7bc1d81f7
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5979
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17. 02. 20 11:26, Kalyani Akula wrote:
> This patch adds a AES DT node for Xilinx ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> V5 Changes:
> - Moved arm64: zynqmp: Add Xilinx AES node patch from 2/4 to 4/4
> - Corrected typo in the subject.
> - Updated zynqmp-aes node to correct location.
> 
> 
>  arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> index 26d926e..de4c694 100644
> --- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> +++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> @@ -158,6 +158,10 @@
>  			zynqmp_pcap: pcap {
>  				compatible = "xlnx,zynqmp-pcap-fpga";
>  			};
> +
> +			xlnx_aes: zynqmp-aes {
> +				compatible = "xlnx,zynqmp-aes";
> +			};
>  		};
>  	};
>  
> 

Applied to zynqmp/dt branch.

Thanks,
Michal
