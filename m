From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 21/27] x86/ftrace: Adapt function tracing for PIE
	support
Date: Wed, 14 Mar 2018 11:35:37 +0100
Message-ID: <20180314103537.GR4043@hirez.programming.kicks-ass.net>
References: <20180313205945.245105-1-thgarnie@google.com>
	<20180313205945.245105-22-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>, Michal Hocko <mhocko@suse.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Petr Mladek <pmladek@suse.com>, Len Brown <len.brown@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Christopher Li <sparse@chrisli.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>,
	kernel-hardening@lists.openwall.com,
	Christoph Lameter <cl@linux.com>, Jiri Slaby <jslaby@suse.cz>,
	Alok Kataria <akataria@vmware.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Joerg Roede
To: Thomas Garnier <thgarnie@google.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180313205945.245105-22-thgarnie@google.com>
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

On Tue, Mar 13, 2018 at 01:59:39PM -0700, Thomas Garnier wrote:
> +	/*
> +	 * If PIE is not enabled or no GOT call was found, default to the
> +	 * original approach to code modification.
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_PIE)
> +	    || probe_kernel_read(replaced, (void *)ip, sizeof(replaced))
> +	    || memcmp(replaced, got_call_preinsn, sizeof(got_call_preinsn)))
> +		return ftrace_modify_code_direct(ip, old_code, new_code);

The predominant kernel style is to place the operators at the end of the
previous line, not first on the new line.
