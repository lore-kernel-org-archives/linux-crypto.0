Return-Path: <SRS0=schb=NE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DE7C004D3
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Oct 2018 08:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC152081B
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Oct 2018 08:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EC152081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbeJXRID (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:08:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:31095 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbeJXRID (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Oct 2018 13:08:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2018 01:40:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,419,1534834800"; 
   d="scan'208";a="81171124"
Received: from sakethyx-mobl2.gar.corp.intel.com ([10.249.254.29])
  by fmsmga008.fm.intel.com with ESMTP; 24 Oct 2018 01:40:50 -0700
Date:   Wed, 24 Oct 2018 11:40:49 +0300 (EEST)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-X-Sender: jsakkine@jsakkine-mobl1
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 2/7] tpm2-sessions: Add full HMAC and encrypt/decrypt
 session handling
In-Reply-To: <CAKv+Gu8T8yGEu2GWWKzLXR=wgd=mYHcTYLrD69_zpaddQK3Zxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1810241137400.3525@jsakkine-mobl1>
References: <1540193596.3202.7.camel@HansenPartnership.com> <1540193787.3202.10.camel@HansenPartnership.com> <CAKv+Gu-gYLY1vmtgFC0MTkBfsAkPz658ELaGW78MbD=6ROrLFQ@mail.gmail.com> <1540278091.3347.9.camel@HansenPartnership.com>
 <CAKv+Gu8T8yGEu2GWWKzLXR=wgd=mYHcTYLrD69_zpaddQK3Zxw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181024084049.p4Folw0yKhaGbW_q2B0D-RIhTNXQsUgxTcvWUzPJ3Pc@z>

On Tue, 23 Oct 2018, Ard Biesheuvel wrote:
> On 23 October 2018 at 04:01, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Mon, 2018-10-22 at 19:19 -0300, Ard Biesheuvel wrote:
>> [...]
>>>> +static void hmac_init(struct shash_desc *desc, u8 *key, int
>>>> keylen)
>>>> +{
>>>> +       u8 pad[SHA256_BLOCK_SIZE];
>>>> +       int i;
>>>> +
>>>> +       desc->tfm = sha256_hash;
>>>> +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
>>>
>>> I don't think this actually does anything in the shash API
>>> implementation, so you can drop this.
>>
>> OK, I find crypto somewhat hard to follow.  There were bits I had to
>> understand, like when I wrote the CFB implementation or when I fixed
>> the ECDH scatterlist handling, but I've got to confess, in time
>> honoured tradition I simply copied this from EVM crypto without
>> actually digging into the code to understand why.
>>
>
> Yeah, it is notoriously hard to use, and we should try to improve that.

James,

I would hope (already said in my review) to use longer than one
character variable names for most of the stuff. I did not quite
understand why you decided to use 'counter' for obvious counter
variable and one character names for non-obvious stuff :-)

I'm not sure where the 'encoded' exactly comes in the variable
name 'encoded_key' especially in the context of these cryptic
names.

/Jarkko
