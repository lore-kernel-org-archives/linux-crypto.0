From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: algif_hash: splice of data > 2**16
Date: Wed, 24 Dec 2014 15:10:14 +0100
Message-ID: <549AC946.2000909@c-s.fr>
References: <8707521.TbV00HIEUx@tauon> <3364866.GGZiChayfE@tachyon.chronox.de> <5499A351.2010300@c-s.fr> <11733044.fQnf94a6to@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:34608 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaLXOKR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Dec 2014 09:10:17 -0500
In-Reply-To: <11733044.fQnf94a6to@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Le 24/12/2014 10:03, Stephan Mueller a =E9crit :
> Am Dienstag, 23. Dezember 2014, 18:16:01 schrieb leroy christophe:
>
> Hi leroy,
>
>> Le 20/12/2014 07:37, Stephan Mueller a =E9crit :
>>> Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe=
:
>>>
>>> Hi Christophe,
>>>
>>>> Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
>>>>> Hi Herbert,
>>>>>
>>>>> While testing the vmsplice/splice interface of algif_hash I was m=
ade
>>>>> aware of the problem that data blobs larger than 16 pages do not =
seem to
>>>>> be hashed properly.
>>>>>
>>>>> For testing, a file is mmap()ed and handed to vmsplice / splice. =
If the
>>>>> file is smaller than 2**16, the interface returns the proper hash=
=2E
>>>>> However, when the file is larger, only the first 2**16 bytes seem=
 to be
>>>>> used.
>>>>>
>>>>> When adding printk's to hash_sendpage, I see that this function i=
s
>>>>> invoked exactly 16 times where the first 15 invocations have the
>>>>> MSG_MORE flag set and the last invocation does not have MSG_MORE.
>>>> Hi Stephan,
>>>>
>>>> I have already noticed the same issue and proposed a patch, but I =
never
>>>> got any feedback and it has never been merged, allthought I pinged=
 it a
>>>> few times.
>>>>
>>>> See https://lkml.org/lkml/2014/4/18/276
>>> After testing, this patch does not work for me. The operation still=
 stops
>>> after 16 pages.
>> Yes, it looks like the function I fixed is exclusively used by
>> sendfile() system call.
>> So there is probably the same kind of fix to be done in another func=
tion.
> I do not believe that is the case. IMHO the blocking issue is found i=
n the
> following code:
>
> splice_from_pipe_feed walks the pipe->nrbufs. And vmsplice_to_pipe de=
fines the
> maximum number of nrbufs as PIPE_DEF_BUFFERS -- which is 16. As subse=
quent
> functions allocate memory based on PIPE_DEF_BUFFERS, there is no triv=
ial way
> to increase the number of pages to be processed.
>
> Thus I see that the vmsplice/splice combo can at most operate on a ch=
unk of 16
> pages. Thus, you have to segment your input buffer into chunks of tha=
t size
> and invoke the vmsplice/splice syscalls for each segment.
>
Yes your are probably right. There splice needs to be called with=20
SPLICE_F_MORE flag, hope that works.
