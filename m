Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CA7C3F68F
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 12:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA692467F
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 12:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="WgzdbVPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAWMID (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 07:08:03 -0500
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:23929
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbgAWMID (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 07:08:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iK8MuxTNQvupwUowY5KZrndKAP2+RbXHjFe6XdzcXxDCNuFJwUULI6hqF927SzlrdbqnYpXT+J0wXC/B+34ikz8rR4GPuzg1Lzc6ebnHJBHNbmD/1R1GG7c4ONyTsQNMLyYmOd/38R3rfcUyoZZL7iCcFlav8VXQ02CkzeOWs/GEKzGR5yMC7H5ppWO+AbllgC55mrrhhlL8Z4NIoa7LUUJlX7L23m7rNlD391USnyPfyxLfCpIYgtg/odTEUk8wcX4i65+hvtaMdyHrUzn+EX8GCGp/fXBnBBDOwXcMusDldKQ9caE6+HR6+FDnBjzELSspqROrvflraPRGDawf/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8BCcNqdfAKfIecJm+cKUfJWnOjSPD++iVn5Z8oImWg=;
 b=lnxpCqKxlgCV/yviTB4irEvhonfJuDGCLVy0g3rzJ7wewPjR1a3Xgx8Yr+YnrP4vxHbaTXqaYZZsymFA2vwwqzlpAX5wL9zo6SESeKe9rg6TUV2syquPCBDIgSIC3YoM9U6zOknagZuXcgT+HlgRyFv143tg5UzIDpP2nVs8trQgrhbSjSjgjJpcNxvuAhwF2YkGDITcI+XFNsyvxACrMcudoF7DvT7FixOPDJ8GVoR925BL/ElLRM8oK0lj3a0iThp+0WyfUdnl4BEcT0h7VtMiOUwpbgRb1VvEmiD6MGn/4NsY5mcetoBseFnFrjaj202iUTygc4WugnaEVgUzSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=xilinx.com; dmarc=bestguesspass action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8BCcNqdfAKfIecJm+cKUfJWnOjSPD++iVn5Z8oImWg=;
 b=WgzdbVPN0gUrHlKpuqBXGp10nh1ofU1LhfGOvlnmzFRxn9DlkXdJ5krdoE8pfsc+ruYi8W4avTMy8bic1pwnohg937SMbwiY4hNqQeUVC5SLVYsZ+D6aeAMx4HsmEJH2LNIppGl0LsAfEkHn9rX8xLQAQQyI2UKnCyAnyxMYMzo=
Received: from CY4PR02CA0047.namprd02.prod.outlook.com (2603:10b6:903:117::33)
 by BYAPR02MB4247.namprd02.prod.outlook.com (2603:10b6:a02:f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20; Thu, 23 Jan
 2020 12:07:59 +0000
Received: from BL2NAM02FT039.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by CY4PR02CA0047.outlook.office365.com
 (2603:10b6:903:117::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend
 Transport; Thu, 23 Jan 2020 12:07:58 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT039.mail.protection.outlook.com (10.152.77.152) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 12:07:57 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iubHA-0001hY-Aa; Thu, 23 Jan 2020 04:07:56 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iubH5-0005A2-6L; Thu, 23 Jan 2020 04:07:51 -0800
Received: from xsj-pvapsmtp01 (maildrop.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00NC7jjX030668;
        Thu, 23 Jan 2020 04:07:45 -0800
Received: from [172.30.17.107]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iubGy-00059M-LB; Thu, 23 Jan 2020 04:07:45 -0800
Subject: Re: [PATCH V5 2/4] dt-bindings: crypto: Add bindings for ZynqMP
 AES-GCM driver
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
 <1579777877-10553-3-git-send-email-kalyani.akula@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <1c5eda42-b28c-ea98-048b-77a94c8da545@xilinx.com>
Date:   Thu, 23 Jan 2020 13:07:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579777877-10553-3-git-send-email-kalyani.akula@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(39860400002)(189003)(199004)(31686004)(44832011)(336012)(31696002)(107886003)(426003)(2616005)(54906003)(316002)(6666004)(36756003)(5660300002)(26005)(356004)(2906002)(9786002)(70206006)(186003)(4326008)(478600001)(70586007)(8676002)(8936002)(966005)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4247;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e06a2e03-9798-4771-c6f8-08d79ffce25f
X-MS-TrafficTypeDiagnostic: BYAPR02MB4247:
X-Microsoft-Antispam-PRVS: <BYAPR02MB424736251AE00568609D9ADFC60F0@BYAPR02MB4247.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdLB0PAPSzOzCNVTXhrTOgCM0g9Q2lt77g/95as0YrJ4HPQc9e5MS1+o/rYbDTtnwGRe46dosaSPCQN0e5fRNaW2B90m1DpyUrVJWYTB+ru7ciafZkdxu18tcJVZG9MTqEThjd5fI1pntw4g/cKJBtsJ1zhGbmoh1QPAnQ8u6pbfcDDME+4DYKp93tArKYydW0hiHZP8KH2QD1GLZCO22HHZyWEqMGR5zxzq8ZIw/S+GGvuP6P/hw0Icvv7eOj/1C9Zp4x+Y6jHgyatiH4her2ergYAuiNa+7rvJCBZUUZk3JY4tsCDl8h1o5uLyUDH/SKHI7sjg+/Kvp2l70lb1oWtCtBWjI5YuEjXJ2l9iAprpm0LtJ5tjCWCPW9ZzmDdxfeRKGAstPuMm+Vd8yOEX7Brv0xHlnAxN3FVRFd4ADIXlDNjXYvoDmxKMxfty7gbbR26p0KQudZQXAp0YrcWDAwnMrPxoF1ZWWpGPUPOEaVQ=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 12:07:57.2922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e06a2e03-9798-4771-c6f8-08d79ffce25f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4247
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23. 01. 20 12:11, Kalyani Akula wrote:
> Add documentation to describe Xilinx ZynqMP AES-GCM driver bindings.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
> 
> V5 Changes:
> - Moved dt-bindings patch from 1/4 to 2/4
> - Converted dt-bindings from .txt to .yaml format.
> 
>  .../bindings/crypto/xlnx,zynqmp-aes.yaml           | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
> new file mode 100644
> index 0000000..b2bca4b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
> @@ -0,0 +1,37 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/xlnx,zynqmp-aes.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx ZynqMP AES-GCM Hardware Accelerator Device Tree Bindings
> +
> +maintainers:
> +  - Kalyani Akula <kalyani.akula@xilinx.com>
> +  - Michal Simek <michal.simek@xilinx.com>
> +
> +description: |
> +  The ZynqMP AES-GCM hardened cryptographic accelerator is used to
> +  encrypt or decrypt the data with provided key and initialization vector.
> +
> +properties:
> +  compatible:
> +    const: xlnx,zynqmp-aes
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    firmware {
> +      zynqmp_firmware: zynqmp-firmware {
> +        compatible = "xlnx,zynqmp-firmware";
> +        method = "smc";
> +        xlnx_aes: zynqmp-aes {
> +          compatible = "xlnx,zynqmp-aes";
> +        };
> +      };
> +    };
> +...
> 

Rob: dtbs_check looks good to me. This binding is aligned with other
clock, reset, pl binding coming to this node that's why

Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal

