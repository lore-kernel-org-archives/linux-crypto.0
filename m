From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: add output feedback mode
Date: Fri, 5 Oct 2018 10:31:38 +0800
Message-ID: <20181005023138.dg22cn4salb3p6zl@gondor.apana.org.au>
References: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
 <1537449521-16182-3-git-send-email-gilad@benyossef.com>
 <CAKv+Gu9T7Z2oV8TEaN8uVdrFxGmmCKLh6ZjDnRnhgCmLwuVf4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>, ofir.drang@arm.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9T7Z2oV8TEaN8uVdrFxGmmCKLh6ZjDnRnhgCmLwuVf4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 28, 2018 at 12:06:29PM +0200, Ard Biesheuvel wrote:
> On 20 September 2018 at 15:18, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > Add a generic version of output feedback mode. We already have support of
> > several hardware based transformations of this mode and the needed test
> > vectors but we somehow missed adding a generic software one. Fix this now.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> 
> I couldn't find any users of OFB in the kernel. Any idea who is using
> it and for what?

Yes this shouldn't have been accepted however the driver did go
in with OFB and it's been there for a while so that's why I'm
making this exception.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
