From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about crypto module dependency
Date: Wed, 18 Jan 2012 14:56:45 +0100
Message-ID: <CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
	<20120118053933.GA23562@gondor.apana.org.au>
	<CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com>
	<20120118121325.GA25822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47120 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757530Ab2ARN4q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 08:56:46 -0500
Received: by obcva7 with SMTP id va7so7280761obc.19
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2012 05:56:45 -0800 (PST)
In-Reply-To: <20120118121325.GA25822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 1:13 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 18, 2012 at 08:49:13AM +0100, Francis Moreau wrote:
>>
>> > What is the user in question?
>>
>> btrfs
>
> Hmm, why does it need to do crc32c at module init time?
>

What do you mean with "at module init time" ?

My point is:

  $ grep btrfs /lib/modules/3.2.1/modules.dep
  kernel/fs/btrfs/btrfs.ko: kernel/lib/zlib_deflate/zlib_deflate.ko
kernel/lib/libcrc32c.ko

and

  $ grep libcrc32c.ko: /lib/modules/3.2.1-1.1-desktop/modules.dep
  kernel/lib/libcrc32c.ko:

So there's no dependency here to 'pull' a crc32c backend, therefore
"crypto_alloc_shash("crc32c", 0, 0)" used by libcrc32c at load time
fails.

Thanks
-- 
Francis
