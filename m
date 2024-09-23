Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A38EAF6
	for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2024 07:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727077413; cv=none; b=IT8alk2Zxu5uCALEYPA4txDJcpvrMeOB17SxdDMgXrsCN7J0qAaDTZ0YX6CU0GPf9yJKFnvoyvdrBKUmrRRfuxH7R/L6Frd6+4J3jFVX1JLLBK8n4ggib3mwZD9olYX1RvggWG9ZJer38zsBWYna9JSYw9xIRkgG2ijNxeGZalw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727077413; c=relaxed/simple;
	bh=a4utO76+Q5PasDVFSIDK7nCObjlMk1RBHcC5sGPt5EU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oS1C4mreWfSxBYXzlSYNlwJ6unmvOGeNkWBG2xyb8HmP5CUZkV8M8kUtDdjZ+dish5HhhAq7z6eHFhnWZDVytiWYRKf4xFp0jL3DhYSbfkE2GmEcyJX77Pvk2dGqgz4f0nGQ7wj324w30Jq+v8UwyS0xW2muwolMeb3TQ+KUei8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BavuNtJD; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BavuNtJD"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c27067b81aso5264978a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2024 00:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727077410; x=1727682210; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/OOBU9h5PruQa21iZmobkwuYwhWiT19TpmxF26W+5A=;
        b=BavuNtJDnFAm9V7WTBqUbDyzyu5WdiJTjVrsqQy2duZrqJXypz8723e9jA/z2zwbly
         uq5s7hdOBK7E1e8M4v39yYCpqmaAOaSj/OckODIh6Tsw+nJLQRxsR2Xy6p+ur9XiCWfI
         lQSDWqt7zSuQR0+EfkZHaPcVvornCnqB8kCXYZeliDs4mydkaTnE5KdKBDzRN797V92n
         rT+M0Rz3XikS2H5YgH2I52p5TObPP6mm1tMzuVvtt5IW89VVrCBcYG5EvJReQC6HustP
         qro3n3qKogT0dk7AcHnAy7dm3DdQ8JUdebGItuEWTyLCt5yYGXtuobR0HBe09uk/BfS2
         8D7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727077410; x=1727682210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/OOBU9h5PruQa21iZmobkwuYwhWiT19TpmxF26W+5A=;
        b=VqtR0JdjNiku4odKkY1p3A06aC9dfxrYbyF8pnDTxwmzUZADWCp50NK29uE6cHPTRe
         XAi2de95DI7v1ISHr0yBYtqvgUvtBLYf9zHnLTPY5Jw7pD4czFUg1hh28QnU/7pceiqg
         l/2PlzFgmuSHPaFn6MZcPB6BsI3k+cpQzLp1R5xQdRT0xAtHgJ5hiRPeN2vUQgellHTh
         38k8C8ubeSoqfEcsAXGew+dMl9v/GAWczA7OGTTzamnMPTPxg6rbibV7dO5YQRA+QJ0Z
         NEGa9R8W1cF3ztSmeCyBXU60RpSXO7qoHHzBfDZrM43R1AE1/jGAjyjmDNmfBSMcewiF
         h6Eg==
X-Gm-Message-State: AOJu0YwVn00LWjNK1RjI/3AiwzOB+dp69/WEBl27XQ3FB0J/4hcn59Qk
	Jv59kJJPPVRqmzSGmbVZgW9s8GvVdAmZlCVq2OG9EeRK7cTFwS7ZXjMOCy9N1byk/UQpkTMqOI+
	qFe8OorPpjwRSgtDjEiktlNdu/Idvv4HdkpmbCw==
X-Google-Smtp-Source: AGHT+IFuHfK2kXcRU5QDg0ykxdU3a5PuRHAKuO3Nc5aRSKNVVeqdzPks2qqQtob+o3pqAZMUrX4oFX1eRW7bqXezWr8=
X-Received: by 2002:a05:6402:5207:b0:5c3:5423:3d10 with SMTP id
 4fb4d7f45d1cf-5c464a38394mr9195991a12.5.1727077410069; Mon, 23 Sep 2024
 00:43:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
 <ZvEasINIFePe1tE7@gondor.apana.org.au>
In-Reply-To: <ZvEasINIFePe1tE7@gondor.apana.org.au>
From: Harsh Jain <harshjain.prof@gmail.com>
Date: Mon, 23 Sep 2024 13:13:18 +0530
Message-ID: <CAFXBA=kHUHNH_BEnK=sWvWPJPoxsDh56OEhisbRGzdD19Di2gQ@mail.gmail.com>
Subject: Re: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, h.jain@amd.com, 
	harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 1:07=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Mon, Sep 23, 2024 at 12:39:11PM +0530, Harsh Jain wrote:
> >
> > What should be the preferred fix for this.
> > 1. Increase the size of HASH_MAX_DESCSIZE macro by 8.
> > 2. Register "versal-sha3-384" as ahash algo.
>
> Please hold onto your algorithm for a while.  When I'm done with
> the multibuffer ahash interface hopefully we can say goodbye to
> shash once and for all.
>
> The plan is to allow ahash users to supply virtual pointer addresses
> instead to SG lists (if they wish), and the API will provide help
> to the drivers by automatically copying them and turning them into
> SG lists.
>
> For the shash algorithms the API will walk the input data for them
> and if the input is a virtual pointer, then there will be no overhead
> at all.

Sure, Thanks Herbert.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
