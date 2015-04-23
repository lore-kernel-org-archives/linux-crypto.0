From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Crypto Update for 4.1
Date: Thu, 23 Apr 2015 22:10:26 +0200
Message-ID: <CAKv+Gu8s=-qyX9MAcpyd39AtBVCa-+Ly1ue1zBwam_bHqqJuvg@mail.gmail.com>
References: <20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150415033951.GA1406@gondor.apana.org.au>
	<CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
	<CA+55aFz8pr-J7K-EY5gjCV7ajJZC2tkFwjNG1xLXvQk0qAm2HA@mail.gmail.com>
	<CA+55aFwG1y6KSu-ZUMHXFnw69nRttS3LZW_pScvB6LCZjS02tA@mail.gmail.com>
	<20150416024252.GA11558@gondor.apana.org.au>
	<CA+55aFx+gm+=Xqr-wFN0Akg7=XJOtv3PDbHgVbo38p=DMv=3OQ@mail.gmail.com>
	<20150416030713.GA11668@gondor.apana.org.au>
	<CA+55aFyinAKD8E5Xj49r+5ByfPRvB4axSxJSWg6R6Zd=bDMHig@mail.gmail.com>
	<CAArOQ2Vrbm5xyWyaFNq44gxmK6m_7nxsQhxBXowE=7FrWbhHCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Bobby Powers <bobbypowers@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36739 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310AbbDWUK0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 16:10:26 -0400
Received: by iebrs15 with SMTP id rs15so69495027ieb.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2015 13:10:26 -0700 (PDT)
In-Reply-To: <CAArOQ2Vrbm5xyWyaFNq44gxmK6m_7nxsQhxBXowE=7FrWbhHCA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 23 April 2015 at 21:27, Bobby Powers <bobbypowers@gmail.com> wrote:
> Hello,
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> Ok, this patch seems to fix it for me, so I undid my revert that I
>> hadn't pushed out yet, and pushed out this instead.
>
> Commit e68410ebf62676dfb93aafff7c55b76644f37072 in Linus's tree from
> this crpyto update (crypto: x86/sha512_ssse3 - move SHA-384/512 SSSE3
> implementation to base layer) causes a GPF on boot in
> sha512_ssse3_finup for me on a Broadwell i7-5600U, rendering the
> kernel unbootable.
>
> Reverting that commit enables me to boot.  I don't know enough about
> the code to comment.  Config is attached, and I can provide a photo of
> the reported Call Trace if thats helpful.  It is quite reproducible
> for me.
>

Hello Bobby,

Would you be able to check whether the following patch fixes the crash?

diff --git a/arch/x86/crypto/sha512-avx2-asm.S
b/arch/x86/crypto/sha512-avx2-asm.S
index a4771dcd1fcf..1f20b35d8573 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -79,7 +79,7 @@ NUM_BLKS    = %rdx
 c           = %rcx
 d           = %r8
 e           = %rdx
-y3          = %rdi
+y3          = %rsi

 TBL   = %rbp

If not, please share the call trace and the content of /proc/cpuinfo

Regards,
Ard.
