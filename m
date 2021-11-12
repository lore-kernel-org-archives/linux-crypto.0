Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C448C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 23:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA67060ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 23:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhKLXml (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 18:42:41 -0500
Received: from mail-dm3nam07on2080.outbound.protection.outlook.com ([40.107.95.80]:65504
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229674AbhKLXmk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 18:42:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xtk1f6PHzy+SU56WuYsEdsmU4II5JUh4Ey1zbhOLHfHSIHUbBaE2t2AowT0us5CES0CLk0ar1uqR3qsYSVmMvvVQvw18oYmV5XKSCF/8zLZCpT/kfC1K118i942PYpDEBfbNy2pfjdJdLHjYSfVLAmwKZLGCad0bhWQ+0W8hXmH0CDlPMlXwFYSi9PiJClecbJsiF4z6lnH+jWWJe+pOmyo6AF9MRBujdMNV/zuWIQ54vwCs17jifx4y+S8TMHBQ7Glixp2B1xSb7xiDWRYeBRPfDNtorTfjXzjw2gRCQKSTQ31+oH89ltn9AzfZaPBy2DJmjHW7XC4szAmegGgZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1BvMiOou6IiP83iST8RBByVWqWC5YbEDZdT9PmWALg=;
 b=gyTXYYljF/iA1u2tzJbo4TTYI6qZdV267qpkZBbOZboW+g2f+o3iovlTkOdYcg738DMKleA2R6vtnl9sDsVn1jrtLGwbxvo/Yw8yGMjpj0GFL94O/CbPZEz95MSRvKW6zE2TtfURjIR0URqrqkt49PpFc175QXQedtWj4cAfWfw9ocTvoC0rjAqUjcK8sBTWOnT2n1M35wecUQNC3FVL6mPH70V+shwHi/I9wp6e9doJTa8vbsOwHFGpL2degfdyQEJ0QeXVpg0IcpDC4zvpCbDDUE5w9JwoSMHJO4izRjsLX7mGCpucvIerJ3jyC1sw4xv16efbhCqGQZ7Gm3vz4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1BvMiOou6IiP83iST8RBByVWqWC5YbEDZdT9PmWALg=;
 b=Pb1xRMaaYhg3IFda5lyKByNXiPYdVZdQg6csGusxmy2HeHG0UrUoMMuGmWr/5KOv4R3qW4ATfzZvRaCxGefWh6aHt6sYIdU8p7L2WQcV8H0B4zk3CRX/2UOAp17mN0KqJZ/AhpcFti59aGfIrOlIMOqYKXuYfM5MNGY/nsJ/GLs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4670.namprd12.prod.outlook.com (2603:10b6:805:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 12 Nov
 2021 23:39:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4669.020; Fri, 12 Nov 2021
 23:39:46 +0000
Message-ID: <14e6c746-c7d3-8cca-47ed-b90f31e4e495@amd.com>
Date:   Fri, 12 Nov 2021 17:39:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Cc:     brijesh.singh@amd.com, Sean Christopherson <seanjc@google.com>,
        Thomas.Lendacky@amd.com, David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] crypto: ccp - Add SEV_INIT_EX support
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
References: <20211102142331.3753798-1-pgonda@google.com>
 <20211102142331.3753798-5-pgonda@google.com> <YYquDWbkIwCkixxD@google.com>
 <CAMkAt6rHdsdD-L4PbZL7qaOY7GRHmApVJam0V0yY2BnYdhmPjA@mail.gmail.com>
 <YYrZXRTukz3RccPN@google.com>
 <CAMkAt6qauoiTBXF9VXRGiqtJD5pTAV=NqKHZgNFXHCkrR50gkg@mail.gmail.com>
 <eff7a2cb-f78a-646a-dc0c-b24998e9e9af@amd.com>
 <CAMkAt6rj94Mzb6HBaqQbi7HHfhS4q1O4fxO8M7Xe=TZeZ0zZOg@mail.gmail.com>
 <CAMkAt6r5MJq0rGYg7MAqm83Xp4mBADSKtQxV=i2_OFuQnDd5Yg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <CAMkAt6r5MJq0rGYg7MAqm83Xp4mBADSKtQxV=i2_OFuQnDd5Yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0040.namprd05.prod.outlook.com
 (2603:10b6:803:41::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.0.0.5] (70.112.153.56) by SN4PR0501CA0040.namprd05.prod.outlook.com (2603:10b6:803:41::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.8 via Frontend Transport; Fri, 12 Nov 2021 23:39:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd07790b-9656-421d-f9ea-08d9a635b54c
X-MS-TrafficTypeDiagnostic: SN6PR12MB4670:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4670DBB3BFB48487282A3001E5959@SN6PR12MB4670.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CAHmKwKlZqep0lDm362ogakyFXOMrhcrSd67YsqIEHbvlWSJhqQ1Whqhw1ZQjjOW4F/eCwLSALBFMiIBsuKp19JwzqGwQkKIzT8neeYsUgxMIaH7xekb8XJuX5l9eUOOfwSprWd7i8gD/Ad5pw31rT8rIDYAqPE0RkjMzDs9yXDZm+lzAVKsm22ZVGA9GTf/GeXDZvGZMZfhYS66aL8p6gAQOeJQYxUBU9MxyY0PZwZOlw7DM1dcf21n5iv5qCbwoFC5aut3AMIC1C6y5Rv4kBrHgvXbNKJZ+q2vIQD694JtGtC+K5M456Sz820HYM6geD6pUVzG2amrGTs3LxpZC4HeP1VoXd+czKxRFBcReXi5nlDvxquOE4FLVfNr0okVvYBjGAekQ969kGm4/S7dRYEU4xJbt8ddtF7WnRQ5qngKoBrCDmu2Pwhvvvg8fgGNO9oR+X2RqmuQOqEyLyZoW0ntiJNGLSpjQ8tGm1fdf8KUL3QLu6hOMaMC5VXwsNeCBGHMUfL5gsBqgreSE+kXnicCLTjov3DzVIkglrMdq0tuG80yjw7uw4zNKNSac+dcakQdENanF9qbaq/U/tfFqrXt92ZifneNvTVV7pEDYbXKD4Ibm2VouNa6kU2WOBL7wC14QVsULKXXWZoRh7Le48/b3q8pDIPDz51oWSeF92yKpM7sijgb1OSeNL4EyeHSLW8H4BzPUii1xTksfHf4rY98RxpKrdQI51eouwb+2ALh8Z0MbXiaecpBrEHvMmZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(36756003)(86362001)(31686004)(8676002)(8936002)(7416002)(31696002)(83380400001)(38100700002)(2906002)(66946007)(66476007)(66556008)(508600001)(316002)(16576012)(956004)(186003)(26005)(44832011)(2616005)(4326008)(6486002)(5660300002)(54906003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGg5dTZ3ZEFlRUw0ZzhBMHlvbmJGL2kvUW10NUphaVlXZ1UrRmZQMTRIREF4?=
 =?utf-8?B?RWdaMjFpaS9nQjFYN1VuU3BUT2ZXQmN5bUVsNmRMNGovM081WUF6SVlrVjU1?=
 =?utf-8?B?SFlpZk9pcUF5aVZVVmE5eURONm5lVWJZbVhSWEE1Vnh5RWpXVHV0RENhb3dn?=
 =?utf-8?B?TlZ0MmpKeXMvcXV6cWxVMVRITERMemk0clhZcUtuQTQrSG4xN3FjU1IxU2Nh?=
 =?utf-8?B?c0ptWnpuRjVaNVFwU2grOXR0dUZCTVJONnhPWURVb3ZDbllkVVpwMjNncWQy?=
 =?utf-8?B?RTNwb1pHcU9jcGlNMUlac1VGd2t5azFyZzJEZUVRNURSTnhRSGI2T283bktW?=
 =?utf-8?B?UFJmblVXNWxZMmRPQ1h4L0VXdU1NVVJnVWtCTC9pbHl3eGE5SVNYUS9Dc3ZK?=
 =?utf-8?B?MGJHMEdSa2J2QXIvcGxmM0N3QkF0NjVIKzByb0laUGRDUnpaZXJYWmZZcU42?=
 =?utf-8?B?Sm5Ic1RTNUNOSVUzQmI2RlltUFNnQlhabmczTzQzK1NPdGRpQXVZVTd2SHRi?=
 =?utf-8?B?dENGUmV4YTdOM0VjMFZ2VFdmdnl1OE1HZ3hKa2pNczNmblR3NU1YaVNuQjlk?=
 =?utf-8?B?NEJyYlJNWHpqQVZISURxWkUvSGQ5VklRY1d4OXlqR3pFRlBuR3crY2Vjd3RM?=
 =?utf-8?B?T3QrbktpVVhVb1ZtV05QbmQyTWxjSFNiaHdSL3dBODVSbUUvTmduOVpEUFRR?=
 =?utf-8?B?eDExUjlveVhDdi9PMDkwUWpJZUE1T0RxdHRvQ3ZUeVE5MEd4YXNFS2xNdlYw?=
 =?utf-8?B?ZmYzdlFvQkRQRkowN1RqUjNSTTNTUFIyQjF1K0VXVXRHa3dKdWQvU1ZmZHE1?=
 =?utf-8?B?N09nRWp6clAvYnEyeUUweWo1NUpVMkM2bVJvSm5hbzlFSUc2RHNPSzdZbVlS?=
 =?utf-8?B?c0tQQTIxL0M3c2dPREFoaERRMmVKQmZzQ2FCdTNtR1cvMFUzbDZoTEQvUVZz?=
 =?utf-8?B?bjVMaDFLZWllNUVnenNnTlNmWFdLN3VFVHZvL3Jja3Z0UklkNUhjeXp1VWpn?=
 =?utf-8?B?NTB6L1JRVCtjbk1CUEdpdnU0ejc0b1FHNDVmZ3JaQjlhZ2w1VS9OUllMSjVv?=
 =?utf-8?B?dnNrN2dDaXpUM0lyOEVNMktDZHJGUkhIMXZNaGVud1JlMXVwYkY2YVJIU0dB?=
 =?utf-8?B?dm5YQ2ZzbFdIWHRYVkxEa3REVDZRWGovMEN1UEpKQXRaRnZod0d5eGpYMWVw?=
 =?utf-8?B?dFM4V3BPUFVmdnZqb1VLejdOd2VFM0d1bHFwZFEraUJlOThZRTZkZE5VUE1C?=
 =?utf-8?B?TmI1Q1JJejhscW5JQmY4UDNqN3R3QVdlVW03cVhPVGNtY3plS2ttQTduU3Yr?=
 =?utf-8?B?YVhxd3padXB1YSt0NWlmRWh1TnhCYmZyb0tSVERUT2lVL2Z0ZFl4dUVtaDdj?=
 =?utf-8?B?NVk2Z3dMVmNwM2VBby9PNElUYnY2Ti9Bc1RWTWVXcDFzM0xFMEQ5QlQ4YXBZ?=
 =?utf-8?B?MklvVDFnQWdDaFhyN2k2U0dMalB2WjlLdkd2N2dFY1NKN09VZXdWSFIvU3Y1?=
 =?utf-8?B?SXB4bmYwVkpKNUEwR2grZERwT0RNRFlBVUg4ZGFDTE0yYU9yOUEwTUFLOHVG?=
 =?utf-8?B?SlNYVnpGUUtPaEZDVmJWVjVRMjNvZkgzMEdHTU5qVm13Wm5Rc0hrSVlpVWdu?=
 =?utf-8?B?dGduY3FqTFR1QUYybWc5UGRjWWJDS2o3b3QxZ0UzNHpwRVJMTVBGTmtodEww?=
 =?utf-8?B?VVJVK2JjQXNUSnJSYlFJTGQwVWMrQkdzdXgxRzJsZ0hId3VKUVVHOHBaQVhG?=
 =?utf-8?B?eENPbU0yRUZveHkzd1VGRU11NkxwUVB1LzZUR3N2bWJsYlZWZjhjRDNTcHJJ?=
 =?utf-8?B?OXUwR09sOWpnUG1CaHlyMUh2UTZjdjN3YjBrdFhWTWlLdUdCMEJGdEdoVzRm?=
 =?utf-8?B?U2ZPTGhrVXVja0djTmZibC9teTJFKys3ZlVEYnNjdTc2cDhaK1ZmalJ0YXJu?=
 =?utf-8?B?aXdOQ2pETzdscFlJSnFYRTZGbG9oZUZ3d1FSeGRkUnNvaXkrTlQyeCs3VmlJ?=
 =?utf-8?B?eXpqMTBxNWRVb2UzVzRVRFJpRFlXSFRkYTZyUHIvQ3NGbUpVd1JiY3pRRGQz?=
 =?utf-8?B?SS9ZQ0grcWZpR3kvcjdDVEZ0ODMwWGY2R3U4RGFCZmZ0emg5OENwN3NlOENV?=
 =?utf-8?B?S3lYVkxpUHBGeHpLNlNCQW9pSi8yTzZQK1FTTWpsblpWNDNhWHRzNXpMT3dz?=
 =?utf-8?Q?SOWXQd6cwZSSJnwnXYJLZc4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd07790b-9656-421d-f9ea-08d9a635b54c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 23:39:46.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3ahlB9RYUpAP9fBYoWV/aXD00MNvV+/NmSPxcr+E+b3dCI5r1XkKg2svCSkVI22CYy9/WLLm7O0qIpdztF6IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4670
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 11/12/21 10:55 AM, Peter Gonda wrote:
> On Wed, Nov 10, 2021 at 8:32 AM Peter Gonda <pgonda@google.com> wrote:
>> On Tue, Nov 9, 2021 at 3:20 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>>
>>>
>>> On 11/9/21 2:46 PM, Peter Gonda wrote:
>>>> On Tue, Nov 9, 2021 at 1:26 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>> On Tue, Nov 09, 2021, Peter Gonda wrote:
>>>>>> On Tue, Nov 9, 2021 at 10:21 AM Sean Christopherson <seanjc@google.com> wrote:
>>>>>>> There's no need for this to be a function pointer, and the duplicate code can be
>>>>>>> consolidated.
>>>>>>>
>>>>>>> static int sev_do_init_locked(int cmd, void *data, int *error)
>>>>>>> {
>>>>>>>          if (sev_es_tmr) {
>>>>>>>                  /*
>>>>>>>                   * Do not include the encryption mask on the physical
>>>>>>>                   * address of the TMR (firmware should clear it anyway).
>>>>>>>                   */
>>>>>>>                  data.flags |= SEV_INIT_FLAGS_SEV_ES;
>>>>>>>                  data.tmr_address = __pa(sev_es_tmr);
>>>>>>>                  data.tmr_len = SEV_ES_TMR_SIZE;
>>>>>>>          }
>>>>>>>          return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>>>>>>> }
>>>>>>>
>>>>>>> static int __sev_init_locked(int *error)
>>>>>>> {
>>>>>>>          struct sev_data_init data;
>>>>>>>
>>>>>>>          memset(&data, 0, sizeof(data));
>>>>>>>          return sev_do_init_locked(cmd, &data, error);
>>>>>>> }
>>>>>>>
>>>>>>> static int __sev_init_ex_locked(int *error)
>>>>>>> {
>>>>>>>          struct sev_data_init_ex data;
>>>>>>>
>>>>>>>          memset(&data, 0, sizeof(data));
>>>>>>>          data.length = sizeof(data);
>>>>>>>          data.nv_address = __psp_pa(sev_init_ex_nv_address);
>>>>>>>          data.nv_len = NV_LENGTH;
>>>>>>>          return sev_do_init_locked(SEV_CMD_INIT_EX, &data, error);
>>>>>>> }
>>>>>> I am missing how this removes the duplication of the retry code,
>>>>>> parameter checking, and other error checking code.. With what you have
>>>>>> typed out I would assume I still need to function pointer between
>>>>>> __sev_init_ex_locked and __sev_init_locked. Can you please elaborate
>>>>>> here?
>>>>> Hmm.  Ah, I got distracted between the original thought, the realization that
>>>>> the two commands used different structs, and typing up the above.
>>>>>
>>>>>> Also is there some reason the function pointer is not acceptable?
>>>>> It's not unacceptable, it would just be nice to avoid, assuming the alternative
>>>>> is cleaner.  But I don't think any alternative is cleaner, since as you pointed
>>>>> out the above is a half-baked thought.
>>>> OK I'll leave as is.
>>>>
>>>>>>>> +     rc = init_function(error);
>>>>>>>>        if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
>>>>>>>>                /*
>>>>>>>>                 * INIT command returned an integrity check failure
>>>>>>>> @@ -286,8 +423,8 @@ static int __sev_platform_init_locked(int *error)
>>>>>>>>                 * failed and persistent state has been erased.
>>>>>>>>                 * Retrying INIT command here should succeed.
>>>>>>>>                 */
>>>>>>>> -             dev_dbg(sev->dev, "SEV: retrying INIT command");
>>>>>>>> -             rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>>>>>>>> +             dev_notice(sev->dev, "SEV: retrying INIT command");
>>>>>>>> +             rc = init_function(error);
>>>>>>> The above comment says "persistent state has been erased", but __sev_do_cmd_locked()
>>>>>>> only writes back to the file if a relevant command was successful, which means
>>>>>>> that rereading the userspace file in __sev_init_ex_locked() will retry INIT_EX
>>>>>>> with the same garbage data.
>>>>>> Ack my mistake, that comment is stale. I will update it so its correct
>>>>>> for the INIT and INIT_EX flows.
>>>>>>> IMO, the behavior should be to read the file on load and then use the kernel buffer
>>>>>>> without ever reloading (unless this is built as a module and is unloaded and reloaded).
>>>>>>> The writeback then becomes opportunistic in the sense that if it fails for some reason,
>>>>>>> the kernel's internal state isn't blasted away.
>>>>>> One issue here is that the file read can fail on load so we use the
>>>>>> late retry to guarantee we can read the file.
>>>>> But why continue loading if reading the file fails on load?
>>>>>
>>>>>> The other point seems like preference. Users may wish to shutdown the PSP FW,
>>>>>> load a new file, and INIT_EX again with that new data. Why should we preclude
>>>>>> them from that functionality?
>>>>> I don't think we should preclude that functionality, but it needs to be explicitly
>>>>> tied to a userspace action, e.g. either on module load or on writing the param to
>>>>> change the path.  If the latter is allowed, then it needs to be denied if the PSP
>>>>> is initialized, otherwise the kernel will be in a non-coherent state and AFAICT
>>>>> userspace will have a heck of a time even understanding what state has been used
>>>>> to initialize the PSP.
>>>> If this driver is builtin the filesystem will be unavailable during
>>>> __init. Using the existing retries already built into
>>>> sev_platform_init() also the file to be read once userspace is
>>>> running, meaning the file system is usable. As I tried to explain in
>>>> the commit message. We could remove the sev_platform_init call during
>>>> sev_pci_init since this only actually needs to be initialized when the
>>>> first command requiring it is issues (either reading some keys/certs
>>>> from the PSP or launching an SEV guest). Then userspace in both the
>>>> builtin and module usage would know running one of those commands
>>>> cause the file to be read for PSP usage. Tom any thoughts on this?
>>>>
>>> One thing to note is that if we do the INIT on the first command then
>>> the first guest launch will take a longer. The init command is not
>>> cheap (especially with the SNP, it may take a longer because it has to
>>> do all those RMP setup etc). IIRC, in my early SEV series in I was doing
>>> the INIT during the first command execution and based on the
>>> recommendation moved to do the init on probe.
>>>
>>> Should we add a module param to control whether to do INIT on probe or
>>> delay until the first command ?
>> Thats a good point Brijesh. I've only been testing this with SEV and
>> ES so haven't noticed that long setup time. I like the idea of a
>> module parameter to decide when to INIT, that should satisfy Sean's
>> concern that the user doesn't know when the INIT_EX file would be read
>> and that there is extra retry code (duplicated between sev_pci_init
>> and all the PSP commands). I'll get started on that.
> I need a little guidance on how to proceed with this. Should I have
> the new module parameter 'psp_init_on_probe' just disable PSP init on
> module init if false. Or should it also disable PSP init during
> command flow if it's true?
>
> I was thinking I should just have 'psp_init_on_probe' default to true,
> and if false it stops the PSP init during sev_pci_init(). If I add the
> second change that seems like it changes the ABI. Thoughts?
>
Good point that a module params may break the ABI. How about if we add a
new ioctl that can be used to initialize the SEV_INIT_EX. The ioctl
implementation will be similar to the PLATFORM_RESET; it will shutdown
the firmware then call INIT_EX. A platform provisioning tool may use ioctl.

-Brijesh

