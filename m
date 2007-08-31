From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Fri, 31 Aug 2007 09:28:34 +0800
Message-ID: <E1IQvJK-0006We-00@gondolin.me.apana.org.au>
References: <46D70BB1.907@gmx.ch>
Cc: linux-crypto@ml.breakpoint.cc, linux-crypto@vger.kernel.org
To: silencer@gmx.ch (Markus Huehnerbein)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1588 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbXHaB3B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 21:29:01 -0400
In-Reply-To: <46D70BB1.907@gmx.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Markus Huehnerbein <silencer@gmx.ch> wrote:
> 
> I thought that the problem is maybe related with the use of LUKS / the
> Master-Key created by the PBKDF2, so I tried cryptsetup without LUKS as
> follows (with the "geode_aes" module loaded):
>        cryptsetup -y -c aes -h md5 -s 128 create devdmcrypt /dev/hda2
> -No errors, neither in syslog nor in the output
> -Checking the output of "dmsetup ls":
>        devdmcrypt      (254, 0)
> -Creating ext2 filesystem
>        mkfs.ext2 /dev/mapper/devdmcrypt
> -Trying to mount /dev/mapper/devdmcrypt fails with "wrong fs type..."
> and syslog error: "VFS: Can't find an ext2 filesystem on dev dm-0"

Sounds like geode_aes is just broken.  Can you please check if
tcrypt with mode=10 and mode=200 work or not with the geode_aes
driver?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
