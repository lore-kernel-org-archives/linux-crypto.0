From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] x86, crypto: ported aes-ni implementation to x86
Date: Thu, 11 Nov 2010 23:18:10 +0100
Message-ID: <F67572F2-BFB5-4EB5-8CEB-FBB7AC30EFE3@googlemail.com>
References: <1288818883-7620-1-git-send-email-minipli@googlemail.com> <1288823231.3016.25.camel@yhuang-mobile>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50832 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab0KKWSn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Nov 2010 17:18:43 -0500
Received: by fxm16 with SMTP id 16so1814298fxm.19
        for <linux-crypto@vger.kernel.org>; Thu, 11 Nov 2010 14:18:42 -0800 (PST)
In-Reply-To: <1288823231.3016.25.camel@yhuang-mobile>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Huang Ying,

On 03.11.2010, 23:27 Huang Ying wrote:
> On Wed, 2010-11-03 at 14:14 -0700, Mathias Krause wrote:
>> The AES-NI instructions are also available in legacy mode so the 32-bit
>> architecture may profit from those, too.
>> 
>> To illustrate the performance gain here's a short summary of the tcrypt
>> speed test on a Core i7 M620 running at 2.67GHz comparing both assembler
>> implementations:
>> 
>> x86:                              i568       aes-ni   delta
>> 256 bit, 8kB blocks, ECB:  125.94 MB/s  187.09 MB/s  +48.6%
> 
> Which method do you used for speed testing?
> 
> modprobe tcrypt mode=200 sec=<?>
> 
> That actually does not work very well for AES-NI. Because AES-NI
> blkcipher is tested in synchronous mode, and in that mode,
> kernel_fpu_begin/end() must be called for every block, and
> kernel_fpu_begin/end() is quite slow. At the same time, some further
> optimization for AES-NI can not be tested (such as "ecb-aes-aesni"
> driver) in that mode, because they are only available in asynchronous
> mode.
> 
> When developing AES-NI for x86_64, I uses dm-crypt + AES-NI for speed
> testing, where AES-NI blkcipher will be tested in asynchronous mode, and
> kernel_fpu_begin/end() is called for every page. Can you use that to
> test?
> 
> Or you can add test_acipher_speed (similar with test_ahash_speed) to
> test cipher in asynchronous mode.

here are the numbers for dm-crypt. I run the test again on the Core i7
M620, 2.67GHz. During the test I noticed that not porting the CBC
variant to x86 was a bad idea so I did that too and got pretty nice
numbers (see v3 vs. v4 of the patch).

All test were run five times in a row using a 256 bit key and doing i/o
to the block device in chunks of 1MB. The numbers are MB/s.

x86 (i586 variant):
        1. run  2. run  3. run  4. run  5. run    mean
ECB:      93.9    93.9    94.0    93.5    93.8    93.8
CBC:      84.9    84.8    84.9    84.9    84.8    84.8
XTS:     108.2   108.3   109.6   108.3   108.9   108.6
LRW:     105.0   105.0   105.1   105.1   105.1   105.0

x86 (AES-NI), v3 of the patch:
        1. run  2. run  3. run  4. run  5. run    mean
ECB:     124.8   120.8   124.5   120.6   124.5   123.0
CBC:     112.6   109.6   112.6   110.7   109.4   110.9 
XTS:     221.6   221.1   220.9   223.5   224.4   222.3
LRW:     206.2   209.7   207.4   203.7   209.3   207.2

x86 (AES-NI), v4 of the patch:
        1. run  2. run  3. run  4. run  5. run    mean
ECB:     122.5   121.2   121.6   125.7   125.5   123.3
CBC:     259.5   259.2   261.2   264.0   267.6   262.3 
XTS:     225.1   230.7   220.6   217.9   216.3   222.1
LRW:     202.7   202.8   210.6   208.9   202.7   205.5

Comparing the values for the CBC variant between v3 and v4 of the patch
shows that porting the CBC variant to x86 more then doubled the
performance so the little bit ugly #ifdefed code is worth the effort.

x86-64 (old):
        1. run  2. run  3. run  4. run  5. run    mean
ECB:     121.4   120.9   121.1   121.2   120.9   121.1
CBC:     282.5   286.3   281.5   282.0   294.5   285.3
XTS:     263.6   260.3   263.0   267.0   264.6   263.7
LRW:     249.6   249.8   250.5   253.4   252.2   251.1

x86-64 (new):
        1. run  2. run  3. run  4. run  5. run    mean
ECB:     122.1   122.0   122.0   127.0   121.9   123.0
CBC:     291.2   286.2   295.6   291.4   289.9   290.8
XTS:     263.3   264.4   264.5   264.2   270.4   265.3
LRW:     254.9   252.3   253.6   258.2   257.5   255.3

Comparing the mean values gives us:

x86:     i586   aes-ni    delta
ECB:     93.8    123.3   +31.4%
CBC:     84.8    262.3  +209.3%
LRW:    108.6    222.1  +104.5%
XTS:    105.0    205.5   +95.7%

x86-64:   old      new    delta
ECB:    121.1    123.0    +1.5%
CBC:    285.3    290.8    +1.9%
LRW:    263.7    265.3    +0.6%
XTS:    251.1    255.3    +1.7%

The improvement for the old vs. the new x86-64 version is not as
drastically as for the synchronous variant (see the tcrypt tests in the
previous email), but nevertheless an improvement. The improvement for
the x86 case, albeit, should be noticeable. It's almost as fast as the
x86-64 version.

I'll post the new version of the patch in a follow-up email.


Regards,
Mathias
