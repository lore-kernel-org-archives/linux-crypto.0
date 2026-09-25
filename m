Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726EC472094
	for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339060; cv=none; b=rRW5wzeJQZfcK1pzV9csXXaFHPRyso6aL5C3q/pLYPVoOUPI0c8RmsrCtr0QYqyQ+/nOHk04J8n5Uca0KBh3dyA7lRZGTtK3Es0gq/odmx4YnOk7ypZaJSkPHs2UFp6wgmuYnQmJa7GCYo8cINAKt0lAuIjLfSwETTBaBrmWXDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339060; c=relaxed/simple;
	bh=FgGxMKVkPPoO74lUXunhrepWkxwIT4CyU22xr2ZpS0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aeth23BQGONiTa1OAIvCBByqHln1HDFuE68IMdEJ0bKsLUo4KgeaydcPt4Ug0lmj8QAWapoJzhFnkUvYcZDbXWAk8mZdb3edrQCeafeDLZ4rydol3cKUVkTGLSHTYBvdwqn/XTV4F0jiOMFcu3o69xPdxSuZK7O7bMOW/+zqiZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f7dbeso100383466b.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 05:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339058; x=1790943858;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FgGxMKVkPPoO74lUXunhrepWkxwIT4CyU22xr2ZpS0I=;
        b=0lu8DPzHHEfuWd6PEZQPtj8wP6S37M2F7+XBLsMOS2M60HqZCOjaXNQ1YZiGdSmEg/
         JB6CRyIkjmranFXdM53PCp5+tXVwzc4vgZ4Mu3Gh91t/p79inBUjuRzC3Di435sMf1WC
         l8tduN3Jh1YQP0Llt+phSnewZ1xzpM2ah+AyIPweFEM3kCa/27CZCv4hw+cHq/vGDDq1
         B1HaIwrYx4c77Btwg9R7k2nqol5kt73uoiEbdsScFEloSTwt+3buoaKW8MGbFK8FXoQS
         Uus9lprFqG0jdsg98XcXQ5BR+/x9p5+BR53i7iqNwkFiNgNKjo3hMT9NK6h81DZkCSzs
         alJQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcHKJbBXIDW8i7/ZhkK1wpbhVvF8kDY6QUrh0GO/1Nf660IEF/QFq5vFKMpgbfTtl/E0vy0gw71rewutU=@vger.kernel.org
X-Gm-Message-State: AFuF++l7+iMDkbNr+WGJi6JmHZSn3NYKSeeL+GUqVE7zEheXdKdd0D1q
	ZMzffXQ3U1JBF1lzP7aUnVTyXsQ1gSJWuAbvApsvwfGFuX8VVIGXUtTUluJOR6x967qgeLQO
X-Gm-Gg: AYBFou0F4oibt4NRAOtudkr2viWYTC8w2Y8vLv1jU4oqeP1TJz+BJmqDR1YG2EOdW4p
	zZn8Et2uC2TxMA6tYZv+pu4LzcQhGr3I5tLyUxo9RZQ8lCC3+g9H+/8k9U09YuK/3jMBfRFcTmI
	yh0vObTxO9lJbZRxu530udX6OD6r7Nhv8XTDgW/EF2JCXRHTIPjtkPfowvbQetlLmloq1TB+W4a
	69uOdsjppkphfRR7IAuo1S9RgoPCDkeexH9FhEUFvnkdeLV6V0kfGgHn0iVwiWiwXpObQcJq7bQ
	NcyUlpD8Q0w22efmlNsRQQLDJjmSBBrzFiQhX4kOtk2w09E/f3LylMdZvDSdoePNJz2UGsJTRZc
	/Hkc2+JEPzxYtc8aOlJ8N4vOwIzyiK/fFAkooIyjnse3/XEMpaG2Nqkz4P+xnZeTehevULmeLgV
	bqqREkRxL4Q18adBjafsQclABudScWTntxmAFVk1KAt7uS2E4+3W+YIksebnWsAjT2JlWG+WGtg
	iu2Yj2NJT4/bYrvqGKH97oNhubimXo=
X-Received: by 2002:a17:906:99d0:b0:c26:19de:9ae8 with SMTP id a640c23a62f3a-c2ac25f3312mr500422466b.39.1790339057376;
        Fri, 25 Sep 2026 05:24:17 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae757b9c1sm107160066b.33.2026.09.25.05.24.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 05:24:16 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c294af0caa8so115635066b.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 05:24:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwmgCXT4dwsQAJI2VppRD93PS+EgdCLt8uX/Xg2hD4sPJt2FlWkcbLiIHgAJEVd4nL13pL6SyWV7gTQXcU=@vger.kernel.org
X-Received: by 2002:a17:906:99d0:b0:c26:19de:9ae8 with SMTP id
 a640c23a62f3a-c2ac25f3312mr500414166b.39.1790339055822; Fri, 25 Sep 2026
 05:24:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH9NdkhqTDyNbK0uNyB9tnYwTbahMGVQgSXJ9PEnVQtDU14kXw@mail.gmail.com>
In-Reply-To: <CAH9NdkhqTDyNbK0uNyB9tnYwTbahMGVQgSXJ9PEnVQtDU14kXw@mail.gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 25 Sep 2026 13:24:04 +0100
X-Gmail-Original-Message-ID: <CAOs+rJU7+8nWCDUuu=BOxpDBYiD=t1hT3ZrWFhoyTV5ZG4ijGg@mail.gmail.com>
X-Gm-Features: AclHuK8V4OoXn-o3NVqGD-TKDM9CI2mAJ_fDiPvSiziHHOrJRYnycd_sE9RDaBo
Message-ID: <CAOs+rJU7+8nWCDUuu=BOxpDBYiD=t1hT3ZrWFhoyTV5ZG4ijGg@mail.gmail.com>
Subject: Re: crypto: ecc - constant-time modular inversion?
To: Erwin Pawliczek <pawliczekerwin@gmail.com>
Cc: lukas@wunner.de, herbert@gondor.apana.org.au, davem@davemloft.net, 
	stefanb@linux.ibm.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 11:51=E2=80=AFPM Erwin Pawliczek
<pawliczekerwin@gmail.com> wrote:
>
> Hello,
>
> vli_mod_inv() in crypto/ecc.c is currently responsible for modular invers=
ion, it is currently a binary greatest common denominator loop where the it=
eration count depends on input. I'd like to replace it with a constant time=
 algorithm, this one: https://eprint.iacr.org/2019/266

Is it used outside of ECDSA signature verification (with secret
input)? If no, the replacement needs to be faster to justify the
change

> It runs a fixed number of divsteps for a given operand size, independent =
of input.
>
> I already started working on a replacement, please let me know if this is=
 something you'd be interested in.
>
> Thanks,
>
> Erwin

Ignat
