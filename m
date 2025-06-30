Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC970145FE0;
	Mon, 30 Jun 2025 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751301027; cv=none; b=H0KLD0JMn/VzWgA424MD7yFeonCCnPPOqPX+4LRn/MqKUlIZYdDpZDkFEOvVevvjy6h1kkksmhjEhgtbWd0swQlWideJyp2VlMCVWovmLDIHKS1a2imvQOw4RCydtdeCPvHWfeX9USx3mm0SGD4ZfC2cS18ue6p78XG84NOcU6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751301027; c=relaxed/simple;
	bh=Z2eTTLeHJFplwtYGcfhlybw6T9tyxAT1gUDIZzaklQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ew0BCrNa+THiesn3h4LgQpsiIUD2YhpSzz/b+5UFNjP4NWZubXQb7HVlmaTAv1FCNY4SQ41BSKMd9mGSwz3PC2ceVTsldYtyOyn5y3JKeuqXkq/kjrdjE2NZGyLgr8nBzRgP4hVx60v0kohsB45kGG8mS8JzxXla9D6/ikEN9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJofbUpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJofbUpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5552EC4CEE3;
	Mon, 30 Jun 2025 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751301027;
	bh=Z2eTTLeHJFplwtYGcfhlybw6T9tyxAT1gUDIZzaklQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AJofbUpG/q1KTmDfuNZyc4ewqPgpkFy+jSAxhDsk3Vx5T/GeRwv3VuNgsSnbcUrYL
	 Lyk8EV8fMwoEgkeRicVcdKDtPBh7jsVV+nd5iMZZoZ4h9KUKCnk1558HF4ZEzbek8O
	 5s6bMEqqaY3CNLMEHe/EjkGmYqYUjrcVDE8dn/oeGKv0OiRYWyYrul4Q0tmekPpakw
	 Y+ycwtxHrXEZNG10zl+Kab3uP6Rz32Jdd+t2+obPNZMEHFuYkdtZgx/e31QfxbaxXF
	 WaYele9/nk4aByNT6DWg71XVmJYtj19KPy04tl+ox7OtKb0aI1Gvfb37kBOLMsxRVb
	 3B5Drv/BSmhCA==
Date: Mon, 30 Jun 2025 09:29:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Johansen <john.johansen@canonical.com>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <20250630162948.GA1220@sol>
References: <20250428190430.850240-1-ebiggers@kernel.org>
 <20250514042147.GA2073@sol>
 <4f37c07c-3a39-4c98-b9c4-13356f5a10dc@canonical.com>
 <20250612191105.GE1283@sol>
 <c80d4e69-ef03-462c-9084-e6bb56f428e6@canonical.com>
 <20250627035918.GA15797@sol>
 <540b7f72-58fa-4ee3-9b5b-6cd81c5959a7@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540b7f72-58fa-4ee3-9b5b-6cd81c5959a7@canonical.com>

On Thu, Jun 26, 2025 at 11:14:50PM -0700, John Johansen wrote:
> On 6/26/25 20:59, Eric Biggers wrote:
> > On Sun, Jun 22, 2025 at 02:16:07PM -0700, John Johansen wrote:
> > > On 6/12/25 12:11, Eric Biggers wrote:
> > > > On Sat, May 17, 2025 at 12:43:30AM -0700, John Johansen wrote:
> > > > > On 5/13/25 21:21, Eric Biggers wrote:
> > > > > > On Mon, Apr 28, 2025 at 12:04:30PM -0700, Eric Biggers wrote:
> > > > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > > > 
> > > > > > > This user of SHA-256 does not support any other algorithm, so the
> > > > > > > crypto_shash abstraction provides no value.  Just use the SHA-256
> > > > > > > library API instead, which is much simpler and easier to use.
> > > > > > > 
> > > > > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > > > > ---
> > > > > > > 
> > > > > > > This patch is targeting the apparmor tree for 6.16.
> > > > > > > 
> > > > > > >     security/apparmor/Kconfig  |  3 +-
> > > > > > >     security/apparmor/crypto.c | 85 ++++++--------------------------------
> > > > > > >     2 files changed, 13 insertions(+), 75 deletions(-)
> > > > > > 
> > > > > > Any interest in taking this patch through the apparmor or security trees?
> > > > > > 
> > > > > I can take it through my tree
> > > > 
> > > > Thanks!  I notice this isn't in v6.16-rc1.  Do you have a pull request planned?
> > > > 
> > > 
> > > Hey Eric,
> > > 
> > > sorry I have been sick and didn't get a 6.16 pull request out. I am slowly trying
> > > to dig my way out of the backlog, which is several weeks deeo. I might get together
> > > a small PR of bug fixes before the 6.17 merge window but the bulk of what is in
> > > apparmor-next will be waiting to merge in 6.17 now.
> > 
> > Hope you're feeling better!  Actually, would you mind if instead I took this
> I lot, though still generally tired/low on energy
> 
> > patch (with your ack) through the libcrypto-next tree for 6.17?
> > Otherwise there will be a silent merge conflict after I apply
> > https://lore.kernel.org/r/20250625070819.1496119-11-ebiggers@kernel.org/
> > 
> Avoiding a merge conflict? You have my ACK and blessing I will pull it out of
> the apparmor tree asap

Thanks, let me know once you've dropped it.

- Eric
