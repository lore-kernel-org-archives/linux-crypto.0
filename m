Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597779;
	b=v4Ugk+rQ1/W/f5IYo1SxiFEVeadUC8mCwxTvx6t8EkJqxRX3Ch5R0Dqyv/TUIVzggPCY
	 Na7PFqYjCSqMK0wXvImVpIVfB5sn6WLkqNLDgMyanhVvQhrmBGwaC0/xlYZO5pPFNd3vU
	 8nW9uGiKaYgxZsRSVFJCXxc/Pv5di8J7VxWRHmi8g5XPSa0QLEyhGeBPN7CRDjXsdJKWt
	 QyZnicyocWI4bh9GMHkRwzH8pe5oqQHCU18zc7tTbmPu9hKT3BTjRLmuYOrIKyKuTcD48
	 TvKUCl5mikFCNVrMeTVUZpBCbokz48WC8WVnzfB61b7F494VEOI5C37OVl+QVvN1B4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597779;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qm/FI2mE1ewe632JTFSK32XwvOS0GNyWzPRE758QoDs=;
	b=dc5rZkMx7gi9Uy793J09NF0TykcKcwpdI02JkkDY7P5eT+gcPznCm1QCg164aTuW+/UI
	 jiWXzb4q0qbdS1weO5RQAG1KRkYzVzmkC3fEzgTqYceMCpNQsD7mmsYTGJVMYTDYcwsyB
	 1MK06khCFkyH7OaJQdKu4MwNDbyuol26bSYnF8eaZ+C7S8OSkCIkzFS6yxlGZST+BPbMM
	 bNdujKC/3EgpB0ZcRDk4JGYRcOYeFy6bnkpkwoVN5OtL1W5M9MsLO0lLwdVegrkmasTo4
	 2ggGFln8U7wuIOx20WyOFN5Jw8qXXm0AHJeGFdBPEDTZUEeduVtvSLZGRss8LfSCA/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AGuiiqVQ;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E247606A331
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 09:09:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E247606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AGuiiqVQ
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb61185057so35417055e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 01:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795597776; x=1796202576; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qm/FI2mE1ewe632JTFSK32XwvOS0GNyWzPRE758QoDs=;
        b=AGuiiqVQqunjoBCYAQf0+aaIX9u8Idwr4BsqXiFG1Y2GXVcd2nGAwNB2bzu0OZsqvt
         JBQWV39Rzw0Nejmv3JjqTkzRxtSB81AvLEnWqd3BIlVhavaIMQto0Hj4ItwMuVJN5t9m
         qDDTsY+zGckYze/eL0Fh35Cvy9GGXbsePdi8hxB00PegW5V2xSwtYpgnQ+XID8ik3L5c
         ETRwW6xnMEEQ916w2d83q83ZxbDdUag/69/1p5CzvXoFbS+9l6yLn8rKodkjDPPM+Rpi
         9t2xYHAx0GtrAFVGzYv5GsoMxIqDShH+sPkkV4Fh0S/+l/GBUcpTn7YbFICB2vlEmz20
         X+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795597776; x=1796202576;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qm/FI2mE1ewe632JTFSK32XwvOS0GNyWzPRE758QoDs=;
        b=Y9l/5Ci1J48cRw46Bh+5lPB9mxzXlKKclvAQDyfqj3UmddbEf5qYUZ/2Ys6/zy1zwj
         aLP+O7hPWLVChmRyNKoeBPUY5H10ZKhwn1qG5hKC9d/LgiPl2cnFMr83+ORYZUbY11wh
         TwmE1/euBqjA/QdOmZNh7SGgR241ss2zch+WgYRasZbVdwKlIdqGjnM2oEpsdZH33h9z
         WQb4Acu3sEUpEknZVzGCGbh13OscM0e+aq3KxXEMYkepns5ICWzMHNsVSnygsObVgvna
         9o1aU/0oXk8NI9SVmutK617UkpfJ0CZ7suIMI8YpouA+fox2CIbXf3IPzLeqRB7Kj653
         CBKw==
X-Forwarded-Encrypted: i=1; AL+hErH++psw8dRPrjei/H9/lLUjlupsw2p35S2vEu9U54bAMcPVzq0x0FMx98S0J7b1srkD2+tGkJ/ygap6rjs=@vger.kernel.org
X-Gm-Message-State: APuU4Z/998nGWOF2nPiojWwnFhEZ4axUioRFLxnvqW1czZjoJNVGMszP
	2Nn0DmrDRxfNjNuU81OgqYkg/AHhrXFi/23O5LDlppqU+qNPBV/IPtmr
X-Gm-Gg: AZFdTZeMjuzhGCq7Y1FPZmk/rAa5oAqK4fVVGJP4VoTxn6n1FIZ2NIGXhO+MZjieL4T
	SLfuiGfYgsCYNSKz3AkODY6C+RzVi9xBIJh4Uys47mmD/mNVISUQClroU76wGYdiBgfzmXB9oYu
	rU4D9at03loQRFDM0XrerY+melW/AsbP38OtFCQBqINqSq1Yq3vr1sbs0MTJPHrAt2ij3h5UfWi
	o1qupG+6G4Gl8x9L4ok0EAwKCTaix8Wz0nNlotFNh5g1zqxRLTwOTe2uTq6tCHCxqZauu1WFA0K
	Nb1lin121hx4Xet86mHwQhi3JFtktma4NrqgdB9bgiTVwAOnPzY/FMA5mtK1gXP5shXhj+Z9fQb
	gCDqSZtUfW6XkN0IxBogbcp99i10hKLk8dLVADyQOX3jOmfLF5lQEVRgktsFGFMmOxdtWkUGYaq
	9Ocjr9s/wdBfdk8EBonc2a5IuPd+ssNgym4uRNKVMd5PtUjUMOU2/fEgJNmnpzWqsKEyuwBrZy4
	RdHVZFZKOc7MnM5YsyUslSENGJz9UqWHZ8+DC4HxsiBTJpjNreUNDD47+KZ6VZyqXIz5Hvywq23
	pYhdsh9zf2YDN+38vo+w3qzsC++WgD62S7FUmz1owsacmVJrgWc9ol86C1yNhiucow==
X-Received: by 2002:a05:600c:3509:b0:4bb:76f6:d23a with SMTP id 5b1f17b1804b1-4bb88814d16mr374824975e9.21.1795597776397;
        Wed, 25 Nov 2026 01:09:36 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm558503985e9.12.2026.11.25.01.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:09:36 -0800 (PST)
Date: Wed, 25 Nov 2026 09:09:30 +0000
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
 <James.Bottomley@HansenPartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data
 shorter than MIN_KEY_SIZE
Message-ID: <20261125090930.698d8f1b@pumpkin>
In-Reply-To: <20261124194043.1651679-2-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-2-jarkko@kernel.org>
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

On Tue, 24 Nov 2026 21:40:35 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
> bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
> 2.23.133.10.1.5) blob.
> 
> While kernel-generated trusted keys ("new <keylen>") and legacy old_format
> blobs are at least 32 bytes long, external TPM2 tools allow sealing any
> non-empty payload up to 128 bytes.
> 
> Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
> bytes for ASN.1 TPMKey sealed blobs.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> index 30188a0ec676..d7336f25b514 100644
> --- a/security/keys/trusted-keys/trusted_tpm2.c
> +++ b/security/keys/trusted-keys/trusted_tpm2.c
> @@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  	rc = tpm_buf_check_hmac_response(chip, buf, rc);
>  
>  	if (!rc) {
> +		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;

There is no point using u16, just use unsigned int.

The same goes for data_len.

David

> +
>  		data_len = be16_to_cpup(
>  			(__be16 *)&buf->data[TPM_HEADER_SIZE + 4]);
> -		if (data_len < MIN_KEY_SIZE ||  data_len > MAX_KEY_SIZE)
> +		if (data_len < min_len || data_len > MAX_KEY_SIZE)
>  			return -EFAULT;
>  
>  		if (tpm_buf_length(buf) < TPM_HEADER_SIZE + 6 + data_len)

