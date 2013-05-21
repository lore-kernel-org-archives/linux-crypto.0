From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
Date: Tue, 21 May 2013 12:43:50 -0400
Message-ID: <CACXcFmnqfpsAnS3ca-bfqE=Ru5vsdFv4atZoE=5AoH9CgWAAfQ@mail.gmail.com>
References: <20130521084455.5c651991@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130521084455.5c651991@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I very much like the basic notion here. The existing random(4) driver
may not get enough entropy in a VM or on a device like a Linux router
and I think work such as yours or HAVEGE
(http://www.irisa.fr/caps/projects/hipsor/) are important research.
The paper by McGuire et al of "Analysis of inherent randomness of the
Linux kernel" (http://lwn.net/images/conf/rtlws11/random-hardware.pdf)
seems to show that this is a fine source of more entropy.

On the other hand, I am not certain you are doing it in the right
place. My own attempt (ftp://ftp.cs.sjtu.edu.cn:990/sandy/maxwell/)
put it in a demon that just feeds /dev/random, probably also not the
right place. haveged(8) (http://www.issihosts.com/haveged/) also puts
it in a demon process. It may, as you suggest, belong in the kernel
instead, but I think there are arguments both ways.

Could we keep random(4) mostly as is and rearrange your code to just
give it more entropy? I think the large entropy pool in the existing
driver is essential since we sometimes want to generate things like a
2 Kbit PGP key and it is not clear to me that your driver is entirely
trustworthy under such stress.

On Tue, May 21, 2013 at 2:44 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Hi,
>
> [1] patch at http://www.chronox.de/jent/jitterentropy-20130516.tar.bz2
>
> A new version of the CPU Jitter random number generator is released at
> http://www.chronox.de/ . The heart of the RNG is about 30 lines of easy
> to read code. The readme in the main directory explains the different
> code files. A changelog can be found on the web site.
>
> In a previous attempt (http://lkml.org/lkml/2013/2/8/476), the first
> iteration received comments for the lack of tests, documentation and
> entropy assessment. All these concerns have been addressed. The
> documentation of the CPU Jitter random number generator
> (http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html and PDF at
> http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf -- the graphs and
> pictures are better in PDF) offers a full analysis of:
>
> - the root cause of entropy
>
> - a design of the RNG
>
> - statistical tests and analyses
>
> - entropy assessment and explanation of the flow of entropy
>
> The document also explains the core concept to have a fully
> decentralized entropy collector for every caller in need of entropy.
>
> Also, this RNG is well suitable for virtualized environments.
> Measurements on OpenVZ and KVM environments have been conducted as
> documented. As the Linux kernel is starved of entropy in virtualized as
> well as server environments, new sources of entropy are vital.
>
> The appendix of the documentation contains example use cases by
> providing link code to the Linux kernel crypto API, libgcrypt and
> OpenSSL. Links to other cryptographic libraries should be straight
> forward to implement. These implementations follow the concept of
> decentralized entropy collection.
>
> The man page provided with the source code explains the use of the API
> of the CPU Jitter random number generator.
>
> The test cases used to compile the documentation are available at the
> web site as well.
>
> Note: for the kernel crypto API, please read the provided Kconfig file
> for the switches and which of them are recommended in regular
> operation. These switches must currently be set manually in the
> Makefile.
>
> Ciao
> Stephan
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Who put a stop payment on my reality check?
