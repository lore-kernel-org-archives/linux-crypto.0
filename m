From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: Decreasing time for `rsa_init`
Date: Wed, 12 Jul 2017 19:38:32 +0200
Message-ID: <8d89fefa-b27d-ba32-e7b2-75312549ee90@molgen.mpg.de>
References: <4ec5a3f5-9605-cdcd-23cf-1df7b3af211c@molgen.mpg.de>
 <3649766.4rHtxdK8Pi@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51001 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750869AbdGLRie (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 13:38:34 -0400
In-Reply-To: <3649766.4rHtxdK8Pi@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Stephan,


Thank you for the quick response.


On 07/12/17 19:28, Stephan Müller wrote:
> Am Mittwoch, 12. Juli 2017, 12:59:58 CEST schrieb Paul Menzel:

>> Building CRYPTO_RSA not as module, but into the Linux kernel,
>> `rsa_init()` takes 130 ms on an ASRock E350M1.
>>
>> (Timings are shown by adding `initcall_debug` to Linux command line [1].
>> The times are visualized by `analyze_boot.py` from pm-graph [2] or
>> `systemd-bootchart`.)
>>
>> This is quite a lot of time compared to other modules, and I wonder if
>> there are ways to decrease that time other than building it as a module,
>> and not signing modules?
> 
> Is the testmgr compiled? If yes, the self test may take that time.

It looks like it is, as the tests are not disabled.

```
$ grep MANAGER_DISABLE_TESTS .config
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
```

I’ll try an image without the tests, and will report back.


Kind regards,

Paul


>> [1] http://elinux.org/Initcall_Debug
>> [2] https://github.com/01org/pm-graph
