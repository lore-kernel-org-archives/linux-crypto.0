Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5803BC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A5A61AAA
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhKOPY5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 10:24:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2694 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232217AbhKOPYy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 10:24:54 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFExFjL002809;
        Mon, 15 Nov 2021 15:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Im3yMmRJk8lWAGg8+ojQVFNRp1uprotJx+U2zi73L4I=;
 b=aC4hF1jphQKXX3t7pI+ohHz/BErnW8/IgZkIxJ8wSrsutJXneemAxGHNCNj/FVlLDNP3
 4B6QP0qnGXEgb3GO8x/Bsl+RsDESy4C/Dp1pnWAhAGhV5UgTQ931sC9Dp/Q226rnQ/U7
 X/BgQKHh9S0U30Q0PpiTc7Kx5cU9WWbr/7UbMYVP+quv/6qweNOGBvSEVsdr+OQO2m2r
 jpx9+7m36QkiW9xJXcrAdK2fMxbVskogxrzS+NTBlXiuM7RWlCPF+5oa+b/FPqStLDI4
 l7z9alstQ9tBYbISwm22kmDEXUPDTvR72jNfkloQ7RNr1TQIdcENrNMau79q5JM+8u+Q EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbh3dtvwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:21:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFFL06h049281;
        Mon, 15 Nov 2021 15:21:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 3caq4r5msf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:21:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jToHfl5LGhfSH617M9S8524Z+qtoOzZ9vIyeboaf3FxNk4fxRAdyy16MXMAQAjpYZtR3hkNPc1/oGTnxSlFWhEuW8F8cXrOYBQgJ5Q+5Oq7Vm/nUZ6PXXBgubQQmRkAYXviyiHGa++nbxO9gP84W0Bg4tVO+r6T4vztMBoGEtZK60jfw+Y1ZCQwSp5TWpYyZSKGh/Nrrz5aiRe5OPdJxVfloLgm0MfnfeGmtxts56ONsNQphgUfEKxXasUUGn07IL3iY4LtSP7rQGx5JxFnnDKt0YT9Lksmk8MJ/H2JJE6RkRInx2VNTPz/TyMs672SmHEKqUMV/rkuPsDbhdkeFIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Im3yMmRJk8lWAGg8+ojQVFNRp1uprotJx+U2zi73L4I=;
 b=bqmOJoxasAluvpIrbz+7nMFLw3fFFNyplpEw8CObh88GDmCUNfoW9jbKeRPeJsdVNwvj5rHRVBlMlazhldWqpFRGcZVFKA9SrxZuSb6j6F53POUMgeF8wYgKFwkTYcDdW3v6algH1L+FhMr0m0aj+9INgsi5zHIpNlo/+yp+0uPdJt+kBZjOHEtF/o/4jq9HcoktlckI+K1+4+ez9lwOm+pxOhQ4XGcv3MhbiyAw6ktQ4SQbo6CUI3GHzO5yb5w3SOiyq02XHEXMbithy0sorck8BstL3o18Avr10KtuCytgHXNXRNM2TD2UguvHA9bH9ye5iWDxadPfneyjewxFSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Im3yMmRJk8lWAGg8+ojQVFNRp1uprotJx+U2zi73L4I=;
 b=FqDwoVyp6qG7sfmFtWKM1CJp5tW2KsvRej2/LqZlp13VmAENGXFVMvEg+6hx0jpwkoqOJTzDR0qjCIRrEtCibrFGaXv1Q++2AVfiqW5IO+st1SLc5FW+M83NInBujjSjn8p9Hm75UPmiJzsA1wjtZjvM7ZP2yuedn+9Wmk/wDq4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4667.namprd10.prod.outlook.com (2603:10b6:806:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 15:21:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:21:08 +0000
Message-ID: <e24cb588-3cc2-7508-8834-4b69ecf2451b@oracle.com>
Date:   Mon, 15 Nov 2021 09:21:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 04/12] lib/base64: RFC4648-compliant base64 encoding
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-5-hare@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211112125928.97318-5-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:806:6f::14) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [192.168.1.28] (70.114.128.235) by SA0PR12CA0009.namprd12.prod.outlook.com (2603:10b6:806:6f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 15:21:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e2897d4-c9d6-4ed2-102e-08d9a84b8c6f
X-MS-TrafficTypeDiagnostic: SA2PR10MB4667:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4667A6BBF236F575DE6C98E9E6989@SA2PR10MB4667.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 25KHTA5be9jDiGFcTQUxBl96jLKkNHPsjuLIoP4TYXNraAapmnl4IG0EU81cbwOJcoIx4sWa196ydFQdo+L2ixxyHiI1s+jpw9CZewVNFsqUNuOBXDUMyowijvj2NLAwQvIbK6Ix7Sfc3raa8c0wKnOiVPzD2NXi2XwIhqVjF/BcOQ/Xk++VctsPkXIUcp66EokwKFXLdc5E9JlBAASv7toljuY3S7fxplHBKpOz4ZH1W3ylSczWKu3Tj4emHU1woCnehRgvLrPQzp3Tz4MN/nBtJkmKpAhuenzJ48zKEp+lUEv4Uf2Urf0jbqszMDjySy0YZlEdmsRMPdEzQGvqllQsrBx61kkmdLkdIpVNv+7vv8gCiuwl6PtGcQZPWT4oUJ8OjVEX+rXnoAFcI2eKy4/Tvr/VzOdhirBfs3db7JedRvjv3Se7vlvsAmAqCoMu3tqZnj/zX0ZH8+9xghNShpdzrVeDwrfgtk1/WN8Mr9H7ZEea0hy3z5GUU9RV+qIRUqgzil9CmddhSZHtghgWqn+DnnL/7l1kw2vnYhNFlHXIlNU8E++jIY2K3QNiE5XkReZxrgEU7MMMgKx5kdoDb7q159TJ6iSYjjVl+dCKmXVFcVPbpdBkHOdlQuT73zCZ+aUMftxo5Imk2QZ4gWLlKdWAB0iAQXiIuipoxOamXE0qNpRouqCPDXCcEvQ+cVEYd+UPljbeqKS3wIqc4NT6ztr01NjC3Hu3ijMskqJYPGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(5660300002)(66556008)(66476007)(44832011)(2906002)(508600001)(86362001)(2616005)(36916002)(83380400001)(956004)(6486002)(31686004)(38100700002)(31696002)(316002)(110136005)(54906003)(8676002)(36756003)(8936002)(186003)(53546011)(16576012)(26005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnMzekN2T0QyTnlyMmxIVHUrTllxNnpwNk5XZ3kyb21ITGxTVWMyTEI3azN6?=
 =?utf-8?B?SXQ2UURFeVJjK0dXMi9DSHoxcCs5cWw4OElnTk5wb25HZ0h0bUsxamdIUW1D?=
 =?utf-8?B?K3FIT3lqQ0FXcWxkMUJZTnhwN3g5c2RTM2xvM0tqY3FqMTVoZGVNYUpsYWpG?=
 =?utf-8?B?WWVSYjRqWng5bjBVSzhuVTNwQWc5RG43SXlzZXFZUG0vdE4rNFU5M1N1NjRT?=
 =?utf-8?B?MC9VVnQ0Mi9RUGRRNE9ZK2ZGMStNS1R6UHZxVmMrY2NOZTdYL3dZa202MXZK?=
 =?utf-8?B?Nk5INTlVellPOC9NK00xR29kRUg4aEMxYTlDV0RMYmZKS1ZOOUpYMzYyeExN?=
 =?utf-8?B?UDRFNXA0NkR1a2R5QnBFaVNmeDJlVVZLT3AzUWFLUnUzV21XOFdWdzY2QTNw?=
 =?utf-8?B?dGtJb0dpNWpxWXZ1NlRZaXpuVzdDUHJVbTJvU2xvb1c1Z0tpNlhHa0RoTmdD?=
 =?utf-8?B?OGRJMHNBV3hhWkpLQnhxMGdXQlE5Uy91RTdha2U1TFZQb1BoTDhrcDd5Rkh2?=
 =?utf-8?B?NXRIb3lja2p4bDlVTm5sRFdzb1gxZGFwWVUrOXlVb3JnYnlqWmJ0cnZhaFNW?=
 =?utf-8?B?MENIRCtTMEdQdFNBREdRYlRiUEN1VGxyZVQ2UklTYUZqK1JGR25Dd1poYlY0?=
 =?utf-8?B?SXJveXRmbWhKSUVWVXlLelVoKzNucVlrb01vU0psWEFwc3R0NWhCZm9PNWY1?=
 =?utf-8?B?SGt2NVVnU080cEVjNW1kSzdFN3NsUU02RjBSZGZ6VjhlRDdrNUx4V2JMaGxM?=
 =?utf-8?B?dHBmWFl5RDJ0YlhGRG16RzdUKytrNTd0NUVIRDFQeFFEeTEvNktjUG9kcjZa?=
 =?utf-8?B?SmFPL0s5bml0dTRSa0xsbjZqc1A5R2orWktHQUYwZWQzdmNSSmg5N3YzQWM5?=
 =?utf-8?B?cjR5TjZzeGhEQ2hxZS82bHE2cDVJdHN1T004R3hFeFZYT1ljclVDYkFSV2RL?=
 =?utf-8?B?dmR6RWF5K0VSU3B3VnA2aGxsTm5nd3JMVklhNDZuVEJ0dWU5TmU2dFovamVt?=
 =?utf-8?B?ODBWWndyK1NvcEFCaWY2c1N1SVE4bmNKc3g0OHNTU3JZVUVFOHh5b1lFWTZB?=
 =?utf-8?B?Tm1INEV2NVlKdkd4dmpkWG83bkdJTzZMZXBhSXdjdW91a3dSKy9PRGVZWnVE?=
 =?utf-8?B?R0pxMDZqZjRmTXJCRFZSMitxeG0rVXV4eGNJZUFwQTd0NUtoaGx0L0FHOWVs?=
 =?utf-8?B?SkZubzNtVjNKenVhbTBsVjZGci90T2d2dXU5Mk0xZCtGUmc0UC9JT3NlbDhK?=
 =?utf-8?B?eE83M29ZL200UDAyekF1RjJxaFpoRXA2L3RqazYzTjJlek5sU1ozY1E4VVZw?=
 =?utf-8?B?LzhVUTAxS2I0VGxIMDVUemk2LzlvcUxWOGhEOEtlRVBvcW9mRWcxOFhuRU9R?=
 =?utf-8?B?S0RpRGkxUXZ2OUtrSTd5UDhPNGJ6eFh0Tm82bmg0V01ua3hIYjMwY0Z5ME12?=
 =?utf-8?B?bVUyN3pxMjZLZStvNU96U2V4aHZCazU1Ym0xQ2RqMExCTko4Um5zUlZKWEZQ?=
 =?utf-8?B?RGlka1hmZTJzMWs0bWMxV0lYSnkwV2hlTzNLWXhXN1htYVdHOUVPdjJmNE0w?=
 =?utf-8?B?RGRGOUtZSkpGWjk5NmQxazM4OVhrSHVSenFXQTBxQy9lUTF2TkQ2a0RBcThG?=
 =?utf-8?B?RmMzVDd5bi9jc3ZINVJ5QkFtMHdWazh5UU5Rd0lkYVNIeEx0dUtpamdMNzl2?=
 =?utf-8?B?RnQrUFZNREJLTTZQMlc2eVRuQ0hkN2hPbDgxRTVBRExMcnNZdVo5NjFCMUU2?=
 =?utf-8?B?dzEyMWxwK2p2dXliNWtSNWE5TTFuRk4xNndMN2F1a0JTUnRLTlUzYytkU1pr?=
 =?utf-8?B?Q1hUTUdOcWErejBNR1QydEV0Q0pFand3QnMwc2dIU0xHZk5JbGUrclIvVEEr?=
 =?utf-8?B?NzRNenRqclVWMFJ2aE43NS8vKy9WTzZDSyt0NTZXWlZuMnBhOHJiaVNGLzY5?=
 =?utf-8?B?MzZQVHZIdnFNbjNTLzVNZWUveXJ4T1lsbmhnaGJZa1JBZHNxMUVNZ2VYbERV?=
 =?utf-8?B?bWo0UWlwQ0FnNEczYUkyaWJaM01ucWR6bDBLTTM2clpkMTYydGYyS21qTmMv?=
 =?utf-8?B?aVRWUi9sekkwK2t0Y1UyOHBZVjltKzBXd0xKZyt6V2o3YVErMFlBUVNib0cz?=
 =?utf-8?B?UENZYWNlUWFSajV4ajBUVHJKSWxCY3Q1QktJdk5KYkJORWRZZTE0bUpmTm5r?=
 =?utf-8?B?bVVXak5aMEJZTkFpVHlidGRMNTlDTVR6Tkd3SmxRbkZsY3N6VFRmVmFkSEIy?=
 =?utf-8?B?Zkw5OVlJdEZpczhlM2VlMG1uWjFRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2897d4-c9d6-4ed2-102e-08d9a84b8c6f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:21:08.3017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hc36ImsgHl4i90tKwzwyWFsRPgEEDPxxEhLPFxkSAId4O1teDnuRUs9wECIJO6lsj3CaYaLHJVD4As6dYOaJIiXfx9h8fUywLk52HAhasWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4667
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150082
X-Proofpoint-GUID: 3vT9m7WtoqgWlqeMHuZx661ZmXOk-a3r
X-Proofpoint-ORIG-GUID: 3vT9m7WtoqgWlqeMHuZx661ZmXOk-a3r
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 06:59, Hannes Reinecke wrote:
> Add RFC4648-compliant base64 encoding and decoding routines, based on
> the base64url encoding in fs/crypto/fname.c.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   include/linux/base64.h |  16 +++++++
>   lib/Makefile           |   2 +-
>   lib/base64.c           | 103 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 120 insertions(+), 1 deletion(-)
>   create mode 100644 include/linux/base64.h
>   create mode 100644 lib/base64.c
> 
> diff --git a/include/linux/base64.h b/include/linux/base64.h
> new file mode 100644
> index 000000000000..660d4cb1ef31
> --- /dev/null
> +++ b/include/linux/base64.h
> @@ -0,0 +1,16 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * base64 encoding, lifted from fs/crypto/fname.c.
> + */
> +
> +#ifndef _LINUX_BASE64_H
> +#define _LINUX_BASE64_H
> +
> +#include <linux/types.h>
> +
> +#define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
> +
> +int base64_encode(const u8 *src, int len, char *dst);
> +int base64_decode(const char *src, int len, u8 *dst);
> +
> +#endif /* _LINUX_BASE64_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index 364c23f15578..ddc5cb4c6eb8 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -46,7 +46,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
>   	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
>   	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
>   	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
> -	 percpu-refcount.o rhashtable.o \
> +	 percpu-refcount.o rhashtable.o base64.o \
>   	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
>   	 generic-radix-tree.o
>   obj-$(CONFIG_STRING_SELFTEST) += test_string.o
> diff --git a/lib/base64.c b/lib/base64.c
> new file mode 100644
> index 000000000000..60d46157da85
> --- /dev/null
> +++ b/lib/base64.c
> @@ -0,0 +1,103 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * base64.c - RFC4648-compliant base64 encoding
> + *
> + * Copyright (c) 2020 Hannes Reinecke, SUSE
> + *
> + * Based on the base64url routines from fs/crypto/fname.c
> + * (which are using the URL-safe base64 encoding),
> + * modified to use the standard coding table from RFC4648 section 4.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/export.h>
> +#include <linux/string.h>
> +#include <linux/base64.h>
> +
> +static const char base64_table[65] =
> +	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> +
> +/**
> + * base64_encode() - base64-encode some binary data
> + * @src: the binary data to encode
> + * @srclen: the length of @src in bytes
> + * @dst: (output) the base64-encoded string.  Not NUL-terminated.
> + *
> + * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
> + * by RFC 4648, including the  '='-padding.
> + *
> + * Return: the length of the resulting base64url-encoded string in bytes.
> + */
> +int base64_encode(const u8 *src, int srclen, char *dst)
> +{
> +	u32 ac = 0;
> +	int bits = 0;
> +	int i;
> +	char *cp = dst;
> +
> +	for (i = 0; i < srclen; i++) {
> +		ac = (ac << 8) | src[i];
> +		bits += 8;
> +		do {
> +			bits -= 6;
> +			*cp++ = base64_table[(ac >> bits) & 0x3f];
> +		} while (bits >= 6);
> +	}
> +	if (bits) {
> +		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> +		bits -= 6;
> +	}
> +	while (bits < 0) {
> +		*cp++ = '=';
> +		bits += 2;
> +	}
> +	return cp - dst;
> +}
> +EXPORT_SYMBOL_GPL(base64_encode);
> +
> +/**
> + * base64_decode() - base64-decode a string
> + * @src: the string to decode.  Doesn't need to be NUL-terminated.
> + * @srclen: the length of @src in bytes
> + * @dst: (output) the decoded binary data
> + *
> + * Decodes a string using base64url encoding, i.e. the "Base 64 Encoding"
> + * specified by RFC 4648, including the  '='-padding.
> + *
> + * This implementation hasn't been optimized for performance.
> + *
> + * Return: the length of the resulting decoded binary data in bytes,
> + *	   or -1 if the string isn't a valid base64 string.
> + */
> +int base64_decode(const char *src, int srclen, u8 *dst)
> +{
> +	u32 ac = 0;
> +	int bits = 0;
> +	int i;
> +	u8 *bp = dst;
> +
> +	for (i = 0; i < srclen; i++) {
> +		const char *p = strchr(base64_table, src[i]);
> +
> +		if (src[i] == '=') {
> +			ac = (ac << 6);
> +			bits += 6;
> +			if (bits >= 8)
> +				bits -= 8;
> +			continue;
> +		}
> +		if (p == NULL || src[i] == 0)
> +			return -1;
> +		ac = (ac << 6) | (p - base64_table);
> +		bits += 6;
> +		if (bits >= 8) {
> +			bits -= 8;
> +			*bp++ = (u8)(ac >> bits);
> +		}
> +	}
> +	if (ac & ((1 << bits) - 1))
> +		return -1;
> +	return bp - dst;
> +}
> +EXPORT_SYMBOL_GPL(base64_decode);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
