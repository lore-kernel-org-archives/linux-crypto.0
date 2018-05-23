From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 23/27] x86/modules: Adapt module loading for PIE support
Date: Wed, 23 May 2018 14:26:51 -0700
Message-ID: <168ebedb-7c27-d1f3-c2f9-223d44186a52@infradead.org>
References: <20180523195421.180248-1-thgarnie@google.com>
	<20180523195421.180248-24-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
	x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-sparse@vger.kernel.org, linux-crypto@vger.kernel.org,
	kernel-hardening@lists.openwall.com, xen-devel@lists.xenproject.org
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
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180523195421.180248-24-thgarnie@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

Hi,

(for several patches in this series:)
The commit message is confusing.  See below.


On 05/23/2018 12:54 PM, Thomas Garnier wrote:
> Adapt module loading to support PIE relocations. Generate dynamic GOT if
> a symbol requires it but no entry exist in the kernel GOT.

                                    exists

> 
> Position Independent Executable (PIE) support will allow to extended the

                                                will allow us to extend the

> KASLR randomization range below the -2G memory limit.

Does that say "below th negative 2G memory limit"?
I don't get it.


> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/Makefile               |   4 +
>  arch/x86/include/asm/module.h   |  11 ++
>  arch/x86/include/asm/sections.h |   4 +
>  arch/x86/kernel/module.c        | 181 +++++++++++++++++++++++++++++++-
>  arch/x86/kernel/module.lds      |   3 +
>  5 files changed, 198 insertions(+), 5 deletions(-)
>  create mode 100644 arch/x86/kernel/module.lds


Thanks,
-- 
~Randy
