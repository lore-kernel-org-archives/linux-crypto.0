Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01EDC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 23:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97CFF60F39
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 23:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhKLXxn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 18:53:43 -0500
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:11137
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231618AbhKLXxl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 18:53:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktVbK7FwRJsI7PAPJiVhb9TyDr8DOAxrZpqwdSW961mVYJvKZpdu2FKTi6haOe7HYDCfyaoplSMNMxOVqTKVtURrgDTuO11S0pVIUU3XBo8GppYDbFBKgqOohRpiYlcuQ8ue4zwaU700KUMPIwywO6lrDqTIU2Y2VUlIzHLA4MFytQ9pJjjMk60cKh5iyPSJX16EaFmSzjWCaI8aKbsenn8/mHBR1obDMO7BIoqReECCjzpomc5BdTuE6a7BbWqtHMiYe6amYjYmhZd7J3eSaR/K6UJwvqMNswQbTGjsSnW7YkWEPxwyqhISkV8wFaqllAZwO7CDxQU7LFReD785PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8Dejr5312LEN5yPtEowR2vXW2BQL9p7dwzLf7dbtBM=;
 b=d6Wiim8/0MCJgdahCFXzSUEDti3lzodW/t6AA0jul1ctlN2kOkN4sPuzfQnewbrqeBjhad9cIghF1Ucq0EJgz9Lpf1UC+4E3Rhi37I5wQRU99P2k9JdSSSWj3K6ucs1TrvgaA295Y/7s3sgM+VsJxNlM33iDITJGIozpTwGJkX0R3p4fAhH2dussAvqXqvtF7tyKYqsTJiiWQumPidrbijA04URJS0LJdLLO2JNPNP90nFClQ+4Qf6iBdPMzj/qYWlfNV+OYwXqg0zuY1UpGKJMea1Xd6Ig83H4C45fZvcXAHjlnJiOe5HFvWAMAKtOyEqXuixkdhMQtFlHU0ymqaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8Dejr5312LEN5yPtEowR2vXW2BQL9p7dwzLf7dbtBM=;
 b=HEI6Qf/3xiwiV57J9NrgCdndU4h3cZVq6Z9fYVZZmENOCYeIm9UdUDAO3ShM22tC/HN1Tnm/kVATmOu8SanMqO9sHtO6Xj2LkkihuX7322upiDZO2WAsubeCzcoetICW4xbSuDmMvXAqexmXYM2Pi0aMfUD8wISPZpWhzi3rBtM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2783.namprd12.prod.outlook.com (2603:10b6:805:78::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 12 Nov
 2021 23:50:47 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4669.020; Fri, 12 Nov 2021
 23:50:47 +0000
Message-ID: <24780f17-6aa0-f237-e581-63b407106894@amd.com>
Date:   Fri, 12 Nov 2021 17:50:44 -0600
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
 <14e6c746-c7d3-8cca-47ed-b90f31e4e495@amd.com>
 <CAMkAt6otpLr687q0iag2s6iXo3MXpF_2yQhARf279xAu2SeEmA@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <CAMkAt6otpLr687q0iag2s6iXo3MXpF_2yQhARf279xAu2SeEmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0132.namprd05.prod.outlook.com
 (2603:10b6:803:42::49) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.0.0.5] (70.112.153.56) by SN4PR0501CA0132.namprd05.prod.outlook.com (2603:10b6:803:42::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend Transport; Fri, 12 Nov 2021 23:50:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28374b43-6223-4458-27b7-08d9a6373f9a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2783:
X-Microsoft-Antispam-PRVS: <SN6PR12MB27837675C9EBDA2253804493E5959@SN6PR12MB2783.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOdldRc4YTzW+8KHiczcUznGSdDpZTmbM22A+Yfz1hC3KSToUZMfBv5tpcWg4L+FcEUEmeV1d0ofaILuO2KX7+TZROapBSqlQuMEiiiZmsEh7jKQzmdp6CsrS3tfIMoVxPEpJ43R739XTgSBbBxXQt9vS9J5G2T/kFjIb3QnqYWBKPcPT9HkAt1QrHrCEiOSeM894z3NTuNAy8Tv0TQxMG22KnPsQHcEOcOEhOHaz7texBY/g0Gk9VhxzME2SSyZaydUoD6WEawQSs1BamsYEBd1Bxolk1+DTkfS3/o6tUrUZNuZVHPv3jct8O34hIl8fWI1KocAHfSNk3vpICudGnlcAfq2Xszv59r8I3/O8QtvH6cUMI4qhem7Wop9WG2xxijINMKLZbhFJS0g0jWfIQAv9eP/F1PxI2ukUF/bADjr16RRSEiLC3AqPwRqfLiq1Cg/6l0oO4yn/bP448XDPxT5z7X16YA5Yiijo7hh4uB8aVEnTjbYKYQtLofQtA4i6xVFnP4XbZh7jnokdoMx0VnBzpWewHva0ycpM/+J9YqiAxvlLa6baqjV8rSFZaPu+vj1ekUxZ13FKEcTgdw0kwTQmmN/lQ1vI5hMQlgNtcqElsUT0sxnI4Z2Oj2YLDvo6Izm4rtgaoWlLboHSXTkp5Q6LIlocTrIKKbrI7vdbUKb1VdN6R4SM//E7tBselHjic7mG0ZpYhOjFRLXQqRKtDMk7uB60ijF71W4DM+RuyPnIni20e7o3B8NRqVsHx5j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(2616005)(66556008)(66476007)(36756003)(38100700002)(5660300002)(86362001)(66946007)(956004)(2906002)(8676002)(508600001)(16576012)(83380400001)(31696002)(26005)(6916009)(316002)(4326008)(8936002)(31686004)(7416002)(6486002)(54906003)(44832011)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTN0VkRUd1Q0NEJJU1UydDVSTWVIVVZUcVZlVFc5K3ozSmtPRU1qN3JCZS9P?=
 =?utf-8?B?NHVHSEkxL3krMHFWSHZyRlZiQ1VXUCt4dzRJdGl3aHZ4RzNIWmxtcEJZazRa?=
 =?utf-8?B?Mk4zWWNNcjNOWVBTVW1USnlFZU11RW84NmcyMEREYU9oNVVwZEw0Z1JiTkIr?=
 =?utf-8?B?aXZsRmxKVUJ3SlAvMTBtODdoazVwWUVyYXNENmpWaFl3ZW5NUTNWcGxZMVJi?=
 =?utf-8?B?dCtHZjJPK0RIZUdQUmVuOFVOL3VOZ3huZ2FHT3lTZjk0N01VSVZsbmtzdy9L?=
 =?utf-8?B?VXVlaFJnMGdyM09VOWh3ajJwODBUTGVydnJoZEdLZUJGbFM2anU4SGhzZysx?=
 =?utf-8?B?NDh1bXM2N3l4K2FYU0hvMFloSnk0WlZwYUJvZkxSTUVFeU9VM3N6MTdsbzI5?=
 =?utf-8?B?Y1hjZlh5MU1CS28rUnFrWllUNDJRU05SbXdjRXB2Y04xUGNoMXFDbEtFOEZK?=
 =?utf-8?B?MEtSVFdvK1pJdDJqYU5Xa0JTUGdKZS9hM0Vwckh6Z3ZRUGhPQkRWQ0ZtSHUw?=
 =?utf-8?B?aE5yc0RrN2hzMDRkM0ladGUrVEhnRmdtaVhyaXF4Yk1YYWlWQjRHc1dDeUUv?=
 =?utf-8?B?TnppMDU2dnBIakZQL05xMjdOd2JMdmRUdEYxN0ZTRTNud0NxNXJJRDY5Q1FY?=
 =?utf-8?B?T2tuT0pnMThWZVd3cm9KYWRCdll5QXEyMW5ieDZNT1UveGx2ei9kb252OUhz?=
 =?utf-8?B?WEs4WlA2UTkrdGV6TFlOb3VHQmZTajVOUzIwbk1tTVVJM2xvUmlkMWtFd25J?=
 =?utf-8?B?eU0rTnYvdzBzNGd3aWlPcXgwRjR3WkRwak1PMGVML1MyYjlyZk5odXBweXAy?=
 =?utf-8?B?MnhSMHlDZ3kzOEZGOExIYk1wZS9SM0dzVkJXZ2xqUWNaRXVGQkpVVFJwRDc0?=
 =?utf-8?B?cFZoU29oWHNJM0V3R2tUbCtnVW5GMEZzcCttSVQ5Q1IyaldHdnlTcmhPWllH?=
 =?utf-8?B?Tmc4cTJoL3FSTm9Oc2VPZDdzNjBYaWRUMVhacjhldWxzVTRZNFQ3dmZuaGc5?=
 =?utf-8?B?VVpkWUtOUS92ZVdBNGZ3MUdwd2FMTjdKUVVvRG5vbUJaL2ZnYy83WGpzRmtX?=
 =?utf-8?B?bDVvTnYyWVVLNlVoRDNLbEJsMVMzeUhReFdEdE9kSTUveGpaR2pKVy9CaHZI?=
 =?utf-8?B?ZUQyNmNwU1dMTmNLK1puZWxlQ1dacWJWOXFLODIrRnRMeUxxSnlYWU0xV1hE?=
 =?utf-8?B?UGZoVzJmSkRYS2cxdGJ1KzJFcXZBRGJtTFovNklvSEV6eGNOaXI4Q005c1Rh?=
 =?utf-8?B?TGVqbVVkYVV0M0p4S0d3alBRTEdLakJ6MU5jZ0JoTGJJbmtwN3RIbFNHdUIz?=
 =?utf-8?B?UzFHczhPaWJYYlI3UEJiMHgyNTNwY3p5ZzNteURMNXpiaXpkL1lOYnNhTWFC?=
 =?utf-8?B?STc3a2lYMGhmdUlGVzBlV3lhMmZJY3E0eVVFZjhBck96OHB5c0U4VVhmM0M1?=
 =?utf-8?B?UnFhUEtDTHQzS2VPcFp2WHdQOUxvNEo4dnlYYkwxWndxTDR0RWVzNzZvUHRs?=
 =?utf-8?B?bGttSGJuVjVXaVpBNHVFWDdNTFVkL1NMZGIweTBwNE4yRHNzUmsxbkFiN0l5?=
 =?utf-8?B?eUFSODBJMjQxUXdFbmVJb0NaQjZmb3Uza0F3V3hvbWNZUGRyL0R3VGt3d2NT?=
 =?utf-8?B?RmFKMXVGbzE3Tk42UGFnVjcyNW8zQTVWQTZFRXFXa1RZcjhCdk8rM3JJdzFS?=
 =?utf-8?B?T3BEZG56QVRsQ3pwbnBxN0NCMzI4M3RwREdTUWpFZFpLRzhTblBIR0RsdmVT?=
 =?utf-8?B?WHpraTVXc3ZuMG9LSGRQUEo0d1hkTk1lTFlPRU1udDkrUDJZaXpmWjJHRFM5?=
 =?utf-8?B?TFd4VHdCTFZDWTJiMnNjYTVFVkkvbk5vK05rektUR3VUTktKbEk4bU43cm1E?=
 =?utf-8?B?SFduRjJ4cUxUbG9rV3lkS3hsanJLSk1IY2VRa0pibWtMdEhRclhha0c2Rm0r?=
 =?utf-8?B?QzFPZ0dCTlBDSy92Zm0xN2lIcFMzSXpXK2F2MGFqSEF3Mk82aHZMbHp1ZGJl?=
 =?utf-8?B?aG14S2l6a2VmSTBrYWt6Nlk1cmJWSnl5VXlOdGtCSzBvMkxKNXdNRURoMVNS?=
 =?utf-8?B?cTNMem50SjMrZ3NzS1VHTm95TmlPdmhtTnNUU2kvRWMrN2g0cEpKRjh4eVEz?=
 =?utf-8?B?cVdxbldWVTJ4MEhMblhmUU5Vb082bk5pRzZDdjMyMjMyOVlRam1qa3h3UXFM?=
 =?utf-8?Q?1AKoJNXlKgrZIk1++WRvIXI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28374b43-6223-4458-27b7-08d9a6373f9a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 23:50:47.1784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrYUHjOvhmPF+amvecJXSCOYdS4KUNQIdBb3jGWuOl5Ta9ORarfw9Nu7UPf2tsfATiAkUNVcOv0SJ6e+10Gi6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2783
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 11/12/21 5:44 PM, Peter Gonda wrote:
> On Fri, Nov 12, 2021 at 4:39 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>> On 11/12/21 10:55 AM, Peter Gonda wrote:
>>> On Wed, Nov 10, 2021 at 8:32 AM Peter Gonda <pgonda@google.com> wrote:
>>>> On Tue, Nov 9, 2021 at 3:20 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>>>>
>>>>> On 11/9/21 2:46 PM, Peter Gonda wrote:
>>>>>> On Tue, Nov 9, 2021 at 1:26 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>>>> On Tue, Nov 09, 2021, Peter Gonda wrote:
>>>>>>>> On Tue, Nov 9, 2021 at 10:21 AM Sean Christopherson <seanjc@google.com> wrote:
>>>>>>>>> There's no need for this to be a function pointer, and the duplicate code can be
>>>>>>>>> consolidated.
>>>>>>>>>
>>>>>>>>> static int sev_do_init_locked(int cmd, void *data, int *error)
>>>>>>>>> {
>>>>>>>>>          if (sev_es_tmr) {
>>>>>>>>>                  /*
>>>>>>>>>                   * Do not include the encryption mask on the physical
>>>>>>>>>                   * address of the TMR (firmware should clear it anyway).
>>>>>>>>>                   */
>>>>>>>>>                  data.flags |= SEV_INIT_FLAGS_SEV_ES;
>>>>>>>>>                  data.tmr_address = __pa(sev_es_tmr);
>>>>>>>>>                  data.tmr_len = SEV_ES_TMR_SIZE;
>>>>>>>>>          }
>>>>>>>>>          return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>>>>>>>>> }
>>>>>>>>>
>>>>>>>>> static int __sev_init_locked(int *error)
>>>>>>>>> {
>>>>>>>>>          struct sev_data_init data;
>>>>>>>>>
>>>>>>>>>          memset(&data, 0, sizeof(data));
>>>>>>>>>          return sev_do_init_locked(cmd, &data, error);
>>>>>>>>> }
>>>>>>>>>
>>>>>>>>> static int __sev_init_ex_locked(int *error)
>>>>>>>>> {
>>>>>>>>>          struct sev_data_init_ex data;
>>>>>>>>>
>>>>>>>>>          memset(&data, 0, sizeof(data));
>>>>>>>>>          data.length = sizeof(data);
>>>>>>>>>          data.nv_address = __psp_pa(sev_init_ex_nv_address);
>>>>>>>>>          data.nv_len = NV_LENGTH;
>>>>>>>>>          return sev_do_init_locked(SEV_CMD_INIT_EX, &data, error);
>>>>>>>>> }
>>>>>>>> I am missing how this removes the duplication of the retry code,
>>>>>>>> parameter checking, and other error checking code.. With what you have
>>>>>>>> typed out I would assume I still need to function pointer between
>>>>>>>> __sev_init_ex_locked and __sev_init_locked. Can you please elaborate
>>>>>>>> here?
>>>>>>> Hmm.  Ah, I got distracted between the original thought, the realization that
>>>>>>> the two commands used different structs, and typing up the above.
>>>>>>>
>>>>>>>> Also is there some reason the function pointer is not acceptable?
>>>>>>> It's not unacceptable, it would just be nice to avoid, assuming the alternative
>>>>>>> is cleaner.  But I don't think any alternative is cleaner, since as you pointed
>>>>>>> out the above is a half-baked thought.
>>>>>> OK I'll leave as is.
>>>>>>
>>>>>>>>>> +     rc = init_function(error);
>>>>>>>>>>        if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
>>>>>>>>>>                /*
>>>>>>>>>>                 * INIT command returned an integrity check failure
>>>>>>>>>> @@ -286,8 +423,8 @@ static int __sev_platform_init_locked(int *error)
>>>>>>>>>>                 * failed and persistent state has been erased.
>>>>>>>>>>                 * Retrying INIT command here should succeed.
>>>>>>>>>>                 */
>>>>>>>>>> -             dev_dbg(sev->dev, "SEV: retrying INIT command");
>>>>>>>>>> -             rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>>>>>>>>>> +             dev_notice(sev->dev, "SEV: retrying INIT command");
>>>>>>>>>> +             rc = init_function(error);
>>>>>>>>> The above comment says "persistent state has been erased", but __sev_do_cmd_locked()
>>>>>>>>> only writes back to the file if a relevant command was successful, which means
>>>>>>>>> that rereading the userspace file in __sev_init_ex_locked() will retry INIT_EX
>>>>>>>>> with the same garbage data.
>>>>>>>> Ack my mistake, that comment is stale. I will update it so its correct
>>>>>>>> for the INIT and INIT_EX flows.
>>>>>>>>> IMO, the behavior should be to read the file on load and then use the kernel buffer
>>>>>>>>> without ever reloading (unless this is built as a module and is unloaded and reloaded).
>>>>>>>>> The writeback then becomes opportunistic in the sense that if it fails for some reason,
>>>>>>>>> the kernel's internal state isn't blasted away.
>>>>>>>> One issue here is that the file read can fail on load so we use the
>>>>>>>> late retry to guarantee we can read the file.
>>>>>>> But why continue loading if reading the file fails on load?
>>>>>>>
>>>>>>>> The other point seems like preference. Users may wish to shutdown the PSP FW,
>>>>>>>> load a new file, and INIT_EX again with that new data. Why should we preclude
>>>>>>>> them from that functionality?
>>>>>>> I don't think we should preclude that functionality, but it needs to be explicitly
>>>>>>> tied to a userspace action, e.g. either on module load or on writing the param to
>>>>>>> change the path.  If the latter is allowed, then it needs to be denied if the PSP
>>>>>>> is initialized, otherwise the kernel will be in a non-coherent state and AFAICT
>>>>>>> userspace will have a heck of a time even understanding what state has been used
>>>>>>> to initialize the PSP.
>>>>>> If this driver is builtin the filesystem will be unavailable during
>>>>>> __init. Using the existing retries already built into
>>>>>> sev_platform_init() also the file to be read once userspace is
>>>>>> running, meaning the file system is usable. As I tried to explain in
>>>>>> the commit message. We could remove the sev_platform_init call during
>>>>>> sev_pci_init since this only actually needs to be initialized when the
>>>>>> first command requiring it is issues (either reading some keys/certs
>>>>>> from the PSP or launching an SEV guest). Then userspace in both the
>>>>>> builtin and module usage would know running one of those commands
>>>>>> cause the file to be read for PSP usage. Tom any thoughts on this?
>>>>>>
>>>>> One thing to note is that if we do the INIT on the first command then
>>>>> the first guest launch will take a longer. The init command is not
>>>>> cheap (especially with the SNP, it may take a longer because it has to
>>>>> do all those RMP setup etc). IIRC, in my early SEV series in I was doing
>>>>> the INIT during the first command execution and based on the
>>>>> recommendation moved to do the init on probe.
>>>>>
>>>>> Should we add a module param to control whether to do INIT on probe or
>>>>> delay until the first command ?
>>>> Thats a good point Brijesh. I've only been testing this with SEV and
>>>> ES so haven't noticed that long setup time. I like the idea of a
>>>> module parameter to decide when to INIT, that should satisfy Sean's
>>>> concern that the user doesn't know when the INIT_EX file would be read
>>>> and that there is extra retry code (duplicated between sev_pci_init
>>>> and all the PSP commands). I'll get started on that.
>>> I need a little guidance on how to proceed with this. Should I have
>>> the new module parameter 'psp_init_on_probe' just disable PSP init on
>>> module init if false. Or should it also disable PSP init during
>>> command flow if it's true?
>>>
>>> I was thinking I should just have 'psp_init_on_probe' default to true,
>>> and if false it stops the PSP init during sev_pci_init(). If I add the
>>> second change that seems like it changes the ABI. Thoughts?
>>>
>> Good point that a module params may break the ABI. How about if we add a
>> new ioctl that can be used to initialize the SEV_INIT_EX. The ioctl
>> implementation will be similar to the PLATFORM_RESET; it will shutdown
>> the firmware then call INIT_EX. A platform provisioning tool may use ioctl.
> Would just a 'skip_psp_init_on_probe' parameter be simpler. We default
> to false but if users set it, we can skip that init attempt in
> sev_pci_init(). The init attempts on all other commands that require
> the INIT state would then provide users with INIT_EX functionality.
> They would also know exactly when INIT or INIT_EX would be attempted
> based on the parameter.

Yes, I think that option is also acceptable. Because we are requiring
the user to explicitly say that it does not want to INIT on boot.


>
> Otherwise a new ioctl sounds reasonable.
>> -Brijesh
>>
