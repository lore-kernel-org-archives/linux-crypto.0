Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E93C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 15:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6159861029
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 15:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhJHPyH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Oct 2021 11:54:07 -0400
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:62333
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243240AbhJHPyF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Oct 2021 11:54:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDaU8CAl4uZxOioKrREpxkjyIERNGivdzFXo0pesJNRvdUANkSgPJzXlifMy2G8FDFPmf9vieUldk9V9G7XXZncfQUdLAstMNLavHIhk0QDmcgBdzA0AlyWfwQmJCO2Gv1PJZP7xSU+/kMo2/EfHgkjPenN9RGkCzFz4AOiwgUR99pvTRTSKLjOhlzT1x8E7uR3l8KFhYxDpaxPMNxuJNkgH6lNtG/T9fFqdrt9K8UCQVxD/rn2aIwfTGz7m9CM/K+hl2tljDBMv4AKQXV927nZD8gUFISX1IrzaLP8gVx5b2lwmtuneL4IcImlzk626YLKGfMQ+Qgtlj+d9UJKvUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0fkFf+XO+RzFz5mciVh36hckAuP181cjZV/rhjkm8E=;
 b=A+eRk9VxVUwBxQMyU4/09roqnzq3hETQdhrkV5ZiQ556efnjmV21d/2L+QjVtfVtxkWijmwQTQvxFWp6J2gzow3vTja6lJS8efyqmVe3wEMqz+deFPLH0BBhGSPU6YqD/nWqNhoNEW/Biu8Z04232HxSufiuBGQyx0L8DXMN5tlN+wlkqlvjyh8Uo9KQShm80GpWW20uZc1h5acMWpRe9oW+fAwgRMMcxFBMIvpVzum52DDJGRn9JBzQf4UPpcgjosqNY7hGqLVoEQGgRGcy6qM33872Y5KwSS7X2Vunsb931FNJxECYQMUamhpv740XG96HsHhNo/U87uNTI11OwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0fkFf+XO+RzFz5mciVh36hckAuP181cjZV/rhjkm8E=;
 b=JNLtdCxSURXFLtWqmHclJQ6Rh3mvPAHY/vbtPSzsj8k7MUECxH5XwJyDGfNrb2Q+fcuzpBarMifwtBHaEomjF20aLcuvzH9GziTcZ0OCdUW3HT0snD1mu0eqkhygZiHJcuFt2nvdgKxYiHBhNPN7K1/LFp9BjbbgO1yel0pHn9A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 8 Oct
 2021 15:52:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 15:52:08 +0000
Cc:     brijesh.singh@amd.com, Marc Orr <marcorr@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Consolidate sev INIT logic
To:     Peter Gonda <pgonda@google.com>, thomas.lendacky@amd.com
References: <20211005195213.2905030-1-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <fdf0c263-38e9-7780-d0ac-943b6d2dd3a3@amd.com>
Date:   Fri, 8 Oct 2021 10:52:05 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20211005195213.2905030-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0166.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::21) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SA0PR11CA0166.namprd11.prod.outlook.com (2603:10b6:806:1bb::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 8 Oct 2021 15:52:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e9590b0-59bb-4259-fe4b-08d98a73958b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268866B83B430AD30A7B8A03E5B29@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wS8ChNzse+zaKI7LN7tVGAppHGeybkV1OKQDgf6reK0R1FwoRGYOFIE5I4YkAsS929+AfiGUjPXEpFKuL7FareQEj/rrK6xfWFFgx86zAzst864HUif82lyMD1E1a72Axt8dXkaJa3KdHjLu537YAQLHVBax8dBtUNS2LfeH48x7RpSTw4paA6j25aS++/doOBbAMhkW5yiAaUxJuw8LcE0cSEmO4xEAAfRzZusrqewTU2Nrxx5MfjbPIg9J2+Md8Puulr6pcEjpS33u08DXl1cRyp2GxgTglMVTR1+I/UIEOMV3I4h0rQy/XD8zQ4e4sbgKBTObyU9leyUfy3b5J38+fJjjmaD++PQ+obeVYZnfIzpVNsVg+CNI3XzRixnhdFbDsz8wwc8EE23gJEw9BO7FGdDywD5Vck/mPiB7VnalaXsYW1G9qf4dTxJJ8KDDG6AjJHsl/YrPZD1V5ZSoeu2t8AGBone6MK5oyqyfs+K3SEdkFNHsJXpfbS/sKeFqExiszuPc3/4sytD1OmEnc0y1Z51RCYhpaMzJQQnCbOpNNLJdKC8AtAPM+UHQ0tdy69vh3K1vW4kNgVS5Hvw8I4xa4GvQ3Ij47wp3qTxs/kl1M3mgbXyPmidX0k8xDfx2F+rg5ET3CohqojuN+QZBmIx1L1f5tcwKqgqGnvjeEajWf+Eulcz1sh2K3fB33mZgMLMv/AoJ2WkZ3VhZywZDi6ZzRlfz5WjK4OqxxomMYja8pmIP+fkkCow6jqmbPxRf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6636002)(8676002)(5660300002)(8936002)(4326008)(83380400001)(508600001)(36756003)(26005)(44832011)(66556008)(31686004)(66476007)(53546011)(6506007)(316002)(6486002)(2616005)(66946007)(38100700002)(186003)(6512007)(86362001)(956004)(31696002)(54906003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzBQQnFtYW16cmJMVkFuZE9JRjRNM1doOXVndGQ2azlicXpGQ2VWdEE5Uks5?=
 =?utf-8?B?UFRGaitvV1h5Mm9JbU01VzRCQUxSWldTUU1DL1l5SkpZK0sxaEsyLzhnMzJK?=
 =?utf-8?B?M3RJSjMvVy8wVk1XeEsvMkFmQi94aC9xTkVNOFF4ODVhY2NlMzNsaWI3ZGlS?=
 =?utf-8?B?aTM4UXJkQStSRk0vNUJwYlBFK0NDWXJFY1hHbVhIcTM1NUFDQXp1TlNKMmRS?=
 =?utf-8?B?czU0ZHFTWFBUWnNyQjgxYWhPdkFIemtWRmhyNy9FUkYzWmljRGlpMTRCMVlQ?=
 =?utf-8?B?QlpIWCtjTDBXK2UrV01xcXhsREE4SFdhMVA2N2hOY0lUbXVHRFpYa2ZnU0s3?=
 =?utf-8?B?aUJXRmpQcVVkY1IrZXkvcVV5eDBMUExwNFF1U1VGSG5yNnRxUlN5NWVqMSt1?=
 =?utf-8?B?TjVKdXFjTHlzRWNXUHJ4dWtMU1Y3SklxZFJBTjlyUGVwMHNxK3ZZZzFhazgr?=
 =?utf-8?B?WExRMSs1c0U4TEFSNWY1YlFQNHJLTFB6S1hlU0xIeC9yM1BOcjYvYmdMNDZU?=
 =?utf-8?B?dHNzV09WUFdzcW95bWhDZ2RtVDJkSjZKTURwYmI4SytUVFFTTHdCSUdVWVRx?=
 =?utf-8?B?MjN5K0QrdEpyODZiV29vNGFRTEwrd09hMWtjWDZwWWFOWFpRUTFGNDBkMlhh?=
 =?utf-8?B?cmNyMDJ5SUh6Rmpxemx6dytxbzdRTVcwMnZIV3JETzNvM2V5V2NCb3FzZ1R5?=
 =?utf-8?B?bjVLbFFjaWxZN0RXRWJLd2VEZE5IWktBNkZFUjRRc1ppdms2MVlHOTFJckln?=
 =?utf-8?B?UG5ySTYzcHBJUEdseDhJRVdrY3kxQ2dUQzl6NnF3SkM5OWpDNk1jQnY5R3FG?=
 =?utf-8?B?b3BpdnVHTWNFUTJXZDQzeGlwWFJKakpoclhyNzB3c0tUNFBHckdUbEpYaW5B?=
 =?utf-8?B?bEdKS0tvUGlzL0gwTHQ1bkpBTU9qT1JmdW54Si9MZ0NsODRnWkRpNFJiMzlw?=
 =?utf-8?B?Vkh6YnFCM2hzNGl1WXdFMWVkazFrN2k1WFMyQUQ5WHFBdGpCRnA1Nm9ZUkZJ?=
 =?utf-8?B?cmJQRGFIOE1BY3k5YmRWVnRBdk9zc2EyR3ZVbFBsaWhLRkphdmVhTTFDL3Ar?=
 =?utf-8?B?Sng4L3ZLekROaFhHaGxuTWxxS1VOWXlabFEyQk9KL3NqNyt2My81NVBKRS9N?=
 =?utf-8?B?aExjWGtXcUt3V2pHQU9jSGRVZ0tnRW1TSU51MTU0MXlGNEN4R01pZm9TQXI5?=
 =?utf-8?B?clpSZklnaFh2ZmsyMVA1MHJTdGJFeUF3T1RhZk5vTm16ZStubDYrSVdydFR5?=
 =?utf-8?B?VUJnZmhicTlyOWNaT2VqdndCNFRMM0FKR0UwWUhmWmNuYnN0emJ6TktGNmZu?=
 =?utf-8?B?Tml3UFFJclJaejRTNThrSFA1VGtCNmtaQlE3RWpxWUY3YzM3VDlRMXdrdUZz?=
 =?utf-8?B?SnVpaGZuN1g0KzdIQTBESGxWNWcwZDhnR1QzMmRkNEdLb1dFK2VWbGV4UkVN?=
 =?utf-8?B?MlQ3dmtaQ2drc1BqcHJ0THh3YnVxWFVZam5BZmU3UG5lTE82d2ZGNlB6WFFF?=
 =?utf-8?B?K2poejk4YjlwQ25kaXgxTHhrQVo4U1dGbEtIN0UzQmRndVpvZUFRRTArRTNS?=
 =?utf-8?B?MkFQMktlanZ1UzdQVVh0VktaVHlmRlphMjFWSVFNclo4YkFLVFptWWx2cHJT?=
 =?utf-8?B?c3RqRCtOVjNyWmtrZWZERHQwdE00ekw4SWxQVEtsNTNOaFo1MDBHM2E3UEFo?=
 =?utf-8?B?NEtSTGtTblNMTCtDb0c2c3V4VHI0TDdoZFZicW1GT0R0cXhTVEU4eTN4Ni84?=
 =?utf-8?Q?J+9gbYAc1jrYCa6l+ExIx14oa0EveU6TlWEhqMx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9590b0-59bb-4259-fe4b-08d98a73958b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:52:08.6126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VK/2KY5wtgqxxz5slpVVNOIaHRMa2cCmDA9NR9SCyO7iXhxLxC4YbBacy6Mxwd6udRzRc9W0Jfa8C0oEFfEWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 10/5/21 12:52 PM, Peter Gonda wrote:
>  
> +static int sev_init_if_required(int cmd_id, bool writable,
> +				struct sev_issue_cmd *argp)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	if (!writable)
> +		return -EPERM;
> +
> +	if (cmd_id == SEV_FACTORY_RESET || cmd_id == SEV_PLATFORM_STATUS ||
> +	    cmd_id == SEV_GET_ID || cmd_id == SEV_GET_ID2)
> +		return 0;
> +
> +	if (sev->state == SEV_STATE_UNINIT)
> +		return __sev_platform_init_locked(&argp->error);
> +
> +	return 0;
> +}
> +
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>  	void __user *argp = (void __user *)arg;
> @@ -840,8 +825,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  
>  	mutex_lock(&sev_cmd_mutex);
>  
> -	switch (input.cmd) {
> +	ret = sev_init_if_required(input.cmd, writable, &input);
> +	if (ret)
> +		goto copy_out;

We need to call this function only for the SEV commands (i.e input.cmd
>=0 && input.cmd <= SEV_GET_ID2). Otherwise a invalid command may
trigger SEV_INIT. e.g below sequence:

1) SEV_FACTORY_RESET   // this will transition the fw to UNINIT state.

2) <INVALID_CMD_ID>   // since fw was in uninit this invalid command
will initialize the fw and then later switch will fail.

thanks


