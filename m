From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_hash: splice of data > 2**16
Date: Thu, 18 Dec 2014 13:37:48 +0100
Message-ID: <20272672.S6U6VsnYQl@tauon>
References: <8707521.TbV00HIEUx@tauon> <5492C6FC.50005@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55087 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaLRMhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Dec 2014 07:37:54 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SCE0D> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 18 Dec 2014 13:37:50 +0100
In-Reply-To: <5492C6FC.50005@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe:

Hi Leroy, Herbert,

>Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
>> Hi Herbert,
>>=20
>> While testing the vmsplice/splice interface of algif_hash I was made
>> aware of the problem that data blobs larger than 16 pages do not see=
m
>> to be hashed properly.
>>=20
>> For testing, a file is mmap()ed and handed to vmsplice / splice. If
>> the file is smaller than 2**16, the interface returns the proper
>> hash. However, when the file is larger, only the first 2**16 bytes
>> seem to be used.
>>=20
>> When adding printk's to hash_sendpage, I see that this function is
>> invoked exactly 16 times where the first 15 invocations have the
>> MSG_MORE flag set and the last invocation does not have MSG_MORE.
>
>Hi Stephan,
>
>I have already noticed the same issue and proposed a patch, but I neve=
r
>got any feedback and it has never been merged, allthought I pinged it
>a few times.
>
>See https://lkml.org/lkml/2014/4/18/276

Thanks a lot for pointing to this patch.

Herbert, do you see a problem in this patch? If no, would it be possibl=
e=20
that you ping the VFS maintainer as I guess your word carries more=20
weight?

In any case, I will test that patch tonight.

Thanks
Stephan
