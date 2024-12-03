Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088661E009B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 18:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733250728; cv=none; b=RnNKI8h03cNSHmYlpcNSL2BPF31XP8TXheD0zvf50RD35ZQtmHHon4cVt1kD+/xr/OjTdo88iWnXeBvWnj/61xFr2Y4pc6OOP5ObSrUKfoSMRGLydiwuZJ02rOVjuEkS6ydteuX2NgX677MC8hFDz9YQHQbu77denLIWAzOULlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733250728; c=relaxed/simple;
	bh=teJpmPTMJwM4XhRCt98E5exgGcMwwsgs/+69aF/6jTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQIdhrTNTbijP/z0Nmw7iVA9oDdeMbLFR76FOUwt5nsrf66MOBbNtXnz3ppgXHmq+QlI3Z4XHadWdWN6l667d0wDC9lqyO/YSLPwd97dOuEYIYw9DC7CBRBLuu1qfEPGK2ChBkvlvoG6pCAyc2BJHX+irhTMGq7uXNZpigSWFAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=exzalodJ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="exzalodJ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-434a2f3bae4so54656645e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 10:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733250725; x=1733855525; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MA0OIWYEx7lhE8KpQkBc+3xSlNCUl4o5/5suXDXfAEw=;
        b=exzalodJ3+4UvOvky5pv0KEAEC2BqruWTai0ibunjgHRPzg7OITLYowpyr/jAvQUdt
         9i/Qc/iB3GdPbXsXmXyepfPtoCQtsogpGiv2aIwkge3wUCTCNtL1v8ZfVg5uHntPCLl4
         n1cNtT2hT1ufMD4FvNUym+NQ8d0umRv/guiiHHdqumXxAtTJmpnLGft6+CCfoHLsLuon
         8gHabPQANiACfh3wMa7ohAikk8/7yM+J8GwXcEAK7uBR0B7PiG4gURXSyQdwVqXkueU1
         YKHMYZqOJuRdVdPz4w507PVnit0eXjBaQwiRutvfIRD36mq7sQC5BX9lQal/N5o7989V
         nINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733250725; x=1733855525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MA0OIWYEx7lhE8KpQkBc+3xSlNCUl4o5/5suXDXfAEw=;
        b=A2cfVId3Q+lrW8KELBUP5YM05VoflSlQ7N7xwrO6v5QDEAtIPDEOlE0PbYVlIY4Non
         KkC+26rUggHgiFS1NlxS5uyO4tVbYGSlpV2kGf+1thYfmZeYInHG3nNGH2rhYDD0KXne
         /L/fImJI2kT6Zqp3jxbkv6uuBkwYqDUq821J23q6Nvo4xQet9QWdek6vxd3gbcyAhD+o
         RllZRa3Arx+WasRRH7puni4CHJ5gkm12V822qFXM9655p2KPi1qmbkT0FN4GFI3hWCka
         TbT595hzL9VlOibvVBwDbTpQ0AjYk2Oainq1nlHmmYeCkyPUcKzmq2afi5gvP6/0hfUT
         2dTA==
X-Forwarded-Encrypted: i=1; AJvYcCUCWaw7h12ynfm08y84ofThHZ132m3d/Gjk2JHRBYMRhmezmatbrq3aLq1hhbJaQgb3TT6nnlYRlYAVT48=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN+CrDmExyEACeE3t63DkDENGB/EaNmJK5pu9OS2S67hgxb5n6
	iNlbIZCHCF+LOf6dD/v7gWq6AGVb/X5jJH49N+w9wsOMRklWcipT63MDx0+uG1A=
X-Gm-Gg: ASbGnctLgzIBN4bLXbQKCvzhCIsSXegN367Sxo0aFKUpcmA8SEd/w1ta4tyA/wNful1
	9IP3aWQW4zvvjr4fBYdInciikv1rVIoKZTTyfBTpduVNFzloqJoBA1p9AUgLq9lMR2koe2nDL8R
	BI2e5ksSNR49byefT1bg6WdZjntFBGSUFrY2FKNiuFOIEV7Ekm5odM8KT2+DoyBu6q837siBYNe
	IQCilRhHs6NusyhsSClg4Wwm8U9JBRgohjLuUCdIx7oVW4biTCcLIrDzrWvUA==
X-Google-Smtp-Source: AGHT+IHf+LjEeT/CgO0kZ2nnAkyl6mj5vAV7M9tzUOSZ6upVeF6Bbz1t4dAO1PkPUN1PMAflp/yrXQ==
X-Received: by 2002:a5d:6483:0:b0:385:df2c:91b5 with SMTP id ffacd0b85a97d-385fd378ddamr3163149f8f.0.1733250725408;
        Tue, 03 Dec 2024 10:32:05 -0800 (PST)
Received: from linaro.org ([2a02:2454:ff21:ef80:41ad:5703:2486:8f59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ee2c7559sm7964163f8f.12.2024.12.03.10.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 10:32:05 -0800 (PST)
Date: Tue, 3 Dec 2024 19:32:01 +0100
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 4/9] crypto: qce - shrink code with devres clk helpers
Message-ID: <Z09OX3vnMC8bB6LG@linaro.org>
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-4-c5901d2dd45c@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203-crypto-qce-refactor-v1-4-c5901d2dd45c@linaro.org>

On Tue, Dec 03, 2024 at 10:19:32AM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Use devm_clk_get_optional_enabled() to avoid having to enable the clocks
> separately as well as putting the clocks in error path and the remove()
> callback.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

FWIW: Ideally, the driver shouldn't keep on the clock all the time in
the first place, since this will prevent reaching deeper low power
states. So while this cleanup is nice, I think it will have to be
reverted again once someone fixes that.

If you're working on refactoring this rarely cared for driver, is there
any chance you could add some form of runtime PM while you're at it? :-)

Thanks,
Stephan
