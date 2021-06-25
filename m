Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC76C2B9F4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 14:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B7FB6196C
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 14:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhFYOzo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 10:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFYOzn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 10:55:43 -0400
Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc08])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906E5C061766
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jun 2021 07:53:22 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4GBKkP0Fn6zMpnhh;
        Fri, 25 Jun 2021 16:53:17 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4GBKkF6p13zlh8TS;
        Fri, 25 Jun 2021 16:53:09 +0200 (CEST)
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A
 rev1
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
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
 <9590fe0e9482e212f2a3223ffae872104659cc4b.camel@chronox.de>
 <248b1aae-effc-f511-03af-65a71f176cf1@digikod.net>
 <3789849.nkhAASfZ5y@positron.chronox.de>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <43710a75-bd5d-2e23-7783-299470490ff0@digikod.net>
Date:   Fri, 25 Jun 2021 16:53:27 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <3789849.nkhAASfZ5y@positron.chronox.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 25/06/2021 15:50, Stephan Müller wrote:
> Am Freitag, 25. Juni 2021, 13:09:26 CEST schrieb Mickaël Salaün:
> 
> Hi Mickaël,
> 
> [...]
>>
>>> - applies an entropy_input len of 512 bits during initial seeding
>>>
>>> - applies a nonce of 128 bits during initial seeding
>>>
>>> entropy_input == <384 bits get_random_bytes> || <256 bits Jitter RNG>
>>
>> We think that using "<384 bits get_random_bytes> || " makes this DRBG
>> non-compliant with SP800-90A rev1 because get_random_bytes doesn't use a
>> vetted conditioning component (but ChaCha20 instead):
>>
>> SP800-90Ar1, section 8.6.5 says "A DRBG mechanism requires an approved
>> randomness source during instantiation and reseeding [...]. An approved
>> randomness source is an entropy source that conforms to [SP 800-90B], or
>> an RBG that conforms to [SP 800-90C] − either a DRBG or an NRBG".
>> The FIPS 140-2 Implementation Guidance
>> (https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-p
>> rogram/documents/fips140-2/fips1402ig.pdf), section 7.19 says "As of
>> November 7, 2020, all newly submitted modules requiring an entropy
>> evaluation must demonstrate compliance to SP 800-90B". In resolution 3 it
>> says "all processing of the raw data output from the noise sources that
>> happens before it is ultimately output from the entropy source *shall*
>> occur within a conditioning chain". Data from get_random_bytes may come
>> from multiple noise sources, but they are hashed with ChaCha20.
>> In resolution 6 it says "a vetted conditioning component may optionally
>> take a finite amount of supplemental data [...] in addition to the data
>> from the primary noise source", which would be OK if get_random_bytes
>> used a vetted algorithm, but it is not the case for now.
> 
> You cite the right references, I think the interpretation is too strict.
> 
> The specifications require that
> 
> a) The DRBG must be seeded by a 90B entropy source
> 
> b) The DRBG must be initially seeded with 256 bits of entropy plus some 128 
> bit nonce
> 
> We cover a) with the Jitter RNG and b) by pulling 384 bits from it.
> 
> The standard does not forbit:
> 
> c) the entropy string may contain data from another origin or it contains a 
> larger buffer
> 
> d) the actual entropy distribution in the entropy string being not an 
> equidistribution over the entire entropy string
> 
> Bullet d) implies that it is perfectly fine to have entropy distribution begin 
> loopsided in the entropy string.
> 
> Bullet c) implies that other data can be provided with the entropy string.
> 
> With that, to be 90A/B compliant, you interpret that the Jitter RNG provides 
> all entropy you need and credit the entropy from get_random_bytes with zero 
> bits of entropy.
> 
> 
> Note, if you look into the implementation of the DRBG seeding, the different 
> input strings like entropy string or data without entropy like personalization 
> string are simply concatenated and handed to the DRBG. As the Jitter RNG and 
> get_random_bytes data is also concatenated, it follows the concepts of 90A.
> 
> If you look into the draft 90C standard, it explicitly allows concatenation of 
> data from an entropy source that you credit with entropy and data without 
> entropy - see the crediting of entropy of multiple entropy sources defined 
> with "Method 1" and "Method 2" in the current 90C draft.
> 
> This ultimately allows us to have an entropy string that is concatenated from 
> different entropy sources. If you have an entropy source that is not 90B 
> compliant, you have to credit it with zero bits of entropy in the entropy 
> analysis. Thus, only the entropy source(s) compliant to 90B must provide the 
> entire entropy as mandated by 90A.

Thanks for your detailed explanation Stephan. We agree that data from
get_random_bytes is not accounted as entropy, but the question is: is it
still in line with the specification because it uses an algorithm not
compliant to SP800-90B (i.e. ChaCha20 is not a vetted conditioning
component)? Cf. IG 7.19 resolution 6 from 08/28/2020 and IG 7.20 from
05/04/2021.

> 
> After having several discussions with the Entropy Working group sponsored by 
> NIST that included also representatives from the NIST crypto technology group, 
> there was no concern regarding such approach.
> 
> This approach you see in the current DRBG seeding code is now taken for 
> different FIPS validations including FIPS validations that I work on as a FIPS 
> tester as part of my duties working for a FIPS lab. My colleagues have 
> reviewed the current kernel DRBG seeding strategy and approved of it for other 
> FIPS validations.

Good to know. We are worried that a new FIPS validation (started after
November 7, 2020) could failed because of the new SP800-90B requirement.
This issue was pointed out by a lab. It seems that the specification is
still open to different interpretations.

Regards,
 Mickaël
