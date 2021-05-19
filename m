Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77218C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 23:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA076135C
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 23:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhESX1y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 19:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhESX1x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 19:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 132A560FF0;
        Wed, 19 May 2021 23:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621466793;
        bh=hXJA2R+CcUs1BiWvz0yIMkkZ6uMumHTehRLvUfxwIPU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=I93to3nt2GWgRRiSLVXxgzRhJcFbD2FRXHSRekR0E3ZkQ6/0YBq7MlFB4gDkJ+W4j
         DrU5/8Taonq7U3aotSCWkRPUv9xm19cAoCHpxv8wnsRGjWpjmDl/g4RM1Vv2MCUywO
         1d5YNZJZVYy4s5bt1VSrRIUufyU2knXQNn21xuas9RQU9ZSg4Wnqv/49DwRMYAI0vp
         ah4pG9keJxOu+yaCjNrIsmeZuxljES/j1xR2Exvg1AdcMDIxF22qimc3kew5sADc+u
         66n4mf6ppQcWqz0WCvqpsLWHFjNDjI+ez8dWkGI1BkJOMiGWH94dT2L40jLDk/PvwN
         0D/Imthf1ripg==
Subject: Re: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
 <247d9a25-f32f-d01b-61ff-b1966e382907@kernel.org>
 <YKP+1cjRWN/IOEpd@google.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <112f7ceb-d699-fc1e-ea5f-89d505e0d6d8@kernel.org>
Date:   Wed, 19 May 2021 16:26:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKP+1cjRWN/IOEpd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/18/21 10:52 AM, Sean Christopherson wrote:
> On Tue, May 18, 2021, Andy Lutomirski wrote:
>> On 5/17/21 11:21 AM, Bae, Chang Seok wrote:
>>> First of all, there is an RFC series for KVM [2].
>>>
>>> Each CPU has one internal key state so it needs to reload it between guest and
>>> host if both are enabled. The proposed approach enables it exclusively; expose
>>> it to guests only when disabled in a host. Then, I guess a guest may enable it.
>>
>> I read that series.  This is not a good solution.
>>
>> I can think of at least a few reasonable ways that a host and a guest
>> can cooperate to, potentially, make KL useful.
>>
>> a) Host knows that the guest will never migrate, and guest delegates
>> IWKEY management to the host.  The host generates a random key and does
>> not permit the guest to use LOADIWKEY.  The guest shares the random key
>> with the host.  Of course, this means that a host key handle that leaks
>> to a guest can be used within the guest.
> 
> If the guest and host share a random key, then they also share the key handle.
> And that handle+key would also need to be shared across all guests.  I doubt this
> option is acceptable on the security front.
> 

Indeed.  Oddly, SGX has the exact same problem for any scenario in which
SGX is used for HSM-like functionality, and people still use SGX.

However, I suspect that there will be use cases in which exactly one VM
is permitted to use KL.  Qubes might want that (any Qubes people around?)

> Using multiple random keys is a non-starter because they can't be restored via
> LOADIWKEY.
> 
> Using multiple software-defined keys will have moderate overhead because of the
> possibility of using KL from soft IRQ context, i.e. KVM would have to do
> LOADIWKEY on every VM-Enter _and_ VM-Exit.  It sounds like LOADIWKEY has latency
> similar to WRMSR, so it's not a deal-breaker, but the added latency on top of the
> restrictions on how the host can use KL certainly lessen the appeal.

Indeed.  This stinks.

> 
>> b) Host may migrate the guest.  Guest delegates IWKEY management to the
>> host, and the host generates and remembers a key for the guest.  On
>> migration, the host forwards the key to the new host.  The host can
>> still internally any type of key, but context switches may be quite slow.
> 
> Migrating is sketchy because the IWKEY has to be exposed to host userspace.
> But, I think the migration aspect is a secondary discussion.
> 
>> c) Guest wants to manage its own non-random key.  Host lets it and
>> context switches it.
> 
> This is essentially a variant of (b).  In both cases, the host has full control
> over the guest's key.
> 
>> d) Guest does not need KL and leaves CR4.KL clear.  Host does whatever
>> it wants with no overhead.
>>
>> All of these have tradeoffs.
>>
>> My current thought is that, if Linux is going to support Key Locker,
>> then this all needs to be explicitly controlled.  On initial boot, Linux
>> should not initialize Key Locker.  Upon explicit administrator request
>> (via sysfs?), Linux will initialize Key Locker in the mode requested by
>> the administrator.
> 
> Deferring KL usage to post-boot can work, but KVM shouldn't be allowed to expose
> KL to a guest until KL has been explicitly configured in the host.  If KVM can
> spawn KL guests before the host is configured, the sysfs knob would have to deal
> with the case where the desired configuration is incompatible with exposing KL
> to a guest.

There could be a host configuration "guest_only", perhaps.

> 
>> Modes could include:
>>
>> native_random_key: Use a random key per the ISA.
>>
>> native_kernel_key_remember: Use a random key but load it as a non-random
>> key.  Remember the key in kernel memory and use it for S3 resume, etc.
> 
> What would be the motivation for this mode?  It largely defeats the value
> proposition of KL, no?

It lets userspace use KL with some degree of security.

> 
>> native_kernel_key_backup: Use a random key, put it in the backup
>> storage, and forget it.  Use the backup for resume, etc.
>>
>> native_kernel_key_norestore: Use a random key.  The key is lost on any
>> power transition that forgets the key.  Backup is not used.
>>
>> paravirt_any: Ask the hypervisor to handle keying.  Any mechanism is
>> acceptable.
>>
>> paravirt_random: Ask the hypervisor for a random key.  Only succeeds if
>> we get an actual random key.
> 
> AFAIK, there's no way for the guest to verify that it got a truly random key.
> Hell, the guest can't even easily verify that KL is even supported.  The host
> can lie about CPUID and CR4.KL, and intercept all KL instructions via #UD by
> running the guest with CR4.KL=0.

The guest can use TDX.  Oh wait, TDX doesn't support KL.

That being said, a host attack on the guest of this sort would be quite
slow.

> 
> I also don't see any reason to define a paravirt interface for a truly random
> key.  Using a random key all but requires a single guest to have exclusive access
> to KL, and in that case the host can simply expose KL to only that guest.
> 
>> Does this make sense?
> 
> I really want to use see concrete guest use cases before we start adding paravirt
> interfaces.
> 

I want to see concrete guest use cases before we start adding *any*
guest support.  And this cuts both ways -- I think that, until the guest
use cases are at least somewhat worked out, Linux should certainly not
initialize KL by default on boot if the CPUID hypervisor bit is set.
