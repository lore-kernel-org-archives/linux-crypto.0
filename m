Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096438D3FF
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 09:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780304625; cv=none; b=GWBpmg3V13j35QtyrV1LooeSiU2WH43Dmy8s/vB5smrIWT8wziqj+0JsQvkafKhPIwjSpii2j28SXQhPbERGzzQW6vSrs2PZeuInuVBQzoh4t/ntZLag/oVPQ+OEkajroDL4NKSHeJ7oIjr2X016lJ3FSirjXLjO4AVYxnH+vs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780304625; c=relaxed/simple;
	bh=4DjmUwOCGOcB+Zvv7fk+Re0YCdBWlSozkc1Kn99ViNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an2OXB4JJSYGarLJECGkfhQidd+SDMnchoTP/IX7nqCXhtH+paM6OjVfWkCD02PxO2vVL7CuPYOAcMgJgZmNz/0ubyJ1uGl8yWD1icx6wsDKoHrq+K0JoCfLXCWx7hroDdLclqwlgQA4rG9A5bLgJIOcLu0ZIQcZW4H6Mwurk6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b/qwF6XI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b/qwF6XI"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso1405555e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 02:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780304623; x=1780909423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DjmUwOCGOcB+Zvv7fk+Re0YCdBWlSozkc1Kn99ViNo=;
        b=b/qwF6XIJvHX4hLWbFVjjtKlcnEb238dkdhjV8dxU/LwTPSnMN0Uxbflh6qQBWLkmv
         io6ylku+3DlgfEnr2XiOOyRe+lGQvuRaREE/psJKEz1KgeR+v+PQqbR67PKaECguqpwX
         015OQR1cmnp/MPFwXSos68QSBA0YoOS4/WMF9JiKUKtvTitrOk1ZE31CquOSEDOi71tv
         bZOM6sb98VYjMObIlVXUKq8SGnGE0rtElsKtzoiIzmxQp9Jgqb0QetD1S0W+eiYBbXFt
         YhXaQiASCjvWH3fq363QNUly8U7vlmqbMFXRMoHAjCuSqaeGuGVwrx8aLoURG7j/zBjk
         EcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780304623; x=1780909423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4DjmUwOCGOcB+Zvv7fk+Re0YCdBWlSozkc1Kn99ViNo=;
        b=cNaAv9NMsdl5GJ8r1s+0Dyp0ayq3w6D19sF1ihKas6OgacTRLh+U+8Qb35tSTOVtmn
         Wn0jZsFqhE6li1VRIFNId14cSJqtImYKcnBdba/6fYvKPTcSTaLMQL+Wg3TzjnMBbFZp
         iswIGauSBw3iIxBJwaCsXun1ALdjL7yd1LG9ay/nT6eVuMjggaFKZ0uNoI5L+pWv88nm
         pz5tPVgzk/mYncOF+EXYfxeQshjAa5Itdh7FbCo0Rhe4Fsp0e4xfDGRjVQK5hNPfUNcq
         o0f49g9n6BQDNgXIvBIh0KBVBow7DjyGXirKnBuUjpjfJu5SlIyarsxKE9SGNo5p/tSN
         3pIQ==
X-Forwarded-Encrypted: i=1; AFNElJ+6Nn55PwPrf+0h5aeYH3HlHBXgRgAGDj3Hr0+0p8KqVazoKGP5X9whFl0P23Q/bA0X9E2N6oAMzhTjZGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXxSh9xXp0J7oCC7wO8SIvhJHUlylR1dOlzTCMfEzWb6qIgpZr
	fcTbwTkfuBen6L+f+gtszntQ2ZcYn7cqIoBM9SDdGnJzAL9Kvo5Yh+WfNNiD/lbWRBo=
X-Gm-Gg: Acq92OH+Kvo7SuvOxOgm5Q9IscrZLy1wNjKMI/wjEXyen4M9N4yLhrND03ShCUauw8+
	DmR9T4rcmJLVgn2i8bzmBq6w0QujYZRRXPfJHlUguLbzWctqjdTyxJTwpRwA+zt4Rr32wbaqxcJ
	OhGXapJrQ7Qgcn1KWPgnsTQ8lLTAOoaNIbkYCt0WYkLqyH+zIi0+g3zwh1tQY0SjZDw3ff0qjM5
	G88g3NISlTa5E3C8wdPSQli0NUKa16gq45W/DDZW8+znUOGNsVgp3Y5xxX1XOAa+alectYX1EFx
	hsepC7HfF91fBJwhjeV/Cld1XrkQ7ah01yHCluRaiRALyP/WDA+jlj/rNp6/3tqWXjhXH+zNeuB
	NfQmdW2hLwB6pYDrxBbVaWCwWntf/RMN63DsT7EkxIz+WWQbrQ6LkEYaLX0VV06h7VWzc5CcwLE
	WCGCCHfrht2PljxnGvxuOQjgSnZH9vXCZ1hp656UEvYFarsc6Dejk4lPJFxzEOjiNY8z9t
X-Received: by 2002:a05:600c:458f:b0:48a:5546:61a1 with SMTP id 5b1f17b1804b1-490a2915aedmr194248805e9.15.1780304622657;
        Mon, 01 Jun 2026 02:03:42 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c127befsm74525925e9.31.2026.06.01.02.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:03:42 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: l.rubusch@gmail.com
Cc: alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nicolas.ferre@microchip.com,
	thorsten.blum@linux.dev,
	Marco Crivellari <marco.crivellari@suse.com>
Subject: Re: [PATCH 10/12] crypto: atmel - update workqueue flags and add flush on exit
Date: Mon,  1 Jun 2026 11:03:29 +0200
Message-ID: <20260601090329.52616-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512224349.64621-11-l.rubusch@gmail.com>
References: <20260512224349.64621-11-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

> Update workqueue initialization to use WQ_MEM_RECLAIM instead of
> WQ_PERCPU

Not sure if you're working on this series right now, but this must keep
the WQ_PERCPU flag. WQ_PERCPU has been added to mark explicitly mark
workqueue that are per-CPU (it is the complement of WQ_UNBOUND).


Thanks!

