From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Date: Fri, 4 Jul 2014 13:50:03 +0300
Message-ID: <20140704105003.GA25934@mwanda>
References: <20140620202418.GZ5015@mwanda> <4892293.kf6KiPx6BS@myon.chronox.de>
 <20140625090646.GB8727@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>, kbuild@01.org,
 linux-kernel@vger.kernel.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20140625090646.GB8727@gondor.apana.org.au>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 25, 2014 at 05:06:46PM +0800, Herbert Xu wrote:
> On Sat, Jun 21, 2014 at 02:26:29PM +0200, Stephan Mueller wrote:
> > The handling of additional input data / personalization string data may
> > be subject to a NULL pointer deference for the CTR DRBG. The
> > caller-provided data may be NULL which must be caught by the DRBG.
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>


Oh, huh.  This bug was actually reported by me but I forgot to change
the from header and apparently my smtp server allows me to send emails
as if I work for Intel.  :P

Fengguang is much nicer than I am.  :P

> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >  crypto/drbg.c | 23 +++++++++++++----------
> >  1 file changed, 13 insertions(+), 10 deletions(-)
> > 
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index faaa2ce..8e7c302 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -513,17 +513,20 @@ static int drbg_ctr_df(struct drbg_state *drbg,
> >  	drbg_string_fill(&S2, L_N, sizeof(L_N));
> >  	drbg_string_fill(&S4, pad, padlen);
> >  	S1.next = &S2;
> > -	S2.next = addtl;
> >  
> > -	/*
> > -	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
> > -	 * input data chain
> > -	 */
> > -	tempstr = addtl;
> > -	for (; NULL != tempstr; tempstr = tempstr->next)
> > -		if (NULL == tempstr->next)
> > -			break;
> > -	tempstr->next = &S4;
> > +	if (NULL == addtl) {
> > +		S2.next = &S4;
> > +	} else {
> > +		/*
> > +		 * splice in addtl between S2 and S4 -- we place S4 at the end
> > +		 * of the input data chain
> > +		 */
> > +		S2.next = addtl;
> > +		tempstr = addtl;
> > +		while (tempstr->next)
> > +			tempstr = tempstr->next;
> > +		tempstr->next = &S4;
> 
> You've still got exactly the same NULL dereference.

I was offline for a bit so I'm coming into this late.  It's weird that
Stephan isn't defending his patch but it looks ok to me...

regards,
dan carpenter
