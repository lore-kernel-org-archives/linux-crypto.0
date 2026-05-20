Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546FB2D5C91
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779284175; cv=none; b=uDaMLmgzgRCBlWt2XN/Uu2isR3PLKQ+CccyaJ/efMBt63yFsgunMsyNCdV9eyRMqWCfMcYhvsNKmKAvb+q3douVb3CKTa4HX2+jzDO2ZZ5BOZjKqIepSGqNsXjRx/cmwFlEYyD04VrlEyHLzq51h7Cg9j9gcKHgQhv3ohoFLml4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779284175; c=relaxed/simple;
	bh=fD+ARADNpV4+681SIU7L6FP5JRjCPOAAhZeDXmn48lM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=liXccYEQSxvgGxReLPd5Ctzbdo8L8tOGEZEqsY9UGAaeLUbY8qBtVH4uJqHqeD3kFdkWR8oVogUvbDOlvOSugHJIWgQrtWEXrHaXB3Z83Ewc6PbLGYzutt2VHelKt4+9choloHK9+G3YiNOCGqV+ZSeNnp689CQFCwz4wWEZM7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMjdSaRC; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMjdSaRC"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-44e1860558fso3063168f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 06:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779284173; x=1779888973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TT5tPOUU6iSkvSGnHgv9ef+z1k0sP1JbXO6EwFFylo=;
        b=bMjdSaRCTVmrsCqvvmI/vwwRs/J3/NtmDqeA03EAy/fPNpy++o+kki2x2j/7CzWQ4A
         QDpSMiJXkZhmsFzajkB0f/vaMrxKvwaqmZ7FhiIN7mX03zBbQmt1rcufgQcaEq3aGqyK
         5YhdhSN/6cvr4TkrRZk4BgGRTIFg8QsD/2vLLze44CPIN+PQStzkoQ5CiSmcv08m68gp
         e1e6hjpXtNMeNJreg2zecXii3UaQ5huTbg+Dge79i1wetiOLsgTCbc3KM2V2+x9eiCqB
         uFElnDtHSn6DnaRyp6Ab3oblhPkSPNkn4Olbzew37KWfXkNK2tTu45BkywtJLIfLlFkA
         00ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779284173; x=1779888973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0TT5tPOUU6iSkvSGnHgv9ef+z1k0sP1JbXO6EwFFylo=;
        b=QTOBw6uQ7d0o2csT+YSe4MB1c5ymM7XDl89O+bJXBt8q5GdmBfAqRZIGM8MZKFRdlI
         t6Drwjcd18HXbf2LnbNn3xUg6obqW6X/7IFg7j151FLK5Dng0E+uaT9q04Uu2lHe64gj
         yuoSE630i+/Qx/tYenUWDD3JaDgAotXwZzmXHdblmL/ctyYjEr46a6EnETgHhywQvaug
         kwH/1LzFOVs0NRYEOuVx41XVdX4+kXhCFM0wTrx3bPTL810+a6u+lY2sZrpHjB+Uaesm
         QYBaZOLtIabjiJhc7jCu3LicLcoP0gtZheZ5+bZURZFExYIi2KorTykby7vlIqkG7B9D
         yYvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9fJvIs5BRCQFf1EW0HaZ5HtbuMIHebvWumtUFshAOPghq8C2begR2Qgjf89odWSC+Kquxf8gjrWL8aDBk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz7Us3YZNt8imiS/hnxs3OtdBlxd5+y+qTYcwukOIN7OFsN6fs
	XwyJle05w44V75zhsMyLGhmibzJQIY46bY4OryquvyOdsGITQ+GS5+vU
X-Gm-Gg: Acq92OHKXteA7IurGREn3h/YGuGMYF9Y8WDmG50dpn4/QsDQe/YhGnnxNbrwbQR9zLN
	R9EZu9152CaIWt7DGvwgL5mripAesL7oICckb+DtGx9H1ARwlZxKQgD4+6+SoIASNUGcBilM2R8
	Q6+l6FQozW4ZzMXqYczpvPihNHMF+mlL05bTB+3T4VHCFAE/xfEyAO6KzmACv2Hs/qbvmuEMEZI
	0qq/LivM2+eWdHDZ5OZgYB9Yoy8MUnFH79psiO3xAyHnE9ArIJo69T4HXtF8ao9Tw7zUhrkIlN3
	TS9m6MQmWGcDfN3zHg1QoUGNeMlodKlClMc9DBs2/aad9X2NpDyRIVkbDdAKG2FU77e3Xt1nQj7
	XcthOOT0oqnnI1Rfh8obw+ypHa4Q+wu2ARJalSv3FAzSh7WiCE99aG1vj2PQMWDF5/6EeS9FfOH
	tdTBZShmVaAsmN4JViidZ2ptSSDoygkuxagGrImH/CCqMBruWkCAyk7EhiaTQGeyUk
X-Received: by 2002:a05:600c:4692:b0:48e:51f8:eb39 with SMTP id 5b1f17b1804b1-48fe6325746mr393966835e9.28.1779284172372;
        Wed, 20 May 2026 06:36:12 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48ff43f8799sm285554245e9.2.2026.05.20.06.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 06:36:12 -0700 (PDT)
Date: Wed, 20 May 2026 14:36:10 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>, Bharat Bhushan
 <bbhushan2@marvell.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Kees Cook <kees@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx - use strscpy_pad in ucode_load_store
Message-ID: <20260520143610.49cb7407@pumpkin>
In-Reply-To: <20260520100031.246078-2-thorsten.blum@linux.dev>
References: <20260520100031.246078-2-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 May 2026 12:00:30 +0200
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Instead of zero-initializing the temporary buffer and then copying into
> it with strscpy(), use strscpy_pad() to copy the string and zero-pad any
> trailing bytes. Drop the explicit size argument to further simplify the
> code since strscpy_pad() can determine it automatically when the
> destination buffer has a fixed length.
> 
> Also use strscpy_pad() to check for string truncation instead of the
> hard-coded OTX_CPT_UCODE_NAME_LENGTH.

This code is horrid :-)
It really ought to be possible to parse the string without taking a writeable
copy.
There is also the 'fun' that it is passed the length of the string - hopefully
it is '\0' terminated at the same length.

Then there is this beauty:
	if (strnstr(val, " ", strlen(val)))

-- David

> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> index e0f38d32bc93..205579a6ba2b 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> @@ -1318,7 +1318,7 @@ static ssize_t ucode_load_store(struct device *dev,
>  {
>  	struct otx_cpt_engines engs[OTX_CPT_MAX_ETYPES_PER_GRP] = { {0} };
>  	char *ucode_filename[OTX_CPT_MAX_ETYPES_PER_GRP];
> -	char tmp_buf[OTX_CPT_UCODE_NAME_LENGTH] = { 0 };
> +	char tmp_buf[OTX_CPT_UCODE_NAME_LENGTH];
>  	char *start, *val, *err_msg, *tmp;
>  	struct otx_cpt_eng_grps *eng_grps;
>  	int grp_idx = 0, ret = -EINVAL;
> @@ -1326,12 +1326,11 @@ static ssize_t ucode_load_store(struct device *dev,
>  	int del_grp_idx = -1;
>  	int ucode_idx = 0;
>  
> -	if (count >= OTX_CPT_UCODE_NAME_LENGTH)
> +	if (strscpy_pad(tmp_buf, buf) < 0)
>  		return -EINVAL;
>  
>  	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);
>  	err_msg = "Invalid engine group format";
> -	strscpy(tmp_buf, buf, OTX_CPT_UCODE_NAME_LENGTH);
>  	start = tmp_buf;
>  
>  	has_se = has_ie = has_ae = false;
> 

