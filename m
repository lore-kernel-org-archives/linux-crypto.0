Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802931C84BD
	for <linux-crypto@vger.kernel.org>; Sun, 14 Sep 2025 13:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757855048; cv=none; b=mN5DgG0ZTeQfjxMxd1512PXcIMR6DUGomuAiF35zBId2a8LeqVmOH4cIZXvv8aqq4sfqZYg2UrrjNTHqfGQd3924mwgGzTglsceFVx4BnvNc/vqc/H+UkNBTaKjAaibU9/Q6rOSIdAtlUqbjVRLiD5bFKfUQAoSEVBL8x87tWI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757855048; c=relaxed/simple;
	bh=eIT6B8Ck9ZTCH2/rxxoLMv5C3Gz96MZvLQcPMa0DpaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h6kCbFk5qafVXlVqKKOV+fgu5fj/6DKf8jkXb9Erl8D5N+XRjV34VGkFc0PuqfATYs5htEoKRYaNx/BD4AU2Iou77kQ4DUhwjrjJZtJHz6yt1EXb2HmZzbXNSKs2WvFG3iiHHWa4XziSjDDC0vGLZzFm3ywGZ0mkEEDbE4odTuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OwgAUerd; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OwgAUerd"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-337e5daf5f5so38157221fa.0
        for <linux-crypto@vger.kernel.org>; Sun, 14 Sep 2025 06:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757855045; x=1758459845; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IqFaUQpd7LmKv213z82AUXz93Hm+V03TkEIouxYHoY=;
        b=OwgAUerdLug2M75lePk8QhIf/tbr9nJpmPkcM6yRhWrTPV0bVHEyzXy4HnypGzssrg
         GNJkr7ano9YHAawyr8hrWlfN2UZxClS7S4Cnv7gvsbJCL9xhT0EZ5CLXHgVrZRobcI0q
         UiCf8/kQQ4PTrTdM1Nlnqh4Icso9HLsNDiq2Fr7nTGX0FIOGizKhbDIJDU1UwGKnBnSd
         V+gYib4H+QcjoDlmpMH/HU1DjMFCTgwjblRcvZDOGVJsZQ7TzGkTcrkwRvhkkt0B+IXE
         2j3I1A2P8XbHQbKR9ladZ4oRPlMX6XpAYl/lXbG2AnT0jumrdxOUn/5lKORm+9K3SNpP
         H71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757855045; x=1758459845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+IqFaUQpd7LmKv213z82AUXz93Hm+V03TkEIouxYHoY=;
        b=WabtmxWe0ilaQgpj3Q4Ls4NTc/J06yXDeYlnivIfbZus5o24AGs1L3BiidF6ZedpWM
         Pn4eTNVOrWVMYngHuyTibMUU0+wqaoSN1AORPpbMzKKZsS143/4jw7FBlVsy9hgfsVyx
         jMO4nWdHVmjmH1iuqTfeujhGkVvHgdt+zywEArNobKi//WCyg73gg5o1Wul/qtsG5UjD
         bHi8oHzoJTto6rP6yxFuO0kp/hvJ+XthDRF7m/izE3XeRvo2ttYVhGiOZzRA6KRBtc0V
         9ieKBeRx2tN921UK1zxDl4zclp1+TjbcyMmAtXSfqts5T7rYbyxHKa/1Ns9mrC6hNwUG
         PnXg==
X-Forwarded-Encrypted: i=1; AJvYcCVlHlZW8w47j6Z2VHckj04xOpjxrMCqXXCD3uSfFw9hSjRHHU/Mg+OErx3EErjdI7EZHP1zrZdeXucKR4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw647yvAZRoW35DOA+1hmB/b2r+YR80hISBTfJ1Nw/gbgS1moZb
	vWE95KYTsM/A9vHxi+NyweDwopEBDbkAFKktf4ya4AguoDiwBgKs5HLTuMSfed8QqIOdtzEfPRF
	RM1qIkEUhcdBXR2/Wy+KTqPMWt5BwlQs5T03o815ylg==
X-Gm-Gg: ASbGnctxMuPrPuUiY78YkZYVA9wBOqlbKgqYu1fQsQyKACA0H5oUeASxtfIWWj4MiM4
	rvDQhnxHEO6epQWR8nfe77SXFHOak9kEB4pYllVZhmjYUBITWmW03b+3+qky7hOroigRF8BqNOq
	9V/7wGkH1hB+87BPO73HDg06IekYItGpToGlZ167FXo3ykjBjsX/mVotBbDCFiCl4U9pycx0kH0
	ucJfDZaeblrFFa+W4ppx4vgsd6SeDynbNNYkU2g
X-Google-Smtp-Source: AGHT+IEUO398q8ckm2nbKF/dOfbPRQTls5OtTZlpWKI8X1lmN9sBYbCZbQk5qLKT3g9QcDozIiQpYjXsSWw6+qhCGak=
X-Received: by 2002:a05:651c:2096:b0:352:7dce:2e15 with SMTP id
 38308e7fff4ca-3527dce34d9mr18523461fa.5.1757855044619; Sun, 14 Sep 2025
 06:04:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905090533.105303-1-marco.crivellari@suse.com> <aMTzW6nGz_FCYzNp@gondor.apana.org.au>
In-Reply-To: <aMTzW6nGz_FCYzNp@gondor.apana.org.au>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Sun, 14 Sep 2025 15:03:53 +0200
X-Gm-Features: Ac12FXwMPunGDOshIZwWaT-ESRpfqLsn7vzZW0pkKSYKtDiTk5wEhcGe2BsXX6o
Message-ID: <CAAofZF66bRAupdBTJeCHcKN4FZu+_GRHptwLRzzkcOM89V0=kg@mail.gmail.com>
Subject: Re: [PATCH 0/2] padata: replace wq users and add WQ_PERCPU to
 alloc_workqueue() users
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, tj@kernel.org, 
	jiangshanlai@gmail.com, frederic@kernel.org, bigeasy@linutronix.de, 
	mhocko@suse.com, steffen.klassert@secunet.com, daniel.m.jordan@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 13, 2025 at 6:30=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> All applied.  Thanks.

Many Thanks!

--
Marco Crivellari

L3 Support Engineer, Technology & Product

marco.crivellari@suse.com
