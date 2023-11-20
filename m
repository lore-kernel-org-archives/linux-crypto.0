Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="zqB5qw7W"
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC62D2
	for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 04:38:27 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-32d9effe314so3093716f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 04:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1700483906; x=1701088706; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9MtZgtFfOW9dCjelkNp5f9hbzEUUDFSn3SDGb/3syhU=;
        b=zqB5qw7Wd/CVbLiMqGH84PN7QQRxwoLnWkPN5dUBF1tqoQegp51/R/TchD+pIubv9f
         cbV1eCZlDDeLtVGIzLz/upQTJNgN0mH7HWMt98yHl39O78kGibVuqLzsE0JfWCAcxnCX
         5m9HzoAHVq2ph9fi4l1IUctbWO8n/ca6ZIzjkckE1Ze6blFNwk3eQ6WV2AEpC1Rj+jT5
         WtOVPDib0kOrLGdnk98c5P8gOIHdDf++iKytE7RQZqXSggNj9IXMsFxoQBUm6JaeEp0U
         YG1nr1PY+5MlWAiWlmSMCAZSMOJe1A1Q+Ba8otvO9AMkJvT3bT08KJnJX1/CvsGGNfiX
         iZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483906; x=1701088706;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MtZgtFfOW9dCjelkNp5f9hbzEUUDFSn3SDGb/3syhU=;
        b=QzgGQpQs3UL066aSR7faKZcuTaE+PXnZF7K76h+i7VbF3/WuFfN+dWUk7ODpzV/RI9
         3xgwjxbFNHL2fEp7CGIJshPdmJnwJZsj7eoaeTU2THp4Rd6Z5KIWB0iI/9IeErTtZliA
         YAx3F5kqCDsP3YdOExT7Umok4zzB3CTQWtnNTY/yR8/UZoE1EtkEvX7Wi842veiuvcAK
         JpouQWMwouUsW+J9g/LLwo3fLYkjcsUvH5CD7FkKwkpt/BESXJNAl+AWjqzyDplfNDhF
         V1NGUZQ1lUfn6LXSnOsjKW5d7bQ7fOm6iW8O0c1etsBZooDgzJbbwoSNxOXwXLbR90v1
         WIqQ==
X-Gm-Message-State: AOJu0YyaMtLJpta6JVlKrcOwE1C+1NM2eQMIS42/54aoKZkvgnMgRkzS
	7rDtePfyYwmKhr3p+sHvbzTQ1w==
X-Google-Smtp-Source: AGHT+IFBvsTa2GSHGKkTsseOa/qkg4gJuMlmlQOUdsnpNZgSMmS2I++Q4cVF9eZfL01E5phYNEjRpw==
X-Received: by 2002:a05:6000:1acc:b0:331:762e:6b0c with SMTP id i12-20020a0560001acc00b00331762e6b0cmr4534497wry.19.1700483905834;
        Mon, 20 Nov 2023 04:38:25 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id g23-20020adfa497000000b0032fb7b4f191sm11289700wrb.91.2023.11.20.04.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:38:24 -0800 (PST)
Date: Mon, 20 Nov 2023 13:38:21 +0100
From: Corentin LABBE <clabbe@baylibre.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
	p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org,
	ricardo@pardini.net, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 3/6] ARM64: dts: rk3588: add crypto node
Message-ID: <ZVtTPUoOtiiS2CuO@Red>
References: <20231107155532.3747113-1-clabbe@baylibre.com>
 <20231107155532.3747113-4-clabbe@baylibre.com>
 <10382065.T7Z3S40VBb@diego>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10382065.T7Z3S40VBb@diego>

Le Tue, Nov 07, 2023 at 04:59:42PM +0100, Heiko Stübner a écrit :
> Hi,
> 
> Am Dienstag, 7. November 2023, 16:55:29 CET schrieb Corentin Labbe:
> > The rk3588 has a crypto IP handled by the rk3588 crypto driver so adds a
> > node for it.
> 
> please follow other commits in the subject line, i.e.:
> 
> "arm64: dts: rockchip: add rk3588 crypto node"
> 
> 
> Thanks
> Heiko
> 
I will do it
Thanks.
