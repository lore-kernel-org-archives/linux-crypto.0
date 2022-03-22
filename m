Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B1CC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 12:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiCVMXn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiCVMXd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 08:23:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5048594E
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 05:22:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BK+zw8Q5xw8MaHmk6yfN3u4BJFJeNyfJItkbLSyKPGGQA7iz9PV01qHJl8/b/aNoQXkMnP/N4LXtO80rLyappu2Uqmupyy4ojKm0hRG9FaNRpdUQyujRMbTJ4cNuzD+SpboccoPqcA51se1zPO7nb+Dj/RSNypWFoqKJz2oOAVbZp1nl0vNwbkDpca1r14zkHCyNZ88zEt+Zq6aO82u6RBUx6KWvn1dzTsIt+VkRA8ILaZWhh/nTNZ7Zbaa9jSqJLr79Sc1urgOn2MxqUkGkHOuxbIetc75FFuuUlsNOx0KV+B1SvHnnYtXMktQ/Qt/r7FvS8y4DbImXxPRkx09j2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4L64Q4nnKu/ZQ2xQbxtgbiuiNF3eMswbYU6nlIdlls=;
 b=aybMfxwsvfFabWNdAh+NsvKl7bcpO9xI5SPjACbd0iB6ACCGgXj14de19ltbnS3esuhMmwrHLyVDiVEVWlXLZ0AmyCz+WhmuVvwxeXW7Zqm24wyEOf39nfw2hQ5H7PNMWggnJWXdDFaUZAOCMUOF9SZmMQduCzPnUEBcfa7edyKjEVTMVcJnQUwF2iDI6O7jyOPcOx3ev+gCAdwpRoDHGY8yE+iMv5QqyBDWinSfoo28ka9x9Yodl1LSzblCp0jWyCHWo1JQgcRMOKnqFCpW6Q0wEP3dKkA0/PzXNBy5ExGq3TmjrPop8ucj2KeJjOIhnH0l2s+Faa9UXUGUVkMwyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4L64Q4nnKu/ZQ2xQbxtgbiuiNF3eMswbYU6nlIdlls=;
 b=HkFhGhkBn6oCF4F9cX91NNgklxXfKCTZrb1X5gPWdTyAgx+gJWs5WvSX/6aWw8ePlYrKLkswejtcA5Pbtf0+H0kcniBUb28EzX79jNFhjfJ33whnyrlZpLYthEewQ6TnlxzVj+G49altjtUpNW2qnIXLRM/VxAP4DunA2jLFiVByqu/JozoifCjlV+6lxa4sNGvmUehdAtxfoSY/s+vBrtsnCwEsfJR2ufNsph7r7ljAIufjtUNDNIXmo2YLVBMilXZqVK59333LU9wWNv0hE6ByzzOzoVfPWi+g81lHqucarkCMDq3j8k3JO+funmeu8LzmoNL0oomWwsX5HlfQGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by MN2PR12MB2928.namprd12.prod.outlook.com (2603:10b6:208:105::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 12:22:02 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::f037:e2a1:f108:125a]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::f037:e2a1:f108:125a%7]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 12:22:02 +0000
Message-ID: <4f320d3b-7ade-211c-e1ff-d4eb37fe540a@nvidia.com>
Date:   Tue, 22 Mar 2022 14:21:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211202152358.60116-8-hare@suse.de>
 <346e03e9-ece1-73f9-f7f4-c987055c5b9f@nvidia.com>
 <3382242d-7349-e6f9-9b3c-4a5162f630c0@suse.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <3382242d-7349-e6f9-9b3c-4a5162f630c0@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P194CA0051.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::28) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 273bbc07-f234-4d70-b846-08da0bfe91e4
X-MS-TrafficTypeDiagnostic: MN2PR12MB2928:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB292843A147A8F9E3160CCA19DE179@MN2PR12MB2928.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlMYa+DAqXLX9s7xH0i+L6ezlg8PCf9A7FnKOG+wv5TJkgzS6dscepkWdLSBtQhiJlE38zqIKkFQA2iSpc+KMsfKI0A+VOrmReys4njaOwuCp3Pg+/okpeRg0bXGl3nbhwG2/58hFbnPcu1R21aV38UpuOP4D3i2bJKwiof1c/mFIBcC2Ru//id0lzMP7JgnvTe9WLgC00CFHErdBrlybnnn6WsGg3hBe6nPN0qC308B7OUbLj/Jwa0HdwvJisNSPEZqhCLKCKQXd1tAst3Vp/8Wkbg/4aoCM+Kd5Ew1grV9nu/TPTwFE1gIcyCGq/YK2d1hnxg8PjrbhGZ+XRrAPs10f/OA8ucsPu0MqbcCzxLlnk4mkN+jMXHaR8y9Li/O7KjqFIxcajGuLGlA0nvX0YlSsVx1elczq/XcYwn8S5BPtUi0Gn2aXujWl7qkQi76kIR58XvUblVDcgKETmtV+p5qpjvOIy5YLVJd9rNsB1k4PEz+2KhFjXLjD7DslkgwmXt9WoY8pldE1kqX7mtdAWy+s4ZX2TSRR3dnfm7+zihmSjTjnEWaIBnurFONmQy4227q5w0mbFiQBbvFl0JZs0UlPMoDdsjuaYgexfgyafaG8mNGy+57bEJHyDK08ux1XBzvcUNMzsV1vpeZd/HM2vx80iP/V/6z/wSIpGQvhLmADN9ot8mwEgmGecUnoXGreXh8VTY6FBQnTKjlgeiZ2ZhLrbjqe9I8r/8Hpv9URJ7dzFZ/riTzU9nvjyjDyopEH4jDJSNt4kxuUGO3wNeQ9beoXnRy8+6fXjFYMdr+yEcNHUQAnf2Bqxydwp6Qocn7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6666004)(6506007)(2906002)(66476007)(66556008)(8676002)(4326008)(53546011)(45080400002)(6486002)(966005)(508600001)(66946007)(26005)(8936002)(5660300002)(31696002)(86362001)(38100700002)(186003)(316002)(2616005)(6512007)(31686004)(36756003)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlRWN1ZCc0tCbDhYUUdkMlR0OGNuZG44cnBEb1JiUUJVUWxiWWt4aDdVZmpn?=
 =?utf-8?B?enJTMVFiSUpLYVBnK0YxVTBqeU1DV1pidGZiZ0xIQy9FZEFNT3QyK1JHdUhQ?=
 =?utf-8?B?dENIa3BuQzkyM0lvRmxFdjF6S082S3NzNWxMcmFxOU5BbUcxSzJVVUo5QkdP?=
 =?utf-8?B?MGY3Y3NtOTJvb2pZMW43eml4NG55NkVrVjFHTGpBWExsOVlNTXRvb3haMlA2?=
 =?utf-8?B?MkxOS2xFOVExaUQ2cXJlb3htTXpBcWlaLzdPM29nT3pGSHpjSnJxYnJLWVhP?=
 =?utf-8?B?TUdWckwwQXlPVCtXOVMwV3VReTRVV2JHNHlieFJvYlQzaGZyd0hXdGhCbDZv?=
 =?utf-8?B?TFNSVG9jU2NCZHV2Y0RBZkMzYzZyQzZCSEJBQVVISlJoSmF3RVNySzA3RFFk?=
 =?utf-8?B?NCtqZHVYcGxPMWtMcUVlMFJrUGFlVktvbUhUbnk3NmJSWDBKdVI3UnBRVGx0?=
 =?utf-8?B?MEpmc2xoeWZQWlpGNTFENGd2VFV1T3dSUytvNDJRTDJ1M0htT2lWMjFtUjY5?=
 =?utf-8?B?YTkxUzVzMjZITFFUeXptVExNRERKYU1zUkN0THNkM1NOOXo2SVdYeVZxQ0xI?=
 =?utf-8?B?bnNaYmpSQjRoSk01RnRBaDhqKzdjQXRVaVhuRVVIYWZEL0l2RWZnYzRvWlds?=
 =?utf-8?B?a29BVTlxaFpJSWVBTGQzZzVvZ2VFQy9GbnI3dDRacFJyRE51WDNaSXVHZzZM?=
 =?utf-8?B?UGNMbzVRbUcvTlFLeHdKb2h3TXNmR3J5ZHpKejFBZ0FuYUNUbWQ5TVFVTzUy?=
 =?utf-8?B?MU1IUUFHOTRvN3dIc2Y3UjczVHlFdGRlZ2QraXNlTEpmTHJNU1hJbGZjdUY4?=
 =?utf-8?B?c3Ayb1NZK256NDUwOU9SenpxYXptbHZJbjNhSWYzTUkwUzd1RzVqVktMYnU5?=
 =?utf-8?B?MmZwb0YvYTRvNjh5bzl0MEd3YXhUd01LbzZDRW9wK0dkS2FGa2U3dlM0ZHJE?=
 =?utf-8?B?WVdtRFl2Ri9NL0R3QmxreWgxOWxUajVUZVRXWFBIU0ZTMFZHMU1EMndZRkhU?=
 =?utf-8?B?TG1tUVM0RzBpNTBqbmFxR1hCMmM0clVkZnY3UDZEM2pSOFliOWQvZG4wYjRx?=
 =?utf-8?B?SDk1OUlkbm9iR3NYT3FGczQraTBUZ21xSmtTU2RhMm1YUVlyeHhoaksveDZS?=
 =?utf-8?B?eWYxUGlWRldxWUZUV2h4ZWdHM09kb0lhZUh5bmhkNE00Mlc3MldubXJSSjJ6?=
 =?utf-8?B?WXN4cVNpTmNRNmF6YzludmZiVnN5d3BjekNZRFI3TDRDaUtzKzVPNy9OSG55?=
 =?utf-8?B?azFiT0ZuN281WEI3bDVGVS8raFlyOVlEdmRtb0Y2MG1YaVN2N2REVmROOWhB?=
 =?utf-8?B?ZUhIWmFJcTA4MGFtN0phMGQwOGhjNXNiTldVMXBoWjRtU3F1S1I4UEFHcmZ5?=
 =?utf-8?B?ampsellnejFub1YrOFp1d2VSVUx4YWg2VHFPcWhEaHVFM2U0cnRUUzErenNN?=
 =?utf-8?B?ZmhJdVNGWk5MVjZTRFhKcHNqRFZTeWRVQjFLTHNORTNkaHJha253OHlJb1hz?=
 =?utf-8?B?cHhRN2h3NHMwQS9QU3pta1lOVEx6UE5tajE0NE5PcE1NMDB1Zis0eFBIUXhM?=
 =?utf-8?B?L01LVHI1a0VkRkpVZWF6dUhPclFtZWFEeVZsTWNldmhGeXRjbmM0NUpnMGZu?=
 =?utf-8?B?UGlzcWZkV1ZSMWNPQTZaWXVEdGlPdnA1ZDVpZTA2ZzBiV3ZzaEx4MHpzN3ps?=
 =?utf-8?B?RitwblFkNWZhQ1JtYjhZTkg5YkRWcmdPOWhmaGlxcGpXZmRFUG5GdVRtQ0ZC?=
 =?utf-8?B?eXAzZDBDVmtmb3VjcHIvYXBnU3RhR0hTN2Z1R2tMY28vVFE5STA0Vi93NDFT?=
 =?utf-8?B?amtuUEhZMEQ0ZzhXOXdlcytMSkphUTVxdWZndnNOSUFWbmpGbE1TRXJ6NWw3?=
 =?utf-8?B?NWVZR0JoK21qVW8vSFl1VG1ocUQ1WUNXcEtoc09XY25Ca1JycmZ1bVVvelhF?=
 =?utf-8?B?NW9uY25CcFNIRHFEOWt4dDhodE5JdFY3SEIyS2Jyc3hQTEpBUXd5N0VnMHN3?=
 =?utf-8?B?RC8wOEwwdHlnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 273bbc07-f234-4d70-b846-08da0bfe91e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 12:22:02.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6d0lvFcRdWMsLVh85Odbi/RKXASJwth9bxUKcQudmD2hnl6ZNmsVKKs0ZS7eF+SZ22rxkQK7Q+UK+hi3rxmQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2928
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 3/22/2022 2:10 PM, Hannes Reinecke wrote:
> On 3/22/22 12:40, Max Gurtovoy wrote:
>> Hi Hannes,
>>
>> On 12/2/2021 5:23 PM, Hannes Reinecke wrote:
>>> Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
>>> This patch adds two new fabric options 'dhchap_secret' to specify the
>>> pre-shared key (in ASCII respresentation according to NVMe 2.0 section
>>> 8.13.5.8 'Secret representation') and 'dhchap_ctrl_secret' to specify
>>> the pre-shared controller key for bi-directional authentication of both
>>> the host and the controller.
>>> Re-authentication can be triggered by writing the PSK into the new
>>> controller sysfs attribute 'dhchap_secret' or 'dhchap_ctrl_secret'.
>>
>> Can you please add to commit log an example of the process ?
>>
>>  From target configuration through the 'nvme connect' cmd.
>>
>>
>
> Please check:
>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fhreinecke%2Fblktests%2Ftree%2Fauth.v3&amp;data=04%7C01%7Cmgurtovoy%40nvidia.com%7C4e6a16198c834c87e2ac08da0bfd01fc%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637835478535167965%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=OgZkPCwDUIllRWfKF0SoC6osWJy3hqAZouME3KDnIGQ%3D&amp;reserved=0 
>
>
> That contains the blktest scripts I'm using to validate the 
> implementation.
>
blktest is great but for features in this magnitude I think we need to 
add a simple usage example in the commit log or in the cover letter.

for someone that is not familiar with blktests, one should start reverse 
engineering 4000 LOC to use it.

Cheers,

Max.

Thanks for implementing this important feature.


> Cheers,
>
> Hannes
