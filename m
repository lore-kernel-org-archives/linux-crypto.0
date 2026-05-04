Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761F3DDDC1;
	Mon,  4 May 2026 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903075; cv=none; b=u3IiMXNN1N7CmnhD+mjx8I9e4IsWK2UYwX8XieSKT50I5QNANc2+9xkR0rQVfh6FokOs3feFksPC3+8O8szmey5w+IxQndLlH58g4TWW6SBMYkflswQANGJV4WTGQKQeuf64f7F7/obY3Q0hCBqg+Ilvqjma1tR0d9klz+0DfHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903075; c=relaxed/simple;
	bh=ASemADxvdTXr4jPSMx2O89KcGuDjn5ijg7GrJYtm45c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLzk5HwcKhT2JRqkSXcixe370zDaGKk5kQmPJhUfHixu22Y0XRbk/zw1/SfxW9DDESrikfrxKYhgh0fX7IgnUS0nKs10bccvS/YLnsFxsAl7zZ3o6DiJxFqvVF61P8B3+P2TfHydwbxOvfGGOFOl4kyh7ovr2FvXS3+9Ax8zaBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6haBxk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6haBxk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7450EC2BCC4;
	Mon,  4 May 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777903075;
	bh=ASemADxvdTXr4jPSMx2O89KcGuDjn5ijg7GrJYtm45c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6haBxk8wXq0+l1NMUTm6cH2CFOSXGpufpJJ76Zfx/rlrLpCzVb928sdjSKxuisU/
	 X2PCSUZqFMAMlaYHLQ67RynSxuCuQUnnWsOftRbG3nI0gt9sJv6o50qiomW746uVDM
	 IfO5LB2ihGrzj3qy89clCZhkpOkV9mKbvCiEub57h7jUqPw/mwB+/hHhuP6Thu4pFw
	 PGpB03Wv8ik5muDNq6amiD39Hvta/gV87ewnq9HrU6m+qA0YN1v+vOG0bHWjtlIapl
	 4idCKGHzk/FesxZ/9J+GhWcWOVZnXQhD3G9u/LpoMYIsTT9z1POEPn8GU0LMxYOXor
	 lHemah+4X8sWQ==
Date: Mon, 4 May 2026 07:57:52 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Maxwell Doose <m32285159@gmail.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC v1 6/6] crypto/ccp: Implement SNP firmware live update
Message-ID: <afijY2Q0tEK5BnPs@tycho.pizza>
References: <20260430160716.1120553-1-tycho@kernel.org>
 <20260430160716.1120553-7-tycho@kernel.org>
 <DI8PTIGP3I43.JOF10O9FPOMF@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DI8PTIGP3I43.JOF10O9FPOMF@gmail.com>

On Sat, May 02, 2026 at 10:18:42PM -0500, Maxwell Doose wrote:
> On Thu Apr 30, 2026 at 11:07 AM CDT, Tycho Andersen wrote:
> > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> >
> > Put all the previous primitives together to implement SNP firmware
> > live update via DOWNLOAD_FIRMWARE_EX.
> >
> 
> [snip]
> 
> >
> > [1]: https://lore.kernel.org/lkml/20241112232253.3379178-7-dionnaglaze@google.com/
> > Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 244 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 243 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index b4711bf823e8..e7fe6dbf69c2 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > +static int sev_download_firmware_ex(struct sev_device *sev, const u8 *data,
> > +				    u32 size)
> > +{
> > +	struct sev_data_download_firmware_ex sev_data = {0};
> > +	int ret, error = 0, order;
> >
> 
> Why not assign across multiple lines? How about something like:
> 
> int ret, order;
> int error = 0;
> 
> or:
> 
> int ret;
> int order;
> int error = 0;
> 
> Would be better for readability and git blame.

Sure, I'll make the change here and in the other places you noted.

> >  static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
> >  					      const u8 *data, u32 offset,
> >  					      u32 size, u32 *written)
> > {
> >
> 
> [snip]
> 
> >
> > +	old_major = sev->api_major;
> > +	old_minor = sev->api_minor;
> > +	old_build = sev->build;
> > +
> > +	mutex_lock(&sev_cmd_mutex);
> >
> 
> Why not guard(mutex)()? You used it earlier in
> sev_firmware_reinit_if_shutdown().

Because this code calls some functions, including
sev_firmware_reinit_if_shutdown(), that take the lock again. We could
use scoped_guard() I suppose, I can look at that for v2.

It may be useful to do a larger series where we re-think when the
locks are acquired here. It seems like only grabbing them at the top
level entrypoints: ioctl, platform init, firmware update, etc. and
putting lockdep asserts in all the helpers in the file might be
cleaner generally.

Tycho
