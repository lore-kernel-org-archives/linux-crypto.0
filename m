Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793331146;
	b=UaNUDmZTzRnr7umaJEtOTfFXljC+WPecJiypcItOdKeExYIFvJp4MWpGRmufmebcgmag
	 hN1BJ3cKs1sdGTqpTbefQUwA7YdH6VkjM3NXP/HwHnDOOpq6aOFecPgR0/Hh88+jjs/Tw
	 CEqys6BGNabphfHXvgrcMO9vpU3DKC7Z5046omonGnvG+mtu/XpvPn6Mt+joyVDhp34xP
	 Fa8qjoQKgJ3ilDS7s0De/Ur3AwLmL9b4O8OtwXsWIrzMzYog9MFwhOo29RRMg34o2ibhn
	 dHW4KxgLcC8yqeBYyTAs2huhvjjeqPZySSakIiW8ajnYoLkP2OjZ09XIZ025WGLHCqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793331146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xPP2Iq+jG/OXOp1muTW4wEvJS9Nxy1yt91NNhV76NRc=;
	b=0efJFJlGr5HyV9NikECw/hgYaH3Y9cnGik1MzftzoUue4FHHJA703TckoOSfCkutw8hh
	 lgzi1pofZG0tKMtIflZpt+I28A02vmQ0k6zUVT6up42e+pBDbHIrERtubWlnt9Clr2rXv
	 oVH5TGCeTrQu9Qqkz2o2ITdMPWb1mDd0gujgU+zij/E7Xc5uMj+GXGFEWo3bOVHJiZN+Z
	 G6/9Y8ezUYN5YTnUvtQwrXH4U7FPqBGjtBiHqrIvteRfmvIp+JG6nF88+yPMQgD8NvSV0
	 9qAlxvUirqWGQdWV/x7pEQEdTTBEfDGPUffWAUt52KOVg8mSkRLhe0oYHTvOHpqyWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hY7WxPts;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765D7606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 03:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 765D7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hY7WxPts
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso665137eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 20:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793331145; x=1793935945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xPP2Iq+jG/OXOp1muTW4wEvJS9Nxy1yt91NNhV76NRc=;
        b=hY7WxPtsWjkTqkdfESwA+2iZqA2DIbhW2bMUHDGRQcQrxl104W+MLpIWNI8Iqaca2c
         qudjtjfNRzj9z43m2QXk1oawndAx6xZ1J+Khsf/PpCfynqpKT5I2XacIqiyIl0P/EfSG
         pITmubLtXFOxycCGUP0tyh9c1nFVPKE8jvL9l0SMfD599Wxq5TafvsVb8EnNvMrIe3ae
         Q1ccW1Dpq5gRAIAp8HqXvO7FLnlg48LFjFSxowOMjNa9nu3CnwU2mlNNQjH1HXX35tQd
         gmhUg49Ht+rTCJfEzJTrN2Y0KKZ79NCeRsHBkkf0ra/GZ9Asdmmno6dcl/pTDqxeNz6X
         MEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793331145; x=1793935945;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xPP2Iq+jG/OXOp1muTW4wEvJS9Nxy1yt91NNhV76NRc=;
        b=zWDmPw6Dm0xXg4PuNhasBxNZharIyP20A2I9obx/sqagVRD1dPVF5Apj1zB6WccDH0
         CAJDu7n8HBxRaA7z+xo3Clq++EAioR9kGSGV8HMzQBjtx9ympASIqnO9NOVtjbMgJ65y
         bRqvj9/Ot7yDExkAkL1K5i2VtZunO9BiE9NQDlMun153anZUERlN81cmLs6/Pxwsdir+
         Ut3XaJGS/Zl2/JRa7UU2esbxzZYtOBlnJ7+3Fs9sFUUjDvBW4TRoVjuqNFLIOlcP0+Fv
         FhSFTuLU/JN76SLHXP1ZjeC4N5XrUpiIso+PLcu9LXqmDChaca5Vp6W1v3W11uFkUB13
         kfvQ==
X-Forwarded-Encrypted: i=1; AKwUvBytK3wP9zpiBjPU6CToKsGjZVe8dgd2dKRbP408sD2R15nJUnMtd0839/WV8u2rw4nxRfPDnUvFo+q3/Gs=@vger.kernel.org
X-Gm-Message-State: AFq9FYI8m6DptiRYvSEUFrYnFN6TYfnMfibxvwVxPC0NlCVIDiMn6lVy
	17l/GSYGC6vEt5WwlXr65I87QCEQVab9aWQkCzOn3wrR11HhukcNU0vW
X-Gm-Gg: AYBFou0c7JK8e8++hi980J5O4QN7aP1utcg6/rN3P56ydflwSPSyf01UfbnrpxpbE65
	eWbRDeARJ5co8ZIYap8U/9jp1MnbR1r8h8njtxrAI7ghacBHk5m8QTfTC9T2nMO6x7k/6AdLxRR
	sHk4ilwnaQ6MV+BfdR6+CMKa57DV6FbUSBwM/zSStMwSz8YkfIhe7OoPb4oU0JlSKQbuk6IKGjs
	qpRwHl6227nvf/m6S06iBnloPbfszv2bBkER9DkEQ81lLa4FtqOhVzF6UH/XE0f+W+0TLn6PtBi
	Xku9I8qxLHUjwUcV83GzvXqwXmwZ2mBhp9j+2G7ATFPu3aCDR4GioR9ajz+7ZXxZzVFmX3Pobhu
	A44Grq6d3PzgAtv95Op0XTSDqyqMFIpNiJn4McfH+xFNa8ZjOcJsry+Zy63QqrGzhwNhTswnQDS
	d/7YEFL9WKKG4YO0RXpzhrLep+nk4fs3MC4U13FPlwDTx+4PlVFbG4pXbvB5crGTyDg4hSbdFRs
	6+OkTEpsdDhRUKsAVys8g7X9+aQp0qfQeBcWC3nE1G5gKaKDFWDW1RPGe2CYGj+BOazpip+sA4M
	yuM8LXIvJR/4d8lmkEawYVUgFCIJeOHNUY+pHEEJxFdPsNi1uw==
X-Received: by 2002:a05:7022:121a:b0:1a9:cad6:5b58 with SMTP id a92af1059eb24-1ac5ffe5b8fmr1322800c88.39.1793331145164;
        Thu, 29 Oct 2026 20:32:25 -0700 (PDT)
Received: from kernel ([103.219.206.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b0a628bsm2767972c88.22.2026.10.29.20.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 20:32:24 -0700 (PDT)
Date: Fri, 30 Oct 2026 09:02:19 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, ardb@kernel.org,
	Jason@zx2c4.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: aes: use memzero_explicit() instead of
 memset()
Message-ID: <auQPw4dFFZM6XPV4@kernel>
References: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
 <20261028155134.GA4041913@google.com>
 <20261028205633.7625d789@pumpkin>
 <20261029173119.GE1862@quark>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029173119.GE1862@quark>

On Thu, Oct 29, 2026 at 10:31:19AM -0700, Eric Biggers wrote:
> On Wed, Oct 28, 2026 at 08:56:33PM +0000, David Laight wrote:
> > On Wed, 28 Oct 2026 15:51:34 +0000
> > Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > > On Wed, Oct 28, 2026 at 07:56:36PM +0530, Mohamad Raizudeen wrote:
> > > > aes_gcm_decrypt() and aes_ccm_decrypt() use plain memset() to wipe the
> > > > output buffer when authentication fails. But the compiler can optimize
> > > > that wipe away, so use memzero_explicit() instead of memset().
> > > > 
> > > > This matches every other sensitive wipes in this file, which already
> > > > uses memzero_explicit() for keystream blocks, tmp buffers, ctx
> > > > teardowns.
> > > > 
> > > > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > > > ---
> > > >  lib/crypto/aes.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> > > > index e1c191551736..7814ef525239 100644
> > > > --- a/lib/crypto/aes.c
> > > > +++ b/lib/crypto/aes.c
> > > > @@ -1733,7 +1733,7 @@ int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
> > > >  		 * Clear the inauthentic decrypted data so that callers won't
> > > >  		 * receive it even if they fail to correctly handle errors.
> > > >  		 */
> > > > -		memset(dst, 0, data_len);
> > > > +		memzero_explicit(dst, data_len);  
> > > 
> > > This isn't for "zeroization" (making the data unavailable in ramdumps),
> > > though.  It's just so the caller doesn't accidentally use the
> > > inauthentic data, as the comment right above it states.
> > 
> > It is also a parameter so has to be zeroed anyway.
> > memzero_explicit() is used to clear on-stack buffers.
> 
> Well, that assumes link-time optimization is not done.  The kernel
> supports being built with link-time optimization.
> 
> I guess the motivation for this patch would be:
> 
>     (1) Shut up LLMs that think the use of memset() is inconsistent
> 
>     (2) Maybe the caller really does want "zeroization" for the dst
>         buffer, even on failure -- and this guarantees it for them, even
>         if LTO is enabled, without having to do it themselves.  (Though
>         on success, they'll have to do it anyway.)
> 
> So I'm tempted to apply this patch anyway.
> 
> But the zeroization stuff is getting kind of annoying at this point,
> when it's unreliable anyway (it's not like we zero out the registers,
> which can then be spilled to the stack and/or written to the task_struct
> on context switch) and can even be counterproductive (by forcing data to
> be written to memory so that memset() can run on it, instead of kept
> entirely in registers).  And Sashiko likes to flag them as Critical
> issues, which is not at all accurate.
> 
> - Eric


You are right, the confusion was caused by my commit message. I said the
compiler would optimize that wipe away without mentioneing LTO, which is
the key qualifier. That only holds under LTO, which I should have called
out. Yes the comment above the memset() makes clear this is defensive,
not zeroization in the rampdump sense. Without LTO th caller is opaque
so the store survives it, but with LTO the compiler can potentially
eldie it... memzero_explicit() prevents that.

Should I send a v2 with just the commit message updated with LTO?
