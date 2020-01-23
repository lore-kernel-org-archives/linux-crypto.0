Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90006C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 12:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 579C92253D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 12:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="rqxwrn3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAWMIb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 07:08:31 -0500
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:9696
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbgAWMIb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 07:08:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYkL5cSTkGNoNt+YDH8kVcswV4a4rWC19wpRnESy6qFrghpL7ZdWuFSHA1nijjq7JsLiHegJbU2/BaIHloSmHish69UjT4o9Vwfz0nV+LvReFkyzyuwg1EKoLEXO/uzEdKH4xqGD9UmU5ra7EQ5OnT5DWHx0pzBcj/v84flrfIoVmAtQwGsnno3b+50OZmI1sPsHhP+JbszTWqT5IF86LNrQSmt5a0+QPpYXqivmS/Qbc5S4GhVtX7TWc5D5/MZYzFsRqPckhrX+Blqhh9CmTin+wbvFpreHa0QQFIdNMk+kWiBWkakKpz00lATBrNynphIIX1weKT70WEVeKhes6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHDtdysv8afKNL3RN7xAOOYe5Kd+aTrsPyQufBJeiJw=;
 b=aSLCH7AOpfWqrzfZgqutkaYUZfAk6DtjKzhmE6gHFP8B+vLFQ/rEEijVY1XyFVKRHy9BXJIrhv3eoj5hQWFW6HiNTNp6tCmMui/WclUSRznNf8pnAtn3wfhw58oTyrGUa5+2rx6POPwaZHH9DrWr5hkCB+7ZKoGMvVvDTx4NQyn3V4ptfgn0Drx4bxeN/Ge+rjhFYWrRr9GBBThzeQhTr0N2agewFol3Gx9JbhQOB7Zx5nZ0ow1KW7JgMY/gSh2vQSC8lecA7v5/9uqZZWINCB9DhKF9hPet9rv3DwIXjaMwCY0fn7I2gjGDJCmWanC++7pjgbkwAz7lpisBCke5Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=xilinx.com; dmarc=bestguesspass action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHDtdysv8afKNL3RN7xAOOYe5Kd+aTrsPyQufBJeiJw=;
 b=rqxwrn3IZStAYTVUEmKczO68aTrH7MBba47y9y0ZlH2m8ZpcOg12Yg9sHKVOEhNjF6gFz81XMRs6UORp13b5MJcercq1KRVuWMNztcSvrwVG+7vTRnH+6+nAPLqzOxSOVZ8/cKwTrcRqN08CYq2HqJRaFn/+ZONkATYMk5t6YT8=
Received: from SN4PR0201CA0034.namprd02.prod.outlook.com
 (2603:10b6:803:2e::20) by SN6PR02MB5600.namprd02.prod.outlook.com
 (2603:10b6:805:eb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20; Thu, 23 Jan
 2020 12:08:28 +0000
Received: from SN1NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::204) by SN4PR0201CA0034.outlook.office365.com
 (2603:10b6:803:2e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend
 Transport; Thu, 23 Jan 2020 12:08:28 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT011.mail.protection.outlook.com (10.152.72.82) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 12:08:27 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iubHe-0001hp-IM; Thu, 23 Jan 2020 04:08:26 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iubHZ-0005FD-Eb; Thu, 23 Jan 2020 04:08:21 -0800
Received: from xsj-pvapsmtp01 (smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00NC8Cs9030845;
        Thu, 23 Jan 2020 04:08:12 -0800
Received: from [172.30.17.107]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iubHP-0005DK-UG; Thu, 23 Jan 2020 04:08:12 -0800
Subject: Re: [PATCH V5 4/4] arm64: zynqmp: Add Xilinx AES node.
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
 <1579777877-10553-5-git-send-email-kalyani.akula@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <a84f13ec-5f1b-be7b-7cb7-a8467936ee59@xilinx.com>
Date:   Thu, 23 Jan 2020 13:08:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579777877-10553-5-git-send-email-kalyani.akula@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(346002)(39860400002)(199004)(189003)(107886003)(44832011)(2616005)(2906002)(316002)(336012)(9786002)(70586007)(70206006)(31696002)(6666004)(36756003)(426003)(356004)(4326008)(8936002)(26005)(54906003)(478600001)(81156014)(81166006)(8676002)(31686004)(186003)(4744005)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB5600;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a52d8857-fd37-4c93-873a-08d79ffcf435
X-MS-TrafficTypeDiagnostic: SN6PR02MB5600:
X-Microsoft-Antispam-PRVS: <SN6PR02MB56005F3C05573D228C9B29ACC60F0@SN6PR02MB5600.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DBT338KLG8ef+j1gPnEbQG0tf0r44M4bU5rGLDUCMxsso3j/qFqzqfbgaFXqOAfRBR0Cs89ejetXIp4sQqqavwh9UinQGy7o7xxWhWreiSbUOEJgaK5vSTKn8Y2xubbY32ibHwM43a91K/qwyQqQy77CJhzAuvF6WQJzJO5K/m1rxU8MePP0pTYyhj69CNaP2ynEY6dojF4ySabeIQaxaKDyztnHGpLxZn7gc2DlQQZkZw+PVyL4BYYv6/4bl0tJxr96jJ3fLxpm355m/bXXfon2flXJEmSwnf9Xdxt6kvPJ28fVKY7rPatOjseuiJBfXGCbbV99nKbxrnBjgXkw58POp1kYMnZw0SdJYuzn342fK0fJlJPbVF2YzPOQZNPDXg9qkQjKCTFQH1kyABMeVSwbrqBFL+OaWScGZy54LoD6AURAUe0AX2iPGWE8/Yer
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 12:08:27.2817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a52d8857-fd37-4c93-873a-08d79ffcf435
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5600
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23. 01. 20 12:11, Kalyani Akula wrote:
> This patch adds a AES DT node for Xilinx ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
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
> index 3c731e7..e9fbbe1 100644
> --- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> +++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> @@ -133,6 +133,10 @@
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

Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
