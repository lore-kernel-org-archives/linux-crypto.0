Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E5AC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 21:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7B921556
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 21:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="u7cKuegC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfK0VXG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 16:23:06 -0500
Received: from mail-eopbgr700057.outbound.protection.outlook.com ([40.107.70.57]:60448
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732224AbfK0VFD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRBuhA3kpJQ8Uvh7akR35QXQ9qmXBC9+qB7Nq160MQKtiLW/1wd9JIMRkthukThIVHy/Gsz/EM7eQxizrOjv9x8FA/CKKJQbJPiwbii9S9Mzl5KWbbnZKilqgAQW7ZIsU7X128UDZppT/c1kWXdzCbo41eZSbyrqxtdRxwFMgSzy0l9jJDUTxsS2/ZioIv8bmlIbCzZAlJptEa/NjrGLVM/yn6ZzWyUqwVI8ijq3eyb7Yr6LdSQbSbQAIpnQekr/dc9V/NhnYEkoyrQr87y9M7VEJQ8cM3xII7fFfooWPzPKIJrq8Nu/ZezPVZuHDhYpYGXWUNRzQtPQRAs53KllNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3aU/F1QGA4pBRP5oE82ZdOXdxzxLJH3b/TeTpBfeYo=;
 b=JVz6f39CRPpas5xx0M7WTyOO6lMlHbOSeQmoebmb2oFob4zKyQRj2C9fNWpDmm0w5w5gMmrJhmNs5W/poPNdTY5CaIY/CI5Ygh0kckNOWUrJJ996cePzDkg3AjCAfDbgBz4eQ+vRlv8f7JY4xluYfb/SKTRbT+exC7Cpe0XjJUWr4WTFhpCB3Zwpvo4ZWYvmYC0k5YFftteaBMIMs5F0VnlenIb3Euob0HMPrIiyby1xfsKcs+J2drL1zrZ8C3Qk8Ama+4FMRHXQupc7i0rLga+gNAa/aos7uexe8Orrc06Xp3HwKnwV3N1gLaJ2MGnNB+ljIESdpLPOh7eJZQTDcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3aU/F1QGA4pBRP5oE82ZdOXdxzxLJH3b/TeTpBfeYo=;
 b=u7cKuegCIQgTOUJtOJRckzhNV4AJUfkQtvOYVCIEaUT76d6tlvVCCRTgGh9NZJG11jh6wyYFMd9tUMntViUTkI0RDdjABKk+DXj0QYKxDeUgUx8jHRodo+G0EsUkyh0gTpVKxzBdXUWnEaiOW+ugNQLTtbEFcCAeO59ytg52Qyc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2390.namprd12.prod.outlook.com (52.132.141.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 27 Nov 2019 21:04:59 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::1c56:6282:aee4:89]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::1c56:6282:aee4:89%3]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 21:04:59 +0000
Subject: Re: [PATCH] crypto: ccp: set max RSA modulus size for v3 platform
 devices as well
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
References: <20191127120136.105325-1-ardb@kernel.org>
From:   "Hook, Gary" <gary.hook@amd.com>
Message-ID: <dcb66129-1cb7-cc67-acf6-07abb4047794@amd.com>
Date:   Wed, 27 Nov 2019 15:04:56 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20191127120136.105325-1-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:805:66::22) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41a174d3-2add-4aeb-6c22-08d7737d766d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2390:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2390742A71E1C95254FA1057FD440@DM5PR12MB2390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 023495660C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(189003)(199004)(2616005)(81166006)(6512007)(81156014)(6486002)(66946007)(2906002)(230700001)(66476007)(66556008)(229853002)(31686004)(7736002)(305945005)(8676002)(6436002)(47776003)(58126008)(6116002)(31696002)(316002)(86362001)(65806001)(50466002)(66066001)(65956001)(26005)(11346002)(3846002)(76176011)(52116002)(23676004)(2486003)(4326008)(478600001)(14444005)(5660300002)(186003)(446003)(36756003)(6506007)(6246003)(25786009)(386003)(99286004)(8936002)(14454004)(53546011)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2390;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVAB9CdCXwg1mL3D2ERkDgD+1+VXW0SzVMuJz6P4FTkTwNs7db+UG+Ry99KWH14prigAyGzaS2Ve5HjsxcTsluC6nBzx4gOjmRvSeMbgMHqUZSLua7zBKqR2cUNLySdByYUkM1UtN/8Gk1dobS0+EHbZ15RDFkOJd8AnJXVig4RFvP+WJ5Nhs6vxbfTclgGMsu1HnruF3cDOWXjUhr6ktUg+chtVpnfRoSxPUsAqgI1ocvTYO7cdbMoTPgsnNyjTeA8yvy2SHdIDoLGCeCxOLVeL8xopFsLhHS01RsVzPsceoImankBoUephsSUo5kqsx3E8UR05N2UPUdpQ+UTWnSXjsWW2ghRDm8bmERBZxgFSV5ELjQCNinrVwF8CyjbtaXeOTlj1gMaEcK0qGuCulYv5xRlEKXLGXVC96RNr/8CHTa/qneE8R5CxCddrSq4D
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a174d3-2add-4aeb-6c22-08d7737d766d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2019 21:04:59.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1+zozXzy6n1GyIkXYZvMr2fEwI3kzBOUb/IshNG2Gadp6QrX7hbQp58jv+WRNrc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2390
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/27/2019 6:01 AM, Ard Biesheuvel wrote:
> AMD Seattle incorporates a non-PCI version of the v3 CCP crypto
> accelerator, and this version was left behind when the maximum
> RSA modulus size was parameterized in order to support v5 hardware
> which supports larger moduli than v3 hardware does. Due to this
> oversight, RSA acceleration no longer works at all on these systems.
>
> Fix this by setting the .rsamax property to the appropriate value
> for v3 platform hardware.
>
> Fixes: e28c190db66830c0 ("csrypto: ccp - Expand RSA support for a v5 ccp")
> Cc: Gary R Hook <gary.hook@amd.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/ccp-dev-v3.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 0186b3df4c87..0d5576f6ad21 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -586,6 +586,7 @@ const struct ccp_vdata ccpv3_platform = {
>   	.setup = NULL,
>   	.perform = &ccp3_actions,
>   	.offset = 0,
> +	.rsamax = CCP_RSA_MAX_WIDTH,
>   };
>   
>   const struct ccp_vdata ccpv3 = {
