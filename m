From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [lkp-robot] [x86/kconfig] 81d3871900: BUG:unable_to_handle_kernel
Date: Fri, 13 Oct 2017 16:17:45 -0400
Message-ID: <CAH8yC8=vqE_1xCmmrb_TQoVayL+rGEObpg6degbVYZuXQ1OU3w@mail.gmail.com>
References: <20171010121513.GC5445@yexl-desktop> <20171011023106.izaulhwjcoam55jt@treble>
 <20171011170120.7flnk6r77dords7a@treble> <alpine.DEB.2.20.1710121202210.28556@nuc-kabylake>
 <20171013044521.662ck56gkwaw3xog@treble> <9a1c3232-86e3-7301-23f8-50116abf37d3@virtuozzo.com>
 <CA+55aFyvK+proOBKfc41qSH8hoPU+mBiT0=hLhbt_ZQv4N82iA@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christopher Lameter <cl@linux.com>,
        kernel test robot <xiaolong.ye@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        linux-mm <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Megha Dey
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38304 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdJMURq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2017 16:17:46 -0400
In-Reply-To: <CA+55aFyvK+proOBKfc41qSH8hoPU+mBiT0=hLhbt_ZQv4N82iA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 13, 2017 at 3:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 13, 2017 at 6:56 AM, Andrey Ryabinin
> <aryabinin@virtuozzo.com> wrote:
>>
>> This could be fixed by s/vmovdqa/vmovdqu change like bellow, but maybe the right fix
>> would be to align the data properly?
>
> I suspect anything that has the SHA extensions should also do
> unaligned loads efficiently. The whole "aligned only" model is broken.
> It's just doing two loads from the state pointer, there's likely no
> point in trying to align it.

+1, good engineering.

AVX2 requires 32-byte buffer alignment in some places. It is trickier
than this use case because __BIGGEST_ALIGNMENT__ doubled, but a lot of
code still assumes 16-bytes.

Jeff
