Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAB84AB1A8
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 11:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792409841; cv=none; b=Z9wmlokNTy24rG5R+jjUnMi3qAKbFw5uDRkHfHfqyinu1+JDbYsK1VhCD5bhCf1p//BMqb5n8mo+0rRBuNYzmkgjNaa9hqdTmVvYNHjKAgIeIDAvRD45debu/V/SCgwLKTLZfjjL1jRak29nBT6519++2i28vgwgd9Ck+Yukt8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792409841; c=relaxed/simple;
	bh=W5WoGAQZEA3z+n6sb1CQZP7onZpz5lPh/HjijfzYU+c=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J28ENYWrSJjsxHrKf/KQtY9z6AEkxSphcLnYhdrqCpbCRyRWlfcgEN4PCzIbZlVqMZ2Q+9Vb3D+jvMlDCACLqalcFeccDBN4yq7WivoAAbffn9KwJ77ihUSz4B/hZBvJt8DcaXoQ1IkqsTHkbKxEvF+TyWVcp5xOhhEkooL4q6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVExZhGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVExZhGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5357E1F000C8
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792409840;
	bh=W5WoGAQZEA3z+n6sb1CQZP7onZpz5lPh/HjijfzYU+c=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=iVExZhGQHZ+XSLnTC4o9DNP5pIxf++6cKY/WfUlPkukWHdJu/s6GOPunhnb/fGHa+
	 8hYmYlUNmKnPAdYB26kJ+FLDmcvsY9qdX7ShqPaGWsBov+pqxX6/F7GYWSgUZtlCPQ
	 lm+j9y9hqn/l8ERIzqgCp4jz0hSjYSIYHXtVz4N8PaeJhNzxtOeCL1dRvFswtG1bZG
	 Y47hRL0w9Dae9YzaKB7NESAZH4P74zxrpttUHuSLfxo57s5yPvpNzhdRaNehhvTW9j
	 wFq9ZCOnJrCepDZGomQcVOSuZxWtHzz1X7ejYBJFwIVvUVLxHS2FjRdC2Qmee2P34L
	 bt+qL4loRflxw==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3a9787a156eso14436471fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 04:37:20 -0700 (PDT)
X-Gm-Message-State: AFq9FYKDHAouM8v59v2oQlXJUiab0VCQco2YAxyDKncsstqhlKyi1OBJ
	/0qBTieeeYi6tflMWIG952v4GrBtYIfoBeTSpBoE8x4Y4cWDHpKz8dYaJTYLZVAnB5jvIo81NRT
	fuc5pdblJr9JUxbZcqXNHLwut/iW3FYyjoKHp2Jv3UA==
X-Received: by 2002:a05:651c:324b:b0:3ab:1207:bd2e with SMTP id
 38308e7fff4ca-3ab292cdd44mr14176911fa.19.1792409839005; Mon, 19 Oct 2026
 04:37:19 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 07:37:17 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 07:37:17 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 07:37:17 -0400
X-Gmail-Original-Message-ID: <CAMRc=MfV9xXEOPZs6QEdnjYmJrpqQ5Lhib1EaR1Fj10GWfKVaQ@mail.gmail.com>
X-Gm-Features: AclHuK93G4nxyMn_dCbdpAqan8MyvoEL2tyPub0X3b72Wx8IgwKQ3HRq4Oh-mvE
Message-ID: <CAMRc=MfV9xXEOPZs6QEdnjYmJrpqQ5Lhib1EaR1Fj10GWfKVaQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Fix HMAC self-test failures for empty messages
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>, Bartosz Golaszewski <brgl@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 16:23:43 +0200, Bartosz Golaszewski
<bartosz.golaszewski@oss.qualcomm.com> said:
> BAM DMA cannot process zero-length transfers, so the driver always holds
> back at least one byte to submit to the engine and only ever finalizes
> with an empty buffer when nothing is left to submit. For plain hashes
> this was handled by returning the precomputed hash of the empty message
> (tmpl->hash_zero), but HMAC's result depends on the key and cannot be
> constant, so hmac(sha256) produced an incorrect digest for an empty
> message and the crypto self-tests failed.
>

Herbert: this should have been v11, sorry, I forgot to force revision with
b4 on this patch. Anyway, sashiko doesn't report anything so this one should
be good to go. There another small issue in skcipher so I'll respin.

Bart
