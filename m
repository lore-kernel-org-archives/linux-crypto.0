Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9322F22F14;
	Sat, 22 Jun 2024 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719079157; cv=none; b=TMMhLmF0NPYCcFZ0lRltVAhjozcVgJ+0UdzIdHdoso5JzR3quelRsg04tMrV4jfeZc7f85QPdvpDhbIWpO02+9Kh+FEn8hKUukII+4Gue4CogURN8Zq8/wWynWYVwg/GnTDHVPd3nr+gXLZ77ppURy1q9qydGrLEBQZtNK+RR8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719079157; c=relaxed/simple;
	bh=0OWr4R6jqv2yBEo8Ss6dcuf/q65Hu16aWbJt9lIsz2Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Es1hQszJ20Xs391j8PXxN6iox3Ivz8DFqEr3VPQ2Kbn7wAFqU0/qwo6mUbwBqo/OL32mAnYcxhYQheB9kXaD7/Kxw13KJjlz9VXvF6fmy7ga+4j1wLvOaNiJyJmwsUrBWsKtVFXw5GYkIciljEWLACgZKzE87azIpZ5wUnaPo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SH4magFr; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SH4magFr"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ec58040f39so3526161fa.2;
        Sat, 22 Jun 2024 10:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719079153; x=1719683953; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0OWr4R6jqv2yBEo8Ss6dcuf/q65Hu16aWbJt9lIsz2Y=;
        b=SH4magFr18uE2js+UU9fZcFUJjDK077G6ccK3uSaWqjMUMx0MT8ocW02+ft7/wxSDh
         GhxpeaR+D8qdZyyz5RhsVKSgV8WF71hWNEmRjaaW8IcDDmw4rdhcGyL9Gu1HAfAm3tk4
         HqJeurV1xV1NkGVh6Dmdo8bS3Qr3PA4WTH0/sB+JEhD0ZzfAjxKpjJ5pBxzw4sED6A+L
         8CAqSaIjexr8QL193//j+HU7oaBtbebd4fg/6ZhArqLCjmUOVcBSfTTKJrK80wY42569
         1KY+Ovt8ACXAVGYAb/TPPlZrhfyhSPnKdkGsr2/+usBA3MGuiKxoGenS8KQXByFABcXg
         Lq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719079153; x=1719683953;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0OWr4R6jqv2yBEo8Ss6dcuf/q65Hu16aWbJt9lIsz2Y=;
        b=troHW8BkrBT2+1yh6yaWix8ZTOLTjI2sS2nHp5aQd0wAi3oXvSQXXa3bnZCAtKU9BT
         7jzV8kJK1pLIhQUCw+3Wj6HmbcIBELsh6pqZUp2M7tS5PAY0zFbkG3zQBSn5kOtMY87r
         Bf+sTmZoI2uvED6TtcSzC9vllCAZBRbwpKIQhb9hQh5FUuQCev1cedUw8b1Ve7Rkf1gN
         Mefsh/Gh7hdSWaG0HV2GkQrDbnqaQlyU4/Gkrw48+PN5xZl4KPnnTFYhZirgjQ+ReT9m
         sEbblga4wigZLAv6/En89cj7hXqXZXiP+bHJqsLDj6xlSyiIge7Ne2iniZQijNE9a7BY
         jTnw==
X-Forwarded-Encrypted: i=1; AJvYcCV6EVUxGFKH1e07J4UTc9MCRJOElpqzo0Ug/KRctmeZ0BmnTtxq7KabqIuOdX1YVjoBlv+JIJZ9C1hfIXyMzB/N1/QE3boWDugMCbeKMpifY95dNfK2Grpcb8BZDC99NktA7Stng0miIQ==
X-Gm-Message-State: AOJu0Yy1q4DQYWID3nauu3J7C+57Anv9usQTjXLdMVmG1dGTr7o4Bp9F
	fVbQJXOSBD7ziJupHVi2HhruSCqrnpGiqdYcbrsZLlQscxo/ggIcWOSn2Fwvbii/CjHoURXz4GO
	C27F81rLepmRO3it+skln4fbW0zE=
X-Google-Smtp-Source: AGHT+IGieTyaH9Y4odq9IPnMfZ+5C0Od0FwR2MBPc/LXfbNiR/36PtAFy5yt77p/oEReYWsXLeb67mC2IF+cLw++fwE=
X-Received: by 2002:a05:651c:104f:b0:2eb:fb9c:5a85 with SMTP id
 38308e7fff4ca-2ec5940087bmr5791551fa.23.1719079153232; Sat, 22 Jun 2024
 10:59:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Philippe Simons <simons.philippe@gmail.com>
Date: Sat, 22 Jun 2024 19:59:02 +0200
Message-ID: <CADomA4-wVWUzk2nFsgN1RtQJmEAgDk8PhyWmEmVT-V2m56e_SQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: sun8i-ce: add Allwinner H616 support
To: andre.przywara@arm.com
Cc: clabbe.montjoie@gmail.com, conor+dt@kernel.org, davem@davemloft.net, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, 
	jernej.skrabec@gmail.com, krzk+dt@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, robh@kernel.org, samuel@sholland.org, 
	wens@csie.org
Content-Type: text/plain; charset="UTF-8"

Tested on RG35XX-H (H700), working fine

Tested-by: Philippe Simons <simons.philippe@gmail.com>
