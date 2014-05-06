From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Date: Tue, 6 May 2014 23:11:28 +0200
Message-ID: <20140506211128.GA13218@amd.pavel.ucw.cz>
References: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com>
 <20140506082846.GB20931@xo-6d-61-c0.localdomain>
 <CAAFXRd3UPRU7AgZCGbxo_YW_PGuO-FPvB4VC5zKb+LuqGxFxkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>,
	linux-coverity@vger.kernel.org
To: Milos Vyletel <milos.vyletel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAFXRd3UPRU7AgZCGbxo_YW_PGuO-FPvB4VC5zKb+LuqGxFxkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> Most likely yes but I wanted to keep sha1_ssse3_mod_init consistent
> with sha256_ssse3_mod_init/sha512_ssse3_mod_init functions.


> > > Reported-by: <scan-admin@coverity.com>
> > > Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>
> > > ---
> > >  arch/x86/crypto/sha1_ssse3_glue.c | 22 ++++++++++++----------
> > >  1 file changed, 12 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/x86/crypto/sha1_ssse3_glue.c
> > b/arch/x86/crypto/sha1_ssse3_glue.c
> > > index 74d16ef..5352196 100644
> > > --- a/arch/x86/crypto/sha1_ssse3_glue.c
> > > +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> > > @@ -235,31 +235,33 @@ static bool __init avx2_usable(void)
> > >
> > >  static int __init sha1_ssse3_mod_init(void)
> > >  {
> > > -     char *algo_name;
> > > -
> >
> > Would simple "algo_name = NULL" be enough to fix this?

Dunno. I'd say that single-line change that is obviously right is
preferable to rewrite inspired by some other function.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
