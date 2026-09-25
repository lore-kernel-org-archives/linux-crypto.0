Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC5F1FC0EA
	for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790295377; cv=pass; b=XYhyxWnIe9I5lq/Cp5i6Nl/N2hyg37sh53sgE2KiQ5J3X84Mrvpc6Vojx0F7VaTzhxGTPr9UDXM5NqQTO9aozEINMMvNr6k+QkGuCe/vBS8hTPY1rQOzHm9kMz7x4yBYwlryfo86XHphqhLUoiNeiB18Y0+J8/y0utxHzT76ANk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790295377; c=relaxed/simple;
	bh=J6NsS0YBb21hzvOhePaLlNVQz4MY3ClTamAaPzj0JeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDGUSQ2we+w9E8YG7sjcvIfljNRGAyF3/kfsHBMFUjzqozzREohOCWhET22vq5pwuchv4n6rogBbrazcR71dVXaJzKQCOpIFFUP5p3JZ90IrqrsTArpitfrT1px3a79zMJhkPotdq6i5Y5erLn64KsYunOwtKK0iPizvxMIQiM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bshadow.us; spf=pass smtp.mailfrom=bshadow.us; dkim=pass (2048-bit key) header.d=bshadow-us.20251104.gappssmtp.com header.i=@bshadow-us.20251104.gappssmtp.com header.b=QdepNmep; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bshadow.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bshadow.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bshadow-us.20251104.gappssmtp.com header.i=@bshadow-us.20251104.gappssmtp.com header.b="QdepNmep"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d4ddd179eso4065177b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 17:16:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790295374; cv=none;
        d=google.com; s=arc-20260327;
        b=mBK0cwRzh7iZWFLI1eBCM4Fg1xEvsXWuJ5xfrq77vAEJlYobF0k8Fpm05JB0e4ytWU
         mF3DkpTvgSUdltsn+H4YW5hTkAgzVjjdWYK5JgajTtg6liy1slk+65O11/jlH1fjoV30
         NCWUuM+OXg/Bt1CPUGRK9Ms05q0S8+1/T/bvaTFkn0ZhSuC4QaMCHFUqc+NC67gm+aKH
         sbVryZP8Byf5lOGriU7rRsNXl6otqbjEPZeozEo3RWO75rraE+HO6AxHWHMguS26SULQ
         mjl1Xxt+KLFxUn873d7jM0/tsC8u900SH8JDVTC+XIHx89drvUkiGZavIvcA9e8uY0S9
         sbGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J6NsS0YBb21hzvOhePaLlNVQz4MY3ClTamAaPzj0JeU=;
        fh=16Lq/Fkb+X1LtWCFcPrRHAz0kS7b3nJudiD4N5+H+Jg=;
        b=eigvpa669YjnRRCN4tIrr76ai8TKhvTmCaVHXIZE1XDwePG9SsFR8gfRvFr8VK82Vm
         qZpqOxxKA95Z70Tz2IERjlQ5W+4rUUNwIqfBqwglQh9+fL4ArmO22ATh/so5UzV+1bmj
         uy4t3Bu7dbT+9zg1EfKj9M7saX5DSLYi2MP93k2Tct0fNRTQVD+Kce8mQtub4VqE6hLL
         xJCbMKGFLvSbmfcFRNTPNMLzekcI/SCXenArH/glkI4wb9hHmrTAx//gngvMPpfxd7is
         T1hxqUR8KlCq4HXvM5oDP7b0jyTkaDMD7ujrmKP7Th7xOZ8XQWk4nIIWFXH7mHJGeSU1
         rR6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bshadow-us.20251104.gappssmtp.com; s=20251104; t=1790295374; x=1790900174; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J6NsS0YBb21hzvOhePaLlNVQz4MY3ClTamAaPzj0JeU=;
        b=QdepNmepi39O8OE6WlLItAiDrPGD1RzRvO/KZGWcEXwPv7s1Hn0HCOv7q5ff7VynVz
         RZjmQiskYYtlcyndqnrmRxxXQSvOcJW4doM5XSwGTa2Tgpl6JBbZD0osf14ABOniv6cg
         077+pS4+KSWEHzxXKxl4C8z4ITkte3hV6nG6CoV7CyAOgus68GKCx0ZLPbr9oonM9t7H
         /ulQPGqfaxRolSqqAulrUy9sW7HJLC+oQg2sBhxHBPSD3VA2rTkM2W/RX6k5Jvm+6IMk
         K6mnRQQn6tOnilCg1Yanf/IvxOiaV9uMaT1XtgLvVXM2Pg4D2FokJfnux89PMWJ3nefQ
         ZVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790295374; x=1790900174;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=J6NsS0YBb21hzvOhePaLlNVQz4MY3ClTamAaPzj0JeU=;
        b=szIP76PGUpSoC8+a6FNMmZb0Z3Au/2+GLgT22kP0V3+vUA8GwoLTKbCi6Kk/154TAu
         qOBlGT02PWgAnpLwXZFpUBk1uAqp7gBCmaisSCf1NL4inpqYFSatyPM7lw28+iK7F4N1
         8cqDN0mJ0D4/ReFS4zOTGPKCN1eMnMdKhjSk+ywu6GpgTkEG5T3w8pRAdBzDLTlQOA2K
         ZjGwAT9+O6FycVYasl0Q4QFeSQszl3AVh2b7OCwLrQTTeJLyKWqj8ja8VaL6WNJRE+Go
         9O6SbHzO6uZO5grqdaQ2l2qPNN88GA9tKjXCFALYAVnYNNhlqkge3Usw1DkcFI5fsF6Z
         a3/w==
X-Gm-Message-State: AFuF++kuzIQpdHzrk6qL1mFRlwG4dDIgiCSXHoDMM0SSQI5XoOSobwmO
	bqc+kqfnTrcdCIQMaB+bo4jEaP1uV7AMSud6fS2elUTOacrAZH+QqjWl9dExipFn8gZmU0XG8EB
	KXAr7EQG4tgunXShvZD41S8KxVwT9Y29E9kCSBWg0Iw==
X-Gm-Gg: AYBFou30jQF3OmPTVHXhsMg7L+Goxobjme1HEDVIFv+nE4FycsnxahGPxqOB27flA3c
	D/cKEMGjUaVVLQdh1pWyhfkNCuIn3JYi5b4IZGaqRFWdSehAJgPAwOiAw7iSd5RgBsWewQXnGI6
	3ksjyI7gCp+YzfaHvlY7kZLkzaj8WhdeNU4o7mgZC5A5dwMbsrlJhDTQqJzX3skzpCAQ3ITufqv
	R5CjgxT67NAguRg8iK1Ns+ie7zBn3dwT6Pchk9T6NSQHeiEy41T1BOXgm3Pk8NJCAf9+DtB4dQC
	TKzB5LUdTGxGlLhEsGKMOrD2iA9j328foIjcb0e3shb5+08OQ4NJztWQR1nfXH/y14akdYay+DD
	Q8+/qoHkjh8fU0Q==
X-Received: by 2002:a05:690c:e28b:10b0:89a:63da:cbec with SMTP id
 00721157ae682-8a64ad4af48mr20301267b3.50.1790295374720; Thu, 24 Sep 2026
 17:16:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924235937.148475-1-rosenp@gmail.com>
In-Reply-To: <20260924235937.148475-1-rosenp@gmail.com>
From: Robert Lovrinovic <r@bshadow.us>
Date: Fri, 25 Sep 2026 02:15:37 +0200
X-Gm-Features: AclHuK8-qQgfbz72-uMb5J0boueQc0SUvZRZGAtgZFpSELI8D9RLgL0irK2iMco
Message-ID: <CA+39HW2_=z1jggfourLfE8XmXGQx8LV233QO=m0y4Fw2774Z3A@mail.gmail.com>
Subject: Re: [PATCHv2] crypto: cesa: complete pending requests on device remove
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>, 
	Bharat Bhushan <bbhushan2@marvell.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

There still appears to be a race between stopping the engine and
setting engine->aborted. An IRQ thread already in flight may call
mv_cesa_rearm_engine() after the CMD idle check but before aborted is
set, and ctx->ops->step() may restart the hardware. We can then
synchronize the IRQ and free request/DMA objects while the engine is
running.

I think engine->aborted needs to be set before the final engine stop,
so that once we have observed the engine idle, no software path can
restart it.

engine->aborted currently only prevents mv_cesa_rearm_engine() from
dequeuing a new request; it does not prevent mv_cesa_queue_req() from
enqueueing one. A submitter racing after the removal drain can
therefore leave a request permanently queued. Please check aborted
under engine->lock in mv_cesa_queue_req() before calling
crypto_enqueue_request() mv_cesa_tdma_chain(), and return an
appropriate teardown error.

The stop timeout also looks unsafe as written. If the timeout expires,
teardown still proceeds to the callbacks and cleanup, which may free
DMA-visible objects while the engine is still active. The timeout
needs an explicit failure path or hardware reset rather than simply
continuing teardown.
