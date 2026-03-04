Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DED3542D8
	for <linux-crypto@vger.kernel.org>; Wed,  4 Mar 2026 02:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772593142; cv=pass; b=RRrS6RgFABzhZVrg0w0oHKufrF/akKv6HrXpy46rktmDkyzWp/v7hUU3SKJXZHbTJjUWMbR31MIq5oR0RofzaBZ9vdLIUVpZGF1CkpxdoNq13e+j8amU63ClNjnSbU7bWrAFtlPv6tWBfaeRwtEi4dsRGJ1q/dCrGGmdsp+Z7c8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772593142; c=relaxed/simple;
	bh=zKM6EuG/p08waYJ2nHV56Gzg4x1zITq/xxo+w01zNwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BzZIPP17VWb0B/PscHKUlfudcndZJlw9UEjud9H4hGEFQLPn+7aFtaWMmKdD8h0BZhlASD+IrpoaiScPTYaJ9rJuaKD7SA5Edo8mmZjzN6vOlXp6bW+CT1auAepjmGlkfjzH6RY9OF6OG64wvz6dtpt9drLEPpxLSpUHA/l7XOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHa3MaJN; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHa3MaJN"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5069b3e0c66so101394721cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2026 18:59:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772593139; cv=none;
        d=google.com; s=arc-20240605;
        b=JW8bkWjUL9yuFNWBdooVshet+r7XJiG8mzjf4Frz7FgxiHvWkdKOitg2PuVNfDbwnn
         jxI47fEbHhBX7JgSQZK9gS/OwPA+ETqZGq4k3DJp0nWQ/IeMRrQx1a3If3le0pRb7KUz
         5XLj8woXco7sy2i825nDiVBuJ7kpgrFJRw7MzB5/OM5SCXww/Mz+9K1AsautinmKqPae
         8fSX4v3N15mU6XxAlFeG6Iz8k7tjJGdcSejvx7lE9O7HCtbUm71npmKPehGUFwKBYzAQ
         5N8/xiMZ2I4nZ9ltLYEzwNJs2gYSp1f5DRmc1MtnraaKx353Kw5SrADjYFqvpdRm8tL7
         mLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVj5WUNu9TPSYD5sj9qQF+48hWTkAcgHwSgxIiLsvcU=;
        fh=Q9Fr+hLG/uBm6/dbwyPEh288K0HMOuqEvRiDXRcgQJw=;
        b=cGNh2f1lMC7zRkOwDb6Af1X58JdSjQoOvNlf+8s0mPFwNoN8Tk8s7aAqzBbQcyx2Ry
         tyCKTxB6LPuq3B4uIPo8+lFlyV7V5EwDx3r7jpyuREryj3TaLjMjPk6S0tCDnuR4wlOz
         xWZnLsRcOUB6JKLTxsbVKMInKiVU4JiOQFBQSxBQlOBQZDCDpTPdu88hgPik1dc+xwcY
         ELIs8HBXQffCji/TjNLfA79Ztx9STUBmhFIm4/38IYher8cHqAdiJs+Ar2vSbkszbMbB
         4RtmxQLbdrwJoS2uZk0p/kyLDTkQ8b/r7uzcTDRfz4kxhpXpper62ayBoa8vRi7HZLn6
         equQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772593139; x=1773197939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVj5WUNu9TPSYD5sj9qQF+48hWTkAcgHwSgxIiLsvcU=;
        b=nHa3MaJNiZ39Xglg5yrpCr6keC9Z/LMxfDUcQmNRji6wi4dNI+g69hGo00U1iH9A9n
         EZDOnVN6aC/GBXJUzE+lSNhN/DFXjGQg8ll+uIODlg3mBKidI12cd+1Xc3ZQZxxMOb5T
         3pPm6O8vLK+2IScQ/R8BkhShR7/B9RuVnM9U8ZQ40+UsuVle6RZNd7ajCRDelErSX8il
         R4+w5F4M23s4oB9BX5XDV11Ue4SQkx8v5Wjz0RN5mC9DPtdm6arli389s7iSgm1COd3V
         n2TIWCku+ggntGuhnWKU2FvIUlGHs9qhPLcg6fCEg5ThhTSmfPI+SYAr2+yVRbEuX7IM
         Pbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772593139; x=1773197939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HVj5WUNu9TPSYD5sj9qQF+48hWTkAcgHwSgxIiLsvcU=;
        b=K8ddeC9wNImhSMokpDYbD+QvSXmQO2AS5CD3XCnvfxMk/D93pvbTqfFOHUK82lQ+uV
         ib5QGGghJBdH3vIifE4Xx83rTuFGUBTN/GkKKl7G389OH3eMKj+EpBMaVxePw1uU0Ww3
         N0NHTPVHfH1+aqpAzE3HBH7T/UMb6bJquiygJXuw86B7/8p3NZybUgu/jqNI3EdTxAsJ
         Fh7bXTUmVIWT9ZbbI+jTlkMDaNM8hieddwVzaU20z3CtsVj6woMbkY8eI0vSfv6FNl/J
         iGdzSsWb9SKm1+3k/0wMreWwCKJZllbRY6QVkM6EgBm0Pe3NpOYyiNPPkOIrXIxzevDq
         Fcqg==
X-Forwarded-Encrypted: i=1; AJvYcCXh3+YDY2RO5OLW7BPKoSRgvwk/hGtu67njzNPiTOW2muamRBlRSpoG6gHljLcVbfqyhsVv142wTddDOfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO96yhlwlFGm3hfmBWeQ2kR7cOX8M84jFcEUAVFYWVVG58aP/U
	Hs81qWmxP6dJV4N1wpb1+2LPmIfkfLIJEi21eZFLcYzMbJ0pgftuz8xc6fWQ8qly1d8fyrzxOn4
	OGlI9Q+wxuYbOyAc4Ily0KCYCz0ArZlU=
X-Gm-Gg: ATEYQzw2G9N24zcj1E+sgU8z5Z3rQlDr9STuIytRz++FoBKtB5JobPoDh7W/syQzba0
	gK48uSkvqq1GMNkhrk1svwj8gnU5yB18TDzd73t3MlVh9yORAtSO0VjeR4SzWhRVt7qOLAwlqkV
	I7JCcc3VNaCAcd1YH+CjgZUHSycApEWoZWvakstbISLotrC81/BWqxL8avQDKfebhRcQhgA817S
	TPPcjvP9jqOKolALZ53i84CP75InElC33Ps86Q7gXT/keqgsIVsahcxJ7v7VPIN+9CYG+bH2z7D
	1cWdD5KFN6iavKyeFEybu8jOkd917bJ1xPFQemJvEyJPu1mXHPprUyScQkEdbB7GSDfg0Yprw+t
	qvuGF4tkehhgoyp4573CcaR2MNtIIM0nls/NyVcEnXgbTt6H8zQQNCWI5Dn9xJJpqMqtfEZiXBD
	QUjd4ujxD++G4yFEcKQB4OHA==
X-Received: by 2002:a05:622a:53:b0:501:46b7:401b with SMTP id
 d75a77b69052e-508ce9b1e9cmr50583111cf.15.1772593139466; Tue, 03 Mar 2026
 18:58:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218042702.67907-1-ebiggers@kernel.org> <b3b9f12347367ea4f0ab1f255e79cf35@manguebit.org>
In-Reply-To: <b3b9f12347367ea4f0ab1f255e79cf35@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Mar 2026 20:58:47 -0600
X-Gm-Features: AaiRm51JuVXJWtCFDs_Tw4S5B-GhRlIEkDR479pURfiq3nh76oTAjTjCjs4_wiA
Message-ID: <CAH2r5mu+VkO8rSL+CWWDR55aKRLaiAxFp_G5PAfQsssK-Erm-A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Compare MACs in constant time
To: Paulo Alcantara <pc@manguebit.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Mar 3, 2026 at 10:24=E2=80=AFAM Paulo Alcantara via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Eric Biggers <ebiggers@kernel.org> writes:
>
> > To prevent timing attacks, MAC comparisons need to be constant-time.
> > Replace the memcmp() with the correct function, crypto_memneq().
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  fs/smb/client/smb1encrypt.c   | 3 ++-
> >  fs/smb/client/smb2transport.c | 4 +++-
> >  2 files changed, 5 insertions(+), 2 deletions(-)
>
> Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>


--=20
Thanks,

Steve
