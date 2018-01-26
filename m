From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH RFC 0/3] API for 128-bit IO access
Date: Fri, 26 Jan 2018 12:05:42 +0300
Message-ID: <20180126090542.bsza7hqqinqwllcr@yury-thinkpad>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
 <20180124102212.GC20586@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180124102212.GC20586@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 24, 2018 at 10:22:13AM +0000, Will Deacon wrote:
> On Wed, Jan 24, 2018 at 12:05:16PM +0300, Yury Norov wrote:
> > This series adds API for 128-bit memory IO access and enables it for ARM64.
> > The original motivation for 128-bit API came from new Cavium network device
> > driver. The hardware requires 128-bit access to make things work. See
> > description in patch 3 for details.
> > 
> > Also, starting from ARMv8.4, stp and ldp instructions become atomic, and
> > API for 128-bit access would be helpful in core arm64 code.
> 
> Only for normal, cacheable memory, so they're not suitable for IO accesses
> as you're proposing here.

Hi Will,

Thanks for clarification.

Could you elaborate, do you find 128-bit read/write API useless, or
you just correct my comment?

I think that ordered uniform 128-bit access API would be helpful, even
if not atomic.

Yury.
