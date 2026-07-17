Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFB0318BA8;
	Fri, 17 Jul 2026 16:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304967; cv=none; b=QIueJK62MF4ZZaxhBJfX2577hXkXTqOXuF81BLof4aCwG9qrHElfRVdaIFEaizCR5XMXgWGNrZDDSB6O7Jy72HVPJ1uv8yCBlvvoPwjiq5JNXd8G4kzQ3s2leSv1YdrDP2YrVPkAEUh07UX+TWYl0M8l/+a7yKWftY2MJx5kbTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304967; c=relaxed/simple;
	bh=Q0c3LAz0+gwYvfmYC0b/X4QUh/4mETCV6zZs9VNm29k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reEGXDRWINiC6XMTKGgOsOBwiT9VsMUXxfReN+MCah5ALrPmWcbhFg+OcYLzAUNBxVtC0DtL7yUYx/2hP6DRzNvX1892is3e9d4tE3551ufwO4BxOHJ8iZHARvdoylA4BGHYujm/xqypz/b92/6C1u50SgqF/GsEEvg1ycPJ3Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKS7zoDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKS7zoDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240831F000E9;
	Fri, 17 Jul 2026 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304965;
	bh=jZgWRm5y/LtA8Hx+Cn4vDzKdPQ6SoScTdBSaUEIRnJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FKS7zoDFsgPHGeTy+sZnTrtmNon2XfPsKqx2yFbNzan1Ym29gz90IprHQXMQhr5K3
	 XUxtmYWLk0axxZz1oDuSEipc6E0ucdSRQKE58kkAvJTfF4gwo04Z8CEZ/+hRJKxWm+
	 UD0FvIg2FWCOhUbCT3eX+dQj5T8g49fd0jIfIECZkziMG6gztN4iWMrxyScBnJu/Uc
	 /UdKOtssfz46YKE+VoJEb/f2jsYbWA/0YYI6DQdk/q+jZi+W5mWxSDPQpPIe6txK4m
	 YmG9Y0TAFT76eNNDKL04CEcuqCVq962UIN4GrYjIJ4aj9qwDXz2BPdRRA1rcU7WeP0
	 Ocn3A2LLY5jCQ==
Date: Fri, 17 Jul 2026 09:16:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: herbert@gondor.apana.org.au, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: xilinx-trng - Remove crypto_rng
 interface" failed to apply to 7.1-stable tree
Message-ID: <20260717161603.GC2046@quark>
References: <2026071501-handstand-curtain-592d@gregkh>
 <20260717021831.GA1847@sol>
 <2026071718-agreeably-sapling-e9b4@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071718-agreeably-sapling-e9b4@gregkh>

On Fri, Jul 17, 2026 at 09:38:26AM +0200, Greg KH wrote:
> On Thu, Jul 16, 2026 at 07:18:31PM -0700, Eric Biggers wrote:
> > On Wed, Jul 15, 2026 at 12:16:01PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 7.1-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > To reproduce the conflict and resubmit, you may use the following commands:
> > > 
> > > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-7.1.y
> > > git checkout FETCH_HEAD
> > > git cherry-pick -x 32b4d29280ed2a991dc196d5845b892acedc63b8
> > > # <resolve conflicts, build, test, etc.>
> > > git commit -s
> > > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026071501-handstand-curtain-592d@gregkh' --subject-prefix 'PATCH 7.1.y' 'HEAD^..'
> > > 
> > > Possible dependencies:
> > 
> > It actually cherry-picks cleanly.
> 
> Odd, I got this error:
> Hunk #2 FAILED at 13.

Use 'git cherry-pick', just like you're telling everyone else to do.

> > And you also failed to Cc the subsystem mailing list.
> 
> We don't do that for stable FAILED emails, as that would just spam too
> many lists too often.

They are part of the kernel development process and need to be sent to
the proper lists.

- Eric
