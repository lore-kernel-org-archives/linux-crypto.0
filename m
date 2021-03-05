Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0ED3C433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 00:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA09264FF9
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 00:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhCEAE3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 19:04:29 -0500
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:7409
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231840AbhCEAE3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 19:04:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwlqbkDzFM0dpyaMRppq1EYF0fp1jCFlUIttBqFoXEubgCd84r3tsyMp282rOjhtFNdQ2iiFz8cxE+mJkIhcfHdShT/5CbotD4f7t0j0eUIpwSI66anHOqx3K3vsqdNRZ6ERhxnORWeaVQHq+qMwod9g6tBRT/c3ANZfH0XBvlOkco54/U6fsFdqFBiKurn9ekKSK74a3mEd9PO1+VjVU6kbaKxlJkFYDrm6iw3iDEmawqzR1hjWiHwD1fJYKn2MCc8RVo3AqrdfdnoxUJyLIbl1XrXpO6aS/BKj3dLXRw19l7PkVTnauWAavhBY+A76RA9N5a8GQvUIiWFpR8l5LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msMkOVMaJP8Xv2pnmbcFunK2NqKOCK13CaPouoPBPu0=;
 b=CA09z7bl+iNWMjKkjOuIqay1jBp7rME2W9lSo23XK0pn9pxIYqpWOGXD0L3CpuNa/RNWnX4wAJYDn+ymYHgMxDO5OiN1ovSIWC80BBA2pNyAY4IbYsj7KyCmpbAqNtjm9KN1IeYuzIaSXLHCBkJtS+KejzH3lV7QuYvGzXpaUxxkKB99Oi0036XuRv59eJInGCz0HeIdmXQvwCQSoLdLdN7FQwP5QIwrrCXxwfRpwF3Tbr8mVbavY74EbArZIpPaNIUshpwyxEsJ5kkc055TGGjg1VH+pydOPpkXMV0ZrW7ddWK8bppe0gaNQtMXtLvcE1U9puVB2DqK9uIgB/iYug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msMkOVMaJP8Xv2pnmbcFunK2NqKOCK13CaPouoPBPu0=;
 b=r4RuRjW1QbBJMJwZnVrRRP4x7sP1EmYBx/mPtdGmVOFhCWuk2A7axAshSsacOFm+pDBFtjquVcNbvP1mYBN9KPfwU3H0yZO4G+kgkbThDQppfbfwtOYi8tKePhET09EvCqoOz8rTj6npo8uiyA85MJhe1exXYk++VMdy8LbJlW0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 5 Mar
 2021 00:04:27 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3890.032; Fri, 5 Mar 2021
 00:04:27 +0000
Cc:     brijesh.singh@amd.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        John Allen <john.allen@amd.com>
Subject: Re: [PATCH] crypto: ccp - Don't initialize SEV support without the
 SEV feature
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c1ea9899e6169bf3a3042866e165a2f90bda3ebd.1614810669.git.thomas.lendacky@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <802f4e75-6e77-c48f-464d-9abcdc53bd8f@amd.com>
Date:   Thu, 4 Mar 2021 18:04:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <c1ea9899e6169bf3a3042866e165a2f90bda3ebd.1614810669.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0701CA0022.namprd07.prod.outlook.com
 (2603:10b6:803:28::32) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0701CA0022.namprd07.prod.outlook.com (2603:10b6:803:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 00:04:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26b6b142-8c60-4895-1667-08d8df6a3db5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495BF4752B6FABD5BFD416AE5969@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNFENpr4LA5MtnB+Cr/ZLOiR9XtsNGEBUUEVq7kk8LZYv2hnUd+balZvvm6wV/jRp7M855wNY9syzGPHPOrHizMOMM/DViQLJTsG8m6YkxuM9accgkmmIcjU9PnH2eJmhAqtuaEuKDXsYDt3KRcchGnB+gUabUew/lopiZU9tgmYk/tXTJkOEqairV08Wx30IDzNMULdD7Wt3mYtNJd22fTmJNuQdTFlbM4PcofMdSeWCKr6rQpaZcfgeQgDIFLBHa1sgyXGUeszTYXDUrZBTXpKmvvAv/lH7UOBdBFI0JCCljCOycW8KLMM2f4VQS3vhbhuqxivYUf8upo0ji5L2pivjn7KvGRd+PYlqzPPtyiRSTzSRepv5MN+lPr++j4wF4di9EoF0gwIeLwPwGVIE2nW5ijA5EaTBzHto+qpyIOTklmydgJGReU7d6OO1O6GkNtp7Cy/NNdb5Igs1HZ6L1g0ioRd/igy07Iuc1Mj7jq+7+a8tGSKnMx1uVe088fd82O+rmTlJ+aOD3GOi0NdNfIcpzE47Yq44II5Am/L9mY+THsrh1dlMiEkP+E6KME8SvWkvUDEmTlpWCsjP5bCokwWyeNYrrbycYjwAoSa+HQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(26005)(6512007)(8936002)(4326008)(186003)(8676002)(54906003)(86362001)(52116002)(956004)(2616005)(44832011)(83380400001)(16526019)(6486002)(53546011)(6506007)(66946007)(31686004)(31696002)(316002)(66476007)(2906002)(5660300002)(478600001)(66556008)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TlJ2TjZkS0NTdHBLdUo4ZnJjT0FYZ3RRRGZDUnBUMTFXK0NFRG1Za1B4YVY2?=
 =?utf-8?B?MXFSbXpDODliTUZtY09leWlLN054eFpFNnExOFovazJXVjZ6UTZuY0E4aTBQ?=
 =?utf-8?B?b3JuNjFITENhVnZSa1p2bjQzRnRoTUo2ejZxUDJFd2dsUytOdjM1TkVFUXJi?=
 =?utf-8?B?cmM1ZUxCVXJRbzlweXUxUUFYdm1YVHh1QmU4Rml2SFpPWXRSZHZZMFNuRDNB?=
 =?utf-8?B?YmwvNGhFNk9TdnZlTUkvNU95VXRHcFFPQkl4WDJmeXVoT3NlVWRSRHZoaDhk?=
 =?utf-8?B?N1RNNWs3Skl6UXFFeU0vTkJGRHlXOU0walhtd2tDdDBEK21nRlRzOThsQUQ2?=
 =?utf-8?B?OXlnTUZaTkg3S0Rja3RBb1l4czlVRWFVVC9tbHdNYlN1SExlNnl2cTRGcS9p?=
 =?utf-8?B?cW1za0YyK0xWWENTTHFuL2lja0NaNmlCOGdzek1XMko3MDVSR2FZRjlJMlVj?=
 =?utf-8?B?T0o5ZC9JUHNTQXBnN3dPZ1VMU0ZYYkppTmtnenBrWW9iazF5UW9iY0xXb0Nq?=
 =?utf-8?B?TTE3V05nOEJ3N29IczdoYzJ4YmhUcGQ4bkxRK2Z1WjlIOVRPRUdJSkRraFl6?=
 =?utf-8?B?d2RoMGNmQWhIMzdycVc0bnV2SWUxdE5oeVlpY3paMThxTThVNjZnUzNWcTFp?=
 =?utf-8?B?R1NoM3NTQkE5eUVFdDdCR2V6REhZVmhNamFOaWlNTEFJUGczSjF3eDBPckp0?=
 =?utf-8?B?NDhmVENVaE5uZjNVdEFiSHFVZlVzWkVDT0lGUTVYSWhPemx3K081UEdxRENv?=
 =?utf-8?B?aXFxVzZ3dmpPTmtLbTgxT3NSYjBKbnFNODdkRHFDNEpYU1FkN2xlU0FZNktj?=
 =?utf-8?B?RVJycmlzaHNPNjBDc3l3UUhiM1I3aFJjK3UzdkxacVo2akYvQUJQMTlTZC9l?=
 =?utf-8?B?Nzg1cU1RMWZ1dmdzelgvOUx1bVM1WTFOYlFSWWFVL3B4TGhMK1hsSkQ3U2hi?=
 =?utf-8?B?OHgyQTQ5a3pRdUNtbFJleGdPcHZMajIzbnNrT3pxRTFPK0h5RzB1RkF0L3VU?=
 =?utf-8?B?NkdOUHArcEYvcVZwdit1aHJFVXRuL0hLckdYRG9vRDI0dUhXSzQ4TUs2cmdY?=
 =?utf-8?B?RFdNbEd1N3QrTjdLWG05SjMwSmJNSFZBelA1cEZyOXc3cEVrS0k5L0lNMDRH?=
 =?utf-8?B?UkxvS0gzWTNFeWJmZlFjZ1Y4bnE1TkdyNnRWZUNMQlpqUEZvWVFabXRtSTJU?=
 =?utf-8?B?dWhmcHlSL3FzSlpaQitzMjBBR0Y4YUVHUFRHQVpOUU5RaTZneTNiRmZFUXJv?=
 =?utf-8?B?WXMwbFV3dTdMQ0lubk1HNHBWSmpJQWo3QnFIZDIxblJKQ0xwcWIydFlyYTlG?=
 =?utf-8?B?YVFnT0N0MDJwOG9lZEdQOTAvaXllMG9qOWhDNkFrODRucVlaNUE5YTR2Uk1G?=
 =?utf-8?B?Z0tsdERialZiYzJGVUttQ3VBMXUzSWZqamN4eXpXYXRWa2pXNjNyREMwWDB1?=
 =?utf-8?B?SEwwQUo3cU4vNEhRZDVVTDZoa2VISy9zRjJvenVydTZ4OExxZmFlcmJ1RW9z?=
 =?utf-8?B?aTROVFFvM0RsVnl6ZXlMaW5tdmQxN01pbXFrTGpGRDBtOEQ1LytsVHJ2K2N0?=
 =?utf-8?B?R1hrMmxQalhqRE9NanJSL01JbEcrb0xnZWYvdU9kVGcwZHJLOEZDVnBsZEFT?=
 =?utf-8?B?WmhzQmRWT01SRUNiU0FaNFdua21GT1pvdEJhU3k3SUd6MmlEdWIzRkJWQjY1?=
 =?utf-8?B?SDFVYU8yYnZSRE90TVVjMS9FZmx2WEd3bjFHcUxCcEdxcXh0czczRXNKQTJG?=
 =?utf-8?Q?c4m7r17CLhGbcp30oQoNGA5hWFbVnrmUx7R2YW0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b6b142-8c60-4895-1667-08d8df6a3db5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 00:04:27.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vONwrTUHSJaqxdvbqZDpeRvCb5hVd6VvxnFhrevSZ58jg9aG/l8YE0b50wyP9ezZkyeqkpIu2bs2vqxLA6L3vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 3/3/21 4:31 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> If SEV has been disabled (e.g. through BIOS), the driver probe will still
> issue SEV firmware commands. The SEV INIT firmware command will return an
> error in this situation, but the error code is a general error code that
> doesn't highlight the exact reason.
>
> Add a check for X86_FEATURE_SEV in sev_dev_init() and emit a meaningful
> message and skip attempting to initialize the SEV firmware if the feature
> is not enabled. Since building the SEV code is dependent on X86_64, adding
> the check won't cause any build problems.
>
> Cc: John Allen <john.allen@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>


Reviewed-By: Brijesh Singh <brijesh.singh@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 476113e12489..b9fc8d7aca73 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -21,6 +21,7 @@
>  #include <linux/ccp.h>
>  #include <linux/firmware.h>
>  #include <linux/gfp.h>
> +#include <linux/cpufeature.h>
>  
>  #include <asm/smp.h>
>  
> @@ -971,6 +972,11 @@ int sev_dev_init(struct psp_device *psp)
>  	struct sev_device *sev;
>  	int ret = -ENOMEM;
>  
> +	if (!boot_cpu_has(X86_FEATURE_SEV)) {
> +		dev_info_once(dev, "SEV: memory encryption not enabled by BIOS\n");
> +		return 0;
> +	}
> +
>  	sev = devm_kzalloc(dev, sizeof(*sev), GFP_KERNEL);
>  	if (!sev)
>  		goto e_err;
