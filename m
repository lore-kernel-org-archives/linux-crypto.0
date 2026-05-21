Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D70B13A3F7
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779377125; cv=none; b=KIZ+hIkBoDyMNjEXa7K6DiytbcMW1cxsIhzgzc/eRlIntB+cmRX30q6WsVu0Nu782xJFiIJZhLoYu1jSvOU3378umw4SZpe8GDowdQHTadIj0MyxAtn9Iq7HyC5xh7xDr10EXXgBfCptdtwW9EtOMFDF1qi8e0pFFjzD3jByIco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779377125; c=relaxed/simple;
	bh=QwJcNq6DwfRcfYtNuuboeWq6WH6NMFni3xDvmdLT4D8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=PbNVABVquecGQH+5aJlup7Ok0dhrrCQC18dSpK8NoayauIjDzz8GLFtNa9q49/GEAaUQjmmAg7orQlCylEVNtD039YwsROCfEVtd1FSdiqkIEo/+HVky4//URpSxEcOSJKLCi95Kz4ureTgjhOg4iJaqVI1Vn47xo8QlHk/4i4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OF6SqBjc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OF6SqBjc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so88192825e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 08:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779377122; x=1779981922; darn=vger.kernel.org;
        h=importance:content-transfer-encoding:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=US8Xi9z03A9vExvROAP26gREM63X2E/RakjDkVuRW24=;
        b=OF6SqBjcP2fzMBdiwpc2E6nsSR2rODvQnR4wZ24+XowuCKUM16tfBc+b4BkOSzXEMe
         /QZberazYA4y0/Mzy6EF05PEG8O13eN/SVy7URKGzKGqr6pWGbG+ep/WVjJGfm7BtdNK
         v0kHZWoYxxwxSaVL6QvS/mLUin2sEzQs0NUe+AIv7xWxopMKAHiRl06ubQRbsAMeuROc
         S9ax/d8eeIRKuROsUFT2Uy122a408AkjKReuT4hn9ET9K1S+yjVOvpIaWtb8mugsqqJR
         hz7Mw9hH10WDROuUj52J/4tG/XIWZKs0/8af+ytDYRIJNwEzyy3DRq1LuNBnQOt/5XoD
         Obhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779377122; x=1779981922;
        h=importance:content-transfer-encoding:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=US8Xi9z03A9vExvROAP26gREM63X2E/RakjDkVuRW24=;
        b=A1bwtLQlTop6DN5w6oUeLgfR2y004/rdcvVZyGGxka2hb2NciK3B0lc1lPYkaXl8Ln
         NTocaufP0jFwd7uYDAJ4hsKQlbUuJHqpMG3iVOKvAT+oM+1D2Gw9bI0VbWKbuVU3obBT
         BqrkdvfszQ2WBoBWw5ZUP1oZMwWHHlgXPijpc4dxAkiBL8ba38jWGWggFaUgznc2wioD
         64bwFrBaQJI6IGQgPHGBEziEUtNNq8KMqPjjdsOplIXmQ6XVj9txda+tChJSo56u9aeG
         CUSQoxauXJDezP/Wfl+sDRS32EvyvEMRFGZsHj7pTA1uohm0lvzbNo60PZ5bf1ToGji8
         cFdQ==
X-Forwarded-Encrypted: i=1; AFNElJ9gnbMG4IRgpPegbPFCELbScfz1+tT9hgdRx0RsoFDY90TFK0GL6sal5S6l48wnwy21DPTGKMpPqKJ3Nfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOKBFjIfVNf6Uglk7tahHSHqNQ8qFr06nW4J5KpklkusMnGgtA
	rey/smJxHoNLTwBuYHhlMUp0enYDg1JxQSWMvXr3vfOVW9xH5kcpl+qA
X-Gm-Gg: Acq92OGeBNifc7/1CjHRSxLYNVOdR/JCVQMsipNY9cxaSYlhOQRrzWmRD7J4NfG5vtG
	iC6UToKbzi9MCAG6deRpG361spg/ihIUnzL3Ey+ytG3QCMZ9VTcJV3FXKN342Cg+j3GSCAhbL5X
	hBGIdIcJRGpZ+KygtjkRfO4bqbnR/GDKcoNNF0e6NuwqNVdGfvHnqUK6chPhqq9NKfFvXNw9rGc
	TgnPPJL9mic64tw7dkfpdfnRxelaUzCL0WlGooGhgSdyN24hmeCbII1RAoh7H79iKv6eD5OOo5v
	5tuMOtdzKQSYdx3tl8T6sjp+fzMHix2AwOGRsrr2JyjMpYm8MZgqS81oZ4zi+zrz+AMg4pHnpJH
	1bK1sYqZAF53WfMWTWjTuA4+wdHesDTUlxTlqz7XixiBrlYG3qQYJ091rXI+V22iOmpRNufgWmv
	0pC3wRwgUDHv4UmLbKkvfJYTJVGoY7CZOXIDWFVv1hkOq/lMWqVayo9Gcp/YUmwoe5DZRXNyiT7
	qd3dPOToxMO5T1FUA==
X-Received: by 2002:a05:600c:1f89:b0:48a:5501:7995 with SMTP id 5b1f17b1804b1-4903606b594mr44755095e9.18.1779377121600;
        Thu, 21 May 2026 08:25:21 -0700 (PDT)
Received: from appsuite-core-mw-groupware-85f8f85758-9d9q7 (gate-4.heinlein-hosting.de. [80.241.60.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c9abbadsm33716505e9.8.2026.05.21.08.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:25:20 -0700 (PDT)
Date: Thu, 21 May 2026 17:25:18 +0200 (CEST)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: Paul Louvel <paul.louvel@bootlin.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: herve.codina@bootlin.com, miquel.raynal@bootlin.com,
	stable@vger.kernel.org, thomas.petazzoni@bootlin.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Message-ID: <1464270648.58006.1779377119607@app.mailbox.org>
In-Reply-To: <DIOA24QU02W5.2RSVK05RE7BJK@bootlin.com>
References: <142603430.61540.1779296295550@app.mailbox.org>
 <DIO9YUHO5VGT.3BLGH04NVJNHP@bootlin.com>
 <DIOA24QU02W5.2RSVK05RE7BJK@bootlin.com>
Subject: Re: [PATCH] crypto: talitos - fix rename first/last to
 first_desc/last_desc
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v8.48.98
X-Originating-Client: open-xchange-appsuite

Dear Paul,

Thank you for this review and feedback.

> > Instead of renaming req_ctx->last, commit 9826d1d6ed5f8 ("crypto: talitos - stop
> > using crypto_ahash::init") should be applied. Ideally before commit
> > 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request limitation") to
> > avoid any compilation breakage and ensure correctness of the code.
> 
> Small correction:
> 
> Ideally before commit 00463d5f864a ("crypto: talitos - fix SEC1 32k ahash
> request limitation") to avoid any compilation breakage and ensure correctness of
> the code.

I can confirm your recommendation. Appyling this commit before, fixes the problem. Please disregard my patch.

Greg could you please backport the mentioned commit to 6.6.y in the correct order for the next update?

I have fixed it for our downstream users for now.

Thank you,
Goetz
