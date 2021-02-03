Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BFFC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 13:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B058364F67
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 13:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhBCNrT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 08:47:19 -0500
Received: from 3.mo68.mail-out.ovh.net ([46.105.58.60]:60719 "EHLO
        3.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbhBCNrP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 08:47:15 -0500
X-Greylist: delayed 6601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2021 08:47:12 EST
Received: from player773.ha.ovh.net (unknown [10.109.146.166])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 5A4B318ABA6
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 12:20:13 +0100 (CET)
Received: from 3mdeb.com (85-222-117-222.dynamic.chello.pl [85.222.117.222])
        (Authenticated sender: maciej.pijanowski@3mdeb.com)
        by player773.ha.ovh.net (Postfix) with ESMTPSA id C59D71AC6F16E;
        Wed,  3 Feb 2021 11:20:05 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-105G0068bf7c86b-0460-4f3d-997e-362dcfc28bbf,
                    A904709882BAC92BF98D1AE3FFD10888713C2FF7) smtp.auth=maciej.pijanowski@3mdeb.com
X-OVh-ClientIp: 85.222.117.222
Subject: Re: safexcel driver for EIP197 and mini firmware features
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "atenart@kernel.org" <atenart@kernel.org>,
        "pascalvanl@gmail.com" <pascalvanl@gmail.com>,
        =?UTF-8?Q?Piotr_Kr=c3=b3l?= <piotr.krol@3mdeb.com>
References: <d90956cf-5340-cbe4-1254-771c18b7e46d@3mdeb.com>
 <CY4PR0401MB3652D787A7DE6E19E937A392C3B59@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <afbde2f9-1ae0-c2be-37c2-8e6eb9c58b82@3mdeb.com>
 <46894c5f-83ea-bb55-ea1b-6e789a944bc7@3mdeb.com>
 <CY4PR0401MB36525895B3BAB48C72A649C7C3B49@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Maciej Pijanowski <maciej.pijanowski@3mdeb.com>
Message-ID: <f2523563-8488-8132-3d0b-bdaa8db84206@3mdeb.com>
Date:   Wed, 3 Feb 2021 12:20:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CY4PR0401MB36525895B3BAB48C72A649C7C3B49@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Ovh-Tracer-Id: 9722427174117125836
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -83
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrgedvgddviecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddujedmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepofgrtghivghjucfrihhjrghnohifshhkihcuoehmrggtihgvjhdrphhijhgrnhhofihskhhiseefmhguvggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeiveeivdeukeeigeffhfffhfffhfevueetleejuedugfelkeevhfeiudelvddvgfenucffohhmrghinhepsghoohhtlhhinhdrtghomhdpshholhhiugdqrhhunhdrtghomhdpshholhhiugdqsghuihhlugdrgiihiidpkhgvrhhnvghlrdhorhhgpdefmhguvggsrdgtohhmpdhrrghmsghushdrtghomhenucfkpheptddrtddrtddrtddpkeehrddvvddvrdduudejrddvvddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeejfedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehmrggtihgvjhdrphhijhgrnhhofihskhhiseefmhguvggsrdgtohhmpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 03.02.2021 12:04, Van Leeuwen, Pascal wrote:
>> -----Original Message-----
>> From: Maciej Pijanowski <maciej.pijanowski@3mdeb.com>
>> Sent: Wednesday, February 3, 2021 11:00 AM
>> To: Van Leeuwen, Pascal <pvanleeuwen@rambus.com>; linux-crypto@vger.kernel.org
>> Cc: atenart@kernel.org; pascalvanl@gmail.com; Piotr Król <piotr.krol@3mdeb.com>
>> Subject: Re: safexcel driver for EIP197 and mini firmware features
>>
>> <<< External Email >>>
>>
>> On 02.02.2021 10:15, Maciej Pijanowski wrote:
>>> On 02.02.2021 09:48, Van Leeuwen, Pascal wrote:
>>>> Hello Maciej,
>>> Hello,
>>>>> -----Original Message-----
>>>>> From: Maciej Pijanowski <maciej.pijanowski@3mdeb.com>
>>>>> Sent: Monday, February 1, 2021 7:53 PM
>>>>> To: linux-crypto@vger.kernel.org
>>>>> Cc: antoine.tenart@bootlin.com; pascalvanl@gmail.com; Piotr Król
>>>>> <piotr.krol@3mdeb.com>
>>>>> Subject: safexcel driver for EIP197 and mini firmware features
>>>>>
>>>>> <<< External Email >>>
>>>>> Hello,
>>>>>
>>>>> I am interested in using the EIP197 crypto accelerator. I am aware that
>>>>> it requires an NDA
>>>>> to obtain the firmware for it, but I found out that there is some kind
>>>>> of "minifw" as well
>>>>> in the linux-firmware tree [3]. I found no description of it - I would
>>>>> like to learn what
>>>>> are the features and limitations of this "minifw".
>>>>>
>>>> Actually, from the perspective of what that firmware normally does,
>>>> it does not have any features
>>>> at all :-) Ok, except for cache invalidates, which the EIP-197 requires.
>>>> It just bypasses everything from the inputs to the internal crypto
>>>> engine, effectively turning the
>>>> EIP-197 into an EIP-97 with caches & prefetching.
>>>>
>>>> But that's OK for the Linux kernel driver, because that was using the
>>>> EIP-197 in EIP-97 backward
>>>> compatibility mode anyway. It does not support any advanced EIP-197
>>>> firmware features.
>>>> So from the perspective of the current Linux driver: no limitations.
>>> Thank you very much for the response. That is much more clear now.
>>>>> I started with using it on the Debian image from board vendor [2]. The
>>>>> kernel here is
>>>>> 5.1.0. The firmware is loaded, but the ALG tests are all failing:
>>>>>
>>>>> [14785.750246] crypto-safexcel f2800000.crypto: firmware:
>>>>> direct-loading
>>>>> firmware inside-secure/eip197b/ifpp.bin
>>>>> [14785.762765] crypto-safexcel f2800000.crypto: firmware:
>>>>> direct-loading
>>>>> firmware inside-secure/eip197b/ipue.bin
>>>>> [14785.777978] alg: skcipher: safexcel-cbc-des encryption test failed
>>>>> (wrong output IV) on test vector 0, cfg="in-place"
>>>>> [14785.788661] 00000000: fe dc ba 98 76 54 32 10
>>>>> [14785.800606] alg: skcipher: safexcel-cbc-des3_ede encryption test
>>>>> failed (wrong output IV) on test vector 0, cfg="in-place"
>>>>> [14785.811720] 00000000: 7d 33 88 93 0f 93 b2 42
>>>>> [14785.823734] alg: skcipher: safexcel-cbc-aes encryption test failed
>>>>> (wrong output IV) on test vector 0, cfg="in-place"
>>>>> [14785.834439] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f
>>>>> ac 41
>>>>> [14785.884568] alg: hash: safexcel-hmac-sha224 test failed (wrong
>>>>> result) on test vector 3, cfg="init+update+update+final two even
>>>>> splits"
>>>>> [14785.901836] alg: hash: safexcel-hmac-sha256 test failed (wrong
>>>>> result) on test vector 2, cfg="import/export"
>>>>> [14785.926693] alg: aead: safexcel-authenc-hmac-sha1-cbc-aes encryption
>>>>> test failed (wrong result) on test vector 0, cfg="misaligned splits
>>>>> crossing pages, inplace"
>>>>> [14785.944430] alg: No test for authenc(hmac(sha224),cbc(aes))
>>>>> (safexcel-authenc-hmac-sha224-cbc-aes)
>>>>> [14785.956978] alg: aead: safexcel-authenc-hmac-sha256-cbc-aes
>>>>> encryption test failed (wrong result) on test vector 0, cfg="two even
>>>>> aligned splits"
>>>>> [14785.973472] alg: No test for authenc(hmac(sha384),cbc(aes))
>>>>> (safexcel-authenc-hmac-sha384-cbc-aes)
>>>>> [14785.986103] alg: aead: safexcel-authenc-hmac-sha512-cbc-aes
>>>>> encryption test failed (wrong result) on test vector 0, cfg="two even
>>>>> aligned splits"
>>>>>
>>>> Ok, that is unexpected. Although I know there is one particular
>>>> kernel version that was broken.
>>>> So you might want to try a slightly newer one.
>>>> (I'd love to try 5.1 myself but I don't have access to the hardware
>>>> right now, working from home)
>>> I am going to try with 5.10.12 and let you know with the results.
>> This is the first result with 5.10.12 mainline kernel:
>>
>> [    1.678251] mmcblk0rpmb: mmc0:0001 8GTF4R partition 3 512 KiB,
>> chardev (239:0)
>> [  182.882113] random: fast init done
>> [  185.308594] crypto-safexcel f2800000.crypto: HW init failed (-11)
>> [  185.314737] ------------[ cut here ]------------
>> [  185.319379] WARNING: CPU: 2 PID: 1 at kernel/irq/manage.c:1777
>> free_irq+0x31c/0x350
>> [  185.327065] Modules linked in:
>> [  185.330134] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.10.12-dirty #1
>> [  185.336687] Hardware name: SolidRun ClearFog GT 8K (DT)
>> [  185.341934] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
>> [  185.347964] pc : free_irq+0x31c/0x350
>> [  185.351640] lr : free_irq+0x300/0x350
>> [  185.355315] sp : ffff80001160baf0
>> [  185.358641] x29: ffff80001160baf0 x28: 0000000000000000
>> [  185.363976] x27: ffff8000111d1078 x26: ffff8000111404b8
>> [  185.369310] x25: 000000000000002d x24: ffff0001016036dc
>> [  185.374644] x23: ffff000101603790 x22: ffff0001015db180
>> [  185.379978] x21: 0000000000000000 x20: ffff0001015da700
>> [  185.385313] x19: ffff000101603600 x18: 0000000000000010
>> [  185.390647] x17: 00000000000000a9 x16: 0000000000000087
>> [  185.395981] x15: ffff000100078478 x14: 0000000000000102
>> [  185.401316] x13: ffff000100078478 x12: 00000000ffffffea
>> [  185.406649] x11: 0000000000000040 x10: ffff8000114322a0
>> [  185.411983] x9 : ffff800011432298 x8 : ffff000100400270
>> [  185.417318] x7 : 0000000000000000 x6 : 0000000000000000
>> [  185.422651] x5 : ffff000100400248 x4 : ffff8000115b0000
>> [  185.427985] x3 : ffff8000115b0188 x2 : 0000000000020000
>> [  185.433319] x1 : ffff000101603600 x0 : ffff800010c87198
>> [  185.438654] Call trace:
>> [  185.441109]  free_irq+0x31c/0x350
>> [  185.444437]  devm_irq_release+0x18/0x28
>> [  185.448289]  release_nodes+0x1b0/0x228
>> [  185.452052]  devres_release_all+0x38/0x60
>> [  185.456077]  really_probe+0x1e4/0x3b0
>> [  185.459753]  driver_probe_device+0x58/0xb8
>> [  185.463865]  device_driver_attach+0x74/0x80
>> [  185.468063]  __driver_attach+0x58/0xe0
>> [  185.471827]  bus_for_each_dev+0x70/0xc8
>> [  185.475677]  driver_attach+0x24/0x30
>> [  185.479265]  bus_add_driver+0x14c/0x1f0
>> [  185.483116]  driver_register+0x64/0x120
>> [  185.486965]  __platform_driver_register+0x48/0x58
>> [  185.491690]  safexcel_init+0x48/0x70
>> [  185.495279]  do_one_initcall+0x54/0x1b8
>> [  185.499130]  kernel_init_freeable+0x1d4/0x23c
>> [  185.503505]  kernel_init+0x14/0x118
>> [  185.507005]  ret_from_fork+0x10/0x34
>> [  185.510596] ---[ end trace a5f4f63f649fa735 ]---
>> [  185.515370] crypto-safexcel: probe of f2800000.crypto failed with
>> error -11
>> [  185.522632] usbcore: registered new interface driver usbhid
>>
>> The "HW init failed" comes from here:
>> https://elixir.bootlin.com/linux/v5.10.12/source/drivers/crypto/inside-secure/safexcel.c#L1692
>> Interestingly, I cannot see in the driver code (at least at a first
>> glance) where the (-11)
>> error code would come from.
>>
>> Any hints?
>>
> It's a weird error code indeed. -11 would be ... EAGAIN? That's certainly not something local.
> So it must be some error code passed on from some Linux kernel API function call.
> My best guess at the moment would be the firmware load call (firmware_request_nowarn).
> But it would have been helpful to see the driver logging _prior_ to HW init failed, to see
> which parts of the initialization _did_ succeed properly.
>
>> Do you have a known working kernel version for this driver?
>>
> I've seen a lot of kernel versions work just fine in the past.
>
> 5.4 - 5.8 should definitely work just fine.  Last time I tried was September of last year,
> when I tried to get some fix in for a customer of ours. (but had to give up due to the patch
> not being accepted as such and me not having the time to redo it as suggested)
> In any case, whatever was in development (5.10?) at the time still worked fine on my side.
>
> In any case, I only know of one older kernel version that was truly broken. Could be the 5.1
> you tried, don't remember exactly ...
I will try with one of these suggested versions and maybe add some
logging in the initialization as suggested above. Thanks.
>
>> Thank you,
>>
>>>>> I am going to test it with more recent, mainline kernel as well, but it
>>>>> would be still nice to learn
>>>>> a little bit more about this "minifw", it's features, and what could be
>>>>> possibly achieved on this
>>>>> board without proprietary (and behind NDA) crypto firmware.
>>>>>
>>>> Everything the kernel driver currently supports.
>>>> The real firmware is for doing full protocol offload (like IPsec,
>>>> DTLS, etc.) which the Linux kernel
>>>> does not currently support anyway. (unfortunately, I might add)
>>> Are you aware of any other system (OS) or implementation which takes
>>> advantage of more of the EIP197 features (like the mentioned IPsec
>>> offload)?
>>>>> Thank you,
>>>>>
>>>>>
>>>>> [1]
>>>>> https://www.solid-run.com/embedded-networking/marvell-armada-family/clearfog-gt-8k/
>>>>>
>>>>> [2] https://images.solid-build.xyz/8040/Debian/
>>>>> [3]
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/inside-
>>>>>
>>>>> secure/eip197_minifw/ifpp.bin?id=eefb5f7410150c00d0ab5c41c5d817ae9bf449b3
>>>>>
>>>>>
>>>>> --
>>>>> Maciej Pijanowski
>>>>> Embedded Systems Engineer
>>>>> GPG: 9963C36AAC3B2B46
>>>>> https://3mdeb.com | @3mdeb_com
>>>> Regards,
>>>> Pascal van Leeuwen
>>>> Silicon IP Architect Multi-Protocol Engines, Rambus Security
>>>> Rambus ROTW Holding BV
>>>> +31-73 6581953
>>>>
>>>> Note: The Inside Secure/Verimatrix Silicon IP team was recently
>>>> acquired by Rambus.
>>>> Please be so kind to update your e-mail address book with my new
>>>> e-mail address.
>>>>
>>>>
>>>> ** This message and any attachments are for the sole use of the
>>>> intended recipient(s). It may contain information that is
>>>> confidential and privileged. If you are not the intended recipient of
>>>> this message, you are prohibited from printing, copying, forwarding
>>>> or saving it. Please delete the message and attachments and notify
>>>> the sender immediately. **
>>>>
>>>> Rambus Inc.<http://www.rambus.com>
>> --
>> Maciej Pijanowski
>> Embedded Systems Engineer
>> GPG: 9963C36AAC3B2B46
>> https://3mdeb.com | @3mdeb_com
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
>
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by Rambus.
> Please be so kind to update your e-mail address book with my new e-mail address.
>
>
> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying, forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **
>
> Rambus Inc.<http://www.rambus.com>

-- 
Maciej Pijanowski
Embedded Systems Engineer
GPG: 9963C36AAC3B2B46
https://3mdeb.com | @3mdeb_com

