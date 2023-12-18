Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BD5740AB
	for <linux-crypto@vger.kernel.org>; Mon, 18 Dec 2023 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Gb9uImLn"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5e75005bd0cso7821017b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Dec 2023 15:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702943056; x=1703547856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7VDVlzaCtIvv9IgKTwUyhOaFAx2Ep1sXTET+2Pb//w=;
        b=Gb9uImLnr3jbTfNiKiVQ2ErR6qUW3tgG74GzbXDzMnhwGz3hDhutsBjke+F0xXTyu1
         xLsIeLLM0LIIfw/F6sLkt5DsgA1VGBq/KBVhieyqJJg8pzyXyUSbF1hoyDSKBASADW5I
         xmN7ZnjyI5AveeG2pXHMoj1w5o5GTy1kgohvBt89gNCOqztsqWfajg0kr712RoawDfeA
         V4IXL1jms2/vCrfWx8n63+LWS3aqy4QbOmvAxpWJiXzIPG9C1xzfFFPf1c4NP2WPn/Pp
         nbBOkHQaoEaZaH4pW4j7cFx6brg6XpUGYsKU9zKufpp/xnH7NbdGlloToCPIh4iyk6tv
         7nGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702943056; x=1703547856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7VDVlzaCtIvv9IgKTwUyhOaFAx2Ep1sXTET+2Pb//w=;
        b=qq3XrWwiU78mmxWeYPLmFKYMpqi3nw6MJ/I8kHacvNhlrz4/WLJrEbrZ0BhZIw6Tnx
         oLL15tYh7nDpc8kaPRjmVQLANFk5AEB4xReacjrX/eir8Ug2KsyKj06WJrWnG15t9nyP
         oy9jVfIQ5t7GIgv9JdLaIUreHAOvG0lBfypRab9lrWIqJKd/VlKGFzsAK6c78WGu41Hg
         52awrWaXk9iyltrR2Hh66ut+GIVV0A9zUuDc2TNbAfv2ZjB/GpkN/5Jceu8/qOtsJCii
         P/TzytQpXlw9SqQsDW8Dw6wp5pNra5NEXOX2dgu9f4Ub6gMvy4EmlfRqNb6knvc6w6Rn
         kMHQ==
X-Gm-Message-State: AOJu0YzzFCr7xj6Gj7ntop/7Z04jIX/xpObzOf6nrdkfDLOCxj2GLYHA
	6ykCqLM14xsqmo+W8DfenOJS0k6Si21FHuOZkcdomg==
X-Google-Smtp-Source: AGHT+IFqzjkHF9wgqmxHy8DQwxyutO8m5gh5rPIBl+hj9RrqElTuK1IgZmdRiOhINEBB7SAzHZD5sB2OFYSltMLOTGg=
X-Received: by 2002:a81:6d8c:0:b0:5e5:7647:3b32 with SMTP id
 i134-20020a816d8c000000b005e576473b32mr3142800ywc.60.1702943056756; Mon, 18
 Dec 2023 15:44:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218164649.2492465-1-ovidiu.panait@windriver.com> <20231218164649.2492465-5-ovidiu.panait@windriver.com>
In-Reply-To: <20231218164649.2492465-5-ovidiu.panait@windriver.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 19 Dec 2023 00:44:06 +0100
Message-ID: <CACRpkdaNTdKu9QgvDqFH8sAzJRMaDARwXNa+a5ddHotUw3k_3g@mail.gmail.com>
Subject: Re: [PATCH 5/7] crypto: sl3516 - Use helper to set reqsize
To: ovidiu.panait@windriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	Hans Ulli Kroll <ulli.kroll@googlemail.com>, Corentin Labbe <clabbe@baylibre.com>, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 5:46=E2=80=AFPM <ovidiu.panait@windriver.com> wrote=
:

> From: Ovidiu Panait <ovidiu.panait@windriver.com>
>
> The value of reqsize must only be changed through the helper.
>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>

Looks right to me:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
