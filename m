From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: algif_hash: splice of data > 2**16
Date: Thu, 18 Dec 2014 13:22:20 +0100
Message-ID: <5492C6FC.50005@c-s.fr>
References: <8707521.TbV00HIEUx@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8707521.TbV00HIEUx@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
> Hi Herbert,
>
> While testing the vmsplice/splice interface of algif_hash I was made
> aware of the problem that data blobs larger than 16 pages do not seem=
 to
> be hashed properly.
>
> For testing, a file is mmap()ed and handed to vmsplice / splice. If t=
he
> file is smaller than 2**16, the interface returns the proper hash.
> However, when the file is larger, only the first 2**16 bytes seem to =
be
> used.
>
> When adding printk's to hash_sendpage, I see that this function is
> invoked exactly 16 times where the first 15 invocations have the
> MSG_MORE flag set and the last invocation does not have MSG_MORE.
>
>
Hi Stephan,

I have already noticed the same issue and proposed a patch, but I never=
=20
got any feedback and it has never been merged, allthought I pinged it a=
=20
few times.

See https://lkml.org/lkml/2014/4/18/276

Christophe
