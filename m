Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C81CEAA2;
	Wed, 21 Aug 2024 08:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724228897; cv=none; b=UMhrCiQdWhIqqLXntsFWwpahV3jNqnZRsDBckYMkdw83xzUKWILzpVbN28H3DDYZhNLWjqkdXPE9e3dUpR+FLu8460pYkwHc3OFwJzhG6cFEq2NaeV72Z+ahqsU451sMqiVAKbyBn/I/CxtOuIgkgHtQLxRsrvA1dPotV/FEUC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724228897; c=relaxed/simple;
	bh=0EYynGqCYYDG0kmMe7va5GsEnxweiUba2sY/4z3aDqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiMBEzZ8Ln9XCKLrgMCMp0cwGUO7jD+PtSiCrvhfkaPiZFXVJMeqCyqY5e40axdzPq9i5VottJQelEyrYAfJpLMi0oKsEdVeuXGJj6csAu32OeflcpmEzkkrMO2vgVGrKOx/VGnroKBCSPZZiHJSnGsY2aSpfe3wPyuZ1Wk+gx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42ab99fb45dso15703715e9.1;
        Wed, 21 Aug 2024 01:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724228893; x=1724833693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xN+FFegBOGLcV5rniaSgQIhF8qgl4CYaiswZ4vLQRc=;
        b=cce7eh/DvdqbvNJtMGkmIfMmyOO259nKEYJD5gtDwcYbkbW3FE9T/qd9mwFWLxCbd/
         8zBIqlzkNrSWYWn+VrBaaZQjCh29TQYhwQUiicaxCAO63QZQIwamC1ijvlnnxq1WTZf1
         DpBWGEcB7V49qGohEPmbuyDYNa/2hu0l2HdEUJHNcQ0bQfefAb4AHbFa/YrOtu8JWbTR
         HJuw/pq6zQNidQHT6W/J4kxG1CEupjQhJ0L83uYXYCfBZRjGowhqAZjLtWhAXLHEuOjM
         Ov7lt3/seF4DWMbc8xFePdV15gXK/yA/0HuB+B6JAVNbjeYbpvF26azuJAEfhQaoza8E
         lCiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfQ7JbVPeTrXVU/U79Hg9+TaH+K3Bb2ahw9FxRNaxtNbzYSwH6s3l+lkRF+q1PflANV5bXwY160nRHFJHt@vger.kernel.org, AJvYcCX/dphfro9qFJOUQeieZD7d6FbyXgAxBL2rR498fjRWdL4QE9u5FzckSKInR4oIzoU2P0jONXuBFACSxFbU@vger.kernel.org, AJvYcCXaf0v3VViKPWQUaAoQpozcJyZ4vxSeHXdcNBDs24OYQdEMaPr0bFTjuR07Upv1eM/9TIouNs1Fo/u7@vger.kernel.org
X-Gm-Message-State: AOJu0YwCQFz0UsZqcu+s+/LqZmkMJWd7HBXm2X7UfWyPmq/hP7kznUCA
	QN04H5Rich7708THfwdFga7cQSjiOjZX6JUN7thmGkuGHgVARKTl
X-Google-Smtp-Source: AGHT+IFyFTdqX7DY6eicZcm0kgte9fLtcZE1QgZwK7wGNFJsY6+nUECjpWKpK6jCrv2y3CBhvnAMbA==
X-Received: by 2002:a05:600c:198b:b0:426:6fd2:e14b with SMTP id 5b1f17b1804b1-42abd21517amr13358835e9.11.1724228893042;
        Wed, 21 Aug 2024 01:28:13 -0700 (PDT)
Received: from krzk-bin ([178.197.215.209])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42abee86d48sm16680535e9.18.2024.08.21.01.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 01:28:12 -0700 (PDT)
Date: Wed, 21 Aug 2024 10:28:09 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, khilman@baylibre.com, jbrunet@baylibre.com, 
	martin.blumenstingl@googlemail.com, vadim.fedorenko@linux.dev, linux-crypto@vger.kernel.org, 
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com
Subject: Re: [PATCH v9 23/23] arch: arm64: dts: meson: axg: add crypto node
Message-ID: <ryvwncu3m7rsja34h37osyoqvfhzalgim6op4itqulmysosncg@5vtil3qsoo2o>
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
 <20240820145623.3500864-24-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240820145623.3500864-24-avromanov@salutedevices.com>

On Tue, Aug 20, 2024 at 05:56:23PM +0300, Alexey Romanov wrote:
> This patch adds a crypto node declaration. With the
> Amlogic crypto driver we can use HW implementation
> of SHA1/224/256 and AES algo.
> 
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 7 +++++++
>  1 file changed, 7 insertions(+)
>

Please use subject prefixes matching the subsystem. You can get them for
example with  on the directory
your patch is touching. For bindings, the preferred subjects are
explained here:
https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-patches.html#i-for-patch-submitters

Best regards,
Krzysztof

