Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30D9394464
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455226; cv=pass; b=eakxRU9ScvbDDGgHkxY61oAVHM9RcupE/19xmNMKdGnlHsRaDW402zI7bIj2OxO9W/XojmZT6Y/NQmloyS97OjzSL4OoZgPg6clVonRrHDGhhaGvJHcmDL3qG4rngZDEdxNkvOSSMqPWAYdhpePrxWVz57Ph9RUNk1HMdrmnc6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455226; c=relaxed/simple;
	bh=KSaEuSw5cR1Usv3Ap2kysrOBKocVC3XD7neTS3R/IPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AF6RhJlD3SN+UvixvLdzXEd/c6tn6D2+npYoE6giFlBhGhmqa1r+nL0z4oS8SUqlh8jc6KFUjw4u/bcmuH36gONi6Hu5CPx9ed6IX98xea6SldNYjgowJXteU9snHY9URZVUAiy+2dkxWagXbA0DNOgOiZ5EPU6cyb/DDsGpvMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P9A7CaI2; arc=pass smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9A7CaI2"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2f0d3e07e30so24294919eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:07:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779455221; cv=none;
        d=google.com; s=arc-20240605;
        b=Dwyx7dNtM8KAxMXphWhaeD77+gq1p9gcYNiTcd0m6noElBQqETSPHt5H8bzMGgHsON
         406R4GoVCdpnRAlvio2CexesXiYPSmEqjgIU9WPYDP8nPTXod1yHtN/d/3vWCp98sy7m
         sesoP0xTnPT2ajw2J4ZdFwHgutIUWKoJD+sQd8rBIXI9Z53ZgE84Pqr1YtaiQ2D+YRZm
         z3k5VYRRvigR2K1lGXZ+nblgT7+H9EeMFXsNkM5DUy/yvi+MwjdQOORNUnjx+X48SWkO
         O1WrT1wMI6ViR0EjWjPC67+KsbtEXwSwYWN14BvyOGF3gszGE7jJUHL8uM/e9hAJ4Jmk
         xcHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CcNLzQ3SzJG6lFwMI5fOP1EQlY9tsnZa9iOPM1rLiDw=;
        fh=DZgmQwfNX6ubBkqgazbrkxpteAVthx1WqkT21gzmhFo=;
        b=bVeowQPH5FwOoeGGSryOTECBUKhajtUcbfFnXcxYwPeVAVgIaJXW/ITUpuK3lfRpdj
         av4zLVGjLn/WQh1zj0Pldi+szr18cn7BqXfYFqSwK0yQ7IMNc2vQfIKvCAooo1LuIGh0
         l7dcmLyybs+vE5yKFNSDRQ6UHZp8JzTljO5NRMzEV1EWsFfIFQbjcF+kOG7wTReoDGKv
         Xf0+UbxGoD3xC4QWMCbxwt+01yBS2LQ/D9YU1HYc7Kh5Bs3seR0okMajk+piBW7S/oLa
         VG1KM9ElOADjWgElTpKCMksFnNSd37UidiQkUD4nkm/ringgO4exk9cSRyn62MbAD1Td
         ApCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779455221; x=1780060021; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcNLzQ3SzJG6lFwMI5fOP1EQlY9tsnZa9iOPM1rLiDw=;
        b=P9A7CaI22mUVV3U28lqerw1m0d4Y6HMGao9knxTwtWeqClNZR3tBoY2V7BF93+TWoo
         1lqACz5OhiiBXIAzWlg4rv+Q+J5JOOvLjzsFNFzkM7209e6dLvV9aYClRbTOmVSE3bry
         Gk3jzadmvOHSEriczW1yFwHnnhI9XrYDdUn7RLi6rxVktFIH6ne0FapXjr0WyiyLki1Y
         1MECbNmc1Yyx9gaXDROmJVwhbbhNH/9mCpwi733aWSiTGVJRb1vrNE5gx0JxjK9qBRSx
         8AO45+5XjKV6+2qP+/ibgq/HtSbFrGDyaSrvvi/H7ytGGh4a40BGiiZKgTrcg/pCoXF3
         HMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779455221; x=1780060021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CcNLzQ3SzJG6lFwMI5fOP1EQlY9tsnZa9iOPM1rLiDw=;
        b=R+C0WiLkBMhL4m7cszY+H16l8vAY4fcn2YhLF/xE37lb2w4nc2H5jW03AUK+zpMdZF
         GvGndudPJJJjZhWGOGtGBpUS1ZyLR6uD+DEEcmr/2hsdt6Y+o/bJWoKubtOkqbzknz3Y
         I1Z6BP0Y6sQh6rDKpIYiMsuUPt0jrxxf+061oyYQLVTlFkyug70DyskTVfB1X/bEleW3
         WSZ4rIK4VDER3Zqc4GtvXn0tOmoEDCU7jNT2LgM0ddFYw22r3iIFaF3ti9K33sYjTuk9
         h8o2Phq0HcV27C0CCoGgURMhYN2A8GWq1g3U4LG4YyrcVSdXEVt3T1eoMiI/H4O00fli
         Nf/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9w5Vh2xX2jK9BeDrYnDFrjbolYkMqeSFuFYxX2haNWr8JxOORFWttAGZjMXSRbrYRAAQVg4t5ICEvsWBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YytUdDwF7xx1ic0Pvd5xKF9yu/LIW8FXRSK2HvwTovl7yPffIm8
	uZEA/ugHaa55aQnuk+uDvoHy1JM0dlNzcTj0HG0RJiGkvRkOrE9g2sgTAhjusFX1vbB9opzZxea
	ebt+Zt+qG1R0jLhGVp5RQoUXDP2z8tQY=
X-Gm-Gg: Acq92OH4sL6culk8U3F8vq4LuYLJ+FFBUkRDb8EvxbpkJXkTXtp7IR4ZweSrau1fQMc
	30BC9QIywl1FVLZuyhjV4bnnM/j3VTmy7mvtgOFyGekkZJNlsK0xDj3JANaPgjyS0p3USHUnY0M
	98Bff6B5zqdS9JYcGBKWRMNxK+6g2apiTFpktp3SP0Yw69GerjAzFuwdIlqLMjmTH3oQvgoirDF
	CRKxGCPhIv0q9gXrnRP6f1ykxdyJZoSb1bWccAWMkopFkCKzDQxiSkC2iHqIKfz8cThXFn1s+GG
	D9lA
X-Received: by 2002:a05:7300:f196:b0:2e6:e504:5435 with SMTP id
 5a478bee46e88-30449001bc1mr1935099eec.12.1779455220962; Fri, 22 May 2026
 06:07:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260522050740.84561-1-ebiggers@kernel.org>
In-Reply-To: <20260522050740.84561-1-ebiggers@kernel.org>
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Fri, 22 May 2026 10:06:49 -0300
X-Gm-Features: AVHnY4Ixi-OiYRQba9g6693g6xpVS_YTTM4oneVGXagDX2SEqWexJ-_Aw02uq-E
Message-ID: <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org, 
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2026 at 2:07=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> The FCrypt "block cipher" and the PCBC mode of operation are obsolete
> and insecure.  Since their only user is net/rxrpc/, they belong there,
> not in the crypto API.
>
> Therefore, this series removes these algorithms from the crypto API and
> replaces them with local implementations in net/rxrpc/.
>
> The local implementations are simpler too, as they avoid the crypto API
> boilerplate.
>
> I don't know how to test all the code in net/rxrpc/, but everything
> should still work.  I added a KUnit test for the crypto functions.
>
> Changed in v2:
>     - Added missing export of fcrypt_preparekey().
>     - Write "RxRPC crypto KUnit test" instead of "RxRPC KUnit test".
>     - Rebased onto latest net-next where decryption now happens in the
>       linear buffer rxrpc_call::rx_dec_buffer, simplifying the code.

Looks good in testing with our kafs test suite, forcing the use of
rxkad with encryption.

Feel free to add for the series:
Tested-by: Marc Dionne <marc.dionne@auristor.com>

Marc
