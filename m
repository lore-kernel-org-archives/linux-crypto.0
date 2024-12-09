Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252381D555;
	Mon,  9 Dec 2024 06:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733726789; cv=none; b=J7Q6oEOtCM6PnEpYASKVUe0UV4pqRBJXBQJQplrdD2BVCZHXt33L8bMYvL1wcmLHPXK4MBXRm5kUbtFjJDSenIHwh8bDnPZ60FPOrv5EBc2+WuKEWlYQ/HCzJ0seMCXGywYwtRdgIqKIFZm2ZbC5ioP1B0FCeV4DjzmBtZADrWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733726789; c=relaxed/simple;
	bh=UUxIExj5X5V9wSdT8qbwxUMy+ABcztcbcaxF3+x3SrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmrP6Ab9DEJUsizQ1BQORzemOUvTy4VXAxaJm618DghnmCibUt7UhuKOqt3bj2vQya4LRa50Rg5x1JBGfxsAooMmPGQ4cKMdeexgrPKzFIuRZnT4sMYhR7hZyBNBBZI0prbYp7ajLm5KbJq18ipSok80/DzzWUxPOzjqrjSfjXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrFZSBKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrFZSBKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EB6C4CED1;
	Mon,  9 Dec 2024 06:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733726787;
	bh=UUxIExj5X5V9wSdT8qbwxUMy+ABcztcbcaxF3+x3SrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wrFZSBKpxTZSyCk8lISFVvdIRmXNjXrgCME0wd2lvaOJ+3qbpeZEPmp4NV/1VUpM5
	 G2iQmh5vnZt7tDXcu5Q2WMImgxRyiawA2lT0E1IOZMS2TkDy1Qrv2Ayk62F1ixgQge
	 ZawEzZssIpLVNVR+XlsraHJADW8woGspdHxiEZ34=
Date: Mon, 9 Dec 2024 07:45:51 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org,
	yury.norov@gmail.com, kees@kernel.org, gustavoars@kernel.org,
	nathan@kernel.org, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, gjoyce@ibm.com,
	linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <2024120938-kilogram-granite-9a53@gregkh>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241208161315.730138-1-nilay@linux.ibm.com>

On Sun, Dec 08, 2024 at 09:42:28PM +0530, Nilay Shroff wrote:
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

As this is different, my Ack does not still stand, sorry :(

> +# Currently, disable -Wstringop-overread for gcc-13+ and FORTIFY_SOURCE globally.
> +config GCC13_NO_STRINGOP_OVERREAD
> +	def_bool y

I hit this with gcc 14, it's not just a gcc 13 issue.

> +config CC_NO_STRINGOP_OVERREAD
> +	bool
> +	default y if CC_IS_GCC && GCC_VERSION >= 130000 && GCC13_NO_STRINGOP_OVERREAD && FORTIFY_SOURCE

Ok, I see you enabled this for more than 13, but why call it "13"?

> +
>  #
>  # For architectures that know their GCC __int128 support is sound
>  #
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 1d13cecc7cc7..1abd41269fd0 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -27,6 +27,7 @@ endif
>  KBUILD_CPPFLAGS-$(CONFIG_WERROR) += -Werror
>  KBUILD_CPPFLAGS += $(KBUILD_CPPFLAGS-y)
>  KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
> +KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERREAD) += -Wno-stringop-overread

I don't want this disabled for all files in the kernel, we only have one
that this is a problem for.  I think you disable this, the whole fortify
logic is disabled which is not the goal, why not just force the fortify
feature OFF if we have a "bad compiler" that can not support it?

So no, I don't think this is the correct solution here, sorry.

And it's odd that we are the only 2 people hitting it, has everyone else
just given up on gcc and moved on to using clang?

thanks,

greg k-h
