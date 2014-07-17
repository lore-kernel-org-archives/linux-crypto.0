From: Bob Beck <beck@openbsd.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 11:46:45 -0600
Message-ID: <CAComcpOkWLPJGDXWuYrC4Gtk02H_81qwSUzzM87qkx-tf6PUhQ@mail.gmail.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
 <20140717173433.GQ1491@thunk.org> <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, Bob Beck <beck@openbsd.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-abi <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51270 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaGQRrH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 13:47:07 -0400
Received: by mail-ie0-f173.google.com with SMTP id tr6so3470549ieb.32
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2014 10:47:06 -0700 (PDT)
In-Reply-To: <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

And thanks btw.

I don't suppose you guys know who we should talk to about possibly
getting MAP_INHERIT_ZERO minherit() support?

On Thu, Jul 17, 2014 at 11:45 AM, Bob Beck <beck@openbsd.org> wrote:
> we have diffs pending that will do the syscall method until we start
> to see it in libc :)
>
> So basically we're going to put that in right away :)
>
> On Thu, Jul 17, 2014 at 11:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Thu, Jul 17, 2014 at 11:05:01AM -0600, Bob Beck wrote:
>>> Hi Ted, yeah I understand the reasoning, it would be good if there was
>>> a way to influence the various libc people to
>>> ensure they manage to provide a getentropy().
>>
>> I don't anticipate that to be a problem.  And before they do, and/or
>> if you are dealing with a system where the kernel has been upgraded,
>> but not libc, you have your choice of either sticking with the
>> binary_sysctl approach, or calling getrandom directly using the
>> syscall method; and in that case, whether we use getrandom() or
>> provide an exact getentropy() replacement system call isn't that much
>> difference, since you'd have to have Linux-specific workaround code
>> anyway....
>>
>>                                 - Ted
