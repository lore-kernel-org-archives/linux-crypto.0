Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD7B199EBB;
	Fri, 29 Nov 2024 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732902452; cv=none; b=BZ2/rDzmCCL9R14IrDN2pud8F6+AMXjjU7eZYbjo7dObZ4aJR6mUavWnAxECAnEqxLwfztQWm7qqTEURlpvl+TgkZ9xSirnODn1mVdBFqi6c1IjYiT/64JnM+MJWxY9cvCMJYXZTxV/GgwB38zUS1IaXwJXwleW8jRRAETSo608=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732902452; c=relaxed/simple;
	bh=Zo8z8OjnZjirUmJPWDlQPgcXBZGP/ZRS3tUgfDwTdXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWS31USBeZSJUrOgCozdt10RdqfPpUk6dSv2CsDsshMU27dLGVvf76aFZxIcHUyMqn5ckzoj4gtR/OpzmQU5wnVFlAhvwpADsUASO3O5P1kllV/SxXKe/jEXeohDEAvA1rQbldowa9momOv0IV8fen46VKrZW7e5ctkSUVsWpKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6kFAVW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6kFAVW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223BCC4CECF;
	Fri, 29 Nov 2024 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732902452;
	bh=Zo8z8OjnZjirUmJPWDlQPgcXBZGP/ZRS3tUgfDwTdXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i6kFAVW5reb45B8jtJsh3DTEw2ZUoO/bAmtDneOf0LbkHCa5ccSnp088qRccq6R+V
	 9HxsC073R0GNOk/sJODQMADJuAY4DcYxw1iDOsZWvt4lBsQGkwM0B9sOO6AOtHx1QM
	 K1YpSZgHGI/BZidB86tvZt0qqY6I4981nVifddU5OnCCscZrI6iHMsUTPA5oWqu9+P
	 bKaZgnyrb9aUqdfDY2NVziC/yK+UDav1nqPOnAeArOV/EDuvlM61uOQ3M4WouTplpV
	 C6QKJzA7abg0QzIoZfEFu17aWFFZ6prhPSzQP/NODB5OTV3ynpVEWBpSrDily0h4ma
	 rRPLd4UuWo7QQ==
Date: Fri, 29 Nov 2024 09:47:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 2/6] scripts/crc: add gen-crc-consts.py
Message-ID: <20241129174730.GA1179@sol.localdomain>
References: <20241125041129.192999-1-ebiggers@kernel.org>
 <20241125041129.192999-3-ebiggers@kernel.org>
 <CAMj1kXFGs8Ur0yt9GetVaub8LzbeWJ77jaZ4ZstvECb3JH9Pvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFGs8Ur0yt9GetVaub8LzbeWJ77jaZ4ZstvECb3JH9Pvg@mail.gmail.com>

On Fri, Nov 29, 2024 at 05:09:51PM +0100, Ard Biesheuvel wrote:
> On Mon, 25 Nov 2024 at 05:12, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add a Python script that generates constants for computing the given CRC
> > variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
> >
> 
> There is nothing x86 specific about this, right? Except perhaps the
> choice of fold distances?

Yes, and maybe other architectures will want something different for bswap_mask
and shuf_table depending on exactly what instructions they have.  But it should
be straightforward to add an option to generate another arch's variant.

> > +print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
> 
> Does it make sense to add a GPL header into a generated file?

Since I'm checking in the generated file, I figured it would run up against the
policy that every source file must have a license.

We could generate the file during every build, but I don't really want to deal
with complaints about Python not being installed or Python being too old, or to
put the performance of the script on the critical path for almost everyone
building a kernel for x86.  (Note that Documentation/process/changes.rst
currently lists Python as "optional" for building the kernel, not required.)

- Eric
