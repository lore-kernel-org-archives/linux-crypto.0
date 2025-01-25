Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0FA1DC745;
	Sat, 25 Jan 2025 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737803698; cv=none; b=dMS8O8tN3DHbFVJkvhqf3/XgMhFqsXG0Yuz4vyUeXoScU6C0oXCrlHqZ+xK+DbY48ge8kAZPtSdqI1KWEqJMsGnS4TubFtqPkoFAocDcs2HzLcTkLB20SMvlXDxKy5rndnf+SaX2BLyfL/5lhYIo1oVIVNoXJqjmc0o5Cq0LAc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737803698; c=relaxed/simple;
	bh=Sep3632jZbCvmggc154gHaJqDJBdLEK8UGq+FlPa4lo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9Okw65MSmM7mD0otIUy3XpNpowBsY6Nk3MEG7jiy2iR6j4EWExJ0uYfOoZovn33I5IjmV3Ecd1MHK1qlnKA0tXzm3oabKykc8EwZut4nCthYbRcRdGKh92C6kOGQAYXEFFiUbMy4ekFEOAjE668iGeP8uvy45PwKT9t7jYLY/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcg2EYSM; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcg2EYSM"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-385deda28b3so2111302f8f.0;
        Sat, 25 Jan 2025 03:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737803695; x=1738408495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF+h8/fEazDIA+ZyLYnsZgqKWixtRdrDOMUcSf2UUr0=;
        b=mcg2EYSMlh4ypCE1P5LbNHBZkzMwIa7n+p7zD+LiNiF9swau/L8uLADjS8LRfrLPhQ
         msKDbqzxr1uIMLNDwNWgKDl15dTREGLEqhTNA6qr+zI8uXmDq4Lqneiy6BySA9wC4Sty
         9QJXhgcYf99s1o+kaUcumbnlFiAOWm2G8IBW3HuumyOWlzo/K4KLws/bLbfGUf8c0UA6
         TAqQge1A2SQorn7bkW5ADso+X0hy/FtDrLifRpt8qLvgKb6bBzNuUkMWOeTpoFN2z3tC
         vIvlUsfmwHPhUXyYnaYtTbn0rswg5rbdEPBsBCpOnsIN4lgQDntQiU2h5JPVOO77xZbZ
         A7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737803695; x=1738408495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aF+h8/fEazDIA+ZyLYnsZgqKWixtRdrDOMUcSf2UUr0=;
        b=GNVloinSBR0dl78OAYZ6MjoBGLf6DG3tR1Vy0bkMzMN1OpF9OqAlY3m3nJGd7+eO18
         oIJfsfjPUB81ERaeOhUSpx1ArLaF/tnbF8VA8Iky9iHJ6EVTxoQ3AWUuiXL/wsvJ6OY+
         4Wt3Qzwjsh9FXW0nDmzmuuxaNpHMR1si3E0o4olNY96bUIayeLg+MtjrDNMF+tKQxt/f
         Jp2t03o3pYc9CyJGFxNUzKl2/p7GdA4mhxv1aE56NZUQ9gHyPxDWzpExvdpNCAtbn0X4
         ANg8Mr62RlzzuPZwmuPoHIYSGu99ekShjTVlOhaNzVOcKYi7XedZwnB2vMeI/MPDP+Xu
         eWDg==
X-Forwarded-Encrypted: i=1; AJvYcCVioe6qX6AvdkiWeFOZ+Jta7+c3lGUR2mwOOaHQXkQPYKK9q+Z6VAEh/tWHUbbwtcNZ1oizvfmnquKdEMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYxZBVSOxeutllqLyvBkKwYxvCslSeJ2seHEQLmy0D0Jbj67hp
	PFMYo3Sf85uGIJ7l1Z8p3mel2vk9Tn0xHHHmX2AsblXBhuauYIH+7VbVOA==
X-Gm-Gg: ASbGncuYieodN++AJE43wzkkWUg1bJqyXppQene8ncKkPC2bk3o4qkYwFjjZj8d5+Mf
	ldKLIvLB4fOQS0u42ZKPUQ5lGfeQuVz/EPmbI9w3hk2Hr6KLdMCb+WjUuoh+7uOnWZVNrc+13Q6
	PlHqGV9CileY4S40Z130QGOemnZ2TneEBLTVnHCseY9VaAj08ua/DAyB5FRJ0XAWjmBzt6BDUEE
	aACDZ0cNC8hibedA4mCW3YvhvB1ebbwxTM//uu0W6LHnqG5WP/ApH3Gm4531jdc0gNgixTXK5KT
	tYeK6TGl7su4nFaFxyhIg95OhbjeHI1XFqFa7Ab1zU4=
X-Google-Smtp-Source: AGHT+IEM9mAV1tTssWlOUFDafaoIJIaBbHkGqS0a5Rhp3uin03opAIRNomXqn7F+faWNeu5HBwxdSg==
X-Received: by 2002:a5d:47c9:0:b0:386:416b:9c69 with SMTP id ffacd0b85a97d-38bf5662912mr35311968f8f.16.1737803695434;
        Sat, 25 Jan 2025 03:14:55 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c4006sm5337410f8f.94.2025.01.25.03.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 03:14:55 -0800 (PST)
Date: Sat, 25 Jan 2025 11:14:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, Ard
 Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Kent
 Overstreet <kent.overstreet@linux.dev>, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Theodore Ts'o <tytso@mit.edu>, Vinicius Peixoto <vpeixoto@lkcamp.dev>,
 WangYuli <wangyuli@uniontech.com>
Subject: Re: [PATCH 2/2] lib/crc32: remove other generic implementations
Message-ID: <20250125111453.26e33854@pumpkin>
In-Reply-To: <20250123212904.118683-3-ebiggers@kernel.org>
References: <20250123212904.118683-1-ebiggers@kernel.org>
	<20250123212904.118683-3-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jan 2025 13:29:04 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Now that we've standardized on the byte-by-byte implementation of CRC32
> as the only generic implementation (see previous commit for the
> rationale), remove the code for the other implementations.

Some of that deleted code is disgusting - well disposed of.

	David
