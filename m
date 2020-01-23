Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C12C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 12:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBBA72253D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 12:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="TJzLVsJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAWMGw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 07:06:52 -0500
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:6053
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbgAWMGw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 07:06:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVvvUN5zQ1+lyzPKEn7/t/h4NGbyMvbBzXB0anD8ZrKTeDeQdQ8Rnm2DIlLPZfIuEMXyOKVaVUliYy+2eJ+tPaxXdMcLzrLN+kyHlnSToZqE27iVFtXfvOJHxyIrV2eTCRcOxzJiufy5aG2ErRPvBSIOxpxOu//ualgvp45WjuGq6MB76B20sH00b69tkHh6lhkYy3yYzY6KtYFNHR/YRCoOtIwslD/FMUBwAJv9wgUi6PJF28fUDz5rmgrqScK3uMPyUGflu5QwjDXja+zbftmcB2nhsfOFge+4fy0Ov4fOXdXIFbY0vc2lXdkRTTn4Z/ziko3Wy0X5gTIE8oxqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOiY4x4yyw4P/8u3tVKr116a3J84fqjzkpcBVm9+rpw=;
 b=Smpnd7z7xwB2OTye92PhtaM8aiuJPSsFOsTSH3BUJmOQSGIVLTZwRm/rSlG8R6Olz7oCmI3c3xYpKCp8D0l9SY0T4FPphDwJf1MHDuzqNoxbnRrQVtZ5aCQ3BP+FZbZfk3oI0wgukLhXXdI7L7G+Q8hk/e+h0/FtZZw4RRTea8PaU2pEhRJuo020PWLQrLm/kYqmLzgDBE9J4hS0K2gmsHCB7dGl/nhSnYb7YsH6qxAk5GRWJCxZjneiyjJvtVxF9tf/Th5U9S0DEq7ndtf4EPEZs6NwGE8UG1LW6J7foD442MVm70958ps8jOVzyeiahzs6/hPBaRweNKOws5I98g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=xilinx.com; dmarc=bestguesspass action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOiY4x4yyw4P/8u3tVKr116a3J84fqjzkpcBVm9+rpw=;
 b=TJzLVsJd8b9wEDROm/bphjC3Q9qFD+I3KAD1MA2mvhlIL48pjb0LmLAKtqDFWgkJyg4AsV3IbIu5MHwW1jS481k3UYsJTSY4i3cmV2geleRSkGP92wVLuml6EQL/IurlnSSkHjjiqPr2lKsQhXKgEkZdbRXKmTK3HB7kyG1hqDc=
Received: from BL0PR02CA0103.namprd02.prod.outlook.com (2603:10b6:208:51::44)
 by SN6PR02MB4398.namprd02.prod.outlook.com (2603:10b6:805:ad::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.23; Thu, 23 Jan
 2020 12:06:48 +0000
Received: from BL2NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BL0PR02CA0103.outlook.office365.com
 (2603:10b6:208:51::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend
 Transport; Thu, 23 Jan 2020 12:06:48 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT012.mail.protection.outlook.com (10.152.77.27) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 12:06:46 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iubG1-0001hF-Jh; Thu, 23 Jan 2020 04:06:45 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iubFw-00052R-Fg; Thu, 23 Jan 2020 04:06:40 -0800
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00NC6W4k029904;
        Thu, 23 Jan 2020 04:06:32 -0800
Received: from [172.30.17.107]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iubFo-00051h-04; Thu, 23 Jan 2020 04:06:32 -0800
Subject: Re: [PATCH V5 1/4] firmware: xilinx: Add ZynqMP aes API for AES
 functionality
To:     Kalyani Akula <kalyani.akula@xilinx.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net, monstr@seznam.cz,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev <git-dev@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalyani Akula <kalyania@xilinx.com>
References: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
 <1579777877-10553-2-git-send-email-kalyani.akula@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <23169ad8-f0a4-13f4-f2e8-3072b05b0469@xilinx.com>
Date:   Thu, 23 Jan 2020 13:06:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579777877-10553-2-git-send-email-kalyani.akula@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(376002)(189003)(199004)(44832011)(31686004)(31696002)(9786002)(316002)(2906002)(5660300002)(8676002)(70206006)(81166006)(186003)(81156014)(4326008)(8936002)(70586007)(36756003)(336012)(6666004)(356004)(478600001)(426003)(26005)(2616005)(107886003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4398;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26670e3a-1ddf-4b7d-8887-08d79ffcb83f
X-MS-TrafficTypeDiagnostic: SN6PR02MB4398:
X-Microsoft-Antispam-PRVS: <SN6PR02MB43986DDE170E2E200492DBE3C60F0@SN6PR02MB4398.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DSnIB8LjkXwuFVgVYkWX5Kjm0VZOHc4q0Fx28DqTz3DBdu6cyTg5twbd26i8HdtHVTbG8VuoGl7Xt2PT5NfL0Lb7emd++bM90+cew6Ntd0iuaROxDoXVVHOe2lMFsytnbdgUqG3LAKNheWxFFRYgX86T0X6LeYiQkQyoELPpvPAwCkLtwY+J5I6GMzNLNXLzheTf3+AHAGprorf+2p5vayrxndiz2YnxA8u+VaP7cloHT3A+o9v05aSliv4+7vWNrcQ8QTA2fnm0CSERdzJiUn1GoncFL1S4njTKqeCD4G6nd6nMfu8yIR/gSibr8B3ILjIUB/eSXnZMhTfmqZWg7oWkE5igCdXlzDm5L+stqQjP9uWs42HsvuClIvQoy5RkbHbgs9p9Ul6uUndxqqw52rFcGfa2fpZ7+JAkCduQRaUGFnopVBfLrKHMPfsMB8ON
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 12:06:46.5498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26670e3a-1ddf-4b7d-8887-08d79ffcb83f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4398
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23. 01. 20 12:11, Kalyani Akula wrote:
> Add ZynqMP firmware AES API to perform encryption/decryption of given data.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
> 
> V5 Changes:
> - Moved firmware: xilinx: Add ZynqMP aes API for AES patch from 3/4 to 1/4
> - This patch (1/4) is based on below commit id because of possible merge conflict
>   commit 461011b1e1ab ("drivers: firmware: xilinx: Add support for feature check")  
> - Added newlines in between at the start and end of zynqmp_pm_aes_engine function
> 
>  drivers/firmware/xilinx/zynqmp.c     | 25 +++++++++++++++++++++++++
>  include/linux/firmware/xlnx-zynqmp.h |  2 ++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
> index 0137bf3..20c084f 100644
> --- a/drivers/firmware/xilinx/zynqmp.c
> +++ b/drivers/firmware/xilinx/zynqmp.c
> @@ -705,6 +705,30 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
>  				   qos, ack, NULL);
>  }
>  
> +/**
> + * zynqmp_pm_aes - Access AES hardware to encrypt/decrypt the data using
> + * AES-GCM core.
> + * @address:	Address of the AesParams structure.
> + * @out:	Returned output value
> + *
> + * Return:	Returns status, either success or error code.
> + */
> +static int zynqmp_pm_aes_engine(const u64 address, u32 *out)
> +{
> +	u32 ret_payload[PAYLOAD_ARG_CNT];
> +	int ret;
> +
> +	if (!out)
> +		return -EINVAL;
> +
> +	ret = zynqmp_pm_invoke_fn(PM_SECURE_AES, upper_32_bits(address),
> +				  lower_32_bits(address),
> +				  0, 0, ret_payload);
> +	*out = ret_payload[1];
> +
> +	return ret;
> +}
> +
>  static const struct zynqmp_eemi_ops eemi_ops = {
>  	.get_api_version = zynqmp_pm_get_api_version,
>  	.get_chipid = zynqmp_pm_get_chipid,
> @@ -728,6 +752,7 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
>  	.set_requirement = zynqmp_pm_set_requirement,
>  	.fpga_load = zynqmp_pm_fpga_load,
>  	.fpga_get_status = zynqmp_pm_fpga_get_status,
> +	.aes = zynqmp_pm_aes_engine,
>  };
>  
>  /**
> diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
> index e72eccf..5455830 100644
> --- a/include/linux/firmware/xlnx-zynqmp.h
> +++ b/include/linux/firmware/xlnx-zynqmp.h
> @@ -82,6 +82,7 @@ enum pm_api_id {
>  	PM_CLOCK_GETRATE,
>  	PM_CLOCK_SETPARENT,
>  	PM_CLOCK_GETPARENT,
> +	PM_SECURE_AES = 47,
>  	PM_FEATURE_CHECK = 63,
>  	PM_API_MAX,
>  };
> @@ -313,6 +314,7 @@ struct zynqmp_eemi_ops {
>  			       const u32 capabilities,
>  			       const u32 qos,
>  			       const enum zynqmp_pm_request_ack ack);
> +	int (*aes)(const u64 address, u32 *out);
>  };
>  
>  int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
> 

Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
