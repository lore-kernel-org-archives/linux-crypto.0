From: Bob Beck <beck@openbsd.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 11:57:59 -0600
Message-ID: <CAComcpPTRoHr3C7r7tdte+j94PmUw7VrptTVOg8uEsT-hTFuzA@mail.gmail.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
 <20140717173433.GQ1491@thunk.org> <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
 <CAComcpOkWLPJGDXWuYrC4Gtk02H_81qwSUzzM87qkx-tf6PUhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, Bob Beck <beck@openbsd.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-abi <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAComcpOkWLPJGDXWuYrC4Gtk02H_81qwSUzzM87qkx-tf6PUhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Or perhaps to put that another way, since you don't do minherit -
maybe a FORK_ZERO for madvise? or a similar way
to do that?


On Thu, Jul 17, 2014 at 11:46 AM, Bob Beck <beck@openbsd.org> wrote:
> And thanks btw.
>
> I don't suppose you guys know who we should talk to about possibly
> getting MAP_INHERIT_ZERO minherit() support?
>
> On Thu, Jul 17, 2014 at 11:45 AM, Bob Beck <beck@openbsd.org> wrote:
>> we have diffs pending that will do the syscall method until we start
>> to see it in libc :)
>>
>> So basically we're going to put that in right away :)
>>
>> On Thu, Jul 17, 2014 at 11:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> On Thu, Jul 17, 2014 at 11:05:01AM -0600, Bob Beck wrote:
>>>> Hi Ted, yeah I understand the reasoning, it would be good if there was
>>>> a way to influence the various libc people to
>>>> ensure they manage to provide a getentropy().
>>>
>>> I don't anticipate that to be a problem.  And before they do, and/or
>>> if you are dealing with a system where the kernel has been upgraded,
>>> but not libc, you have your choice of either sticking with the
>>> binary_sysctl approach, or calling getrandom directly using the
>>> syscall method; and in that case, whether we use getrandom() or
>>> provide an exact getentropy() replacement system call isn't that much
>>> difference, since you'd have to have Linux-specific workaround code
>>> anyway....
>>>
>>>                                 - Ted
