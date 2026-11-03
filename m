Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793736401;
	b=1vePwTw9u2AN7a7PFSDt0YsIleGdcqgR9+fABFV2n1anCZ20ol4z4KeOPSh9tNsFZYUL
	 aesI2YCb6JxG7+6tU2JrXHRhx3QFfBXLsjzqEu9NVE3Nq8VdjBK+Tj1zqYzsx1Or0HUgR
	 JoiqL0DNNPlxXlNZOeSmgMeW8aE5LDzl4f7twLtieWSDZuSsHm9rJSSDRK6Llhx2hFONn
	 KDPScvhdutzgNph5FmnwGHalgkwecjWKgDoYg1CMCoq8tSWOQhdigH7jHNXPrlnRWp3DK
	 Xxif/YiFrYWOwR57AB6lhSkkOdy/0PRnFDuxAt+BQda6kDqvAbpQwXhhgnUZV+4+zGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793736401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+Wkeggk9/I8XK/OzWemypiGDuPRyFGzMcFGwhba67BE=;
	b=zjPk4OPiHV1BJ50hPzylBH2gYOwyHoS1xXl0/OxiNvAZERnAZ7diWtXVZZAcWsHJdtdC
	 JuNyAndWa5Q+IBKCUG1ToKd1lyzMYBpibXS92uZU+OOFzXinlXkImDJtknSbUXmBq5wfP
	 iKa1wInqVyxlW+/cr6N8IpYcc/XiwSsLcisK/Nky628k3b2FjWD+Wwk/73278jwVFzKIF
	 qv041WBQ5W36+PQiDVoZmhPgZiH2Bjfa+jVm3/gri7EToEuGmY0O1CwrDSVz0fQxcc0sO
	 roQ/IG8tAe7WFgLI9GBbW3keRkbK3jd4kOlEW6h4h4WBKwqrywDJT/6RUVUzf1fHHnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jW5vxALe;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE869606A339
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 20:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE869606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jW5vxALe
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3abb4c24125so23370a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 12:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793736400; x=1794341200; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Wkeggk9/I8XK/OzWemypiGDuPRyFGzMcFGwhba67BE=;
        b=jW5vxALevlVJMAlYih9ubNLJExjQ1Mpls//X//Ybk5pkxyOAZrNTUJy6eMe64j+kpx
         ipNUPBeEE137HaQchSjNEgLDr5ignUKWAKgGOtSrZKR2DkVfaWjRrBaOQNNJXj8v58kz
         T3icgK6Ws02vEgM1HKMyOT2QNxVmouSXzjrCjLoUmOwzXqgtxx30ctLu9pR6NJ6yQjDC
         VEejsYIjlul2oKd4VnaGZtcgNOihsQr5qS+LOwMOHFrNXtnImDNHDI43GyCUJL/28Cxk
         D5CPD1agtyTKdmtLSGE5K1UeNUvzpPObKbOflbg8opmawQaZ6SLDQJK0Uuqx00NFR/XO
         mVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793736400; x=1794341200;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Wkeggk9/I8XK/OzWemypiGDuPRyFGzMcFGwhba67BE=;
        b=s8+Sa4JN/4enA+I4E+HPqEJGXatCxkKsdbPdqhMLEFGER2psiYcSgqp7aw0UgvQxhN
         atdbgY+kItbHoVEVwDseLUhcfnkp1RW0w1qQILTawl/ZbsIZzGCKIjNXz5L9babvUYma
         eWY7iFBfNrXuuV6/+4BitIZWDI/zwen/saxSgYcxGaAeRTCimbPVfWouYKX71ciKTFB3
         5KXkb1QMfx8fEfifPZUeH0Bj2BJqCRtIBwOL3dA04dO93Wn1TuuMKKINjDzah4xVJeLr
         cLHZATST3BB4f39N8N7MMlLFrGqhrX9HYXqm9qGZ26DWAGQiAhM+CJUdn48Flyz+pGRj
         U+hg==
X-Forwarded-Encrypted: i=1; AKwUvBxHAyG7hEpjGWdAdsnnnRzu4fj1Vuyf8fJt1e6dr3PKcMtF7y7SYWFNuQWNuEFar5jcFZ6ech+QLdDABU8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+F8Kq3x9aSEU6kpz3QoFo5VcuVmAr640ew52ORfpLIw1Nzn9n4
	nQ4yYCxdxPaUmfmDkYQNS6g7hUMZLTFnjj3d7XtNvTM8f1LfvggAM/Azmkf3N5L1ROF24Vu+Iyg
	iOGzkQ7acnYir84Z79w==
X-Received: from pgkz19.prod.google.com ([2002:a63:a53:0:b0:cd6:5865:b9a2])
 (user=shansinha job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:514f:b0:3a4:9dd7:296f with SMTP id 98e67ed59e1d1-3ae897e224bmr10233131a91.40.1793736399648;
 Tue, 03 Nov 2026 12:06:39 -0800 (PST)
Date: Tue,  3 Nov 2026 20:06:29 +0000
In-Reply-To: <fe86fe10f9def87a2b463a6d4b44e266dd9497dc.1792599491.git.prsampat@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <cover.1792599491.git.prsampat@amd.com> <fe86fe10f9def87a2b463a6d4b44e266dd9497dc.1792599491.git.prsampat@amd.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261103200629.136230-1-shansinha@google.com>
Subject: Re: [Patch v5 7/7] crypto: ccp - Implement SNP Download Firmware EX
From: Shantanu Sinha <shansinha@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org, 
	ashish.kalra@amd.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org, 
	chao.gao@intel.com, aik@amd.com, tycho@kernel.org, nikunj@amd.com, 
	michael.roth@amd.com, shansinha@google.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 21, 2026 at 05:05:03PM +0000, Pratik R. Sampat wrote:
> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
> command.
> [...]
> v4..v5:
> * Report original firmware error on rollback failure - Tycho, Shantanu

I've tested v5 on Milan and everything seems to be working as expected.
I'm happy for this to be merged.

Tested-by: Shantanu Sinha <shansinha@google.com>

Thanks,
Shantanu
