Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="iS6BBgeu"
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17446116
	for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 04:37:52 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-332c0c32d19so1238933f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 04:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1700483870; x=1701088670; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4atkjwStmvZxjHp5SDNM/cbMwICPzQFU+wT6vfftIs8=;
        b=iS6BBgeuvmFxNkRyg4rXcUNa68Ot7hmPsV9TlKY+FqMGXaAXpOkipxofzLDZ4j7O3j
         LBUmBYn2dh0hEZxm0olE9g3uO36eRmEx1qmdhTe/l5irK3wzW0E2xD9sATSp4s4/LBr2
         UTN5W4Ek4CoSTrJfPrH/9A0FcsiDXQnPIZ8C4JbqEE0flyYTBCDOOz5I2ve/kTRFHjuq
         Zmag0kF8gakHXOkHpwqSr8/eO8VKRdCwp44+bBBgy8BZjDRhClZDGypHsc3lwLsVv01K
         FxSC1CfPqCPf3KGs9Zo5MI7Mzcdk9+k3O/jo8cPV/8kGXewUiOLobVZY/7oeAFgJ6o9J
         aJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483870; x=1701088670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4atkjwStmvZxjHp5SDNM/cbMwICPzQFU+wT6vfftIs8=;
        b=EMYWLmnCRCBWrR+ngI9tYsrW/7G9F0XA/U/QKIhqF9AZ3pNZubc8xCD9s0JlLLXgBH
         L/6TFlun7xov106dwMINnJi/xS0Hl6v2maayKKBYfzrWoWCW1ZlOUEeB1m7AFz/HfVc5
         s+XqtUEmCCzulihNRnv1LmjnvgD1O8odtcC0ykHMaNSActfnE37hVZd0JfJdlUs1JCok
         Rj03S/+A5gxE0noptwDqEzwtlsyLzAjGvyXfXPD5rJJSqZlMvibcYScD9YJe+uDDGWyd
         hzWyUEmVX6BGrB4hT03CgJwI3t4uKXcLTyHsfs4DaZWy3mYMJXjdGyVmwoyXM5W9mS8r
         e8NQ==
X-Gm-Message-State: AOJu0YyX3NdMBAcPyLV1VdkY0cNG6LmrtUJMkAVG1ueW0521iGTo6rUr
	QaHMlYvFG8Fbd9jskQJx71So6w==
X-Google-Smtp-Source: AGHT+IEs5lAuavrkwKGpRZ5AkeCSKymW/RWPSADLBndhDv2LJ9rELvqHNmj4T3wJSogI6J0K/0ehDA==
X-Received: by 2002:a5d:47ab:0:b0:332:c514:641f with SMTP id 11-20020a5d47ab000000b00332c514641fmr2915054wrb.13.1700483870457;
        Mon, 20 Nov 2023 04:37:50 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id q15-20020adff94f000000b0033169676e83sm11203792wrr.13.2023.11.20.04.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:37:49 -0800 (PST)
Date: Mon, 20 Nov 2023 13:37:48 +0100
From: Corentin LABBE <clabbe@baylibre.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
	krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
	p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org,
	ricardo@pardini.net, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 2/6] MAINTAINERS: add new dt-binding doc to the right
 entry
Message-ID: <ZVtTHEr-zVZFuvHT@Red>
References: <20231107155532.3747113-1-clabbe@baylibre.com>
 <20231107155532.3747113-3-clabbe@baylibre.com>
 <6ba4585a-b7a1-46f9-ba89-a1e605cbdda3@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ba4585a-b7a1-46f9-ba89-a1e605cbdda3@linaro.org>

Le Tue, Nov 07, 2023 at 05:20:46PM +0100, Krzysztof Kozlowski a écrit :
> On 07/11/2023 16:55, Corentin Labbe wrote:
> > Rockchip crypto driver have a new file to be added.
> > 
> 
> It does not have sense patch to be separate commit. It's not like you
> add new entry. New file is introduced in a patch? Then this patch
> touches maintainers.
> 
> Best regards,
> Krzysztof
> 

I will do it
Regards
