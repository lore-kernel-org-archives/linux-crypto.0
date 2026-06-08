Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF16367295
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780942310; cv=pass; b=KAo49VYmqoBmC0s4e+vaDeVcAZ5RiK1EV9wN3pihxQTTSpekK975DS3XVNsUj+2xSADR+brNNWK+n5eK3ixmwi5GAjo9Af4512Dityc5RuA9BZeeEyowuMcED8Kc/LQfEONeU4HaOowVdVqgijOkFC5duS3oYz2ujgdAgCZqwCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780942310; c=relaxed/simple;
	bh=VZpVuEIFYp9UsfFz5BGKAT3YAHB73zvlRx6pwQWbJ0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UzODcYcYV344E3g5z5z3TSMt/aQ9gn1QmZ5QymvWSpF6Ke3sbtyH5ElH39bxvhqxBxHIwAJsTe7Q69QtIpN0/9weYdvmXI/l/utuYNPIpI2yf1C4XwyYO2zjM/9iYzC2kFw3ZWeCQYKrT7f8lljr8MeQcG4OgULqaFKv4sAGg5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOzeiRdk; arc=pass smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOzeiRdk"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-304f590dd91so5015806eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 11:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780942308; cv=none;
        d=google.com; s=arc-20240605;
        b=C5YEbE+1CTVK17M4Z5Uz7ZQREqNDPNgvtaSeZShks5M/TMIIf2dQO/e2rlVsOqRoES
         nnGiqeLN57+5ltuQcbRrp2p9vhYY6JE3QMMJa+WOtCFk/o5y3gkzvMfUe4DUJ+vFg4zy
         cY3QCcMHklzP+3+nvPAXaNoAlbcPnJLvuKvnFgJYcSozrA7+zqQLxr5O1css5vZ11oP4
         BUQh5BVTvZbTTdgCfz4Qa4pPMLVCORlWag2bVdgcIJbf1+/iCPHoN/CtTde8HZSlzJwa
         Hb3OtWue6xC7jOkIZYm/LUDirHxTJpopsX7pWwO67bHkih6yJwvJrsuCmkLrqGMKw5h/
         +C5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ep5iwWlczkBtdvT0ueoldhn2n7yNnVgtmpFujFfNkgg=;
        fh=RstN9zTpY9eTJSfuHdABDlhe8dkh+/V4qJU5TWmISE4=;
        b=KLZ+Y6HK6dWR7QS1rtoqKyGF2qBap165QUvodA38jGFDDv3I8vOqcPPBmbeE6AfYzX
         5cdzZ+3f93H+rXipR/MHg09UIbLAZcOR2wwEqcgLNCrmHZyVsSw7KWP7+LJRKP5W+8yZ
         QLPmoc+XBPvf5nz+YabN1PJ+bulp7JhUMAS0eKDpyDeqcSDflR7TtcP12RZfYXHnrTtD
         75uMRbMrdvi1GJBhz9Syc9SBJFMEFN4x3rDL7sGO1Y7vEsksPL11jqgoMbh1hoFx7y2b
         6+jZhAI9gXA2WWA4jwIDYr1TFD0zTdH4Mpi7EmraJ3b62qxibxq0qp8eMFVH4a1jtzxD
         e3dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780942308; x=1781547108; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ep5iwWlczkBtdvT0ueoldhn2n7yNnVgtmpFujFfNkgg=;
        b=VOzeiRdk1KnojBUbI4Q4spYN0loFYMm7+wM2pmzYMiXfYlC/INktsaz3wOh0h0+YqQ
         7vQN607z3XTTm4PQ6OONe0xoaUJuQ1ISDH4OmGBxlvkCct34fpTODuNSiUCuNuDAtJPh
         JMDjOMSYDN+wkGpQo6OEe1MjzERAV4ax1a0BVuTa5CkV1Z5XRVMY/k0SlFepPKCnRtko
         PkHKXyb6EgIAdntCHmHj33TdwDADZchljdy2T5VnGMJw0hlnWoXVvRcEJB9pA5bLCVUu
         O1dt2ZR1aeJRs88vnuv0chjK8HcXDTHReFScXro8vWVwXcFxxYJ+v602VaPLbM/dqc/J
         MwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780942308; x=1781547108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ep5iwWlczkBtdvT0ueoldhn2n7yNnVgtmpFujFfNkgg=;
        b=bxYH3vGbMsmLbh5I4zy2yqu9mS7NjUBCaUbkulA5pazICUl+3IlfA3diRKJQ19/d71
         24EmetPWglcLiKYlS0DZkeXBR6AR0//0TjcAYS7BVQq+l4kSj9USdhKwnHRpkNZ5s0o/
         KEIOduP9fkjOH6yTheWxsYExnrWkrwhKQlfFlaCiJH54st/NtaIsSMqCqsBf4+xC7YZ8
         fJcIMgoChIUJbDjRWMOhgPtc388elEJ2WSB5IRip1U8I91DioP75jj6g1oITes6X4Ac7
         xkD65C0kxsJLnRSwOncqTAqEe93Xqvrp116exZKdkx5NjMpawwDG2lTD2/TPqQ7UR/nH
         7G4Q==
X-Forwarded-Encrypted: i=1; AFNElJ9cvof5ZL7HDaS87iIcpV9m9TB7Mpc87LXK/GEc/HbP7pEL6N8/GmRYSzCYPTkdqXQenemJ4zXNxUjtG/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6DvkF2G8g2Hlqa0j+lPbB0Fzm5vQANy997GFV144JS/kbrS3L
	UF7sJe8Spk3E8PK3NUCVKd/bjacdakXiInL5bTI+WLBJB3tod+kpSTG3x3/SWUcKunCiFwnLpg2
	f9e6P9Ugol/AInJ4420aAr9le+zBEZoc=
X-Gm-Gg: Acq92OFpolCEga0auYtym2EnjZ8trw1haWeB46T0NizXadcfolHhOLFCwpLNIdGF1Qx
	TKn9LCeX1XDn3mcJQF0ftmq5RWWh86n05ghYPryFdohV1w/swfsyqQitzirdBOdbG1dDdhTHMB+
	xhKeewWNuaN7IJNec8CXSbMsnr9tllG3IutGaomDWOVBYTvISTkzGU36zLvrmhSJrPCiE1ixt47
	foy7Kcw+Ej+9YRIupMX1SQfafGnYgEeF7DNKsfO4isKVWanv6a4Z272W0MYaWP2qmqytaZCk18A
	iY5csAPiQ+kx3y4=
X-Received: by 2002:a05:7300:3b06:b0:2ed:e14:e954 with SMTP id
 5a478bee46e88-3077b8014d6mr7984972eec.30.1780942307519; Mon, 08 Jun 2026
 11:11:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260522050740.84561-1-ebiggers@kernel.org> <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com>
 <20260603050557.GB18149@sol> <20260608173921.GA434331@google.com>
In-Reply-To: <20260608173921.GA434331@google.com>
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Mon, 8 Jun 2026 15:11:35 -0300
X-Gm-Features: AVVi8Ccuf9-VZpieD-CilJz3X4Bu-AwhKT-kdmFxIlO2MI1v6r1hS5SlD2UxAzQ
Message-ID: <CAB9dFds7kUSMRPAV_BGZ5hGYd-yPq3YziFW5VTN7FgXTtHuhZw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org, 
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 2:39=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Tue, Jun 02, 2026 at 10:05:57PM -0700, Eric Biggers wrote:
> > On Fri, May 22, 2026 at 10:06:49AM -0300, Marc Dionne wrote:
> > > On Fri, May 22, 2026 at 2:07=E2=80=AFAM Eric Biggers <ebiggers@kernel=
.org> wrote:
> > > >
> > > > The FCrypt "block cipher" and the PCBC mode of operation are obsole=
te
> > > > and insecure.  Since their only user is net/rxrpc/, they belong the=
re,
> > > > not in the crypto API.
> > > >
> > > > Therefore, this series removes these algorithms from the crypto API=
 and
> > > > replaces them with local implementations in net/rxrpc/.
> > > >
> > > > The local implementations are simpler too, as they avoid the crypto=
 API
> > > > boilerplate.
> > > >
> > > > I don't know how to test all the code in net/rxrpc/, but everything
> > > > should still work.  I added a KUnit test for the crypto functions.
> > > >
> > > > Changed in v2:
> > > >     - Added missing export of fcrypt_preparekey().
> > > >     - Write "RxRPC crypto KUnit test" instead of "RxRPC KUnit test"=
.
> > > >     - Rebased onto latest net-next where decryption now happens in =
the
> > > >       linear buffer rxrpc_call::rx_dec_buffer, simplifying the code=
.
> > >
> > > Looks good in testing with our kafs test suite, forcing the use of
> > > rxkad with encryption.
> > >
> > > Feel free to add for the series:
> > > Tested-by: Marc Dionne <marc.dionne@auristor.com>
> >
> > Thanks!
> >
> > If there's no more feedback, could this be applied to net-next?
>
> Any update on this?
>
> - Eric

Looks fine to me (and in testing), I wasn't sure if David had a chance
to look at v2, as he was away for a little while.

Marc
