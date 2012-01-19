From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about crypto module dependency
Date: Thu, 19 Jan 2012 09:10:48 +0100
Message-ID: <CAC9WiBgSXRizqSNdnPv7yd8O1Ysd4r89f44CCtG4XY_+z+9Khg@mail.gmail.com>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
	<20120118053933.GA23562@gondor.apana.org.au>
	<CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com>
	<20120118121325.GA25822@gondor.apana.org.au>
	<CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com>
	<20120118222516.GA30542@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50953 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab2ASIKt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Jan 2012 03:10:49 -0500
Received: by obcva7 with SMTP id va7so8327110obc.19
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2012 00:10:48 -0800 (PST)
In-Reply-To: <20120118222516.GA30542@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 11:25 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 18, 2012 at 02:56:45PM +0100, Francis Moreau wrote:
>>
>> What do you mean with "at module init time" ?
>>
>> My point is:
>>
>> =A0 $ grep btrfs /lib/modules/3.2.1/modules.dep
>> =A0 kernel/fs/btrfs/btrfs.ko: kernel/lib/zlib_deflate/zlib_deflate.k=
o
>> kernel/lib/libcrc32c.ko
>>
>> and
>>
>> =A0 $ grep libcrc32c.ko: /lib/modules/3.2.1-1.1-desktop/modules.dep
>> =A0 kernel/lib/libcrc32c.ko:
>>
>> So there's no dependency here to 'pull' a crc32c backend, therefore
>> "crypto_alloc_shash("crc32c", 0, 0)" used by libcrc32c at load time
>> fails.
>
> We have a Kconfig dependency and the rest is taken care of by
> modprobe.

Hmm could you please be more verbose and details how it's supposed to w=
ork ?

How things are supposed to work when :

  - crc32c module is not loaded
  - libcrc32c module is not loaded
  - btrfs is not loaded

and I issue: "modprobe btrfs" ?

>
> Perhaps your problem is really with mkinitramfs?
>

=46or now I can't tell, I did describe the issue I'm facing (it's not a
theoritical one) but you still haven't described how this is supposed
to work.

And after reading the code, I don't see how the use case I described
previously can work without some user space tweakings. But should
userpsace stuff have knowledge of such module deps ?

Thanks for your time.
--=20
=46rancis
