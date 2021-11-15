Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953E1C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7D261AA5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhKOP3e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 10:29:34 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54530 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236499AbhKOP3a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 10:29:30 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFEpgqA005201;
        Mon, 15 Nov 2021 15:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iFXjXsu5byYWWp3tZbGZbVPZ/suJcv2fpB1ETK7Yuhs=;
 b=sRWf6m//bG777yG91xR8eh5gRM8J9vC9viUlkcGm2zIpQ6yg2GkA7XDwLU/GQAcPxtmW
 k/e2hzmBFvZuvBDwL4dpkgpBmZQ7djRNParQQBWiDpxgbPdth7tUeHexh9psTuCuC7P5
 Hnw3zdoidv16fnzwbjKYlYcdv88tHpEFUjNN4jfx/1h3w8beNS/dwM2CXeO+5gNXvm7k
 BXAEVFqSrxNEWYsGjl/7vkMihTu3oZoJ4oFKIQrw96fHwSgmuTYL1KdejR37J5H21VLg
 oHgeuw/mfz0IJOHijChxcj/UiZHrdvX7i7h2oilzCLjwr17CS/1vNhwqGCrB8jJ2aNo2 CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxk8fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:26:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFFKMPp159326;
        Mon, 15 Nov 2021 15:25:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3ca3dej057-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:25:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mH2UmENxWC5v0Auf8C4qCrwfEejF50a4sNKAxriQOyBWsKvygEjjBu6F8K2swgVS29+FJh+ZHKZQxxj7afn0+NDhj5ScrRSE12oUl8GmjbeW7hh5gMSSml2i1X/zTCzpuhtAyw2zeEiPBc25T7Nbri2Ze/UDaGVgwmsF2rzy68723zmtXiG9w+zSKvqB/bjlJm0a/LybzDq1Uj0YtCB871JK9Wgn1YRBdFhkIuemwFLe6Ex/zBRcl50RGI/zK1gOlTIx4OwTzK81ZYMIscBhkU4RGESKOm6enk8YFU5NBUD2bIo+gZk7A1P9Jcp1wNQmDwABPFgZQraTiEpb3mxyUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFXjXsu5byYWWp3tZbGZbVPZ/suJcv2fpB1ETK7Yuhs=;
 b=LQZjsl87dtwiYHKi1y1I+kQym0akHpH/iGUC/qJ6iM37md5ubUKRbM0rDPurbRw8uq5JiSYR7yw5qrp78NQZv3UlS7x+niI/d9zynWNxdWjvyfuGkk5ytF5m0SI3wb+OvfhgRAaMwZHHITWWwMtpotDUt9ddpgADY9yBB4CXXuojqIzV5DHg6zL8v/79HDVlaeZGjwKkyaP6tFeScZlpFg0LOHWG2HuvvNe4tjVfg9HIf5rMU5Vc46MhwL5y7u4hbxDTOKExb63vxMUdidr+e1uRZYNcWQssvrE+i4pY1GMEo57CwmxCqOKq3i0u12EfKzchAb+anmrRqStfXuqn9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFXjXsu5byYWWp3tZbGZbVPZ/suJcv2fpB1ETK7Yuhs=;
 b=HmMk6ryzy9UJdKC6gGSWnH7w4bigbVOhCyN9HvG5Gl+1MkSh3uNTyaa0cb5n4R598WvTK9QZJssFZb68O5JNNbYLOVADdCS0kYdDRnudOKRTcLKiGhQuXErvONS+6qH78IYq5WNef1Je24X5bnGdZUcIapibP3TyA0keBu3l8EU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 15:25:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:25:45 +0000
Message-ID: <4c301e38-5b87-fccb-5e2b-ec5f78895151@oracle.com>
Date:   Mon, 15 Nov 2021 09:25:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 06/12] nvme-fabrics: decode 'authentication required'
 connect error
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-7-hare@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211112125928.97318-7-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:6e::23) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [192.168.1.28] (70.114.128.235) by SA9PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:6e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 15:25:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f14f2233-22c7-4885-aa7f-08d9a84c3157
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25101EE5C9AA5F2BB1613A65E6989@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOOsjMauD149d5W41XQByG7UXdCNLjhroTlOHgX5KVRepiwDHGMFWoE288xROJOSmasdOgBPfzOx3NV/YA6oCrEtlA/Xm8Y8Ps9wW9NqtID4xDSuPRMu6lxB+21OwXlKMD0WjsyaldHx0d0Y98rk2YP5Tj8NQmOMWV9LkmdZdljeJnD21vktNsiKrhys5uK5YL++LoeKzdsRo+jJl7yQrjCCpd79YwM126L4kiM9Z9gWV3n8dBkIBHlJlDqdq3lW0UIIN1brV32GYj/IIdHNAkKvpw6mlPQUJI0IaHHifoD+1Q1i7eQrEIJ3ZQsKXHmld0EGvpwRCq4uhWEP4UPl+rkPh0KJKcmXU+fs33FzakGwPvr/FxTdQgNZhtlt3IzE/8e2agWt/IBz0m/S3pC8QWTQdHkURKeFlrENYO31OwxWLz6BFPZDis2SIVmAAT7fPO9s+Ryd7oPUunGI1SeMSijFSWfpq41kpd3d1OWOtL+5kQvDjSA44ZUW04aWI9K1u718QlKtPUB+1aymmlt7LRgtLWa/rxC/wzt/Hb3ACEvLWd56Ykf1vzMSw212wYoXfU3P+5f4azJlnJYLbUnIJYUtVo9sBtJRuHzcCUS0jG84TZbmZi2v+OA5w30RilFFSGQiWM63kr6yjQRLGeYVktzFTSaljjfs7vBJf7VbgF0wsi1wBYtlB2oBrLctO5e27GLrZB0c3TgBzry3+TRCZnAlC3aVALN2VwZ1wBF1/hI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(36756003)(66946007)(38100700002)(26005)(8936002)(316002)(508600001)(44832011)(36916002)(31686004)(8676002)(6486002)(54906003)(2906002)(110136005)(53546011)(2616005)(66556008)(86362001)(4326008)(186003)(66476007)(5660300002)(31696002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y01oTm93OXEzVEl4YjNidjdFamZyMXBJZUtmanhnTk5hbXJsZ0VGaFY5TlQ5?=
 =?utf-8?B?a2tFWlZjMWdDcDY1WVVJcEc0dGduY3lVTGxHTUljVWxPNmZ6UDBYV244Q2hu?=
 =?utf-8?B?Y1V5dmMwc2hPK29Leno2eHlaTHY3cnpMRWN3UjBqUk16VnZBalFHWStIVDl3?=
 =?utf-8?B?amJpL1JoK1pkMkVOdGs1a0xIV29IQWJNczdqd2FVQTBKekw0a3RHVVFiVktY?=
 =?utf-8?B?ZVRzVlVwZnA2QjJpcTZwdE1ScEVlbXZabmNPUmY4TkE1MzlpNWgvQjNYbk5m?=
 =?utf-8?B?TkpldlBrZjNKRzB2Slh2YnVpdTMvOWQ2LzByOE9UMTlUU28vNEp6M0tOQW1r?=
 =?utf-8?B?NzhnUnJuaU5mNGhNV0JxOGF6WnZpaVJuZ0ZxWTRaZFc0dUNzQmRZZnNuWk44?=
 =?utf-8?B?TzNDL2Z5MzRFd1FrbUZmUk9ERmd4d3IvdExSU0JvUmp5OEU2cFBFV0h3Y0gv?=
 =?utf-8?B?b0xJeTBHelJGWG9ZNTBhd3M3bXVyL01qWUgrTE5BYkpFeDUrbzdXQUJHVEJz?=
 =?utf-8?B?Yko2M0xvYXRZaUhMSGdXWW1tUHpVMFNXQ2hwdzVnbFNJdnpFb3hHenh2bTBC?=
 =?utf-8?B?QVI0RFJmL3ZrWStFWlZFMy9EVVh0MTk0NjVZTEFvQ21vbUloWUtqSyt0cDFF?=
 =?utf-8?B?ZGUyVWFZQzl0YURiNEJtVDJyU3Yvc0lrUjF3OGhWZGFsejdyblU1eVlZOGky?=
 =?utf-8?B?L0hzNTB5Z1RjMUJGcXdZNmpFdDA5by85Y2M3b3pDS0djRTEwWHNtSEpPUmEx?=
 =?utf-8?B?dzZ5WGxtd3U4RFd3L2lzbHJaK3pDVEhTazBhSmY0bXVSVm5aVmdoN0tqQUtq?=
 =?utf-8?B?d0tpOXlZL0dEYUNjQmp6cGlHM3RqVUE1eFBLMTlDUjNhUVpiS29peFNBVWxP?=
 =?utf-8?B?OUdKbnBtcmFBV2VOWVUzOXpyUWJMbi9qSzRCb09PRWJFVXVDM1FCZ2RLNVVS?=
 =?utf-8?B?NWlXWURMeUsyTFBJWm1TcGUvSnBKd3pZNEIyTFJBYkVxYTJkcm5US2w1S1Ra?=
 =?utf-8?B?LzM4aGF5NEptYmp4eFFBVGMrcVZ6b1RHZ1RqRzFSUHZVano4R3NSV3pGMGg5?=
 =?utf-8?B?blN6MGFOUU9XZ1BmTGpNVWkremVrUStUVTBDWkF4bXFId29Ub1I1UzdBNnRQ?=
 =?utf-8?B?Z0FXNnZ5aEJwZHZjMG44WTJBejBTMExMeWRWRFF3MmJLY2xEbGRrb3FpUTJY?=
 =?utf-8?B?OTBENzRuSjJKWkJQZ1JFV0hQR0ZOL29velNVa1graGY4R051ejR5enZQbmU4?=
 =?utf-8?B?QnR2My8xZFlkUXp2cWVoaElnWDJiQTZqVFlTV3NDckJwQ3FwdGV3dXpBTmMy?=
 =?utf-8?B?a2cvUU5MVHFSTy93a1UrNnB3cUQzYzVmcHFtTGdmbEx4RWwrUkdyODRIQWhj?=
 =?utf-8?B?KzZUdUI5clYrVmY4VEREMDk1Ym1oZ29FcXFJQVhObTdIRllRNTJPdzdIOU4w?=
 =?utf-8?B?TGRpTnBpQ0x1bXRNU1ZJQlNsK0tjTHVCRk83Ty9RY1Ewc0tpWXZoRXlia2o0?=
 =?utf-8?B?MDlwRmZSbDRBNGtxRmpHRlpYVWxwQjFJZU1NSTloWll1UW9sZDBJUXlKbEUw?=
 =?utf-8?B?SWx3dWJ0QUo0eXBDZW1DSzZHRGl1RnkyK3dEYjZYMjVUY1ljazQzUWVTcUpY?=
 =?utf-8?B?eFkrNDcrTHZKSm9NT0pYNmNEWkZkdHFCNGJvYWFqUzhUUkxwRERJNE43MGh2?=
 =?utf-8?B?VXZJYmozc3pLejF5citvV2RHRVFEbVE4dDNDcTVlUTJ6WVFBbjZZSWVJeXpV?=
 =?utf-8?B?SFBUZHpib0o3UzFzNmJpYlNBS053MWNCKzRsSHNtaVNOWjFyeXBsUE4veGVa?=
 =?utf-8?B?VXVoa1lHT1Q3cUE5Ukd2NkVDYVpwVkNuWjZPNXB2QzE1bnJtU0QvSXNjM0Rl?=
 =?utf-8?B?Z0wvR3BEVWFNT25sZEltYnNjMlJpU3JPWERiR3IybVNkdTFHNVFXeDBmTkgx?=
 =?utf-8?B?ZEd3ZHlNU2d2WkdEREVhOFJqNDV3b3ppYmQzTjhINjRjTTRBdHAvUzl3RGdw?=
 =?utf-8?B?eUpsSFNLdmpTaVMrSStSejRsbU1MQXFKWFUyeE5JZGVQSHArRGhVc00zdVh4?=
 =?utf-8?B?SHJ3aGMrbEdCUUltWTVzMTcwUVhna1d5NFdRcFY3YUNxTFlPRlQwdko0dWxO?=
 =?utf-8?B?SkhrTzBwU2R4YW5aSlNXR0ZGL0ZLYlZmZHVlSFJCdk1KTnVrckVDalRHZTRD?=
 =?utf-8?B?WDBnVS9GS1hPUU5RT0NLcURraVRZKzlGY3QxT0lpTTNjNzlNWGVvVkJlWGU3?=
 =?utf-8?B?M1l1VnplN1J3QS95MXhrK0RDTzZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14f2233-22c7-4885-aa7f-08d9a84c3157
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:25:44.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/QbNXU5uSQenRGtZEYUrHiGQyQNi05wYJP6RoWN0K0Zu8IuHox6fn9fi/LdfXPbCIdVPp9owQl+e4UEUGNgmat5eDbxvlza06OjklQcG+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150082
X-Proofpoint-ORIG-GUID: GP5dKMa7TIJsioc777hYEZmZWNDO4L07
X-Proofpoint-GUID: GP5dKMa7TIJsioc777hYEZmZWNDO4L07
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 06:59, Hannes Reinecke wrote:
> The 'connect' command might fail with NVME_SC_AUTH_REQUIRED, so we
> should be decoding this error, too.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   drivers/nvme/host/fabrics.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
> index c5a2b71c5268..a1343a0790f6 100644
> --- a/drivers/nvme/host/fabrics.c
> +++ b/drivers/nvme/host/fabrics.c
> @@ -332,6 +332,10 @@ static void nvmf_log_connect_error(struct nvme_ctrl *ctrl,
>   		dev_err(ctrl->device,
>   			"Connect command failed: host path error\n");
>   		break;
> +	case NVME_SC_AUTH_REQUIRED:
> +		dev_err(ctrl->device,
> +			"Connect command failed: authentication required\n");
> +		break;
>   	default:
>   		dev_err(ctrl->device,
>   			"Connect command failed, error wo/DNR bit: %d\n",
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
