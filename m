Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C689E414A1F
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 08:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791102843; cv=none; b=UAsZMPccZwGZE6ScnxinfcLm0g79N7NziAPinPI6NRklc2khoDfvvGi2QQGP0D4EUK5UpkXXepc6fjHJA8nhbP7EDISslhx7nge50H06YdNUeL+Wlc0qX8XmekYhSIC3V1a7W76vD9FBLNh7++mzwbuFXFldB/Cy1sblRVvrhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791102843; c=relaxed/simple;
	bh=1sBv2SI3wnHyVQDHUJVigmIehBQG6EXZHnsM+TL5srs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWh6tNneDyHbudRjKwkdpJsfOpPTjQHtS3F5d0lLnP+Go9Q237ct3k1s2uQTVVhDKk91neWAc+pssNjrFezcxoM8gkxYvyu4lvBUiTinD+s48vSYJnnitsVphsZapPNkhTtAFSCCW9BY373WahZlQ3ZOL1Eu4KL51TvvvObleNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdkAUfd2; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdkAUfd2"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-488811c9ebaso332236f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 01:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791102840; x=1791707640; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0HFDC0D77tUqEmXehAlYyAx2E0DK1wOzX1zKg1ym3bo=;
        b=NdkAUfd2+KZTf3s9hEpqKwliTej8peJLCSWDISLUjLwt09egN/aiRz2XZCkpPnIhNC
         aK2B8KkXrAsfSf5UqEl+SqvFza5LHgVUqAccsIdsuUTmlR+g8Uea5bMpAzd2qbdFBiCg
         t8fADBhEweXTv2ZNQgB7eZ1zF3dsFM6vncUf/ADRkOjyLLHTRGIDP4eOp+lBBA8JuXeu
         nBJoxu6110IVlbTfAnaegRILWMJ2WNttnECN9/fl0pH8w6q6eG9C43JEnC4p9zNrOs3x
         cGQa4jIxiwUPFj88RAfsTL3tjVtRaEeC2g1Rjy8xyoFrbRQsWvwMztVhAx2Ih1bK6nsb
         4faQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791102840; x=1791707640;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0HFDC0D77tUqEmXehAlYyAx2E0DK1wOzX1zKg1ym3bo=;
        b=z47/4IBUcAvlfQAnDb7h4tE1CCCwqsyNpb9Lwivbdp0U6rZBDb0KxPgznFFp03lAIF
         VzLWMENPUM+SeAOuWRVDXdAseAB1ptsv5DiYygUB9LN73BpTKm3CZEbB/HRWtMOAV0+i
         5RmfghO4oy0OAL/+So6Thuv4pdnKuSRn+CA2eguoR/JVR9WuW75j3DFBqEXlwW5AaRv3
         1wGHss4KTavc210a8QnVGMArOh15KW1NGzr2kNfI/6yUbNInxK7beoeYvRuGYSVv9k0E
         akf2lu4Uc3AsSn6jZTIC1Gr9INUnKUJlZTEc6w55NOjsbffKNAjKVzfINOE7xXDAbYXt
         i8pg==
X-Forwarded-Encrypted: i=1; AKwUvBwK4+B/NGwAbIJydMWuCxPdpKpfj3VPPfmtPBF9eN078Es/scvszhrSlIVw+rAYXBdxdLwEKIGlVhBpHeA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLJB/FugA1CYIXHFDQsdN1RuSPTz+or7DPBAgtnIQTkqFxazs4M
	SCV3nTLkbkEjmjOFlHWVR4yayd2K3ejFmM9Lvvs6OUafNGzbEteAJ8Je
X-Gm-Gg: AYBFou2WUKyodUk9FOcVjVTaHnwtL9AccnQIEiohUMjW/vGcbneiUM0fwp/HQfeGza6
	daU8rCrSanLwIpEpjTLShJnz+Ye68vOwuq5tPifERcHcRfxg9Nmd/8b2dFOvffMcJOegv6YsOa9
	HcDGsnaBD/RCglpcxK+Qqu+bxzFIIcgzV0p8pnEmmwSo2J2FWjOw06uK37CAu70O2BtHZIa14Zo
	F2BiiyZVGGdjBRTKZnq9YlOvwd8VpwlOo6Dj/dNZjpJ7INIMyQSBAWo7oMN9GZefWd8HHIIsGRp
	tVXeESbMH02Dj4H/ebRa7X7Aob5bjwjPmqnAChY/K2cYTT99KLU09MJNFm+7CgIPdv1KLpN//MT
	99ImXKLMH2CvVzJp2Cmnth8zTWQVTHszt2Hd6IN0h5r87TnJ3qeJMHyCZBKNOZEfeosZUrzW3zL
	vzBvCyz/C9mv1gfC4fejrhG3J+C+kXco+ZQtljPYvRlTQDqmOHS1luXzo9osHkI7su1pKwCrXBV
	88a1gnf11TaGzrLVH6iF+5Kkgyn+49vcKXAPFOloeGV2A==
X-Received: by 2002:a5d:5d0f:0:b0:488:83f7:633a with SMTP id ffacd0b85a97d-48b12736b49mr11750202f8f.28.1791102839800;
        Sun, 04 Oct 2026 01:33:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f04f8sm17350793f8f.9.2026.10.04.01.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 01:33:59 -0700 (PDT)
Date: Sun, 4 Oct 2026 09:33:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Nathan Chancellor
 <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Bill
 Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Russell
 King <linux@armlinux.org.uk>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, Nick
 Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, Phillip Lougher <phillip@squashfs.org.uk>,
 Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 1/9] lib/lz4: import upstream LZ4 sources verbatim
Message-ID: <20261004093357.33a124b4@pumpkin>
In-Reply-To: <fac0f401-bbd3-444b-a755-53cc393673de@samsung.com>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a@eucas1p1.samsung.com>
	<20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>
	<arn3TC7BgjTXWmdG@google.com>
	<fac0f401-bbd3-444b-a755-53cc393673de@samsung.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 4 Oct 2026 01:50:39 +0200
Michal Wilczynski <m.wilczynski@samsung.com> wrote:

> On 9/28/26 07:19, Sergey Senozhatsky wrote:
> > On (26/09/25 13:27), Michal Wilczynski wrote:
> > [..]  
> >> +int LZ4_compress_fast_extState(void* state, const char* source, char* dest, int inputSize, int maxOutputSize, int acceleration)
> >> +{
> >> +    LZ4_stream_t_internal* const ctx = & LZ4_initStream(state, sizeof(LZ4_stream_t)) -> internal_donotuse;
> >> +    assert(ctx != NULL);  
> > 
> > Probably in some other places as well:
> > 
> > LZ4_initStream() can return NULL, but the code immediately derefs
> > the pointer.  The assert() check seems to be misplaced, unless I'm
> > missing something.
> > 
> > I suppose those need to be decoupled.  First LZ4_initStream() call and
> > NULL check, then stream->internal_donotuse.  
> 
> Good catch, this assert() is a noop in the kernel (as any build without
> LZ4_DEBUG), so a NULL, undersized or misaligned wrkmem oopses in
> LZ4_compress_fast(), and LZ4_compress_destSize() and LZ4_resetStreamHC()
> carry on with an uninitialised state.

The assert() is also just a waste of code.
Debugging the NULL pointer dereference is just as easy.

David 
 
> 
> No in-tree caller hits it (all use kmalloc/vmalloc), and I listed the
> alignment requirement as a behaviour change in the cover letter. Still,
> the vendored files need to stay verbatim.
> 
> So in v2 our own entry points can check alignment with a WARN_ON_ONCE()
> and bail out early. It might be something that we can fix upstream as
> well.
> 
> 
> >   
> 
> Best regards,

