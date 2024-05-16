Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F6E2566
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 03:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715829131; cv=none; b=UO2nJQDGeGaNQLj4jq4WShGItDLBkVvZxL6aUG2NRUu02aipo1txYcnKRQrhjyCxGlTgwfeKMkLvdIfFUrqT8GZ4mztYdp5sdqaNLs90eibsx7AwoOFkDdBdLHfyOG0T/8N0xmi6AykPEVfz9vUEhG9VYNoblU8yoyNbRYS60Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715829131; c=relaxed/simple;
	bh=GeayfmFw5bI1wsDSlpFOMEcNK5ns1Ba1gDkmHP5rC+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cLKF0OOiXO35FYJCSxEiF8XJFIuDR6UhfsDkMMrEa42VkdCnD2nIN5b/0Pa+tVgMQjXtIC4W1UQq/vbYDd+mvqVNWXaKs/WTZ2V+YxbE1/PwhkDwEKPbCKeJb0J2AYE8sga6WqNScM7JTXiEsjgkX3zD1jiycKKFWH7UBkzRPZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=C5Ikvfp1; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="C5Ikvfp1"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-de5ea7edb90so7648471276.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 20:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1715829129; x=1716433929; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=arhi97mOaQdG99l3e6G5fKeBVU4MWUpNsqgpVpnh/jg=;
        b=C5Ikvfp1zquuHINySPcYcquKtpN1H6jBgi5MCPHmBqXbGBA5/ciok9BPsuGzhSQ20V
         NN2J7B0qbWM73QKeXlyBWU0E9jnAFICRm2oiLwmXRVLyU7qae3r5ChzI8rr9vlWS30O/
         fBeQPX/o3eHm3NGpoLnZVjnwtfNwjRANroCvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715829129; x=1716433929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=arhi97mOaQdG99l3e6G5fKeBVU4MWUpNsqgpVpnh/jg=;
        b=gpdIOejxcZmEPs/ZU373xLvrIdi+I8rL/Y7MuMxPHdVtOZmi4N90f6sq+e+sNu5PTZ
         wl8kTFs9ZmDOAQnTbqBXTY9eqRVPOyI/gGQboQS2sedG/tLYRS52C1T9cMYLFVGHGiRz
         vmg02NyB+xkwDKr2DLDaTQMyBA7Z+Gkk+GOPqugIj2D4SdvnnrKBfPSUQirjyzuoTwth
         FtPQG/PK2KDR6ks7L5FDau9n9C16bT5YIPDON4hLPzJ3MxfLMB4jz5wGK7K/F7d2jerM
         u9M67bP+3550IeNHjXmNQwWsUHKMlgb1Ho/Hij6rcZDgu1qg53/kzK/lKostBjUm41ei
         a12Q==
X-Gm-Message-State: AOJu0YzpG6s1+pVY+LAWsIwPAfr2kyIk5qs08zYUWkSxI/YC4O895XWB
	T438yKWaio5FPZbK7lMXBHziNX2S8EfoaiGGuIJ4Lc0TwrkOXNiV/BbF8fDmycVbTNWBHiqFgbS
	6OR8MIY/QrSWTZCxaVlgeSCTiuPg4sXwHjDAgLwMeth+1bJh/
X-Google-Smtp-Source: AGHT+IFqKcborT2t/RlsVHtj7BoDOTBzvI7w+UdNwASVyoVxCinRhb9V1pOm7vdTeUcBLDtBb1qYdZrzDZwP3lHD7js=
X-Received: by 2002:a25:9702:0:b0:de6:4ff:3164 with SMTP id
 3f1490d57ef6-dee4f2eb5b2mr16897416276.36.1715829128723; Wed, 15 May 2024
 20:12:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com> <ZjS8fQE5No1rDygF@gondor.apana.org.au>
 <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com> <Zj3Ut7ToXihFEDip@gondor.apana.org.au>
In-Reply-To: <Zj3Ut7ToXihFEDip@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 16 May 2024 08:41:57 +0530
Message-ID: <CALxtO0myn63AwPh4vck7fpuJcttPJYLBM3TpsyBAexCMSa4GcQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
   The SPAcc crypto accelerator has the below design

   1. The SPAcc does not allow us to read internal context (including
the intermediate hash).
       The hardware context is inaccessible for security reasons.
   2. SPAcc has multiple hardware contexts and every request uses a hardwar=
e
       context that's obtained using 'spacc_open' and released with
'spacc_close'.

  The export/import is supposed to save the intermediate hash and
since SPAcc hardware
  does not provide that, I was using it to save my driver state. This
is redundant and I tested
  the same by removing it from export/import. An empty import/export
function is what I
  have in the latest driver code and that works for me.

  Appreciate your inputs.

Warm regards,
PK


On Fri, May 10, 2024 at 1:33=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Tue, May 07, 2024 at 09:49:57AM +0530, Pavitrakumar Managutte wrote:
> >
> > About the export function, yes its hash state that's present inside
> > "spacc_crypto_ctx".
>
> Please show me exactly where the partial hash state is stored in the
> request context because I couldn't find the spot.  It can't be in
> spacc_crypto_ctx as that is the tfm context and shared by multiple
> reqeusts.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
