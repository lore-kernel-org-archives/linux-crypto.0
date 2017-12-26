From: Paul Menzel <pmenzel+linux-crypto@molgen.mpg.de>
Subject: Re: Decreasing time for `rsa_init`
Date: Tue, 26 Dec 2017 09:28:56 +0100
Message-ID: <559cf836-1a06-0462-d6a6-d07cb3e96815@molgen.mpg.de>
References: <4ec5a3f5-9605-cdcd-23cf-1df7b3af211c@molgen.mpg.de>
 <3649766.4rHtxdK8Pi@tauon.chronox.de>
 <8d89fefa-b27d-ba32-e7b2-75312549ee90@molgen.mpg.de>
 <1499970041.1134.1.camel@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50508 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750705AbdLZI3A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 03:29:00 -0500
In-Reply-To: <1499970041.1134.1.camel@molgen.mpg.de>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Stephan, dear Linux folks,


Am 13.07.2017 um 20:20 schrieb Paul Menzel:

> Am Mittwoch, den 12.07.2017, 19:38 +0200 schrieb Paul Menzel:
> 
>> On 07/12/17 19:28, Stephan Müller wrote:
>>> Am Mittwoch, 12. Juli 2017, 12:59:58 CEST schrieb Paul Menzel:
>>>> Building CRYPTO_RSA not as module, but into the Linux kernel,
>>>> `rsa_init()` takes 130 ms on an ASRock E350M1.
>>>>
>>>> (Timings are shown by adding `initcall_debug` to Linux command
>>>> line [1].
>>>> The times are visualized by `analyze_boot.py` from pm-graph [2]
>>>> or `systemd-bootchart`.)
>>>>
>>>> This is quite a lot of time compared to other modules, and I
>>>> wonder if
>>>> there are ways to decrease that time other than building it as a
>>>> module,
>>>> and not signing modules?
>>>
>>> Is the testmgr compiled? If yes, the self test may take that time.
>>
>> It looks like it is, as the tests are not disabled.
>>
>> ```
>> $ grep MANAGER_DISABLE_TESTS .config
>> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>> ```
>>
>> I’ll try an image without the tests, and will report back.
> 
> Thank you. That was it. Disabling the tests reduces the time to 51 μs.
> 
> ```
> kernel: calling  rsa_init+0x0/0x40 @ 1
> kernel: initcall rsa_init+0x0/0x40 returned 0 after 51 usecs
> ```
> 
> It’d be nice to be able to disable the testmgr during run-time by
> adding an option to the Linux Kernel command line for example.

To follow up with this, thanks to commit 9e5c9fe4 (crypto: testmgr - Add 
a flag allowing the self-tests to be disabled at runtime.), present 
since Linux 4.7, this can be disabled at run-time by adding 
`cryptomgr.notests` to the Linux command line.

I just don’t know, how a user should find this parameter, that means, 
what module(?) this parameter belongs to, and is visible with `modinfo 
<module_name>`.

Additionally in `crypto/algboss.c`, that parameter doesn’t seem to apply.

```
    214	static int cryptomgr_test(void *data)
    215	{
    216		struct crypto_test_param *param = data;
    217		u32 type = param->type;
    218		int err = 0;
    219	
    220	#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
    221		if (disable_tests)
    222			goto skiptest;
    223	#endif
    224	
    225		if (type & CRYPTO_ALG_TESTED)
    226			goto skiptest;
    227	
    228		err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
    229	
    230	skiptest:
    231		crypto_alg_tested(param->driver, err);
    232	
    233		kfree(param);
    234		module_put_and_exit(0);
    235	}
```


Kind regards,

Paul


>>>> [1] http://elinux.org/Initcall_Debug
>>>> [2] https://github.com/01org/pm-graph
