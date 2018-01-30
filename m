From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: Re: Subject: [PATCH] crypto: add zbewalgo compression algorithm for
 zram
Date: Tue, 30 Jan 2018 22:27:52 +0100
Message-ID: <A2E3026A-BF61-4DD8-A61D-D768CE450EE4@informatik.uni-hamburg.de>
References: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
 <20180130202439.gjnly72x3ebbtxf4@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:49206 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751653AbeA3V1z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 16:27:55 -0500
In-Reply-To: <20180130202439.gjnly72x3ebbtxf4@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,

>> Currently ZRAM uses the compression-algorithms from the crypto-api.
>> None of the current compression-algorithms in the crypto-api is designed
>> to compress 4KiB chunks of data efficiently.
>> This patch adds a new compression-algorithm especially designed for ZRAM,
>> to compress small pieces of data more efficiently.
> 
> This is some interesting work, and I like the idea of doing transforms
> specialized for in-memory data.  However, where can I find more information
> about this new compression algorithm?  

I invented this algorithm during the last months for an university lecture. I have not published it before, that is why you can not find anything at google.

> What does "zbewalgo" even stand for /
> mean?  Googling it turns up nothing.

zbewalgo: z=zram be=Benjamin wa=Warnke algo=Algorithm

> You are going to have to be much more specific what you mean by "efficiently".
> Efficiency usually implies speed, yet even by your own numbers LZ4 is much
> faster than "zbewalgo", both for compression and decompression.

In this context efficient refers to the compression ratio.

> If the goal is to provide an algorithm more tuned for compression ratio than
> speed in comparison to LZ4, then the omission of Zstandard from your benchmarks
> is strange, especially given that Zstandard is available in the kernel now.

I was not aware of Zstandard in the kernel.

#echo zstandard > /sys/block/zram0/comp_algorithm
returns 
"write error: Invalid argument"

#cat /sys/block/zram0/comp_algorithm
does not show Zstandard

I pulled the latest commit from git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
There is no CONFIG_CRYPTO_ZSTD (or similar) flag in my .config file.

How can I enable Zstandard for use within zram?

> The proposed "zbewalgo" decompressor also doesn't handle invalid inputs, which
> means it cannot be used on untrusted data.  
> This isn't acceptable without
> justification (since people may use it on untrusted data, creating security
> vulnerabilities), and it also makes it not really a fair comparison with LZ4
> since the LZ4 decompressor does handle invalid inputs, at least in the mode
> exposed through the crypto API.

Since zbewalgo is intended for use within zram, the data-source for the decompression algorithm is the same computer.
I assume, that the data is never corrupted in any way, because it is never exposed to untrusted hardware.

To catch all invalid inputs a lot of branches would be required.
Each additional if-branch in the code for handling untrusted data slows down the algorithm.
In the zram context only blocks of 4KiB are going to be compressed.
The zbewalgo algorithm executes multiple (de)compression steps in a row.
Each step would need to fully verify, that the data is valid, even if the preceding algorithm does not detect an error.
All together, the relative cpu-time cost for invalid data is high.

I could add a comment to the decompression functions, but that would not be visible for the final user.

Benjamin
