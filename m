From: Anand Moon <linux.amoon@gmail.com>
Subject: Re: Odroid HC1 cryptsetup:encrypt sata driver
Date: Wed, 24 Jan 2018 20:42:30 +0530
Message-ID: <CANAwSgSp+D_2D3TNGvSH+PY39ibF7+SM3t0v1vZEiYd-qrVOcA@mail.gmail.com>
References: <CANAwSgQ3WE9XmjmzHxJstDz52fj_SFvmBKnMjY3MVjhxJuoFmg@mail.gmail.com>
 <CAJKOXPeudajDX9EouSz=eB7r+OG1vcJD8Yg139CDpWGs-7bSOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35676 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934032AbeAXPMv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 10:12:51 -0500
In-Reply-To: <CAJKOXPeudajDX9EouSz=eB7r+OG1vcJD8Yg139CDpWGs-7bSOw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Krzysztof,

On 24 January 2018 at 19:31, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Wed, Jan 24, 2018 at 2:04 PM, Anand Moon <linux.amoon@gmail.com> wrote:
>> Hi Kamil Konieczny,
>>
>> I am looking in setup of encrypted sata hard-disk on Odroid XU4/HC1 device.
>> using following encryption method.
>>
>> aes-cbc-essiv:sha256 128
>> aes-cbc-essiv:sha256 256
>>
>> Here is my defconfig I am using. https://pastebin.com/gF5T2stp
>>
>> Following crypt benchmark we use to test : https://pastebin.com/WiexsJA2
>
> No problems on my side with a 128 MB file (not a device):
> # cryptsetup -v luksFormat /tmp/testcrypt /dev/urandom
> --keyfile-size=32 --cipher aes-cbc-essiv:sha256
> # Command successful.
> # cryptsetup -v luksFormat ~/testcrypt /dev/urandom --keyfile-size=32
> --cipher aes-cbc-essiv:sha256
> # Command successful.
>
> Linux 4.15.0-rc9-00023-g1f07476ec143.
>
> Some time ago you were building from not usual source code and your
> kernel version from WARN is not unambiguous.
>
> What is necessary to reproduce it?

[snip]

I am build the latest kernel
I have check you [0] https://github.com/krzk/tools testcase it pass.

To reproduce the issue you need to run.
[1] crypto benchmark shell script  https://pastebin.com/WiexsJA2

If we leave out below testcase case most of the test case passes with
hard-drive or /tmp/testcontainer.bin

aes-cbc-essiv:sha256 128
aes-cbc-essiv:sha256 256

Below is the command form the testcase which fails.

+ [[ ! -e /tmp/testcontainer.bin ]]
+ fallocate -l 939524096 /tmp/testcontainer.bin
+ [[ ! -e /tmp/testkey.key ]]
+ dd if=/dev/urandom of=/tmp/testkey.key bs=512 count=1
1+0 records in
1+0 records out
512 bytes copied, 0.000123042 s, 4.2 MB/s
+ sync
+ [[ ! -d /mnt ]]
+ trap control_c EXIT
+ test_cipher aes-cbc-essiv:sha256 128
+ local cipher=aes-cbc-essiv:sha256
+ local keysize=128
+ echo ''

+ echo 'aes-cbc-essiv:sha256 (128 bit key)'
aes-cbc-essiv:sha256 (128 bit key)
+ cryptsetup luksFormat -q -d /tmp/testkey.key --cipher
aes-cbc-essiv:sha256 -h sha512 -s 128 /tmp/testcontainer.bin

with kernel panic.

Best Regards
-Anand
