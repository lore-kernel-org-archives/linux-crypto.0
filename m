Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FFA4A0C
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 03:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715831436; cv=none; b=uRPbMgAXiUFInmT8ffhf10PVazrefUL41uAfFX7po4vT/hWWW9WE/2hMLH116hzokVle0G3i1PntVke6sxeLzICxtQTX628J4r/gFzRALkajw0dlMRoK+rvRfTlzRyky0t9VvwybgH3rJOAAzZGgWe45m0UM/NJNRbCFh2uUB9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715831436; c=relaxed/simple;
	bh=hHa6kmharfqHVPtuc3yO5chQaYVtBbZpk4gsvsfx378=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YV8TZfaQEMCiIJUBSahUnFo4FKsDgsx9qkBPBQ3m9VAoxBp4keeWPXqhJpEYEZ3Z46lZu2BPtzJPa4cYmBe+THD6QvJErsJ3p5Kw7E85mXQu3xGP/nVMW+TLDFrgRf+D5gHvZ2C9o3+84/ID+oyhdFgefdP5N1BLxKwWCgjHHR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=JoHf+kb2; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="JoHf+kb2"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-de61424f478so7444050276.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 20:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1715831434; x=1716436234; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wnK0WjZixLo/MtWnjkyeiV+YNAfaoH1VmBopqFJPW8=;
        b=JoHf+kb2iOT93cRPKX1gdMJa9sckS+7W892HnJuKttsFaRhoeMUrBHzUYcA6/dMosg
         RVTp/aFPYjUk4NMtrKNlDQOt5EsCC+rNVYr9zNrzRbf1DUA739rZW/ZpDMOUI7AL5VJf
         llOcxnUmifOGdBljplOreP2wGTqcYGn0vIZd4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715831434; x=1716436234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wnK0WjZixLo/MtWnjkyeiV+YNAfaoH1VmBopqFJPW8=;
        b=k7ftG2IMbMjM/7xjgcg6+NoJNMMdj4EkZ3CFcxtDG3xv2S0P1IrVuETrhFAXpDSFuf
         fK0VeJnovlBeZbCM0jCdrKYqNKY1G6Niv4Ns9Sv145H6U4UuS92OScXKClfye3oCpjGH
         eMjMqVFyvIoaywP6BmCOJ5sbMYPStUEZEpbnTuGwvDHUJe2k7Qh9z/a+6WWAPR9UETdn
         CZ1slK2T/kmsvQybfsHjXVQ3hGnOB005YNKHCHKR9vTCyWckfMsLp9D1QK0S8t+vZB1P
         adSmr3onGlK+hN23N/VLew4gUDhpSpXZuesECteKa+iWnXFLf9LY2SeK+hnosXxkFUpH
         oHwg==
X-Gm-Message-State: AOJu0YxQrI7wtl16yUtyBgPKPVOrAHBjcpd4lXc/NLkUFe2+IfYtmK+S
	vagZlf++lnUtpyP57pRVjbEjLYSzRuthaZAZ/NvwgQmuxBUSTSgyUAIHDhZur2kX/p2VVfv/7rl
	8oxijytwaf85F10VSZYThfAT4NnmFuRL2V2Ejt70LwwNmbiGV
X-Google-Smtp-Source: AGHT+IGFjSu+/VtUxs8ASexrS0GPVQUTBMIDEBfiN0x0l0+Q/HV7y4NLvg9S+4EIGUwblSQuPkOFjYm3ngb9KNWnSH8=
X-Received: by 2002:a25:820d:0:b0:dd0:972b:d218 with SMTP id
 3f1490d57ef6-dee4f370323mr15839405276.41.1715831434476; Wed, 15 May 2024
 20:50:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com> <ZjS8fQE5No1rDygF@gondor.apana.org.au>
 <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com>
 <Zj3Ut7ToXihFEDip@gondor.apana.org.au> <CALxtO0myn63AwPh4vck7fpuJcttPJYLBM3TpsyBAexCMSa4GcQ@mail.gmail.com>
 <ZkV6ZmONMHEX7BQy@gondor.apana.org.au>
In-Reply-To: <ZkV6ZmONMHEX7BQy@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 16 May 2024 09:20:23 +0530
Message-ID: <CALxtO0=n+k9NDfH87JWkFHQfA=T2x+T-ekGh=SBmA6Ozk48qsw@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure Herbert,
  Thanks a lot for the quick reply.
  I will update the partial hashing code to do a software fallback and
push the patch.

Warm regards,
PK


On Thu, May 16, 2024 at 8:45=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, May 16, 2024 at 08:41:57AM +0530, Pavitrakumar Managutte wrote:
> > Hi Herbert,
> >    The SPAcc crypto accelerator has the below design
> >
> >    1. The SPAcc does not allow us to read internal context (including
> > the intermediate hash).
> >        The hardware context is inaccessible for security reasons.
>
> In that case you cannot support the partial hashing APIs in Linux.
>
> You should use a software fallback for everything but the digest
> call.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
