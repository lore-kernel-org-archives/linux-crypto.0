From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [Question] AEAD crypto api for userspace can't deal with a PTlen=0 vector
Date: Mon, 11 May 2015 09:59:59 +0200
Message-ID: <1984935.lhMUbQKbef@tauon>
References: <554B3415.3060707@huawei.com> <20150511063509.GA2430@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Yao Dongdong <yaodongdong@huawei.com>,
	linux-crypto@vger.kernel.org, "Lihui (Eric)" <lihui8@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34762 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbbEKIAG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 04:00:06 -0400
In-Reply-To: <20150511063509.GA2430@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 11. Mai 2015, 14:35:09 schrieb Herbert Xu:

Hi Herbert,

>On Thu, May 07, 2015 at 05:44:53PM +0800, Yao Dongdong wrote:
>> while we use crypto api for userspace to do vectors test for AEAD(aes-gcm),
>> we encounter a problem. There are some test vector's PTlen is 0,for
>> example:
>> [Keylen = 128]
>> [IVlen = 96]
>> [PTlen = 0]
>> [AADlen = 0]
>> [Taglen = 128]
>> 
>> Count = 0
>> Key = 7e93936b2e2188cfa9c9882ad901312f
>> IV = b6879804163b9eaf5bfe5218
>> CT =
>> AAD =
>> Tag = aa77daf382d0d63480ff8c8a2dee149e
>> 
>> In testing vectors like that, we will get an error result that the decrypt
>> return is success but the right return is a ghash verify fail.
>> After digging into the kernel(3.10) code, we find the function
>> sock_aio_read
>> in net/socket.c has a judgement of iocb->ki_left which will be 0 when we
>> do an aes-gcm decrypt decribed above.
>> 
>> static ssize_t sock_aio_read(struct kiocb *iocb, const struct iovec *iov,
>> 
>>                 unsigned long nr_segs, loff_t pos)
>> 
>> {
>> 
>>     struct sock_iocb siocb, *x;
>>     
>>     if (pos != 0)
>>     
>>         return -ESPIPE;
>>     
>>     if (iocb->ki_left == 0) /* Match SYS5 behaviour */
>>     
>>         return 0;
>>     
>>     x = alloc_sock_iocb(iocb, &siocb);
>>     if (!x)
>>     
>>         return -ENOMEM;
>>     
>>     return do_sock_read(&x->async_msg, iocb, iocb->ki_filp, iov, nr_segs);
>> 
>> }
>> 
>> So it directly return before calling aes-gcm decrypt.
>> 
>> How can we deal with that?
>
>Does this still happen if you use recvmsg?

Indeed, this works.
>
>Cheers,


Ciao
Stephan
