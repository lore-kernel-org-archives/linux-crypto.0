Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686EEC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 22:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BF361ACD
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 22:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbhKIWYu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 17:24:50 -0500
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:21600
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344163AbhKIWWu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czg1AbwYtkWzDf3rii6KJiXewMkyyLjAGTD/4cA/rMFmEUFCMSAXWGFkz2gk4+afv9ppMH132AOBKF9jK71cNAIMCSMb6xotWXbYWeRIN+DBn4JyNuq0Ee9aD5pm0Ax2V4nj7YNetGRKbMuMRCeaXwhu0p6Hmrk9ZsQfqmBtF6dEnMSsJZgWU+ap3BfyI5e8f+TXVt9EiyzDbIzINtuEE6hnx71np63NW1Oljtl4dG1GT4FFSs+jjVCUjwDfyXsuziyL0jsYqsVB+t+SDChreSGgDqh1zs+krlDgnCrDlrT49jWwI82H+FQj3OQkHcelkEP5DY586w71fLzlsw3g3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR6klJk/HsCN7FpX16kUQVVDHTHg+saP06pNhiXroBU=;
 b=a99135ApJOzPDMQsvxp1VPsUYDa5F+kKjkJYuysJJhwVucikYHzZyG/Dci4V3GmfMWebLXYG28fvRtzWp9/7G/kDeumgNqsQooYgF18dAH94Xos6Lqi7lawHEqwNQ4Mk+Yq/epTuRj2EUse1YZ125phNL4QBm1ZBaDoHrMMvHlaIJIRal3/Ij0A6Tynl8IEytR24R0fjnGn8NHRA3IpNJf/2yQ7FWtQsP3Vz6SC8hNOXNSiwS5JZV+Uhnki/7FYPM0t3XesaWbNKyFKFw7RU52pi9mn0DSpeQUQOgfdoq1fc3CrKrJY4PgcIaGViDPOFN9ezAgOBwZMzMuMkRkQ3nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR6klJk/HsCN7FpX16kUQVVDHTHg+saP06pNhiXroBU=;
 b=srBLjWBWsB9D4vrlYJNNttIdSmxkIBPHQ1zuKwh6uAuKI0dod/Xgb802kep5jqFdiD5NPWh4KBiSZqtDUhP0Jeg1u2/SZEtFtGNKvQXqxalU9LJGrsIrUjduHonCT+UNwxi5tGmRBN3up9gpMF9SJCyJ3fHWa2faKQbkE17+2oY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 22:20:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 22:20:01 +0000
Cc:     brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20211102142331.3753798-1-pgonda@google.com>
 <20211102142331.3753798-5-pgonda@google.com> <YYquDWbkIwCkixxD@google.com>
 <CAMkAt6rHdsdD-L4PbZL7qaOY7GRHmApVJam0V0yY2BnYdhmPjA@mail.gmail.com>
 <YYrZXRTukz3RccPN@google.com>
 <CAMkAt6qauoiTBXF9VXRGiqtJD5pTAV=NqKHZgNFXHCkrR50gkg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <eff7a2cb-f78a-646a-dc0c-b24998e9e9af@amd.com>
Date:   Tue, 9 Nov 2021 16:19:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAMkAt6qauoiTBXF9VXRGiqtJD5pTAV=NqKHZgNFXHCkrR50gkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 22:19:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 430e28f9-a532-444d-99b3-08d9a3cf1286
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509F03D13883C6C1DCE9030E5929@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1LNUlqPpZMLGiNKu4Z7jzHGa4Zey/aJG8OD9iuHFm8y3O5ai+gqVy7RosdsSE2ww8+P55p0lhP3F3Tt37vLjQT84wdTaHIh7VViCgx7MyAUMXNFjOdAHPNhgF76cPXDiO3g64d8p6Spzo0uD3QuChOkrHWi/783XlHRZgN+zI8HANOSB1IFQOtBFvWzJZkix0G9YgrfQF4GYyvmwXF/LFIdZPthDPJ/8v9P/GCht8yyVRTcE5CfTrW57vYpYrtmw5mJk+PgiQiOuucHqZrFXp19zKmWXmQamIFeyEtqMunXIaUVpVKIGV2BuwNo+avgL+Hz7P6olzI4GdfZ7q69U2JcH8OL9QTQqw5b5rfGkkiyttr5EzkJXTVokuEfOXhqcbXnAaGcB7s/w9te1itjqze9I+XplahZ3TZZ/cpYN8Vr2dRRQeOt1A8YJoDX4g4S67AtVYCeAM1ssL4aEXfvl/1oBcKBtdCqIGWDfN6ClSn5F6Jq/nqU8E8T501L1Q3OmGJiiTxCRg6pqodkBUYEWJDsMIvU72APobz2+UDE7g+oGUz1N3FIDsn4WcFIKEaVlFVFTkQFG0EvDG8/QJ6Zjn9hOLkY4bpNvSxVEdww8FvNowapfsyVmcsaCA89AqTuk7lT2sMM4TbA8zSz5rpua1aZrIVy7NOO4pS9reBoTLzz9FsSmuEjATtJqs1ap1WYdYpIUPc1PbsmyNgri32wnpOtq7PwRZnu+dN3CqOmBgPkMmWxeGYxqVos9rpSqfmZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(26005)(38100700002)(6486002)(2616005)(53546011)(36756003)(86362001)(110136005)(8676002)(956004)(54906003)(5660300002)(66946007)(2906002)(7416002)(66476007)(316002)(31696002)(66556008)(16576012)(31686004)(186003)(4326008)(508600001)(44832011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjRwd1JQV0VWT3BjY3YycHFzYjA4RXdZRWd1UTYwUmpKR0FGd3JRR3VkK3Fa?=
 =?utf-8?B?QzNuUHN5SE0zWTlVeVBBYzRSVms1OFlld1BvSFhoUS9nWXhkNTd0M0FhRUJP?=
 =?utf-8?B?YU5FRWhBNVNuYWdXTXArK3liWkVyZWZXbkJZNUpVSmYxaG9nK2RwZk9NbFV3?=
 =?utf-8?B?Y3BZVWlNYXI2aCtNOVRkYVg5TkY4STM5U1BKVWxMSkgrbnZqcXpvSUlyZDY1?=
 =?utf-8?B?aGpYT2VwLzc5NFkrd0RpWkVzWlVtQ2xSYmFjM2c4a1NvRFN6dEZ3ZGVFb3VK?=
 =?utf-8?B?M2djRmtXOUpRVSttN25CS2hkSnhJNFBhMkFDRTVpZ1Z0V3dVYnJlYVpLNmlB?=
 =?utf-8?B?UitpUmdXOHZnT25NZ2NQeCtIM2Y3bks0aDlncC9Cc1FOSEFsT3FBYlZENzdr?=
 =?utf-8?B?YzFNMkQ2aU5wbzJJLzJjRjNienRWZ203a29LL20zcnJ2cW4zVW55aWpJam5P?=
 =?utf-8?B?bmJIaTg0Y0IzSmxXYlhvemdYcEVtT0JCTG5nQjRwbXIyNEwrdUxjZWxxSkxi?=
 =?utf-8?B?OElicXV6SC82VDgrTW8wSjVpY0k3M3UvYS94QWpYU0JsYzU0MXRLcWVJM2RS?=
 =?utf-8?B?OHgyVTB6ZzJrUi9qblUxRFZIc2Z3M1F0dldwbXdTYXFKTmlkVVQ0eGJzY2hl?=
 =?utf-8?B?U1N6VHBSQ2dOUmVMZkhvN0lNNEdPMFBMY044YVRUZlNWR21uSHFKVDYwUVU1?=
 =?utf-8?B?WHluSWY5clFQTVMrek9XdEgxWk5wNWF4NkdpWXQzZWxNbHljM1R1cG4xR2xF?=
 =?utf-8?B?L2ZWK3NvcUQ4TXhDVDJpZThueU5MelNxeEgxVnQzZXYwd2pIVzRnN29HdjFr?=
 =?utf-8?B?Z1BobEQwaHN3Q1l3MDNHbmRwZ29EeEJ5aVdianBYWGlPaVN2cVVYL2V1YS9H?=
 =?utf-8?B?RlpFRkIzZTdhc3cvaEVBcnNtU1UwYllQVG5pd3daSnJKRlVNeWoxTkpud1lQ?=
 =?utf-8?B?MXhOQkZmOXREbjBDT2dGYTNNR3UvOVk4a3RMQ2FKVVZJR25KV0ovMkp3RXlw?=
 =?utf-8?B?YzJleDJncS9KMTgyWDFHeFVWNUluTmJKaDdPS0xpRndPSHkvYXlkd2hReWVp?=
 =?utf-8?B?SzAxR0FMME1ReS9UKzBRcXZJS1p3UTlyNFNtZzdVY0ZMY2ZBQ0hnS3o2OGRr?=
 =?utf-8?B?T2hDa09zKzNzLytsRVc3cmVIT3NaMlZ2V0NQc3JLQ2lUb2VLOFUzV3A1Wkl0?=
 =?utf-8?B?aEZDd0NKV3R3M1lQOWhFcVBVb0JySnZKcjNRc3hUVys2M3NMUjBlVjFBY1R4?=
 =?utf-8?B?aUM1YUFpNlVGK0hISElmQmdhTkNRMUYzRWk5NDc4SUN4aTNPdDE1Yk9Ta3Z6?=
 =?utf-8?B?TTNxcm50VGZkVXJkbVZVQ3JWeXd6dUk4MlI2QnplVW1EZWhPN3g0czVGTlZ0?=
 =?utf-8?B?SHg0d0swc1dyMVNsLzBIb0tIOW43R2MxRUY2UVVFc1hBOTIzWGc2QkFxdTNn?=
 =?utf-8?B?emhsNHI3UURlWm4yS0RtNHdMVFc3UHg5ZjlBQXZFRU4ybEVtWTk1eVM3QWhS?=
 =?utf-8?B?ZWlFN0ZUU1VIN2srUkhpVDVxaWF0VEtUVkJNQmYzK1JxRnM3eWYxRUR3M1Zp?=
 =?utf-8?B?S0NOMGVFeVdsTytuU0hxcjdYOFVuMXZNVG1Fci9pNmRYRjhPMkMyQ2RxWEw1?=
 =?utf-8?B?bytWMjBwbGE0TGNvbzlZbEwzZHhvY3NSUkVFWlp4VmtOVjdoRlhOeWlFZ2VB?=
 =?utf-8?B?T0ZrcjBaMDdnczhUOGo2UG1zOUFvdHJVK1RlOU5jdUFRKy9vS2paRmVseHZa?=
 =?utf-8?B?Y3JNTnJhN2lZQUMwT2s0N3pOSFozamNXUmVFT0JWTE0rZmcvR010MzB1THpv?=
 =?utf-8?B?aTNqKzdEYXdoeUdGNTZRZzVmV3E0R1lzNjdLK1BlWVVMVkNhVmY5YVF5Q1oy?=
 =?utf-8?B?T0Rxb0JITHl0aWJFcUhiMjNiOU1OQ2JtSlhIMFBmdEVBNnhpQUJiTWRVMm1j?=
 =?utf-8?B?VklxK0Y3a1NJMzY3bXdvSE1jWGZiWk5Od0lRbk1hbDlYZ0FQaHVxbU43QjNO?=
 =?utf-8?B?Mmhub1pzcFJzZUp3YkI5ckRBTXMxZWZ0RVJmbi9udFlQbjVlaGlrSk8wOWp6?=
 =?utf-8?B?TU5DUFJTMm1hZ0doWWRWbnlmdmcwSVo2R3BJcC9JUkt1N2M3eERucm05SGl5?=
 =?utf-8?B?bzY3RDNxd3hLN1Q3TU9LU1g0cmRtaXRUcWNUTTUzTjBTRVNJRE9WNEVrQlI2?=
 =?utf-8?Q?701VtU6EBbZAMxxR2u7a5DA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430e28f9-a532-444d-99b3-08d9a3cf1286
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 22:20:01.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNK/IqB3kgx+UOC78ycZO+aP86eahTFc/VryPq8KQT3rJbdaw4MNYpDqeujgjEitBztEwbeQkvDKdcalM1PhTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/9/21 2:46 PM, Peter Gonda wrote:
> On Tue, Nov 9, 2021 at 1:26 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Tue, Nov 09, 2021, Peter Gonda wrote:
>>> On Tue, Nov 9, 2021 at 10:21 AM Sean Christopherson <seanjc@google.com> wrote:
>>>> There's no need for this to be a function pointer, and the duplicate code can be
>>>> consolidated.
>>>>
>>>> static int sev_do_init_locked(int cmd, void *data, int *error)
>>>> {
>>>>          if (sev_es_tmr) {
>>>>                  /*
>>>>                   * Do not include the encryption mask on the physical
>>>>                   * address of the TMR (firmware should clear it anyway).
>>>>                   */
>>>>                  data.flags |= SEV_INIT_FLAGS_SEV_ES;
>>>>                  data.tmr_address = __pa(sev_es_tmr);
>>>>                  data.tmr_len = SEV_ES_TMR_SIZE;
>>>>          }
>>>>          return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>>>> }
>>>>
>>>> static int __sev_init_locked(int *error)
>>>> {
>>>>          struct sev_data_init data;
>>>>
>>>>          memset(&data, 0, sizeof(data));
>>>>          return sev_do_init_locked(cmd, &data, error);
>>>> }
>>>>
>>>> static int __sev_init_ex_locked(int *error)
>>>> {
>>>>          struct sev_data_init_ex data;
>>>>
>>>>          memset(&data, 0, sizeof(data));
>>>>          data.length = sizeof(data);
>>>>          data.nv_address = __psp_pa(sev_init_ex_nv_address);
>>>>          data.nv_len = NV_LENGTH;
>>>>          return sev_do_init_locked(SEV_CMD_INIT_EX, &data, error);
>>>> }
>>>
>>> I am missing how this removes the duplication of the retry code,
>>> parameter checking, and other error checking code.. With what you have
>>> typed out I would assume I still need to function pointer between
>>> __sev_init_ex_locked and __sev_init_locked. Can you please elaborate
>>> here?
>>
>> Hmm.  Ah, I got distracted between the original thought, the realization that
>> the two commands used different structs, and typing up the above.
>>
>>> Also is there some reason the function pointer is not acceptable?
>>
>> It's not unacceptable, it would just be nice to avoid, assuming the alternative
>> is cleaner.  But I don't think any alternative is cleaner, since as you pointed
>> out the above is a half-baked thought.
> 
> OK I'll leave as is.
> 
>>
>>>>> +     rc = init_function(error);
>>>>>        if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
>>>>>                /*
>>>>>                 * INIT command returned an integrity check failure
>>>>> @@ -286,8 +423,8 @@ static int __sev_platform_init_locked(int *error)
>>>>>                 * failed and persistent state has been erased.
>>>>>                 * Retrying INIT command here should succeed.
>>>>>                 */
>>>>> -             dev_dbg(sev->dev, "SEV: retrying INIT command");
>>>>> -             rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>>>>> +             dev_notice(sev->dev, "SEV: retrying INIT command");
>>>>> +             rc = init_function(error);
>>>>
>>>> The above comment says "persistent state has been erased", but __sev_do_cmd_locked()
>>>> only writes back to the file if a relevant command was successful, which means
>>>> that rereading the userspace file in __sev_init_ex_locked() will retry INIT_EX
>>>> with the same garbage data.
>>>
>>> Ack my mistake, that comment is stale. I will update it so its correct
>>> for the INIT and INIT_EX flows.
>>>>
>>>> IMO, the behavior should be to read the file on load and then use the kernel buffer
>>>> without ever reloading (unless this is built as a module and is unloaded and reloaded).
>>>> The writeback then becomes opportunistic in the sense that if it fails for some reason,
>>>> the kernel's internal state isn't blasted away.
>>>
>>> One issue here is that the file read can fail on load so we use the
>>> late retry to guarantee we can read the file.
>>
>> But why continue loading if reading the file fails on load?
>>
>>> The other point seems like preference. Users may wish to shutdown the PSP FW,
>>> load a new file, and INIT_EX again with that new data. Why should we preclude
>>> them from that functionality?
>>
>> I don't think we should preclude that functionality, but it needs to be explicitly
>> tied to a userspace action, e.g. either on module load or on writing the param to
>> change the path.  If the latter is allowed, then it needs to be denied if the PSP
>> is initialized, otherwise the kernel will be in a non-coherent state and AFAICT
>> userspace will have a heck of a time even understanding what state has been used
>> to initialize the PSP.
> 
> If this driver is builtin the filesystem will be unavailable during
> __init. Using the existing retries already built into
> sev_platform_init() also the file to be read once userspace is
> running, meaning the file system is usable. As I tried to explain in
> the commit message. We could remove the sev_platform_init call during
> sev_pci_init since this only actually needs to be initialized when the
> first command requiring it is issues (either reading some keys/certs
> from the PSP or launching an SEV guest). Then userspace in both the
> builtin and module usage would know running one of those commands
> cause the file to be read for PSP usage. Tom any thoughts on this?
> 

One thing to note is that if we do the INIT on the first command then 
the first guest launch will take a longer. The init command is not 
cheap (especially with the SNP, it may take a longer because it has to 
do all those RMP setup etc). IIRC, in my early SEV series in I was doing 
the INIT during the first command execution and based on the 
recommendation moved to do the init on probe.

Should we add a module param to control whether to do INIT on probe or 
delay until the first command ?

-Brijesh
