From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Tue, 17 Jul 2018 21:51:54 -0400
Message-ID: <20180718015154.GE3489@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: labbott@redhat.com
To: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718014344.1309-1-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 17, 2018 at 09:43:44PM -0400, Theodore Ts'o wrote:
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

Note, I had meant to tag this with an RFC.  I'm not sure I really want
to push this to Linus yet.  If you have an opinion, let me know.

Thanks!

	   	     	      	    - Ted



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
> +config RANDOM_TRUST_CPU
> +       bool "Trust the CPU manufacturer to initialize Linux's CRNG"
> +       depends on (X86 || X86_64 || X86_32 || S390 || PPC)
> +       default n
> +       help
> +	Assume that CPU manufacurer (e.g., Intel or AMD for RDSEED or
> +	RDRAND, IBM for the S390 and Power PC architectures) is trustworthy
> +	for the purposes of initializing Linux's CRNG.  Since this is not
> +	something that can be indepedently audited, this amounts to trusting
> +	that CPU manufacturer (perhaps with the insistance or requirement
> +	of a Nation State's intelligence or law enforcement agencies)
> +	has not installed a hidden back door to compromise the CPU's
> +	random number generation facilities.
> +
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 34ddfd57419b..f4013b8a711b 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -782,6 +782,7 @@ static void invalidate_batched_entropy(void);
>  static void crng_initialize(struct crng_state *crng)
>  {
>  	int		i;
> +	int		arch_init = 1;
>  	unsigned long	rv;
>  
>  	memcpy(&crng->state[0], "expand 32-byte k", 16);
> @@ -792,10 +793,18 @@ static void crng_initialize(struct crng_state *crng)
>  		_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
>  	for (i = 4; i < 16; i++) {
>  		if (!arch_get_random_seed_long(&rv) &&
> -		    !arch_get_random_long(&rv))
> +		    !arch_get_random_long(&rv)) {
>  			rv = random_get_entropy();
> +			arch_init = 0;
> +		}
>  		crng->state[i] ^= rv;
>  	}
> +#ifdef CONFIG_RANDOM_TRUST_CPU
> +	if (arch_init) {
> +		crng_init = 2;
> +		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
> +	}
> +#endif
>  	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
>  }
>  
> -- 
> 2.18.0.rc0
> 
