Return-Path: <SRS0=ccn8=ZY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233DCC432C0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 16:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D55E32053B
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 16:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="tQLAosWW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfLBQQy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 11:16:54 -0500
Received: from mail-eopbgr800057.outbound.protection.outlook.com ([40.107.80.57]:13664
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727418AbfLBQQy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 11:16:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmBLNiTd3CHsvm87iN5lmp1PtUq6IhcpuQVSrwas1lq2KLtfnRaq59qAXR+efaucXuVws0rqOp44bTRG4QXK555rY6C95WdQ/1FYVvqBgaUB7/RdQAd5Pgnj6vxKT5Gvm4mojfh5fKQ5TNwEc4dgANHCf9KfzGxtSBebO0g5RRPACw3YUpn613XzKBDPz1+e7koDqTywrnw/y8g2hl92pqYlSA41FpgX50T3Y+KyKT+5bXjvXjXlbyaHAq4S/3Qrslkbwr/uIiQcXTDFcpjAjXd6gqt2P//l7Qnqze43i1lXV6E/PrJH2lP9AQhvK13rGasowO+B+/ZAkDXKgZXEAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFi14Qi2INQOb1PURJ+aK6XYMPe+ZZfdeAg/+aLagqw=;
 b=EUgoNhmlLrdXISPFDa2KuWucz8F70N2qRr9Gi7teaTYrvzeZTUBmHX0rT4JE70DaMYZvi5FNgyDRANrF67Wdto4qbPPUAasAfShstkMPnMsBQnDFZiQhI2Hju9lGbyYUS8E6y9PIBZGmcuzFRS7Tvm+7gkJWcPULwQLkAWvnFrjZChw2MXccJy49/Rsf5X9qf6Q3SDaEydNx2+Vu8EpYWLx9wuOXUVzJl46nrLiqSi4jjyo1BNfOg2YTNCL9abQ7Hpr66d7ZlGSvCM73BG0FBgJrYCduc9GFdux5h4cGHQzJUNg6pA8cLYTU3tDxmCNgNuXkR8Q9ImaectvzzwSdpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFi14Qi2INQOb1PURJ+aK6XYMPe+ZZfdeAg/+aLagqw=;
 b=tQLAosWWu8cu9A48ug3yzEAnbXnngiw7JTz+48sHkpw6SufTlThaDIfFF3uwbZ8+1lM3ZOWHRdTPdfTYDnp4Ut60fS0OPz7xu25hzaanHFyoS6zU8tYW7l4kcxuDDcFNeWfhDdzHpZ41lyzMpRCat5hg8IaEVdSLrUUhqT0wHHo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from CY4PR12MB1448.namprd12.prod.outlook.com (10.172.71.140) by
 CY4PR12MB1877.namprd12.prod.outlook.com (10.175.60.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Mon, 2 Dec 2019 16:16:51 +0000
Received: from CY4PR12MB1448.namprd12.prod.outlook.com
 ([fe80::4436:923:b008:9205]) by CY4PR12MB1448.namprd12.prod.outlook.com
 ([fe80::4436:923:b008:9205%5]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 16:16:51 +0000
Subject: Re: [PATCH] CRYPTO: Fix initialize 'psp_ret' to avoid uninitialized
 usage in error paths
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
References: <aa2fd7ae-261a-5c62-821c-96479d11309b@gmail.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <2e77f35a-5a51-c60f-52b6-7e660f1ec8f3@amd.com>
Date:   Mon, 2 Dec 2019 10:16:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <aa2fd7ae-261a-5c62-821c-96479d11309b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR12CA0033.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::46) To CY4PR12MB1448.namprd12.prod.outlook.com
 (2603:10b6:910:f::12)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d22f5c9f-8ea9-48f2-599a-08d7774309d9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1877:|CY4PR12MB1877:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1877243DCABBD67B2E42C75BFD430@CY4PR12MB1877.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0239D46DB6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(199004)(189003)(65956001)(2616005)(58126008)(5660300002)(8936002)(110136005)(66476007)(14454004)(50466002)(14444005)(386003)(6506007)(53546011)(66556008)(26005)(66946007)(186003)(23676004)(52116002)(11346002)(2486003)(36756003)(76176011)(2870700001)(6246003)(6512007)(2501003)(31686004)(2906002)(6486002)(6116002)(3846002)(229853002)(305945005)(6436002)(7736002)(478600001)(81156014)(4326008)(25786009)(316002)(8676002)(47776003)(66066001)(31696002)(65806001)(86362001)(446003)(99286004)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1877;H:CY4PR12MB1448.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3D9ie9owevgFoBUZGMmyzcQ3DyATN9Dv0337jfWQGGNcaeyeHQfEULMXoKmBxiUpAaz+eIIMvYcwGcAOb6bbVSzO28rYL+bK1rSy5PBOF6+jum4i8R6Bu9uP5YWcoO/nDx10khTsMJR0cninZslFEg1v4aajYxickpiekgrm+I8FTt8Pvrl4fxen5jHJwDEJx2tBSdJ2dqUueecn7+g9DRKvKflgPhdTF5bQDeZXTbuqxU/nmTm9F3e5QU5Cm4zbJ1p7oBblDKBraeq/hgTJb+RI2s8iGL2C2Xd2Shl6M2pNvkd2QBsm0bTS+dBu1RsCWHGl5TmGfim2TC/HILJO7ez9A+p8ywPzzMR3MHu/328GXJDeJjQqgV7w7hOdCqyHD2gLDxCXrTxotousYCJWHd8kqRJZJ7Y/ss+1y9ZXD4AjU1zGAOTj2DD0hPFBz52z
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22f5c9f-8ea9-48f2-599a-08d7774309d9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2019 16:16:51.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwlFq3i1nsT2HAftkPJFiNrYcMBQPRUr7CKMBUgJpmoPzMgoodGSeWmF2cITUaXU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1877
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/27/19 6:41 PM, Haiwei Li wrote:
>  From 842cac9822aafd3cfe2da154b92b033fa1ed0d2d Mon Sep 17 00:00:00 2001
> From: Haiwei Li <lihaiwei@tencent.com>
> Date: Thu, 28 Nov 2019 08:25:16 +0800
> Subject: [PATCH] fix: initialize @psp_ret to avoid uninitialized usage 
> in error paths
> 
> Initialize @psp_ret to -1 to avoid uninitialized usage in error paths.
> Such as the function 'sev_flush_asides' in file 'arch/x86/kvm/svm.c'.

There is no uninitialized usage in error paths.

> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/crypto/ccp/psp-dev.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 39fdd06..3501562 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -155,6 +155,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, 
> int *psp_ret)
>       unsigned int phys_lsb, phys_msb;
>       unsigned int reg, ret = 0;
> 
> +    if (psp_ret)
> +        *psp_ret = -1;
> +

This function is not responsible for initializing memory that comes from 
elsewhere. Much like the use of errno, we should not modify memory if an 
error path causes __sev_do_cmd_locked() to return before any work is done.

Since this function can return two values (the return code, and the 
psp_ret argument), it has been defined to use the return value of the 
function to first indicate success or failure. Only in the case of a 
failure should the memory pointed to by psp_ret contain any useful 
information. In every other case, that memory should remain unmodified.

The return value that is stored in *psp_ret only represents information 
from the PSP. Therefore, it should only be modified when the PSP is 
called. Additionally, there is no "-1" return value from the PSP, and we 
will not be defining an default value at this time.

While I am somewhat sympathetic to the static checker's complaints, the 
proper solution for that problem is to initialize memory when it is 
allocated. Not here.

Therefore:

Nacked-by: Gary R Hook <gary.hook@amd.com>


>       if (!psp)
>           return -ENODEV;
> 
> -- 
> 1.8.3.1

