Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E924679A
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750296; cv=none; b=SeY1KMGPZ6O7nVt+0yBDLUW2thQ/g5iSeGbEWLqlvXz7kzCjyrPz9oFOUFgsGR9tiPD/aMY/OceuWYslz8IvMOSuyiFtgqjf9BBccXc2v9Bkhs3u6ZsUPau94BGjtYf5zkANC3ISDQcO8G8/B84dzf15OfovQzjGLgq0S4BZy20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750296; c=relaxed/simple;
	bh=PzqRSymdVzt1Og9H2m/pVZgy34E6YLnOoomg2VWITJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m1s5YlWYqNErlCm/+fDQrHF/PN3HmziaAoFP2km90QPf1L02s8pZjTjLUyuEoddYMql47VMrxFeqI53J53TO3vOZC0QB5h7SDsc1wllIPXMrmFq15WHK1eUEM1XOHbc3UEeclBWhd2ugVoLZsvOIv0nnslPHk/skpUvrARnBhWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gpvaMTzE; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gpvaMTzE"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-631787faf35so489671a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758750292; x=1759355092; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=38X5IFenUzwUhQGVC0bd120a5LFhgoZi9a0z5DrCvfg=;
        b=gpvaMTzECxo9tYItWL8VaHkOTQFEmuAjhUKojozeoWFDAle4CMUllQvEAoPiMS0JWP
         qc1Gqd6SgJqN239aGs5b8AJDnDrd5AS1L07XWQZk52Z3ZpoqOdg/+bhWj9yfwM+Al+ZX
         6PU6Ksh6AIL0jEMJkCGgOafJr0+fSZJ4Z+toc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758750292; x=1759355092;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38X5IFenUzwUhQGVC0bd120a5LFhgoZi9a0z5DrCvfg=;
        b=ixltJXCFsUpyUjoYAl9gNwxiV/YFr0J1sjkLIY+n3CBG9MQKvJRzSMAllpSt4cTXyc
         0Xb6mpw2pQ8kzm/R9IZwPd8+BrDhuHSCF45iiOeW93quGjNceImkSLAmwvUpAAuxGWtZ
         UCTuk9aBKW5Ewf36hoYB7Ulz8h11bt9Vvu6PWeNcu0hiVuPjgPxQVyTPxJbsUiBCREUE
         xATCSZjN+MAz+NoxjF8qVfDBtPvXplvhJDDKyameepP7ojuKUZraHuSENKYIiv1bCszs
         0QdfQyggj3ry+NTrW/dXUpSyE9ja+HvjjgFJbk6aaC7R1gGdfHuQZ+WYc3VLXiRp32yW
         ItpA==
X-Gm-Message-State: AOJu0YxcVIDV/Z2lCTX12z3SzKCoIvn0sN2Y2f57BB8CcaoHujfOo1RT
	7sMJPpGNve4moFRI1z6j1rMPekLao7vzjBGyK2u0dYDwyWNF4xlepybAW7/tlFlNSm0PhKVTrGs
	FZbHRW00=
X-Gm-Gg: ASbGnctJ5HZsyYI9snmExxY9TLeEP3sEwjrYtT7frRfF33AyDUCfArVKCpwPzXatSfE
	TOfj6aN9vPq01W18wOKK9b3NSw9lPdMWq22IwjGwXMr2MtfxaXnL1bKOMHOhdgHfPiF8WpoZLBn
	CD0YdOgHA2zdvGcSBrnTb2DxNyKnDKYxNWE8VcQbIsVyPxlhmacfAXgT2hIwbqTvzlDU3sHhTkr
	W8T+mfRtS38/2Lmv1yDpXYMiGqHBnSfWd9spAe9PL+FL0YvuCrb+symRx2/Rav+KaNXsZ9KSMUf
	hQOH3sGtwRbL7jb85m3uVawJtxzEVwlgukoeqDnNzswkhqyxfY4kZOF/FK4KBOwIFkCOW9322tb
	Whbln3Aul89s+odCZNwwdD66qTkPIoFi5WC3GAk4G4DsNQxDr9+f6X9yQKEdt6edaNieDbQF1
X-Google-Smtp-Source: AGHT+IFWUM8M1ibARXhEFARO1mT+zMKXrvz2A4pt6E5SzmTi49bHhj59WAhb7O4mOr5cDWAAji3j3Q==
X-Received: by 2002:aa7:c403:0:b0:634:9e1c:ded1 with SMTP id 4fb4d7f45d1cf-6349fa8df1bmr645191a12.25.1758750292527;
        Wed, 24 Sep 2025 14:44:52 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a364fedesm119731a12.14.2025.09.24.14.44.51
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 14:44:52 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-631787faf35so489610a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 14:44:51 -0700 (PDT)
X-Received: by 2002:a17:907:3d9e:b0:b2d:830a:8c17 with SMTP id
 a640c23a62f3a-b34bd068ecdmr129037066b.56.1758750290992; Wed, 24 Sep 2025
 14:44:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924201822.9138-1-ebiggers@kernel.org>
In-Reply-To: <20250924201822.9138-1-ebiggers@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Sep 2025 14:44:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wivFdqXAytf0Hv4GQ9FgD1hGBMutrrbicgSZirX5qYR_A@mail.gmail.com>
X-Gm-Features: AS18NWBx1VupiFgf0uY-dl7iFrU4oMoZkrOXQfLP0z514sSYRpKr3DVixUA0aJI
Message-ID: <CAHk-=wivFdqXAytf0Hv4GQ9FgD1hGBMutrrbicgSZirX5qYR_A@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Sept 2025 at 13:19, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fix this by restoring the bool type.

Applied directly since the end is nigh.

          Linus
