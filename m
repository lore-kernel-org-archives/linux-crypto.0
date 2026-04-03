Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446F432E75A
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 08:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775205337; cv=pass; b=dM6lxQHVSnKMrav/SYRxbMTmhuQ8axL8ymo6/kwQIQMp+7MhQgEV39nJIooogydwRxskmEvKPY3Wk5egA9cYtCCDfyGdpd3mxmUD2+Ll6RwrxwnNNs9T3HSZy4NYGRfLgc5hAjCW/DuSyEjNcdfAVQhEbt9dFfyYb0A6Vz3iZnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775205337; c=relaxed/simple;
	bh=5cwHC3eZOxiU2/NZzUhXroPRJVVWV1jp1fwyeMJtdWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GyegDiC6ft/jfF0Bnp7vziyPQUkij5eL0/kGIVU+hVSKxcWZzJROIGGMUPIYTqjkK0PlNDGiBex4WLiUeGCemHcaPYepaktSZESMQmeZf8MEZkaFjDDb2gBxTTDCyOEMQRDVRmyJjdsfW3w0+R0MHSpu6xDT6gC6ACdggBfwQjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCW9auFt; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCW9auFt"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so296123666b.2
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2026 01:35:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775205334; cv=none;
        d=google.com; s=arc-20240605;
        b=Ryc7wxRUQjhsCHM5BB+fzS9Ue9dJjG4lDemRiBaWpsl+NzQKfUGgi0/UAdR4bXqSDB
         A4cuPWE+5/RbsSGgfF+bAVDqbID3II3rN+EoZEwbgc0MuJ5qBgaDLS1Z5uRpBpmDojBf
         FiO7OZ1pULNRsIkkGC09v1PmC4ubIBxQ3pJ4EZ8mOOhdi1tFcSInAHwWwK5e4/heYPqN
         zKxYseHk8atBZyHDczDH9Ec5/S1BGFuzCFJG48NqnFqFB3HGD5u1BZQRa6WzpxHpCAp+
         rfsjaH6VDju32vMQL1vMDZo0ld1jQ610F5DAKOlaK12iI2lXi4DinTVy2vcetYN8SFKD
         tvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5cwHC3eZOxiU2/NZzUhXroPRJVVWV1jp1fwyeMJtdWw=;
        fh=sQcds55DVfTvatBa4qtMG+EFnJYyWf4pEcdq6s5iUT4=;
        b=gO56eC67v8QpYirubwF9nA2Jy+AHwZUNIWgJRaP3/RClJd/anHdN8eVSpNq7SgCb7Y
         EUrqL7EYPcNO2HR9gw9LicjBHw/f35QMEBuXGBFPffIEtypmsQsNdBlz3i1lWxb590a2
         gaw7KtmOJqJM+MLV47XaME7yEN+AV/qNW3klx/gAlwPiMKN0lJ4bC8/3Ve8bwUtqeleh
         7CY4zbi5VAP60nhBcV0V51vjFNqhb+t4my3yyd3lbZeROfx1RiuPHUZ+lX1s6D9oc/sn
         fawPEv6nwiZL+7CNdhvNNue4Q5HKdAgKf78GQq9y+TMhGPVLvYX2yxuJrjb7KccF9Fmm
         4cug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775205334; x=1775810134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cwHC3eZOxiU2/NZzUhXroPRJVVWV1jp1fwyeMJtdWw=;
        b=fCW9auFtEGhMYP4SDKI2eZj1Wg2FZ+zyT9cIAwlPDFHMuMJCUFLFK29tDI4yMPRYwU
         scIVZzOOhjxGNad8YQVe1R8XAdT00S1i9+3PAadSQaW8OdUQq2qQ5xA4BBB8SsSZlMZV
         oED24ByEI6nhPyLf3aX5hTrFIxKRBjN47A432hSSEZzGydXEHcLISfMxigcTsz31xeGQ
         nMd/XARI2zZiBwT1RVAkpKy3QeBmK6TLvo5N8qO5rRBIBNpFt7/VOqe6/EgpNGG5FyNB
         XFIB9nlnIs9PopI5+McX4Cclw0TnSAwAB02xEispzp+6q+wTWaumP8mlAezb91TSUzNZ
         2m4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775205334; x=1775810134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5cwHC3eZOxiU2/NZzUhXroPRJVVWV1jp1fwyeMJtdWw=;
        b=AUMZcaNOmYH7bTiZ3tB6zU3EO7D8gy0C+qstq2yY1hIlFd/jHm16dRlVrjLKoxV83X
         cxiR59I3yZF4KInTA4aJoSvzF6YxCnu3Wq4WX+fUUNzzmXo7emfstG8B5Eeh/JoelzgY
         hV1+sfgJBPPCcv6zpqz10c3gLZKeN67SZzthYHK2yEpQEoqjXIXj713PFwZ/KyuYjmZN
         Xjn7BfoLpolIKx82eijlK0BiGyhsXbM5b1TKWYbQIjsU4hfrR9jvmKmrJ6TRKAasZ2t4
         nJDJwu46BzZa3EFL4BZDEVje3GLDKeReunq6NWbiC+y8i4Vl3bUOjnqWGTKNaCmBE/yZ
         62lw==
X-Forwarded-Encrypted: i=1; AJvYcCUG5NgKxGF+hNX56XWenHA8/LC1es6X6HVgT0H7/ydFuG1fb1qkq7K4wGSJFFkxggh9eJCH3qZllyeyst0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+ESkoXY3Npsd3i07/s5MNmphs3zpvdRcm8jzlh3cvj+U3iLaE
	mPR7Jd6siXHcQeD5yuEwD1wZdsVjonVns8xVRRH81nlN8aNffjJPNYDedRGJ0Fl0qer9SaayL/T
	sD6I9+hskv9cDeDrxNCjul0NTuTOXbIg=
X-Gm-Gg: ATEYQzyVF1HXZx3wIqclGGhdg83zNJcrttnsV+JDlWZugB3lZ/pD2aj66yomVMD5igW
	vG0fmpdt4Lg8jfAOtzRtLPSlMAvDQeHmrfO1o/WS7eHs0mHbi0vo0QvlyelCWsDp59YzlETML/u
	bIuYDsBEYYkq4tkHsjvKq9Xg4aXDDWXuPUpnFB+RRJVBPAeoBabIDOObyoPwp49LFPDuOHwBoOd
	8tsv6sSuhRmJDkwcoMTVoBEMc/UwfnqWpjP6BN090BCL2Lse3o9nqOUclKC+db7B88zKXkbQVoF
	0bq6hE8M
X-Received: by 2002:a17:906:478e:b0:b9c:69df:4d8e with SMTP id
 a640c23a62f3a-b9c69df5f1amr98269666b.25.1775205334163; Fri, 03 Apr 2026
 01:35:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
 <CAAUX2SVmu+_Avs=6ipdJY9iciig4w6DzGNGaH_ZQf+LNqR=KVA@mail.gmail.com> <SA3PR12MB7997CAA00BEFD7402AC63DD7CF5EA@SA3PR12MB7997.namprd12.prod.outlook.com>
In-Reply-To: <SA3PR12MB7997CAA00BEFD7402AC63DD7CF5EA@SA3PR12MB7997.namprd12.prod.outlook.com>
From: Tony He <huangya90@gmail.com>
Date: Fri, 3 Apr 2026 16:35:22 +0800
X-Gm-Features: AQROBzA1m_wQDaVSCgT3cerSrI2bUJahBbBIizfsTd8TaF04s7vtqN975bGKl4I
Message-ID: <CAAUX2SX3wjsj8JLkej4oKR=77BQK2AEmc2tAqe8eCJqO=gaizg@mail.gmail.com>
Subject: Re: [PATCH v11 0/4] crypto: spacc - Add SPAcc Crypto Driver
To: Ruud Derwig <Ruud.Derwig@synopsys.com>
Cc: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "robh@kernel.org" <robh@kernel.org>, 
	"conor+dt@kernel.org" <conor+dt@kernel.org>, 
	"manjunath.hadli@vayavyalabs.com" <manjunath.hadli@vayavyalabs.com>, 
	"adityak@vayavyalabs.com" <adityak@vayavyalabs.com>, 
	"navami.telsang@vayavyalabs.com" <navami.telsang@vayavyalabs.com>, 
	"bhoomikak@vayavyalabs.com" <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ruud,

Thanks for your quick reply.

I would like to confirm my understanding regarding the use of
SPAcc as a pure crypto engine in IPsec scenarios.

My concern is that the main bottleneck may not be the crypto
throughput itself, but the per-packet overhead, such as
descriptor setup, submission, and DMA cost. Since IPsec traffic
typically operates at MTU-sized packets (~1500 bytes), this
per-packet cost may significantly reduce the overall benefit of
offloading.

In other words, for MTU-sized traffic, the performance gain from
a pure crypto engine might be limited, or in some cases even
offset by the overhead of per-packet scheduling and DMA.

Could you please confirm whether this understanding is correct?

Also, do you happen to have any performance data for network
workloads (e.g., IPsec throughput), comparing:

1)with SPAcc enabled

2)without SPAcc (software crypto)

It would be very helpful to understand the actual benefit in
real-world scenarios.

Thanks.

Tony

On Fri, Apr 3, 2026 at 3:59=E2=80=AFPM Ruud Derwig <Ruud.Derwig@synopsys.co=
m> wrote:
>
> Hi Tony,
>
> > Is SPAcc capable of handling full ESP packet processing (i.e.,
> > beyond basic encryption/decryption and authentication)?
>
> No, SPAcc only implements the crypto algorithms.
> (The name/documentation only shows that it was designed to
> support the crypto algorithms of various communication protocols.)
>
> Regards,
>
> Ruud.
>
