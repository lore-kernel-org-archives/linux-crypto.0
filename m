Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949437997E
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 08:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774947417; cv=none; b=dbcpgYhQcc/isPstmY/KnGgid2j+6TkZksXfd5fVR2KmCNepdSsPEqI0bia7VmhgLdrEhgVvIGk+Bmcij5yzJ7Kpfb5VX/RuBP4iPtgYXifEkDgorLEXBOFvCASJCedF/6dcE11zSTonYUX5oOvRzLkeUbi2K6rTlYJhqjxCotk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774947417; c=relaxed/simple;
	bh=NfCIvD9EKCBGG09dklHcwf400e4LoX12LOmkMPlap6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rPSU7uk52Q5h0TzVA2XOtXmS8GTHE/I3h6jSn+ppDQ3wJexz2byAaK7p8u2ikHCAZi280JihQNeefM8YUPZbDHG5YJ0uaiqFDkrBYWTPWw8wA4rG30P7zFjiUnvlpWUNR0uTdODdf2jOpFdsIFHHfOY39XhGAS8irdT4oN3+XEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso740267366b.3
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774947414; x=1775552214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fkKySBZ7X7iczOeZdeOY7AG3jh/Ec5V+U3FeSPchdFc=;
        b=bnX6NCkkl3drUHACwrU10iC+VIQIs3D7pg6d6Ds2ykOg2eTfevFMywQUATfwPYZHvO
         RY5qbQR10sv3dX+vWuL0wz2DkEdSXTM4YYBMKSL9M8x319P+BlQ4fO5H7wphBZUob0Ei
         sOVs96XzT7GB+Ex0BaI3MUI0dGkzEFaCaxn5rIJ/7VCOmSy6oornzs97qp1+ML8FiTn0
         y3dPJz5ZQVZGwhE3SpY+cl5gMeS92qJt1/Ik0w16e/hmBWDlmE4O8kW1Uzxda9kAdRqM
         Z1JPzwZBefKOjmY9eSeJSvPYirOtNdf7fcXN2lcmhEp8D/UafWToQENmzmVKjUqsAOHi
         QJiQ==
X-Gm-Message-State: AOJu0YzNmpM9+2Fbvf7PCAMLJsAZEceypUPrf3Za18XPUbioCiFdyIBR
	TCAvisIbR6tyYbZQfm2BZIpF8+Z/y4k9jbw8DQXqfTbySdDKchbU315nYcAI/BMjfSg=
X-Gm-Gg: ATEYQzydUtgAJ41kmhUSUJIL8BsbMdQqRr2280LCxwBUKrRONdUbennCd7TPN7AVKHg
	F8W6EjFL4XwT8MoYkT4QAorLpKBxgMrIgkX5CjvQkMnS7OaMrHV/ymiogDFqi/WWawuijIppcrs
	kpDr0NIJoimS1DEg42M5kcj3OLfYcJCS2eJ9pMuUguRZvSfaHeIZo0ptoF3fYrlMDp6M5TskfJO
	1cxPHN+0a1bTiLCaqxq0lntm1/90O7fKLxhzBivA4HnpxvvBo67YcphPGzUyMM1txSoWahbKgza
	nq5KPRJJrvnn1a786HAuwidU+Ge9adCIblFrHCCcgi8SbAdnuugF71o3WwgILp3xsrNtvW4SFJZ
	wPzQJIx3WJwyPtpwOpC0AGUumcMA5VN3aENFnSAr/KvFbjxsvHGDRnxhUyhQSRBbRWMPerkx8cH
	UOTQmxkRX8NgY7vFd6kxQ5iabcHKkPpv1+D72QooF0JGCgTikPfdH5lw==
X-Received: by 2002:a17:907:846:b0:b98:51d6:883b with SMTP id a640c23a62f3a-b9b502bee4bmr1082896366b.4.1774947413429;
        Tue, 31 Mar 2026 01:56:53 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9b7b225193sm382246966b.57.2026.03.31.01.56.52
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 01:56:52 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b9b1df1a6b3so613478566b.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:56:52 -0700 (PDT)
X-Received: by 2002:a17:907:3e07:b0:b9b:207c:f7b7 with SMTP id
 a640c23a62f3a-b9b502bd373mr1030630666b.3.1774947412225; Tue, 31 Mar 2026
 01:56:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALPOzVkz5dzdOTJyWGGNyQOuSG9d2fhjdL2cLSvAOFXFA80bLw@mail.gmail.com>
 <actCBln9jaznIovi@1wt.eu> <actUQV7g8uy6Ta4C@wunner.de>
In-Reply-To: <actUQV7g8uy6Ta4C@wunner.de>
From: Ignat Korchagin <ignat@linux.win>
Date: Tue, 31 Mar 2026 09:56:40 +0100
X-Gmail-Original-Message-ID: <CAOs+rJUy7CUoauGnrwZGw3PyzK2ZS+gfgk=Bx1SMx=qLWYfvXw@mail.gmail.com>
X-Gm-Features: AQROBzAISIosIxRDNQhTYd1AR4DPMA5fuTfo_Rz0XqVSko_UZJUuFr6Vd5lr2_M
Message-ID: <CAOs+rJUy7CUoauGnrwZGw3PyzK2ZS+gfgk=Bx1SMx=qLWYfvXw@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in x509_process_extension
 (keyUsage / basicConstraints)
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, Willy Tarreau <w@1wt.eu>, 
	Leo Lin <leo@depthfirst.com>
Cc: linux-crypto@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Cc: linux-crypto

On Tue, Mar 31, 2026 at 5:57=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> On Tue, Mar 31, 2026 at 05:39:50AM +0200, Willy Tarreau wrote:
> > On Mon, Mar 30, 2026 at 04:10:51PM -0700, Leo Lin wrote:
> > > An out-of-bounds read exists in x509_process_extension() in
> > > crypto/asymmetric_keys/x509_cert_parser.c. When parsing the keyUsage
> > > (and basicConstraints) X.509 extension, v[0] is dereferenced before
> > > vlen is validated, so a crafted certificate with an empty extnValue
> > > triggers a 1-byte OOB read past a slab object.
> >
> > Please note that 6.12 is not the latest LTS and is more than one year
> > old, 6.18 is the latest LTS, 6.19 is the latest stable, and 7.0-rc is
> > under development. If you could confirm that current versions are still
> > affected, it would be nice.
>
> I hereby confirm that current versions are still affected.
>
> Patch is below, in case Leo doesn't want to craft a patch of their own.
>
> Thanks,
>
> Lukas
>
> -- >8 --
>
> Subject: [PATCH] X.509: Fix out-of-bounds access when parsing extensions
>
> Leo reports an out-of-bounds access when parsing a certificate with
> empty Basic Constraints or Key Usage extension because the first byte of
> the extension is accessed before checking its length.  Fix it.
>
> Fixes: 30eae2b037af ("KEYS: X.509: Parse Basic Constraints for CA")
> Fixes: 567671281a75 ("KEYS: X.509: Parse Key Usage")
> Reported-by: Leo Lin <leo@depthfirst.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v6.4+

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetri=
c_keys/x509_cert_parser.c
> index b37cae914987..aac2d55345a9 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -584,10 +584,10 @@ int x509_process_extension(void *context, size_t hd=
rlen,
>                  *   0x04 is where keyCertSign lands in this bit string
>                  *   0x80 is where digitalSignature lands in this bit str=
ing
>                  */
> -               if (v[0] !=3D ASN1_BTS)
> -                       return -EBADMSG;
>                 if (vlen < 4)
>                         return -EBADMSG;
> +               if (v[0] !=3D ASN1_BTS)
> +                       return -EBADMSG;
>                 if (v[2] >=3D 8)
>                         return -EBADMSG;
>                 if (v[3] & 0x80)
> @@ -620,10 +620,10 @@ int x509_process_extension(void *context, size_t hd=
rlen,
>                  *      (Expect 0xFF if the CA is TRUE)
>                  * vlen should match the entire extension size
>                  */
> -               if (v[0] !=3D (ASN1_CONS_BIT | ASN1_SEQ))
> -                       return -EBADMSG;
>                 if (vlen < 2)
>                         return -EBADMSG;
> +               if (v[0] !=3D (ASN1_CONS_BIT | ASN1_SEQ))
> +                       return -EBADMSG;
>                 if (v[1] !=3D vlen - 2)
>                         return -EBADMSG;
>                 /* Empty SEQUENCE means CA:FALSE (default value omitted p=
er DER) */
> --
> 2.51.0
>
>
