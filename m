Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933CEC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 20:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AD660E52
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 20:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhKAUFE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 16:05:04 -0400
Received: from mail-sn1anam02on2040.outbound.protection.outlook.com ([40.107.96.40]:3981
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229560AbhKAUFA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 16:05:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dyul4BMt+++LVHseSfMO5iaAKrYSF4QbKeinVw10xtuqYGU53ocXkeaUIRhkn7xjZzt06W2kCWzd7tTe/4bZmy5/iE+Wi/fNglN4bY3Rym0pRnkiWKkGMuMOoyLawXQEhcyNBSJK8I1iVsTz5fnzNGNb+/lFJa2z7BKCNsdE58GH6ktTS6bGDqL+PONe9quVvgW390Z8sueQpyyox0OVpcLBVOBAI1oMxccQ2Cydr+84zzP7yNRpKCL/oo3X7ipgpdiciiXiWxfc9pRsE9HXBcR8URkGcHXi+kbT+yFlk312TR98XSycN6/x0wZVsYxPWxfBzWJcaak6papGPlLE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlXDQftmE13hNCqRZSgFu5ycXh7eWH6vrM0T4I9kYFU=;
 b=f1apXeeLd/iGy4A2Uey4KLWLAc/tnlcI/fKQoir9CHZzFnPzelaWg4I1LDoxdILov5ULQ/CG9jZBTngwUwxb7TdUDvHhHA2Hq03KvkaI/27OeIQ3bSupwl+zgR8coibKIMt4KRwp3ro67tUBFWEYchh3cIcEBZ5YQfc/oBxQsNLW5y/rNI1/eHckoKpIvKGxFnPE5MinFPEFWHLXoOIBs5+Cdw7/VWTRPaDtaWwN/b/A/CwmWOo030hky80OFlXrYtvNwbdwQ+Euqj+W2VzJMbUSQrMHpV0aSTCWnrAg4AwG7b2SOWg7R6sBMJypjM9J+WtE9QDbV81eybD5FW2VDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlXDQftmE13hNCqRZSgFu5ycXh7eWH6vrM0T4I9kYFU=;
 b=Q8B3oewsrp5mDNiQHS8ygcvPvW9ap+E00CDPuJfe+apviv8J9nCeR20Q0XIOz7OP3ayDvaul1GzMTz+YhTRf3je19fm3C9VKS0Ld3pXKmTOStozuqODkYRKAbR/avwgCDsHYcG5FqQ2wNMjY7LuXy4JYf0opF2ZTvoXDrdVoFNw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5344.namprd12.prod.outlook.com (2603:10b6:5:39f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Mon, 1 Nov
 2021 20:02:25 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 20:02:25 +0000
Subject: Re: [PATCH V2 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Peter Gonda <pgonda@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211101172127.3060453-1-pgonda@google.com>
 <20211101172127.3060453-5-pgonda@google.com>
 <952fa937-d139-bd90-825c-f7dfca8d8cb9@amd.com>
 <CAMkAt6qdNWP-Ka1N=0d16Q1TrbHPXPEkdLoxC8ndsyid-dqA6Q@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d6fc38fa-1caa-289a-ae92-102a96638560@amd.com>
Date:   Mon, 1 Nov 2021 15:02:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAMkAt6qdNWP-Ka1N=0d16Q1TrbHPXPEkdLoxC8ndsyid-dqA6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:208:160::43) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:160::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6 via Frontend Transport; Mon, 1 Nov 2021 20:02:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59cf16ec-8aaa-41af-8033-08d99d728603
X-MS-TrafficTypeDiagnostic: DM4PR12MB5344:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53443434E0BDA7089B987B58EC8A9@DM4PR12MB5344.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdrSOV6GTbDLv5QFU1Z6z0q2KsCtVkicHPDNdaICI2mlgxLdUIi0YDKOmqBEY8jcaqO/fwRuhdJhUTa3lzEBG4U9YriO47ExPQnFKQb6c211l5c1llbhy0vdiLjR3nL6+l2LerJ0eJWV4cVAxAyKPHPhy2/uJoYu1X67JJfh/Q8Ew7p+pULbX4ITQBJEm2DHOD3XUWVwSFMSuH39alFrMY5Q6Ov9L5a65zwHdIJmXJzEVlG0hDLdf1MOvkHTOvC07n6grOEMaq8OJL/tGF8/BV6JCfDnJ8a5Q+r3yc3RUHEmr1/oaV04/VsGKig19FwvyuJq49UDV107FLu3F/i4NCf6BJSKTVBj0EiOv48L2vJiXA9UJ1RaoTQHjvv+yZeBkkp7g80fJKVhSMk4YUxYYbszBCUHC23gND7k0Zd5Q2H+U2JPDtzJC6Td3AV8XiF4j5PuTyGUbtllcFTwmpnYuS6jlcy0yq0BkMGDep5rApeMszvdPNqaE5ZCGlaX+GclVh7JJJZ6vihynbU3K2192ZllEKWI7gcxaCH6BKXP01wDbRHBUptDVKLak3IIZeuAMHxpCllylutCB1N5ORAr9hsbgLijxWAqeiH2oYfLK4LSt1y4HKZc72Ksx2hsPDDhFNIZUJUebv+Ra/7Jtr6V2d64jg/QGKzcZ5hjqpAqT3FOhutijvL12AyIbTt87kH1pPJP3k+x+IeHZTweQiv/bmhFa1xuAImG2v3k6T6R2k/n++P86349s6z1Sum9ZkZ7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(54906003)(4744005)(6916009)(186003)(66476007)(66556008)(26005)(508600001)(8676002)(38100700002)(2616005)(6486002)(956004)(83380400001)(4326008)(53546011)(2906002)(86362001)(31696002)(36756003)(66946007)(31686004)(316002)(16576012)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExvUHpJdnczTFBhcEsyOHpDOFdMY1Y5QXdRMTU0NGRRbVZtNHRhcmVvTmZ4?=
 =?utf-8?B?NUVUbmtRaVdjemlGUTFRcWhaWGN2dzEvNXVOWDhJQVNhSExCcUNBbGsvSzhw?=
 =?utf-8?B?Um82U0VFM2lMb081K0RmcHJGalVoUTRvNUQwb1hCbDhmcWV6VklhVWhET1Np?=
 =?utf-8?B?YkZOWVZQQi94TXZxd0NwZ2lnM2VzaHUwT1ZiZVFPL25TSkRpSXJjNEZDUTdD?=
 =?utf-8?B?RFA2SzBiN1pMY1ZIRC9GcFI4cXpvSzBaL210R0x3bmorQ0docmd2WmxKNFZh?=
 =?utf-8?B?ZDBRS3BiaFYrTVd3WmljK01JcjNaOGVjQWY2azg2Zk1yU3BabVVyclVUN1Ja?=
 =?utf-8?B?aUVjR0ZydE4zblhsN0ZCYTZ4ZFpqdElGeHJIZzJrTHJNTGFTdXJVbk9wTU10?=
 =?utf-8?B?ZmRtTksxbTk2RjBjUVRoNmRVNkoyUnpHcm5xVWwrZDBXVkgxam9JOUMrRG0y?=
 =?utf-8?B?RnVFcE93K2thbHI0Nm9wMkdaZ253UDJDSzdHaE9hbWh1VkpjT2ZWVDYxNjd3?=
 =?utf-8?B?RFphd3UxOGVZSjRHSzNTUHI1WUhKMDZvRFZ3VHpKZTBycWg4cDRBejJRb3VP?=
 =?utf-8?B?OG5KT1BINUtYTzdrOVRpdDB5WXR0cFVjR1ZYM3U5R3IzZ3dnSHhoVkdoR01o?=
 =?utf-8?B?ViszaWd2VkFLRmJSMlp3OTFxajhaWWxpL25PdTIwaDJyZTVIZFhaYUZoa29N?=
 =?utf-8?B?b2JSRlZ5cTZ1aHM5dHJCYjdLblhEUWV1RVBIbllMbGtSVi9sYVhjUE9qai9z?=
 =?utf-8?B?a010dzBEa25GVHp5N04zOUlrc0ZwTmFTSzNWbDN1UEtYTitmUWx4aTF6ckR0?=
 =?utf-8?B?V1JNRFlibitSQVI3MkFqNHhUVTh1bXZYUDkwNGZrUUpMM1NKSW9BaHNFWEJJ?=
 =?utf-8?B?UkFGTzBFSlRSbmlrTlJTUXZFTm9pVmdDK1FnQzBBc2N1OUdQS25EQkI2VCtn?=
 =?utf-8?B?bERqN2JRMmF5eVNTWkdvRnl4c1JmZjhBWDJPQTlnbk9EUWpiK2lZTUlDUjZR?=
 =?utf-8?B?aUVYNHhqWllXQlBkZHlMdE9OeXg0dCszdFNQR082anFwQXM4ZVg4MWlrdmwz?=
 =?utf-8?B?bllscGtXcmFJTS9aRlROckF0ZlI3ZGdxbzRTQzNRUkVvbGhCWWZqZjdDNGFZ?=
 =?utf-8?B?NWVzYk90WHZwdDFMWFVEZngrYXZEZEFWaElRR3JEbkV5dEZLNmVYbHJkbE5D?=
 =?utf-8?B?VTFmSU44NnlTNm1LdnNHU0l5UGxPRm0wUFpxcHlhWHVFbmh4VVR5VmJoL3dC?=
 =?utf-8?B?NTVER1FEbVk5RTFvR1hCdVVoSmhCd3FDMjFZWUk4R05oTHh0eS84NkpLYXN1?=
 =?utf-8?B?N0VwTzREQXllR2J5NU1sK04zcUwxK1I5ZGN0ZzFmSU9aVnpXS3A5YzJmbUJP?=
 =?utf-8?B?SkpzTk5xSWlOeXBTdVJsalhjOVZ1YjVtbkVMUjU1Wm11a2dqSnV2UEg2QVlv?=
 =?utf-8?B?S3NOdmF5TE0wTEppTlg5MEs4QkJ1TE9rb01xRFd4N0kxY2xnZndIS1JwZmlK?=
 =?utf-8?B?TW8zeDFPOTBhL1oyVk1zZzA0cmdwemttZ25tYmk5WENvMUJZdzRDaFpieTYw?=
 =?utf-8?B?V25rSEcza3ViZHQ4bk1DcDNwYmxiYlZSYVlibHZmc2lRUzFZRk5YeXJoMklm?=
 =?utf-8?B?bk9URFREc25FSWxqeDFlTVhnekpCZDZMSTBlZ3BUM0xlK3JsSkFvNnV2azg3?=
 =?utf-8?B?aCt1QnZIMGdwaG04VFBwRmU3MkVZKzI3bHVpVkMwWCtRbTB1VXNVWmxpalRN?=
 =?utf-8?B?VWlUV3NzTCtHditrdVBONThIbHB1ZWc2cmJ4RHF0RjNqS0lkd0R3QlQ0Mzg3?=
 =?utf-8?B?VXVkbHpUYi9uempCelF2UnVSN1pWdFFrYmdzdFlPajZHbUVFZmdsTS90MEFE?=
 =?utf-8?B?S0M3QmhMVExCK0ZPei90MXFyZGp1RGtlU3Z5SHBsVFBJSmNUNThVSUFpcWpV?=
 =?utf-8?B?MmZNbWFJZFgxWURXbFpzUUxOanFQS0IzcjQ2RDNmeU1tRUhXenNQQWRXZXFt?=
 =?utf-8?B?NlNocysycGxlVW84dmhidFFSTmtyTjQ0U3ZwVXozSjNqUWNOc0pRWVpzR0tj?=
 =?utf-8?B?OFJVUkhCQzVCcEhMTTY2VkwxbTk4b1kxaUs2cHhHUWhnUmtZU2ZEejJCajBt?=
 =?utf-8?B?UFFqd2tUTHA1SDJZaFFZR0NOSWZtNWVIZHpDUmJsM2J6YnU2S1RFNFVpS3pE?=
 =?utf-8?Q?JN8EoFbTjs7aC/6EM3N1Qd0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cf16ec-8aaa-41af-8033-08d99d728603
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 20:02:25.2104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m49tgOqkts7hfIy2Y5Cyvi/Fm7EfrETeGTKZJWf/sx946dy2cIn1ZG/Cupbns1kT7t8pYq52knHKbBgNMKtTcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5344
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/1/21 2:18 PM, Peter Gonda wrote:
> On Mon, Nov 1, 2021 at 12:41 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> On 11/1/21 12:21 PM, Peter Gonda wrote:

...

>>> +
>>> +     fp = filp_open(init_ex_path, O_RDONLY, 0);
>>> +     if (IS_ERR(fp)) {
>>> +             const int ret = PTR_ERR(fp);
>>
>> I don't think you need the "const" here.
> 
> Sounds good, removed. I normally default to consting a variable if I
> don't expect/want it to change. What guidance should I be following
> here?

Heh, I don't know... I guess since its in such a short scope it just read 
easier to me.  But, you're correct, const is appropriate here, so I guess 
feel free to leave it in if you want.

> 
>>

...

>> "SEV: write successful to NV file\n"
> 
> Updated all messages. Should have noted the "SEV: .." format.

It's not like we were very consistent originally, but it would be nice to 
have the new messages start to maintain a consistency.

Thanks,
Tom

> 
