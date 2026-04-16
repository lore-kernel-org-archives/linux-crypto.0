Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7036939DBFE
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 10:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776334128; cv=pass; b=BTbjzrvFO2wx31tXQc4KUHiedWRUPX8xiGad9oUj3M4UrwsXXY9pwbJSUa6Qxd61SaxH6AmaVFa6HiDZd3HIVNm5fNf/WXpdNbGmmg+22B1WjAntZPuYICeWJ8z6nPYKJJM4szA66uq6tjHs6em9JFI4BtEXHs/HjxPG4pGY9DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776334128; c=relaxed/simple;
	bh=zEB5HcHU9q0EcT9F6l3nHGl5sT13qq55hsj22g7GCPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AYL1LkgHV/5VrC3Jdo+aQeSgiOagaZy/qLYTW3+pYH8WDMqxuYQoxWSTZaXX+KkVuppx+LzICrcR5+8WZ0dwgoUmfghxJLjRPTB62ZvKw5t0q7M7BUDJW2e9Y6HTSHYy4G1edtIywWwew0SlLE41vqTPy5RxQHaglVTC7+ZeRCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n+1Ofs8/; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n+1Ofs8/"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-652fcd5a6d7so506321d50.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 03:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776334125; cv=none;
        d=google.com; s=arc-20240605;
        b=Qprv557jeA/MznsLdVb6iDbf2aNNVxwGxmOwKdS1BVs90FpAIJjezUHyMnJW/PBFno
         N3q4aqLAQ2j/kuswc5A7uukez9MrvF5NgWL9jDTP4XxH0vIzYhRCNVg+T89oVPyKLQTN
         lVa15oMvx0PIDHbTUYhExhCp9axD1zkxSY0ms/7/PFF3+1d+rdMEMWzIt5Wg//M7IZxQ
         fdz947ylxkLYFLZerTChWrMSImqmAbMf3cKFrtLX95FVHEa0dNl73Vt1SYAI7aLC260u
         zSrVLSi7f10gYsfMnuF7rGtiGuaQyKIkbqkBjUszUJlinfWhioLLoweJ4krQmbP19SQG
         C3Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZCa5TDSOTBDDHCBKmyirCxSkjy8N+uWnUPZoqRXfgUg=;
        fh=aw+StsLnivhc3l+MICfujprb2k7qRAVpcejkkOxAM0Q=;
        b=V+D9xhslNVKlyeUdkPdYiUbtVak6+eKKh+m8bHZItvCIfYk0nW6VQ4yCrw2tP0x66l
         D88JkXFrVc3g6N4x/cwZdzEI8D8+2adsZgNb0UDav6FeR+He8f5Oi4+44gzxVRWvAozP
         q7u+IwdFPU/Mk+na57HlQVkqRU2+a6ETK5Djy8L5WGwODRmnOykEz75/Pfq3NcHB0WHS
         DXnL1kAFNDXTo2CIUUSGT54LLLIgqibwVqe8d8aedkg8zkKCMvi9nEkUQXF9jW1fcRx5
         5NSprDK4M8SWB6TRUrZlEWhLaXuzC+frzcbvLtplE+A5QEba3S6Xtm0cyjBWh8vKuu7x
         m5Wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776334125; x=1776938925; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCa5TDSOTBDDHCBKmyirCxSkjy8N+uWnUPZoqRXfgUg=;
        b=n+1Ofs8/oteRxn7wC2E1uLVnUUFEVWIhS3kWGK79BmGPQedHpXrfYFIQuCY2H1DBJF
         BxBr2aG3iPt+ZyRyUc6Zjk/WZH/WonYh0wLF8rwOSBTaTjoo6WYlVHd6ehFEa9tS1WV9
         KjNmyhqT6G6PD1ekGGMi2sWCArfRUeEMIleknSBW2xXIacUrb2lDfgtzQUlKmFeh8WGC
         2W3CBWgxQzRGkK18cKIqcKn9eB4vHip/+rFocXGzecpCIxTb4tG+bc5YmtiuKxjIsj6n
         n0s6cwNzNP1GcRWWImA2cA0vl63LNef0dXYVt/O8SRuxQntHgGpwMuPezmX9TpoTXZM1
         hUjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776334125; x=1776938925;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCa5TDSOTBDDHCBKmyirCxSkjy8N+uWnUPZoqRXfgUg=;
        b=bxHp0h4NyrghRZZ44fknduE2k4uyfF7OV8LVbXo/QFUyDRBZeHIT32rHxI8Jm19QNz
         aeGPKxDTdaPwL/uwsZ9fzMEOqjH3jl3N+JvtAhl+jgwe/zQ7/zWths3inLivW/Wnsp65
         51JMessjaRjYAraxTuvJIVWBUQMUmBtKR9PWWI6UHzRNoEV3CYZnqGF3LMPFlj8rgNHS
         8cQ5SiOJrElkNgETgHWGSTe/AmCLGI7ghB8mqIhCDL1ugo7teUvP3kPpME4K5LkurPgn
         BOF6zWWRgmxbtPmTcZMeUZ5G43EQ2bDb2tsedMHYo5g1vviB2kJhi1ogMCCU7At6DM62
         7F/g==
X-Forwarded-Encrypted: i=1; AFNElJ++OgDV7I6/LyTWqGeEcAqEf4erTQHKMiaVeB6YJUhesXT29wvHigM4kD8ZJ2z+MiWG+L4S9pXx/DCX2nk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTtbuCnfb0HzWiu3JZnzPTZ4vL+Ba9OCGz1pDx9mR9RFFHK7yy
	7lZX9gjaRbeU4ZUt1ACml3Gw4/LHYEctVyFQZHOYgXAvcUfce4AHqzHyHMNX6bAUInH30KiYUcs
	OSTvlIzBIBmC4He+2KaxkhOtbkSPiG5g=
X-Gm-Gg: AeBDieuCKHA3sHAcPyOTTHm8k1X4yxNt0hOthgaj9SKozZUsnqODYxRV8fOePhG6sff
	5qu9nIAijWsRIUV/VTkCz/hOgNkXpneN1138hvFuiTbxhsmDQxxrhHU6fS8n149r1VIvvz4bXIV
	eWZI1m0y8UHrXxV/qKV5KDdOZ404KUBfqnM9uX9X5HFpeRRqG+BSh/BsT3rFNZu5dTB+N9T0F5Y
	sv3IM1sEM2/fEwEGvXTqlVMAu79j8h4T9xv7f6VrWqYrny3Tem/7W3Am6e0uOJEJ164nVVOq77J
	AqFL+88bPDIbBt0FfJ0D
X-Received: by 2002:a05:690e:4196:b0:651:9286:57a0 with SMTP id
 956f58d0204a3-651988599efmr20819218d50.0.1776334125288; Thu, 16 Apr 2026
 03:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414123857.3162673-1-lgs201920130244@gmail.com> <aeCp0Xe5G531vHBj@gondor.apana.org.au>
In-Reply-To: <aeCp0Xe5G531vHBj@gondor.apana.org.au>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Thu, 16 Apr 2026 18:08:31 +0800
X-Gm-Features: AQROBzBlVonOYU68cO6MUquPGIUrZcJ7ZQ7pqMxalBF0GpuaTdoNNdTd60OFy44
Message-ID: <CANUHTR9zW=i8UxS=rNoHf-mcq09QyK3243yu6oOySuZqiwbvjQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: octeontx2: fix IRQ vector leak in otx2_cptpf_probe()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	"David S. Miller" <davem@davemloft.net>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Kees Cook <kees@kernel.org>, Lukasz Bartosik <lbartosik@marvell.com>, 
	Suheil Chandran <schandran@marvell.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Herbert,

Thanks for the review.

On Thu, 16 Apr 2026 at 17:20, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Good catch.  But what about the remove path, shouldn't the vectors
> be freed there as well?
>
> Thanks,
> --

I investigated this further after your comment and found that this
driver relies on the PCI managed cleanup associated with
pcim_enable_device(). In other words, the IRQ vectors allocated by
pci_alloc_irq_vectors() are already reclaimed through that path, so an
explicit pci_free_irq_vectors() is not needed in remove/error unwind
here.

So this patch is not needed. I'll drop it.

Thanks,
Guangshuo
