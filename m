From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [lkp-robot] [x86/kconfig] 81d3871900: BUG:unable_to_handle_kernel
Date: Fri, 13 Oct 2017 12:09:23 -0700
Message-ID: <CA+55aFyvK+proOBKfc41qSH8hoPU+mBiT0=hLhbt_ZQv4N82iA@mail.gmail.com>
References: <20171010121513.GC5445@yexl-desktop> <20171011023106.izaulhwjcoam55jt@treble>
 <20171011170120.7flnk6r77dords7a@treble> <alpine.DEB.2.20.1710121202210.28556@nuc-kabylake>
 <20171013044521.662ck56gkwaw3xog@treble> <9a1c3232-86e3-7301-23f8-50116abf37d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Christopher Lameter <cl@linux.com>,
	kernel test robot <xiaolong.ye@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
	Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>,
	Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
	linux-mm <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, Megha Dey <megha.dey@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <9a1c3232-86e3-7301-23f8-50116abf37d3@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 13, 2017 at 6:56 AM, Andrey Ryabinin
<aryabinin@virtuozzo.com> wrote:
>
> This could be fixed by s/vmovdqa/vmovdqu change like bellow, but maybe the right fix
> would be to align the data properly?

I suspect anything that has the SHA extensions should also do
unaligned loads efficiently. The whole "aligned only" model is broken.
It's just doing two loads from the state pointer, there's likely no
point in trying to align it.

So your patch looks fine, but maybe somebody could add the required
alignment to the sha256 context allocation (which I don't know where
it is).

But yeah, that other SLOB panic looks unrelated to this.

                   Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
