From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Sun, 02 Mar 2008 14:49:56 +0100
Message-ID: <47CAB084.6060607@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de> <20080224125117.GA17076@Chamillionaire.breakpoint.cc> <47C1CE67.70804@the2masters.de> <20080302112004.GA16659@Chamillionaire.breakpoint.cc> <47CA97D5.8090804@the2masters.de> <20080302132202.GB16659@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:49401 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYCBNuO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 08:50:14 -0500
In-Reply-To: <20080302132202.GB16659@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> * Stefan Hellermann | 2008-03-02 13:04:37 [+0100]:
> 
>> But I get much lower speed than with aes-cbc-essiv:sha256.
> Yes, I expected this :)
> The aes-cbc operation is supported directly in HW. So the
> driver just says here is the key, source, destination, length and now do
> it. So the HW fetches the key once and is going to process the whole
> request (lets say 4 KiB) in one go.
> 
> The XTS blockmode on the other hand encrypts encrypts only 16 bytes in
> one go and performs some GF operations in between. This is
> repeated until we encrypt the whole request. So for a 4 KiB we need here
> 257 calls to the HW instead of one (the one extra is to encrypt the IV).
> For every encryption call we have to reset the HW key. According to the
> spec fetching the key from memory takes more time than the whole
> encryption process as it (in case of a 16 byte block). This might still
> be faster than the pure software solution.
> Anyway, XTS is way more complex than CBC and part of it is done in
> software what we can't change.

Ah, good to know! Could this information be placed in the Kconfig-help for padlock_aes?

> 
>> With xts I get 57MB/s while reading the cryptodev with dd, and >90% sys in top, 0% wait
>> With cbc-essiv I get about 75MB/s while reading it with dd, 60% sys int top, 30% wait
>> without cryptodev I get 75MB/s while reading the raw lvm-volume with dd, 40% sys, 50% wait
>> I do a blockdev --flushbufs beetween each read.
> According to this numbers I would say in CBC mode the HD is breaking in
> XTS the CPU is.
> I could try to tune it a little but don't expect much.
> Could you please compare xts with and without padlock?

Yes, xts with padlock is almost 3 times faster.
20-21MB/s read in dd without padlock_aes, >90% CPU sys, 0% wait
57-58MB/s read in dd with padlock_aes, >90% CPU sys, 0% wait

I tried lrw-benbi/lrw-plain this time, but it doesn't work, with or without padlock_aes.
dmesg logs:
device-mapper: table: 252:6: crypt: Error allocating crypto tfm
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table

... but I will use cbc-essiv, if I ever need better encryption I can take xts-plain. (no
need for lrw-benbi)

Thanks
Stefan
