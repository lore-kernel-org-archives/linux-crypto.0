From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Date: Sat, 05 Jul 2014 02:00:15 +0200
Message-ID: <3313472.TGNVD1jVhQ@myon.chronox.de>
References: <20140620202418.GZ5015@mwanda> <20140625090646.GB8727@gondor.apana.org.au> <20140704105003.GA25934@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140704105003.GA25934@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 4. Juli 2014, 13:50:03 schrieb Dan Carpenter:

Hi Dan,

> On Wed, Jun 25, 2014 at 05:06:46PM +0800, Herbert Xu wrote:
> > On Sat, Jun 21, 2014 at 02:26:29PM +0200, Stephan Mueller wrote:
> > > The handling of additional input data / personalization string data may
> > > be subject to a NULL pointer deference for the CTR DRBG. The
> > > caller-provided data may be NULL which must be caught by the DRBG.
> > > 
> > > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> 
> Oh, huh.  This bug was actually reported by me but I forgot to change
> the from header and apparently my smtp server allows me to send emails
> as if I work for Intel.  :P
> 
> Fengguang is much nicer than I am.  :P

Too late, your colleague's name is now in the patches ;-)
> 
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > > ---
> > > 
> > >  crypto/drbg.c | 23 +++++++++++++----------
> > >  1 file changed, 13 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > > index faaa2ce..8e7c302 100644
> > > --- a/crypto/drbg.c
> > > +++ b/crypto/drbg.c
> > > @@ -513,17 +513,20 @@ static int drbg_ctr_df(struct drbg_state *drbg,
> > > 
> > >  	drbg_string_fill(&S2, L_N, sizeof(L_N));
> > >  	drbg_string_fill(&S4, pad, padlen);
> > >  	S1.next = &S2;
> > > 
> > > -	S2.next = addtl;
> > > 
> > > -	/*
> > > -	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
> > > -	 * input data chain
> > > -	 */
> > > -	tempstr = addtl;
> > > -	for (; NULL != tempstr; tempstr = tempstr->next)
> > > -		if (NULL == tempstr->next)
> > > -			break;
> > > -	tempstr->next = &S4;
> > > +	if (NULL == addtl) {
> > > +		S2.next = &S4;
> > > +	} else {
> > > +		/*
> > > +		 * splice in addtl between S2 and S4 -- we place S4 at the end
> > > +		 * of the input data chain
> > > +		 */
> > > +		S2.next = addtl;
> > > +		tempstr = addtl;
> > > +		while (tempstr->next)
> > > +			tempstr = tempstr->next;
> > > +		tempstr->next = &S4;
> > 
> > You've still got exactly the same NULL dereference.
> 
> I was offline for a bit so I'm coming into this late.  It's weird that
> Stephan isn't defending his patch but it looks ok to me...

It has been clarified in a later email that there was no NULL pointer after 
all. I erroneously sent this message and initially missed the check that 
guards against the NULL pointer.
> 
> regards,
> dan carpenter


-- 
Ciao
Stephan
