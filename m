Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377895;
	b=AWR0FBb0boPmse0XXyR4hw6o5HCSvSvw0Lw5EpyqK4BK45W6S03vhndn1NdAw6P9kmi7
	 PWgJfSBHShO3IIgnDGpOHItqC4kik1pUqwqqtDXvRrKAFHg5SsjHWqNxfQMxyuvGGVz/u
	 iAc/t/hDA/tcWcRoinPccXSsaZgHNgfe1E5oHOex4qymN+0oGrQdGqzThMrPdBRKpsuK1
	 xtDq1FycS4e6BIuOjDHH2SlbPLqJ+KfYvmQWMnc/ojrVDb1k8C+EUu2MUftEmsSx0Qz+I
	 1t0auX7JtXvCUiEg1swKq38EVUQlvujGz5GMxrM7e0HVHpty1Wx5THXVgYaX7RDm5Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377895;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1gGF1mtAr/lwTqIAotY13/mj9rw+PP7UFZyG/jdv9hY=;
	b=F2MgeuY6SDXeiedzZsSgxYQzVy8geY3TAeGX26gxfQ3dAnh9MRy1XpRMcXTkNbtocFX+
	 MbWvL2OWBKQMn6gYvNlZpcWNzDg4yFpw5tJ6M+rBU5bBMAE19q8CvMJZGDj1wvHqP0yiU
	 R4rliHuo8JCkY5dUhwp/E/9kHdVg0lwe9J47bvWJs2fT1gNTT4DcKIG5hw/qWr9F/lFU4
	 3EZ8lh00Fa/L8fSuKhCPhdHkF/sSE0xwMmxcq1yRkxQDXsVRnB+/uDthqxrkLuE6JImj7
	 Sysn/xBHX3jHGj4zFmqmCgdDG+oWLeXlSOI8OUYvyA/VtCKN8+CJjHAWuNCK5ILv8Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hdprGwCS;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23280606A31F
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 16:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23280606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hdprGwCS
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso9934635e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 09:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793377893; x=1793982693; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1gGF1mtAr/lwTqIAotY13/mj9rw+PP7UFZyG/jdv9hY=;
        b=hdprGwCSzXf7PRKQ/V5wvfaVkpaM2GmUVffQo54E2zGDxNlDOBku6jVRQrBvOEGPw6
         os5QkDVc5h5REpSPb+OJH/0yxAl9ymggDnYFOn4pUmDwgvn+kjTlv6nTaErQzZHXHGfO
         NvfrNDuU6i/W9D9XQ68WspWENQMBFPh0poo7f9kjoV40fMjuWt1VGQQ3V5CH4uaNdp99
         BDf+G0piQkL8K2u8K5xFRHm28dB1YLroHCLaoW1zvMgSirm0rIfjWpzEKUGrkw4QIusM
         Q7OXVBfjO2rFU0sg1y78nmoid9RwPqeLOMbm/jBjxhqkgsQFkMrokIb0SzzO9BIjLOzV
         XS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793377893; x=1793982693;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1gGF1mtAr/lwTqIAotY13/mj9rw+PP7UFZyG/jdv9hY=;
        b=gsdmNIhm+nfber9XYpBJIfZDWzwDqDzS87tp8cbgUuAUsshFV76f0LZPkBFofVVIX+
         ZWGsHZ9gcKuFn+JO9ytvIMhcYPnXq1e00JrfqtiB7ieFZvDtUNUUM0qADosTt7X+voGt
         ZVF03OolcW/xP/JwMmbORp61/gx/X/DIjLUB1yVRsXqCaH8vOGpcZ89aVKJpeQNXBza+
         uYagmhZYMQealTe08jbcHJYu0GzB5c/Iw2mSVW0YSzWn+F7/L1+Czf++P8q/pHxQ9mgS
         0lK5aMutMLMIP8/vEJGMQmsCHQXUkB9L39xyzuFCI0sn0LFNqUp00BoCOtEYb2H58JmA
         BruA==
X-Forwarded-Encrypted: i=1; AKwUvBwpE0psbdmrL1CQ2TFZyb7sr7vJxPB/iEXMYIUswl0UEfmaoFAowAuqslYhibpt+WsgbCRr72ON9k6oVtM=@vger.kernel.org
X-Gm-Message-State: AFq9FYJt4uPGF2jbVO5h4ydGMinogOZmcC1a2NKRx9SECCa1cv1OBePe
	Znosk+ebsdCpClOqofEPDroWlC/3Xn884lr/vLiKr0l3ZkV5ONu1aodJ
X-Gm-Gg: AYBFou0nd+0k1Apexh+X2KUQ1cnylOBGb0qHwQ7BH/8gJWUBY2UUHq8wX8JRkZZHvsS
	a4AeZv4J7TMhdn7UumCb7g5BqAKG7YdmrkqsuMVgfDMBFgV4Mzvd+4u/rO7khBq+zTwC5HFpNS3
	becNU+cxZ2l2FooPBNhJUOufHTtL912zJMjWJh3waiAWR0m0Jeb+iKgu94HuCGG1tvNeWDW31VC
	m8zQdbIIocMh7d4f/H8z69Mynk1h6Ay72A4wQdsICJP4ex55+9ZZIUh1vrIuoCsJH7WGjOH0daU
	a2RsNCj+Ftzd1sMmQFWs73RYMTsGav/SlqWPXH+OrSl99ffaiUYoWY4sv3/TEpE5dBiiaw6IzSg
	limAMAla9ZPxoxttV4kLFVFvB+6CbpAf2rthfx7e/OPPentZv5pTMMihr9l/wysdr5Q/6cvW7TS
	+p0liEwQ9mMGTMrgP5tPVXuWXACusHScTY/4nf8XY4parrVCfVKiWWdMen3o6dPWjuOCJXOKCDx
	7gRFOH7mKh2fy+eh20fMMXVcvdfaKy5ut64DMkmTAj1vIGb3cZqJupf9CXfhHQrK9J2rJZvW9/C
	dETvnLForoBa4PZ2NiGyUsMh5Ua0xDhrMMxEOD9/uYZKPP2b3D9GchNqxYTbAZGDww==
X-Received: by 2002:a05:600c:1c0f:b0:4a2:150f:1601 with SMTP id 5b1f17b1804b1-4ac1709a7bdmr62699895e9.12.1793377893396;
        Fri, 30 Oct 2026 09:31:33 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d4f9sm4141958f8f.2.2026.10.30.09.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:31:32 -0700 (PDT)
Date: Fri, 30 Oct 2026 16:31:31 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, ardb@kernel.org,
 Jason@zx2c4.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: aes: use memzero_explicit() instead of
 memset()
Message-ID: <20261030163131.21d8f0ff@pumpkin>
In-Reply-To: <20261029173119.GE1862@quark>
References: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
	<20261028155134.GA4041913@google.com>
	<20261028205633.7625d789@pumpkin>
	<20261029173119.GE1862@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Oct 2026 10:31:19 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

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

OTOH, if someone does a memset() then maybe the compiler should never
throw it away?

David

> 
> - Eric
> 

