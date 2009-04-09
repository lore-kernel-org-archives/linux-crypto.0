From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] add self-tests for rfc4309(ccm(aes))
Date: Thu, 9 Apr 2009 15:16:53 -0400
Message-ID: <200904091516.57048.jarod@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <20090409185204.GA6758@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert.xu@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933109AbZDITR6@vger.kernel.org>
In-Reply-To: <20090409185204.GA6758@hmsreliant.think-freely.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 09 April 2009 14:52:04 Neil Horman wrote:
> On Thu, Apr 09, 2009 at 02:34:59PM -0400, Jarod Wilson wrote:
> > Patch is against current cryptodev-2.6 tree, successfully tested via
> > 'modprobe tcrypt type=45'. The number of test vectors might be a bit
> > excessive, but I tried to hit a wide range of combinations of varying
> > key sizes, associate data lengths, input lengths and pass/fail.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > 
> >  
> ><snip>
> 
> > +/*
> > + * rfc4309 says section 8 contains test vectors, only, it doesn't, and NIST
> > + * Special Publication 800-38C's test vectors use nonce lengths our rfc4309
> > + * implementation doesn't support. The following are taken from fips cavs
> > + * fax files on hand at Red Hat.
> > + *
> > + * nb: actual key lengths are (klen - 3), the last 3 bytes are actually
> > + * part of the nonce which combine w/the iv, but need to be input this way.
> > + */
> 
> RFC4309 section 8 actually says the test vectors you can use are here:
> http://www.ietf.org/rfc/rfc3610.txt
> in RFC3610 section 8.

Oh, I'm dense, didn't correctly parse that 4309 was referring back to 3610
for the actual test vectors. I'll see what I can do with those...

> I don't think theres anything wrong with the vectors
> your're using below, but you may want to add the vectors from 3610 just to
> imrpove the testing.

I think I'd drop some of the ones in the initial patch in favor of adding
some from 3610, rather than simply adding more. The coverage is already
pretty good, increasing the number of vectors shouldn't really be necessary,
but it would definitely be nice to have vectors that are already publicly
published and verified.

-- 
Jarod Wilson
jarod@redhat.com
