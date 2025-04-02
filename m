Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A1C2E3394
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 10:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743591226; cv=none; b=qSNcRfB4CpnQK757/js9F6XyzZqaEXds+hPxC4TK3a43epZPXnV+1q+0wUxHdvueBaekLmD+nA0c5mfTnKnzTiXUSF817rKpRbimEHKLtEFlsSI/Zx6GwlHaOYUZs53FabR+hi0OpGz3+Ri6532TpN+g3IUtIJeWpf8EhdCJYTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743591226; c=relaxed/simple;
	bh=FsAMmNELhR9E4r7mNrNpzPtaL3vX55iJQx0AqvsRQfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nc8pJd3uNLsh/kIcTbMZIcWGE2d1J2rAsmqJL9mNw+QbkCgfM775ws0mM2UNGoz8Ig3iP4xVZaDnR5a2s53mARhlTgbM1UYOMKPakTW7S9cmbv/HG5/+dMMHZJ7ChljGQKYUZW/uvy8JagK+vEsSSnNJawRL/PK+GbpXkzSGtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tulloh.id.au; spf=pass smtp.mailfrom=tulloh.id.au; dkim=pass (2048-bit key) header.d=tulloh.id.au header.i=@tulloh.id.au header.b=ZUbr58l1; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tulloh.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tulloh.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tulloh.id.au header.i=@tulloh.id.au header.b="ZUbr58l1"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6df83fd01cbso32895696d6.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Apr 2025 03:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tulloh.id.au; s=google; t=1743591223; x=1744196023; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AkBX8zIeIcsVqr+aW6yqRK/ZdOvZKclMy8ld2dBNN5c=;
        b=ZUbr58l15bUGckuhoQBnr3MFtVwJZRpbMtcvhB6jI8I0jAaGjXIls+XwlBLGb/3rl3
         +FsFG+MuWJZQ2rq1GoJ2KyJLUVYPO9s7JLhDpJItJmT8xwZW/tnW2sJ5lLmyF2bAVJBO
         MeH2RFZENgp0M8FPGl+2jirVXYIuvtktZWytWT87H3wkgaZSlgAP8b0Ks49fUcGp6fGP
         9Rg/uNdgdSbLTpHXlHXQwvfHrDKEWDkcojE952g6z8r0uGK06P8gfiIm19F5kdGkydLf
         oXecVZTtLylc+XS/D2qhKitaB/qbmAuX7DV3Uditj/pBDRI0pR7b2eygWZU69AQ9JNYY
         kaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743591223; x=1744196023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AkBX8zIeIcsVqr+aW6yqRK/ZdOvZKclMy8ld2dBNN5c=;
        b=P+hoANSzfD0trh9x8hHzPDfDycME/xMfvq0/0SU8f5tPXFesmjiE6eqHfKtRFkRvbo
         uYmONZ1P/xx0BrRJWlw4jRkU8qiUwtGUnHNP4vexN/F3KzmOs1cjeUDUCcS2ktH1YiQN
         phCLa8SfsRRqM0NUtlW5camiOKZNecKG2kxxH9+UaZZMNGPXihIZw5URefXP1SRVqjh+
         eVi985RT8Htiu6OiTjriZjglPKayxw9Y2/+ZMJ0RmUxhAhkHT/7OcLYon/BH8lTaTaur
         2AVhovXFaM6NaX4Ao8VJE3fkFfIyFTg3MFRIfXOSpM3yJRdbs0Lghk03wRhcYJ9pZlWw
         eNUA==
X-Gm-Message-State: AOJu0YxinD9gRnffRcAMLbMnuU4u3rRBrswtuhm7nIXLyOTWuZtgeuc2
	OKHTbeUqRmIrdZ2pJnK09glPu9YMT9kRl4yyFKqI6Hvf//8DHVK6j9Ig6uGkxIuAqbawkH+tQ2l
	urx7ZGOtCeux1jm2wsksi2bvqcGwSOfj9LFD1qA==
X-Gm-Gg: ASbGncvJpSWHYOPYH6mgYnnEuhhJijOkTvR5CKuuBwgCSDDLipDYPSePJQxv9Umys7W
	hXVRKuOOcxM285Z6oP7S9fkKxcSwP8Rnh/KYfabsflyrbZoVW+QFo9yIsm1V15b0lI55Nr6QwRg
	ZDsc82q28EKCE2us/3wj0QBZheCSY=
X-Google-Smtp-Source: AGHT+IGb/dSjkgyHCQo+7w2rsG9+s3hZF18n/WwYbfVRQdNfPhZY2E758WG/d2LVkrpWryw996lO33XKS9i2i+F86/Q=
X-Received: by 2002:a05:6214:f62:b0:6e6:6089:4978 with SMTP id
 6a1803df08f44-6eed6073d6dmr261017406d6.24.1743591223575; Wed, 02 Apr 2025
 03:53:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOP4N=-42N6bzXtWYCSAmZekwh+FqRBnYnBPwoPX_SuHTBVavA@mail.gmail.com>
 <CA+_ehUwg-ikoL2XL_8BRMO2aQ=Jnnn_RB2Dy4TNKo_Hk0qZjWQ@mail.gmail.com>
In-Reply-To: <CA+_ehUwg-ikoL2XL_8BRMO2aQ=Jnnn_RB2Dy4TNKo_Hk0qZjWQ@mail.gmail.com>
From: David Tulloh <david@tulloh.id.au>
Date: Wed, 2 Apr 2025 21:53:32 +1100
X-Gm-Features: AQ5f1Jo3FP2xZtUpJqaNNQLCxGtzaV6yOb--sB2kq6bUpsGkmHQAigLjwlAGZGc
Message-ID: <CAOP4N=8KVUf+DHmNByFJx+2=ZRMoGxXKH661V8doN2hh+A3HXQ@mail.gmail.com>
Subject: Re: [BUG] : EIP-93 module crash, unable to handle kernel paging request
To: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Apr 2025 at 19:25, Christian Marangi (Ansuel)
<ansuelsmth@gmail.com> wrote:
>
> Hi David,
>
> can you provide easy repro step? On rmmod the module, you were doing tests?

I can reproduce the module removal by loading the module on boot and
then running `modprobe -r crypto_hw_eip93`.  I don't run anything else
other than the standard boot init process.

The mount I can reproduce by running mount... but that's obviously
less useful for others.

Tomorrow, I will try to produce a reproducing mount script using a usb disk.


David
