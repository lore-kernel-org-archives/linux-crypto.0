Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636784;
	b=0K4YwYpqU+VnzryTary1E2xkzR//rW0RYaz3q4KNpcRSQUswbbN7R2K7bLYrlViDrCyY
	 kmp0xTWCdXlxW7qnvj27vIR0huID0+ph5tHcPAMG2hpNGdHUZqT+S3SNM6e/DEx5q8fw3
	 2w1blf+0HvPS9f4CGz/moKp1zS6suy9HbWdUKM78iS3SiCsLbBuTRcwG1K4xPMQ6gqHVB
	 fgpDebjf8B52dGPCUSx2MCxm0zmfNUqdWdCKdbck1mJhbPfQejwKExACVeP/gMGjsm0Xw
	 JI5eSOZ5kBq6EXKXu4NxQTUR/rXdizXFZgqNICIH39jvU7Z9A7MP8XsXmojLd06TYYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636784;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:Content-Type:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vCVc5uN5koRfW3We1Irng1UChFIRF8uThNg4EI6oku4=;
	b=KXZ2lLQnm0tjssamE6Ie4vanJ9kOSsiBLWVW008fH+NMCHT9hgAj9n7aU4Z+zZEavnnL
	 UCalubZML2onJOPJXM5jI20k8yhuBMvOc5T56nJKoy/R36FU2CG/HY13DToHrVKl9AXsj
	 fIZ5pxyjLIUpHVsqr6HeJiM6sv9QvKwlu5y7EeSZI9xAsqIEb9yFmrg0atA1VKCdq8VgG
	 j7h0Zbmb0YKEKdEAGmYZjlsHQ+iOj3O+osjvW3tLoNbSspnlwtRQ8goS0hec+MxL4Mb0e
	 pXgPloaqHwTNdRalrCwfxLlLSxY+Ht+/ywqZNf7lkPiwpisEgMNO0uOpsH7rxYUbWCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HXSAcZrb;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ABA606AE9F
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 16:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2ABA606AE9F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HXSAcZrb
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso1271601f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 08:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793636782; x=1794241582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vCVc5uN5koRfW3We1Irng1UChFIRF8uThNg4EI6oku4=;
        b=HXSAcZrbuWCltYlm0yjjMBnqBdMpv6CLEsK5CowC0S+immagkbH8M1jNoPmEAmCoZD
         1fxB2VozW5s90sGhEIHWY0qgcQrFgDelbW8lzGpITgNW0vJpu46FSPwTTBARFgzd8k5X
         vIZqj1AmdZotj8lyK0HFl+Sn5IWPSXFcwpEAHmrQxmbxMNhYU09SIeIh8ySMpDuR/MQi
         /rEp4O2+kDPDeTNxZl9IU2RcbI7pFqIwFiPI3w8tlgHWEXNyqNQc/wzL9gl+U6rDtE8p
         prN5gTh/38sDqM8AkupsZzVC1DrWk1sWxvLi4jKB/yhedd60N+i89Ritog5oj2q1pLam
         BI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793636782; x=1794241582;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vCVc5uN5koRfW3We1Irng1UChFIRF8uThNg4EI6oku4=;
        b=ESxhLPFkY0EzpuJ0XR9Q1UBPvedDFRdi/T+KWwV9LqfcaFNG3c2Oa2BHZllLgo/BN6
         WBlpY4lKHlgCtP81kiAi6cfxaK4diTYTUNUmom3gbakBQeD383Y6+tX2NCAy6JBATmWE
         PVMWUrPrl2u3X80BAULIr+EraLMAKig4d5EtRCcmk3Nr5WmAH0V51ikWgjM4m6aePB2t
         ZCi3ig+OVKAq3fCkeaKB3vRQhzU6ebldP76AkwvzpGWrWvDjQpQVY5/3tJ6p0vW4Ifo/
         Q84M45JhMzevwpFV1IS8eKXJyU+c7jll80eSb998aTTFclLAsQbpM1Uwn1wO9UVMA3wC
         FMOg==
X-Forwarded-Encrypted: i=1; AKwUvByzk7vYYLqIHRb6QA0hGBkdU6ZOBdjCXDeILNLvFbdO9JwLpb9IJkYrKG79lj4RIS2yhMOeZ5O+VXHn9gQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/fb1wcGb8DKWpofYME6hq1B4hEMrnQAicLOx3bSCmwOCzDbTRE
	Ffd41ICxenwXvH0BlXfC9qh8iFhvf5TnuyL7/RHUGF+YdrC9tH2p2Ug=
X-Gm-Gg: AYBFou017hlh83mz7p2vLrhdNymGd7V5iZxLyZ8HSIDGCF1VJ+ocrQuXYd+T6lC72+i
	QJAmTVPWHt1nE8LAEHJ+d1ddY24VDMpJ/ytIhLGntA2GLOTnx4Y7QQ+5YU0M9uX5qhBJ+u5+XZ4
	oR6/hDSn2DxN+bUE/eC3dKbpegv0jlVanPUzqJQble2zOCaAH8xYdGIhU7wDvm3N/zQTQqqBWsK
	cFecnzCtrPgpS98FMQbi1OT7hS4X/eutPwf0AfrCGleHKVxirZPEK0e5DeaViK+1WNp3S6vB64o
	1s4GBK23vXv87klY1CEgclxOBxiTJ0TrHbAogpElRnAz604NqQfE6OifAxaNNfNWZR1iZ7qCtLT
	Mcmg5IfZNXeTwHNF6OsLVCNQJYwqRWGEN9qQAPam8AKzKcZpQR1D93nH+mc+aFFY43nzFBuYYXy
	vRJPQsaCqmiuNmbfdlCkYzf8yEjXd9oM04tBbdk0wHx3IlovixqOaGNFyL2j39fE5HQKP0PrjMn
	CtgGTB/NsYDbW5g8zxPzwG6LxpSLFJKmSr+0C6KR0FuYvNzG7RyI4OK4BDgtA4ozZgQeINiq2jj
	5oSNngoXmys=
X-Received: by 2002:a05:6000:2011:b0:48d:f14a:917e with SMTP id ffacd0b85a97d-48e6e2f24f9mr25344268f8f.11.1793636781827;
        Mon, 02 Nov 2026 08:26:21 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80306sm22341432f8f.33.2026.11.02.08.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 08:26:20 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org,
	steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com
Subject: Re: [PATCH] padata: fix lockdep warning in padata_find_next()
Date: Mon,  2 Nov 2026 16:26:19 +0000
Message-ID: <20261102162620.1428887-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102155353.1268322-1-tristan@talencesecurity.com>
References: <20261102155353.1268322-1-tristan@talencesecurity.com>
Content-Type: text/plain; charset=UTF-8
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 02 Nov 2026, sashiko-bot@kernel.org wrote:
> [Medium] padata: redundant spin_lock_nested() in padata_find_next() splits lock class

You are right. Commit af3852cda347 ("padata: remove __padata_list_init()")
already resolved this by giving squeue->serial.lock and reorder->lock
separate lock_class_key via separate spin_lock_init() call sites.

The spin_lock_nested() annotation is redundant and would incorrectly split
the subclass.

Please drop this patch.

Thanks,
Tristan
