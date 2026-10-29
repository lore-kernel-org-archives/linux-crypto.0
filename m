Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793306147;
	b=JNN1uef7l8n6LkhCex4O7R17x690ED1XoE8Zh5HoYjE6yDlanF/Efjg2RnCB/kRzqht9
	 acrE6Pt903SNX2Ff4DABTFxzpYfLdF5WKT+EsO3Lxtd37bPfc+Y/yE42586uKT3dZNstz
	 0STLucW4ME353MreAjF2A68SaoxXs0b8epCl8wgvq6v++fh182vk6aXjM2D85nUCem/jb
	 YfCZ1Br+ECKH2GJUbokrKH5tnshxiT3GSIYV+oI5OzSqM8/bQuEH9GAgoVBpZi36SG9LQ
	 wPY1RRLqYKScn56zY7foKVfmaEkv0h5TB2yV2MxVwcG9A6ytGroRGqa0F9d4APNIZSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793306147;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UF42Vdd/T1B9YjxSSq5RVbRzD5IK/OVjqsPpDVNv/08=;
	b=VV3EhlZrE975Vkh5Wm8AeRpfi/hTzSyRXlIxdMoFjYeDBj5AVpEUOGV37aDy11Ggqvdk
	 4GTuVVGZ47+g6d0j7t8TLwca/JGyNcKm0zIfVIdcrzYRWfWDHevyQkVFFOWfSeHVExE8T
	 Bzl8VP9d4yLzTr3KxzV4Y8lMYG38WJkVxLNbS7CvFV9dgn14VSelvztNJQ6j5jlrqct7Y
	 gqp6xusOzgacnEijeJEEfe6+PxCRXvktuIyXp0jYLQGN2nOhwUbVb1M5hIrs6vYY5xBgk
	 ewXGSWq49Oue+o+quM1tfAYoe4DBUscsn46tMUiol2r4wopzomDviNaVhj3rS+QvGYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZMApxRFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBF2606A322;
	Thu, 29 Oct 2026 20:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZMApxRFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15161F01825;
	Thu, 29 Oct 2026 20:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306147;
	bh=UF42Vdd/T1B9YjxSSq5RVbRzD5IK/OVjqsPpDVNv/08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZMApxRFQTk+S76CBfWT7CNZwk5dCrPQJzX7H3ALrZrk9iChWiolLW+eXi/jqyBZGG
	 YvcwBHj/O1o7+Q8856jfgSvfCFwlGWIDlz4ENsyGk2R3BbXFuiArq1DTolspZOkrWK
	 6TuAtsGx6epzIBkzBvgmq5OjmJs4/9V0gw5UbIhde+8Nf2iCOw9vLUD1vyF6ThWkCm
	 LdkPQEQ7W1KDfiy8srDlUecH7tfUZ8GZWn1VXMZmkqYWs+fKljH6nyFvyr4fZw60qb
	 cDm4VQp7EeR22PK0gIy2f/JOEbaVHyS3oSy4IlEpWI/Kvv6u2NlC7vvlxYIwaO7WO7
	 fXCJjm0IWgNNg==
Date: Thu, 29 Oct 2026 13:35:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Jeremy.Jean@oss.cyber.gouv.fr, Jason@zx2c4.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: arm64: Fix lost Poly1305
 carry when resuming NEON" failed to apply to 6.12-stable tree
Message-ID: <20261029203545.GA49373@quark>
References: <2026102137-contently-unshaven-7da4@gregkh>
 <20261021154806.GA1879@quark>
 <20261021164836.GB1879@quark>
 <20261028182014.GE1876@quark>
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
In-Reply-To: <20261028182014.GE1876@quark>

On Wed, Oct 28, 2026 at 11:20:14AM -0700, Eric Biggers wrote:
> On Wed, Oct 21, 2026 at 09:48:36AM -0700, Eric Biggers wrote:
> > On Wed, Oct 21, 2026 at 08:48:08AM -0700, Eric Biggers wrote:
> > > [+Cc linux-crypto@vger.kernel.org]
> > > 
> > > On Wed, Oct 21, 2026 at 04:40:37PM +0200, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 6.12-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > It's a clean cherry-pick, as git detects the rename of
> > > poly1305-armv8.pl.  So there should be no need to require this to be
> > > resent.  Also, missing Cc to linux-crypto.
> > > 
> > > Same for 6.12, 6.6, 6.1, 5.15, and 5.10.
> > 
> > As I've said before, the reason this keeps happening is that Greg's
> > stable scripts perform a cherry-pick by first formatting the commit as a
> > patch file with the default 3 lines of context, then applying it with
> > 'patch' using the default fuzz of 2.
> > 
> > (The second step seems to occur in the 'apply_it' script, which isn't
> > public.  But based on the observed behavior, it must be what it does.)
> > 
> > This process is buggy compared to simply using 'git cherry-pick':
> > 
> > - It has no rename detection.  Any file rename, like what happened for
> >   this commit where poly1305-armv8.pl is in different locations in
> >   different branches, results in FAILED.  This happens regularly.
> > 
> > - Incorrect backports due to only *one* line of context being
> >   considered (since 3 - 2 = 1).  For examples of this, see
> >   https://lore.kernel.org/all/20260512173933.811124271@linuxfoundation.org/
> >   and
> >   https://lore.kernel.org/all/20260515154719.961677988@linuxfoundation.org/
> > 
> >   This is easily reproducible.  For example for the first one:
> > 
> >   git checkout -d v6.12.87
> >   git cherry-pick 2909f0d4994fb4306bf116df5ccee797791fce2c
> >   git show # correct backport
> > 
> >   git checkout -d v6.12.87
> >   git format-patch -1 --no-base 2909f0d4994fb4306bf116df5ccee797791fce2c
> >   patch -p1 < 0001-usb-typec-tcpm-reset-internal-port-states-on-soft-re.patch
> >   git diff # incorrect backport that was actually sent out
> > 
> >   The second example is even worse, as there the incorrect backport was
> >   actually released.
> > 
> > Just using 'git cherry-pick', as contributors are already being asked to
> > do in the FAILED emails themselves, avoids these problems.
> > 
> > Can this please be fixed?  This outdated cherry-pick process is reducing
> > the quality of the stable releases.
> 
> Any update on this from the stable maintainers?  Requiring resends for
> clean cherry-picks is a waste of time for everyone, among other issues I
> mentioned.

Seems there's no choice but to work around the process by sending out
clean cherry picks, so I've done so.

I guess I need to start using lei as well to get stable emails for
subsystems I'm interested in as well, to work around the apparent
deprecation of the subsystem mailing lists.

As for Greg/Sasha creating incorrect backports by using 'patch' instead
of 'git cherry-pick', I guess the workaround, at least for my own
commits that I might have time to check this for, is that I need to redo
every clean cherry-pick myself and verify that what was sent by
Greg/Sasha actually matches, as Greg/Sasha's process may instead patch a
different place in the file that has the same 1 line of context.

Just seems really time consuming for everyone involved to be working
around these unnecessary issues.

- Eric
