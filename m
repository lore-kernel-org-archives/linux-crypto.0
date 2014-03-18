From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] arm64/lib: add optimized implementation of sha_transform
Date: Tue, 18 Mar 2014 12:51:57 +0100
Message-ID: <201403181251.57252.marex@denx.de>
References: <1394809353-16707-1-git-send-email-ard.biesheuvel@linaro.org> <201403171918.35632.marex@denx.de> <CAKv+Gu9=SXJngmeYC9bDjgr+VF-b-Hj1jf_NWdPwNzn8z3MVKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Steve Capper <steve.capper@linaro.org>,
	Nicolas Pitre <nico@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:41706 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCRMK4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Mar 2014 08:10:56 -0400
In-Reply-To: <CAKv+Gu9=SXJngmeYC9bDjgr+VF-b-Hj1jf_NWdPwNzn8z3MVKA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, March 18, 2014 at 08:26:00 AM, Ard Biesheuvel wrote:
> On 17 March 2014 22:18, Marek Vasut <marex@denx.de> wrote:
> > On Friday, March 14, 2014 at 04:02:33 PM, Ard Biesheuvel wrote:
> >> This implementation keeps the 64 bytes of workspace in registers rather
> >> than on the stack, eliminating most of the loads and stores, and
> >> reducing the instruction count by about 25%.
> >> 
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> ---
> >> Hello all,
> >> 
> >> No performance numbers I am allowed to share, unfortunately, so if
> >> anyone else (with access to actual, representative hardware) would care
> >> to have a go, I would be very grateful.
> >> 
> >> This can be done by building the tcrypt.ko module
> >> (CONFIG_CRYPTO_TEST=m), and inserting the module using 'mode=303' as a
> >> parameter (note that the insmod always fails, but produces its test
> >> output to the kernel log). Also note that the sha_transform() function
> >> will be part of the kernel proper, so just rebuilding the sha1_generic
> >> module is not sufficient.
> >> 
> >> Cheers,
> > 
> > Won't the function sha_transform() collide with the one in lib/sha1.c ?
> > Or will the one in lib/sha1.c be overriden somehow ?
> 
> No, this works pretty well, in fact: arch/*/lib has precedence over
> lib/, and objects (declared with lib-y +=)  are only included to
> satisfy unresolved dependencies. So the second (generic) sha1.o will
> not get linked.

Thanks for clearing this !

> > Otherwise:
> > 
> > Reviewed-by: Marek Vasut <marex@denx.de>
> 
> Thanks. I did send a v2 which is actually a lot different from the
> version you reviewed, so I won't carry over your reviewed-by without
> your acknowledgement.

Thanks!

Best regards,
Marek Vasut
