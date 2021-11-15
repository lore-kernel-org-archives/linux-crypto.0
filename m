Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D223FC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C0561AA8
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhKOP41 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 10:56:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59624 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232388AbhKOP40 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 10:56:26 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFExFGg002809;
        Mon, 15 Nov 2021 15:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6FWCaKpJErAVJ4mVpP1vt0lAscIHos3b6NT9qo0CFI8=;
 b=UQCXZoWLzpDvFSKYD6QwOPUVYBP0j9U6p1WnEWnLNkZjLx1dgjtKBSAINhOAFMwJl+ip
 wmq93MiDnXrebyAzWHc5UBCY89loPBD8RrXMd3tUaB9x6KYH4voJhgWZ8yuUF9nG49Aw
 8ZXDfJ1/gJUWfWGupEwkaDddSiNOkhmc/TSV0HIoEuzYw3HGdqOA1eBisguKDYZhJreU
 jJf2kF7okjWx4KE5qztagEyZ1Ogw+/XdhH0N+8T49eDVQ/C7U23NAWfNKVj8YuN8K9XL
 UYB+MvkQ1QJO+CVsRpBeEWDmZw8i/XjLBac3LQrYLIGxBhgfkrrmb/ZTXRYOMC2LgIeF Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbh3du3p7-25
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:53:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFF10SQ132967;
        Mon, 15 Nov 2021 15:19:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3020.oracle.com with ESMTP id 3caq4r5jbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHzxqLCqTANhlQRFhib1xwJvOkgVtx3J3ZCqqHAc3/dbvJCZvSHxHCYVJq2KC0ld+vPq0xc14dNbVxKFnjycy2Oa6dXDa8TImI/Sm20i8MUOjqhiqHGCq6fJiG/8gxiPSc5EKNd7Hs0aUDBD2h2qMx3DLw95aGBYVMRAajOxQORqHKU1cwjZtEyvSTKK8ylBS8dU3lBQOJANi7YvHssI0pz6JwmKXnduCoAyTetlTNUx+a056Xm8B1XG0tnu2L1e1cj9ZXz09FErC5W0SpLf/PodpUg/z290GgXBij5lThGG0ZmUWJsvR/FkJ4FRCWJVZVdric980YXNfJIyn0CkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FWCaKpJErAVJ4mVpP1vt0lAscIHos3b6NT9qo0CFI8=;
 b=hG3o1PZVVIIRycmsxCk+9ZAL17ewmgJb/f7fijzqm9mrUVwracgndQBX8PqVn9v+TcMHP/GjkgS50jn2K53IyIKIT/IfTSeDj0ifz5RVsH+sWIWGX80fMpd/7IbN3um0yrZ7D/QL8HL4YRT5Ym0z3TdPXMZPcgm0/71mcJDMLoBPWU7keff3l5FLbAEOhC6SCx+KUW7Ah23SXtYBJQtzXqs6lOTBcYoTVtdmVSeYvQYdTQs/iityhuT+oWitaXJr4flq+PxdBd4r6sa7zinEvc51iJcW0zMZcqQGNGs4DattF12yZpiJnAL26MEteAidPxXiB/1s+MxKF5XLvzcwgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FWCaKpJErAVJ4mVpP1vt0lAscIHos3b6NT9qo0CFI8=;
 b=UYqcCcnRKr5sDuxT8zqlHWNw/BoGWDsSVcO5V4oJS7Yo0I57aC8JfHGVKtDFANGmUCXXS2sW/rCWwSnZKpN5ff6Bc4+7LQH8jK595Smslc828Na3sZF+re4l2mejmfjJMy7LBpmXfmuLK1YwhFp9zCFXBrf5Fq0NrL2fu57Ck2c=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2720.namprd10.prod.outlook.com (2603:10b6:805:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 15:19:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:19:45 +0000
Message-ID: <96d26ba7-9553-adba-5341-8f071b0639d8@oracle.com>
Date:   Mon, 15 Nov 2021 09:19:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 01/12] crypto: add crypto_has_shash()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-2-hare@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211112125928.97318-2-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:806:6f::28) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [192.168.1.28] (70.114.128.235) by SA0PR12CA0023.namprd12.prod.outlook.com (2603:10b6:806:6f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 15:19:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e21fb927-7834-42e6-96df-08d9a84b5b0e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2720:
X-Microsoft-Antispam-PRVS: <SN6PR10MB272081EE5F4B52D5F0A4BC7FE6989@SN6PR10MB2720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:361;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vx7GWWV3vFq0HSpDZOckwCPf+HeepO91YHetwVVhzcR7UukdpZ+M5RW/9B1f7A8cntLTZcFCHs+gFzBh6y9+PRPPC0dFCgRT+OmXEBL1XIc8MBkoPMMDBj+YbtaNXpxmZqRROZQiP/bAFs3s7aQ1209FzyxGsD6dsSchMq09Gb4TpwlCpaE3bOWyNDeYAuMbbkfogU7Iz9l3C8qY10/lqCXRS9boldXV1TDJFExQ0UR50MnalkVtCv/TA1bUt/EQrFpBNcodGINWKnjocPCKVi7Pq/JVSR+3mq8Qf6VxjlsNBe+JYnhCtr5xR1J0/UrMprUF/gu4iWAuqJWKd9CNRqvyRSv1+iNxXzNXr7aDZ54XILUcd5Ek6SM4ZoggvpHMSuhYM4EUN/pX2XgFybcMXVX9B4DosgV2qKhJ6Zx3bZCnliNEpkp585xxmpwLClymPLYHI59d9oTLCYYrJoysFudAQzUeAcBEyUhrDdeybTQ+gjkL4dYrf0OPALWrOOQxk1CDNEowR78pRiZ9jKBMJ6ctBYZG3t65FtTc61IQr2pBjooV+Fyb8iGdy0kPpe3vsSHt+7yTG9GCV6FJRgqJ/IIZZOUy9xVN4Vp4mgsVFi2wbA3+QXdnVzBtbRs24PBreoaVqUdi5rQZQjUjYeB0w7H4Ls1YjF99EcX73BIw3sR6Q22iEajgxWgDFL72c70XPCuLBXrPXhDCrobOobGYk0AXPpEQ9BsokeLItVppcg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(110136005)(36756003)(54906003)(4326008)(31686004)(316002)(16576012)(2906002)(66556008)(83380400001)(66946007)(186003)(36916002)(508600001)(53546011)(86362001)(6486002)(5660300002)(8676002)(38100700002)(26005)(956004)(2616005)(44832011)(31696002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnVyUGpHTmR1M29oWktTY2lPak9YYmVkTHBaa1BZSE9oay85WTRsVnlhWXZM?=
 =?utf-8?B?am9iemRlZ01IRStCaWtLdlVNOFhaQkVZSHFuM3hvcm9CVTZWS1JzQktyS3g5?=
 =?utf-8?B?UDBUeVUrazBnSGFYMGdmUHJseWJ4QXF1YVl2MTFzQ2RXS2VpeHhHcmFuUDhK?=
 =?utf-8?B?QzZxRHM2c0hjRVEwM1paa2xpVDEySC9EMVltR3pOeG5XQVBZS0xzYm01ZWlx?=
 =?utf-8?B?TEMrMkxjT3N3M1NSRnhXNGhZTDdya0hpR0d6MkphTnNjWTU3eGJkdHkyNVA3?=
 =?utf-8?B?dmY4NWdTY3lIbGUzUzVmRUJJV3FwUjUzNCtSeUtnUWNUMUtleDlrYUh5d01i?=
 =?utf-8?B?M2YwUEdDcG1qZVBubUMraXZQNlBwZUNvTS9UL2wyVDFMLzNSOFd3ZTdEMlgx?=
 =?utf-8?B?Ukh3RWd5c0JyeThtUXo4ZlNqL2Z4azhyVEhtZC94R0dvbXN1empWSHRjMFVU?=
 =?utf-8?B?K0lQZWN3NDRqWXBmODFqNDJaVUdzOUxwbXRlb1ltS005UmdFd3p6dUt2Qkdz?=
 =?utf-8?B?S210MzgzYytDRTl4b3ZTR3pUb0pXM0psNURScjMwcGgrMGZvbHFDakNqUUFF?=
 =?utf-8?B?SCtXMlFrMjBCNmhwQVZSUFFSY0pETkdKMHlUY3FMVVNISmxleDlRczJ3S0E4?=
 =?utf-8?B?MTNwR1NJSUxsWkJXbFVjTnNrUm9TNkdwSXBPTnYwb2x4dStsM1RJeHJ5dXMy?=
 =?utf-8?B?MjFVREJkMmNLSVVyV1YrekNPTXB2WUVCdzBNTERhYnBZbGlXTW5jUi9FVTdL?=
 =?utf-8?B?Z0tGdEpwcFpqanIrM3JjMWZrU25pdTY0V2NPVXNyTUpmRHYwMkUrSTkyek1Q?=
 =?utf-8?B?WG9KUG9SNlNrYWdMbFI1YytwTFpQL0Mxb0N0bnNBYWN4anNtdGRTSkhuTlhT?=
 =?utf-8?B?c1piVTVNTytzMUNGZzRBSEsxWWcyS205em5wVG9vSXREbHYrakpnVmwwQjBD?=
 =?utf-8?B?dUV1Z2daRzJkeDVmR2d0Wngrb3JTd0FPNXRLZEE0TC9jNHpvTEZHMDREdXJh?=
 =?utf-8?B?Sm5xWFZnR21RRDd4NHVGQjVYNnBaMnJidldNTENDdEZhOEQyQ09vR2VRYnpK?=
 =?utf-8?B?c2tPVE03VHRrL2U5ci82ZmczeS9qUklPUzQ4ajFkRmZCOExJWk1qbkpDMHpH?=
 =?utf-8?B?NUJTTnVPbzZsbk10Uk9XdGJsYU82dC94TUpsQ0YyRDBQcEFWWVRUM1JzQ1BG?=
 =?utf-8?B?cTd3ZjdYMVhhdUNKaGJueFJOT2ZLT1lKZGg1OWdISTJ6ZzJIN3dzaVc3RXdL?=
 =?utf-8?B?b1dEMktjSyswNmYrU1dPa2dJWGtNS0MwY0t2SW0rdFI5cmxSWHRJekZ3dmtE?=
 =?utf-8?B?MG9FcUdhY3Bna3IxZGxqVm8zMEVySU55Z3c3Q2ttZTRLRW11S2NWRkRMdEdK?=
 =?utf-8?B?ZXEvd3NkUTdqUklWQ0VoOTZBdlZISWc1V0JtcmRZMlNuYXlaMVNBTWc2U2dO?=
 =?utf-8?B?QXUrWXJqUlNTL1dzWmpLYjI3ZWJ0bTBycUREKzJnNkFteDVTeHdQaDZwblpr?=
 =?utf-8?B?bnlvOTNkUnR1RWcvQSsrd2Ztd3lacEszWUsxbHNDdmxZQklGay9BTHZ1aHlh?=
 =?utf-8?B?M0NsWndlakwyellmSUwraWlQRFFIaDRYcDBBUmNPc3UranpGVHZUd2twbnZi?=
 =?utf-8?B?ZDV0NlFLSE0yS0dMSTBVaXM2RFpkM1VmR285b3I1cmF6VmRJQWx1SHFycVJ5?=
 =?utf-8?B?aXo3T1FsUWdDdEtzcDkrZWlBaG0vQnpCYTRtWWZ0VlRpSThVTllhamo5RDRw?=
 =?utf-8?B?T3o2NE41aWNDZVZrYzZVblRja1RIYWN6cnR1V3BXSTR2ampNSytWNVVlcWQ3?=
 =?utf-8?B?akNLWVJCbW8rcnhGYlBkTThiWG9xdFVJVHdCMm1IWFRQZ0ZhNzFuaCtCejUx?=
 =?utf-8?B?TE1oTEZzamxJQ2ZQNjVJaHFEZEx1aUxCUHh4SUlEZXZBMFUwbzhRdUhvbExL?=
 =?utf-8?B?S0p4ay9xTEI4Y2tpUW1JQitPN2s1QTJGaVh5Ym5ubjM3bkdzNWxsN2tEYytP?=
 =?utf-8?B?TXRSdVR4dnV4a1k5WTE1OFhKNHU0Sm45T21pemg2RUxCSFN4M1JmV2Vja3pM?=
 =?utf-8?B?YUxjL3RMMWdLYVJNbHFyUmxzeHlsVXZzeHJqVlBaY2FZR3ExWndiZjNFazRw?=
 =?utf-8?B?Sm9uL2I0UzdUYk1qK05BVG9hbmdiV2kxS25VcDQ3Q0FxZ3lMMnBMcUo2QTBH?=
 =?utf-8?B?NnJPRVc1b0pQakpZQ25HRUFoZGJXSVZPK0lybVBjYUZVc21yWnVsR1l1OXZi?=
 =?utf-8?B?N1J1SkNZRWVIalRoQkUwN1ZVSmFRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21fb927-7834-42e6-96df-08d9a84b5b0e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:19:45.7739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5jRY2Tfl0guwebVHpn+nBkamGqqHOF26EjmI5Ne79XBFNSKXzoKKJatwOWp3gcURQEFvjEZuYym9jt6zpPbtg4BMa1lJnZwyk1mo6w1zN8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2720
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150081
X-Proofpoint-GUID: xdFgLuClPDZrcEJEaoV1jLLS_BryPpDU
X-Proofpoint-ORIG-GUID: xdFgLuClPDZrcEJEaoV1jLLS_BryPpDU
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 06:59, Hannes Reinecke wrote:
> Add helper function to determine if a given synchronous hash is supported.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   crypto/shash.c        | 6 ++++++
>   include/crypto/hash.h | 2 ++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 0a0a50cb694f..4c88e63b3350 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -521,6 +521,12 @@ struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
>   }
>   EXPORT_SYMBOL_GPL(crypto_alloc_shash);
>   
> +int crypto_has_shash(const char *alg_name, u32 type, u32 mask)
> +{
> +	return crypto_type_has_alg(alg_name, &crypto_shash_type, type, mask);
> +}
> +EXPORT_SYMBOL_GPL(crypto_has_shash);
> +
>   static int shash_prepare_alg(struct shash_alg *alg)
>   {
>   	struct crypto_alg *base = &alg->base;
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index f140e4643949..f5841992dc9b 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -718,6 +718,8 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
>   struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
>   					u32 mask);
>   
> +int crypto_has_shash(const char *alg_name, u32 type, u32 mask);
> +
>   static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
>   {
>   	return &tfm->base;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
