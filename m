Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB1BC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 17:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB78B611BF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 17:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244037AbhERRMO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 13:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239478AbhERRMO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 13:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B686460FF2;
        Tue, 18 May 2021 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621357856;
        bh=zyu3M9789at9L5JkPqLyjf7RRXYDUAb83BZV6wHRdY8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pzekA2tYlJ+RlkC3VaIJZRZRjCB5UTWQI4L9U50cA5tw++oU2e0ygkWHcPbsADygc
         Hlcq08q6OkwcAacZZ3D3RePb7GFVVIyi9w4Bx4u04GSgpxHm/gjnoYOKtxLEJWuJCv
         YvFdddaXxVq6U1AVZJ/JONx974sq+VTUWtyfDocj+xkIB7iyekvJnMwStN73h0dKDK
         zmtbhnPeqawmIoCaoa/tf72sH3RV7tIC97Tughg8KtpMgUa3SAPaP62QKgAbavZsJz
         b5qJMJQG1EhkQow2vRbA4zptY+q5Sd9tigqOWjQwFd3RjoS8MpTFJcSOanVtmEY0tS
         edGSyPIo53Crg==
Subject: Re: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <9f556d3b-49d3-5b0b-0d92-126294ea082d@kernel.org>
 <C08CCADB-864B-48E0-89E0-4BF6841771E8@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <247d9a25-f32f-d01b-61ff-b1966e382907@kernel.org>
Date:   Tue, 18 May 2021 10:10:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <C08CCADB-864B-48E0-89E0-4BF6841771E8@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/17/21 11:21 AM, Bae, Chang Seok wrote:
> On May 15, 2021, at 11:01, Andy Lutomirski <luto@kernel.org> wrote:
>> On 5/14/21 1:14 PM, Chang S. Bae wrote:
>>> Key Locker [1][2] is a new security feature available in new Intel CPUs to
>>> protect data encryption keys for the Advanced Encryption Standard
>>> algorithm. The protection limits the amount of time an AES key is exposed
>>> in memory by sealing a key and referencing it with new AES instructions.
>>>
>>> The new AES instruction set is a successor of Intel's AES-NI (AES New
>>> Instruction). Users may switch to the Key Locker version from crypto
>>> libraries.  This series includes a new AES implementation for the Crypto
>>> API, which was validated through the crypto unit tests. The performance in
>>> the test cases was measured and found comparable to the AES-NI version.
>>>
>>> Key Locker introduces a (CPU-)internal key to encode AES keys. The kernel
>>> needs to load it and ensure it unchanged as long as CPUs are operational.
>>
>> I have high-level questions:
>>
>> What is the expected use case?
> 
> The wrapping key here is only used for new AES instructions.
> 
> I’m aware of their potential use cases for encrypting file system or disks.

I would like to understand what people are actually going to do with
this.  Give me a user story or two, please.  If it turns out to be
useless, I would rather not merge it.


> 
>> I certainly understand how KL is valuable in a context where
>> a verified boot process installs some KL keys that are not subsequently
>> accessible outside the KL ISA, but Linux does not really work like this.
> 
> Do you mind elaborating on the concern?  I try to understand any issue with
> PATCH3 [1], specifically.

My concern has nothing to do with your patches per se.

I want to understand the entire workflow that makes Key Locker safer
than not using Key Locker.  Something like:

Step 1: Computer is powered on.
Step 2: Boot loader loads Linux
Step 3: Linux does such-and-such
Step 4: Attacker compromises the computer in the following way

and an explanation of why this is realistic and how Key Locker helps
would be nice.

>> What is the expected interaction between a KL-using VM guest and the
>> host VMM?  Will there be performance impacts (to context switching, for
>> example) if a guest enables KL, even if the guest does not subsequently
>> do anything with it?  Should Linux actually enable KL if it detects that
>> it's a VM guest?  Should Linux have use a specific keying method as a guest?
> 
> First of all, there is an RFC series for KVM [2].
> 
> Each CPU has one internal key state so it needs to reload it between guest and
> host if both are enabled. The proposed approach enables it exclusively; expose
> it to guests only when disabled in a host. Then, I guess a guest may enable it.

I read that series.  This is not a good solution.

I can think of at least a few reasonable ways that a host and a guest
can cooperate to, potentially, make KL useful.

a) Host knows that the guest will never migrate, and guest delegates
IWKEY management to the host.  The host generates a random key and does
not permit the guest to use LOADIWKEY.  The guest shares the random key
with the host.  Of course, this means that a host key handle that leaks
to a guest can be used within the guest.

b) Host may migrate the guest.  Guest delegates IWKEY management to the
host, and the host generates and remembers a key for the guest.  On
migration, the host forwards the key to the new host.  The host can
still internally any type of key, but context switches may be quite slow.

c) Guest wants to manage its own non-random key.  Host lets it and
context switches it.

d) Guest does not need KL and leaves CR4.KL clear.  Host does whatever
it wants with no overhead.

All of these have tradeoffs.

My current thought is that, if Linux is going to support Key Locker,
then this all needs to be explicitly controlled.  On initial boot, Linux
should not initialize Key Locker.  Upon explicit administrator request
(via sysfs?), Linux will initialize Key Locker in the mode requested by
the administrator.  Modes could include:

native_random_key: Use a random key per the ISA.

native_kernel_key_remember: Use a random key but load it as a non-random
key.  Remember the key in kernel memory and use it for S3 resume, etc.

native_kernel_key_backup: Use a random key, put it in the backup
storage, and forget it.  Use the backup for resume, etc.

native_kernel_key_norestore: Use a random key.  The key is lost on any
power transition that forgets the key.  Backup is not used.

paravirt_any: Ask the hypervisor to handle keying.  Any mechanism is
acceptable.

paravirt_random: Ask the hypervisor for a random key.  Only succeeds if
we get an actual random key.



Does this make sense?
