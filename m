From: "Vasile Marii" <vascim@gmail.com>
Subject: blokcipher interface to geode-aes
Date: Wed, 2 Apr 2008 10:17:59 +0300
Message-ID: <ff203bd00804020017h7c9e076dgd6077fe4e8405190@mail.gmail.com>
References: <ff203bd00804012346w60a70967jc6f08feb3d170acb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:5878 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbYDBHSB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 03:18:01 -0400
Received: by an-out-0708.google.com with SMTP id d31so656117and.103
        for <linux-crypto@vger.kernel.org>; Wed, 02 Apr 2008 00:18:00 -0700 (PDT)
In-Reply-To: <ff203bd00804012346w60a70967jc6f08feb3d170acb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

@ Sebastian Siewior
>>I'm trying to write a driver for hardware accelerated aes-cbc crypting
>>device to use with ipsec. I have a geode-aes and I'm spying on it
>>trying to understand all the stuff needed to make it work.
>>Well, when I'm initializing the geode module, I'm sending some test
 >>vectors:
>> Key       : 0xc286696d887c9aa0611bbb3e2025a45a
>>IV        : 0x562e17996d093d28ddb3ba695a2e6f58
>>Plaintext : 0x000102030405060708090a0b0c0d0e0f
> >             101112131415161718191a1b1c1d1e1f
>>Ciphertext expected:
> >              d296cd94 c2cccf8a 3a863028 b5e1dc0a
>>              7586602d 253cfff9 1b8266be a6d61ab1
>>This looks like the test vector #2 for cbc enc.

>Are you using the in kernel module or your own?
>Which kernel version do you use?
it is the geode-aes driver from kernel 2.6.24.2 but modified, meaning
that on loading no algorithms are registred, just some data(hand
written) is put on input of geode-aes and some is taken out. Because
the results differ from test vectors, i concluded that some other
operations are made on data...before entering geode-aes.
>Try to run the tcrypt module for testing.
>modprobe tcrypt mode=10
>will test _all_ aes variants, you can ignore them all except the cbc
>part.
ok, i will install it and will watch.
>>Is the plaintext in ipsec not so "plain"? Is the kernel doing some
>>modifications on it while  trabelling thru blkcipher_walkvirt &
>>friends?
>No. That one should only walk through the scatterlist and ensures
>alignment that is required.

>> What is the real interface between ipsec and algorithms?
>>Thanks in advance!
>Take a look on tcrypt.c. That one is pretty easy. ipsec uses the
>asynchronous interface.
OK i'll do this right now, but the next question is:
after all, in blockcipher mode, the src, and dst addresses filled by
blkcipher_walk... are the real plaintext source and destination? No
other operations are made on that data?
Thanks a lot for response.
>
>--
>Vasile Marii

Sebastian
