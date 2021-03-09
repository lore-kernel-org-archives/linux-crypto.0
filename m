Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8D4C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 16:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9760A651BB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 16:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCIQgP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 11:36:15 -0500
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:64800
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230491AbhCIQgG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 11:36:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIUE3WXHl37oQLPmV6EO+cnVZ30r11B2bwOdgNtWRF/ezcT9aPL0RDXfQXIavSDl7yaACREv2xLc5uIys2+eWdaqUS3bxE3vJxT4jAbSGz9MI3/XCN+p8fZzs+wi2y9gfPLuwzXrH7ME8Nx724TVoIuAkB0T4bpzRre9JHzbKj0D+t6WA0MtCuum4Y9jeao2zoauyusZZCeBeef10j5ZtPM7fAisUvCvH5BsjRySFy5tNNtWnXlOnOkZeZzJyScsU6Ih9R5wdT6sUhCEKLZI23KmmdCqlfLER90wiwZf4pION+mCITUW+BVxFTep247/THFvYlko9BpcZTUzuvZ/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inFjzHCc3ZFfZeTonuvI3EiTWcndFCC6NFAi8mTqFnw=;
 b=fUi9+H9mGWvKYUbVLXqbjM0tJqtu/srhQUdBOF8MN62SR2vNCBvhiLYKFqZRsfzey+NdWCFMKmiFahyHCQZITYpBArgn156vw+PPTXkAL/Eo+36GREt9Ep8d089dRNfGrgy9PK6wc/n04LsD8mOV8PsCNlF/80dWd2x7Ve8NOLQ7Mecnfz4RTUGvAZDJJiQmEjGCioecRD/YXHccBd3MZMShSGMz+6ISkF6FV2+tVd9Y+1ylPou9gjYgyFk7KL7tRlX4HSWahKnvIc8K8u1zlqN0aHSDqxUHM2Yp4Nz4yEZZta5Osi+Esn5ISJZ4tdLq/27BokE0vIo7Z0lfKgOS5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inFjzHCc3ZFfZeTonuvI3EiTWcndFCC6NFAi8mTqFnw=;
 b=fb++egXvGz0RrER0n3Et7BFFZy4ml33IulzI8KTFwKqBgN1Cwc+UynPGLVJARBp8H/dQ2EE4vR40PI2yOZOTefCZBBJ4TEvKD5k5Hx44QrCmsAQaAzjIh4LEPHp/gVgwEZecwEcF2zHo4BuhB8p04v0Gh3JfwovoE1q9zsNDNOg=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3690.namprd12.prod.outlook.com (2603:10b6:5:149::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Tue, 9 Mar 2021 16:36:03 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 16:36:03 +0000
Subject: Re: [PATCH 0/3] PSP TEE driver update and bug fixes
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6f036523-6eb4-4b74-c22c-e45a98f63f86@amd.com>
Date:   Tue, 9 Mar 2021 10:36:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0208.namprd04.prod.outlook.com
 (2603:10b6:806:126::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN7PR04CA0208.namprd04.prod.outlook.com (2603:10b6:806:126::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 16:36:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcf9878d-19da-4061-1398-08d8e3196e1b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3690:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB369054EBB2BEB238E9D9B0C7EC929@DM6PR12MB3690.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHT4GigCShnlCcV0x4UWLwLzaqXJhACW+/si7sLZzucvqhWg8Hxhn6v4LUzzomWENHpRs625ZRCNVOpdO7pBuFHy21XE+N5X6/I+aJTwLv6Zun98VIH3hf29v1ufsN4MJkYjxavmpHsXfZTFvMKDaBGFYGYl0DVPDlzUox0uGVx2wiKlnz5RQPBnWpf18RX3vqhq+9GBPrdPT1dywoyC5olI732YlIe02RzytGmycdvBMWk8L9e6lrjVAxeqJBZkTMN/kyFKqFVvAI4QiCdv3ZeLfzahGcINcWMT1QsAl5S2sEP85XgEqVAqoGRhjNUayN+Jr5+vktxYlb8+mcjEaMoH7pTWebkj6u3+H2CFkfFyvJiXOpOyT3yqFwo01BI/doplfPbWAJ7htLFH72B7OEuTXpwcAMZImQw5+4PNKITVm2JRW3P9jwPhshnDS+P5AVVsbAsRQ8zuU/Xj+oHoUObeg3cZl5qPTulMlCWejbsv3ICKiqgeNrtCrY3sDY6hJ/owLsGPb7oYwJNL5O2ZmJ68/ZUU7xVg3bVczsGrJnXOVIHaCD+ISqbJbQTqxrxK7WnZKajAuxMB5c9ZQ8NLxA6CdEIoSLkNZXGRJchZNUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(16526019)(26005)(36756003)(6486002)(31696002)(54906003)(83380400001)(16576012)(8676002)(52116002)(2616005)(110136005)(53546011)(8936002)(15650500001)(86362001)(956004)(186003)(316002)(31686004)(5660300002)(66476007)(2906002)(66946007)(478600001)(4326008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aFY5eHB3QjQ4ZGZMTldjaG9yV3hRNE9vZHdLVU1paTFidUZmalgvQWNZMzQ1?=
 =?utf-8?B?S1hOMkQ5ejRvWWtFanNaeEhkSG9VZUlxZXRVRFFDeEFmYThocVZYWExtejlU?=
 =?utf-8?B?eG1BcWtqa0VaSEthYlp2VUUrS0VuYW9VUGw4eHhpVHphUDE1WnVHUkhaaW1a?=
 =?utf-8?B?QXFsZlhNQTdHZGE1d1V0am5rSzV5T00veDFvdXg5WUJmZGo2Mi9ZVXZzbEdK?=
 =?utf-8?B?VDZTMXJ2VmxiUUYyMWxhSEIvbTNkMVRCelU0V2lOeENkcmhWQkpqbi9LdkdO?=
 =?utf-8?B?b2NWRjBRZmYvQTVtdW9FR2pYMDYvR0wzZGIvd2hNUHl3WVpJNVh2VmdQaldM?=
 =?utf-8?B?S2RNOTlybTZJRkw5bTdlYVA1dDVLYUZJZUlPNHdJa3pXL2tEeS9iakV5RExr?=
 =?utf-8?B?b0ZlRzlvbU9vMU50RndGK0FBWG1HME8raUI1NUJNL1pDcTVNd2dvc3Z2YnRi?=
 =?utf-8?B?QUp6Mms3NW94QkhUQ3FaVFpsa3JZb0ZiZDNDNXBXZ2N1SUQveWh5UFhtM3Bn?=
 =?utf-8?B?a0g2eUsvcVhwSUJGdU9TZlpZYTZBVEs4Zjg0dTFWL1ZTek9CYWFWWFNIYlIw?=
 =?utf-8?B?K3IrRGF5OFNOVXoxY1lhUlQycjJKMDRKaDZmVGVobytQdEYvSDMzYXJMQ0ky?=
 =?utf-8?B?T3VNTTBmQ2NYc2VrWFpJVVZ4UklNNXA2ZnU1aWRoeFYwNTlOdTVNM2RFNi93?=
 =?utf-8?B?L3ljSGdBbTJrQmhuUktxaXljTll0S0ZTOEt5d3VRMVhKVWpYQjRvZUZoVlMr?=
 =?utf-8?B?c2oxTVZzYmltQ3dXL1V5WVJPTkw0cEpINU5tQlNTQm1GdkJaWHVxRUlSMFJh?=
 =?utf-8?B?RGxVY3BhRWZwZUUrcmt1QzZCTkI2Z0UwOU4rWDlWekZwVUJtTDdJWUVlN21M?=
 =?utf-8?B?WElHQzc5M1JxTVRnSS9ML2UwZHJNN2dFMDRGTDdIREFySGpyVFdoeDFpV1pP?=
 =?utf-8?B?TmZpNXZ1d0dheFZuM3A0NktMNWI4aXVGbTRMeHBmK0hFdmFsWlVPckNFZE9V?=
 =?utf-8?B?OFNwN0Vxc003UzM5UTU1TVBxeDVRY2xOSklyOGFnN1FJSFpnNUhVdkFYV1Rt?=
 =?utf-8?B?REgwRHY1dzZyNGZaYkNMSVRqSFpaaDZlR25MV0x3V2l6cElhMi9vbXJJVnVx?=
 =?utf-8?B?RFBNUnBrd1l2UjQvTDF4MXJVMTg1QTJKQTdFK2o5aWVmaEFubjFldkxnZ0dR?=
 =?utf-8?B?VG0vcTl6Z1haMXBUMWZUQ0hGVmE5RHEyQThVUWF3ZHJDWnM2dG9Id2N0b2t6?=
 =?utf-8?B?Y01yY2pWbVl5SXBxNEpLSUdaTzJESDRiSzUvMnBCQ1Y2YXFEWDlSdWNlNjk5?=
 =?utf-8?B?RUVKWnBrSlg2KzJYQXhCaFZUY3o4OUc5OUprc3lHMjA5QTZ4bGJtOWZPeFg5?=
 =?utf-8?B?UHgxejQveE4wZzFaN3RiTlVEci9RQ203T2QzdXQxMjlVcU9XaWZDd0NVdE1v?=
 =?utf-8?B?WUJBNVFCaXVxOTYxVTc0WVl2Wm00ajdwZU8xQjc2RWQ4REpjZzJXVFlDbnMz?=
 =?utf-8?B?eEQrTjgwVm1Ec2ZlQlJUY1BMa2o2UEhJY0pibFE2NXhld1BoOXFkSm4rUm05?=
 =?utf-8?B?RXorVithWVYvUkV1cG9zRjhiNVRsakJLVHd1eE9ablFkbDhIbUZqbVdURTJt?=
 =?utf-8?B?Q0wzaWZKaFZRN0tQQ1VtUXRuT0ZrT1VZcWhPTjFjS294KzExMnhPRTBMVXdu?=
 =?utf-8?B?QWc0dllPMjVtaG9HR0loYTg1Z21wWHJodkhwMFBUdldxaWF2WmtiYUFEQ3lM?=
 =?utf-8?Q?XE7kUkThzHuk7Ww7gtYuNFpMyfvXbbD42Cfnwhc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf9878d-19da-4061-1398-08d8e3196e1b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 16:36:03.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13vpx1LkwdvYuGt3XCqT3bYOUsAWy6KqFj+9ct1f8GN4VJpFE+EOK2b0SvFacSXb0JZWxbeExH08Svta3wOWrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3690
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/9/21 2:11 AM, Rijo Thomas wrote:
> The first patch helps to improve the response time by reducing the
> polling time of the tee command status variable.
> 
> Second patch is a bug fix to handle multi-threaded use-case.
> During testing, race condition was seen due to missing synchronisation
> in writes to the TEE ring buffer. This patch helps to resolve that.
> 
> Third patch is to update the copyright year for the tee driver files.
> 

Just something to think about and not as part of this patch series, but
think about submitting a patch that adds you as maintainer of the TEE
portion of the driver (see how the SEV portion is handled).

Thanks,
Tom

> Rijo Thomas (3):
>   crypto: ccp - reduce tee command status polling interval from 5ms to
>     1ms
>   crypto: ccp - fix command queuing to TEE ring buffer
>   crypto: ccp - update copyright year for tee
> 
>  drivers/crypto/ccp/tee-dev.c | 57 ++++++++++++++++++++++++------------
>  drivers/crypto/ccp/tee-dev.h | 20 +++++++++++--
>  2 files changed, 57 insertions(+), 20 deletions(-)
> 
