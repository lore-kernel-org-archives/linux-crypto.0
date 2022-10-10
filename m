Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3968C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Oct 2022 08:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiJJIZk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Oct 2022 04:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJJIZh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2022 04:25:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F38231ED9
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 01:25:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBDAB1aZ8RT+gjYz+W4etlZBJO3mt6Qmha0Mnw8wMznV/uIKOw1HonuoUOHN9Ba+e38DUt2RlGJuDVbZDPi7D9J1wDl3AjhYfldJac8COe39/eewJWtiSmKHqJxdYePZi0lUoUr7DdEE+EklAy9NqBMvg308+Zu7AI0jUS/NChHdDeG+zvrXNNeSl1gk78JMfTaK3fSIQXVY9V0Y8BXUYHrwemTVVWw3IrhmnptEzPuvAX3Vue9aST3Jw1MrJ71tbpaKeLt6lwtQsTQCJgu0efk536EvzDEV8ZePuUlc1GkJLSztt9/67t0q9NiFUfoqTLwz9w9nG6fZLAu5vtTNSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/2+dedavJOQJXFlN8RLHY64fQPhWbMzmmElPdSNUz6w=;
 b=gWMl5mVgA7NF4Pu53RAQPg40mi8g+zsHs1S4A4UUTJnHIj28GX+CssMsQHz3WIuz/pEkOA0l3vAB1BQYptV2+Lo0EcZei4ENc65gztAmlb2y2RPK9OEX8udyoITAgZpGhbONSlofAjHGcNylyY9Lnqj/M3legbJe+IL9s5uKGENU6embug9V180/UER8FYRgiI//B4h3s79TXhLS6GLtXczrHg06i7u2GGKLMlLYRCvvf/2XthD2XEixxtzXBsq+PINlU4SXXvj/Qc3xMyKYFHSxLD62fdmw1+9VtY9sW2Fk4ZeDrwqc0gpCT8A3XRS/rTfiunsk3kCqKRkvJQwJeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2+dedavJOQJXFlN8RLHY64fQPhWbMzmmElPdSNUz6w=;
 b=3w4BvcXEiVHHPhzlq0pga4GyPIDA/tcjEYXKwx+PLa9w4oub6Fn/v6hejsxnWkk2kDz0aKNp22HTH8PQLWl7AMcIQk3KARtgHpVwfbQJkPXyMQby3IZbPbX6MkDxs6HM9dlxbwjy2qrxPIfEeloK3tQC9tWKKfqkhhGiKacfbe0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS7PR12MB5861.namprd12.prod.outlook.com (2603:10b6:8:78::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.15; Mon, 10 Oct 2022 08:25:31 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002%3]) with mapi id 15.20.5676.028; Mon, 10 Oct 2022
 08:25:31 +0000
Message-ID: <ecc2207e-4845-f467-1926-e675f78c6b2e@amd.com>
Date:   Mon, 10 Oct 2022 13:55:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] crypto: gcm - Provide minimal library implementation
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, keescook@chromium.org, jason@zx2c4.com
References: <20221007152105.3057788-1-ardb@kernel.org>
 <3e395ad2-48f6-87f6-9042-a3ca21c0baba@amd.com>
 <CAMj1kXGNXYvS9_-RwzzO-VeZN8+ZErhxGiCbfbBA5thJ84RxYA@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMj1kXGNXYvS9_-RwzzO-VeZN8+ZErhxGiCbfbBA5thJ84RxYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0221.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS7PR12MB5861:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e8a462-cedc-43d9-47da-08daaa98feac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FdwLunCveCFHMJfpvWAnBNEzwPySrmGe1IYEHeStqhN2lUsNVZiEK4XdmZJxbGgRQRSz7qXMxo71KpFmLbMudszQtyxojRpkeEZEvkJNSSRHyu+9Xn4s/UtkyRsi9laABLOQ9LBT4GjTdUgU0XiJ3UPo5Zw3IwGefnJrGAFsw1ToYWjAHGiKJPjkyoNiOTdsttFHrm8liMNvVc68tkvpq/UvEaaUtV2JpsOg3Hml3KbUczFxFEMEQaIK7bmxppNMRtnUUKeqC55+0LNJ0+yPK9ZjwXkEAvIn/s0fTVEtmGIJnwuaj7dPyJMZMlB0NfrsVPElQTXfKIEgTcQIxu1ZaaR35mT+dAlf66B5Ie/6lOYlwZ75xPhYfj1qJtRQ3P6oF1jgTkPTd06yOvAN7GKlVEn9BSY7r1B3eqrjJfSMxsyzjdvgHC8O8Au/riOXbWfRs2/TN0LK8QW7D04nKQ6E5+pG4GwxjBHZLnfjkWx2z/1Y59sYq9Ki8KiC4k9Q9E7qXCqQUn4vRbZ6M/hWSKeLGUWs2+HvppRdW7c8IL/48M7oq3+c/B7TJw1ckIkYX0PU1p0rIQ5cqIS/agBGC7cs4EmrQ7bTD4DUhBrrn9FGQgo8GBrE9KOWEa7rFcPCCjRv1eODpJrwtfYimf0TYE3kw4XedOeJvPzbNMaGb1br8BqQLWFCRKZYs///ISmEAq/vf1j+LH2qUdUucekD77IFpjqILQ2ByJSfosnNtpae56vvMck5Np7IbmmBBtGmeSAP66N/n7bnIGXxXDrjn02+SqBkfX5I5cM7drJqFfTMfV47AGjcTv4A/VOKTmAxm4NcWnJOHGAvXvJfRzL2yuanDdkjVqqevaAPOK2f+l62xi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(478600001)(36756003)(6916009)(45080400002)(6666004)(5660300002)(6486002)(31696002)(966005)(41300700001)(316002)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(186003)(38100700002)(6512007)(26005)(53546011)(6506007)(2616005)(83380400001)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDRwbUxUNkEybHdEVkVCS0pieWVSd3JDNGpmZWc1clVuL3Y2Y0x3T2g2SzdN?=
 =?utf-8?B?bUFVei94M1d1S0ZNVWI3L293Rkd6UFJsb3lKMS9ROXhtVmNnMkUyRDBDaXA1?=
 =?utf-8?B?QXRheWlpbUZjYy80aWRSdVBhOE5YNHQrNUQvRUhURENhMzRDQ2EvSW1JdnFu?=
 =?utf-8?B?SnJnempuR21lQVJxRUFSV2N2aGY0ZHFFcW9nZE1mQ3pxdEVtcVByTWk3NzN4?=
 =?utf-8?B?ODVvOXZveld2SFBUNVpnUFpWKzhvOXZBYU9xaUxwRUExVkhROHNzR21lamRP?=
 =?utf-8?B?RUF4eGtXalRUR1hWTVo2bExBVkhWdC9EU2pHemVNUml0Smo2bDczelRRMWdG?=
 =?utf-8?B?WVk1Z0wzU3h4eWdqNnFaSkJCQldQZklMSUsrRVdaTTFtVDRoOTZXbG9WMzBs?=
 =?utf-8?B?T05qU2w1bDF6MWkyc0VON0Y0ZHZ3WTQ5WStDajRlRDJEN0NHUkZnbzcxTUEv?=
 =?utf-8?B?U1gvTThyZDdHNzFpWFMwNXUzb0hRNlNheWZWTENLQnAzcUgrWlp3NVh2L09n?=
 =?utf-8?B?Z3FJVFR6QXNtVEQrbXpkTHR4UzVHRjFESk4xeFNUSVF1TkdpTHBKNE9kWXUx?=
 =?utf-8?B?N0I1bE95ZHhMQU1zTXVocU5JdkQ0V3pIZ1Zmai9uRjNmV3JHTUVYQmMwMDhh?=
 =?utf-8?B?RHN5RzlYcjhwS083ei81Nk01MG1nQ0VOU3M1c2JkOFc2ZldCSitSMUhZci9V?=
 =?utf-8?B?enFhODFGV1QraWVPMUV2Y2NoVzNwOXlkY0huQitic2lUNjVRU2ZsZExkVEFk?=
 =?utf-8?B?aWlPZVE1Ni9hcjZZZTVJWFRjb2M5MFZlakZTSHdXRGFiM3psMmFOaDU0MzVU?=
 =?utf-8?B?cHNSbzRnT1BkMVd4UFAvK2tXaldXSVZMNlAwUW1Sd1pQZWtIYUdSK1QyeVUw?=
 =?utf-8?B?SkpHWU1sdldVTERSWUIrYnlqK0JpZzlkYUNvVm1UOVVvYklicnU4MDlXWEgr?=
 =?utf-8?B?MjdkVXE4T3pwQzNDZGQ2VjhJbFNzd01QVE5TblYvTTYyTXJUL1ZOSDZoZjFU?=
 =?utf-8?B?K0JleEduaVFvZzIyVXlrbC8zR0dYSWorWEVzUTR0dVpTR1oyWGdYM0VhTGtO?=
 =?utf-8?B?SndqekVKeTJQMnFyUlJseHhVOEc2MHZ0OEU1QmJPeGZJSjZBZExKVmVLQ2I1?=
 =?utf-8?B?ai91c2VRYkV1Yys2Ukc1Y0Q3bXBJanRaTHA2NGRSc3h1SUVpOUFXTHptRXlC?=
 =?utf-8?B?TGFmMWZnZWRQcGFGZnJIT1lzSloyRlVTNGUyMExMbDhZcDJXR0J2aFdLYXlt?=
 =?utf-8?B?MWd3ODl0b05uYjZpblUzeGZqckVhUy96WUlLV1g3RXRkYTZRTUV1c05BYjZh?=
 =?utf-8?B?dmNXbGtCZG1SbW51NGtnbDlNU042M0pGdThFOHd2SDhFSjJxdEZQVEkvejRv?=
 =?utf-8?B?VlhQU3BmS1FSU0UyTmJQdEVlOUM4TTNuZVFHZzQydXJYWStsQlBZMnVERml1?=
 =?utf-8?B?RENXZ2lxU0l0MkNRZ2pVQ09DanVjVndNQ2kzem9nRWtFNXM4QS9qWjQ5Z2dE?=
 =?utf-8?B?YVFtMVd4UkFsS1JuMkpxTTFxYmhwUEkwdHoxQzBDZHBOK3BlbjRFcHk0dlpi?=
 =?utf-8?B?QzFTd2VnMi9iL3lINWFYcDV0SWFrWGI5Tm5sTGhrS0QyRVdSRnY3Y1Y0eHdn?=
 =?utf-8?B?RWcvMlZEaHRFTnVYMXRKOWJYYkZsdHowdXhBTFJzZ1RmbitUWGtIWUtiejFR?=
 =?utf-8?B?TndNSU5TbkJseGZ4T2J6Zm9CUVpZSkthdnJHKzdKN25Mem91VENZVVRuZHg1?=
 =?utf-8?B?M0NKdDRMV0lIa0xScHFOQ1c2N24raXNXaG1KY2N2NGxPUGJvUkU2VURYYTEr?=
 =?utf-8?B?ZTZiL1ZWZVZQZ2VlOHpwekNYSFJqb2J0WTEvRHNGZ0JEUzQvb0tQcHd4YkIx?=
 =?utf-8?B?WmxiVVVkVGNpWUplSktzbmVtSUI0TDR2WUZEZnI4ampBcmcwQzAwUUdPWC9Y?=
 =?utf-8?B?RG1KUVk0OC9uWS9yVEN3VkgxSzRtTS9ZSlVWN2JaRFFuZHBwZkg2V2N6K1ZH?=
 =?utf-8?B?dVJ0eVp3NnJrUU5ienhGVWNwcTZmZ3pySWllZkJ2c0tmWVBNb2REWGR0S2hF?=
 =?utf-8?B?QkllOWJPN2U3cVhIZUxjRkU0Vkg5Q1dQY0R1dXkydE5ObHJkVm5PSG85Z0F3?=
 =?utf-8?Q?zvi7AuO/LjFf7QKtluS083tyT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e8a462-cedc-43d9-47da-08daaa98feac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 08:25:31.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTYsm/Om7rP/ezZ1u3ESJQMEZgdwzwi3H1xIb9HgFgnXU1nf3pr4uAUJlqNbSsGwxahfn+V0ds0417Do4wD/UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5861
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 10/10/22 13:45, Ard Biesheuvel wrote:
> On Mon, 10 Oct 2022 at 09:27, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>
>> Hi Ard,
>>
>> On 07/10/22 20:51, Ard Biesheuvel wrote:
>>> Implement a minimal library version of GCM based on the existing library
>>> implementations of AES and multiplication in GF(2^128). Using these
>>> primitives, GCM can be implemented in a straight-forward manner.
>>>
>>> GCM has a couple of sharp edges, i.e., the amount of input data
>>> processed with the same initialization vector (IV) should be capped to
>>> protect the counter from 32-bit rollover (or carry), and the size of the
>>> authentication tag should be fixed for a given key. [0]
>>>
>>> The former concern is addressed trivially, given that the function call
>>> API uses 32-bit signed types for the input lengths. It is still up to
>>> the caller to avoid IV reuse in general, but this is not something we
>>> can police at the implementation level.
>>>
>>> As for the latter concern, let's make the authentication tag size part
>>> of the key schedule, and only permit it to be configured as part of the
>>> key expansion routine.
>>>
>>> Note that table based AES implementations are susceptible to known
>>> plaintext timing attacks on the encryption key. The AES library already
>>> attempts to mitigate this to some extent, but given that the counter
>>> mode encryption used by GCM operates exclusively on known plaintext by
>>> construction (the IV and therefore the initial counter value are known
>>> to an attacker), let's take some extra care to mitigate this, by calling
>>> the AES library with interrupts disabled.
>>>
>>> [0] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fnvlpubs.nist.gov%2Fnistpubs%2Flegacy%2Fsp%2Fnistspecialpublication800-38d.pdf&amp;data=05%7C01%7Cnikunj.dadhania%40amd.com%7C912c5b73be0146ca63db08daaa97ade4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638009869061457627%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=sNHrpE3d7w%2BpT8dzAPiFbmvYLLIu9zsCnJ%2BFFxjzp%2Bk%3D&amp;reserved=0
>>>
>>> Cc: "Nikunj A. Dadhania" <nikunj@amd.com>
>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2Fc6fb9b25-a4b6-2e4a-2dd1-63adda055a49%40amd.com%2F&amp;data=05%7C01%7Cnikunj.dadhania%40amd.com%7C912c5b73be0146ca63db08daaa97ade4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638009869061457627%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=oyUKkikTm6wsPy8vFHiS98TZpL4Hu%2BFz9aYX%2Fs37wk0%3D&amp;reserved=0
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>> +/**
>>> + * gcm_decrypt - Perform GCM decryption on a block of data
>>> + * @ctx:     The GCM key schedule
>>> + * @dst:     Pointer to the plaintext output buffer
>>> + * @src:     Pointer the ciphertext (may equal @dst for decryption in place)
>>> + * @crypt_len:       The size in bytes of the plaintext and ciphertext.
>>> + * @assoc:   Pointer to the associated data,
>>> + * @assoc_len:       The size in bytes of the associated data
>>> + * @iv:              The initialization vector (IV) to use for this block of data
>>> + *           (must be 12 bytes in size as per the GCM spec recommendation)
>>> + * @authtag: The address of the buffer in memory where the authentication
>>> + *           tag is stored.
>>> + *
>>> + * Returns 0 on success, or -EBADMSG if the ciphertext failed authentication.
>>> + * On failure, no plaintext will be returned.
>>> + */
>>> +int __must_check gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
>>> +                          int crypt_len, const u8 *assoc, int assoc_len,
>>> +                          const u8 iv[GCM_AES_IV_SIZE], const u8 *authtag)
>>> +{
>>> +     u8 tagbuf[AES_BLOCK_SIZE];
>>> +     __be32 ctr[4];
>>> +
>>> +     memcpy(ctr, iv, GCM_AES_IV_SIZE);
>>> +
>>> +     gcm_mac(ctx, src, crypt_len, assoc, assoc_len, ctr, tagbuf);
>>> +     if (crypto_memneq(authtag, tagbuf, ctx->authsize)) {
>>> +             memzero_explicit(tagbuf, sizeof(tagbuf));
>>> +             return -EBADMSG;
>>> +     }
>>
>> The gcm_mac computation seems to be broken in this version. When I receive the encrypted
>> packet back from the security processor the authtag does not match. Will debug further
>> and report back.
>>
> 
> Sorry to hear that. If you find out what's wrong, can you please
> provide a test vector that reproduces it so we can add it to the list?

My bad, it was wrong crypt_len that I was sending. Working fine now.

Tested-by: Nikunj A Dadhania <nikunj@amd.com>
