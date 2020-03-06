Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E711C10DCE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 15:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6572073D
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 15:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="EzX8qvfx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFP4T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:56:19 -0500
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:6111
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726269AbgCFP4T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Mar 2020 10:56:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HghzkYDHRq69pvY+fggdIPMF+HfmflcLXtARau94oSMmcKbv7n8IntbEzcbbG/2ouVIl6eGpYXEdHCjehDJJ+tKAsOEyOz8VXx76XnikrqplE5d2W3Ak1VwvUkWpFJw8s10InqSdG5U/sqFjVj7VoLj/ohz/77H1epKjdfHApsGTzAWoApo20C/XBCWN/v42bEu9jc3LR+K3J/GU0oSGYxnCrJt30WAkCMBMAcEwefNA4Dt7Ifmjg7JE2JdPn+gxjDakQMu523z/xuZrfupoR+RzreIX4NIFF/sLy/WtXF83HzklaOBi87/ZczwopHod2/29TtER0xiHr3neJu6LLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM+THY1TIN/GvSMIsa+6gMNlAmmUcbdxI05htCNGaDs=;
 b=Tv/aCA0kRh3rTzVSiD0ZA7Co9LWxEs7czWRjb9z3PAuylmwMKF5dxzX9tSPdpTi9WcnjyU/Dhkk1raHWPKQNZyU5ZErEazcgdJjuepzR6+TfZGAeKwOD/gZOpp0Xi89ujQuZnuJnx8SN/9Glw5BQkv1QkEZXvFeRRCmx/OLRBGCcEMX7VbgwnXyUi2cclLmfObny4Ok2Wyrbyf6aSrpfpypLMj7QZuiFbcH9HGdv1FVlUsHNTU+mPkWTed+LZWJ7OmwQBTx8wMqYOVralonzvA6D7VNnZjWaCwtV6T0uxBmFod/WcymgFCOpBigCBXYY6iwffltWdykNUvgQmlv/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM+THY1TIN/GvSMIsa+6gMNlAmmUcbdxI05htCNGaDs=;
 b=EzX8qvfx1gK1BtJ0o93okDlhC/8f7Tzua1M+f7aCQnXO380reJWQAXdEAswBl8/23T6ij8IhuvqbWdHcm8MhI0RKd46UUIK184Hw5kTpp1+LQ6oN6sVPhOoplCNjGU580gVtM81DCY0luNIIBPmUR2JjF7VGitLOqhsCOcx6TNI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from BN8PR12MB3154.namprd12.prod.outlook.com (2603:10b6:408:6d::10)
 by BN8PR12MB3297.namprd12.prod.outlook.com (2603:10b6:408:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 6 Mar
 2020 15:56:14 +0000
Received: from BN8PR12MB3154.namprd12.prod.outlook.com
 ([fe80::fdf0:c7aa:3bd7:7d51]) by BN8PR12MB3154.namprd12.prod.outlook.com
 ([fe80::fdf0:c7aa:3bd7:7d51%4]) with mapi id 15.20.2793.013; Fri, 6 Mar 2020
 15:56:14 +0000
Subject: Re: [PATCH 1/2] crypto/ccp: Cleanup misc_dev on sev_exit()
To:     John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        brijesh.singh@amd.com, bp@suse.de, linux-kernel@vger.kernel.org
References: <20200303135724.14060-1-john.allen@amd.com>
 <20200303135724.14060-2-john.allen@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5bda6954-a4f1-117a-30ad-8b9737b835fa@amd.com>
Date:   Fri, 6 Mar 2020 09:56:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200303135724.14060-2-john.allen@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0081.namprd12.prod.outlook.com
 (2603:10b6:802:21::16) To BN8PR12MB3154.namprd12.prod.outlook.com
 (2603:10b6:408:6d::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN1PR12CA0081.namprd12.prod.outlook.com (2603:10b6:802:21::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Fri, 6 Mar 2020 15:56:13 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99ad2509-c139-4236-ff9d-08d7c1e6e62a
X-MS-TrafficTypeDiagnostic: BN8PR12MB3297:|BN8PR12MB3297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB329744C4653EEC65B15D8757ECE30@BN8PR12MB3297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(189003)(199004)(2616005)(31696002)(956004)(316002)(86362001)(4326008)(31686004)(16576012)(53546011)(52116002)(2906002)(36756003)(26005)(186003)(478600001)(16526019)(8936002)(81156014)(8676002)(81166006)(66476007)(66556008)(5660300002)(6486002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3297;H:BN8PR12MB3154.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8zm1uV+t3lFWPCU3BWnkfQ7BWZl30FPJbGRjvDKubgSfACw5cheWGge/JL5JW84lDXQFdLHST6wft2GKjyXj5YriLv/5xppqm33ypbG3/mvwLH79Z1Ak2+ArnTEiGEZcLeXDIGCzvplorPjgVlmeoXpqXKP/ursde7wQjxnJ8cz9/i0isdsKZjMU3hpTgq86XX7CJ95XNVw+S8RzLYA3nJTMhJ73sLmkflULEGth75T2mDcM/K+KF3FmgbDCn/TZH23cCW2XAWunyXDQQboDIbXQYJ7T7XF6vaF8KaYy+PrNsi0archceBV/cyARpq7c3+2sV6ED6BhCHiKufb0E27ubr4/VhnyBP2h+D7YuyXI8BJJfgZ8oFHytd8tEAxb59pIEtrfMHUysZ1beBOJIWYWO9iNE4KjyUP4s0en+6BH0Ljp2jySzQojLIatcfBv
X-MS-Exchange-AntiSpam-MessageData: twse+rDvlHD59vjHzXP2RG3BoWh4ieLZzkQHGnT+5bX/8a2jay9XTC8e+FpVC8vFh3//B6+NPIM1qwxJwgg8QlDNgJLjUAkrNbSvhnQiKCe6MoS27W2te44gZbFKAxTUeD1XP69+cklzM2F8aE8rkA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ad2509-c139-4236-ff9d-08d7c1e6e62a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 15:56:14.6579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP6uCcJB4eWkhqXSwBXFm0TUZWG//NbflzVKneADY3tT7c+3zJl98yomFm1pKs+Cpz9uNorN4d11muJxjL2Wtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3297
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/20 7:57 AM, John Allen wrote:
> Explicitly free and clear misc_dev in sev_exit(). Since devm_kzalloc()
> associates misc_dev with the first device that gets probed, change from
> devm_kzalloc() to kzalloc() and explicitly free memory in sev_exit() as
> the first device probed is not guaranteed to be the last device released.
> To ensure that the variable gets properly set to NULL, remove the local
> definition of misc_dev.
> 
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Signed-off-by: John Allen <john.allen@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e467860f797d..aa591dae067c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -896,9 +896,9 @@ EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>  
>  static void sev_exit(struct kref *ref)
>  {
> -	struct sev_misc_dev *misc_dev = container_of(ref, struct sev_misc_dev, refcount);
> -
>  	misc_deregister(&misc_dev->misc);
> +	kfree(misc_dev);
> +	misc_dev = NULL;
>  }
>  
>  static int sev_misc_init(struct sev_device *sev)
> @@ -916,7 +916,7 @@ static int sev_misc_init(struct sev_device *sev)
>  	if (!misc_dev) {
>  		struct miscdevice *misc;
>  
> -		misc_dev = devm_kzalloc(dev, sizeof(*misc_dev), GFP_KERNEL);
> +		misc_dev = kzalloc(sizeof(*misc_dev), GFP_KERNEL);
>  		if (!misc_dev)
>  			return -ENOMEM;
>  
> 
