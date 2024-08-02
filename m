Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB2516BE11
	for <linux-crypto@vger.kernel.org>; Fri,  2 Aug 2024 16:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722617346; cv=none; b=XJbBH7iAjeOOm5r3FxAYQubrZUkctT7giRpO04NaDdwnCktP0TKrf5y3GLbFwhI4Ea1jwEUW42qICLRrYUpYQ9b4f3xH4GVv6Ztyn+47tGcoHBMgdFyBsyvYVRxfsDAhVTaT0VRbYax66JCnJHvwV1xzXOZPCcCOcqye760kC6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722617346; c=relaxed/simple;
	bh=6TDBf/95RWQkCJ0GIy6p8S8yjUhPmBkPWwc8S0r5Fh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thk5O13JC7aX0jubGUMnRPgFdo8EobNVW2oc1Tjc/5mtcoRsqMK2cCBqhyap0ZQEOY64n2j1CzT8qn4aXXfSGW3qP/pNhxOHwRIlsl1uLBCXhh3slT+QPiSiCi1sMIBi7VCP6wxEhITWS8POOEEX01IO7oM//2QOrxHAeKL8R8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEFyPMYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEFyPMYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4EAC4AF0C;
	Fri,  2 Aug 2024 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722617346;
	bh=6TDBf/95RWQkCJ0GIy6p8S8yjUhPmBkPWwc8S0r5Fh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vEFyPMYErxdDLjDr3uyIKHqevReRkAxMJC2Z3TKTFWYPWlFjVpcTj82yOmOLFSL2L
	 LEFMvhI8Nukoj+oOLrPzHjnlO0Ys2eiFxwKMox9hGoZlTfEeMnVYQTsPhx3vI0EGqj
	 o0pdeI4vrLtUduM/sr/KJ1AAXPwmrilTLhovMbcpU+xTH2zY5oGkYmdYowsS6trqN2
	 FSwf1oAO9OdZHFK8PkFc+o5mj84ZxF5b4JAWmQfSAkqw3snGzG58EDjxbPQEkXmkoJ
	 Ox00HgKEJA7PdFyfNfqqdsT9uqrh8XF1q6VD2Qy/maK3jmKcF/30CaMeaeQOruB2uc
	 l/A1t0ft/hdvw==
Date: Fri, 2 Aug 2024 09:49:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240802164904.GB1809@sol.localdomain>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802162832.GA1809@sol.localdomain>

On Fri, Aug 02, 2024 at 09:28:32AM -0700, Eric Biggers wrote:
> Hi Sebastian,
> 
> On Fri, Aug 02, 2024 at 12:23:33PM +0200, Sebastian Andrzej Siewior wrote:
> > kernel_fpu_begin() disables preemption. gcm_crypt() has a
> > skcipher_walk_done() invocation within a preempt disabled section.
> > skcipher_walk_done() can invoke kfree() which requires sleeping locks on
> > PREEMPT_RT and must not be invoked with disabled preemption.
> > 
> > Keep FPU access enabled while skcipher_walk_done() is invoked.
> > 
> > Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index cd37de5ec4046..be92e4c3f9c7f 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
> >  			aes_gcm_update(key, le_ctr, ghash_acc,
> >  				       walk.src.virt.addr, walk.dst.virt.addr,
> >  				       nbytes, flags);
> > +			kernel_fpu_end();
> >  			err = skcipher_walk_done(&walk, 0);
> > +			kernel_fpu_begin();
> >  			/*
> >  			 * The low word of the counter isn't used by the
> >  			 * finalize, so there's no need to increment it here.
> 
> Can you make this conditional on CONFIG_PREEMPT_RT so that it doesn't hurt
> performance for everyone else?
> 
> Note that kfree() lacks a might_sleep(), and its kerneldoc does not say that it
> can sleep.  Have you checked for other instances of this same problem?  It seems
> it would be quite common kernel-wide.  Is it really necessary that kfree() takes
> a sleepable lock on PREEMPT_RT?
> 

This would work too, I think:

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index cd37de5ec4046..2d6bcf7fc7c51 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1401,11 +1401,12 @@ gcm_crypt(struct aead_request *req, int flags)
 		} else {
 			/* Last segment: process all remaining data. */
 			aes_gcm_update(key, le_ctr, ghash_acc,
 				       walk.src.virt.addr, walk.dst.virt.addr,
 				       nbytes, flags);
-			err = skcipher_walk_done(&walk, 0);
+			err = 0;
+			break;
 			/*
 			 * The low word of the counter isn't used by the
 			 * finalize, so there's no need to increment it here.
 			 */
 		}
@@ -1439,10 +1440,12 @@ gcm_crypt(struct aead_request *req, int flags)
 				       datalen, tag, taglen, flags))
 			err = -EBADMSG;
 	}
 out:
 	kernel_fpu_end();
+	if (nbytes)
+		skcipher_walk_done(&walk, 0);
 	return err;
 }
