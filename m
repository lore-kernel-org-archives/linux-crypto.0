Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474410;
	b=fTHfK0krPgMitkMkbSLBZ76feg92JiOcB0+28mjv9LXS7cRaXTMYG5QJRqsz+GO5CGwB
	 TUOU0/zKbUCgEoUHCdSaVceRupFtEygpuYvN7aSt60gaorgYB8HhbYl2XgWn2QrWSVvA3
	 NAZo5WqtrcFgWJP8Xvl0GNZig60ckVQ52SsUyIphMVYolYOlyFUKBULUzB3r4D3qf/t7J
	 5gsxtsRz6Nv+WQ5YILr24Q54lFIVVeIXZ3OYxN9GDZnzdfmpGj5wzBoMR/uZDHNdyciPW
	 BipHYrkcWcYboRcv4e7RQhCOIXLg6oWqzdYGF86lcp4r/MEE2S91PwuIwvcS1GGSlPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474410;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=AOEFU8qzpm93qZ0ASBa3G2K2mt+nms7YtGgBndT2NAs=;
	b=Rg9eFcEzZNjQDTxtpRNdLOg6EIXnJrUNMyLbDXNmIl4LJnM5b5IZmvP4E2vRQ2AaJNt0
	 MURoCI8yXZQY/8ac8V7PfJW71TDGE3djG4qGr6TpjapIN5MGHo/D82Hxyfbb6QZGwpH6f
	 kxeAee72kfuc/abgsuiRDiSVUze3OkXXhPDyDL722vp1Cxut3KjirK1F3myH/xp7QJIHo
	 p4C++sP9VQC8qScum5y0wa1A/DwxAkzcl5gbXuMGdk0HDM8Xs8UyDRx6ieNzsSTzcAPps
	 QbLXCzs82x+07Od8xV3OsWSRnzXHMAWwR88MiHgC2k9f8oRadPfrfytq6wFuyewuljw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=fJQCMBQ6;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59275606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 09:06:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59275606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=fJQCMBQ6
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so49381855e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 01:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794474407; x=1795079207; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AOEFU8qzpm93qZ0ASBa3G2K2mt+nms7YtGgBndT2NAs=;
        b=fJQCMBQ6bEfikb53H2FDBkryxY8kd7OKhsso6FL8J1BMHNLRRUPDHng5PEiNSdOTsi
         6X5VjQMWOTQSAPL3adCNUcJp66Kl3GMR8uusg55hfNQE+Yw5HDt8QTXKIeoxrEmRGR7l
         iaqTeccg4O3Vy6X+hjjAr5wsATeZrBzjeamgUci4RCTP+zYt2JSPquCemKE1dQjo1jvL
         Zo3Liu9DKGRbZJ33FbFESxEOLlNApiXLfKR3BajjefqerhZOqbPpspvWoEZQxnIH5kDV
         i81Y6SUTuxb5uWkntohRGmel2+N/qmEhDpV7WNE4S/WcNj12jdUMgBTqWsbQ+/TaoSIi
         yyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794474407; x=1795079207;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AOEFU8qzpm93qZ0ASBa3G2K2mt+nms7YtGgBndT2NAs=;
        b=2imihgOlbJ43jawQb5t5FCVm5s9GvkmoJG767xZC/+7gnczGz8q42L6VEqAh8Ah/Vc
         ZFSbw3QDbEQKLD1xfULFAd3Z5O+ZWGkw31hrz62sTTN4BG/polZUD8ifBXid3r+iP+Qp
         UyjUSMsEXRHKuyiTp6NgUGuiUlup/rMdo2dTLSYw9tW4U7f3ACVNHf3xs5tw6zcOjX8h
         PBcIzZsR7XpI9xNkUO24L+59f2WdFBU7EZbb60u9ypE+J3BYBbTyUNI5ckZsjLJaaJ44
         jGFIuK2mapJT1mAh5v8j/bGWUy8iFh690+fdBLwMQvmb1XRQPCEal7w4NerG2EFnBais
         Sy1A==
X-Forwarded-Encrypted: i=1; AL+hErF9nQW5AfQK4vIMOQ+405ykrPI2BTlVBxUBiHTYsOp0aDVODTWtmztzgDeYDXA7VpZRO2c7m6F/oIHAuD4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Jtq/Wba+OFkQSU1jdwstM01RbPyKl0S7hMU1rFOxwDW6Tz4XM
	g4Zby+uHRhZndE9TMBJ3CIA+3yHOgze9v+UAl0IiEkYq2d4KhVHXx5LzoUsrm0WXtkvhFN7c/v/
	hYqNoaow=
X-Gm-Gg: AYBFou0s+zVwTV9Ft9xhtJ2St4NGcJFw6iuL9PEPDrmYaq6mw6v+uBhRgu7+9xQl1Wl
	hPbZewE2fI8772/0WYP/CzM2JK2To3g/dRFRc2io4flhAQWJcsHSJjB/XnD//KT0PewPR9tFBvT
	jEOpVrZg2f2KFIt6Sm5wSR6D9G6ZUPJHc6UB2fiV8cFJR0Uu5YqqG+CztdjF/K/thXVwkvkXQKO
	6pbvndhBFNOfkLHEyG6mXXmRz2/pjptST8xYldx/kStUnp6jjIWrDMx3+VHuq3PVlDgV8eFW52f
	s8yWK//sLGU9Tpjk5FpSPkpXnmjusGBXS1Z1Pxo4sZdBfOsCHxsGWUeUMpBQy2BReSLtJalmi9C
	TUqNFy7lDUJXd0LYCMcMnaWcEYU3e+tGBMllD0kVX6rmMmhaGeJZ+6Oev4RytzjbMFmLmbqjoPV
	2BwAkoGquyRi6+/uqySlXcEOWJvxWK4zhIA4P+weHaXeyVnaVStP2roHIMS2YESFT0U44BrXl1l
	SrUmTKmO9jhZ2t5erRg8kQzjKrL2XTZfiZ2CroQ5H6JyLrivr+z+kWOmbKIAOnb+YaMicolXYPm
	uxB3r1Le/oX7A6ow/qiI+p0dFKQ+TyHLrers01TpcfYCZLkYwFexUyM=
X-Received: by 2002:a05:600c:1549:b0:4a2:cbe:bebc with SMTP id 5b1f17b1804b1-4ba0938ba0amr89292435e9.23.1794474407550;
        Thu, 12 Nov 2026 01:06:47 -0800 (PST)
Received: from [127.0.1.1] ([2a01:e0a:1264:e140:4d18:9bd3:e16:ab6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e26c2casm49653405e9.12.2026.11.12.01.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 01:06:47 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] crypto: engine - clear busy and recheck running in
 the retry pump loop
From: Jean-Michel Hautbois <jmhautbois@baylibre.com>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 liulongfang@huawei.com, qianweili@huawei.com, wangzhou1@hisilicon.com, 
 linwenkai6@hisilicon.com
In-Reply-To: <20261109073556.2517351-2-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
 <20261109073556.2517351-2-huangchenghai2@huawei.com>
Date: Thu, 12 Nov 2026 10:06:41 +0100
Message-Id: <179447440150.262855.920255293147441135.b4-review@b4>
X-Mailer: b4 0.16.0

Hi Chenghai,

> When the loop drains the queue it exits with busy still set, and
> crypto_transfer_request() queues a pump only when the engine is not
> busy: if the loop ends with the inline error completion in req_err_1,
> which queues no pump, the next request is enqueued with nothing to run
> it and the engine queue stalls. crypto_engine_stop() also spins
> waiting for the stale busy flag, up to failing with -EBUSY, and the
> loop keeps submitting to hardware after stop was requested because it
> never rechecks running.

I ran into the same stale busy flag while measuring crypto_engine, and
had a narrower fix for it in crypto_transfer_request(). Yours also
covers crypto_engine_stop(), so I dropped mine.

> Jump to the idle check instead: the loop now clears busy and exits
> when the queue is empty, and stops submitting once the engine is no
> longer running. Engines without retry support are unaffected.

Tested with virtio-crypto under QEMU/KVM: a small request no longer
waits for a big one in flight (about 350 us down to 4-8 us).

Tested-by: Jean-Michel Hautbois <jmhautbois@baylibre.com>

-- 
Jean-Michel Hautbois <jmhautbois@baylibre.com>
