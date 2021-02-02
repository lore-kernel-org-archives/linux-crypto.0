Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FA1C433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 09:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12BEF64EA1
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 09:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhBBJYB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 04:24:01 -0500
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:57739 "EHLO
        8.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhBBJWx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 04:22:53 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 04:22:51 EST
Received: from player758.ha.ovh.net (unknown [10.110.171.173])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 5395D265E7F
        for <linux-crypto@vger.kernel.org>; Tue,  2 Feb 2021 10:15:50 +0100 (CET)
Received: from 3mdeb.com (85-222-117-222.dynamic.chello.pl [85.222.117.222])
        (Authenticated sender: maciej.pijanowski@3mdeb.com)
        by player758.ha.ovh.net (Postfix) with ESMTPSA id C5ED91AA85954;
        Tue,  2 Feb 2021 09:15:42 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-97G0021d41bac2-8316-40e5-8792-fe8cdf0db9d2,
                    15A1E526C6027736B464B120C098C81B350B3EF2) smtp.auth=maciej.pijanowski@3mdeb.com
X-OVh-ClientIp: 85.222.117.222
Subject: Re: safexcel driver for EIP197 and mini firmware features
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "pascalvanl@gmail.com" <pascalvanl@gmail.com>,
        =?UTF-8?Q?Piotr_Kr=c3=b3l?= <piotr.krol@3mdeb.com>
References: <d90956cf-5340-cbe4-1254-771c18b7e46d@3mdeb.com>
 <CY4PR0401MB3652D787A7DE6E19E937A392C3B59@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Maciej Pijanowski <maciej.pijanowski@3mdeb.com>
Message-ID: <afbde2f9-1ae0-c2be-37c2-8e6eb9c58b82@3mdeb.com>
Date:   Tue, 2 Feb 2021 10:15:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CY4PR0401MB3652D787A7DE6E19E937A392C3B59@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Ovh-Tracer-Id: 1749085506347871948
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -83
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrgedtgddtudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddujedmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepofgrtghivghjucfrihhjrghnohifshhkihcuoehmrggtihgvjhdrphhijhgrnhhofihskhhiseefmhguvggsrdgtohhmqeenucggtffrrghtthgvrhhnpeehjeefledtffetgfejgedutddtveevgfdvleelveeuffejffekvddukeduudegvdenucffohhmrghinhepshholhhiugdqrhhunhdrtghomhdpshholhhiugdqsghuihhlugdrgiihiidpkhgvrhhnvghlrdhorhhgpdefmhguvggsrdgtohhmpdhrrghmsghushdrtghomhenucfkpheptddrtddrtddrtddpkeehrddvvddvrdduudejrddvvddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeehkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehmrggtihgvjhdrphhijhgrnhhofihskhhiseefmhguvggsrdgtohhmpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 02.02.2021 09:48, Van Leeuwen, Pascal wrote:
> Hello Maciej,
Hello,
>
>> -----Original Message-----
>> From: Maciej Pijanowski <maciej.pijanowski@3mdeb.com>
>> Sent: Monday, February 1, 2021 7:53 PM
>> To: linux-crypto@vger.kernel.org
>> Cc: antoine.tenart@bootlin.com; pascalvanl@gmail.com; Piotr Król <piotr.krol@3mdeb.com>
>> Subject: safexcel driver for EIP197 and mini firmware features
>>
>> <<< External Email >>>
>> Hello,
>>
>> I am interested in using the EIP197 crypto accelerator. I am aware that
>> it requires an NDA
>> to obtain the firmware for it, but I found out that there is some kind
>> of "minifw" as well
>> in the linux-firmware tree [3]. I found no description of it - I would
>> like to learn what
>> are the features and limitations of this "minifw".
>>
> Actually, from the perspective of what that firmware normally does, it does not have any features
> at all :-) Ok, except for cache invalidates, which the EIP-197 requires.
> It just bypasses everything from the inputs to the internal crypto engine, effectively turning the
> EIP-197 into an EIP-97 with caches & prefetching.
>
> But that's OK for the Linux kernel driver, because that was using the EIP-197 in EIP-97 backward
> compatibility mode anyway. It does not support any advanced EIP-197 firmware features.
> So from the perspective of the current Linux driver: no limitations.
Thank you very much for the response. That is much more clear now.
>
>> I started with using it on the Debian image from board vendor [2]. The
>> kernel here is
>> 5.1.0. The firmware is loaded, but the ALG tests are all failing:
>>
>> [14785.750246] crypto-safexcel f2800000.crypto: firmware: direct-loading
>> firmware inside-secure/eip197b/ifpp.bin
>> [14785.762765] crypto-safexcel f2800000.crypto: firmware: direct-loading
>> firmware inside-secure/eip197b/ipue.bin
>> [14785.777978] alg: skcipher: safexcel-cbc-des encryption test failed
>> (wrong output IV) on test vector 0, cfg="in-place"
>> [14785.788661] 00000000: fe dc ba 98 76 54 32 10
>> [14785.800606] alg: skcipher: safexcel-cbc-des3_ede encryption test
>> failed (wrong output IV) on test vector 0, cfg="in-place"
>> [14785.811720] 00000000: 7d 33 88 93 0f 93 b2 42
>> [14785.823734] alg: skcipher: safexcel-cbc-aes encryption test failed
>> (wrong output IV) on test vector 0, cfg="in-place"
>> [14785.834439] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
>> [14785.884568] alg: hash: safexcel-hmac-sha224 test failed (wrong
>> result) on test vector 3, cfg="init+update+update+final two even splits"
>> [14785.901836] alg: hash: safexcel-hmac-sha256 test failed (wrong
>> result) on test vector 2, cfg="import/export"
>> [14785.926693] alg: aead: safexcel-authenc-hmac-sha1-cbc-aes encryption
>> test failed (wrong result) on test vector 0, cfg="misaligned splits
>> crossing pages, inplace"
>> [14785.944430] alg: No test for authenc(hmac(sha224),cbc(aes))
>> (safexcel-authenc-hmac-sha224-cbc-aes)
>> [14785.956978] alg: aead: safexcel-authenc-hmac-sha256-cbc-aes
>> encryption test failed (wrong result) on test vector 0, cfg="two even
>> aligned splits"
>> [14785.973472] alg: No test for authenc(hmac(sha384),cbc(aes))
>> (safexcel-authenc-hmac-sha384-cbc-aes)
>> [14785.986103] alg: aead: safexcel-authenc-hmac-sha512-cbc-aes
>> encryption test failed (wrong result) on test vector 0, cfg="two even
>> aligned splits"
>>
> Ok, that is unexpected. Although I know there is one particular kernel version that was broken.
> So you might want to try a slightly newer one.
> (I'd love to try 5.1 myself but I don't have access to the hardware right now, working from home)
I am going to try with 5.10.12 and let you know with the results.
>
>> I am going to test it with more recent, mainline kernel as well, but it
>> would be still nice to learn
>> a little bit more about this "minifw", it's features, and what could be
>> possibly achieved on this
>> board without proprietary (and behind NDA) crypto firmware.
>>
> Everything the kernel driver currently supports.
> The real firmware is for doing full protocol offload (like IPsec, DTLS, etc.) which the Linux kernel
> does not currently support anyway. (unfortunately, I might add)
Are you aware of any other system (OS) or implementation which takes
advantage of more of the EIP197 features (like the mentioned IPsec offload)?
>
>> Thank you,
>>
>>
>> [1]
>> https://www.solid-run.com/embedded-networking/marvell-armada-family/clearfog-gt-8k/
>> [2] https://images.solid-build.xyz/8040/Debian/
>> [3]
>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/inside-
>> secure/eip197_minifw/ifpp.bin?id=eefb5f7410150c00d0ab5c41c5d817ae9bf449b3
>>
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

