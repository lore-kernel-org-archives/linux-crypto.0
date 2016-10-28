From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Fri, 28 Oct 2016 15:21:19 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1610281501490.9348@mjmartin-mac01.wa.intel.com>
References: <4006219.iWaCqWYv1B@positron.chronox.de> <alpine.OSX.2.20.1610271419040.52583@mjmartin-mac01.local> <4087872.10iu4A8UFE@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:61809 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755086AbcJ1WVV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 18:21:21 -0400
In-Reply-To: <4087872.10iu4A8UFE@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Stephan,

On Fri, 28 Oct 2016, Stephan Mueller wrote:

> Am Donnerstag, 27. Oktober 2016, 14:42:14 CEST schrieb Mat Martineau:
>
> Hi Mat,
>
>> Stephan and Herbert,
>>
>> On Thu, 27 Oct 2016, Stephan Mueller wrote:
>>> Hi Herbert,
>>>
>>> for this patch, I have updated the testing for libkcapi accordingly and
>>> all
>>> tests pass. I will push the libkcapi code 0.12 with that test code change
>>> out shortly. Using the current upstream version of 0.11.1 will show
>>> failures as it expects the correct recv return code. As stated below,
>>> that return code has changed which implies that some of the tests will
>>> fail.
>>>
>>> ---8<---
>>>
>>> For encryption, the AEAD ciphers require AAD || PT as input and generate
>>> AAD || CT || Tag as output and vice versa for decryption. Prior to this
>>> patch, the AF_ALG interface for AEAD ciphers requires the buffer to be
>>> present as input for encryption. Similarly, the output buffer for
>>> decryption required the presence of the tag buffer too. This implies
>>> that the kernel reads / writes data buffers from/to user space
>>> even though this operation is not required.
>>>
>>> This patch changes the AF_ALG AEAD interface to be consistent with the
>>> in-kernel AEAD cipher memory requirements.
>>>
>>> In addition, the code now handles the situation where the provided
>>> output buffer is too small by reducing the size of the processed
>>> input buffer accordingly. Due to this handling, the changes are
>>> transparent to user space with one exception: the return code of recv
>>> indicates the processed of output buffer size. That output buffer has a
>>> different size compared to before the patch which implies that the
>>> return code of recv will also be different. For example, a decryption
>>> operation uses 16 bytes AAD, 16 bytes CT and 16 bytes tag, the AF_ALG
>>> AEAD interface before showed a recv return code of 48 (bytes) whereas
>>> after this patch, the return code is 32 since the tag is not returned
>>> any more.
>>
>> I tested out these changes and found that recv() or read() do not update
>> all of the indicated bytes. In your decrypt example where there are 16
>> bytes AAD, 16 bytes CT, and 16 bytes tag, read(sk, buf, 32) returns 32.
>
> Please check the current patch (the one I sent to you as a pre-release did not
> contain the fix for the decryption part -- the patch sent to the list and what
> we discuss here contains the appropriate handling for the decryption side).
>
> With your example using 16 bytes AAD, 16 bytes CT and 16 bytes Tag, the read
> will *only* show the return code of 16 (bytes) now, because only the CT part
> is converted into PT.
>
> Yet, you are completely correct that the first 16 bytes of the AAD are skipped
> by the read call.
>
> Thus, the read call returns exactly the amount of changed bytes, but it
> deviates from the POSIX logic by seeking to the end of the AAD buffer to find
> the offset it shall place the resulting data to.

I re-built my kernel using the patch from this email thread, and I still 
see the total read() length including the "skipped" AAD byte count. Here's 
an strace excerpt for a decrypt operation with AAD length of 32 and 
plaintext length of 32:

sendmsg(5, {msg_name=NULL, msg_namelen=0, 
msg_iov=[{iov_base="*\200\233\350Zg\306\5ck\240\t\344\177\336 h\321\205\214<P^H~l\243\353w\34\377\316", iov_len=32}, 
{iov_base="\205\256}\336\27\276\31\333\321&\254w\244\244\323h\221)\254}\345s\227\242>f\266\2020\212\220\322"..., 
iov_len=48}], msg_iovlen=2, msg_control=[{cmsg_len=20, cmsg_level=SOL_ALG, cmsg_type=0x3},
{cmsg_len=20, cmsg_level=SOL_ALG, cmsg_type=0x4}, {cmsg_len=36, cmsg_level=SOL_ALG, cmsg_type=0x2}],
msg_controllen=88, msg_flags=0}, 0) = 80
read(5, "\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1"..., 64) = 64


The libkcapi test behaves similarly (AEAD test 11):

sendmsg(6, {msg_name=NULL, msg_namelen=0, 
msg_iov=[{iov_base="\373{\303\4\243\220\236f\342\340\305\357\225'\22\335\210L\343\3472Aq6\237,]\261\255\304\214}"..., 
iov_len=68}], msg_iovlen=1, msg_control=[{cmsg_len=20, cmsg_level=SOL_ALG, cmsg_type=0x3},
{cmsg_len=40, cmsg_level=SOL_ALG, cmsg_type=0x2}, {cmsg_len=20, cmsg_level=SOL_ALG, cmsg_type=0x4}],
msg_controllen=88, msg_flags=0}, 0) = 68
read(6, "\373{\303\4\243\220\236f\342\340\305\357\225'\22\335\210L\343\3472Aq6\237,]\261\255\304\214}"..., 68) = 64


Even with read() returning only the number of changed bytes, what would 
you think if there was one filesystem that updated the last bytes of a 
buffer in a read() call instead of the first? It's important to maintain 
the standard POSIX semantics and only update the bytes starting at the 
beginning of the buffer.

>
>> However, the first 16 bytes of buf are *unchanged* and the second 16 bytes
>> contain the plaintext. In other words, 16 bytes were skipped over and 16
>> bytes were read.
>
> Correct. Again, with the current patch we discuss here, the read will return
> 16 as it processed 16 bytes.
>>
>> I see how this is similar to the documented use of the dst buffer in
>> aead_request_set_crypt(), but it is not consistent with POSIX read()
>> semantics.

Regards,

--
Mat Martineau
Intel OTC
