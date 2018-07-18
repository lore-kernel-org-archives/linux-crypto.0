From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Tue, 17 Jul 2018 22:09:10 -0700
Message-ID: <ec07bf22-31aa-638e-b40b-4f3efb1b77b5@infradead.org>
References: <20180718014344.1309-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: labbott@redhat.com
To: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718014344.1309-1-tytso@mit.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 07/17/2018 06:43 PM, Theodore Ts'o wrote:
> This gives the user building their own kernel (or a Linux
> distribution) the option of deciding whether or not to trust the CPU's
> hardware random number generator (e.g., RDRAND for x86 CPU's) as being
> correctly implemented and not having a back door introduced (perhaps
> courtesy of a Nation State's law enforcement or intelligence
> agencies).
> 
> This will prevent getrandom(2) from blocking, if there is a
> willingness to trust the CPU manufacturer.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> 
>  I'm not sure Linux distro's will thank us for this.  The problem is
>  trusting the CPU manfuacturer can be an emotional / political issue.
> 
>  For example, assume that China has decided that as a result of the
>  "death sentence" that the US government threatened to impose on ZTE
>  after they were caught introducing privacy violating malware on US
>  comsumers, that they needed to be self-sufficient in their technology
>  sector, and so they decided the needed to produce their own CPU.
> 
>  Even if I were convinced that Intel hadn't backdoored RDRAND (or an
>  NSA agent backdoored RDRAND for them) such that the NSA had a NOBUS
>  (nobody but us) capability to crack RDRAND generated numbers, if we
>  made a change to unconditionally trust RDRAND, then I didn't want the
>  upstream kernel developers to have to answer the question, "why are
>  you willing to trust Intel, but you aren't willing to trust a company
>  owned and controlled by a PLA general?"  (Or a company owned and
>  controlled by one of Putin's Oligarchs, if that makes you feel
>  better.)
> 
>  With this patch, we don't put ourselves in this position --- but we
>  do put the Linux distro's in this position intead.  The upside is it
>  gives the choice to each person building their own Linux kernel to
>  decide whether trusting RDRAND is worth it to avoid hangs due to
>  userspace trying to get cryptographic-grade entropy early in the boot
>  process.  (Note: I trust RDRAND more than I do Jitter Entropy.)
> 
>  drivers/char/Kconfig  | 14 ++++++++++++++
>  drivers/char/random.c | 11 ++++++++++-
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 212f447938ae..fe2930c4ecf0 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -554,3 +554,17 @@ config ADI
>  
>  endmenu
>  

Hi Ted,

In case you go further with this:


> +config RANDOM_TRUST_CPU
> +       bool "Trust the CPU manufacturer to initialize Linux's CRNG"
> +       depends on (X86 || X86_64 || X86_32 || S390 || PPC)

	depends on X86 || S390 || PPC
should be sufficient.

> +       default n
> +       help

and all 4 lines above should be indented with one tab instead of spaces.

> +	Assume that CPU manufacurer (e.g., Intel or AMD for RDSEED or

	                manufacturer

> +	RDRAND, IBM for the S390 and Power PC architectures) is trustworthy
> +	for the purposes of initializing Linux's CRNG.  Since this is not
> +	something that can be indepedently audited, this amounts to trusting

	                      independently

> +	that CPU manufacturer (perhaps with the insistance or requirement

	                                        insistence

> +	of a Nation State's intelligence or law enforcement agencies)
> +	has not installed a hidden back door to compromise the CPU's
> +	random number generation facilities.


-- 
~Randy
