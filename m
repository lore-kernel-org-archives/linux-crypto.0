Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793337331;
	b=MuxaI45kxY59qOMr1hi0Ia/suVL3v5cgbjYu2lfZb7EWzaWJEpbAcd5NPyb9PyMk/4pv
	 D/vxfJtyWS+Kue+FoL+9SHXFJh8EwhfXcgVm6lVx46Giqrh4WPV7Nc5zehwbL2N7LVPJb
	 noPgvP6Ev2R342q6PinXyPKynchMcRmTY0269xu+A/7teYixknDOesD0FZKq/TMMbp6tC
	 tGOxmdmo/Dpi+dSt01TpmSjMRXuGFIEQpmQBEhJhuQLC5f+XmqWnMoKsGOgbeU4T7hZII
	 squ1O56H2v1hOOt5EpjTwmqxSYonk2AKAwkBuQqMZ1p4vHe7YgKtPHMrhQ8jcmv5D3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793337331;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
	b=zJaihNS5cWfX7KqL5wlPGR5QaxEh+PESccJV45mybU3huqvCy/sQpE8TgOXRUyMcgGd1
	 H4ZnD78tyYkp+FJGeQ2R+hrPlGGZR7wnG8m22lp9LfMxl4yV1/JzXcUYsAAoHskSkap/l
	 fspeuGmX54/4H9sVev2dWHbhHla/7WFF5lIby2akvLEFL8Wy8Qvx7amIyOIrF72pDeiXY
	 dbyOUPIrmv9R81dmJrQQOSrbaJgba3q5BJYuGnytVY9VDlk/rrzCgQz1JcdXltyGXhUMG
	 Sb4koirYOAIkfEZXu6LJSgPS6L7DBQBFO/MzJUdyaNh/+gL/kJ/eFxJCseyNXWYEGzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="soK7AlZ/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BA8606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 05:15:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52BA8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=soK7AlZ/
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bb7c6980f1so352390e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 22:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793337329; cv=none;
        d=google.com; s=arc-20260327;
        b=Pm74App5h5EV9Sxw8R/QwpSbMMFokBA02Oz9E0VnGGXWyNfNo31XDlRKMnsysRC0oN
         D1HPWKstOzXEGG5K5WBSiGQ7Bu00ifk3iBFD+MDRDNadcmQgJjQA2UepDMHOHcvL+iQC
         PjgeqKLnrwcHCYIDhNf04f7pXhGA4p4VTcAw6wlkiO5ogaqdFGjrSHt0Qw+EzvVIQWaM
         LHhObWtc/JdAHOjPJ18ZpKEoaTiDukV9h2HegCAVrKkqZYRAGfLL0K82Og9IjPsqIwqr
         hReCrA9ohkmEzzeTJkv6/9l1visZwfdFYOkReoVy1dQlAn/huiGbPubQjN6Krnkjg2kA
         liBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
        fh=q81toP0wP8v7RTqZRSaYRCjqPHb2cG4fmelrdO+rF/A=;
        b=ZZTcZPXx0rzNQrDaW+oUj0sWbSqmX+2lezUqYmxamd/bnFzvU1QRTyIOYsEk3Au6dh
         GOrDQFb+s9ocejfF7rz1bLAO95Z73a4kIFZfIE/pw9S3G0MgqUPXnCYxxQkyGQdHUCWb
         Rucv+T7HzvIJAgGK5rgzoy+4jI91NrY0kNkRfuuqfWiOovhueWyTF/pL6Ga8abE9kuiP
         9Yi2RfMn5zOdXh/84PH+BQux995HfPKbaKPwPwq88nnlLxf09lO2oN57uAeBewSdeHiP
         vUXqxqpx+z89tIYBJlLC6WeN0e9G2aAagWBfe8OvdWfXp0bMQPVfmaYrIxLDYhdyKkYl
         7+7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793337329; x=1793942129; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
        b=soK7AlZ/r4AXsWE0W+iIZ105wIvs+I7WSy1GcH2zdOVl/gC61FkE5ZGDC4G2swqNxw
         viQONjW+yGzmWp2soJ21TnieHSfgayMb6gLVxj64TdKlVRm3UH797a78Mcu4ZLsWv9jA
         cH3NddGnKgKsKlZCS8g2YhM4kxpfPFDybOmEjRnzrhyVhjTEilD+7XuYYD6yXkMuhBFg
         3vAMaqQpR3KlbNfk6oLbeWQUpOY6EWLNebnTtpW5U/TvvuWuCjLEEkTcAPZPICkETfek
         d4BZYpIqnt/Xq6xf4nPRQuj8MVL0ZS/Vb5mxeQ/Se+x8Tqab0qKVM1cMxvVtM4/ldOvv
         TnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793337329; x=1793942129;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
        b=Lu90D61haxg2/nAu1oMGnO0iUMyTo4yVQLMOZpJ+9iswN71yv4/yaVVRhjYYvR6Y8y
         s0MK0CrcCZvlvzCMa8V0cHzrZ+WhlG4XfdTmczfayIdVJ5OI2rgk/uiMNDJOgpoFMUkx
         +UtlHUuJ+xPlMNLwhPwGclAQAuIXTfL2CUHQPivel1xKoPY0lpFjN2LbeRR8hdpmEvUh
         gMmtTVJLOPH84IKbeVVxSrVffuvOmc4sa7EBln5xTBKZpgno257DjQE8WMH793hrHtad
         qeU80Ay1vBi+PQ0uacdUT8cfpkIBJpyHcxtIcoCPft9i75WVzAWtp+C1chHor/Q+VSWz
         ZK8A==
X-Forwarded-Encrypted: i=1; AKwUvBz33YnOTjVI26CuvClAHzh+QhOB60l7Lr1el0bqr67AqeF5ZLDihHZltMVSZr500baugiaxUFw8XB2S+oY=@vger.kernel.org
X-Gm-Message-State: AFq9FYL2EFCdBaYENcgV/N1aMbmUggNh7ar6w9W/1xDKeY8r0bz6STlh
	P3rCHVXcSgG2MAKQsFVmCfDUB8e/iA+AVBy/cHTd4UtzT2LU40jNaQcZWMpGmNJ54QC7A84tl/h
	nuz4gb+G3nE1DBUVPrbrL5qR6J8hqDnw=
X-Gm-Gg: AYBFou3YBDo7NwUZKzpM8GDilcZgXoqCPyE8haWYB+hKLhPibwvJhk0W86pjDP6ewL9
	iV6KnSUBbE6MLBt+hojMbHWUYwAbRtiaaolxlWYBGo3SChDnCMOtKdm2dKLx/Dy0buD1uGEIj8X
	lhOTc+5EQXyaXMQKkNF8wIv8Xrb4PSW0DoeyN9TlNqE1SQXW7HhD4cZu9Ile37zUbdV+PcyvGfa
	kiOeHS3WAD+AxhYiyNvf+ftE9lFjw1xbTPaZW0UKcHNMqxhPvJ7CKBgVGKFTvqF8fA8IXygp31x
	iXdUxnndfaWZGCGePikPHywo1A0iqjps8YsBj/aj/qbtw6YBCqzIjOzJ5uEaPf4gav7L7t7qbCx
	OoFjRnOE1/Jp3yRKyr6+7g1kHSNEwvFJcqBi3
X-Received: by 2002:a05:6512:6c4:b0:5bf:6c4c:62ce with SMTP id
 2adb3069b0e04-5bfd957e727mr296888e87.55.1793337329304; Thu, 29 Oct 2026
 22:15:29 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au>
In-Reply-To: <auQhULh1VTh6lWoe@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 22:15:15 -0700
X-Gm-Features: AclHuK_aVAvKy7VDR9aeCsm3QjdEtQQMz0IwVOpBUfBcF46N-aien0GXVvgDMaA
Message-ID: <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 9:47=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Oct 29, 2026 at 03:06:03AM +0000, sashiko-bot@kernel.org wrote:
> >
> > Additionally, because each CPU independently calls crypto_alloc_acomp_n=
ode()
>
> Why do we allocate a tfm for each CPU? The tfm object is meant to be
> reusable and you only need one for a given algorithm.

This is how it is in the current mainline, and has been for as long as
I can remember.. I assumed it was because we need a per-CPU acomp_req
to be allocated for the tfm. Can this be done with a single
crypto_acomp for a given algorithm?

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
