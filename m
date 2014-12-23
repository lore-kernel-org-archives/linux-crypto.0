From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: algif_hash: splice of data > 2**16
Date: Tue, 23 Dec 2014 18:16:01 +0100
Message-ID: <5499A351.2010300@c-s.fr>
References: <8707521.TbV00HIEUx@tauon> <5492C6FC.50005@c-s.fr> <3364866.GGZiChayfE@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:31698 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaLWRQL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2014 12:16:11 -0500
In-Reply-To: <3364866.GGZiChayfE@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Le 20/12/2014 07:37, Stephan Mueller a =E9crit :
> Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe:
>
> Hi Christophe,
>
>> Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
>>> Hi Herbert,
>>>
>>> While testing the vmsplice/splice interface of algif_hash I was mad=
e
>>> aware of the problem that data blobs larger than 16 pages do not se=
em to
>>> be hashed properly.
>>>
>>> For testing, a file is mmap()ed and handed to vmsplice / splice. If=
 the
>>> file is smaller than 2**16, the interface returns the proper hash.
>>> However, when the file is larger, only the first 2**16 bytes seem t=
o be
>>> used.
>>>
>>> When adding printk's to hash_sendpage, I see that this function is
>>> invoked exactly 16 times where the first 15 invocations have the
>>> MSG_MORE flag set and the last invocation does not have MSG_MORE.
>> Hi Stephan,
>>
>> I have already noticed the same issue and proposed a patch, but I ne=
ver
>> got any feedback and it has never been merged, allthought I pinged i=
t a
>> few times.
>>
>> See https://lkml.org/lkml/2014/4/18/276
> After testing, this patch does not work for me. The operation still s=
tops
> after 16 pages.
Yes, it looks like the function I fixed is exclusively used by=20
sendfile() system call.
So there is probably the same kind of fix to be done in another functio=
n.

Christophe
