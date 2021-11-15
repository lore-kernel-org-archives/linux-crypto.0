Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D3AC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C4D61B39
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 15:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhKOP2t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 10:28:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20976 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236544AbhKOP2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 10:28:33 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFEnWpl000684;
        Mon, 15 Nov 2021 15:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DLSzp65Yxv213Avcwx7ALurFlAOPTMpxGKwZFTklkCY=;
 b=nqMVpittLCQdIwrnL/e+5v6I7kr6OugaMK+BSy5ImlZ3cTsC0IvQhBUJoxVPn1ADvuB4
 PdyuCVstzfJheVl5Hsm4zIQ6hsx51a7uUsZYe25oIcQErFBveyrdVHyBMFYPiPFGj7A9
 cVVNp4VtPy9pa6G4qi3WNgKZv3PqOWEk4fjp97Y04re7K6DajrdYGvMgYloMsoTDJBrj
 7x1gL+dMihFIEGGMGouwoBSlXtarDSZCaMoANqCaKH1F9WAMq2IFpWRz4l2e6eD2cTO3
 BqSpTZiWP5ttaOm1k+CwHVaHY33ywWugA4OEGkYl4lq28+YgikdYWbNVx8966OrWor5U Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnjxtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:25:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFFKAap007043;
        Mon, 15 Nov 2021 15:25:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 3ca2fuqf5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 15:25:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7f+zgszYXKphhtjZO+fftbS1PWnODvhPWQOhzxQge5haLqj0Fm0KcsHtrv5yk6V+LFUOVsxFCX2+E2UWlssdbQ4l3McYaWwqSVR64kyBzuqffGYmzb3Qli2RVPcvcY+8wEOniUMF1BgCohxwJzG3BRSGBDvVFRAuvynctSUWQ//E4VMFTVuuORs+c861tfUo4z369tLGsm060iT8CfO6Vo3Fmt30IQoOTYfMUrMN72YprSzXIyOM+LDLLMFLFigGJL5Il7T3aQX2dmj6y5h3VfzxQQq2cymnzNjOSomgixtjjyjGk9QQmggQRNxI6S96UdilM9a87C4LXmIuCFG0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLSzp65Yxv213Avcwx7ALurFlAOPTMpxGKwZFTklkCY=;
 b=CXGP/9cyiAmBKVhlxo0PzHebmhJPjUR+w/MUcjd7InDje6AlFbLYH6XMPonweyqQkui85HXcHscGXxSAHGVEq2NJ440wYpnhEr3GvJ2fCeP/oEY+7E2bjXg/d+JB6T6N5FRkN1i46e7ynDYdKH2izs0mD/W5WQU3AA19l9c5HRi9qRXrrnedzE9z2acubn+5D3RlaGYlkIfnLAptWHBKE3+ImFMPl6X1AU/2k+AXgxHn5rsHnzTtbTcuZW4h2Efd4QgnI/3dheGWnx1zx6ZN46ypGWu1lr0m4S3BEcs+sH5wFxZr/zyDXzPjzYToemOWBCuRJ+mvIY70I6oUu7aT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLSzp65Yxv213Avcwx7ALurFlAOPTMpxGKwZFTklkCY=;
 b=SjmYA0Y5Ik0QFObYfeQqW3ZouFZmOl3lHnqrGbJlwfEWAIN7hnGf2p73tEamRmJDkrhNVdZVAkufLk1ZveXHm4u7D2LuBKVRbevEnw6qMq/m1HJe34a/10kPuKYGVIvMXinplv5oXI6T09R2Ssyu8cH508WPpU0XoXcUJswyVzQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 15:25:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:25:19 +0000
Message-ID: <494b8566-ac09-e3ef-9743-60cdd7f0f63c@oracle.com>
Date:   Mon, 15 Nov 2021 09:25:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 05/12] nvme: add definitions for NVMe In-Band
 authentication
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <20211112125928.97318-6-hare@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211112125928.97318-6-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:806:6e::29) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [192.168.1.28] (70.114.128.235) by SA9PR11CA0024.namprd11.prod.outlook.com (2603:10b6:806:6e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 15:25:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3557fda-2637-44ba-3505-08d9a84c225b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2510A48570F47F73257D7ECBE6989@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7eEld1mC7uowE4N8uYpjFjqqYlGht7JRPig35hwOYZojSalQUK8KdpSk2iwPtBSkEFgjocWdXxzSoKdeaXnNIaXjrjTVdSuCAWs9VIko7pafA0XaOJjxiX4S+zE6GIkrevEpDldXDhp2kHD2nl7d5bfNJIkCDGYD7VN8yPOYfK/lJRjAt4b0v1T/rUqHiJwfE5355RAVO+XQTBUIXj/IJT0f/wvIC64TqWVeJIosNdD6hF4XnSCRMq/pwA6qmmzzIlU13FnIe50hIa/Tl/aokMeVXvyYqhPkRXOQd7TaA2Qea15HURteV4XdcZ1ck+F9JBjBiZghfncPzdoI+gr9tkr+WGK54rJKIqaMv+bb9ARQXc91RvYqIOBRynov9KTjpcs7rujmMKI+0OSMuBVHhOs5vz2kqCmNiZ4lOQfyBpqEiHj1Gkde7lKwbcbq+RY9FYJp+e9ksXZ/ouLwX0u2jFw7iES+TcTwQOxOmj1obsih6vVgb5xeDu9STwJfdXZCmoRtq72296ohSY92cxmERrfhe/7Eo6oYCvbqtG0j9auS4O+s09T/uq82z7HXsy+s3i/d42JDooDYuUNB34oqBUblgL3lHvgX2Ou+6eLR74pjTtMRbqf7beSw97WqS4Ss2tZ8Ucw/TSRz0CdoExtaOfhcXMZlAat/ImnkZXr7yVpu4ktFcY6MXnFyl13gdg4ltuexVTg1hk65iVYvUIM5sfdPZ+YXUX07hm+kPmqJwJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(36756003)(66946007)(38100700002)(26005)(8936002)(316002)(508600001)(83380400001)(44832011)(36916002)(31686004)(8676002)(6486002)(54906003)(2906002)(110136005)(53546011)(2616005)(66556008)(86362001)(4326008)(186003)(66476007)(5660300002)(31696002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajRVK0FPRGsrOGRYZlh1WmFmZlJha3RpeEFZdFRpci9NK3c3OTU3L3Y2OWZl?=
 =?utf-8?B?Ulluam9aQVFkc1FJajFndWVFU1J3RlR5SmNjTkU3cDFqUjJKSGU2cFpaNHhT?=
 =?utf-8?B?Y0VxRGR0dlRqakJENEFMdW5CK01RNFcwWkxuL2NaRXJmY0Q4U1d2dkh4ZURW?=
 =?utf-8?B?NVM2NWVhYnE5b0ZkVDh3RlpUS0hwY2JEQnBOUnI5eWF4L2dwYi9PdXBwYXdX?=
 =?utf-8?B?Umd0akxiRXlURUhwNjRaSmNCZm1COFZscXROZzAxZTVrSUhXVWNmMlRNVFR2?=
 =?utf-8?B?NjIvZWUrQkhRVm5SL3RGK0x1dFVNSlJXSTliZGtNUDFqZE1TR1pGTUFPZEhF?=
 =?utf-8?B?ZFZpNVFMb1FEU1I0d2UvYWhCa3JiSE1UN2VGV3QrcjdzUmtCT281am1UbmE5?=
 =?utf-8?B?cDNNdzZPU1FFRGpVTTIvdGh5cE5QOU95Mmg5dDNDV1pzc2hnRkp5c0NDeXNq?=
 =?utf-8?B?Uk84T054b2RiZmk5aDB2aEJ0Rlp4Sk5ISXNQRWVVY0hURDJWSUZ5K2dQQU96?=
 =?utf-8?B?UmdLcXphYUg4disrQlZuS2xMTURhS21YVXhEN3hvcXhCMWY0cCsvOExLanVx?=
 =?utf-8?B?ei9IYmhTUWdaSGVyTDAzeEloRE5BMFROWk9KNEY1V2RkVzNHeFp3VGtySTBY?=
 =?utf-8?B?VnVHUTNOOXhrL3RSNEhoTHh2RmNsd3NaYjRUdHpaVW1iVlZsbVV3Uzd1aEg3?=
 =?utf-8?B?RXRHcGtCVEdoazJQWk9vSVdjb2JYSnRwcythYUViRHZ0SzBYNHR3clZNci8w?=
 =?utf-8?B?akRWV0VNUlZucEFqNHNqUUhtVlRoeU14eTJibjhpN0ZhaElhVHJ0R1dqMjhy?=
 =?utf-8?B?RjcxcXhjT1d6Q0REajg5dFE0L2Z4NW9OQVVzajA3ajdlMTdpYnMrdVQ2RGJI?=
 =?utf-8?B?ajZkTGxodi9jZE1qcVNOU09SdUJLdnRWZHVWTDFPd0pUeVNwZ2JrQmlaSGky?=
 =?utf-8?B?di9JTWZSR1VNR2pXdHNQQm41bEVHcWRqR0VleGYxOEJVLzZ2Mm5WL3dvaGJk?=
 =?utf-8?B?ZC9VOXBocktnamVWUlBFc0hPbEZ6T0FSTmlyYUdLdWZDbHRqdS9qNjBDQkNP?=
 =?utf-8?B?SFRKK1NRU1lnRkN6cjRCTi9jamhvajZ1QjBsV05TbURkU2t3NlpxOXdkQ0hO?=
 =?utf-8?B?UXRjV01GcjZuSDc1dWpEanZRMzd4RytBSS9TUVVOaEFEN2dpVmJPMzROZm85?=
 =?utf-8?B?QnZzYkZ0Ym8yOXBoamVTTjlPckNlR2t2UDI2ZzZtNzRKbW9STElxWnM4V1BM?=
 =?utf-8?B?QmZZV3k5ekU4U3c2UHl3SXh5c0JWdE1qdnFnc0VTaWI3Z1dWUGFpRW13czQ0?=
 =?utf-8?B?TUhXakd2Yit4cnVhWkhHUjJNS2hXTThKQjg4bmIweFNOSHVhT1VmWHI2RlNz?=
 =?utf-8?B?bjJNd1gveDBvWE9uNSsxRXRhaTROalMwQ1VZdGxaWThZRUFoQTNzR2V6SlBT?=
 =?utf-8?B?UExqSXFLN29wNW5GQzJ0MlZWeXhzNStHNkJQOXowZXNMV2hQQmpJL0M0RWt4?=
 =?utf-8?B?dHFxWTJNZjVsU24zS0RleXZEUDZlazJ6eFYwMFJJbnFsdHFBUncxV2hlWndO?=
 =?utf-8?B?aXN1SEU3Q3lXQkRoaFk3VGJGRWVwU3I2WjlPYjJ5dWtIN3VKU0JobHdZbU0x?=
 =?utf-8?B?MVZhUXV5blN2VDQvMGNWRFZmbjlpbURVRlc5dGxYSFJ6Qm1Ld1l2TWF0MW5T?=
 =?utf-8?B?VVZPdEJwS3cyMDJHaGVueWhlRk9rbDdET0Jlc3RET2xnbmM3YXhIbDBianhM?=
 =?utf-8?B?akxzMGR6Snc0c0JFc09pMU1TaXFTTklVMmZtRnplQjlpdTJkRlpkNmRxaXFm?=
 =?utf-8?B?SWpmcGxPVXh4dFBTYUxqdDI4aVpiSDVhMTFiN0pCaHlSbENpN2wzSUlGTG9w?=
 =?utf-8?B?RDJSSU81RmgyNjBSbDM4V25qT3RIWGFzcGJHWFJXUDE1UnYyOEt3aHFrcVRY?=
 =?utf-8?B?QTAzek1GMGt6ckd1aFZuR1RTV3EwUTl6MFhJM0dEWklNUUcrUDlUMzJKcXA1?=
 =?utf-8?B?Wm5yOStzS1BjUzhHbFY3Z2ZIY1BIYVZFdnRNTnpVd2l2NXFoOHNwbTFQVk1P?=
 =?utf-8?B?VWNuQXFnbjJQbUFveVNVU1MxSHVIeVVabFNJekRBLzVhOXlIZ0xjcU0rTk10?=
 =?utf-8?B?MXFKT25FNVVGL3dISTEvaFhmTkJiVGlqc2Q4d0RKVnN0Wk5OcWtBUVkrT294?=
 =?utf-8?B?b3NHT3JvNEE4ZjNtUTFmRTZkV05UMU9MS1c5SW5TUzh5VENkdWVHY1dLOUVK?=
 =?utf-8?B?QmJDdFg1RjUxU0F1ejVNcy9qRVd3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3557fda-2637-44ba-3505-08d9a84c225b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:25:19.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mtbAEVmz9fdPS4G9vnRbwjPzyqSzQLN8jNytgw3fUuKXKMRu/Ned8lY+hnjGzDrqfpRy5uB5WXX65FrOawIdDZxXICInO+u0IekyJevBXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150082
X-Proofpoint-ORIG-GUID: pmCMJOtvtsSH1DxYRQerb1H90iR1WpUk
X-Proofpoint-GUID: pmCMJOtvtsSH1DxYRQerb1H90iR1WpUk
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/12/21 06:59, Hannes Reinecke wrote:
> Add new definitions for NVMe In-band authentication as defined in
> the NVMe Base Specification v2.0.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>   include/linux/nvme.h | 186 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 185 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/nvme.h b/include/linux/nvme.h
> index 855dd9b3e84b..3e3858d3976f 100644
> --- a/include/linux/nvme.h
> +++ b/include/linux/nvme.h
> @@ -19,6 +19,7 @@
>   #define NVMF_TRSVCID_SIZE	32
>   #define NVMF_TRADDR_SIZE	256
>   #define NVMF_TSAS_SIZE		256
> +#define NVMF_AUTH_HASH_LEN	64
>   
>   #define NVME_DISC_SUBSYS_NAME	"nqn.2014-08.org.nvmexpress.discovery"
>   
> @@ -1278,6 +1279,8 @@ enum nvmf_capsule_command {
>   	nvme_fabrics_type_property_set	= 0x00,
>   	nvme_fabrics_type_connect	= 0x01,
>   	nvme_fabrics_type_property_get	= 0x04,
> +	nvme_fabrics_type_auth_send	= 0x05,
> +	nvme_fabrics_type_auth_receive	= 0x06,
>   };
>   
>   #define nvme_fabrics_type_name(type)   { type, #type }
> @@ -1285,7 +1288,9 @@ enum nvmf_capsule_command {
>   	__print_symbolic(type,						\
>   		nvme_fabrics_type_name(nvme_fabrics_type_property_set),	\
>   		nvme_fabrics_type_name(nvme_fabrics_type_connect),	\
> -		nvme_fabrics_type_name(nvme_fabrics_type_property_get))
> +		nvme_fabrics_type_name(nvme_fabrics_type_property_get), \
> +		nvme_fabrics_type_name(nvme_fabrics_type_auth_send),	\
> +		nvme_fabrics_type_name(nvme_fabrics_type_auth_receive))
>   
>   /*
>    * If not fabrics command, fctype will be ignored.
> @@ -1415,6 +1420,183 @@ struct nvmf_property_get_command {
>   	__u8		resv4[16];
>   };
>   
> +struct nvmf_auth_send_command {
> +	__u8		opcode;
> +	__u8		resv1;
> +	__u16		command_id;
> +	__u8		fctype;
> +	__u8		resv2[19];
> +	union nvme_data_ptr dptr;
> +	__u8		resv3;
> +	__u8		spsp0;
> +	__u8		spsp1;
> +	__u8		secp;
> +	__le32		tl;
> +	__u8		resv4[16];
> +};
> +
> +struct nvmf_auth_receive_command {
> +	__u8		opcode;
> +	__u8		resv1;
> +	__u16		command_id;
> +	__u8		fctype;
> +	__u8		resv2[19];
> +	union nvme_data_ptr dptr;
> +	__u8		resv3;
> +	__u8		spsp0;
> +	__u8		spsp1;
> +	__u8		secp;
> +	__le32		al;
> +	__u8		resv4[16];
> +};
> +
> +/* Value for secp */
> +enum {
> +	NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER	= 0xe9,
> +};
> +
> +/* Defined value for auth_type */
> +enum {
> +	NVME_AUTH_COMMON_MESSAGES	= 0x00,
> +	NVME_AUTH_DHCHAP_MESSAGES	= 0x01,
> +};
> +
> +/* Defined messages for auth_id */
> +enum {
> +	NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE	= 0x00,
> +	NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE	= 0x01,
> +	NVME_AUTH_DHCHAP_MESSAGE_REPLY		= 0x02,
> +	NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1	= 0x03,
> +	NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2	= 0x04,
> +	NVME_AUTH_DHCHAP_MESSAGE_FAILURE2	= 0xf0,
> +	NVME_AUTH_DHCHAP_MESSAGE_FAILURE1	= 0xf1,
> +};
> +
> +struct nvmf_auth_dhchap_protocol_descriptor {
> +	__u8		authid;
> +	__u8		rsvd;
> +	__u8		halen;
> +	__u8		dhlen;
> +	__u8		idlist[60];
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_AUTH_ID	= 0x01,
> +};
> +
> +/* Defined hash functions for DH-HMAC-CHAP authentication */
> +enum {
> +	NVME_AUTH_DHCHAP_SHA256	= 0x01,
> +	NVME_AUTH_DHCHAP_SHA384	= 0x02,
> +	NVME_AUTH_DHCHAP_SHA512	= 0x03,
> +};
> +
> +/* Defined Diffie-Hellman group identifiers for DH-HMAC-CHAP authentication */
> +enum {
> +	NVME_AUTH_DHCHAP_DHGROUP_NULL	= 0x00,
> +	NVME_AUTH_DHCHAP_DHGROUP_2048	= 0x01,
> +	NVME_AUTH_DHCHAP_DHGROUP_3072	= 0x02,
> +	NVME_AUTH_DHCHAP_DHGROUP_4096	= 0x03,
> +	NVME_AUTH_DHCHAP_DHGROUP_6144	= 0x04,
> +	NVME_AUTH_DHCHAP_DHGROUP_8192	= 0x05,
> +};
> +
> +union nvmf_auth_protocol {
> +	struct nvmf_auth_dhchap_protocol_descriptor dhchap;
> +};
> +
> +struct nvmf_auth_dhchap_negotiate_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__le16		rsvd;
> +	__le16		t_id;
> +	__u8		sc_c;
> +	__u8		napd;
> +	union nvmf_auth_protocol auth_protocol[];
> +};
> +
> +struct nvmf_auth_dhchap_challenge_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u16		rsvd1;
> +	__le16		t_id;
> +	__u8		hl;
> +	__u8		rsvd2;
> +	__u8		hashid;
> +	__u8		dhgid;
> +	__le16		dhvlen;
> +	__le32		seqnum;
> +	/* 'hl' bytes of challenge value */
> +	__u8		cval[];
> +	/* followed by 'dhvlen' bytes of DH value */
> +};
> +
> +struct nvmf_auth_dhchap_reply_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__le16		rsvd1;
> +	__le16		t_id;
> +	__u8		hl;
> +	__u8		rsvd2;
> +	__u8		cvalid;
> +	__u8		rsvd3;
> +	__le16		dhvlen;
> +	__le32		seqnum;
> +	/* 'hl' bytes of response data */
> +	__u8		rval[];
> +	/* followed by 'hl' bytes of Challenge value */
> +	/* followed by 'dhvlen' bytes of DH value */
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_RESPONSE_VALID	= (1 << 0),
> +};
> +
> +struct nvmf_auth_dhchap_success1_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__le16		rsvd1;
> +	__le16		t_id;
> +	__u8		hl;
> +	__u8		rsvd2;
> +	__u8		rvalid;
> +	__u8		rsvd3[7];
> +	/* 'hl' bytes of response value if 'rvalid' is set */
> +	__u8		rval[];
> +};
> +
> +struct nvmf_auth_dhchap_success2_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__le16		rsvd1;
> +	__le16		t_id;
> +	__u8		rsvd2[10];
> +};
> +
> +struct nvmf_auth_dhchap_failure_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__le16		rsvd1;
> +	__le16		t_id;
> +	__u8		rescode;
> +	__u8		rescode_exp;
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_FAILURE_REASON_FAILED	= 0x01,
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_FAILURE_FAILED			= 0x01,
> +	NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE		= 0x02,
> +	NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH	= 0x03,
> +	NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE		= 0x04,
> +	NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE	= 0x05,
> +	NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD	= 0x06,
> +	NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE	= 0x07,
> +};
> +
> +
>   struct nvme_dbbuf {
>   	__u8			opcode;
>   	__u8			flags;
> @@ -1458,6 +1640,8 @@ struct nvme_command {
>   		struct nvmf_connect_command connect;
>   		struct nvmf_property_set_command prop_set;
>   		struct nvmf_property_get_command prop_get;
> +		struct nvmf_auth_send_command auth_send;
> +		struct nvmf_auth_receive_command auth_receive;
>   		struct nvme_dbbuf dbbuf;
>   		struct nvme_directive_cmd directive;
>   	};
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
