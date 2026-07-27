Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839533D4108;
	Mon, 27 Jul 2026 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785190794; cv=none; b=anlf+6n+J2XCJbAYhu4LCvMugpX6DWGGeCQsIA3CJptA/14pV2XPq93C17jUkWVZ3oNQce86yHbWckSX7rIGlJF3QSGeMYiDBMUppIiCXhqtO1TZFguTfwpp4xvNAtkkIZ59rGz/Q6eMga71NqiTA/I06pmpMYDxvBHPZwHPdmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785190794; c=relaxed/simple;
	bh=DWwGog2qIR0UruDcJRBjgpaK20g6Bexmn5XlfYvDN9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dARBPblq9zgN7w68Y4fYaiyz9PSY4pDypaeBREwpxBpk8V2WtfJImqhiafKFQbyXIt4joKxvEyfDpKQpx2dwE5Xouk4f3WRUzBb5+BH/4wB42VulqYL2W6oJUKOAe3uwveFSnj7OeHW2FxLjbEjtQw3McJxWTn7UBZPc80CCc7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VG3eOyCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VG3eOyCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD931F000E9;
	Mon, 27 Jul 2026 22:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785190793;
	bh=UrmScClQTWjTysmIgm++bCyKqy3YK6bYZXGGtWwcm2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG3eOyCobHEH6gX2UV548Zv7fsHITfr+46LDNSGHPrnclOO+u+dlL1LtxLfpEHueG
	 HLz8f/Fde6qmIoWsIH1BWk38rYegBqJKp3EvvKyQMglHk7t7qCFrnvHSmecNeASv2M
	 C9QupTpF6kiYRo5cw1P2wm/OqgjVOv2bU4KspkSfRgCaLf+AAK6+7ak81QFkYOR2d4
	 TjiMZhk2xznoKNelIEHmByRdHD2OQ2ELUh/JsrrDMSbxL/ZXSlh87jvgxb2grDhP6P
	 ltrrSFgZrwHe7fonTAH4O2h+LIeC+DpJRQ99QyzUqu93LI0K1l/M9lLZQJzyC69ggL
	 tRzKivbitrDJw==
From: Sasha Levin <sashal@kernel.org>
To: Doruk Tan Ozturk <doruk@0sec.ai>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>,
	Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 5.10/5.15.y] crypto: rsa-pkcs1pad: Don't WARN on an empty digest
Date: Mon, 27 Jul 2026 18:19:39 -0400
Message-ID: <20260727202413.stable-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <amc0kJZ37reVQdKD@wunner.de>
References: <amc0kJZ37reVQdKD@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 27, 2026 at 12:36:00PM +0200, Lukas Wunner wrote:
>Reviewed-by: Lukas Wunner <lukas@wunner.de>

Queued for 5.10 and 5.15, thanks.

-- 
Thanks,
Sasha
