Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6F4C2B9F4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 11:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C2461459
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 11:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFYLLg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 07:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFYLLf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 07:11:35 -0400
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4A1C061760
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jun 2021 04:09:12 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4GBDlq2Rv0zMq45w;
        Fri, 25 Jun 2021 13:09:11 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4GBDln20D4zlmrrr;
        Fri, 25 Jun 2021 13:09:09 +0200 (CEST)
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A
 rev1
To:     Stephan Mueller <smueller@chronox.de>,
        James Morris <jamorris@linux.microsoft.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
        hpa@zytor.com, tytso@mit.edu
References: <20210623120751.3033390-1-mic@digikod.net>
 <9dbbf4e751cb4953fe63079cdc917a0bb3a91670.camel@chronox.de>
 <a4e1c071-32af-9650-e6fd-8943b3a79bb0@linux.microsoft.com>
 <8811360.37IJKxs2K1@positron.chronox.de>
 <9ca2fdb4-8cee-3667-c90a-358255fb8f54@digikod.net>
 <7acf0d4a63f7c94d8355101dd03cbfeb58c05d17.camel@chronox.de>
 <afce411f-7ddb-557d-e039-83d4d84b87d7@digikod.net>
 <9590fe0e9482e212f2a3223ffae872104659cc4b.camel@chronox.de>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <248b1aae-effc-f511-03af-65a71f176cf1@digikod.net>
Date:   Fri, 25 Jun 2021 13:09:26 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <9590fe0e9482e212f2a3223ffae872104659cc4b.camel@chronox.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 24/06/2021 13:50, Stephan Mueller wrote:
> Am Donnerstag, dem 24.06.2021 um 12:13 +0200 schrieb Mickaël Salaün:
>>
>> On 23/06/2021 21:10, Stephan Mueller wrote:
>>> Am Mittwoch, dem 23.06.2021 um 20:04 +0200 schrieb Mickaël Salaün:
>>>>
>>>> On 23/06/2021 19:27, Stephan Müller wrote:
>>>>> Am Mittwoch, 23. Juni 2021, 19:00:29 CEST schrieb James Morris:
>>>>>
>>>>> Hi James,
>>>>>
>>>>>> On Wed, 23 Jun 2021, Stephan Mueller wrote:
>>>>>>>> These changes replace the use of the Linux RNG with the Jitter
>>>>>>>> RNG,
>>>>>>>> which is NIST SP800-90B compliant, to get a proper entropy input
>>>>>>>> and a
>>>>>>>> nonce as defined by FIPS.
>>>>>>>
>>>>>>> Can you please help me understand what is missing in the current
>>>>>>> code
>>>>>>> which
>>>>>>> seemingly already has achieved this goal?
>>>>>>
>>>>>> The advice we have is that if an attacker knows the internal state of
>>>>>> the
>>>>>> CPU, then the output of the Jitter RNG can be predicted.
>>>>>
>>>>> Thank you for the hint. And I think such goal is worthwhile (albeit I
>>>>> have
>>>>> to 
>>>>> admit that if an attacker is able to gain the internal state of a CPU, I
>>>>> would 
>>>>> assume we have more pressing problems that a bit of entropy).
>>>>>
>>>>> Anyways, the current code does:
>>>>>
>>>>> - in regular mode: seed the DRBG with 384 bits of data from
>>>>> get_random_bytes
>>>>>
>>>>> - in FIPS mode: seed the DRBG with 384 bits of data from
>>>>> get_random_bytes 
>>>>> concatenated with 384 bits from the Jitter RNG
>>>>>
>>>>>
>>>>> If I understand the suggested changes right, I would see the following
>>>>> changes 
>>>>> in the patch:
>>>>>
>>>>> - in the regular case: 640 bits from get_random_bytes
>>>>
>>>> Why 640 bits?
>>>
>>>                 if (!reseed)
>>>                         entropylen = ((entropylen + 1) / 2) * 3;
>>>
>>> -> Entropylen is 384 in case of a security strength of 256 bits.
>>>
>>> Your code does the following if the Jitter RNG is not allocated (i.e. in
>>> non-
>>> fips mode):
>>>
>>> ret = drbg_get_random_bytes(drbg, entropy, entropylen + strength);
>>>
>>> so: entropylen + strength = 384 + 256, no?
>>
>> Correct (for entropy + nonce + pers), I thought you were referring to
>> just the entropy + nonce part. This change is not needed for FIPS of
>> course but I changed it too to use the same algorithm and lengths as
>> when Jitter RNG is available.
>>
>> Do you prefer to keep the current lengths (384 bits) when there is no
>> Jitter RNG? It seems to me that this change makes sense and could only
>> strengthen this case though.
>>
>>>
>>>>
>>>>>
>>>>> - in FIPS mode: 256 bits of data from get_random_bytes concatenated with
>>>>> 384
>>>>> bits from the Jitter RNG
>>>>
>>>> In both cases there are 256 bits for the entropy input and 128 bits for
>>>> the nonce.
>>>
>>> I see in the code path with the Jitter RNG:
>>>
>>> ret = crypto_rng_get_bytes(drbg->jent, entropy,
>>>                                                    entropylen);
>>>
>>> --> 384 bits from the Jitter RNG
>>>
>>> ret = drbg_get_random_bytes(drbg, entropy + entropylen,
>>> +                                                   strength);
>>>
>>> --> 256 bits from get_random_bytes
>>>
>>> What am I missing here?
>>
>> OK, it is just a misunderstanding of what is where. To simplify the code
>> (with a fixed-length entropy array) I used the "entropy" array to store
>> the entropy + nonce + the automatically generated personalization string
>> or additional input. The user-supplied personalization string or
>> additional input is stored (unchanged) in the pers drbg_string. I
>> (briefly) explained this in the comments.
>>
>> Another difference brought by this change is that the Jitter RNG data
>> (i.e. entropy source) is used at the beginning (of the entropy array)
>> and the urandom data (i.e. random source) at the end. This strictly
>> follows the algorithm described in SP800-90Ar1 sections 8.6.1, 8.6.2,
>> 10.1.1.2 and 10.1.1.3 .
>>
>>>
>>>
>>>>  If Jitter RNG is not available, then urandom is used instead,
>>>> which means that the system is not FIPS compliant.
>>>
>>> Agreed, the existing does does exactly the same with the exception that it
>>> pulls 384 bits from get_random_bytes instead of 640 in non-FIPS mode (i.e.
>>> when the Jitter RNG is not allocated).
>>>
>>> In FIPS mode, the current code draws 384 bits from get_random_bytes and
>>> separately 384 bits from the Jitter RNG. So, each data block from either
>>> entropy source could completely satisfy the SP800-90A requirement.
>>
>> What is the rational of using 384 (strength * 1.5) bits to draw from
>> get_random_bytes?
>>
>> We noticed that (as explained above) the order of these sources doesn't
>> follows SP800-90Ar1.
>> It is not clear which part and source is used for the entropy, nonce and
>> (maybe) personalization string.
>> If the random source is indeed the personalization string or the
>> additional input, then the pers length may not fit with the maximum
>> lengths specified in SP800-90Ar1 table 2 and 3.
>>
>>>
>>>>
>>>> This follows the SP800-90Ar1, section 8.6.7: [a nonce shall be] "A value
>>>> with at least (security_strength/2) bits of entropy".
>>>
>>> Agreed, but what is your code doing different than the existing code?
>>
>> It just fits with strength/2 for the length of the nonce.
>>
>>>>
>>>>>
>>>>> So, I am not fully sure what the benefit of the difference is: in FIPS
>>>>> mode 
>>>>> (where the Jitter RNG is used), the amount of data pulled from 
>>>>> get_random_bytes seems to be now reduced.
>>>>
>>>> We can increase the amount of data pulled from get_random_bytes (how to
>>>> decide the amount?), but as we understand the document, this should be
>>>> part of the personalization string and additional input, not the nonce.
>>>
>>> There is no need to have a personalization string or additional input. Note,
>>> those two values are intended to be provided by a caller or some other
>>> environment.
>>
>> Right, but the intent here is to strictly follow SP800-90Ar1 (hence the
>> use of Jitter RNG for entropy and nonce) but to still use the urandom
>> source, which seems to only fit in the personalization string according
>> to SP800-90Ar1.
>>
>>>
>>> If you want to stuff more seed into the DRBG, you simply enlarge the seed
>>> buffer and pull more from the entropy sources. I have no objections doing
>>> that. All I am trying to point out is that the 90A standard does not require
>>> more entropy than 256 bits during initialization plus 128 bits of nonce ==
>>> 384
>>> bits of data. But the DRBGs all allow providing more data as seed.
>>
>> Agreed, the user-supplied personalization string can be used to add more
>> data. We also want to harden the default use (i.e. without user-provided
>> personalization string) by automatically using non-entropy source
>> (urandom) though.
>>
>>>
>>>> I guess it may not change much according to the implementation, as for
>>>> the order of random and entropy concatenation, but these changes align
>>>> with the specifications and it should help FIPS certifications.
>>>
>>> Are you saying the order of data from the entropy sources matters in the
>>> entropy buffer? I have not seen that in the standard, but if you say this is
>>> the goal, then allow me to understand which order you want to see?
>>>
>>> The current code contains the order of:
>>>
>>> <384 bits get_random_bytes> || <384 bits Jitter RNG>
>>    ^                              ^
>>    personalization string?        entropy+nonce
>>
>> As described in SP800-90Ar1 section 10.1.1.2:
>> seed_material = entropy_input || nonce || personalization_string
>>
>> As described in SP800-90Ar1 section 10.1.1.3:
>> seed_material = 0x01 || V || entropy_input || additional_input
>>
>> And SP800-90Ar1 section 5 defining "X || Y" as "Concatenation of two
>> strings X and Y. X and Y are either both bitstrings, or both byte strings".
>>
>> According to that, we would like at least:
>> <384 bits Jitter RNG> || <256 bits get_random_bytes>
>> and also enforcing the maximum length for the whole personalization
>> string and the additional input.
> 
> And I think here we found the misconception.
> 
> - SP800-90A section 8.7.1 clearly marks that a personalization string is
> optional. If it is not provided, the personalization string is treated as a
> zero-bit string in the formulas you mentioned above. This is also consistent
> with the CAVP testing of DRBGs conducted by NIST which allows testing of the
> DRBG without a personalization string. See [1] as an example (search for DRBG
> and click on it to see the tested options - there you see the testing with
> zero personalization string).
> 
> - SP800-90A section 9.1 specifies that the entropy_input is: "The maximum
> length of the entropy_input is implementation dependent, but shall be less
> than or equal to the specified maximum length for the selected DRBG
> mechanism". For all DRBGs except the CTR DRBG without derivation function the
> maximum length is 2^35 as defined in table 2. As we do not have a CTR DRBG
> without derivation function, we can ignore that special case.
> 
> With these considerations, the current DRBG code
> 
> - does not mandate a personalization string or even create one by itself but
> allows the caller to specify one

OK

> 
> - applies an entropy_input len of 512 bits during initial seeding
> 
> - applies a nonce of 128 bits during initial seeding
> 
> entropy_input == <384 bits get_random_bytes> || <256 bits Jitter RNG>

We think that using "<384 bits get_random_bytes> || " makes this DRBG
non-compliant with SP800-90A rev1 because get_random_bytes doesn't use a
vetted conditioning component (but ChaCha20 instead):

SP800-90Ar1, section 8.6.5 says "A DRBG mechanism requires an approved
randomness source during instantiation and reseeding [...]. An approved
randomness source is an entropy source that conforms to [SP 800-90B], or
an RBG that conforms to [SP 800-90C] − either a DRBG or an NRBG".
The FIPS 140-2 Implementation Guidance
(https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/fips140-2/fips1402ig.pdf),
section 7.19 says "As of November 7, 2020, all newly submitted modules
requiring an entropy evaluation must demonstrate compliance to SP 800-90B".
In resolution 3 it says "all processing of the raw data output from the
noise sources that happens before it is ultimately output from the
entropy source *shall* occur within a conditioning chain". Data from
get_random_bytes may come from multiple noise sources, but they are
hashed with ChaCha20.
In resolution 6 it says "a vetted conditioning component may optionally
take a finite amount of supplemental data [...] in addition to the data
from the primary noise source", which would be OK if get_random_bytes
used a vetted algorithm, but it is not the case for now.


> 
> nonce = 128 bits Jitter RNG

OK

> 
> 
> You asked why 384 bits from get_random_bytes. Well, the answer is exactly to
> cover your initial concern also raised by James Morris: some folks may not
> trust the Jitter RNG. Yet we need it here as it only provides 90B compliance.
> But folks who dislike it can treat its data providing no entropy and assume
> get_random_bytes provides the entropy.

Agreed, this is the reason we want to keep using urandom, but not as the
entropy input.

> 
> As both, the get_random_bytes and Jitter RNG data is concatenated, we do not
> destroy entropy by this operation. This implies we cover different view points
> at the same time.

The entropy is not destroyed but doesn't seems compliant with the
specification (and IG).

> 
> [1]
> https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/details?validation=33056
> 
> Ciao
> Stephan
> 
>>
>> Thanks,
>>  Mickaël
> 
> 
