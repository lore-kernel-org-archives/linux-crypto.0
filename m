Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB6F1CF92
	for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 11:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947956; cv=none; b=ZgaqQHkAqmdfBCpNjDzzS7czz00tGqkctH/J/+ewozgfMOS7BguTeQOgSn8bTiPqLrmg+l93fdVD9iaR9Ju2ovMa7xdE2RWVJ4B1eWNknaWFQtqLYmUzWHnpfmCw8bWINvEOBYmlSit+Koxq+FhzzK2gwhwO6YJMPu+ZpKi8YUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947956; c=relaxed/simple;
	bh=5QHOzDnr2fZFc8mJv/ASjvc4DZGcBtF/FA4nRGxtHbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDxsquDWdYfZ+A7kyMLFtkJC6jY0oVrLltNonSMBfrmrJXOqbHY3f3x3EMbA48HFWS6osyhZWN2VrudAKASkihblVodekcaqzxE2RFR9j25sGDLI7Wyaz3c8dUeOicrEznqGSyPqkY/O/Fa3yYh9EIIg21fJvVj1+JAVW2H3u3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FKOYLbUG; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FKOYLbUG"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5658082d2c4so3673859a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 03:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708947953; x=1709552753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5QHOzDnr2fZFc8mJv/ASjvc4DZGcBtF/FA4nRGxtHbI=;
        b=FKOYLbUGDQbtXJBEJNWkNW9CH7hEMkO3rlzlqmmwRupvA1OSmmJQW2ZSXRnsgfGJW4
         PcfNfwhDOfLhYUfvoKU7heXXnV4uLJX4Rni6bOCazo0C8B6DxTqbvuTIHlh7CQcWvsW0
         PtAGR9Q+B/J8BLrp824TsctVBjs7BCTwbuewjrCWzD2DRvX0Q4fG2Obro2ViMV1O+vL1
         pvCK4gCs0AQJm9Exy5bT6ToG5xOodxBI2+GsEDvt3muGymAE5RNhmV6A0gCu+PIDWigB
         bu0RvujSON2hYeiZ/BRX+F4y788nj3HHVuq3TYQ1HntiKDEbqeFeMT6Wj3eDaOuREUI1
         gP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708947953; x=1709552753;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5QHOzDnr2fZFc8mJv/ASjvc4DZGcBtF/FA4nRGxtHbI=;
        b=RkYIh52gvHSYA+DiuYJlh5N5BKyTiz+BD5D0J52viMTf+45zTHRkQinrIV4rtMvvuH
         YbTqhII14zodcjml4CkmtLd3BRsWtx/bDnbGgIofPYUYB7rmy/qEIOqmmLaYz6+atZhB
         8MVpGa4cVmSJKRiN5IaUSa4EPp5znHMtAEDyCKyfsFjk32gRTw75Rm+aYvfUwoRL9IE1
         gSABOLv5ScWlf2RDO4qkculo0z8YlyTxPWfNmBx8cOv1XxXbby6/anrxDZPg1N0tENZt
         8ZJOABqrjJvwelugTCMgEEbw5DHjbtG/28P2JT2A07F+dLXbZS3B/UqWB9UhC+ubV0ps
         3pQw==
X-Forwarded-Encrypted: i=1; AJvYcCUnsJQ3Cbm2krX6I/flE+7/cSFOBsX7B1xmd0xYIwUkPB0oH2CtZdOFGRX3f2tIW4BlS4YfrhXoI7rCuPz9pxgYGQBYt/4qF1WrF0tF
X-Gm-Message-State: AOJu0YyEp3bK+A/a7sO7HRbN/83l7ak5g2IlEvmC7O7q+eA9fFu/g4Hv
	bd5nxLyX8HIdTt4rNRhCawLBYD4UvAz8c1rch6+FCKQxIJqvjy7za/4wcfn+Hl8=
X-Google-Smtp-Source: AGHT+IH8TtND5SHe97VFjkocDpWlBzqqd8/3crqG9Nh3OaWBEP6nmhxYTZJXMwvAZhqQ56h19IStNQ==
X-Received: by 2002:a17:906:2419:b0:a3e:f7ae:49b6 with SMTP id z25-20020a170906241900b00a3ef7ae49b6mr4000009eja.49.1708947953323;
        Mon, 26 Feb 2024 03:45:53 -0800 (PST)
Received: from [192.168.0.173] ([79.115.63.202])
        by smtp.gmail.com with ESMTPSA id vh12-20020a170907d38c00b00a3ee9305b02sm2337992ejc.20.2024.02.26.03.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 03:45:52 -0800 (PST)
Message-ID: <1d7b31a1-60c4-45b3-a7ae-a3a2c2e126a8@linaro.org>
Date: Mon, 26 Feb 2024 13:45:50 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Remove T Ambarus from few mchp entries
Content-Language: en-US
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: claudiu.beznea@tuxon.dev, nicolas.ferre@microchip.com,
 dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20240226094718.29104-1-tudor.ambarus@linaro.org>
 <20240226112132.22025454@xps-13>
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20240226112132.22025454@xps-13>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 26.02.2024 12:21, Miquel Raynal wrote:
> Could we mark these entries orphaned instead of removing them?

ok, will send v2.
