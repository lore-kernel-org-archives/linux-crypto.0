From: Jeffrey Walton <noloader@gmail.com>
Subject: Entropy sources (was: /dev/random - a new approach)
Date: Sun, 21 Aug 2016 01:37:29 -0400
Message-ID: <CAH8yC8nZyAZT2OiRXgT=CBfQ4RSw-E1uZaQvKuQZ9BDYuPmGvA@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "H. Peter Anvin" <hpa@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36800 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbcHUFhb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Aug 2016 01:37:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 19, 2016 at 1:20 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 08/18/16 22:56, Herbert Xu wrote:
>> On Thu, Aug 18, 2016 at 10:49:47PM -0400, Theodore Ts'o wrote:
>>>
>>> That really depends on the system.  We can't assume that people are
>>> using systems with a 100Hz clock interrupt.  More often than not
>>> people are using tickless kernels these days.  That's actually the
>>> problem with changing /dev/urandom to block until things are
>>> initialized.
>>
>> Couldn't we disable tickless until urandom has been seeded? In fact
>> perhaps we should accelerate the timer interrupt rate until it has
>> been seeded?
>>
>
> The biggest problem there is that the timer interrupt adds *no* entropy
> unless there is a source of asynchronicity in the system.  On PCs,
> traditionally the timer has been run from a completely different crystal
> (14.31818 MHz) than the CPU, which is the ideal situation, but if they
> are run off the same crystal and run in lockstep, there is very little
> if anything there.  On some systems, the timer may even *be* the only
> source of time, and the entropy truly is zero.

It seems like a networked computer should have an abundance on entropy
available from the network stack. Every common case I can come up with
includes a networked computer. If a handheld is outside of coverage,
then it probably does not have the randomness demands because it can't
communicate (i.e., TCP sequence numbers, key agreement, etc).

In fact, there are at least two papers that use bits from the network stack:

* When Good Randomness Goes Bad: Virtual Machine Reset Vulnerabilities
and Hedging Deployed Cryptography,
http://pages.cs.wisc.edu/~rist/papers/sslhedge.pdf
* When Virtual is Harder than Real: Security Challenges in Virtual
Machine Based Computing Environments,
http://www.usenix.org/legacy/event/hotos05/final_papers/full_papers/garfinkel/garfinkel.pdf

As IoT gains traction the entropy available locally should increase
because these devices are chatty. I also expect gossip protocols to
play more of a role in the future. A network based attacker cannot
possibly monitor every conversation, especially when devices pair and
form adhoc networks. The network attacker probably won't see the
traffic on a local LAN segment either for headless servers.

When using network bits, it seems like the remaining problem is
extracting the entropy. I think Krawczyk (et al) have done a lot of
work in this area:

* Leftover Hash Lemma, Revisited, http://eprint.iacr.org/2011/088.pdf
* Cryptographic Extraction and Key Derivation: The HKDF Scheme,
http://eprint.iacr.org/2010/264.pdf

Jeff
