From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about crypto module dependency
Date: Wed, 18 Jan 2012 08:49:13 +0100
Message-ID: <CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
	<20120118053933.GA23562@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57386 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab2ARHtN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 02:49:13 -0500
Received: by obcva7 with SMTP id va7so6847297obc.19
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2012 23:49:13 -0800 (PST)
In-Reply-To: <20120118053933.GA23562@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 6:39 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello,
>>
>> I'm wondering how this scenario is supposed to work: let's say a
>> module A uses 'crc32c' function in lib/libcrc32c.c. In its turn this
>> function calls crypto_shash_update() which is exported by
>> crypto/shash.c. But now no module implementing "crc32c" has still been
>> loaded although crc32c.ko is available. Therefore the initial load of
>> module A fails although all required modules by the system are
>> present.
>>
>> If the above is correct, how should it be handled ?
>
> We'd need to adjust the init priority of libcrc32c and whatever
> it depends on.

Could you give me some details beacause I don't see how that would work...

Currently we have this : libcrc32c -> shash

where '->' means depend on.

However I think we should have this: libcrc32c -> shash -> crc32c, to
get all modules properly loaded when using libcrc32c.

But it seems not possible because of the way shash is doing the load
of its backends dynamically: it requires that the backend has already
been registered.

>
> What is the user in question?

btrfs

Thanks.
-- 
Francis
