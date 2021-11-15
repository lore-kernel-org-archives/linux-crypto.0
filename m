Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21494C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0793461BFE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhKOPsh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 10:48:37 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31802 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236417AbhKOPri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 10:47:38 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFF3BT3001106;
        Mon, 15 Nov 2021 15:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KzyYnRboaihyVpWuf4jd6pl1gvlHaq/UBP61nFJ+p4g=;
 b=jBKZ612j85pwEuFAiobkFWQKgyNoSh/3Cfcbx2v6hyhNZtqA/F0/7jwMcY7KdsA0u/F3
 Wl3El7XNDPzR/b5tfoKq2Se0Z1JRItamJxQc4sn9pPnBa7MTV1Ot/8yqcZesKCw52YFW
 zcR97WbYuMW8O0zptEZmXvraOov19N7j8L0Wc+BootZYq+Z8p9EbWu9GDXI72f8kcgKV
 BJxEa6SvSKknQO8gipqnQLoe/JnHel1clkAnVaAU7sn4knop9aocMi/QAwhgUi5cLPS6
 j74pBswgLINx38F86NBiLH5/eZRl46/R9O7wUIlm7sGb5G3AIqBB2LTe8/W325v4gkvR TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhtvjtdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:44:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFFSdcS104764;
        Mon, 15 Nov 2021 15:43:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 3ca5641dtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:43:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmLEn1r5lVry0IGXefep1TYWTuc44phya3Jf1wjDosdHcO0e8lx9vXgAKnsmuo//ZUOdUH5hv/hapYQPMpk4nYLMaQQaH1H8g0HxXv49llessjWarjpa0TLqWpeAnnUDRa2ppUQEIZK30r3+/mB30uGB10BwOS0VHGVEpffnmF05JeECoM1ZxWJwHDK77XS2rwsPlaKI4N572ZFnfjvaZzPcG13vCclQzC64dxP/URfu1NgQ4qQYkrWDk7s43f7dL0d7ufu3w4C5ndocx3XBh6BTLBEXYbqGvylUP7Ectk3ePf9QpeX3svCfZGp9lI3v74casSB2qm/Psp+pubHtrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzyYnRboaihyVpWuf4jd6pl1gvlHaq/UBP61nFJ+p4g=;
 b=T/W93A7lFT1CFBW59yslqiluucVgiCJ/SEYpuYNEtZZoQoJ9f9a6m0bHio+3DHqK4ub6LAgLfNKY4q8IFpW1xRpalZvYFnH7U50/i8o3Cc7t3qZY982DpQbm5pKIAbA9ARhquDux0AGu9eyOQnju931nZAUAs7Ct4p35RqmeT2+H7SjyOWC3dANdyRDuuBgc2PiE/GNTZqGp+qT7HFEXfMdH5RrNmdOt3Hzmu/GSwGAgm72pk4/haVZugURMKsTA0Rw0dE6bnJHBiD1nQm2SofrH0mbxETIMiUXv3jninT7KhqKwulFd7pDBa3gqmnFq9i3QmyentQbiJJnLRD8fYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzyYnRboaihyVpWuf4jd6pl1gvlHaq/UBP61nFJ+p4g=;
 b=NaVXLtbhpxfa+cJsTn1cM9yQMdnX/T4MnGYmJCqSv3FrxeU71PdZj6w8Gi+Pm292B3GJMdWtQbppEKYZIRO+tFRfg7pjoK9Z0R/ay/ze6am2bWn9VqxCquMbkQ9Uvhq622XKlSy8MkZoRTwwG325hlISnNSlEsxZhku3eOpAhP4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2944.namprd10.prod.outlook.com (2603:10b6:805:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 15:43:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:43:12 +0000
Message-ID: <99e93779-b003-6ee1-429d-0b3af172926f@oracle.com>
Date:   Mon, 15 Nov 2021 09:43:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-10-hare@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211112125928.97318-10-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:806:121::28) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [192.168.1.28] (70.114.128.235) by SN7PR04CA0083.namprd04.prod.outlook.com (2603:10b6:806:121::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 15:43:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6009c503-9cf2-4b56-8bbb-08d9a84ea18e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2944:
X-Microsoft-Antispam-PRVS: <SN6PR10MB29445B7AEF12B4396AF42DB4E6989@SN6PR10MB2944.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZGwD1xPylWjNRtgW+vdCAm1woYEULZR/wwHYXEqPbbivJX7lhOGluAboifCNktRF0gslvFpIYjqJzrYdaDUPvEpUtrOS4GS7TKqRmqT7NxpWVy9v+EjvvJL9Z5Qgo8mX0uPjcn+tJ7Lvj5WixtzdiHbnNj2+BS4iQ3w25Xx+yAByFBJuNHjnleIQ9d6dFRx5pxs0oDF42+JdewUWIqI0CC4a0g3ivq9UyXkOm7bMkh97mSY1kqzC3rBnNtoB49VUKsaFqvfV/kYBQRfBqRWSIgfAbGsdKc6n67GJIHJfwhKlo4xa93Qz1ru7SwAzCARfM0dSQ6whBUwT/npgjoetLQxYVtbDwm1pDLjR9OM2MZzeZuKX/wdyEqlCFF0lF81OuEWNVHCHE54x+Kwfw5N8v3OE/wg+aMZBIz99o7goBBk3b3CXGfaxSuaHoxotMxOZLyZaKUsg1v1hftcilpltp5uIDX5XIopfnQRBRxmSDJFYtr2swh3Rzi+kaojACB3ZA2nAH6SQoEPF/lrjRGFWLYwC8qfPuvMhnr5Gv4bIqKF7MeOqQcEPNFyZvobFU5Apa7sCfAoTXaC6GKXE3uSYM/L1rIEe92rtqHjo/8u64yInEjTUGMHnYIVM/5nIGmB9HrkdZvQcDUO2eZ1IoP4FgRGF64bzog6taHF868yWf8CuG2UT6ckWCKVV4gTLgsz8IxDJZUnwyb1TorDknll1RRLZFaSre9nqKTOsn46osmIKLdu9refibxB09tRbo5i2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(316002)(66556008)(66946007)(53546011)(66476007)(110136005)(5660300002)(16576012)(54906003)(26005)(31696002)(36756003)(86362001)(8676002)(956004)(2616005)(44832011)(6486002)(4326008)(8936002)(186003)(31686004)(2906002)(508600001)(83380400001)(36916002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3lXbk9JY0RWNXdXZUkzamc4a2tkWFpMVjNGaW9XTXdJRWZIMHlRSmhTWUFn?=
 =?utf-8?B?T3ovQmptTy9iN00xR1FzcDQwSzA3UVhzdGZPQnZudkJiYVR2L3BIRkJMdTJC?=
 =?utf-8?B?c0luekVHYWlaWFZUUkdaalJoclowKzZUNGtrcDduaW5CNHMrZDJaalVNV3cx?=
 =?utf-8?B?U3hndVhnY0FSVUlGZWxacGhSOW9ldW1mamtDeGZtdkdzUXJ4aVE4dTF1OVV3?=
 =?utf-8?B?djVQSTNPUEFIUWUvZlFqQzY2eHpNWjRBTU05Y1djbTA1YVV1OUZsMTJRWExm?=
 =?utf-8?B?cWF0MEljU1ZCL3VjN1dMSWphWHRrUmFjU0Zpb0dnN29nN1NzeHFrTXQwaXJS?=
 =?utf-8?B?VDM4bktoem50Rno1UDhnaWV2UFU4V0IzaVBUakVLWGxFNzB0UGo5WHlYTHQx?=
 =?utf-8?B?V1JIbTlab3NnMUV4TWxxekR3SVFibExxQXFieDBEN3QxTXQ1OGJrQnZZU0Ew?=
 =?utf-8?B?ZTFiS1FGYTBHRUxkU2RtQmRVM0x3RnVIaUtMVTJCS24rd0RTUGVyVWdlQkZ0?=
 =?utf-8?B?WFhYK2ZMK3VCdCtFM29YYkd4alArV2hWNXpiNkIrVk9IWFNNTDNtUTd2VzRz?=
 =?utf-8?B?bmNJQ3ptbURxRzIwRUhNTmRmR29lalhCQ1VnK2RuSDJZampMVWtFb2NiYXh3?=
 =?utf-8?B?WkZQaGxqeTlPVEpDWUgrSGRjUjJWbGRCY2hQbXE2eFJVL1BWbzZlT0lyZmVr?=
 =?utf-8?B?VnJUTlV3NE4zaklsV3NCekxsRUFsR3BzQ3pvRHpHTnUyUkJtVWhseHFBMmV3?=
 =?utf-8?B?N0daM1FNdTFsdXl0ZFFhVEJUTy9obVFIQk5uRHdSUU9KNCtNdkZUNnFJaVJu?=
 =?utf-8?B?cmFkTDladGV5bFVIRHdrWFlxUjcwN010WmlKcGFDa2J0YmdDMnBjR2VpR2JR?=
 =?utf-8?B?NkxMb0M1RHNxWTJzc3RGNXNNU0NPd1lraGc0c3dWbVhRaEFyb3pBdE5DTmVS?=
 =?utf-8?B?RVBLVkpLamlmZC9NSHF6S2NETUE4VU1RSVZ5YUFNdDNWSG9PK1I4K0R4TVBY?=
 =?utf-8?B?Tmx4ZE1DTDhVU2w0eDB1Rmo2dDZwNUV2STBicUxuUEw5VFJLUUlFcVpXS3dK?=
 =?utf-8?B?NWhjNW83MkZEVHByTmpyL0dSejdBUHpsbmFOZ0JjTUxqK3JrQlB6ZkZFRmgz?=
 =?utf-8?B?ODBGWkVqRnk2N1Q1SHptelFwdU0yZWIydjhMbytxbkFKK2hNbEdCMXMxbFNr?=
 =?utf-8?B?dkQxZk1NdGxMdlhlWkVVWGpoSUNaa3ZYOFhJWi82VU9HM3NSd0pGRnU1cjRX?=
 =?utf-8?B?SThNYUhzSWJXUjBjMDNON1EwZERqM3IyS0xEWk5hNUE3QjNLemViZ2IzY1B0?=
 =?utf-8?B?dllXT3RXL1psUkJiSlNSZ0loWUoxZHZ1MU8yejhUbGZTVXNsOVhndnVvc2wr?=
 =?utf-8?B?OFhYc0JmMVpHb3hYUDJ5RE13SGh3UVlxbmRpMU5MNi9qUWJXaXBUcFJXV2NM?=
 =?utf-8?B?Z1VzaVlibGdDTkkzdWtraTNhSkVTamlqK2lhOEhzcTUxNy9Td0xUdTFxWHQ2?=
 =?utf-8?B?eFpjcWNTS2tsYzN6czBwYWNMWXUwZ1kvelhhM291SDRyc2RDazJ6dUlWNFA3?=
 =?utf-8?B?Z3RlZWNyeU15aXBqdStCWmxPZlB5U2F2b1RTUTlPVXdyWHBsRDEzWUE5d3Bk?=
 =?utf-8?B?aUNONXJxaENaTFVxK2o2Nll5Z25LMVBDL0VrMEZYT1ZBU3BNV1Z3WDhMRlkx?=
 =?utf-8?B?c09sd1V5RENEcnBjUlNuWUYvcTB3bmVFeHV5MHp2em5DTUZhVjQ3Mjl4TUVk?=
 =?utf-8?B?RTBtU2NpSkRCMTB6QTJ0elJ6RnliM3c2MDIrYVgzMmNnWG1ZdGl2a0QrZ3BK?=
 =?utf-8?B?OFR2QkZUSW9zN0plMXc2ZVNJNGRuS0VTeVI0TThsN0RrSEZoZDllSmMzWHln?=
 =?utf-8?B?c2U0M0hYMG1IVWpNdzNzWnZ5Wk1CRUNqK2F1dUFmQk1wZWdtb3FQL250alpx?=
 =?utf-8?B?TVpWZU0wNUFsWFBBRTFKQ0JWZXE2SHNTS2tIQnlNazk2dUxJZnZEZWNaSTRG?=
 =?utf-8?B?SWt2ZE1OUHMrdXUxWmFod3ZHNDcrSFFQSHRDT2t6UThVaHpmVGJ6ZEl1aDYx?=
 =?utf-8?B?azBvdnJIN3Q2cHJaTklkS0xCUWY2WVUwT3hyL2dZNm5Jc3Nta0RyY0FKOHRE?=
 =?utf-8?B?MFVCWHNoVmNuZzRmcm5zTkxsQWY3YnBPTjhsamdDOTZibmdtQjd1T1AwdEpF?=
 =?utf-8?B?ajg1T0hEZDlmTzNpM2JKUENHQko4TjFJYWdwd2NVTmNaeHlNcEtUc25OWnFF?=
 =?utf-8?Q?lOohkn57WNAoQEnYjPcRuWAJ35DTlPy8uILd/hiD3U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6009c503-9cf2-4b56-8bbb-08d9a84ea18e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:43:12.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nh3z0xZEqPryCfiUlPFwsRvnuBH+k5dROsLEjXRdXUhJKWJj2iEMiK61AwgBbUTd1GJOfuVA5sCqTZ0fhj5NPuWbyVC8E3NKvXtt5u8uaZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2944
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10169 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150082
X-Proofpoint-GUID: 2VLeKiaJLLzfrrDhWTV1Otpbmx9CFMzz
X-Proofpoint-ORIG-GUID: 2VLeKiaJLLzfrrDhWTV1Otpbmx9CFMzz
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 06:59, Hannes Reinecke wrote:
> Fabrics commands might be sent to all queues, not just the admin one.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>   drivers/nvme/target/core.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index 5119c687de68..a3abbf50f7e0 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -943,6 +943,8 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
>   	if (unlikely(!req->sq->ctrl))
>   		/* will return an error for any non-connect command: */
>   		status = nvmet_parse_connect_cmd(req);
> +	else if (nvme_is_fabrics(req->cmd))
> +		status = nvmet_parse_fabrics_cmd(req);
>   	else if (likely(req->sq->qid != 0))
>   		status = nvmet_parse_io_cmd(req);
>   	else
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
