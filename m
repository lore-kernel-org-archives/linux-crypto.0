Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E0A1C7B70
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 21:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723669914; cv=none; b=tkziGVy3hXLx2/01i3WBg5suFWhdfsusvGRQdqLiIR//qsAItyMO//q3aEgcp8jB1pPlgE+Tls+KzDxt+3ZbfleOSj/djf/D3Axi/OSawfeA93YMbApaAPJSsbkrq1lrfjwlXmBteEAstHKtmbd6oPmd2Umw/+x6+6p773Y56Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723669914; c=relaxed/simple;
	bh=RrNuKMnpWClcSwdeuBHgLTNkTWm1l+81N9oPrYk2bpE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Jn1B+I2SGFavjhlrpejLkX66DiJCPggvAVCpwTZYOU5T7GuD6hz8I8U1gyYcnUk1arlyWAAydWQ3ZUWggkRqqSCzrDX8MJGeoD6TgnKL/bdN3YP3W+k7h2TqXXIR7MUVkJeJmsA5jAlbgGAA7tzpfNlpwfTASAV757XrdHhQBsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ktby8IA3; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ktby8IA3"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-368313809a4so765289f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 14:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723669911; x=1724274711; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bNtnCY8eBpgWHbCqN80CA+9ry5b1MXO3tqsVqyVfaag=;
        b=ktby8IA3B6Z4A+97jEQEqvOR+Ww2A+k5EnwXCdNenKQ7FeSNItwtCOA9DPz/XB9R1N
         nO2Fhl5lYOj0s6A+k5QihjEtjFOJ90u1HpnnCpB8qZ8hTiGM2/cNMb/rL7wgBWzbPk8F
         PKVTvbOzBmQjLMCLep7ECQnKIDO56KbUdNv+FZN3LYPIuiF3SeHL49zmlASdf3LWcFcb
         bcoGkWn1JS70MK4cSmSR/m9O5CAxFRId+59E0vgrUjF8dsLOojZpYm9IF3RgUJR8VC4h
         WDvqd283rERwW/qA1RdIgK/Xq17xI98vcX6Eu4vCcdPvz3Yp8xvDXf0hF2b0pVRZLMK+
         JRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723669911; x=1724274711;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNtnCY8eBpgWHbCqN80CA+9ry5b1MXO3tqsVqyVfaag=;
        b=KFb30P280q5Ske62nhIuZRNKWladWeH7JURg5roUT6BUZm5tOFvpCKaPfRIIGFs80x
         wXW92i6A4ikyM41q24k6Z00vpzZQcFv7yQonoMtE5miX4x70SHgHo8BGMdqsFpzdSZBB
         1MdviuDnF3ivPuPj3FsrrwukTub31cWcvabC9+TaOS3i0ApANSbNtofH9rQnYlYW/lA/
         4vn7VnLWX3J8p1u3QoymLoOduRfkekyFzgtKQKHmgVJ8xRpYMADklLoFnQZZaR+85Bql
         zI8cDjl5Yc998A7Cok1U0TCmeEvniYJtjbIsbTEIaABxs19Qo/Jm+JuYlUusOeO9b0hv
         ANgg==
X-Forwarded-Encrypted: i=1; AJvYcCUW04ZFas9uMv2hDVDRjwMC8oQ88L9hf2UcTp1Iw+jykJjikqXd4300Qhxxtc491MDGaJDiYZRvBBfqjUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB7xQPM7AZJAwFUXKw8q5EpvVSfxu08HSCyb/7gYFbN6Se05vy
	gH+NJuGge+WYH0wJtsg9ihYj9c+X5UrXmfOThlot9L5NakMHZwMmMlzb1fWs1ow=
X-Google-Smtp-Source: AGHT+IExOoLUif+8UAIX2fT9byQAmZbdMZQHvKRFH/pxCPo2HgmjobMSMqCtfayNv3jQTefqPATJ/g==
X-Received: by 2002:adf:e641:0:b0:36b:bb7b:9244 with SMTP id ffacd0b85a97d-37186bbd1ecmr665844f8f.1.1723669911269;
        Wed, 14 Aug 2024 14:11:51 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded7cfc6sm31092815e9.42.2024.08.14.14.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:11:51 -0700 (PDT)
Date: Thu, 15 Aug 2024 00:11:46 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bhoomika K <bhoomikak@vayavyalabs.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: [PATCH 0/3] crypto: spacc - Fix Smatch issues
Message-ID: <b47b6e7a-dd63-4005-9339-edb705f6f983@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fix a couple off by ones, and a minor style nit.

Dan Carpenter (3):
  crypto: spacc - Fix bounds checking on spacc->job[]
  crypto: spacc - Fix off by one in spacc_isenabled()
  crypto: spacc - Add a new line in spacc_open()

 drivers/crypto/dwc-spacc/spacc_core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.43.0

