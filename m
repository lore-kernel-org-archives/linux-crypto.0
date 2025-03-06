Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B04F2E3386;
	Thu,  6 Mar 2025 08:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741249028; cv=none; b=WDdLyW78+1/rVLPxB2iM2F1A4J/Yg8XNpCEdd8wC5kjd4bqi87nGaoNRjBSFYmCH4/bv/CJWdhmjSKlqAW3JQf0z0CTh9n8oRG8jAW2FSQGo0WiILzb8uaaumggfre8jNBqy+zqmYUSsXxAgHWAuCeE5uQb2YbyuGFwxjoGfNuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741249028; c=relaxed/simple;
	bh=72+o6HKWXWJfLq+ehiK1lP6SVVuJzuY6rOOLJIw66f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PxPAeO5W4xCPHBL3RAQtr16NgRJZDHG5kjXmOXLHWQsYrFUhtoPAXISbHgAZDdqmfekf/BIm2mUDXoqam/PJXSTUsl6ucGReGE8j2JE48vR7Rlb7O1PQu6VhgO9jnYRrNd1xE+0U+9Ioj5Xq4MsAbkXbdS61hcD0gMeLc4npWM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7vrCdaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7vrCdaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7A4C4CEE8;
	Thu,  6 Mar 2025 08:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741249027;
	bh=72+o6HKWXWJfLq+ehiK1lP6SVVuJzuY6rOOLJIw66f0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=b7vrCdaA8JmFOxHtqMSGdlERAjQOHi7JkqVJJkAZri08YIyYawnOfHZ8jgMyKR4Tp
	 /73T8XThY6SAxoOY1wmWMwF1kXvFiWYmfQbSeBE6+V/4JD3cfmSDp1xwUjuNDLzSie
	 /P+9IJOaT1jwp9M15GBAw/b5wDEc3rBj088MuU2I9CRihyEaIj5BsCirtzLT+FHIuL
	 aqLg2YN87diKfL4Ycgi7IKm6LCBndPW278q4+ZTCVj3NpPVLdPyBYN3N6Q6BIkv6eE
	 zb/Zv6XUUL091BgXZAiAqw1Y0AvYYBshHF/5tkJ26gOYGOHDqY5P8S2XKXfnIV4Vmb
	 v8CqYmj0NnK3A==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54943bb8006so421210e87.0;
        Thu, 06 Mar 2025 00:17:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXk3Xaa8BauoFmnZ0PaKogEqM0Q6lIzFcqM2m9Jtvm/Ybne1ea42cspARB17sGVdfwFzIQhYCWtWU5KBfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YziMQGdHk1OhGlIXDJ2228SOdClMcHnqnahq/MMGmINtQKlIdqJ
	RPlWS1JKapKRo9F0DqdkkDiJA1IQHHFtV2U11+ftbi/42jh8hPxK6xZHsxLeDbKKDT1xRu44j5W
	AuPrarqociH924665kggo8iPaViM=
X-Google-Smtp-Source: AGHT+IHdx+zZZT+eoJ3MDLBU69fWhIa3VRQi81qKzbTJjVk/HWUD2tx9Ysm2CivVBTU1PojeMO22C3rVrLtcMezDMPM=
X-Received: by 2002:a05:6512:1386:b0:545:81b:1510 with SMTP id
 2adb3069b0e04-5497d32f4ffmr1887608e87.2.1741249025975; Thu, 06 Mar 2025
 00:17:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304230712.167600-1-ebiggers@kernel.org>
In-Reply-To: <20250304230712.167600-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Mar 2025 09:16:54 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEL6cMOfd+aV=VxvLEfNaeF+7Fx=d13tMzzFR+s4NYKAQ@mail.gmail.com>
X-Gm-Features: AQ5f1Jp-5GJZKhpJUa1UTZBsvhdlD3ddRLWTafjQUHv5sXWY_fRpOGAxOojkS00
Message-ID: <CAMj1kXEL6cMOfd+aV=VxvLEfNaeF+7Fx=d13tMzzFR+s4NYKAQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Remove unnecessary prompts for CRC library (batch 1)
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Mar 2025 at 00:08, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Library functions are already selected when they are needed, so there is
> no need to ask users whether to enable them or not.  This patchset fixes
> this for the first batch of CRC library options.
>
> There will be a batch 2 later to handle the rest.
>
> Eric Biggers (5):
>   lib/crc: remove unnecessary prompt for CONFIG_CRC4
>   lib/crc: remove unnecessary prompt for CONFIG_CRC7
>   lib/crc: remove unnecessary prompt for CONFIG_CRC8
>   lib/crc: remove unnecessary prompt for CONFIG_LIBCRC32C
>   lib/crc: remove unnecessary prompt for CONFIG_CRC64
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
