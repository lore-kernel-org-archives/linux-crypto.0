From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 00/23] crypto: arm64 - play nice with CONFIG_PREEMPT
Date: Tue, 20 Mar 2018 07:36:32 +0800
Message-ID: <20180319233631.GB15897@gondor.apana.org.au>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
 <20180316155735.GJ7095@gondor.apana.org.au>
 <CAKv+Gu8jCa7dAoXHan+3zwBt2pZjD22MaCSwiAM-bXHgvVJkmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, linux-rt-users@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8jCa7dAoXHan+3zwBt2pZjD22MaCSwiAM-bXHgvVJkmQ@mail.gmail.com>
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

On Mon, Mar 19, 2018 at 11:31:24PM +0800, Ard Biesheuvel wrote:
>
> Apologies if this wasn't clear, but there are some cross dependencies
> with the arm64 tree, which receives non-trivial modifications in
> patches 10 and 11, which are subsequently depended upon by patches 12
> - 23.
> 
> Without acks from them, we should really not be merging this code yet,
> especially because I noticed a rebase issue in patch #10 (my bad).
> 
> Would you mind reverting 10 - 22? I will revisit this asap, and try to
> get acks for the arm64 patches. If that means waiting for the next
> cycle, so be it.

Sure it's done now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
