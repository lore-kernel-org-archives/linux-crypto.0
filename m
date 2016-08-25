From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Entropy sources (was: /dev/random - a new approach)
Date: Thu, 25 Aug 2016 19:35:29 -0400
Message-ID: <CACXcFmk8DWOxu+=J3i06bSvEW3tp_O2cxHLGdCuXTJROZ=hysA@mail.gmail.com>
References: <CAH8yC8nZyAZT2OiRXgT=CBfQ4RSw-E1uZaQvKuQZ9BDYuPmGvA@mail.gmail.com>
 <f57f675f-a914-4c72-f32a-4091e547905f@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeffrey Walton <noloader@gmail.com>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f57f675f-a914-4c72-f32a-4091e547905f@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 25, 2016 at 5:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:

> The network stack is a good source of entropy, *once it is online*.
> However, the most serious case is while the machine is still booting,
> when the network will not have enabled yet.
>
>         -hpa

One possible solution is at:
https://github.com/sandy-harris/maxwell

A small (< 700 lines) daemon that gets entropy from timer imprecision
and variations in time for arithmetic (cache misses, interrupts, etc.)
and pumps it into /dev/random. Make it the first userspace program
started and all should be covered. Directory above includes a PDF doc
with detailed rationale and some discussion of alternate solutions.

Of course if you are dealing with a system-on-a-chip or low-end
embedded CPU & the timer is really inadequate, this will not work
well. Conceivably well enough, but we could not know that without
detailed analysis for each chip in question.
