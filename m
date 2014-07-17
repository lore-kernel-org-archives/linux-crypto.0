From: Bob Beck <beck@openbsd.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 11:05:01 -0600
Message-ID: <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-abi <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Bob Beck <beck@openbsd.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:42511 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaGQRFW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 13:05:22 -0400
Received: by mail-ig0-f171.google.com with SMTP id l13so6559006iga.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2014 10:05:21 -0700 (PDT)
In-Reply-To: <20140717170115.GO1491@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted, yeah I understand the reasoning, it would be good if there was
a way to influence the various libc people to
ensure they manage to provide a getentropy().


On Thu, Jul 17, 2014 at 11:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 17, 2014 at 09:12:15AM -0700, Christoph Hellwig wrote:
>> On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:
>> > The getrandom(2) system call was requested by the LibreSSL Portable
>> > developers.  It is analoguous to the getentropy(2) system call in
>> > OpenBSD.
>>
>> What's the reason to not implement exactly the same system call OpenBSD
>> does?  Having slightly different names and semantics for the same
>> functionality is highly annoying.
>
> The getrandom(2) system call is a superset of getentropy(2).  When we
> add the support for this into glibc, it won't be terribly difficult
> nor annoying to drop the following in alongside the standard support
> needed for any new system call:
>
> int getentropy(void *buf, size_t buflen)
> {
>         int     ret;
>
>         ret = getentropy(buf, buflen, 0);
>         return (ret > 0) ? 0 : ret;
> }
>
> The reason for the additional flags is that I'm trying to solve more
> problems than just getentropy()'s raison d'etre.  The discussion of
> this is in the commit description; let me know if there bits that I
> could make clearer.
>
> Cheers,
>
>                                         - Ted
