From: Shannon Nelson <shannon.nelson@oracle.com>
Subject: Re: console noise after commit c1e9b3b0eea
Date: Wed, 4 Jan 2017 16:44:43 -0800
Message-ID: <32704d75-cff2-c3b5-9133-5d3f8749ba09@oracle.com>
References: <a0a9e8ae-38a8-9bb8-d3b7-2f4b50809096@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "SOWMINI.VARADHAN" <sowmini.varadhan@oracle.com>,
        sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36094 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdAEAo2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Jan 2017 19:44:28 -0500
In-Reply-To: <a0a9e8ae-38a8-9bb8-d3b7-2f4b50809096@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Resurrecting an old thread, pulled out of
http://www.spinics.net/lists/linux-crypto/msg19192.html


On Wed, Apr 20, 2016 at 9:18 AM, Anatoly Pugachev <matorola@xxxxxxxxx> 
wrote:
> On Wed, Apr 20, 2016 at 1:33 AM, Sowmini Varadhan
> <sowmini.varadhan@xxxxxxxxxx> wrote:
>>
>> Hi Anatoly,
>>
>> after commit c1e9b3b0eea1 ("hwrng: n2 - Attach on T5/M5, T7/M7 SPARC
> CPUs")
>> I get a *lot* of console noise on my T5-2, of the form:
>>
>> n2rng f028f21c: Selftest failed on unit 0
>> n2rng f028f21c: Test buffer slot 0 [0x0000000000000000]
>> n2rng f028f21c: Test buffer slot 1 [0xe63f56d6a22eb116]
>> n2rng f028f21c: Test buffer slot 2 [0xe63f56d6a22eb116]
>> n2rng f028f21c: Test buffer slot 3 [0xe63f56d6a22eb116]
>> n2rng f028f21c: Test buffer slot 4 [0xe63f56d6a22eb116]
>> n2rng f028f21c: Test buffer slot 5 [0xe63f56d6a22eb116]
>> n2rng f028f21c: Test buffer slot 6 [0xe63f56d6a22eb116]
>> n2rng f028f21c: Test buffer slot 7 [0xe63f56d6a22eb116]
>>
>> Why/when is your commit needed on my T5-2?
>>
>> I'm not sure how this was tested, but if you need to revise it and test
>> on sparc, please let me know- I think it needs more work on sparc.
>
> Sowmini,
>
> the patch/commit is actually quite trivial, it just adds device_id
> matches for newer T5/M7 CPUs to n2rng_match structure. Without this
> patch, n2rng does not work on this newer CPUs. Works well on my T5-2
> LDOM (tested with rng-tools and gpg --gen-key). I don't have M7

   ^^^^

Anatoly, I think your LDOM is why you don't see the problem.  Yes, your 
patch works just fine when running in a client LDOM, but we see a 
problem when running this on sparc "bare metal".  Did you test this on 
the bare metal so that the self-test would run?

It seems there's an issue with the self-test in the newer hardware and 
the driver will never stop trying to retest the hardware.  I'm 
contemplating a patch to limit the self-test attempts, at least until we 
can figure out what is the root of the issue.

sln

> machine to test it with.
>
> Why the n2rng selftest fails on your machine - I've no idea... Just to
> silence it, you can blacklist this module, since it does not work your
> hardware anyway.
>
> Can you please send me "prtconf -pv" output from your machine, as well
> information on how do you run linux as LDOM container or baremetal
> T5-2 ?
>
> Mine T5-2 is one of the last firmware releases (run from solaris 11.3
> control domain):
>
> root@deimos:/home/sysadmin# prtdiag -v
> ============================ FW Version ============================
> Sun System Firmware 9.5.3 2015/11/25 09:50
>
> sysadmin@deimos:~$ ldm -V
>
> Logical Domains Manager (v 3.3.0.0.17)
>         Hypervisor control protocol v 1.12
>         Using Hypervisor MD v 1.4
>
> System PROM:
>         Hostconfig      v. 1.6.3        @(#)Hostconfig 1.6.3 2015/11/25
> 08:57
>         Hypervisor      v. 1.15.3       @(#)Hypervisor 1.15.3 2015/11/11
> 17:15
>         OpenBoot        v. 4.38.3       @(#)OpenBoot 4.38.3 2015/11/11
> 10:38
>
>
> Can you please check what firmware release if yours T5-2 server and
> probably update? I'm not sure it would help, but anyway.
>
>
>
