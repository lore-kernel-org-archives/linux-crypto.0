From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Thu, 16 Aug 2018 12:46:21 -0700
Message-ID: <20180816194620.GA185651@gmail.com>
References: <20180801072246.GA15677@sol.localdomain>
 <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
 <20180814211229.GB24575@gmail.com>
 <20180815162819.22765.qmail@cr.yp.to>
 <20180815195732.GA79500@gmail.com>
 <20180816042454.15529.qmail@cr.yp.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: "D. J. Bernstein" <djb@cr.yp.to>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180816042454.15529.qmail@cr.yp.to>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Dan,

(I reordered your responses slightly to group together similar topics)

On Thu, Aug 16, 2018 at 04:24:54AM -0000, D. J. Bernstein wrote:
> Eric Biggers writes:
> > You'd probably attract more contributors if you followed established
> > open source conventions.
> 
> SUPERCOP already has thousands of implementations from hundreds of
> contributors. New speed records are more likely to appear in SUPERCOP
> than in any other cryptographic software collection. The API is shared
> by state-of-the-art benchmarks, state-of-the-art tests, three ongoing
> competitions, and increasingly popular production libraries.
[...]
> > there doesn't appear to be an official git repository for SUPERCOP,
> > nor is there any mention of how to send patches, nor is there any
> > COPYING or LICENSE file, nor even a README file.
> 
> https://bench.cr.yp.to/call-stream.html explains the API and submission
> procedure for stream ciphers. There are similar pages for other types of
> cryptographic primitives. https://bench.cr.yp.to/tips.html explains the
> develop-test cycle and various useful options.
> 
> Licenses vary across implementations. There's a minimum requirement of
> public distribution for verifiability of benchmark results, but it's up
> to individual implementors to decide what they'll allow beyond that.
> Patent status also varies; constant-time status varies; verification
> status varies; code quality varies; cryptographic security varies; etc.
> As I mentioned, SUPERCOP includes MD5 and Speck and RSA-512.

Many people may have contributed to SUPERCOP already, but that doesn't mean
there aren't things you could do to make it more appealing to contributors and
more of a community project, especially since you're suggesting it to the Linux
kernel community.  There should be a git repository with the development
history, including all documentation files so they are available even if your
website goes offline (i.e. the "bus factor" should be > 1), and there should be
a way to contribute by a conventional means that invites public review, e.g.
sending a patch to a mailing list or opening a Github pull request.

The apparent lack of a license for the SUPERCOP benchmarking framework itself is
also problematic.  Though you've marked some individual files as "Public
domain", not all files are such marked (e.g. crypto_stream/measure.c), so AFAIK
there is no explicit permission given to redistribute them.  In some people's
view, license-less projects like this aren't really free software.  So Linux
distributions may not want to take on the legal risk of distributing it, nor may
companies want to take on the risk of contributing.  It may seem silly, but some
people do take these things *very* seriously!

Fortunately, it's easy for you to fix the licensing: just add a standard license
like the MIT license as a file named COPYING in the top-level directory.

> Am I correctly gathering from this thread that someone adding a new
> implementation of a crypto primitive to the kernel has to worry about
> checking the architecture and CPU features to figure out whether the
> implementation will run? Wouldn't it make more sense to take this
> error-prone work away from the implementor and have a robust automated
> central testing mechanism, as in SUPERCOP?
> 
> Am I also correctly gathering that adding an extra implementation to the
> kernel can hurt performance, unless the implementor goes to extra effort
> to check for the CPUs where the previous implementation is faster---or
> to build some ad-hoc timing mechanism ("raid6: using algorithm avx2x4
> gen() 31737 MB/s")? Wouldn't it make more sense to take this error-prone
> work away from the implementor and have a robust automated central
> timing mechanism, as in SUPERCOP?

If you're talking about things like "don't use the AVX2 implementation if the
CPU doesn't support AVX2", then of course has to be checked, but that's
straightforward.

If (more likely) you're talking about things like "use this NEON implementation
on Cortex-A7 but this other NEON implementation on Cortex-A53", it's up the
developers and community to test different CPUs and make appropriate decisions,
and yes it can be very useful to have external benchmarks like SUPERCOP to refer
to, and I appreciate your work in that area.  Note that in practice, the
priority order in Linux's crypto API has actually tended to be straightforward,
like generic -> SSE2 -> SSE3 -> AVX2, since historically people haven't cared
quite enough about crypto performance in the kernel to microoptimize it for
individual CPU microarchitectures, nor have there been many weird cases like ARM
NEON where scalar instructions are free when interleaved with vector
instructions on some CPUs but not others.  Maybe that's changing as more people
need optimal crypto performance in the kernel.

> I also didn't notice anyone disputing Jason's comment about the "general
> clunkiness" of the kernel's internal crypto API---but is there really no
> consensus as to what the replacement API is supposed to be? Someone who
> simply wants to implement some primitives has to decide on function-call
> details, argue about the software location, add configuration options,
> etc.? Wouldn't it make more sense to do this centrally, as in SUPERCOP?

Not yet; that's the purpose of code review, so that a consensus can be reached.
But if/when the new APIs land, the next contributor who wants to do things
similarly will have a much easier time.

As a side note, are you certain you've received and read all responses to this
thread?  I haven't always bothered replying to your "qsecretary notice", and I
suspect that many others do the same.  (Imagine if everyone used that, so
everyone had to reply to 10 "qsecretary notices" on threads like this!)

> And then there's the bigger question of how the community is organizing
> ongoing work on accelerating---and auditing, and fixing, and hopefully
> verifying---implementations of cryptographic primitives. Does it really
> make sense that people looking for what's already been done have to go
> poking around a bunch of separate libraries? Wouldn't it make more sense
> to have one central collection of code, as in SUPERCOP? Is there any
> fundamental obstacle to having libraries share code for primitives?

A lot of code can be shared, but in practice different environments have
different constraints, and kernel programming in particular has some distinct
differences from userspace programming.  For example, you cannot just use the
FPU (including SSE, AVX, NEON, etc.) registers whenever you want to, since on
most architectures they can't be used in some contexts such as hardirq context,
and even when they *can* be used you have to run special code before and after
which does things like saving all the FPU registers to the task_struct,
disabling preemption, and/or enabling the FPU.  But disabling preemption for
long periods of time hurts responsiveness, so it's also desirable to yield the
processor occasionally, which means that assembly implementations should be
incremental rather than having a single entry point that does everything.

There are also many other rules that must be followed in kernel code, like not
being free to use the %rbp register on x86 for anything other than the frame
base pointer, or having to make indirect calls in asm code through a special
macro that mitigates the Spectre vulnerability.

So yes, crypto code can sometimes be shared, but changes often do need to be
made for the kernel.

> For comparison, where can I find an explanation of how to test kernel
> crypto patches, and how fast is the develop-test cycle? Okay, I don't
> have a kernel crypto patch, but I did write a kernel patch recently that
> (I think) fixes some recent Lenovo ACPI stupidity:
> 
>    https://marc.info/?l=qubes-users&m=153308905514481
> 
> I'd propose this for review and upstream adoption _if_ it survives
> enough tests---but what's the right test procedure? I see superficial
> documentation of where to submit a patch for review, but am I really
> supposed to do this before serious testing? The patch works on my
> laptop, and several other people say it works, but obviously this is
> missing the big question of whether the patch breaks _other_ laptops.
> I see an online framework for testing, but using it looks awfully
> complicated, and the level of coverage is unclear to me. Has anyone
> tried to virtualize kernel testing---to capture hardware data from many
> machines and then centrally simulate kernels running on those machines,
> for example to check that those machines don't take certain code paths?
> I suppose that people who work with the kernel all the time would know
> what to do, but for me the lack of information was enough of a deterrent
> that I switched to doing something else.

The process for submitting Linux kernel patches is very well documented.  If
you're interested in contributing, you're welcome to read
Documentation/process/submitting-patches.rst and the other documentation.

As for testing, things are different for different parts of the kernel.  Some
parts are covered well by automated tests, others rely more on manual tests, and
others rely more on a large community running the kernel, especially -rc
(release candidate) kernels, and reporting any problems.  For the crypto API
specifically, there are correctness self-tests that are automatically run when
an option is set in the kernel .config.  Developers should always run them, but
even if they don't, other people are running them too on various hardware.

ACPI workarounds for firmware bugs are a somewhat different story...  AFAIK,
those types of patches rely on testing and review done by the developer, the
subsystem maintainters, and the broader community; as well as the community
reporting any problems they experience in -rc kernels.  Many people, such as
myself, run -rc kernels on their computer(s) and will report any problems found.
Yes, the standards of correctness for those types of things are not as high for
crypto algorithms, which is a shame; but when you're talking about hacking
around bugs in specific firmware versions in specific laptops, there's probably
not much more that can be done in practice...  So I encourage you to still send
out your ACPI patch!

Thanks,

- Eric
