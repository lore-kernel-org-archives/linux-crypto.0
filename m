Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601319;
	b=cV0tJ7nHWJfUmnUWkABM7O+EuUXi8O07V3NfrxhbeUO/itA72006Ez4smq9GDP46r1t7
	 DcRI13uY/Ug187/q/SLteSvZ0gijDKT2onl9rhZfMqYAnvfbYanmqSCV7rwWSd7HOte7T
	 jlrfzfSgwGqDPwwYW+NuZUWIQb0VMBBTYLavtjg53kH/QHIOBiBG7q8k9MRExs7SC0LLA
	 4u/fHa2nmABV7HfEo3HO2PHDYiOBVC7Z4XyfjemIaY0R1du8i3oinijfbk3aVCaAq8CfM
	 +Mla10Ecc7UoEUCtLRSj/RCYUBZrKQ+4W78+ZKJcjd1V1EF2l3IT/JJMV5i9O/8MSZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601319;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zVLDLaiDGk345YdSTyqFZM9TsxpOXFLIN/jyVIKs6D0=;
	b=STMXhBQCP/GZM9SVpxaU8dpmpslLKLYAvqqDFsZiQPIJJ7ODNFCGQmvdyPajnChmJ+fq
	 NM4sTKX+VSAJ2j+wK0Sq5RU6EIHw3GZbvqddmVGnURcuUJYqhh8Vd5CXdXMEBExC5/Cpz
	 UpTQlHdSlnLJvwVRWjWGD1Mvle3W3NARPUEVeRT/JZlD8D3OWwhpJaVO/uOn9ynAiYyES
	 cVYWRE5T4AE+mum9VElSgA3x/0civvFH131sOYHheSdWN7cD+xhvxVqVVkRqcNft4fVRo
	 a3h9vAbGZmIaLJ+Jyde+uGbNipjamBLLO23Qu4BwJl4i6UFCCiqvYXqCH2h3252l1vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCehtQnh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF0E606A31E;
	Wed, 21 Oct 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCehtQnh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CFA1F000C2;
	Wed, 21 Oct 2026 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792601318;
	bh=zVLDLaiDGk345YdSTyqFZM9TsxpOXFLIN/jyVIKs6D0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JCehtQnhQDIB6dZZvhss7tsmA6idgFTrh5d/bcgbbeUSfP4Kmq0NhuTgr9uojw+zA
	 2VlNyuTKa4IM50s5b5F3qhuZHqVA+X5ACZc3YShxq/HRBX7OXXuEecderGORLeFgBS
	 /vO5t+EDB1djcD0BU6R/AmsRW2I1mQ8zbanCbskLuaWN3FlPVPoD1s3/+KHR6K9QFF
	 B/7CCupbDAH4QNOoyENYDfFuCg0WTBu0CtEqsbSisgHTAxI/Pj8bmNQ5x1AKZJmNR6
	 rsLtvauzI7ohOjVzf60edUPPSUoEONSC30WiDV68Qlq3Metwisw6d4fyrp7KILQAD5
	 MzY1HnAVPQpwg==
Date: Wed, 21 Oct 2026 09:48:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Jeremy.Jean@oss.cyber.gouv.fr, Jason@zx2c4.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: arm64: Fix lost Poly1305
 carry when resuming NEON" failed to apply to 6.12-stable tree
Message-ID: <20261021164836.GB1879@quark>
References: <2026102137-contently-unshaven-7da4@gregkh>
 <20261021154806.GA1879@quark>
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
In-Reply-To: <20261021154806.GA1879@quark>

On Wed, Oct 21, 2026 at 08:48:08AM -0700, Eric Biggers wrote:
> [+Cc linux-crypto@vger.kernel.org]
> 
> On Wed, Oct 21, 2026 at 04:40:37PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.12-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> It's a clean cherry-pick, as git detects the rename of
> poly1305-armv8.pl.  So there should be no need to require this to be
> resent.  Also, missing Cc to linux-crypto.
> 
> Same for 6.12, 6.6, 6.1, 5.15, and 5.10.

As I've said before, the reason this keeps happening is that Greg's
stable scripts perform a cherry-pick by first formatting the commit as a
patch file with the default 3 lines of context, then applying it with
'patch' using the default fuzz of 2.

(The second step seems to occur in the 'apply_it' script, which isn't
public.  But based on the observed behavior, it must be what it does.)

This process is buggy compared to simply using 'git cherry-pick':

- It has no rename detection.  Any file rename, like what happened for
  this commit where poly1305-armv8.pl is in different locations in
  different branches, results in FAILED.  This happens regularly.

- Incorrect backports due to only *one* line of context being
  considered (since 3 - 2 = 1).  For examples of this, see
  https://lore.kernel.org/all/20260512173933.811124271@linuxfoundation.org/
  and
  https://lore.kernel.org/all/20260515154719.961677988@linuxfoundation.org/

  This is easily reproducible.  For example for the first one:

  git checkout -d v6.12.87
  git cherry-pick 2909f0d4994fb4306bf116df5ccee797791fce2c
  git show # correct backport

  git checkout -d v6.12.87
  git format-patch -1 --no-base 2909f0d4994fb4306bf116df5ccee797791fce2c
  patch -p1 < 0001-usb-typec-tcpm-reset-internal-port-states-on-soft-re.patch
  git diff # incorrect backport that was actually sent out

  The second example is even worse, as there the incorrect backport was
  actually released.

Just using 'git cherry-pick', as contributors are already being asked to
do in the FAILED emails themselves, avoids these problems.

Can this please be fixed?  This outdated cherry-pick process is reducing
the quality of the stable releases.

- Eric
