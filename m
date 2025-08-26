Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828EE2D8767;
	Tue, 26 Aug 2025 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756227519; cv=none; b=V3tJOtlVKrwZLMwsuhFDwyXbaGy37OlytpiP3x8ceDjIMkawI/VBRVN2am9QusKUhV3PYao5pK7avpMf2MK8caMihGa+OhTOpx/Kil3Z81tAoIq33qZUsgBLzddaca7R4bz/oVSHGWAaIUYI1Dh4Y2ocIiNhY5RFfwhdfLitIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756227519; c=relaxed/simple;
	bh=BCi/bDs3/YCFJu7JKF6xbxRdVINcPUOiF6PfpYoo3Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdJBjOSINQEIb7JjYNXkxGUHivzCCsi+BrSns+1g/y49Sp8rTpGkAOBfyXxsYXil1Zs/tJaCMKbO2Hs9VAG8Y4FI70kCaRlvhA48UkvibedUQaP1rbI08RKqKc4VOQ+hGwVze/NBSkCAU06sYAwg+AfZGf9YdrUmN66Thn/dTbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcaZtTKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcaZtTKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E7AC4CEF1;
	Tue, 26 Aug 2025 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756227519;
	bh=BCi/bDs3/YCFJu7JKF6xbxRdVINcPUOiF6PfpYoo3Kc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lcaZtTKlvd+rH0YmxXpUsOqb2FHT4S+VqK7A+JRcg0NOuuMPMD9ru1iOWK7F1lN4q
	 HSXIot3leqwWkGm2kzisIgDT72O66LO3VEYA72Sn6rMkVTcWrqnNk8N240p+h5zbDa
	 VrS+Vlq3OAF7AyolEklqw3CN+EUo7T1ogOlq9g4t5JiU5rnfITrPZ+VD+1uG9nSAdy
	 SdTUv6IMGnDx+SetP8TXeCVGhOaApiEvTCEuQ9Oy0i1SFUWCJMnhCP3ive0L0USyFm
	 g+qBx2pg6zL4qUcpKyVuyRRLibrIYaVO18CTZD2R7xf7WCpcPtYnIxoIUvjkJssjlj
	 dioOfcbj9cY0g==
Date: Tue, 26 Aug 2025 09:58:36 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Edward Adam Davis <eadavis@qq.com>,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] crypto: Prevent kernel-infoleak in rng_recvmsg
Message-ID: <202508260957.6D8C43E2@keescook>
References: <6895b041.050a0220.7f033.0058.GAE@google.com>
 <tencent_B406618996EEF22ED6CC8EA7DF46FD92D206@qq.com>
 <aKBMjQpA9P70EA0z@gondor.apana.org.au>
 <CAMj1kXF4aRL02CKnO5T9kKnvSV=BcMDiD=mDW7CKQx5t_HmaHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF4aRL02CKnO5T9kKnvSV=BcMDiD=mDW7CKQx5t_HmaHw@mail.gmail.com>

On Tue, Aug 26, 2025 at 03:51:04PM +0200, Ard Biesheuvel wrote:
> (cc Kees)
> 
> On Sat, 16 Aug 2025 at 11:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Sat, Aug 09, 2025 at 05:59:43PM +0800, Edward Adam Davis wrote:
> > > Initialize the intermediary array member to 0 to prevent the kernel from
> > > leaking uninitialized data to user space.
> > >
> > > Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
> > > Tested-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > ---
> > >  crypto/jitterentropy-kcapi.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> > > index c24d4ff2b4a8..9e9e069f55af 100644
> > > --- a/crypto/jitterentropy-kcapi.c
> > > +++ b/crypto/jitterentropy-kcapi.c
> > > @@ -107,7 +107,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
> > >  {
> > >       struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
> > >       SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
> > > -     u8 intermediary[SHA3_256_DIGEST_SIZE];
> > > +     u8 intermediary[SHA3_256_DIGEST_SIZE] = { 0 };
> >
> > This is not a leak! The stack memroy is hashed and fed into the
> > entropy pool.
> 
> Is there still a point to doing this now that the compiler
> zero-initializes automatic variables? Or does that not apply to u8
> arrays? (asking Kees)

Wait, the jitterentropy _depends_ on "uninitialized" stack contents?
That is not a safe way to get entropy (especially since the stack
contents are likely predictable). But regardless, yes, arrays would be
fully wiped by zero-initialized automatic variables.

To force it to be uninit, use __uninitialized.

-- 
Kees Cook
