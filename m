Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC4722FDEA;
	Wed, 21 May 2025 05:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747805948; cv=none; b=YS+oWeWbOJAnCogrrKOH+4UpeDjylSvymX6XWLJJctBPtpTC58pYpT8NYCwNV844+xFVepY4d6gfLTmo6J4wU/YARJ+GElo3NkXpnBDUyPanchM+mDEE6HNyDF7+nL8nCnDh7I+NEOvj4SU7hLNL/rNW9c9Mk1Eo6tImslemF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747805948; c=relaxed/simple;
	bh=rJoHwVdmu70bBttowc9ovSLMST2TXYUrOme1AYIzTw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=amL53zLacZAD2gPTcQ0r5kmvhs51ZJQIRnLtFLd2o2V7kYHIuzRzZ6n/3jsU0PSA8SHrSei9ANRc3S/wktGu2er6xUSOMjN/SB+Yvlxr7OrIemvOIMVTx1uEBoOyD3WGZsuQJClIU3x3ko4TXbLkCOLZv0hsyraE3jA3n1LOtJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZEPVcKp7; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZEPVcKp7"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e7b9a3d85b9so2793595276.0;
        Tue, 20 May 2025 22:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747805945; x=1748410745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cwi1TKu0MzTX9DMGvQifU91RHt6vK7DQSE6M6IhUvCs=;
        b=ZEPVcKp7QSVT2NqCVDO8zAwfpfJHoYnLMJAXB+gG2ZY/tAHzdQQBSyW+PZ4nVTKkJJ
         rUfdMrb/MUuJoShxXYOm6xyh8IFr0KSjubv62/Ll9HypsskWL8J9Dy9uJWnBxHkPjGm4
         DYUDNByYh0EzMOCFeLtaxkItWtAVQFlJ6mpPQo2tBDV4qwApVWF2v7ll8tENjyHBMxvJ
         fSgWPmCzysya4ncKQN1cF1d4Y3A1v5jdfWyfnz2VM21AXkWGsAJZNVJLV3mSVK8/Txsw
         16K0joc2C8cO8uP6iH450SvD3PFMohTZjIeSw84uA6nBwGSzFBuFGCP6ChDvAKvb/xlA
         x9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747805945; x=1748410745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cwi1TKu0MzTX9DMGvQifU91RHt6vK7DQSE6M6IhUvCs=;
        b=GVUvz0nMPE2KKLq68/brIeg/T5WxvMj5k3GdhUWltU9gB+xbr4+OqKKxFmxExMvCc9
         R4XkPoIaP07uX8tiCmzfX1mk/pB8szevRT2EUc6LTvNANLCgABNdxm2Ojo3Uch55rpdN
         02VPtqLoxGx+s0x3YsU6+5fwbSEsWtFr5Ob0xBwoojzIH2LL87q1ifiHUlo28u7niX7p
         OusgyjKuO6/rnDcWEmPOoemo81/e6f1o3q6oiXoL93j4NkiaQvDvpJIfQJNskjsLdVS4
         U/o8U9kvwi09fjLH8iomFm8hvWhZim+GAVYtCKmtiphBepY6mVBoSis+W8YoWdgHU3Gp
         r+rw==
X-Forwarded-Encrypted: i=1; AJvYcCVMDDU2gyIQHHlYtZhlPuG9lFW8mwcOXtuxUlmGJMjd60Bs1xELtmcRUWm4pZmpjaTtjkGNcHRz@vger.kernel.org, AJvYcCVN/NySxsUb6Cw/vN63B8GaRB3VLQl/sVZQNSU1VdHnbtowfON+eTh+taiLHXrgfLwMg3LDvr/ka+MZfqI=@vger.kernel.org, AJvYcCWqF2U+zH18C9BHetwDWZSV7uZZPk1kX4k4wBuKJWFd5HCc3ASCVXz8TD7sDG3YlXJLDpCV7Lffeggkeuie@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+VNzydA/Kq9mSw3j1J+1zmUQOwhzMT/9Ha5RcyIJ9DEZLTqKs
	dgShDX3/7LCH7q86jhtzti8jp0Gva298RLgM5sj2UsELR3ojy99QOASwEQXAFBETEpdAfoi55+i
	5/OPeZ5M3O8M0WtkTeXo9mC6Ic/EesmumrA==
X-Gm-Gg: ASbGnculXsTubnf/SiLaCvqYLwgj5m/RZ3SKBZvZNPsVSXDQtBzr3z9hFxcYYQqg8w9
	yEsYyVRLvqee4g8xfFUO1nX/8WsRp3/oN/L3lLZ0vlKjxSWN4+D9DelZ9XDOrtu4jyLmrJr7yg6
	7aSHzV49h2/jlRhtFOMGV6Z0uzfxWNZ0c=
X-Google-Smtp-Source: AGHT+IGgzD7CKFw8OUIVR1AtCawdPAvyoq5kif11vGmUaW6UgrO2N7MmgFJ6Es69Q3ma9sPvy1SwqBIMn6DqYvI7LUk=
X-Received: by 2002:a05:6902:2181:b0:e6d:f4c8:7fab with SMTP id
 3f1490d57ef6-e7b6d554875mr20507447276.37.1747805945382; Tue, 20 May 2025
 22:39:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250520130737.4181994-1-bbhushan2@marvell.com>
 <20250520130737.4181994-4-bbhushan2@marvell.com> <aC0KdBdslZM8m2Ox@gondor.apana.org.au>
In-Reply-To: <aC0KdBdslZM8m2Ox@gondor.apana.org.au>
From: Bharat Bhushan <bharatb.linux@gmail.com>
Date: Wed, 21 May 2025 11:08:53 +0530
X-Gm-Features: AX0GCFuhNlG-J3vC3RuGk-CuapO2lbxSI7JUvkzX_hl9f90ZXIHLJZrJZKDtIOs
Message-ID: <CAAeCc_nLSuDrHTPNt39mK4Ea_PD6fO4a=x21kgQoMVWWPNvbPg@mail.gmail.com>
Subject: Re: [PATCH 3/4 v2] crypto: octeontx2: Fix address alignment on CN10K
 A0/A1 and OcteonTX2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bharat Bhushan <bbhushan2@marvell.com>, bbrezillon@kernel.org, schalla@marvell.com, 
	davem@davemloft.net, giovanni.cabiddu@intel.com, linux@treblig.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 4:34=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Tue, May 20, 2025 at 06:37:36PM +0530, Bharat Bhushan wrote:
> >
> > +     info->in_buffer =3D PTR_ALIGN((u8 *)info + info_len,
> > +                                 OTX2_CPT_DPTR_RPTR_ALIGN);
>
> Any address that's used for bidirectional or from-device DMA
> needs to be aligned to ARCH_DMA_MINALIGN.
>
> Sorry I missed this during the first round.

Will change in the next version.

Thanks
-Bharat

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
