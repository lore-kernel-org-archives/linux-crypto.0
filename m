Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185E91917F1
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 21:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763845239; cv=none; b=UEkV2qNj8rGotehV8BWDyasjHFdsDpCaQKMNZMfp8FFlTdlJSnyUBUYHK+WEbiJfS/9CHEx77JjoapkxqDYQruHHRr8eU+aL9uWkF30QRkPgqmn69CHhmTpeeQ7eo9plGtBaYxb+hb8mGgxFH2bHob+9JgizcL3297DmZPi2wLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763845239; c=relaxed/simple;
	bh=RdjaX2niye+QaA7f4+vmh/qanvjRwf5mmtfnOsMH620=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/+IU9r6XdM0oNIp+fS2OT2Wi/ZqjS1d5wggK+tN4aSBfZjLZgLnil9vG3noG21PRpwFtYSwVv3EfX5bFQILEcGb4e0UmhT5Glqu14VQ3M8UuTyNQEn9R4x8EOIM+NmtOw6GMVQrvSMnVQf2iRxpM1qjiFDViH0lvi1qZid6v50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=cDWt4JFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cDWt4JFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C22AC4CEF5
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 21:00:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cDWt4JFw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763845236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RdjaX2niye+QaA7f4+vmh/qanvjRwf5mmtfnOsMH620=;
	b=cDWt4JFw8pI2q0gcrSPIqO2teetVxKnKPe57XDm2rkGIvJ2BKsc2xggNgBS7If79ZcByYj
	UUoC2H3S5NKHZHPMgB+KH1w/Nvf5DAORrUDFTPY7hb3FHN+jlSSVIqx/+93GjHp91NFK+T
	FeuVshc+zxIiFX/ioWDH9jKykRRw7bo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 17815943 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Sat, 22 Nov 2025 21:00:36 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-656d9230cf2so1501556eaf.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 13:00:36 -0800 (PST)
X-Gm-Message-State: AOJu0YwkajgwKcC5kk+qD3QUcyxOPBBMkj9W8tT7ckffMu6b0s9ssMga
	/sgopIV7oj6eUZ31qzxvLNMuEUs6UCesfPlT38oNEcnlzsvRu4/XmEDcZaN4R26/CE48FRhImbD
	Y0TLGCYHpBcnt4moGDABhhHzcf/DVGJM=
X-Google-Smtp-Source: AGHT+IHhLYoQTOXsYDzBvDrhx/MSvI4agDaTEI5z0taFiCl8rX+zo7epzxpxtq3QIvy50SGXsWOw5WH5qgGfyHvcPLg=
X-Received: by 2002:a05:6808:178b:b0:450:c648:4aeb with SMTP id
 5614622812f47-45115b25a78mr2323855b6e.44.1763845235532; Sat, 22 Nov 2025
 13:00:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122194206.31822-1-ebiggers@kernel.org>
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 22 Nov 2025 22:00:27 +0100
X-Gmail-Original-Message-ID: <CAHmME9pvZLPKK=_Wa9+kCNejZ88grDnb5JS9=QvMrTQ0WeVsOw@mail.gmail.com>
X-Gm-Features: AWmQ_bn1ZzeLHuRMqZ6nj3AH1LlwOlRr1TPSTeXuVGzgci7cSh4vrKZVIUr8xEc
Message-ID: <CAHmME9pvZLPKK=_Wa9+kCNejZ88grDnb5JS9=QvMrTQ0WeVsOw@mail.gmail.com>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
