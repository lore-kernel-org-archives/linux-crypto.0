From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 4.1
Date: Wed, 15 Apr 2015 20:34:59 -0700
Message-ID: <CA+55aFyinAKD8E5Xj49r+5ByfPRvB4axSxJSWg6R6Zd=bDMHig@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150416030713.GA11668@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 15, 2015 at 8:07 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Thanks! It actually appears to be a very simple bug that I somehow
> missed during reviewing.

Ok, this patch seems to fix it for me, so I undid my revert that I
hadn't pushed out yet, and pushed out this instead.

Thanks,

            Linus
