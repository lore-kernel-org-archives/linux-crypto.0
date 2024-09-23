Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526A41FDA
	for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2024 07:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727075366; cv=none; b=oInHE/DkRWHzsq7pbmSv2I2WmPGpLHIRa9cOy39Qd605CoqomwrJe558weqUpetki9g/WbnAyJe0BQ9ROnJxHJojHInsVQ6NQuJAa+jVLU1ssvewu6oQELGXZ6sayaMjONnBQoMIyKxG3/eso+4ZDPnMa2Mcd9jStIQybP2dCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727075366; c=relaxed/simple;
	bh=BiC8nqRZtwmjgtMhyeT5JV8bJ1xXem/IARButjRsxtE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=McYYF++B1eDnJP/v26e54G/HeGkUCIHg6MMmT/Pxxh+szqShOtlI4bpj1V7eL9emd9XAOWTzmdcI+gi99nwt7d4Dl3+4m6pLXRvVXel9WzLdzvH0hiR70E1YMLGy2hqLZ/x0Y+SCzeCbfYP35mGgpzhs5p8qp3QzneRYiIBQHMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6ZnxmmW; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6ZnxmmW"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42bb7298bdeso51429415e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2024 00:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727075363; x=1727680163; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u3jSuoHrXX8M9QUOZ05rtmA7EAzJQMRzAH5eeSDKLMg=;
        b=N6ZnxmmWV1x9AT3U6c4kXtOXNPvnCDAobJxgbv6RWtOc0DLMyHcuf1eyWEzi83AHy0
         PpBCHdwWSR4QddZwL8uyW1gqvqZeoKPwkDeqkRpfcItvPtVK65f2qyCLTM4Z8/fGvdHH
         V90BiYCzzESuxFLaopPUeH+5saw1mZlqzgjYKBe5gqmrqTHNp1haXfXkB72pz5yFOTNy
         UmrLl30qzgSiGzcPUZe8kOt8Ihibx2lNi+trzRM/0iPCxo59XKHSo/+7r5Qo348QwAoT
         KG1ftKKNO4NyNtZmJ2sopeZtPQYZwOFoMyVAY5UmM3UslFx2viSZHWcZT+WbJB7SV2P3
         qsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727075363; x=1727680163;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3jSuoHrXX8M9QUOZ05rtmA7EAzJQMRzAH5eeSDKLMg=;
        b=PVAZSktXvPwLFK/JwdPcAFmdcNl/Tu7+mo+8h7YzOBSX8M/5xI+cPdx7PHt3fzO7fT
         +6veCmRCboOGpD/SxqVnctnTlJ+IhW2vA1112gGVS5J6cY+uYQfNQAGU8cKE5rN1ALlM
         bQrbdNh31UnEtxoSza2+10izREHC5mlibh2b+XYHzm6KnfA+WsEP9HbPbcE69dic4pUc
         Sr8W4fR5EjW14cCEv/1V1N7mgQX6Iw0WagSYkRvWY2WsYViiZNZ+YWXgLpsGtRzS3gZ3
         XjfaYLMCVvmYUp6mQb3k+B7a6LpAm1igR+DIoyrEHvGHBCHIFbNtp9ZN39yEaWkrC0TL
         fgdA==
X-Forwarded-Encrypted: i=1; AJvYcCXxoRZ4S/J+bFFvMq1paq3d6pkh8ZOIBfN15lEdkFmb5qBjPb2iGTiZ1mq5YxD1eNmSzriVT3ZnEIK3JBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrrUW2wrJj6CzFVxSwG5C2aMCVMaY+avLhfJKDGhshD0QWsiSt
	t+0WIDz1DGvho/jdALzHwh09QtfWST+/sannxgLQDanoqWVEpe0yun/FN822pj4bOzjzL+yLlK1
	K6g2bNSbaLgf++B6LCka3EKzrRjPkg95skDbMmw==
X-Google-Smtp-Source: AGHT+IHiY21J/vzTmq1sSESpmjTf6voJrwz1Wl2gKXJWhKXy17GJDR/suSlLuwo6of9g+6T4meJ+edRSElkOlRQv9O8=
X-Received: by 2002:adf:fc0c:0:b0:374:ca1d:85ad with SMTP id
 ffacd0b85a97d-37a4238cd1emr8816931f8f.56.1727075363313; Mon, 23 Sep 2024
 00:09:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Harsh Jain <harshjain.prof@gmail.com>
Date: Mon, 23 Sep 2024 12:39:11 +0530
Message-ID: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
Subject: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
To: Herbert Xu <herbert@gondor.apana.org.au>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
Cc: h.jain@amd.com, harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi All,

We have observed self test failure with hmac(versal-sha3-384) in
init_tfm callback.

[   14.672021] WARNING: CPU: 1 PID: 578 at crypto/shash.c:495
crypto_shash_init_tfm+0xac/0xd0

In init_tfm ("versal-sha3-384") we increase the descsize with
crypto_shash_descsize("sha3-384-generic") . When HMAC template is
enabled, it add 8 more bytes in descsize and reports warn_on because
descsize is 376 which is greater than 368 (HASH_MAX_DESCSIZE).

HMAC            versal-sha3-384         sha3-384-generic
    8         +              8                 +            360           = 376

What should be the preferred fix for this.
1. Increase the size of HASH_MAX_DESCSIZE macro by 8.
2. Register "versal-sha3-384" as ahash algo.


Thanks & Regards
Harsh Jain
