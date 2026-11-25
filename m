Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642014;
	b=YR6F9kXDnCDbBWMvuiT31eB5zvreXfCb6c7ZyY1A4uc9/rIUHFADaU+Dq30vWpHB4nYO
	 moUPE/DUrtKtOltzsuLkd/ag81plAX9v/qGG1COZUjHFlyfOfTOHrsSSXvIR1UxSD0c9M
	 ARJ9KECx7Dd/aahVcYR1vgKFeNIprjgSetmFi1gNCX1hZCMJWNjSKYFBXNt/OTZeaqkpV
	 Y8dRFSVlo5WB15k8Po8s1ubXQv5150RchbeYT34rILV3NhweygmkCSl8XVmvb7srB7RtV
	 Y1itx7QErtWcEJpYUm8mrS3d3WB51CZeUkNR1Yhx3bKze1YVeC2S2uLM+hEyTGdgZog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TvrU0wA9nQ8NmkHqlIbwXmklpSSQk+6g+lOk6duGUaY=;
	b=dRdnwxte0xFexdiyokxJjx7foOiD/PZWzyfhUWpCEtD0PCiAkQhBBMtPiJsrmOUnKiIA
	 +fet+J6dpYI11Wdpl2MIfNSnJgBBmWrWxmk7/f/XPJRuUeWABRV36Xhy4Lxyf6hJJgamt
	 ECaQJzcYPcjz7nYIB2Ym2UBar27a88nsnqj12M3Rd/Ht14OVsPgFqgUKIgHuZlNalg9ew
	 DSCktdfliPCKFOBZfTNG3TsAOW3cxt9uVR8NOsMUhwPI7V9b05LjURWo1FnCOqcdCusQT
	 gIgpzunFsnugvY2CYR9YL/+PtpPHwLOBbOZqNoLcleJfsRjBIhTMhxKTY7ruS8XNISg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=khbHvIZS;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2EB606A338
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 21:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A2EB606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=khbHvIZS
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso59292015e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 13:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642012; x=1796246812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TvrU0wA9nQ8NmkHqlIbwXmklpSSQk+6g+lOk6duGUaY=;
        b=khbHvIZSswKzRKScFBxEP5dKyjo1fhxkUl/Tm9a7vooLiIEIc3+D/8+f+l2qOQAqqt
         NkhbUqa1fNS3fq7OMj0WJMaJl1khGxmmDggv3i+SWU85FgAdjmbQ2zLZepZPts3zxApM
         +6QfPBplV6uwffDVwMTmMBw7k1e3de0G6FQe/sfuWrH5Ds6lbEvkXQTXgjHFZ3p+bjez
         1kr4qDOVCP9dTt5FKMHZl8AC9yxsqKbDOwSROd6mExDAJeQ3K3/NchHUz2ApoMTPzZeQ
         /uhnbwnb7ArGmTHzNkayy/FGQamuBbJ3FEoi6BqwxfvCMlyHosFKu+w8DEKRCPmU15eV
         1whQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642012; x=1796246812;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvrU0wA9nQ8NmkHqlIbwXmklpSSQk+6g+lOk6duGUaY=;
        b=nxDABTRPduCZY7O2uKstwX3j1LaQOnalG/4TJYlPjDk6lFb/CpeTScYde36yFMwJ4D
         B8cdZie6pFy6ediC6rvPh/VeeuGAFqgWEpaEI/yIpY3x6YoKf5nPgtyBpTK5eq8Fhsek
         2bT12pOMrIF3ShnLCn6lKTGmz6ZOntn8EmokhYt0fImgmKExoA+P3eghhxXCbHiFoaxY
         BCDMQx7kbR5guKigFxiq9sI0RNQl+BhG1cdpgyumiq0RnkiIEUPRA42nIRvzzMULDTr7
         UZpnXeaoE/QeAtuqd6gIbixZ4VcckWG4SwlMV8SzbDYj+JBE6A3yylRUi5hpMYWpIQqx
         Nb5g==
X-Forwarded-Encrypted: i=1; AL+hErEmZ/NJVlRcT60jv0DWQZcgLjZENOn/nvHgO3FJA2L0o0yFHCIm6SS+l9dZrmO1heBuWciWUX1iJyODeTc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9024X9zGlCAsaEVcw6+tgiKA5ObGI+FXCcDKV07+M3LRAFSF4X
	xhbSKVOzhk9h01jLIhg3tdKp6WaLodt2zH8zmE/Dcr7/3t1kvLTnA1Ey
X-Gm-Gg: AZFdTZeBpzMmSjeEkPAmJ/3EC6Fn/IGrRRWFeEsm6mrKQBxhh9+HKXd9FA7L0bVT+Hr
	nsfP0+VctGOsaoLRVuLyx05QEgS0kute7F3gSQ46qS0MB4pJEgn/nr0OhxmsfDMu2rtPZXMB/OU
	rht/l5uXQN0LSKBuCZbzWLgPLjJao5eJH8ct7UW9mB9z41fXKzcB0EwbSPQF5dK87uZqieD+Jk9
	uOjZsrDcfrw3yb+7jwrEqD3uJ1hyQh6njXWU/FILLF4yMHhtaiGjZ69po7A+J4IKmkdIDGAdTu3
	2mGcqAWUos0OsGxq/unHgaR/by+aIkjbNIQA9AJdQEjFjFJuzedP7//DxsF4SP/rTx9rp5YxB5o
	NfUmDyX6wECGFYpk0PAHFUVJYoSTd7rL/2PLT47Nbq+RvNai+Zmttw2/vM7Es2R3CrIWNU4V04k
	HjBHJxILj4wkKquFUPeJ2CAsOCQiH3jCSuhsiec7+DQjWb4RXbV49TKuMV3OLQrwAEXNdZrrHl6
	+qFWBjWqT/jTRQXn5XptN1pKS2F5gf1SKw9XP0PoShv8jfM4Bssno4pQgbG2fzJfKoCn0Bu1qDX
	CV9qCh2cFE3+Zmtp3np6nx4oz1MfRt9/ThlrRB3BPEH9NtPlx3deX5o7z1ZYEDjSNg==
X-Received: by 2002:a05:600d:82c5:b0:4a3:5aee:2c25 with SMTP id 5b1f17b1804b1-4bb88822642mr433032475e9.31.1795642012525;
        Wed, 25 Nov 2026 13:26:52 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm310815745e9.2.2026.11.25.13.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:26:52 -0800 (PST)
Date: Wed, 25 Nov 2026 21:26:50 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, Ahmad Fatoum
 <a.fatoum@pengutronix.de>, Alasdair Kergon <agk@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Gstir <david@sigma-star.at>, David Howells <dhowells@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, David Woodhouse
 <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Ignat
 Korchagin <ignat@linux.win>, James Bottomley
 <James.Bottomley@hansenpartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data
 shorter than MIN_KEY_SIZE
Message-ID: <20261125212650.479bea7c@pumpkin>
In-Reply-To: <awcAeLUROL0l_g3X@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-2-jarkko@kernel.org>
	<20261125090930.698d8f1b@pumpkin>
	<awcAeLUROL0l_g3X@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Nov 2026 17:36:24 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> On Wed, Nov 25, 2026 at 09:09:30AM +0000, David Laight wrote:
> > On Tue, 24 Nov 2026 21:40:35 +0200
> > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >   
> > > tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
> > > bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
> > > 2.23.133.10.1.5) blob.
> > > 
> > > While kernel-generated trusted keys ("new <keylen>") and legacy old_format
> > > blobs are at least 32 bytes long, external TPM2 tools allow sealing any
> > > non-empty payload up to 128 bytes.
> > > 
> > > Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
> > > bytes for ASN.1 TPMKey sealed blobs.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > ---
> > >  security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> > > index 30188a0ec676..d7336f25b514 100644
> > > --- a/security/keys/trusted-keys/trusted_tpm2.c
> > > +++ b/security/keys/trusted-keys/trusted_tpm2.c
> > > @@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
> > >  	rc = tpm_buf_check_hmac_response(chip, buf, rc);
> > >  
> > >  	if (!rc) {
> > > +		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;  
> > 
> > There is no point using u16, just use unsigned int.
> > 
> > The same goes for data_len.  
> 
> Hmm... or just int?

Unsigned int can generate slightly better code - especially for
array indexes.
I sort of prefer it for values that can never be negative.

David

> 
> 
> > 
> > David  
> 
> 
> Br, Jarkko

