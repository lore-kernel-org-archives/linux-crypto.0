From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] crypto: arm64 - disable NEON across scatterwalk API
 calls
Date: Sat, 2 Dec 2017 14:54:07 +0100
Message-ID: <20171202135407.GU3326@worktop>
References: <20171201211927.24653-1-ard.biesheuvel@linaro.org>
 <20171202090107.GT3326@worktop>
 <CAKv+Gu-dG0Zc35NZZ85U36K2TXCpN+wJTYOyjkhxRjXbdiJTAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Dave Martin <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 linux-rt-users@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-dG0Zc35NZZ85U36K2TXCpN+wJTYOyjkhxRjXbdiJTAQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Dec 02, 2017 at 09:11:46AM +0000, Ard Biesheuvel wrote:
> On 2 December 2017 at 09:01, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Dec 01, 2017 at 09:19:22PM +0000, Ard Biesheuvel wrote:
> >> Note that the remaining crypto drivers simply operate on fixed buffers, so
> >> while the RT crowd may still feel the need to disable those (and the ones
> >> below as well, perhaps), they don't call back into the crypto layer like
> >> the ones updated by this series, and so there's no room for improvement
> >> there AFAICT.
> >
> > Do these other drivers process all the blocks fed to them in one go
> > under a single NEON section, or do they do a single fixed block per
> > NEON invocation?
> 
> They consume the entire input in a single go, yes. But making it more
> granular than that is going to hurt performance, unless we introduce
> some kind of kernel_neon_yield(), which does a end+begin but only if
> the task is being scheduled out.

A little something like this:

https://lkml.kernel.org/r/20171201113235.6tmkwtov5cg2locv@hirez.programming.kicks-ass.net

> For example, the SHA256 keeps 256 bytes of round constants in NEON
> registers, and reloading those from memory for each 64 byte block of
> input is going to be noticeable. The same applies to the AES code
> (although the numbers are slightly different)

Quite. We could augment the above function with a return value that says
if we actually did a end/begin and registers were clobbered.
