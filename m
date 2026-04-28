Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F9F3D5670
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777406972; cv=pass; b=QBMVmRcqBbw7YOt6DTH1gQmNWhFdTF54xMuJqirFAESOhZOQITlfEQJhL/CbH9QbzIx5rmZC2XCmR0HRW41KfZtkWO1+H43X5Fh3xNrxfxJpoQZz1hJD6V83Wa2df0tiCXV5Xbc8wf7ofkEtO6EZDoiJOg8PFHv2hp8pTAKBa0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777406972; c=relaxed/simple;
	bh=SWN9RdOsJbK5+i0RsFKXguO7G1Oqw6OS6x/afly4M5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EcDMoD2iegDDs2KA3gsYRLK6PSEETUDUayDUUtDYXZHYW8E44vUgSOQoGnw/6tmyyYO/Adn/+sn4SoWJykNdQ7zObAfAmtUP6SwbCup8VHipY44ATNIiU7Tb5M7RB0e4GtDb7rHWXZ5NcRtbzVRaAAinN9/KZjzR/IurXVItf0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FwzBNSIA; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FwzBNSIA"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12c8f9846c8so11937541c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 13:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777406969; cv=none;
        d=google.com; s=arc-20240605;
        b=F4dont3s9Iu32XIW/dOaluUyg4l/8XaypttUNkmXcsPXbDmf6fYCZCGd7Oa1BN5vlB
         s+mWkgaX4mRcyh7JJsdXxO76GPB0GMVH+NZigK4X25FUTSaQrzuWbWkXmzRp6Y4hY0JY
         KPJO8Ev7paINyeMnqVpW4PZbQ4Q6/rH/7Equb29AMS1y/NH2j7wfnK/TK2PAIaQ6odMm
         duiJX4xVMqXYauENVuFBOniItZTYCv397huUQk5hbYNOS2Kms08cNnuIweWZGV9sObV3
         MPgfkcd/TrYl5Hzh1TV/igWAeggeCNfHWOYMu7+w7qfSWOz3N2nTlqxL8cit+95eFd+s
         v2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SWN9RdOsJbK5+i0RsFKXguO7G1Oqw6OS6x/afly4M5A=;
        fh=DffW7HC1gSJ9c95iuBm6HFD2UDid0tNHw4iBlCA3eYE=;
        b=Z3dq/sxvLFzJ9PU0E8J1K3La6MUfvVU4VxTd+ScZpjMqnkSV45ktVVba03xM8Ae++F
         hVX85jsASyKULbYThem3fGtA6hBwxIdJZWkwfyA5zNBVagz6ipAWMgiO0BtISh18gKbp
         my7mpsf+zeiG2QBrk8pXdzFiG5AvVhHr0ayKc8q1u/IzW9tCswaZvq7OkEQS8dVtBFZs
         J2w9ehMYxhOAH7vLAMngj0N0WC6opRdF6nrVXhoy3V3T71Zm4xQT02emYaRcYtMGKa/U
         HUst/Sc38towLBfC4AKX1Uk1t7Gz+3C+XeCCfrcJt6hSUTJlyl2jSZrfd6TvpHkDVbpQ
         rs7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777406969; x=1778011769; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWN9RdOsJbK5+i0RsFKXguO7G1Oqw6OS6x/afly4M5A=;
        b=FwzBNSIA/FKF7Z4nNRaoidcjmqIewLEuryF7hREgozsU8m44jIrwGtR9PtD/ZwBIvg
         S2mlVE2kl6TMKsExxdi2U2t17dha//gZb6aLXQFfIvwq0aoKHaBeWI5jGo/bwUuvHQX7
         c9znJO6UKNbdQrsxdhABV/LsBBlx5CXn3wKiiacrVBoOQuRKa6XhCL8DEDYIlzpnvfXe
         ZzVLqYWCpeE9SCGyahxz/iBLjKCUI5ssvRcja5Qa/KpmY0s7F4KShCqzi+jWx7Lh7416
         59BudlBT8hluJp4GsE1IWLNvB6ueilNWuKGrALYkavN3fwNBr53SkU5c2JIepYzHtyOx
         PnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777406969; x=1778011769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SWN9RdOsJbK5+i0RsFKXguO7G1Oqw6OS6x/afly4M5A=;
        b=oGSnTo9Ue2EmqgVIqvNuZSKDXEEmRWZWJVLbmIfBkW3FBHf1k6RmM0EE9Hc5XYAj0J
         tharhR7JTRD+llmjGl92SrEV6lUZrCrPXF0qNTwFq1lhIso1N4oP6PWaAcNaB04NE1I/
         vycWAf8HLe5VKJYd5Gb2nq4LMWEkFqUif6Ezj4kvormLInoL4pkLMAxOfoJJJ5w9hUru
         /IDnfHLKhqGEBCc9j5MR3K6HylJKki0sEtV5s+3QnXxavp0jlBDp31DZIfp1MTtyOw1f
         z8FVqzhhQ3JASUEGVsj5LEpjdqgmuAdytDsS5/uMV3F19pdHTfeAVmy6SN6IEiYHJ14K
         M61Q==
X-Forwarded-Encrypted: i=1; AFNElJ+4+c25jWHChBR2U+TSe8zfbTKZYQskN8VpJXgz7QShLzYzJn7dcoxEpDsm5Q/jYLHru2B3UGsaFCuZJ+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLY4y8HdSsTiscPz3a9OiVGosWH9hsZiFht2x06y66XmtO3HII
	Oda1AV5swt4m/mMke/Nt2RlE8FnANuY0ByuwmoNNGPcJUO1FDhbjRDGKyqetoirMMxzPgeTU+cj
	dS/DA5CNI5TmAGwsHQ0RKO1q/RfyBwBiCUmbkrBHw
X-Gm-Gg: AeBDiev5PPBKoOR+MAlhZt6HyNz7qgrarQfFyecc9o2n+Xsd7LpR7bwAkepCUENnaSM
	QyReOzroNfOFILd/MP2NEULNyyr9016bjZUCYVbwJzTrv1Q1/ZExBfx1yu2UNpIX4woRMF86kK2
	BcWCWMy0uhtDadglzgkfx2NPWM95KAu0Mnd/gR5b+UqOiP7/aQ2WTTEoyokWWXaP2MDPnP/Mael
	FavdamEblTjMlkj5xy1Wo8d7cXISBpir7s+RKFtaZFXtdHOBXXxE2VwsV1wqlHylgCNRAVPWgJS
	yhkkX+zW/Mr67NlfNnauDHxfdVycNckCRCFlvOUWG4kSam21aqhmXbbo/OlqgNftwsn+4lOHYj1
	MJuGAnEBqFXpz7NDNFbqYoplKLCGqfmUATItLDT0EDSD8VcMy38c3wGwa13E8tUtz1en7XA==
X-Received: by 2002:a05:7022:90c:b0:128:cf80:deea with SMTP id
 a92af1059eb24-12ddd9804e3mr1980451c88.1.1777406968574; Tue, 28 Apr 2026
 13:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104129.309982-7-thorsten.blum@linux.dev> <20260427104129.309982-10-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-10-thorsten.blum@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 28 Apr 2026 13:09:17 -0700
X-Gm-Features: AVHnY4Lxnj5buv7icbDKCKIcdnJX27YH-CComkTWLl5hcWgm0NuARrbnrAwuVhI
Message-ID: <CAAVpQUDV2zfdGO9O3LuCDNzabsLnTsiFLb6ipH0gUDRX06g7KQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] crypto: af_alg - use sock_kzalloc in alloc_result + accept_parent_nokey
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 3:43=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
> simplify hash_alloc_result() and hash_accept_parent_nokey().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
