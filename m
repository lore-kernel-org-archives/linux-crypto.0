Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39521C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A5961AA5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhKOPYB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 10:24:01 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37484 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231592AbhKOPXs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 10:23:48 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFEmmXt000658;
        Mon, 15 Nov 2021 15:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=YXOhWM8mBV8qq/3K5lVkv6yma39qmug2qt6OvJuRYkc=;
 b=lthcMS8pczMyrovHdtbRpEXGEQLjV+8DthO4cm/s5ZE+eHKc5imE7WEforCgKflFZr9s
 +3r00C3JlTzYErBA4FAknLBY2/o+ztNIT5b0DyGZh+4cL13rKt1XoJXWhTu5eqwwedFm
 vMtx+9G2kz/uGKMNKUTT61LTlb63v9FOWcHYgt4OmwN9k6Q12CL6WRtLv84/S5Ad8hP+
 sSjqpd5lV1cx/fcfa1csZKOJuM8+5WRK7dbsYm+fmRngLm019wVzQl9id6ZMWPcNGBFs
 LREsFsy66tXGFT3eTykXM83C6cEltko0qx07oD39x/2nQxI9XD5VkcBocP680Q45G3lk Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnjvcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:20:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFF0ONV048403;
        Mon, 15 Nov 2021 15:19:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3030.oracle.com with ESMTP id 3ca3dehrht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:19:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjqVSuih8VQ767EPyuDAHc7a7I+Z3QEXEoH/SF6RHdkjGarAgLe6J2f83R4MKSiuoNNfXCANlr/Igw8sND6wCjwv1rKwe3V1aY4FusUAUcomgYkUU6IwLslAKl2p5/CeKaw2aLszfWhyWZ4vent6+1F0mJz7FDm3qre8109S5+6wNzQBsQ5uXng5kTdFPpQ2OhK/WQ43PSMbSPbHgb4fhsKn5/A4VQaowjqwRh3ccEHn7mUWAzYRw/RDjY0HGGS2YxICkf5wfqrSVOKBJNIzB3hubak+8sXhj7dUXJfqsuWu+vsMmDktMqpPowQ6kFIpXgVitAroj0eVgepOBHIZgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXOhWM8mBV8qq/3K5lVkv6yma39qmug2qt6OvJuRYkc=;
 b=BvEsoC5hC7f8Gv87WB6ncbOiQGKm5UjqQQ3gGLTCaYnlnS1jO++HuQXbjYpIkTScIncNAHK+eia+F/Jks+w40Z4JjP4xcqDJXdal9AiQ8ivjU9fMYoTZUbeL17XFB4LGezaYtknJlo0vn/dYNkU3ZZsa9/OIFeZF5JtHiRdCuTxUqki+E793jx1L57yJvQ1PrzDHQZ1P7/jVsynaAcgy05LUKajQ+OgqI7hzC5jZLGYKfZ6TmtQewErJRtAO0me+kHigFnxbWJSl9OnqwUB31y2iM++b5FTHmjrFnmml9/Pf1HXQ/S9N05d1hQ3MS7LrKma9drk7H99bs629aKFWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXOhWM8mBV8qq/3K5lVkv6yma39qmug2qt6OvJuRYkc=;
 b=vVchrfSPwlmVk6nbva3YZ9/ihznZeT+A89LUb1xGU0z5d0mka/95mEhOG7reUtqghom6PMM/G9GQgPa0PGf3YJAeM77buhNgtHxD9FV2+2ELPZeOYTR9dZYnbuF9Fogpr3D4xHg4dBSosYU05v0GZVPL+ke+8HhCoNnJ7+vhKBs=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN4PR10MB5638.namprd10.prod.outlook.com (2603:10b6:806:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Mon, 15 Nov
 2021 15:19:51 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:19:51 +0000
Message-ID: <b1133dd1-a5a9-de1e-e57f-1b471d2e513b@oracle.com>
Date:   Mon, 15 Nov 2021 09:19:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 02/12] crypto: add crypto_has_kpp()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-3-hare@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211112125928.97318-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:806:6f::14) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [192.168.1.28] (70.114.128.235) by SA0PR12CA0009.namprd12.prod.outlook.com (2603:10b6:806:6f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 15:19:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7583af6f-5716-41a3-4f8c-08d9a84b5e8d
X-MS-TrafficTypeDiagnostic: SN4PR10MB5638:
X-Microsoft-Antispam-PRVS: <SN4PR10MB563872D153E925B1F4CD1233E6989@SN4PR10MB5638.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:361;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yinJ2ePk42xY75fzKAlVkgPNPJH2+BVID6F1yGlEguM+5JLGuFOxfxIBsRq3WmJDlSHhAVABhn5VmbSgmbu+SvaYviPmNz9Pap/4siAAnSMW6uB+ioMi9xLpcmvKN5zlZPZN2TKlggSDO9hrFCCg7xCwa7hO9qrXyPzh78h0icPx7tolsYn2DeemZWFkJkDE+ETpTCCOWF189Xj7bOPMLubfKZuy29q31W+KDa+d7/F8kj8K5Fe+AVJfScprt6xLEYSvsz7CKL8Cw3f68tfC36rANjn3CFxb9cTO6bWl8l0qjexfo5xwjj0WaIRm0qFf7yv4KzlLmxyTsNgl0WbbAxQNlCovF12qG5mt5ov/2rLzziab2MmJ1aLrJ992ZcP9gQ/UodDxgFS/ZUZCQGUm+KEKDDfetieUh9K94oPt+fpkXwbdhtIiIAvDQEfiZqzPsRnUpAxxpX7NC8pFxuNnxDs/cEKt81dBTP3vbkzhDnzSlUxphGeQ0kCuGx3+DFQDkY1UbWuEyVyIF/AkJfSkoNA9cCuafmFfkEmA1SFPyon/un6f4bWOMA7kzrypwcAY+DzeU2xFMeF73ayThiphpL+7KWKbuqhlq1IdF8Rp5lZ++TaWx3rqzDAg8VddX8XQxxSydiA9BT+6Kk4hBtmclNQz3/nJ5vfsiZ39fQmx/G98tNWi1GAwMzX2UpezObbY5leDAj4Y42IsMnRIikR3tVTLVAgEauB1h8ukIXJdkvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(2906002)(2616005)(5660300002)(44832011)(110136005)(36756003)(66946007)(31696002)(66476007)(956004)(66556008)(53546011)(6486002)(31686004)(36916002)(4326008)(186003)(54906003)(8936002)(26005)(38100700002)(316002)(8676002)(508600001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STJxU1VFdG1heGVUN0ZtMDBKMEdvNWhwR2l0UzNKTVdoRzcwT3A5NXptQW9l?=
 =?utf-8?B?ODJPZmNqWmFOdjU3eTJjWkx5UlJ4eVNDMmNTL1B3NEJZalMzOTNEOHhBZk4y?=
 =?utf-8?B?ZGhqSWozcXc3MkRseGNOZkxmKzJzQVhFdkpMVmhGT0MwT3BKRkErYUI4c3Bv?=
 =?utf-8?B?UG9kdlFqejJITUh5NFN2N2s1UFNEcm10REhNRUc5K3lrYXRXU3ZKTXFwNHRN?=
 =?utf-8?B?ZWU1S2RjVHVCUjZmQTBuakl0NXJEM0V4YW5YQ09pMDZ2STFJQkd0cVJsZ3Vt?=
 =?utf-8?B?LzltMUNpYWRSbjFZbC9xMjkza0hER3Z0L1BrdU4vNUpkc3JWazdVK3BPekVt?=
 =?utf-8?B?cmc4Vk9ZbWVqazBRQVpNaDd6WEFlL1MxbDJrYUlETHk4bWtiaEdlTXR0WWov?=
 =?utf-8?B?T2Y3ZFFnU2oySldHL2htM0xwVU9pZlRXMWN2Nmpyc2xHR3B4ZzYrNldoTXBN?=
 =?utf-8?B?VDJoNGlwWTZxcU9PdHNMM3p3K1NQV2ZTOER4S0xTZ3U0L3BWdDB4ZkgrUU51?=
 =?utf-8?B?TmxsaXowUTR6WjNjN2dLa1F3RW82aHJ3cWlsWG5rUm1Kd2xJVmdEelJiZTRj?=
 =?utf-8?B?ekhzWEh3VjFJUE9UaGp1MlVHTS8vM0NpenVWakpkM1VoaHRyZGJzT2ZZRTR4?=
 =?utf-8?B?TkN0b0FSS3ZvcnBVTWlzT2o4Uk55WUR3a0dtc3VyeTRCQmVhYUwxZXpibkhS?=
 =?utf-8?B?dDBnUDNDMFUzbFZEKzZhRllKS3htTm0zK1lTeFo5VkpKT21xSkdsQUFVYXA2?=
 =?utf-8?B?UmxJTDZQMnQvVTV6TVB4TG1OUXJqSFNWdkJ4L3ZqWHRhM0N0eFZPVzlNMWF0?=
 =?utf-8?B?TUV0UXhvN0xIbFB0ZUo3Ykx4LzFlUHgybnRLRjBjdlpxNCtQOHU0R2dMQzhr?=
 =?utf-8?B?Z0dFN3hPTEpvMDRPblJybU05cnUvT25JS1c4TzBpNHJ0VDY2UUhBR2ozQ09N?=
 =?utf-8?B?aWxtTElnaER3RkpqdWdScUtMSUl3bGJlY2dTaXd2SHNYYmRJMFFZaEh5U0Ja?=
 =?utf-8?B?S0w4MGRBWGFmbHN0S3BJUll1ZHNzNmM3all4VzRPSk5jZkd2dlUyeXZpQXBu?=
 =?utf-8?B?c1pGOWZmVjZlbHQzS3FQSTJhR2M4KzRDNmZMZFl1L20yUDc2bENrNThIdUd1?=
 =?utf-8?B?Z3NmblhtM0NCSWI0czAycW16RHVxaFBQYTcvQngxYk91UVBFaXBpVEw3SFhE?=
 =?utf-8?B?bVN3TGNVanVCRTgxa1dLRTdFT0dUc0lzelhEZnBDelhldUFNKzB2SklSeHNn?=
 =?utf-8?B?d1VVa1pNOS9Zc2pJUXNEeVh6bkhqbUJOS1JMZW5LcmxZbXF0NXJrZUdRM3Y3?=
 =?utf-8?B?czRPMkc3UWxHQjBEck1QSDlpekVkT3A3dzUzZ3Q0Wkd1NkJ4cmk0KzFLRThj?=
 =?utf-8?B?eU8xYlJmQWRNMlRFcHRQTmxlaGFxUmhMWXhNVHphMXNyQVlsT1AwbnR4MUx5?=
 =?utf-8?B?SkdNRWVURjJEYm9TaEhvM2w2d09iS2EyYm1Sa2RDUmFjOUtaVzI5NDZTdTFI?=
 =?utf-8?B?OVFZQ3BraTJGZS9WdUZwS0hpUnNIUkkzdllqRmI5QWRJcGtiQXA0Z3cyWlkv?=
 =?utf-8?B?c1hMSktBS1NuYklzbjlXRHBIaDNyaisxSm93RU14ZUY5OC8xQjBpMngyVVZ2?=
 =?utf-8?B?bytsUUNWUVBNMG5Ya0tkVWRuUm00ZnlLNzFOSitqYUs3MXVIdTV2YnlMaXhq?=
 =?utf-8?B?aWZiWWJCLytVSnJZcVZpQVZzNEx4RlVvNFltUEV5cjdSM1I0Q1k0azZ1eUZn?=
 =?utf-8?B?MGczL2lxOFJIOWQ1Sll4R215ZEE5bmhHTnIrY2hDd0U5ODBTUDEyUi9nY0dj?=
 =?utf-8?B?eFVaWXlqVDdmRk5iV1EvVUYrR2h2eUlhM3FBd3hkcEhXYTFKQ2lodEZvRU5N?=
 =?utf-8?B?a01qTkk3SnpuakVVTDJRQ0MrQjN6M3Qvd1JWZnMvRTdIbHo0UHVmQlN4ekhz?=
 =?utf-8?B?VC9tMkdJR0VreVRMMXYrY0NSdVF0WHFXa0c4S29wK3U3ei9KQU9iOW1tdlVt?=
 =?utf-8?B?U0k0ZEFtcnQrdkp6M0RWSjVCOWZIdktCYWRFWGVsZGFiUnZ1cHJZTEZIVldT?=
 =?utf-8?B?Z0FsMlhNSjI4M2dWc1d3d0JOZm1mVWxWdVRxQlpSQS82cjF0VlNTZ2tnOXFT?=
 =?utf-8?B?YzJ0UThqTHo0OWYxMGFOOWxWakpIUUxCZ3VwazFxbFJtbUgxbVRJc3hwVGVu?=
 =?utf-8?B?ZmVPbUN3anRPcE42L0tmRlZockFxWWRLYjMxQnJONFlGd3EvMXhvdnhUWUJu?=
 =?utf-8?B?Sk1pRnVxMjkxSVhvSWFETjFxSlR3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7583af6f-5716-41a3-4f8c-08d9a84b5e8d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:19:51.3028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6iQdFmXbN2AD5QdNcsG0bT3SdOvezU3xKhHDUeuDOaYLQVm7MBwKyTRgetE05WKGTYTfqBjkHd4dmieTypP31E9ntHbM5HXNbMV+WltI0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5638
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150081
X-Proofpoint-ORIG-GUID: sBF7EjFqHAadC-0-j1DzOizfmWJzJtVq
X-Proofpoint-GUID: sBF7EjFqHAadC-0-j1DzOizfmWJzJtVq
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 06:59, Hannes Reinecke wrote:
> Add helper function to determine if a given key-agreement protocol
> primitive is supported.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   crypto/kpp.c         | 6 ++++++
>   include/crypto/kpp.h | 2 ++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/crypto/kpp.c b/crypto/kpp.c
> index 313b2c699963..416e8a1a03ee 100644
> --- a/crypto/kpp.c
> +++ b/crypto/kpp.c
> @@ -87,6 +87,12 @@ struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask)
>   }
>   EXPORT_SYMBOL_GPL(crypto_alloc_kpp);
>   
> +int crypto_has_kpp(const char *alg_name, u32 type, u32 mask)
> +{
> +	return crypto_type_has_alg(alg_name, &crypto_kpp_type, type, mask);
> +}
> +EXPORT_SYMBOL_GPL(crypto_has_kpp);
> +
>   static void kpp_prepare_alg(struct kpp_alg *alg)
>   {
>   	struct crypto_alg *base = &alg->base;
> diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
> index cccceadc164b..24d01e9877c1 100644
> --- a/include/crypto/kpp.h
> +++ b/include/crypto/kpp.h
> @@ -104,6 +104,8 @@ struct kpp_alg {
>    */
>   struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask);
>   
> +int crypto_has_kpp(const char *alg_name, u32 type, u32 mask);
> +
>   static inline struct crypto_tfm *crypto_kpp_tfm(struct crypto_kpp *tfm)
>   {
>   	return &tfm->base;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
