Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF29C27B500
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749149108; cv=none; b=vGlu1W5X5TA7tjN1yWVBwk6E3Ov7fx1kZUYhBjndD9pVuIH+McZ8Po/3Ubnmr+HBeOv9Jmg2UvZQU7cu/zd/1XiuOoKaFA7NlncdXFK3qehn38edG7M70zy2VjL/igym60yf9/SSSF28XAnOfeo49ZXglNv/oJu37xu/XKYd6eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749149108; c=relaxed/simple;
	bh=cmvfFRYB1PFHOpI2SRC8mvuCC9FS1HQfcs9TNxWoB3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RcLQUn58k+mv1j15MgOyiBuUj+nB0F18PSIbPgRT4PUX/K2Mx6QLY/xdGmMnmAo8w/KlL33n1cZ92Ua3c97j6iChTIVxTqN+BUOriysS8YgOp1PlrHz+19dkIMK9XrS78xPiWOfRkK8PUlXl0VeiYoOSu8yq3ltMXFUpVqOaJLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B054zcIf; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B054zcIf"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d54bso2392868a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jun 2025 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749149105; x=1749753905; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9XTBJm/DbQyoJyugrERn5OxUzft8qC4Z3sD467xDNQ=;
        b=B054zcIfOnRelB00yKisGyNu3Pj3abFdbr3Qm5gH4ValHxHIH2f5IjSlFLbLWuPZ8e
         mUSZsCfTSZhkhFbWfZG+tYchyRvyLELKh1lIOklk3k8HK3BPrgzGviKF8HFTtWZREGi0
         AtUdW4KNtqqab8s5afi+/gKx/LGreqULxbQsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749149105; x=1749753905;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q9XTBJm/DbQyoJyugrERn5OxUzft8qC4Z3sD467xDNQ=;
        b=BnT9Yjo5kNHryY3PgqwTWjsrcMrKJeV8uHroMN9AOo6eyPUfqSmL/f6tliGJ1qK9da
         crU5piesrpni04dfDH3eULhGqzTJIeWH12d1YmDHqJRLiecWOti9+Yy5AoQy4iaV6+n9
         Z5iz0X2OAVzefQr/1WuWNbZ527ZeN/ZyR2AMKM1uT8UDIwJ15uRFZLbQJrAyWSaAdPDY
         b4KSyJ6CHgwgY2tY3I4sxrgrTD+wo7OEKPNKkuWnRDuH6n0d+8WuYnUmCnzi8DM0ruxL
         7TBOKJa5A5NjdS/7jJH8rPBY9Z0Qe+ZS99dkJoHhWjTwhLOIKVDUWBXt7B0UbYIHXI9t
         vpZg==
X-Forwarded-Encrypted: i=1; AJvYcCUBQ6/xVjF7wxjQI6rUZqEPGkgERrzCxK8iwtfn0msMUqvuspzt3XpmaV33GkfcOV6YRengdeZsLTVr6zE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz7mMIBgKTKCved1K/lIG/I2awR+wB74ARALgej8PxpVOvL+w7
	8lSUBtx+yin3vHUxmcQfraBUiqWb2ejZYNVy96UngQ+ryPwczdtj0IxbLt2rkYL85klRZTLNPhA
	WZjmzg5M=
X-Gm-Gg: ASbGnctkT6gTKCZcY6vqTSQyxiOxQmbHdasl7e/PSO6EYQ6qwrALvNKaFxthj380JOP
	SzTZxl8Z94FGRLfzP1kTUwajZSbqfe/18Xa7dq7Md3gRCxozW7u+MCsMFxvPXXccx9UZjxWoy3B
	yUsHbdO/3JQYC50bmOrcdcQsoWWVhkT1LF4BzPFt0XT5s7oM8rqaQFt2t4e4pO9rpaU2cbwZv5y
	H3gTojNlifrr/IBBNWfhAJxFJIMINkoapbV3lhjJX2j25FYlmk07XiDg1olonnRD1AzcukpWpLb
	8PiLQTvTL4weubwl7+MXVE3kKTQroAjPPVy6Yxotq4h+yRbXzM5v9hv21gEYHNrIPEtL0KhwsDV
	fqMyq/dTxs5FG2IRa8VrQQdnxS3Ytd5mm1a/i
X-Google-Smtp-Source: AGHT+IG8rrbYv34vjD2j23csXI2SzW6eaZRgW8xrimOTqx9T5Q2oWN38gdwG4WTqnYVPtqOv+R4Y8A==
X-Received: by 2002:a05:6402:3552:b0:607:2e23:d9ff with SMTP id 4fb4d7f45d1cf-607740c2bccmr261369a12.9.1749149104956;
        Thu, 05 Jun 2025 11:45:04 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-605673731dasm10621962a12.81.2025.06.05.11.45.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 11:45:03 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d54bso2392808a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jun 2025 11:45:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUvOV/j7x4GncwSVhcc8Ss5ZrhLZtjzQ7chdeYgPsv+5QlZ2j5AppYT07jQxN4H7VMEQgOmPbAj/iGIlC8=@vger.kernel.org
X-Received: by 2002:a05:6402:40c6:b0:602:e002:97b0 with SMTP id
 4fb4d7f45d1cf-607743a644cmr266621a12.18.1749149103123; Thu, 05 Jun 2025
 11:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605171156.2383-1-ebiggers@kernel.org> <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
 <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com>
In-Reply-To: <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jun 2025 11:44:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgd_4xrpXLUH1CGgGL=SXj0vq=XdJGGg388Exkti2Dg5Q@mail.gmail.com>
X-Gm-Features: AX0GCFsYM6S2PiHlmu7TlOVOIi2ktim4C4IM1PCtSKH5LTCkvkdZGrga_vDPEBM
Message-ID: <CAHk-=wgd_4xrpXLUH1CGgGL=SXj0vq=XdJGGg388Exkti2Dg5Q@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for crypto library
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Should I just add you and Jason directly as 'M:' entries for this?

                 Linus
