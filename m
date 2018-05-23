From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 16/27] compiler: Option to add PROVIDE_HIDDEN
 replacement for weak symbols
Date: Wed, 23 May 2018 14:16:11 -0700
Message-ID: <92748474-8044-4b55-7529-c982342855ab@infradead.org>
References: <20180523195421.180248-1-thgarnie@google.com>
 <20180523195421.180248-17-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org,
 linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-hardening@lists.openwall.com
To: Thomas Garnier <thgarnie@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Kate Stewart <kstewart@linuxfoundation.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook
 <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len
Return-path: <kernel-hardening-return-13375-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180523195421.180248-17-thgarnie@google.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 05/23/2018 12:54 PM, Thomas Garnier wrote:
> Provide an option to have a PROVIDE_HIDDEN (linker script) entry for
> each weak symbol. This option solve an error in x86_64 where the linker

                                solves

> optimizes pie generate code to be non-pie because --emit-relocs was used

                generated

> instead of -pie (to reduce dynamic relocations).
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  init/Kconfig            |  7 +++++++
>  scripts/link-vmlinux.sh | 14 ++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 0fc3a58d9f2f..2866cca86b4a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1954,6 +1954,13 @@ config ASN1
>  	  inform it as to what tags are to be expected in a stream and what
>  	  functions to call on what tags.
>  
> +config WEAK_PROVIDE_HIDDEN
> +	bool
> +	help
> +	  Generate linker script PROVIDE_HIDDEN entries for all weak symbols. It
> +	  allows to prevent non-pie code being replaced by the linker if the

	                    non-PIE

> +	  emit-relocs option is used instead of pie (useful for x86_64 pie).

	                                        PIE                    PIE).

> +


-- 
~Randy
