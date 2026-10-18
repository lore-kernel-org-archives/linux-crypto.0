Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB9C39DBD0;
	Sun, 18 Oct 2026 20:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792355848; cv=none; b=FxAvNENCmUVCwuVlgIjNHG8e3J4PoKzLiWyYyuQfkZLB42KBIchjn8u4fzPIujyof0WGMKNZn72RCIFHQjiXRsbmSWOKygukbqD3Kak+4/bZ+loLv5qnnrtp+f329/JFBY1IFMUk50/msWSPlrY75823rblaQuR27pS3Q0souyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792355848; c=relaxed/simple;
	bh=shHviM0D1+dCnCCiCeDiNnlKGT/UthA8YjfsCp7FnZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndFAjZ4egJTi8ZlBYUgEREvVMiDSxIuwIt/Qja4pMUPY1vysK8IasOvlQq6cjltQ4PS+WjgVvxw/L86aqmGq8GkzUkRopiIonjL+7FwihYyDoqPGyl2mxXRBqwtOKSNCkXQVXs8cXi9FO+ZsTn+bnhzOI/5jJuWep9LqxWjP96g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C15FN4Kz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C15FN4Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DEE1F000C4;
	Sun, 18 Oct 2026 20:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792355847;
	bh=QXko8Bdg1ppLeaBDulK5mghnlD1+S4a+kO42xD2gaH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C15FN4KzGfd1dojoDS1r3+g6gxUUU6jySV4HkwxFuFX8bpiYuGDTtWcbI0e5L5NBM
	 +ynB8THFDKxG49XjgZgmaGvQEBVtV9Fg7fP9A5JJ8SNPQ4qFfQvZtbgVnVDs6qAu3H
	 k/34bmh5fqn4Jqn9w7kix8+hbOuLrJggDlMV4hsRwRVawdxNEAEbqa9jkR/zOjXMh7
	 DqYdhwiIIEV212KVA/vRuUaTEpspLl/HfSUtbLhux5bldaAGoeThmWH490ztqdoaHE
	 JT85+kQt6Hl/bh0nPdhfMEt4FcqrBdK0rhMvsu29IcAZYfwCivTnWmXlE6OA7qGWkT
	 COy1INlVEukuw==
Date: Sun, 18 Oct 2026 22:37:22 +0200
From: Thorsten Blum <blum@kernel.org>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rusty Russell <rusty@rustcorp.com.au>, Amos Kong <akong@redhat.com>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: virtio - prevent use-after-free after a failed
 restore
Message-ID: <atUuAsxE42s8NGEY@kernel.org>
References: <20261016103640.4989-2-blum@kernel.org>
 <CANc+2y7ruqmfO+D_nfdc9rnBE0uSSnZR9UJY2Dvc5Nez9U-61Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANc+2y7ruqmfO+D_nfdc9rnBE0uSSnZR9UJY2Dvc5Nez9U-61Q@mail.gmail.com>

Hi PrasannaKumar,

On Sun, Oct 18, 2026 at 10:30:08PM +0530, PrasannaKumar Muralidharan wrote:
> Hi Thorsten,
> 
> On Fri, 16 Oct 2026 at 16:16, Thorsten Blum <blum@kernel.org> wrote:
> >
> > remove_common() frees the driver data during freeze, but does not clear
> > vdev->priv, which points to freed memory. If probe_common() then fails
> > during restore, a later remove or freeze can dereference the dangling
> > pointer.
> >
> > Clear vdev->priv on the probe_common() error cleanup path and before
> > freeing the driver data in remove_common(). Also reset the device and
> > return early from remove_common() if vdev->priv is already NULL for a
> > safe teardown after a failed restore.
> >
> > Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Thorsten Blum <blum@kernel.org>
> > ---
> >  drivers/char/hw_random/virtio-rng.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > index 5e83ffa105e4..a9ff520975a7 100644
> > --- a/drivers/char/hw_random/virtio-rng.c
> > +++ b/drivers/char/hw_random/virtio-rng.c
> > @@ -190,6 +190,7 @@ static int probe_common(struct virtio_device *vdev)
> >  err_find:
> >         ida_free(&rng_index_ida, index);
> >  err_ida:
> > +       vdev->priv = NULL;
> >         kfree(vi);
> >         return err;
> >  }
> > @@ -198,6 +199,11 @@ static void remove_common(struct virtio_device *vdev)
> >  {
> >         struct virtrng_info *vi = vdev->priv;
> >
> > +       if (!vi) {
> > +               virtio_reset_device(vdev);
> > +               return;
> > +       }
> > +
> 
> The virtio_reset_device() is always called before setting vdev->priv
> to NULL. So the virtio device is already quiesced, no need to do early
> return. Isn't it?

The check is still needed.

For example, during hibernation or suspend, .freeze (virtrng_freeze() ->
remove_common()) frees vi and sets vdev->priv to NULL.

On resume, .restore (virtrng_restore()) calls probe_common(), which
could fail and leave vdev->priv NULL. A later .freeze or .remove calls
remove_common() again, which would dereference NULL without the check.

Best regards,
Thorsten
