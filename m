From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about crypto module dependency
Date: Sun, 22 Jan 2012 15:47:53 +0100
Message-ID: <CAC9WiBjgVdGDfWdZ5CR-1ZAN3rw9Qq4ySHPu8BuhPTdey8WqbA@mail.gmail.com>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
	<20120118053933.GA23562@gondor.apana.org.au>
	<CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com>
	<20120118121325.GA25822@gondor.apana.org.au>
	<CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com>
	<20120118222516.GA30542@gondor.apana.org.au>
	<CAC9WiBgSXRizqSNdnPv7yd8O1Ysd4r89f44CCtG4XY_+z+9Khg@mail.gmail.com>
	<20120119115831.GA3017@gondor.apana.org.au>
	<CAC9WiBiLx4=uugZSjrGrmOAX_6aWY_OP3ywWv7aEwOOWgt-yVw@mail.gmail.com>
	<20120119122841.GA3437@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55225 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab2AVOry convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Jan 2012 09:47:54 -0500
Received: by obcva7 with SMTP id va7so2221489obc.19
        for <linux-crypto@vger.kernel.org>; Sun, 22 Jan 2012 06:47:53 -0800 (PST)
In-Reply-To: <20120119122841.GA3437@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2012 at 1:28 PM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> On Thu, Jan 19, 2012 at 01:26:30PM +0100, Francis Moreau wrote:
>> On Thu, Jan 19, 2012 at 12:58 PM, Herbert Xu
>> <herbert@gondor.apana.org.au> wrote:
>> > On Thu, Jan 19, 2012 at 09:10:48AM +0100, Francis Moreau wrote:
>> >>
>> >> How things are supposed to work when :
>> >>
>> >> =A0 - crc32c module is not loaded
>> >> =A0 - libcrc32c module is not loaded
>> >> =A0 - btrfs is not loaded
>> >>
>> >> and I issue: "modprobe btrfs" ?
>> >
>> > When libcrc32c is loaded it'll automatically load crc32c through
>> > the Crypto API.
>> >
>>
>> Did you try ?
>
> Yes it works on my machine.
>

Ok, It's acutally the user space tools which are confused: they don't
have a way to track the dependency therefore crc32c is not included in
my initrd.

I'm wondering how this could be fixed... I could hard code the
dependency in userspace but it looks like an ugly workaround.

Thanks
--=20
=46rancis
