Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CDA242D72
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767215221; cv=none; b=bR//tggOtVwftBaKBLRZqJv3d85MK56jfSVLjyH4rBWgKqBR1xwrX5BQ4y1m2RnoR2540UmW84CmIAeS7i6j7u3HeYOZZn/4N/NEek4qbiFClC/+cQhNpDVwo+yN7TydLhTL1d+ZhLX1ntc55QGc982JwhYLTD8wEEsLIr1yieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767215221; c=relaxed/simple;
	bh=hXY0z2RTCx2IayzS/hr4AMGX/MGY2zH4FaDqoTXDYfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vqvb+8EREdkkoJmKrjNgEyDALgrlMv1UfkAjPp84G48aCZ42I/msqt6ypt2qrP2ySnUyIj5ofae1RUNVd8vahXbpMp4nRUUIDYcHVizro0H3m95YNnXrJmt2K7ybQoFzSVrprdZAG0p7/0HIXTHSNwT8OdK98kBUSVPOrh6R9zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKpB9CQs; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKpB9CQs"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34f0bc64a27so2719543a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 13:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767215219; x=1767820019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1ZWaanXm47B26qX7kDszQnTW7zmwL2leOV+Pb1tK7Q=;
        b=GKpB9CQstUvnPpXg05poBihyKlHyIMBFRBidE9alLUMu/xklJ92r1MQvUldbhUbNqa
         hTqjPTIuuj/W/8/K4bwcB1+2/dF5GMzbr5T6tTwQAjTjgGbH6xMp3LvSuw8jX3bNNPqH
         jk0lJSNagJWUdeclvO4tu2reS1odic8a1UlUCAqlzxrMMJ/6cF3Pr0JB+FMHaFYKaAvg
         rEJQm8lL5GegHYSB3H509h5dJjAM6AG850kyHpBMTJLgBpuBGybeHiowYLt9G9jUSZjM
         4SN2hCHnaxbgT0MWVX/SSBivSj9wD+5NGVWGoR1cNkkMQ/JlCCaLhN80e4/SjuEV2HRR
         c6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767215219; x=1767820019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K1ZWaanXm47B26qX7kDszQnTW7zmwL2leOV+Pb1tK7Q=;
        b=tukUZe6IoUDg+2ahmQp0tKrHCAtrf3TzduocdyW3HPqDKX6R4NW7fOdRFdHLXhlJYQ
         pk+Jb0GZ6dVEOYejGIRf0GErzF0QACAKtFr370eAcPExpIwbwYGG+SrZVlTuZSAJ5n6P
         eEwwGVDh4nrK5zOZz2wPMkhnftITW1PIy+G6CrAJb3Ku4m9zd6A4v8+pNUi45IcoH60o
         XsrhrR3mM53NCERvPAZ9YlZrwT+WmJII6107IObVPOvSFu0EpKgtp3xQ+cUJw9/tpTn/
         B7ILD6xumZjQ4xfT31miQA2A5LMzq9kHHax0OuIVsXGd62m/fnJIkXTgLPc65eqoefG9
         DVIA==
X-Gm-Message-State: AOJu0Yy7KL0BZPgCsZ3/qBXxFs9oV8jqK62Y99iSTQmgatHo4URX2Ivp
	DDhIqcA9DCdNzKnUBJuv7Is32/a6cn9h1G478LnTcNOVKh+4zGtttpS44/2l0iiBLD/h+PNPolS
	xwR4TYUAxpwAA7tqqvU7t0XJp82gkw50=
X-Gm-Gg: AY/fxX53MdpGzs1AT/4vxFFGDMSe8v9GiaX21fYs2kmMyMO1KmuhdgZouLMejs2HtHd
	EKw8bUApWui/GCc8UlVJzM+vv30OPGWFDwS9TA5xPaJniOI2PUMZ4UPbbX2QyXoqnMf+GRjGHZj
	Ysu8MeC5pX+igc3+jBRzgsqpC5rmbP1cdB9R8BGur/2BF62sC27zFfgkTxKjwwshYmqDEU5PX2D
	TmuXhTl85Dqqi7VqM50mm5OkUIRJsoNvg4BpkBQehuF62yZWmOCHID6IGTYigVH7td6/Ww2ww==
X-Google-Smtp-Source: AGHT+IHOH80RBheEwq7MKA7j9OO9E8H4gjMPZ0bsCxBVyZD1vWpOCOlwCy1ssnvYJm5Gza9MA6LpjuUCPW5TpvAOPv8=
X-Received: by 2002:a17:90b:2585:b0:340:ecad:414 with SMTP id
 98e67ed59e1d1-34e921e7557mr35034139a91.27.1767215219482; Wed, 31 Dec 2025
 13:06:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>
 <aUJKjXoro9erJgSG@gondor.apana.org.au> <CADvbK_e1b1uF9izfeV3KOuEOckCBXnFKL4NRjb3ZGHih7F89hA@mail.gmail.com>
 <aUijI8zYq31rSY16@gondor.apana.org.au>
In-Reply-To: <aUijI8zYq31rSY16@gondor.apana.org.au>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 31 Dec 2025 16:06:48 -0500
X-Gm-Features: AQt7F2ojQJIJfBbSB4eqhmV1MU8SsLDNhOj1bzBasJwAQ_WMrog8dRksO-3d95o
Message-ID: <CADvbK_dORpkN7Gu-xP7WyEcCJmzn6Cr-Fu5_1aHB5Bp=Ahzcrw@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: seqiv - Do not use req->iv after crypto_aead_encrypt
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"David S . Miller" <davem@davemloft.net>, Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 21, 2025 at 8:47=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Dec 19, 2025 at 12:58:49PM -0500, Xin Long wrote:
> >
> > Which upstream git repo will this patch be applied to?
>
> I intend to push this to Linus for 6.19.
>
BTW, Do you think it might have the similar issue in essiv_aead_crypt()?

        if (rctx->assoc && err !=3D -EINPROGRESS && err !=3D -EBUSY)
                kfree(rctx->assoc);

since rctx comes from req.

Thanks.
