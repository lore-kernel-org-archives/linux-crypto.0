From: Bob Beck <beck@openbsd.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 11:45:56 -0600
Message-ID: <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com> <20140717173433.GQ1491@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, Bob Beck <beck@openbsd.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-abi <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60002 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGQRqS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 13:46:18 -0400
Received: by mail-ie0-f176.google.com with SMTP id tr6so3423208ieb.21
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2014 10:46:18 -0700 (PDT)
In-Reply-To: <20140717173433.GQ1491@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

we have diffs pending that will do the syscall method until we start
to see it in libc :)

So basically we're going to put that in right away :)

On Thu, Jul 17, 2014 at 11:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 17, 2014 at 11:05:01AM -0600, Bob Beck wrote:
>> Hi Ted, yeah I understand the reasoning, it would be good if there was
>> a way to influence the various libc people to
>> ensure they manage to provide a getentropy().
>
> I don't anticipate that to be a problem.  And before they do, and/or
> if you are dealing with a system where the kernel has been upgraded,
> but not libc, you have your choice of either sticking with the
> binary_sysctl approach, or calling getrandom directly using the
> syscall method; and in that case, whether we use getrandom() or
> provide an exact getentropy() replacement system call isn't that much
> difference, since you'd have to have Linux-specific workaround code
> anyway....
>
>                                 - Ted
